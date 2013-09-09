package Pval::User;

use strict;
use warnings;
use v5.10;

use Dancer ':moose';
use Dancer::Plugin::DBIC;
use Data::UUID;
use Moose;

with 'Pval::Roles::DBRole';
with 'Pval::Roles::LDAPRole';

# Satisfies LDAPRole and DBRole requirements
sub commit {
    my $self = shift;
    $self->dbic_object->freshman->update if $self->dbic_object->freshman;
}

has username => (
    is => 'rw',
    isa => 'Str',
);

sub BUILD {
    my $self = shift;
    my $db = schema 'default';
    my $ug = Data::UUID->new;

    $self->updates([ qw/entryUUID active alumni housingPoints onfloor roomNumber/ ]);
    $self->db_methods([ qw/UUID freshman/ ]);

    $self->ldap_object($self->_fetch_from_ldap("uid=" . $self->username));
    my $dbic_object = $db->resultset('User')->search({ UUID => $ug->from_string($self->ldap_object->get_value('entryUUID')) })->first;

    unless ($dbic_object) {
        $dbic_object = $db->resultset('User')->new({});
        $dbic_object->UUID($ug->from_string($self->ldap_object->get_value('entryUUID')));
        $self->insert_needed(1);
    }

    $dbic_object->result_source->schema($db);
    $self->dbic_object($dbic_object);
}

1;
