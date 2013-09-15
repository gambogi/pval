package Pval::Schema::Result::FreshmenMissingSignature;

use strict;
use warnings;
use v5.10;

use Moose;

extends 'DBIx::Class::Core';
__PACKAGE__->table('freshmen_missing_signatures');
__PACKAGE__->add_columns(
    'packet' => {
        data_type => 'integer',
        size => 16,
        is_nullable => 0,
    },
    'freshmen_missing_signature' => {
        data_type => 'integer',
        size => 16,
        is_nullable => 0,
    },
);

__PACKAGE__->belongs_to('packet' => 'Pval::Schema::Result::Packet');
__PACKAGE__->belongs_to('freshmen_missing_signature' => 'Pval::Schema::Result::Freshman');

1;
