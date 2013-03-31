package Pval::Roles::LDAPRole;

use strict;
use warnings;
use v5.10;

use Cache::Memcached::Fast;
use Dancer ':moose';
use Dancer::Plugin::LDAP;
use Moose::Role;

requires 'commit';

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

has ldap_object => (
    is => 'rw',
    isa => 'Net::LDAP::Entry',
);

has updates => (
    is => 'rw',
    isa => 'ArrayRef',
);

sub _fetch_from_ldap {
    my ($self, $query) = @_;
    my $result;

    my $ret = $self->memcached->get($query);
    return $ret if defined $ret;

    $ret = ldap->search(base => 'dc=csh,dc=rit,dc=edu', filter => $query, attrs => $self->updates )->entry(0);
    $self->memcached->set($query, $ret);

    return $ret;
}

after commit => sub {
    my $self = shift;
    $self->ldap_object->update;
};

1;
