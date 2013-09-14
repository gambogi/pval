package Pval::Schema::Result::Event;

use strict;
use warnings;
use v5.10;

use Moose;

extends 'DBIx::Class::Core';
__PACKAGE__->load_components(qw/InflateColumn::DateTime InflateColumn::Object::Enum Helper::Row::ToJSON/);
__PACKAGE__->table('events');
__PACKAGE__->add_columns(
    id => {
        data_type => 'integer',
        size => 16,
        is_nullable => 0,
        is_auto_increment => 1,
    },
    name => {
        data_type => 'varchar',
        size => 1024,
        is_nullable => 0,
    },
    date => {
        data_type => 'datetime',
        is_nullable => 1,
        default => \'CURRENT_DATE',
    },
    presenter => {
        data_type => 'integer',
        size => 16,
        is_nullable => 1,
    },
    committee => {
        data_type => 'varchar',
        size => 32,
        is_nullable => 0,
    },
    type => {
        data_type => 'enum',
        is_enum => 1,
        extra => {
            list => [qw/technical social committee_meeting house_meeting/],
        },
    },
    timestamp => {
        data_type => 'timestamp',
        default => \'CURRENT_TIMESTAMP',
    },
);

__PACKAGE__->set_primary_key('id');
__PACKAGE__->belongs_to('presenter' => 'Pval::Schema::Result::User');
__PACKAGE__->has_many('event_attendee' => 'Pval::Schema::Result::EventAttendee', 'event');
__PACKAGE__->many_to_many('attendees' => 'event_attendee', 'attendee');

1;
