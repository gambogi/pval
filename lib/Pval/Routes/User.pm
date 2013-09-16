package Pval::Routes::User;

use strict;
use warnings;
use v5.10;

use Dancer ':syntax';
use Dancer::Plugin::DBIC;
use Dancer::Plugin::Cache::CHI;
use Pval::LDAP;
use Pval::Misc;
use Try::Tiny;

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

    my $db_user = $db->resultset('User')->find({ UUID => $ldap_user->get('entryUUID') });
    if ($db_user eq "0") {
        $db_user = $db->resultset('User')->create({ UUID => $ldap_user->get('entryUUID') })->single;
    }

    return $db_user->json;
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
        push $users, $ldap->ldap_to_json($active_user);
    }

    return cache_page template_or_json({
        users => $users,
    }, 'users', request->content_type);
};

1;
