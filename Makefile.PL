use strict;
use warnings;
use ExtUtils::MakeMaker;

WriteMakefile(
    NAME                => 'pval',
    AUTHOR              => [ 'William Orr <worr@csh.rit.edu>', 'Matt Gambogi <gambogi@csh.rit.edu>' ],
    VERSION_FROM        => 'lib/Pval.pm',
    ABSTRACT            => 'Updated evals database for CSH',
    ($ExtUtils::MakeMaker::VERSION >= 6.3002
      ? ('LICENSE'=> 'MIT')
      : ()),
    PL_FILES            => {},
    PREREQ_PM => {
        'Test::More'    => 0,
        'YAML'          => 0,
        'Dancer'        => 1.3095,
        'Data::UUID'    => 0,
        'Dancer::Plugin::DBIC'  => 0,
        'Dancer::Plugin::LDAP'  => 0,
        'Dancer::Plugin::Cache::CHI' => 0,
        'DateTime'  => 0,
        'Moose'     => 0,
        'Cache::Memcached::Fast'    => 0,
        'CHI::Driver::Memcached::libmemcached' => 0,
        'Memcached::libmemcached' => 0,
        'DBIx::Class::InflateColumn::Object::Enum'  => 0,
        'Try::Tiny' => 0,
        'HTML::Entities' => 0,
        'Template' => 0,
    },
    dist                => { COMPRESS => 'gzip -9f', SUFFIX => 'gz', },
    clean               => { FILES => 'pval-*' },
);
