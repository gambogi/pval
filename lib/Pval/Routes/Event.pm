package Pval::Routes::Event;

use strict;
use warnings;
use v5.10;

use Dancer ':syntax';
use Dancer::Plugin::Cache::CHI;
use Dancer::Plugin::DBIC;
use Pval::Misc;
use Pval::Routes::Event::Utils;

check_page_cache;

get '/house/meetings' => sub {
    return aggregate_routes 'house_meeting';
};

get '/meetings/house' => sub {
    return aggregate_routes 'house_meeting';
};

get '/meetings/house/year/:year' => sub {
    return aggregate_routes 'house_meeting', param 'year';
};

get '/meetings/house/:id' => sub {
    return single_routes 'house_meeting', param 'id';
};

get '/meetings/:committee' => sub {
    return committee_aggregate_routes param 'committee';
};

get '/meetings/:committee/year/:year' => sub {
    return committee_aggregate_routes param 'committee', param 'year';
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
    }, { prefetch => 'presenter' })->single;

    unless ($meeting) {
        return cache_page template_or_json {
            error => "Can't find meeting with id ".param('id'),
        }, 'error', request->content_type;
    }

    return cache_page template_or_json {
        meeting => $meeting->json(1),
    }, 'meeting', request->content_type;
};

get '/seminars' => sub {
    return aggregate_routes 'events/seminars';
};

get '/seminars/year/:year' => sub {
    return aggregate_routes 'events/seminars', param 'year';
};

get '/seminars/:id' => sub {
    return single_routes 'events/seminar', param 'id';
};

get '/events' => sub {
    return aggregate_routes 'events/social_events';
};

get '/events/year/:year' => sub {
    return aggregate_routes 'events/social_events', param 'year';
};

get '/events/:id' => sub {
    return single_routes 'events/social_event', param 'id';
};

1;
