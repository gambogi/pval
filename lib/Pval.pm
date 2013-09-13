package Pval;

use strict;
use warnings;
use v5.10;

our $VERSION = '0.1';

use Dancer;
use Dancer::Plugin::DBIC;
use DateTime;
use Pval::LDAP;

# Other routes
use Pval::User;

prefix undef;

get '/' => sub {
    my $db = schema 'default';

    my $user = Pval::LDAP->new->get_eval_director;
    template 'index', {
        user => $user->[0],
    };
};

1;
