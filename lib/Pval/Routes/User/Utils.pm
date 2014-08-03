package Pval::Routes::User::Utils;

use strict;
use warnings;
use v5.10;

use Dancer ':syntax';
use Dancer::Plugin::DBIC;
use Dancer::Plugin::Cache::CHI;
use Pval::LDAP;
use Pval::Misc;
use Try::Tiny;

use base 'Exporter';
our @EXPORT = qw/
get_user_hash
/;

sub get_user_hash {
    my $name = shift;
    my $ldap = Pval::LDAP->new;
    my $db = schema;
    my $ldap_user;

    try {
        $ldap_user = $ldap->find_user($name);
    } catch {
        $ldap_user = undef;
    };

    # Try::Tiny doesn't let you return from catch blocks
    return $ldap_user unless defined $ldap_user;

    my $db_user = $db->resultset('User')->find_or_create({
            UUID => $ldap_user->get('entryUUID'),
        });

    if ($db_user eq "0") {
        $db_user = $db->resultset('User')->create({
                UUID => $ldap_user->get('entryUUID'),
            })->single;
    }

    return $db_user->json(1);
}

1;
