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

use Data::Dumper;

with 'Pval::Roles::DBRole';

sub commit {
    my $self = shift;
    $self->dbic_object->user->result_source->schema(schema 'default');
    if ($self->insert_needed) {
        $self->user->insert;
    } else {
        $self->user->update;
    }
}

sub BUILD {
    my $self = shift;
    my $args = shift;
    my $db = schema 'default';

    my $name = $args->{name};
    my $vote_date = $args->{vote_date};
    my $ten_week = $args->{ten_week};

    $self->db_methods([ qw/user name vote_date comments ten_week passed_freshman_project freshman_project_comments result timestamp/ ]);

    die "Need to provide name" unless $name;

    my $dbic_object = $db->resultset('Freshman')->search({ name => $name })->first;

    unless ($dbic_object) {
        die "Need vote_date and ten_week" unless ($vote_date and $ten_week);

        my $user = $db->resultset('User')->new({});
        $dbic_object = $db->resultset('Freshman')->new({ 
            name => $name, 
            vote_date => $vote_date,
            ten_week => $ten_week,
        });

        # wtf dbic
        $dbic_object->user($user);
        $self->insert_needed(1);
    }

    # This is definitely a DBIx::Class bug
    $dbic_object->result_source->schema($db);

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

1;
