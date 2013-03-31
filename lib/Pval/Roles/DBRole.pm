package Pval::Roles::DBRole;

use strict;
use warnings;
use v5.10;

use Dancer ':moose';
use Moose::Role;

requires 'commit';

has dbic_object => (
    is => 'rw',
    isa => 'DBIx::Class::Core',
);

has 'insert_needed' => (
    is => 'rw',
    isa => 'Bool',
    default => 0,
);

after commit => sub {
    my $self = shift;
    unless ($self->insert_needed) {
        $self->dbic_object->update;
    } else {
        $self->dbic_object->insert;
    }
};

1;
