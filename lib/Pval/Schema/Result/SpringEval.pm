package Pval::Schema::Result::SpringEval;

use strict;
use warnings;
use v5.10;

use Moose;

extends 'DBIx::Class::Core';
__PACKAGE__->load_components(qw/InflateColumn::DateTime InflateColumn::Object::Enum Helper::Row::ToJSON/);
__PACKAGE__->table('spring_evals');
__PACKAGE__->add_columns(
    id => {
        data_type => 'integer',
        size => 16,
        is_nullable => 0,
        is_auto_increment => 1,
    },
    date => {
        data_type => 'datetime',
        is_nullable => 0,
        default_value => \'CURRENT_TIMESTAMP',
    },
    user => {
        data_type => 'integer',
        size => 16,
        is_nullable => 0,
    },
    comments => {
        data_type => 'varchar',
        size => 10240,
        is_nullable => 1,
    },
    result => {
        data_type => 'enum',
        is_enum => 1,
        extra => {
            list => [qw/pending conditional pass fail/],
        },
        default => 'pending',
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

    $sqlt_table->add_index(name => 'spring_evals_date_idx', fields => ['date']);
    $sqlt_table->add_index(name => 'spring_evals_result_idx', fields => ['result']);
}

1;
