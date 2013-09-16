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

get '/' => sub {
    my $db = schema;
    my @freshmen = $db->resultset('Freshman')->all;

    return cache_page template_or_json {
        freshmen => [ map { $_->json } @freshmen ],
    }, 'freshmen', request->content_type;
};

get '/:id' => sub {
    my $db = schema;
    my $freshman = $db->resultset('Freshman')->find({
        id => param 'id',
    }, {
        prefetch => [ qw/packets/ ],
    });

    return cache_page template_or_json {
        freshman => $freshman->json(1),
    }, 'freshman', request->content_type;
};

1;
