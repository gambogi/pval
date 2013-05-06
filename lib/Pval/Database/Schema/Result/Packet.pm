package Pval::Database::Schema::Result::Packet;

use base qw/DBIx::Class::Core/;
__PACKAGE__->load_components('InflateColumn::DateTime');
__PACKAGE__->table('packets');
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
    given => {
        data_type => 'date',
        is_nullable => 0,
    },
    due => {
        data_type => 'date',
        is_nullable => 0,
    },
    timestamp => {
        data_type => 'timestamp',
    },
);

__PACKAGE__->set_primary_key('id');
__PACKAGE__->belongs_to('user' => 'Pval::Database::Schema::Result::Freshman');
__PACKAGE__->has_many('packet_missing_signatures' => 'Pval::Database::Schema::Result::PacketMissingSignature', 'packet');
__PACKAGE__->many_to_many('missing_signatures' => 'packet_missing_signatures', 'missing_signature');

1;
