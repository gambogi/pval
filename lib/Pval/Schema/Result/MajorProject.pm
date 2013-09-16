package Pval::Schema::Result::MajorProject;

use strict;
use warnings;
use v5.10;

use Moose;

extends 'DBIx::Class::Core';
with 'Pval::Roles::JSON';

sub json {
    my $self = shift;
    my $project = $self;

    my $ldap = Pval::LDAP->new;
    $project = $project->TO_JSON;

    $project->{committee} = $ldap->uuid_to_committee($project->{committee})->get('cn')->[0];
    $project->{submitter} = $project->{submitter}->json;
    $project->{status} = $project->{status}->value;
    $project->{date} = $project->{date}->datetime;

    return $project;
}

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
        default_value => \'CURRENT_TIMESTAMP',
    },
    comments => {
        data_type => 'varchar',
        size => 10240,
        is_nullable => 1,
    },
    committee => {
        data_type => 'varchar',
        size => 37,
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
        default_value => \'CURRENT_TIMESTAMP',
    },
);

__PACKAGE__->set_primary_key('id');
__PACKAGE__->belongs_to('submitter', 'Pval::Schema::Result::User');

sub sqlt_deploy_hook {
    my ($self, $sqlt_table) = @_;

    $sqlt_table->add_index(name => 'major_projects_status_idx', fields => ['status']);
    $sqlt_table->add_index(name => 'major_projects_committee_idx', fields => ['committee']);
}

1;
