package Pval::Database::Schema::Result::EventAttendee;

use base qw/DBIx::Class::Core/;
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

__PACKAGE__->belongs_to('attendee' => 'Pval::Database::Schema::Result::User');
__PACKAGE__->belongs_to('event' => 'Pval::Database::Schema::Result::Event');

1;
