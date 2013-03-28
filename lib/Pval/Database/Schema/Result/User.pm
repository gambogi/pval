package Pval::Database::Schema::Result::User;

use base qw/DBIx::Class::Core/;
__PACKAGE__->table('users');
__PACKAGE__->add_columns(
    'id' => {
        data_type => 'integer',
        size => 16,
        is_nullable => 0,
        is_auto_increment => 1,
    },
    'UUID' => {
        data_type => 'binary',
        size => 16,
        is_nullable => 1,
    },
    'freshman' => {
        data_type => 'integer',
        size => 16,
        is_nullable => 1,
    },
    'timestamp' => {
        data_type => 'timestamp',
    },
);

__PACKAGE__->set_primary_key('id');
__PACKAGE__->belongs_to('freshman' => 'Pval::Database::Schema::Result::Freshman');
__PACKAGE__->has_many('packet_missing_signatures' => 'Pval::Database::Schema::Result::PacketMissingSignature', 'missing_signature');
__PACKAGE__->many_to_many('packets' => 'packet_missing_signatures', 'packet');
__PACKAGE__->has_many('event_attendee' => 'Pval::Database::Schema::Result::EventAttendee', 'attendee');
__PACKAGE__->many_to_many('events' => 'event_attendee', 'event');
__PACKAGE__->has_many('projects' => 'Pval::Database::Schema::Result::MajorProject', 'submitter');
__PACKAGE__->has_many('spring_evals' => 'Pval::Database::Schema::Result::SpringEval', 'user');
__PACKAGE__->has_many('winter_evals' => 'Pval::Database::Schema::Result::WinterEval', 'user');
__PACKAGE__->has_many('rosters' => 'Pval::Database::Schema::Result::Roster', 'user');

1;
