package Pval::Routes::Event;

use strict;
use warnings;
use v5.10;

use Dancer ':syntax';
use Dancer::Plugin::Cache::CHI;
use Dancer::Plugin::DBIC;
use Pval::Misc;

check_page_cache;

get '/meetings/house/' => sub {
    my $db = schema;

    # I don't like house meetings
    my @worthless_piles_of_shit = $db->resultset('Event')->search({
        type => 'house_meeting'
    });

    return cache_page template_or_json {
        meetings => [ map { $_->json } @worthless_piles_of_shit ],
    }, 'meetings', request->content_type;
};

get '/meetings/house/:id' => sub {
    my $db = schema;

    my $waste_of_time = $db->resultset('Event')->search({
        type => 'house_meeting',
        id => param 'id',
    })->single;

    unless ($waste_of_time) {
        return cache_page template_or_json {
            error => "Can't find house meeting id ".param 'id',
        }, 'error', request->content_type;
    }

    return cache_page template_or_json {
        meeting => $waste_of_time->json(1),
    }, 'meeting', request->content_type;
};

get '/meetings/:committee' => sub {
    my $db = schema;
    my $ldap = Pval::LDAP->new;

    my $committee = $ldap->committee_to_uuid(param 'committee');
    unless (defined $committee) {
        return cache_page template_or_json {
            error => "Can't find ".param('committee')." in LDAP",
        }, 'error', request->content_type;
    }

    my @meetings = $db->resultset('Event')->search({
        type => "meeting",
        committee => $committee,
    });

    return cache_page template_or_json {
        meetings => [ map { $_->json } @meetings ],
        committee => param 'committee',
    }, 'meetings', request->content_type;
};

get '/meetings/:committee/:id' => sub {
    my $db = schema;
    my $ldap = Pval::LDAP->new;

    my $committee = $ldap->committee_to_uuid(param 'committee');
    unless (defined $committee) {
        return cache_page template_or_json {
            error => "Can't find ".param('committee')." in LDAP",
        }, 'error', request->content_type;
    }

    my $meeting = $db->resultset('Event')->search({
        type => 'meeting',
        committee => $committee,
        id => param 'id',
    })->single;

    unless ($meeting) {
        return cache_page template_or_json {
            error => "Can't find meeting with id ".param('id'),
        }, 'error', request->content_type;
    }

    return cache_page template_or_json {
        meeting => $meeting->json(1),
    }, 'meeting', request->content_type;
};

get '/seminars/' => sub {
    my $db = schema;

    my @seminars = $db->resultset('Event')->search({ 
        type => 'technical'
    });

    return cache_page template_or_json {
        meetings => [ map { $_->json } @seminars ],
    }, 'meetings', request->content_type;
};

get '/seminars/:id' => sub {
    my $db = schema;

    my $seminar = $db->resultset('Event')->search({
        id => param 'id',
        type => 'technical',
    })->single;

    unless ($seminar) {
        return cache_page template_or_json {
            error => "Can't find seminar id ".param 'id',
        }, 'error', request->content_type;
    }

    return cache_page template_or_json {
        meeting => $seminar->json(1),
    }, 'meeting', request->content_type;
};

get '/events/' => sub {
    my $db = schema;

    my @social = $db->resultset('Event')->search({
        type => 'social'
    });

    return cache_page template_or_json {
        meetings => [ map { $_->json } @social ],
    }, 'meetings', request->content_type;
};

get '/events/:id' => sub {
    my $db = schema;

    my $social = $db->resultset('Event')->search({
        type => 'social',
        id => param 'id',
    })->single;

    unless ($social) {
        return cache_page template_or_json {
            error => "Can't find social event with id ".param 'id',
        }, 'error', request->content_type;
    }

    return cache_page template_or_json {
        meeting => $social->json(1),
    }, 'meeting', request->content_type;
};

1;
