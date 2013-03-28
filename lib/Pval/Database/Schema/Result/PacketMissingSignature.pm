package Pval::Database::Schema::Result::PacketMissingSignature;

use base qw/DBIx::Class::Core/;
__PACKAGE__->table('packet_missing_signatures');
__PACKAGE__->add_columns(
    'packet' => {
        data_type => 'integer',
        size => 16,
        is_nullable => 0,
    },
    'missing_signature' => {
        data_type => 'integer',
        size => 16,
        is_nullable => 0,
    },
);

__PACKAGE__->belongs_to('packet' => 'Pval::Database::Schema::Result::Packet');
__PACKAGE__->belongs_to('missing_signature' => 'Pval::Database::Schema::Result::User');

1;
