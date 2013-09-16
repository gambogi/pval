package Pval::Schema::Result::User;

use strict;
use warnings;
use v5.10;

use Moose;
use Net::LDAP::Entry;
use Pval::LDAP;

extends 'DBIx::Class::Core';
with 'Pval::Roles::JSON';

has ldap_entry => (
    is => 'rw',
    isa => 'Net::LDAP::Entry',
    lazy => 1,
    builder => '_build_ldap_entry',
);

sub _build_ldap_entry {
    my $self = shift;
    my $ldap = Pval::LDAP->new;

    $ldap->uuid_to_user($self->UUID);
}

sub json {
    my $self = shift;
    my $ldap = Pval::LDAP->new;
    return $ldap->ldap_to_json($self->ldap_entry);
}

__PACKAGE__->table('users');
__PACKAGE__->load_components(qw/InflateColumn::DateTime Helper::Row::ToJSON/);
__PACKAGE__->add_columns(
    'id' => {
        data_type => 'integer',
        size => 16,
        is_nullable => 0,
        is_auto_increment => 1,
    },
    'UUID' => {
        data_type => 'varchar',
        size => 37,
        is_nullable => 0,
    },
    'freshman' => {
        data_type => 'integer',
        size => 16,
        is_nullable => 1,
    },
    'timestamp' => {
        data_type => 'timestamp',
        default_value => \'CURRENT_TIMESTAMP',
    },
);

__PACKAGE__->set_primary_key('id');
__PACKAGE__->belongs_to('freshman' => 'Pval::Schema::Result::Freshman');
__PACKAGE__->has_many('packet_missing_signatures' => 'Pval::Schema::Result::PacketMissingSignature', 'missing_signature');
__PACKAGE__->many_to_many('packets' => 'packet_missing_signatures', 'packet');
__PACKAGE__->has_many('event_attendee' => 'Pval::Schema::Result::EventAttendee', 'attendee');
__PACKAGE__->many_to_many('events' => 'event_attendee', 'event');
__PACKAGE__->has_many('projects' => 'Pval::Schema::Result::MajorProject', 'submitter');
__PACKAGE__->has_many('spring_evals' => 'Pval::Schema::Result::SpringEval', 'user');
__PACKAGE__->has_many('winter_evals' => 'Pval::Schema::Result::WinterEval', 'user');
__PACKAGE__->has_many('rosters' => 'Pval::Schema::Result::Roster', 'user');

sub sqlt_deploy_hook {
    my ($self, $sqlt_table) = @_;

    $sqlt_table->add_index(name => 'user_uuid_idx', fields => ['UUID']);
}

1;
