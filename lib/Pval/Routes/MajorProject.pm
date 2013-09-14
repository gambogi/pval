package Pval::Routes::MajorProject;

use strict;
use warnings;
use v5.10;

use Dancer ':syntax';
use Dancer::Plugin::Cache::CHI;
use Dancer::Plugin::DBIC;
use Pval::LDAP;
use Pval::Misc;
use Pval::Routes::User qw/user_to_hash/;
use Pval::Schema;
use Try::Tiny;

prefix '/projects';
check_page_cache;

sub project_to_json {
    my $project = shift;

    my $ldap = Pval::LDAP->new;
    my $user = user_to_hash($ldap->uuid_to_user($project->submitter->UUID));
    $project = $project->TO_JSON;

    $project->{committee} = $ldap->uuid_to_committee($project->{committee})->get('cn')->[0];
    $project->{submitter} = $user;
    $project->{status} = $project->{status}->value;
    $project->{date} = $project->{date}->datetime;

    return $project;
}

get '/' => sub {
    my $db = schema;
    my $ldap = Pval::LDAP->new;
    my @projects = $db->resultset('MajorProject')->all;

    foreach my $project (@projects) {
        $project = project_to_json $project;
    }

    return cache_page template_or_json({
        projects => [ (@projects) ]
    }, 'user_project', request->content_type);
};

get '/incoming' => sub {
    my $db = schema;
    my $ldap = Pval::LDAP->new;
    my @projects;

    @projects = $db->resultset('MajorProject')->search({
        status => 'pending'
    }, { prefetch => 'submitter', });

    foreach my $project (@projects) {
        $project = project_to_json $project;
    }

    return cache_page template_or_json({
        projects => [ (@projects) ]
    }, 'user_project', request->content_type);
};

get '/:id' => sub {
    my $id  = param 'id';
    my $db = schema;
    my $project = undef;
    my $ldap = Pval::LDAP->new;

    try {
        $project = $db->resultset('MajorProject')->find({ id => $id });
    };

    if (defined $project) {
        $project = project_to_json $project;
        return template_or_json({
            project => $project,
            user => user_to_hash($ldap->uuid_to_user($project->submitter->UUID)),
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

    foreach my $project (@projects) {
        $project = project_to_json $project;
    }

    return cache_page template_or_json({
        projects => [ (@projects) ],
        user => user_to_hash($ldap->uuid_to_user($ldap_user->get('entryUUID'))),
    }, 'user_project', request->content_type);
};

1;
