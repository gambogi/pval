package Pval::Schema::Result::Conditional;

use strict;
use warnings;
use v5.10;

use Moose;

extends 'DBIx::Class::Core';
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
        is_nullable => 0,
    },
    created => {
        data_type => 'date',
        is_nullable => 0,
        default => 'TODAY();',
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
    timestamp => {
        data_type => 'timestamp',
    },
);

__PACKAGE__->set_primary_key('id');
__PACKAGE__->belongs_to('user', 'Pval::Schema::Result::User');

1;
