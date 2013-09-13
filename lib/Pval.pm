package Pval;

use strict;
use warnings;
use v5.10;

use Dancer;
use Dancer::Plugin::DBIC;

our $VERSION = '0.1';

use Data::UUID;
use DateTime;
use Pval::LDAP;
use Pval::Schema;
use Pval::Schema::Result::Freshman;
use Pval::Schema::Result::User;

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
