package Pval::Routes::Freshman;

use strict;
use warnings;
use v5.10;

use Dancer;
use Dancer::Plugin::Cache::CHI;
use Dancer::Plugin::DBIC;
use Pval::LDAP;
use Pval::Misc;
use Pval::Routes::Freshman::Utils;

prefix '/freshmen';
check_page_cache;

get '/' => sub {
    freshmen_aggregates;
};

get '/year/:year' => sub {
    return cache_page template_or_json {
        error => 'Invalid year '.param 'year'
    }, 'error', request->content_type unless valid_year param 'year';
    freshmen_aggregates param 'year';
};

post '/create' => sub {
    my %params = params;
    return create_freshman $params{name}, $params{vote_date};
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
