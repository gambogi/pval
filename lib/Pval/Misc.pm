package Pval::Misc;

use strict;
use warnings;
use v5.10;

use Dancer ':syntax';
use DateTime;

use base 'Exporter';
use constant MIN_MONTH => 8;
use constant MAX_MONTH => 6;

our @EXPORT = qw/template_or_json year_to_dates date_to_year valid_year/;

sub template_or_json {
    my ($data, $template, $content_type) = @_;

    if ($content_type eq "application/json") {
        return to_json $data;
    } else {
        return template $template, $data;
    }
}

sub date_to_year {
    my $date = shift // DateTime->now;
    my $year = $date->year;
    my $month = $date->month;

    if ($month < MAX_MONTH) {
        $year -= 1;
    }

    return $year;
}

sub year_to_dates {
    my $year = shift // DateTime->now->year;

    return (DateTime->new({ year => $year, month => MIN_MONTH, day => 1 }),
        DateTime->new({ year => $year + 1, month => MAX_MONTH, day => 1 }));
}

sub valid_year {
    (shift // DateTime->now->year) =~ /^20\d{2}$/;
}

1;
