package Pval;

use strict;
use warnings;
use v5.10;

use Dancer ':moose';
use Dancer::Plugin::DBIC;

our $VERSION = '0.1';

use Data::Dumper;
use Data::UUID;
use DateTime;
use Pval::Freshman;
use Pval::User;

get '/' => sub {
    my $user = Pval::Freshman->new({ name => 'William Orr' });

    template 'personal_application', {
        user => $user,
    };
};

1;
