package Pval::Routes::MajorProject;

use strict;
use warnings;
use v5.10;

use Dancer ':syntax';
use Dancer::Plugin::Cache::CHI;
use Dancer::Plugin::DBIC;
use Pval::LDAP;
use Pval::Misc;
use Try::Tiny;

prefix '/projects';
check_page_cache;

get '/' => sub {
    my $db = schema;
    my @projects = $db->resultset('MajorProject')->search;

    return cache_page template_or_json({
        projects => [ map { $_->json } @projects ]
    }, 'user_project', request->content_type);
};

get '/incoming' => sub {
    my $db = schema;
    my @projects;

    @projects = $db->resultset('MajorProject')->search({
        status => 'pending'
    }, { prefetch => 'submitter', });

    return cache_page template_or_json({
        projects => [ map { $_->json } @projects ]
    }, 'user_project', request->content_type);
};

get '/:id' => sub {
    my $id  = param 'id';
    my $db = schema;
    my $project = undef;

    try {
        $project = $db->resultset('MajorProject')->find({ id => $id });
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
