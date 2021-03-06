package Pval::Schema::Result::Queue;

use strict;
use warnings;
use v5.10;

use Moose;

extends 'DBIx::Class::Core';
__PACKAGE__->load_components(qw/InflateColumn::DateTime Helper::Row::ToJSON/);
__PACKAGE__->table('queue');
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
    date_added => {
        data_type => 'datetime',
        is_nullable => 0,
        default_value => \'CURRENT_DATE',
    },
    filled => {
        data_type => 'tinyint',
        size => 0,
        is_nullable => 0,
        default => 0,
    },
    timestamp => {
        data_type => 'timestamp',
        default_value => \'CURRENT_TIMESTAMP',
    },
);

__PACKAGE__->set_primary_key('id');
__PACKAGE__->belongs_to(user => 'Pval::Schema::Result::User');

1;
