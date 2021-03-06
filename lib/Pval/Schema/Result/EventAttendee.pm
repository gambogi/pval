package Pval::Schema::Result::EventAttendee;

use strict;
use warnings;
use v5.10;

use Moose;

extends 'DBIx::Class::Core';
__PACKAGE__->table('event_attendee');
__PACKAGE__->add_columns(
    'event' => {
        data_type => 'integer',
        size => 16,
        is_nullable => 0,
    },
    'attendee' => {
        data_type => 'integer',
        size => 16,
        is_nullable => 0,
    },
);

__PACKAGE__->belongs_to('attendee' => 'Pval::Schema::Result::User');
__PACKAGE__->belongs_to('event' => 'Pval::Schema::Result::Event');

1;
