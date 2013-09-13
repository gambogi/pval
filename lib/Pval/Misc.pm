package Pval::Misc;

use strict;
use warnings;
use v5.10;

use Dancer ':syntax';
use base 'Exporter';

our @EXPORT = qw/template_or_json/;

sub template_or_json {
    my ($data, $template, $content_type) = @_;

    if ($content_type eq "application/json") {
        return to_json $data;
    } else {
        return template $template, $data;
    }
}

1;
