package Pval::User;

use strict;
use warnings;
use v5.10;

use Dancer ':moose';
use Dancer::Plugin::DBIC;
use Data::UUID;
use Moose;
use Net::LDAP;

with 'Pval::Roles::DBRole';
with 'Pval::Roles::LDAPRole';

has username => (
    is => 'rw',
    isa => 'Str',
);

sub BUILD {
    my $self = shift;
    my $db = schema 'default';
    my $ug = Data::UUID->new;

    $self->updates([ qw/entryUUID active alumni housingPoints onfloor roomNumber/ ]);

    $self->ldap_object($self->_fetch_from_ldap("uid=" . $self->username));
    my $dbic_object = $db->resultset('User')->search({ UUID => $ug->from_string($self->ldap_object->get_value('entryUUID')) })->first;

    unless (defined $dbic_object) {
        $dbic_object = $db->resultset('User')->new({ UUID => $ug->from_string($self->ldap_object->get_value('entryUUID')) });
        $self->insert_needed(1);
    }

    $self->dbic_object($dbic_object);
}

# Satisfies LDAPRole and DBRole requirements
sub commit {
}

__PACKAGE__->meta->make_immutable;

1;
