package Pval::Routes::Event;

use strict;
use warnings;
use v5.10;

use Dancer ':syntax';
use Dancer::Plugin::Cache::CHI;
use Dancer::Plugin::DBIC;
use Pval::Misc;

check_page_cache;

sub aggregate_routes {
    my ($type, $year) = @_;
    my $db = schema;
    my $dtf = schema->storage->datetime_parser;

    unless (valid_year $year) {
        return cache_page template_or_json {
            error => "Invalid year $year"
        }, 'error', request->content_type;
    }

    my @events = $db->resultset('Event')->search({
        type => $type,
        date => {
            -between => [ map { $dtf->format_datetime($_) } year_to_dates $year ],
        },
    });

    return cache_page template_or_json {
        meetings => [ map { $_->json } @events ],
    }, 'meetings', request->content_type;
}

sub single_routes {
    my ($type, $id) = @_;
    my $db = schema;

    my $event = $db->resultset('Event')->search({
        type => $type,
        id => $id,
    })->single;

    unless ($event) {
        return cache_page template_or_json {
            error => "Can't find social event with id $id",
        }, 'error', request->content_type;
    }

    return cache_page template_or_json {
        meeting => $event->json(1),
    }, 'meeting', request->content_type;

}

sub committee_aggregate_routes {
    my ($committee_name, $year) = @_;
    my $db = schema;
    my $ldap = Pval::LDAP->new;
    my $dtf = schema->storage->datetime_parser;

    unless (valid_year $year) {
        return cache_page template_or_json {
            error => "Invalid year $year"
        }, 'error', request->content_type;
    }

    my $committee = $ldap->committee_to_uuid($committee_name);
    unless (defined $committee) {
        return cache_page template_or_json {
            error => "Can't find $committee_name in LDAP",
        }, 'error', request->content_type;
    }

    my @meetings = $db->resultset('Event')->search({
        type => "meeting",
        committee => $committee,
        date => {
            -between => [ map { $dtf->format_datetime($_) } year_to_dates $year ],
        },
    });

    return cache_page template_or_json {
        meetings => [ map { $_->json } @meetings ],
        committee => param 'committee',
    }, 'meetings', request->content_type;
}

get '/meetings/house/' => sub {
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
    return aggregate_routes 'technical';
};

get '/seminars/year/:year' => sub {
    return aggregate_routes 'technical', param 'year';
};

get '/seminars/:id' => sub {
    return single_routes 'technical', param 'id';
};

get '/events/' => sub {
    return aggregate_routes 'social';
};

get '/events/year/:year' => sub {
    return aggregate_routes 'social', param 'year';
};

get '/events/:id' => sub {
    return single_routes 'social', param 'id';
};

1;
