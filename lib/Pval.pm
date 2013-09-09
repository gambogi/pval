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
use Pval::Database::Schema;
use Pval::Freshman;
use Pval::User;

get '/' => sub {
    #my $db = schema 'default';
    #$db->deploy;

    my $user = Pval::Freshman->new({ name => 'William Orr' });
    $user->commit;
    template 'index', {
        user => Dumper($user->dbic_object->user)
    };
};

1;
