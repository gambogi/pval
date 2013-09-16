package Pval::Schema::Result::Event;

use strict;
use warnings;
use v5.10;

use Moose;
use Pval::LDAP;

extends 'DBIx::Class::Core';

sub json {
    my $self = shift;
    my $deep = shift;

    my $event = {};
    my $ldap = Pval::LDAP->new;
    $event = $self->TO_JSON;

    if ($deep) {
        $event->{attendees} = [];
        foreach my $attendee ($self->attendees) {
            push $event->{attendees}, $attendee->json;
        }

        $event->{freshmen_attendees} = [];
        foreach my $attendee ($self->freshmen_attendees) {
            push $event->{freshmen_attendees}, $attendee->json;
        }
    }

    $event->{date} = $event->{date}->mdy;
    $event->{presenter} = $event->{presenter}->json;
    $event->{type} = $event->{type}->value;
    $event->{committee} = $ldap->uuid_to_committee($event->{committee})->get('cn')->[0];

    return $event;
}

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
        size => 37,
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

__PACKAGE__->has_many('freshmen_event_attendee' => 'Pval::Schema::Result::FreshmenEventAttendee', 'event');
__PACKAGE__->many_to_many('freshmen_attendees' => 'freshmen_event_attendee', 'attendee');

1;
