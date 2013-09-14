#!/usr/bin/env perl

# This is not my code, I got this from here:
# http://blogs.perl.org/users/davewood/2013/03/using-dbixclassdeploymenthandler.html

use strict;
use warnings;
no warnings 'experimental';
use v5.14;

use Dancer ':script';
use Dancer::Plugin::DBIC;
use DBIx::Class::DeploymentHandler;
use Getopt::Long;

my $cmd = '';
my $from_version;
my $to_version;
my $version;
GetOptions(
    'command|cmd|c=s' => \$cmd,
    'from-version=i'  => \$from_version,
    'to-version=i'    => \$to_version,
    'version=i'       => \$version,
);

sub usage {
    say <<'HERE';
usage:
  database.pl --cmd prepare [ --from-version $from --to-version $to ]
  database.pl --cmd install [ --version $version ]
  database.pl --cmd upgrade
  database.pl --cmd database-version
  database.pl --cmd schema-version
HERE
    exit(0);
}

my $schema = schema;
my $deployment_handler_dir = './db_upgrades';

my $dh = DBIx::Class::DeploymentHandler->new(
    {   schema           => $schema,
        script_directory => $deployment_handler_dir,
        databases        => "SQLite",
        force_overwrite  => 1,
    });

die "We only support positive integers for versions."
    unless $dh->schema_version =~ /^\d+$/;

for ($cmd) {
    when ('prepare')          { prepare() }
    when ('install')          { install() }
    when ('upgrade')          { upgrade() }
    when ('database-version') { database_version() }
    when ('schema-version')   { schema_version() }
    default                   { usage() }
}

sub prepare {
    say "running prepare_install()";
    $dh->prepare_install;

    if ( defined $from_version && defined $to_version ) {
        say
            "running prepare_upgrade({ from_version => $from_version, to_version => $to_version })";
        $dh->prepare_upgrade(
            {   from_version => $from_version,
                to_version   => $to_version,
            }
        );
    }
}

sub install {
    if ( defined $version ) {
        $dh->install({ version => $version });
    }
    else {
        $dh->install;
    }
}

sub upgrade {
    $dh->upgrade;
}

sub database_version {
    say $dh->database_version;
}

sub schema_version {
    say $dh->schema_version;
}
