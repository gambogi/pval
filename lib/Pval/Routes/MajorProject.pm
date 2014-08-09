package Pval::Routes::MajorProject;

use strict;
use warnings;
use v5.10;

use Dancer ':syntax';
use Dancer::Plugin::Cache::CHI;
use Dancer::Plugin::DBIC;
use Pval::LDAP;
use Pval::Misc;
use Pval::Routes::MajorProject::Utils;
use Try::Tiny;

prefix '/projects';
check_page_cache;

get '/' => sub {
    return aggregate_projects {};
};

get '/:result' => sub {
    pass unless param('result') ~~ [ qw/pending passed failed/ ];
    return aggregate_projects { status => param 'result' };
};

get '/year/:year' => sub {
    return {
        error => 'Invalid year '.param 'year'
    }, 'error', request->content_type unless valid_year param 'year';
    return aggregate_projects {}, param 'year';
};

get '/year/:year/:result' => sub {
    return {
        error => 'Invalid year '.param 'year'
    }, 'error', request->content_type unless valid_year param 'year';

    return aggregate_projects (
        {status => param 'result'},
        param 'year'
    );
};

post '/create' => sub {
    my $db = schema;
    my $user = Pval::LDAP->new->uid_to_uuid(
        request->header('x-webauth-user')
    );
    die "Could not find $user in LDAP." unless $user;
    $db->resultset('MajorProject')->update_or_create({
            name => request->header('name'),
            description => request->header('description'),
            submitter => $user,
            committee => request->header('committee'),
            status => 'pending',
        });
};

post '/vote/:result/:id' => sub {
    my $db = schema;
    pass unless param('result') ~~ [ qw/pending passed failed/ ];
    return $db->resultset('MajorProject')->update({
            id => param 'id',
            status => param 'result',
        });
};


get '/:id' => sub {
    pass unless param('id') =~ /^\d+$/;

    my $id  = param 'id';
    my $db = schema;
    my $project = undef;

    try {
        $project = $db->resultset('MajorProject')->find({
                id => $id 
            }, { prefetch => 'submitter' });
    };

    if (defined $project) {
        return template_or_json({
            project => $project->json,
        }, 'project', request->content_type);
    } else {
        return cache_page template_or_json({
            error => "Cannot find project with id $id"
        }, 'error', request->content_type);
    }
};

get '/user/:user' => sub {
    my $user = param 'user';
    my $db = schema;
    my $ldap = Pval::LDAP->new;
    my $ldap_user = undef;
    my @projects;

    try {
        $ldap_user = $ldap->find_user($user);
    };

    unless (defined $ldap_user) {
        return template_or_json({
            error => "Cannot find user $user"
        }, 'error', request->content_type);
    }

    @projects = $db->resultset('MajorProject')->search({
        'submitter.UUID' => $ldap_user->get('entryUUID')
    }, {
        join => 'submitter',
    });

    return cache_page template_or_json({
        projects => [ map { $_->json } @projects ],
    }, 'user_project', request->content_type);
};

1;
