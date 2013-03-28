package Pval::Database::Schema::Result::Event;

use base qw/DBIx::Class::Core/;
__PACKAGE__->load_components(qw/InflateColumn::Object::Enum InflateColumn::DateTime/);
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
    },
    presenter => {
        data_type => 'integer',
        size => 16,
        is_nullable => 1,
    },
    committee => {
        data_type => 'binary',
        size => 16,
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
    },
);

__PACKAGE__->set_primary_key('id');
__PACKAGE__->belongs_to('presenter' => 'Pval::Database::Schema::Result::User');
__PACKAGE__->has_many('event_attendee' => 'Pval::Database::Schema::Result::EventAttendee', 'event');
__PACKAGE__->many_to_many('attendees' => 'event_attendee', 'attendee');

1;
