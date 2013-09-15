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
    },
    winter_form => {
        data_type => 'boolean',
    },
    spring_form => {
        data_type => 'boolean',
    },
);

__PACKAGE__->set_primary_key('id');

sub sqlt_deploy_hook {
    my ($self, $sqlt_table) = @_;

    $sqlt_table->add_index(name => 'control_panel_fall_form_idx', fields => ['fall_form']);
    $sqlt_table->add_index(name => 'control_panel_winter_form_idx', fields => ['winter_form']);
    $sqlt_table->add_index(name => 'control_panel_spring_form_idx', fields => ['spring_form']);
}

1;
