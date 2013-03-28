package Pval;
use Dancer ':syntax';
use Dancer::Plugin::DBIC;

our $VERSION = '0.1';

use Pval::Database::Schema;

get '/' => sub {
    my $db = schema 'default';
    template 'index';
};

1;
