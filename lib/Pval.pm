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
    return cache_page template 'index', {
        user => $user->[0],
    };
};

1;
