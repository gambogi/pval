package Pval::Database::Schema::Result::SpringEval;

use base qw/DBIx::Class::Core/;
__PACKAGE__->load_components(qw/InflateColumn::DateTime InflateColumn::Object::Enum/);
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
    },
);

__PACKAGE__->set_primary_key('id');
__PACKAGE__->belongs_to(user => 'Pval::Database::Schema::Result::User');

1;
