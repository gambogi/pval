package Pval::Schema::Result::WinterEval;

use strict;
use warnings;
use v5.10;

use Moose;

extends 'DBIx::Class::Core';
__PACKAGE__->load_components('InflateColumn::DateTime');
__PACKAGE__->table('winter_evals');
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
    # This doesn't correspond to major projects, so it's just a text field
    projects => {
        data_type => 'varchar',
        size => 10240,
        is_nullable => 1,
    },
    comments => {
        data_type => 'varchar',
        size => 10240,
        is_nullable => 1,
    },
    date => {
        data_type => 'date',
        default_value => \'CURRENT_DATE',
    },
    timestamp => {
        data_type => 'timestamp',
        default_value => \'CURRENT_TIMESTAMP',
    },
);

__PACKAGE__->set_primary_key('id');
__PACKAGE__->belongs_to(user => 'Pval::Schema::Result::User');

sub sqlt_deploy_hook {
    my ($self, $sqlt_table) = @_;

    $sqlt_table->add_index(name => 'winter_evals_date_idx', fields => ['date']);
}

1;
