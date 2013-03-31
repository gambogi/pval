package Pval::Freshman;

use strict;
use warnings;
use v5.10;

use Dancer ':moose';
use Dancer::Plugin::DBIC;
use DateTime;
use Moose;

with 'Pval::Roles::DBRole';

sub commit {}

has ten_week => (
    is => 'rw',
    isa => 'DateTime',
);

has vote_date => (
    is => 'rw',
    isa => 'DateTime',
);

has name => (
    is => 'rw',
    isa => 'Str',
);

sub BUILD {
    my $self = shift;
    my $db = schema 'default';

    my $dbic_object = $db->resultset('Freshman')->search({ name => $self->name });

    unless (not $dbic_object) {
        if (not defined $self->vote_date or not defined $self->ten_week) {
            $self = undef;
            return;
        }

        my $user = $db->resultset('User')->new({});
        $dbic_object = $db->resultset('Freshman')->new({ 
            name => $self->name, 
            user => $user, 
            vote_date => $self->vote_date,
            ten_week => $self->ten_week,
        });
        $self->insert_needed(1);
    }

    $self->dbic_object($dbic_object);
}

__PACKAGE__->meta->make_immutable;

1;
