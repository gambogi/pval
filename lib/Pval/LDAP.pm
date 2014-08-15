package Pval::LDAP;

use strict;
use warnings;
use v5.10;

use Dancer ':syntax';
use Dancer::Plugin::Cache::CHI;
use Dancer::Plugin::LDAP;
use Data::UUID;
use Moose;
use Net::LDAP::Entry;
use Net::LDAP::Util qw/escape_filter_value/;
use Pval::Schema::Result::User;

sub ldap_to_json {
    my $self = shift;
    my $ldap_entry = shift;
    
    return {
        uuid => $ldap_entry->get('entryUUID')->[0],
        uid => $ldap_entry->get('uid')->[0],
        name => $ldap_entry->get('cn')->[0],
        room => ($ldap_entry->get('roomNumber') // [0])->[0],
        active => ($ldap_entry->get('active') // [0])->[0],
        alumni => ($ldap_entry->get('alimni') // [0])->[0],
        on_floor => ($ldap_entry->get('onFloor') // [0])->[0],
        housing_points => ($ldap_entry->get('housingPoints') // [0])->[0]
    };
}

sub committee_to_uuid {
    my $self = shift;
    my $committee = shift;

    my $committee_obj = $self->_fetch_from_ldap("cn=".escape_filter_value($committee), [ qw/entryUUID/ ], "ou=Committees,dc=csh,dc=rit,dc=edu")->[0];
    return undef unless $committee_obj;
    return $committee_obj->get('entryUUID')->[0];
}

sub uuid_to_committee {
    my $self = shift;
    my $uuid = shift;

    my $committee_name = $self->_fetch_from_ldap("entryUUID=$uuid", [ qw/cn/ ])->[0];
    die "Cannot find $uuid in LDAP" unless $committee_name;
    return $committee_name;
}

sub uuid_to_user {
    my $self = shift;
    my $uuid = shift;

    my $username = $self->_fetch_from_ldap("entryUUID=$uuid", [ qw/uid cn entryUUID active alumni housingPoints onfloor roomNumber/ ])->[0];
    die "Cannot find $uuid in LDAP" unless $username;
    return $username;
}


sub uid_to_uuid {
    my $self = shift;
    my $uid = shift;

    my $entryUUID = $self->_fetch_from_ldap(
        "uid=$uid",
        ['entryUUID'],
    )->[0];
    die "Cannot find $entryUUID in LDAP" unless $entryUUID;
    return $entryUUID;
}

sub find_user {
    my $self = shift;
    my $username = shift;
    my $ug = Data::UUID->new;

    my $user = $self->_fetch_from_ldap("uid=".escape_filter_value($username), [ qw/uid cn entryUUID active alumni housingPoints onfloor roomNumber/ ])->[0];
    die "Cannot find $username in LDAP" unless $user;
    return $user;
}

### get_eboard :: self -> {committee_name => [uid]}
sub get_eboard {
    my $self = shift;
    my $eboard = {};
    my @committees = qw/
        financial
        history
        improvements
        opcomm
        r&d
        social
    /;
    foreach my $committee (@committees){
        $eboard->{$committee} = $self->get_eboard_director($committee);
    }
    # I want to smack an RTP for this. Note the spelling of 'evaluations'
    $eboard->{evals} = $self->get_eboard_director('evaulations');
    # Not as bad as a spelling mistake, but a little silly nevertheless
    $eboard->{chairman} = $self->get_eboard_director('eboard');
    return $eboard;
}

### get_eboard_director :: self -> committee_name -> uid
sub get_eboard_director {
    my $self = shift;
    my $committee = shift;

    my $ret = $self->_fetch_from_ldap (
        "cn=$committee",
        [ qw/head/ ],
        'ou=Committees,dc=csh,dc=rit,dc=edu',
    )->[0];
    die "Cannot find $committee director in LDAP" unless $ret;
    # pull out uid
    map { s/uid=(\w+),ou=Users,dc=csh,dc=rit,dc=edu/$1/ } @{$ret->get("head")};
    return $ret->get("head");
}

# This query only fetches uids so we can make use 
# of existing entries from memcached
sub get_active_users {
    my $self = shift;

    my $ret = $self->_fetch_from_ldap("active=1", [ qw/uid cn entryUUID active alumni housingPoints onfloor roomNumber/ ]);
}


sub _fetch_from_ldap {
    my ($self, $query, $attrs, $base) = @_;

    $base //= 'dc=csh,dc=rit,dc=edu';

    my $ret = cache_get $query;
    return $ret if defined $ret;

    $ret = [ (ldap->search(
        base => $base,
        filter => $query,
        attrs => $attrs,
    )->entries()) ];

    # The longest possibly cache time is about eleven hours. The expiry is staggered
    cache_set $query, $ret if defined $ret;

    return $ret;
}

1;
