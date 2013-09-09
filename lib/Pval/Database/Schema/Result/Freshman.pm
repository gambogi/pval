package Pval::Database::Schema::Result::Freshman;

use DateTime;
use Moose;

use base qw/DBIx::Class::Core/;
__PACKAGE__->load_components(qw/InflateColumn::DateTime InflateColumn::Object::Enum/);
__PACKAGE__->table('freshmen');
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
    name => {
        data_type => 'varchar',
        size => 1024,
        is_nullable => 0,
    },
    vote_date => {
        data_type => 'date',
        is_nullable => 0,
    },
    comments => {
        data_type => 'varchar',
        size => 10240,
        is_nullable => 1,
    },
    ten_week => {
        data_type => 'date',
        is_nullable => 0,
    },
    passed_freshman_project => {
        data_type => 'integer',
        size => 1,
        is_nullable => 0,
        default_value => 0,
    },
    freshman_project_comments => {
        data_type => 'varchar',
        size => 10240,
        is_nullable => 1,
    },
    result => {
        data_type => 'enum',
        is_enum => 1,
        extra => {
            list => [qw/pass fail pending conditional/],
        },
        is_nullable => 0,
        default_value => "pending",
    },
    timestamp => {
        data_type => 'timestamp',
        default_value => \'now',
    },
);

__PACKAGE__->set_primary_key('id');
__PACKAGE__->belongs_to('user' => 'Pval::Database::Schema::Result::User');
__PACKAGE__->has_many('packets' => 'Pval::Database::Schema::Result::Packet', 'id');

1;
