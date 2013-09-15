package Pval::Routes::Freshman;

use strict;
use warnings;
use v5.10;

use Dancer;
use Dancer::Plugin::Cache::CHI;
use Dancer::Plugin::DBIC;
use Pval::LDAP;
use Pval::Misc;

prefix '/freshmen';
check_page_cache;

sub freshman_to_json {
    my $freshman = shift;
    my $deep = shift; #Check to see if we need to do all of the packet stuff

    my $user = undef;
    my $packets = [];

    if ($deep) {
        my $ldap = Pval::LDAP->new;
        if ($freshman->user) {
            $user = $freshman->user;

            my $ldap_user = $ldap->uuid_to_user($user->UUID);
            $user = Pval::Routes::User::user_to_hash $ldap_user, $user;
        }

        foreach my $packet ($freshman->packets->all) {
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

    $freshman = $freshman->TO_JSON;
    $freshman->{ten_week} = $freshman->{ten_week}->mdy;
    $freshman->{vote_date} = $freshman->{vote_date}->mdy;
    $freshman->{result} = $freshman->{result}->value;

    if ($deep) {
        $freshman->{user} = $user;
        $freshman->{packets} = $packets;
    }

    return $freshman;
}

get '/' => sub {
    my $db = schema;
    my @freshmen = $db->resultset('Freshman')->all;

    foreach my $freshman (@freshmen) {
        $freshman = freshman_to_json $freshman;
    }

    return cache_page template_or_json {
        freshmen => [ (@freshmen) ],
    }, 'freshmen', request->content_type;
};

get '/:id' => sub {
    my $db = schema;
    my $freshman = $db->resultset('Freshman')->find({
        id => param 'id',
    }, {
        prefetch => [ qw/packets/ ],
    });

    $freshman = freshman_to_json $freshman, 1;

    return cache_page template_or_json {
        freshman => $freshman,
    }, 'freshman', request->content_type;
};

1;
