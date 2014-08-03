package Pval::Routes::User;

use strict;
use warnings;
use v5.10;

use Dancer ':syntax';
use Dancer::Plugin::DBIC;
use Dancer::Plugin::Cache::CHI;
use Pval::LDAP;
use Pval::Misc;
use Pval::Routes::User::Utils;
use Try::Tiny;

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
