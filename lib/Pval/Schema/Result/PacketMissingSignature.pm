package Pval::Schema::Result::PacketMissingSignature;

use strict;
use warnings;
use v5.10;

use Moose;

extends 'DBIx::Class::Core';
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

__PACKAGE__->belongs_to('packet' => 'Pval::Schema::Result::Packet');
__PACKAGE__->belongs_to('missing_signature' => 'Pval::Schema::Result::User');

1;
