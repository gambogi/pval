package Pval::Routes::Freshman::Utils;

use strict;
use warnings;
use v5.10;

use Dancer;
use Dancer::Plugin::Cache::CHI;
use Dancer::Plugin::DBIC;
use Pval::LDAP;
use Pval::Misc;

use base 'Exporter';
our @EXPORT = qw/
	freshmen_aggregates
/;

sub freshmen_aggregates {
    my $year = shift;
    my $db = schema;
    my $dtf = schema->storage->datetime_parser;

    my @freshmen = $db->resultset('Freshman')->search({
        vote_date => {
            -between => [ map { $dtf->format_datetime($_) } year_to_dates $year ],
        },
    });

    return cache_page template_or_json {
        freshmen => [ map { $_->json } @freshmen ],
    }, 'freshmen', request->content_type;
}
