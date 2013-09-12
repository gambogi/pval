package Pval::User;

use strict;
use warnings;
use v5.10;

use Dancer;
use Dancer::Plugin::DBIC;
use Pval::LDAP;
use Pval::Schema;
use Pval::Misc;
use Try::Tiny;

prefix '/users';

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

    # This is the only optional LDAP attribute
    my $roomnumber = $ldap_user->get('roomNumber');
    $roomnumber //= [ 0 ];

    my $user = {
        uid => $ldap_user->get('uid')->[0],
        name => $ldap_user->get('cn')->[0],
        room => $roomnumber->[0],
        active => $ldap_user->get('active')->[0],
        alumni => $ldap_user->get('alumni')->[0],
        on_floor => $ldap_user->get('onfloor')->[0],
        housing_points => $ldap_user->get('housingPoints')->[0],
    };

    return $user;
}

get '/:name' => sub {
    my $name = param 'name';

    my $user = get_user_hash($name);
    unless (defined $user) {
        return template_or_json({
            error => "Cannot find user $name"
        }, 'error', request->content_type);
    }

    return template_or_json({
        user => $user
    }, 'user', request->content_type);
};

1;
