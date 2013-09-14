package Pval::Schema::Result::MajorProject;

use strict;
use warnings;
use v5.10;

use Moose;

extends 'DBIx::Class::Core';
__PACKAGE__->load_components(qw/InflateColumn::DateTime InflateColumn::Object::Enum Helper::Row::ToJSON/);
__PACKAGE__->table('major_projects');
__PACKAGE__->add_columns(
    id => {
        data_type => 'integer',
        size => 16,
        is_nullable => 0,
        is_auto_increment => 1,
    },
    name => {
        data_type => 'varchar',
        size => 1024,
        is_nullable => 0,
    },
    description => {
        data_type => 'varchar',
        size => 10240,
        is_nullable => 0,
    },
    submitter => {
        data_type => 'integer',
        size => 16,
        is_nullable => 0,
    },
    date => {
        data_type => 'datetime',
        is_nullable => 0,
    },
    comments => {
        data_type => 'varchar',
        size => 10240,
        is_nullable => 1,
    },
    committee => {
        data_type => 'binary',
        size => 16,
        is_nullable => 0,
    },
    status => {
        data_type => 'enum',
        is_enum => 1,
        extra => {
            list => [qw/pending passed failed/],
        },
        default => 'pending',
        is_nullable => 0,
    },
    timestamp => {
        data_type => 'timestamp',
    },
);

__PACKAGE__->set_primary_key('id');
__PACKAGE__->belongs_to('submitter', 'Pval::Schema::Result::User');

1;
