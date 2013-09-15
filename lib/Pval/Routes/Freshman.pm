package Pval::Routes::Freshman;

use strict;
use warnings;
use v5.10;

use Dancer;
use Dancer::Plugin::Cache::CHI;
use Dancer::Plugin::DBIC;
use Pval::Misc;

prefix '/freshmen';
check_page_cache;

sub freshman_to_json {
    my $freshman = shift;

    $freshman = $freshman->TO_JSON;
    $freshman->{ten_week} = $freshman->{ten_week}->mdy;
    $freshman->{vote_date} = $freshman->{vote_date}->mdy;
    $freshman->{result} = $freshman->{result}->value;

    return $freshman;
}

get '/' => sub {
    my $db = schema;
    my @freshmen = $db->resultset('Freshman')->all;

    foreach my $freshman (@freshmen) {
        $freshman = freshman_to_json $freshman;
    }

    return cache_page template_or_json {
        freshmen => [ (@freshmen) ],
    }, 'freshmen', request->content_type;
};

1;
