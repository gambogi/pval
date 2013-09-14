package Pval::User;

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

our @EXPORT_OK = qw/user_to_hash/;

sub user_to_hash {
    my ($ldap_user, $db_user) = @_;

    # wtf CSH
    return {
        uid => $ldap_user->get('uid')->[0],
        name => $ldap_user->get('cn')->[0],
        room => ($ldap_user->get('roomNumber') // [0])->[0],
        active => ($ldap_user->get('active') // [0])->[0],
        alumni => ($ldap_user->get('alimni') // [0])->[0],
        on_floor => ($ldap_user->get('onFloor') // [0])->[0],
        housing_points => ($ldap_user->get('housingPoints') // [0])->[0]
    };
}

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

    my $db_user = $db->resultset('User')->search({ UUID => $ldap_user->get('entryUUID') });
    if ($db_user eq "0") {
        $db->resultset('User')->create({ UUID => $ldap_user->get('entryUUID') });
    }

    return user_to_hash($ldap_user, $db_user);
}

## Routes

prefix '/users';
check_page_cache;

get '/:name' => sub {
    my $name = param 'name';

    my $user = get_user_hash($name);
    unless (defined $user) {
        return template_or_json({
            error => "Cannot find user $name"
        }, 'error', request->content_type);
    }

    return cache_page template_or_json({
        user => $user
    }, 'user', request->content_type);
};

get '/' => sub {
    my $ldap = Pval::LDAP->new;
    my $active = $ldap->get_active_users;
    my $db = schema;
    my $users = [];

    foreach my $active_user (@$active) {
        my $db_user = $db->resultset('User')->search({ UUID=> $active_user->get('entryUUID') });
        push $users, user_to_hash($active_user, $db_user);
    }

    return cache_page template_or_json({
        users => $users,
    }, 'users', request->content_type);
};

1;
