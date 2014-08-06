package Pval::Routes::MajorProject::Utils;

use strict;
use warnings;
use v5.10;

use Dancer ':syntax';
use Dancer::Plugin::Cache::CHI;
use Dancer::Plugin::DBIC;
use Pval::LDAP;
use Pval::Misc;
use Try::Tiny;

use base 'Exporter';
our @EXPORT = qw/
    aggregate_projects
/;

sub aggregate_projects {
    my $incoming = shift;
    my $year = shift;
    my $db = schema;
    my $dtf = schema->storage->datetime_parser;

    my @projects = $db->resultset('MajorProject')->search({
            %$incoming,
            date => {
                -between => [ map { $dtf->format_datetime($_) } year_to_dates $year ],
            },
        }, { prefetch => 'submitter' });

    return cache_page template_or_json({
            projects => [ map { $_->json } @projects ]
        }, 'user_project', request->content_type);
}

1;
