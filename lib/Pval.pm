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
    #$db->deploy;

    #my $freshie = $db->resultset('Freshman')->create({ name => 'Will Orr', vote_date => DateTime->now, ten_week => DateTime->now });
    #$freshie->insert;
    #$freshie->create_account("worr");
    #$freshie->add_packet(DateTime->now, DateTime->now);
    #my $packet = $freshie->get_latest_packet;
    my $user = Pval::LDAP->new->get_eval_director;

    template 'index', {
        user => $user->[0],
    };
};

1;
