package Pval::MajorProject;

use strict;
use warnings;
use v5.10;

use Dancer ':syntax';
use Dancer::Plugin::DBIC;
use Pval::Misc;
use Pval::User qw/user_to_hash/;
use Pval::Schema;
use Try::Tiny;

prefix '/projects';

get '/:id' => sub {
    my $id  = param 'id';
    my $db = schema;
    my $project = undef;
    my $ldap = Pval::LDAP->new;

    try {
        $project = $db->resultset('MajorProject')->find({ id => $id });
    };

    if (defined $project) {
        return template_or_json({
            project => $project,
            user => user_to_hash($ldap->uuid_to_user($poject->submitter->UUID)),
        }, 'project', request->content_type);
    } else {
        return template_or_json({
            error => "Cannot find project with id $id"
        }, 'error', request->content_type);
    }
};

1;
