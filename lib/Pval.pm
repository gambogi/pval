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
use Pval::Misc;

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

    my $user = Pval::Routes::User::Utils::get_user_hash(
        request->header('x-webauth-user')
    );
    my $eval_director = Pval::LDAP->new->get_eval_director;

    return 'Error' unless defined $user;

    return cache_page template_or_json({
            user => $user,
            eval_director => $eval_director->[0],
        }, 'index', request->content_type);
};

1;
