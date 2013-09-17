package Pval::Schema::Result::Freshman;

use strict;
use warnings;
use v5.10;

use Dancer ':moose';
use Dancer::Plugin::DBIC;
use Moose;
use Pval::LDAP;

extends 'DBIx::Class::Core';
with 'Pval::Roles::JSON';

sub json {
    my $self = shift;
    my $deep = shift; #Check to see if we need to do all of the packet stuff

    my $user = undef;
    my $freshman = {};
    my $packets = [];
    my $conditionals = [];

    if ($deep) {
        my $ldap = Pval::LDAP->new;
        if ($self->user) {
            $user = $self->user->json;
        }

        foreach my $packet ($self->packets->all) {
            my $missing_signatures = [];
            my $missing_freshmen_signatures = [];

            foreach my $sig ($packet->missing_signatures->all) {
                my $signature = {};
                $signature->{cn} = $ldap->uuid_to_user($sig->UUID)->get('cn')->[0];
                $signature->{uid} = $ldap->uuid_to_user($sig->UUID)->get('uid')->[0];
                push $missing_signatures, $signature;
            }

            foreach my $sig ($packet->freshmen_missing_signatures->all) {
                my $signature = {};
                $signature->{name} = $sig->name;
                $signature->{id} = $sig->id;
                push $missing_freshmen_signatures, $signature;
            }

            foreach my $conditional ($self->conditionals->all) {
                my $cond = $conditional->json;
                delete $cond->{freshman};
                delete $cond->{user};

                push $conditionals, $cond;
            }

            $packet = $packet->TO_JSON;
            $packet->{given} = $packet->{given}->mdy;
            $packet->{due} = $packet->{due}->mdy;
            $packet->{missing_signatures} = $missing_signatures;
            $packet->{num_missing} = @$missing_signatures;

            $packet->{missing_freshmen_signatures} = $missing_freshmen_signatures;
            $packet->{num_freshmen_missing} = @$missing_freshmen_signatures;
            delete $packet->{user};

            push $packets, $packet;
        }
    }

    $freshman = $self->TO_JSON;
    $freshman->{ten_week} = $freshman->{ten_week}->mdy;
    $freshman->{vote_date} = $freshman->{vote_date}->mdy;
    $freshman->{result} = $freshman->{result}->value;

    if ($deep) {
        $freshman->{user} = $user;
        $freshman->{packets} = $packets;
        $freshman->{conditionals} = $conditionals;
    }

    return $freshman;
}

__PACKAGE__->load_components(qw/InflateColumn::DateTime InflateColumn::Object::Enum Helper::Row::ToJSON/);
__PACKAGE__->table('freshmen');
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
__PACKAGE__->belongs_to('user' => 'Pval::Schema::Result::User', { 'foreign.freshman' => 'self.id' });
__PACKAGE__->has_many('packets' => 'Pval::Schema::Result::Packet', 'id');
__PACKAGE__->has_many('conditionals' => 'Pval::Schema::Result::Conditional', 'freshman');

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
