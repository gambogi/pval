package Pval::Schema::Result::Packet;

use strict;
use warnings;
use v5.10;

use Moose;

extends 'DBIx::Class::Core';
__PACKAGE__->load_components(qw/InflateColumn::DateTime Helper::Row::ToJSON/);
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
        default_value => \'CURRENT_DATE',
    },
    due => {
        data_type => 'date',
        is_nullable => 0,
        default_value => \'CURRENT_DATE',
    },
    timestamp => {
        data_type => 'timestamp',
        default_value => \'CURRENT_TIMESTAMP',
    },
);

__PACKAGE__->set_primary_key('id');
__PACKAGE__->belongs_to('user' => 'Pval::Schema::Result::Freshman');
__PACKAGE__->has_many('packet_missing_signatures' => 'Pval::Schema::Result::PacketMissingSignature', 'packet');
__PACKAGE__->many_to_many('missing_signatures' => 'packet_missing_signatures', 'missing_signature');

1;
