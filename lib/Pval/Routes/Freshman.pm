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
    my $user = undef;

    if ($freshman->user) {
        my $ldap = Pval::LDAP->new;
        $user = $freshman->user;

        my $ldap_user = $ldap->uuid_to_user($user->UUID);
        $user = Pval::Routes::User::user_to_hash $ldap_user, $user;
    }

    $freshman = $freshman->TO_JSON;
    $freshman->{user} = $user;
    $freshman->{ten_week} = $freshman->{ten_week}->mdy;
    $freshman->{vote_date} = $freshman->{vote_date}->mdy;
    $freshman->{result} = $freshman->{result}->value;

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

    my $user = undef;
    $freshman = freshman_to_json $freshman;

    return cache_page template_or_json {
        freshman => $freshman,
    }, 'freshman', request->content_type;
};

1;
