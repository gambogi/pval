package Pval::Schema::Result::ControlPanel;

use strict;
use warnings;
use v5.10;

use Moose;

extends 'DBIx::Class::Core';
__PACKAGE__->load_components(qw/InflateColumn::DateTime InflateColumn::Object::Enum Helper::Row::ToJSON/);
__PACKAGE__->table('control_panel');
__PACKAGE__->add_columns(
    id => {
        data_type => 'integer',
        size => 16,
        is_nullable => 0,
        is_auto_increment => 1,
    },
    fall_form => {
        data_type => 'boolean',
        is_nullable => 0,
    },
    winter_form => {
        data_type => 'boolean',
        is_nullable => 0,
    },
    spring_form => {
        data_type => 'boolean',
        is_nullable => 0,
    },
);

__PACKAGE__->set_primary_key('id');

1;
