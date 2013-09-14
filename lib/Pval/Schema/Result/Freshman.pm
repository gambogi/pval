package Pval::Schema::Result::Freshman;

use strict;
use warnings;
use v5.10;

use Dancer ':moose';
use Dancer::Plugin::DBIC;
use Moose;
use Pval::LDAP;

extends 'DBIx::Class::Core';

__PACKAGE__->load_components(qw/InflateColumn::DateTime InflateColumn::Object::Enum Helper::Row::ToJSON/);
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
        is_nullable => 1,
    },
    name => {
        data_type => 'varchar',
        size => 1024,
        is_nullable => 0,
    },
    vote_date => {
        data_type => 'date',
        is_nullable => 0,
        default_value => \'CURRENT_DATE',
    },
    comments => {
        data_type => 'varchar',
        size => 10240,
        is_nullable => 1,
    },
    ten_week => {
        data_type => 'date',
        is_nullable => 0,
        default_value => \'CURRENT_DATE',
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
        default => \'CURRENT_TIMESTAMP',
    },
);

__PACKAGE__->set_primary_key('id');
__PACKAGE__->belongs_to('user' => 'Pval::Schema::Result::User');
__PACKAGE__->has_many('packets' => 'Pval::Schema::Result::Packet', 'id');

sub sqlt_deploy_hook {
    my ($self, $sqlt_table) = @_;

    $sqlt_table->add_index(name => 'freshmen_name_idx', fields => ['name']);
    $sqlt_table->add_index(name => 'freshmen_vote_date_idx', fields => ['vote_date']);
    $sqlt_table->add_index(name => 'freshmen_ten_week_idx', fields => ['ten_week']);
    $sqlt_table->add_index(name => 'freshmen_result_idx', fields => ['result']);
}

sub create_account {
    my ($self, $uid) = @_;
    my $db = schema;
    my $ug = Data::UUID->new;
    my $ldap = Pval::LDAP->new;

    my $ldap_user = $ldap->find_user($uid);
    my $user = $db->resultset('User')->create({
        UUID => $ug->from_string($ldap_user->get_value('entryUUID'))
    });

    $user->freshman($self);
    $user->insert;
    
    $self->user($user);
    $self->update;
}

sub add_packet {
    my $self = shift;
    my ($given, $due) = @_; 
    my $db = schema 'default';

    my $packet = $db->resultset('Packet')->create({ given => $given, due => $due, user => $self });
    $packet->insert;
    $self->update;
}

sub get_latest_packet {
    my $self = shift;
    my $db = schema 'default';

    my @packet = @{$self->packets};
    return @packet;
}

sub missing_signatures {
    my ($self, $packet, $usernames) = @_;
    my $db = schema 'default';

    foreach my $username (@$usernames) {
        $packet->add_to_missing_signatures(Pval::User->new({ username => $username })->dbic_object);
    }
}

1;
