package Pval::Routes::Freshman::Utils;

use strict;
use warnings;
use v5.10;

use Dancer;
use Dancer::Plugin::Cache::CHI;
use Dancer::Plugin::DBIC;
use DateTime;
use DateTime::Duration;
use Pval::LDAP;
use Pval::Misc;

use base 'Exporter';
our @EXPORT = qw/
    freshmen_aggregates
    create_freshman
    freshman_dump
/;

sub freshmen_aggregates {
    my $year = shift // date_to_year;
    my $db = schema;
    my $dtf = schema->storage->datetime_parser;
    my @freshmen = $db->resultset('Freshman')->search({
        vote_date => {
            -between => [ map { $dtf->format_datetime($_) } year_to_dates $year ],
        },
    });

    return cache_page template_or_json {
        freshmen => [ map { $_->json } @freshmen ],
    }, 'freshmen/freshmen', request->content_type;
}

sub freshman_dump {
    my $year = shift // date_to_year;
    my $db = schema;
    my $dtf = schema->storage->datetime_parser;
    my @freshmen = $db->resultset('Freshman')->search({
        vote_date => {
            -between => [ map { $dtf->format_datetime($_) } year_to_dates $year ],
        },
    });

    return cache_page template_or_json({
            freshmen => \@freshmen,
        }, 'dump', request->content_type);
}

sub create_freshman {
    my $name = shift;
    my $now = DateTime->now( time_zone => 'America/New_York' );
    my $vote_date = $now->add( weeks => 10 );

    my $dtf = schema->storage->datetime_parser;
    my $db = schema;

    return $db->resultset('Freshman')->create({
        name => $name,
        vote_date => $dtf->format_datetime($vote_date),
        ten_week => $dtf->format_datetime($vote_date),
        timestamp => \'CURRENT_TIMESTAMP',
    });
}

1;
