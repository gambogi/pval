package Pval::Database::Schema::Result::WinterEval;

use base qw/DBIx::Class::Core/;
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
    },
    timestamp => {
        data_type => 'timestamp',
    },
);

__PACKAGE__->set_primary_key('id');
__PACKAGE__->belongs_to(user => 'Pval::Database::Schema::Result::User');

1;
