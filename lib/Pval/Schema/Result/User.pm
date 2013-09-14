package Pval::Schema::Result::User;

use strict;
use warnings;
use v5.10;

use Dancer ':moose';
use Dancer::Plugin::DBIC;
use Data::UUID;
use DateTime;
use Moose;
use Net::LDAP::Entry;

extends 'DBIx::Class::Core';

__PACKAGE__->table('users');
__PACKAGE__->add_columns(
    'id' => {
        data_type => 'integer',
        size => 16,
        is_nullable => 0,
        is_auto_increment => 1,
    },
    'UUID' => {
        data_type => 'varchar',
        size => 32,
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

1;
