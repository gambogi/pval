package Pval::MajorProject;

use strict;
use warnings;
use v5.10;

use Dancer ':syntax';
use Dancer::Plugin::DBIC;
use Pval::Misc;
use Pval::Schema;
use Try::Tiny;

prefix '/projects';

get '/:id' => sub {
    my $id  = param 'id';
    my $db = schema;
    my $project = undef;

    try {
        $project = $db->resultset('MajorProject')->find({ id => $id });
    };

    if (defined $project) {
        return template_or_json({
            project => $project
        }, 'project', request->content_type);
    } else {
        return template_or_json({
            error => "Cannot find project with id $id"
        }, 'error', request->content_type);
    }
};

1;
