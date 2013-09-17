package Pval::Schema::Result::Conditional;

use strict;
use warnings;
use v5.10;

use Moose;

extends 'DBIx::Class::Core';
with 'Pval::Roles::JSON';

sub json {
    my $self = shift;
    my $conditional = $self->TO_JSON;

    if (defined $self->user) {
        $conditional->{user} = $self->user->json;
    }

    if (defined $self->freshman) {
        $conditional->{freshman} = $self->freshman->json;
    }

    $conditional->{created} = $conditional->{created}->mdy;
    $conditional->{deadline} = $conditional->{deadline}->mdy;
    $conditional->{status} = $conditional->{status}->value;

    return $conditional;
}

__PACKAGE__->load_components(qw/InflateColumn::DateTime InflateColumn::Object::Enum Helper::Row::ToJSON/);
__PACKAGE__->table('conditionals');
__PACKAGE__->add_columns(
    id => {
        data_type => 'integer',
        size => 16,
        is_auto_increment => 1,
        is_nullable => 0,
    },
    user => {
        data_type => 'integer',
        size => 16,
        is_nullable => 1,
    },
    freshman => {
        data_type => 'integer',
        size => 16,
        is_nullable => 1,
    },
    created => {
        data_type => 'date',
        is_nullable => 0,
        default => \'CURRENT_DATE',
    },
    status => {
        data_type => 'enum',
        is_enum => 1,
        extra => {
            list => [ qw/pending pass fail/ ],
        },
        default => 'pending',
    },
    deadline => {
        data_type => 'date',
        is_nullable => 0,
    },
    description => {
        data_type => 'varchar',
        size => 10240,
        is_nullable => 0,
        default_value => '',
    },
    timestamp => {
        data_type => 'timestamp',
        default => \'CURRENT_TIMESTAMP',
    },
);

__PACKAGE__->set_primary_key('id');
__PACKAGE__->belongs_to('user', 'Pval::Schema::Result::User');
__PACKAGE__->belongs_to('freshman', 'Pval::Schema::Result::Freshman');

sub sqlt_deploy_hook {
    my ($self, $sqlt_table) = @_;

    $sqlt_table->add_index(name => 'conditional_created_idx', fields => ['created']);
    $sqlt_table->add_index(name => 'conditional_deadline_idx', fields => ['deadline']);
    $sqlt_table->add_index(name => 'conditional_status_idx', fields => ['status']);
}

1;
