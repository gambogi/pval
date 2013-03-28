package Pval::Database::Schema::Result::Roster;

use base qw/DBIx::Class::Core/;
__PACKAGE__->load_components('InflateColumn::DateTime');
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
__PACKAGE__->belongs_to(user => 'Pval::Database::Schema::Result::User');

1;
