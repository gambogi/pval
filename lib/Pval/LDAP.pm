package Pval::LDAP;

use Cache::Memcached::Fast;
use Dancer;
use Dancer::Plugin::LDAP;
use Data::UUID;
use Moose;
use Net::LDAP::Entry;
use Pval::Schema::Result::User;

has memcached => (
    is => 'ro',
    isa => 'Cache::Memcached::Fast',
    default => sub {
        return Cache::Memcached::Fast->new({
            servers => [ qw/127.0.0.1:11211/ ],
        });
    },
    lazy => 1,
);

sub find_user {
    my $self = shift;
    my $username = shift;
    my $ug = Data::UUID->new;

    my $user = $self->_fetch_from_ldap("uid=$username", [ qw/uid cn entryUUID active alumni housingPoints onfloor roomNumber/ ]);
    die "Cannot find $username in LDAP" unless $user;
    return $user;
}

sub get_eval_director {
    my $self = shift;

    my $ret = $self->_fetch_from_ldap("cn=Evaulations", [ qw/head/ ], 'ou=Committees,dc=csh,dc=rit,dc=edu');
    die "Cannot find eval director in LDAP" unless $ret;
    map { s/uid=(\w+),ou=Users,dc=csh,dc=rit,dc=edu/$1/ } @{$ret->get("head")};
    return $ret->get("head");
}

sub _fetch_from_ldap {
    my ($self, $query, $attrs, $base) = @_;
    my $result;

    $base //= 'dc=csh,dc=rit,dc=edu';

    my $ret = $self->memcached->get($query);
    return $ret if defined $ret;

    $ret = ldap->search(
        base => $base,
        filter => $query,
        attrs => $attrs,
    )->entry(0);

    $self->memcached->set($query, $ret) if defined $ret;

    return $ret;
}

1;
