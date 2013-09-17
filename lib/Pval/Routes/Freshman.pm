package Pval::Routes::Freshman;

use strict;
use warnings;
use v5.10;

use Dancer;
use Dancer::Plugin::Cache::CHI;
use Dancer::Plugin::DBIC;
use Pval::LDAP;
use Pval::Misc;

prefix '/freshmen';
check_page_cache;

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

get '/' => sub {
    freshmen_aggregates;
};

get '/year/:year' => sub {
    return cache_page template_or_json {
        error => 'Invalid year '.param 'year'
    }, 'error', request->content_type unless valid_year param 'year';
    freshmen_aggregates param 'year';
};

get '/:id' => sub {
    my $db = schema;
    my $freshman = $db->resultset('Freshman')->find({
        id => param 'id',
    }, {
        prefetch => [ qw/packets conditionals/ ],
    });

    return cache_page template_or_json {
        freshman => $freshman->json(1),
    }, 'freshman', request->content_type;
};

1;
