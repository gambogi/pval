package Pval;

use strict;
use warnings;
use v5.10;

our $VERSION = '0.1';

use Dancer;
use Dancer::Plugin::Cache::CHI;
use Dancer::Plugin::DBIC;
use DateTime;
use Pval::LDAP;

# Other routes
use Pval::Routes::Event;
use Pval::Routes::Freshman;
use Pval::Routes::MajorProject;
use Pval::Routes::User;

prefix undef;
check_page_cache;
cache_page_key_generator sub {
    return join ':', request->path_info, request->content_type, request->method
};

get '/' => sub {
    my $db = schema 'default';

    my $user = Pval::LDAP->new->get_eval_director;
    my $cp = $db->resultset('ControlPanel')->single;
    
    if (not defined $cp){
        $cp = $db->resultset('ControlPanel')->create({
                fall_form => 0,
                winter_form => 0,
                spring_form => 0,
        });       
    }

    return cache_page template 'index', {
        user => $user->[0],
        fall_form   => $cp -> fall_form,
        winter_form => $cp -> winter_form,
        spring_form => $cp -> spring_form,
    };
};

1;
