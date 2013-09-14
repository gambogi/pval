package Pval::Schema::Result::Roster;

use strict;
use warnings;
use v5.10;

use Moose;

extends 'DBIx::Class::Core';
__PACKAGE__->load_components(qw/InflateColumn::DateTime Helper::Row::ToJSON/);
__PACKAGE__->table('roster');
__PACKAGE__->add_columns(
    id => {
        data_type => 'integer',
        size => 16,
        is_nullable => 0,
        is_auto_increment => 1,
    },
    user => {
        data_type => 'integer',
        size => 16,
        is_nullable => 0,
    },
    date => {
        data_type => 'date',
        is_nullable => 0,
    },
    room => {
        data_type => 'integer',
        size => 4,
        is_nullable => 0,
    },
    timestamp => {
        data_type => 'timestamp',
    },
);

__PACKAGE__->set_primary_key('id');
__PACKAGE__->belongs_to(user => 'Pval::Schema::Result::User');

1;
