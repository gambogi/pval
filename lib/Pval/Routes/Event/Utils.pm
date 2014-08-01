package Pval::Routes::Event::Utils;

use strict;
use warnings;
use v5.10;

use Dancer ':syntax';
use Dancer::Plugin::Cache::CHI;
use Dancer::Plugin::DBIC;
use Pval::Misc;

use base 'Exporter';
our @EXPORT = qw/
	aggregate_routes
	single_routes
	committee_aggregate_routes
/;

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
    }, { prefetch => 'presenter' });

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
    }, { prefetch => 'presenter' });

    return cache_page template_or_json {
        meetings => [ map { $_->json } @meetings ],
        committee => param 'committee',
    }, 'meetings', request->content_type;
}

1;
