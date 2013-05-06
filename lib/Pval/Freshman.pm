package Pval::Freshman;

use strict;
use warnings;
use v5.10;

use Dancer ':moose';
use Dancer::Plugin::DBIC;
use Data::UUID;
use DateTime;
use Moose;
use Pval::User;

with 'Pval::Roles::DBRole';

sub commit {
    my $self = shift;
    $self->dbic_object->user->update;
}

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

    my $dbic_object = $db->resultset('Freshman')->search({ name => $self->name })->first;

    unless ($dbic_object) {
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

sub create_account {
    my ($self, $uid) = @_;
    my $ug = Data::UUID->new;
    my $user = Pval::User->new({ username => $uid });

    $self->dbic_object->user->UUID($ug->from_string($user->ldap_object->get_value('entryUUID')));
    $self->commit;
}

sub add_packet {
    my $self = shift;
    my ($given, $due) = @_; 
    my $db = schema 'default';

    my $packet = $db->resultset('Packet')->new({ given => $given, due => $due, user => $self->dbic_object });
    $packet->insert;
}

sub get_latest_packet {
    my $self = shift;
    my $db = schema 'default';

    my @packet = @{$self->dbic_object->packets};
    return @packet;
}

sub missing_signatures {
    my ($self, $packet, $usernames) = @_;
    my $db = schema 'default';

    foreach my $username (@$usernames) {
        $packet->add_to_missing_signatures(Pval::User->new({ username => $username })->dbic_object);
    }

    $packet->update;
    $self->commit;
}

__PACKAGE__->meta->make_immutable;

1;