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
        'CHI::Driver::Memcached::libmemcached'      => 0,
        'Dancer'                                    => 1.3095,
        'Dancer::Plugin::DBIC'                      => 0,
        'Dancer::Plugin::LDAP'                      => 0,
        'Dancer::Plugin::Cache::CHI'                => 0,
        'Data::UUID'                                => 0,
        'DateTime'                                  => 0,
        'DBIx::Class'                               => 0,
        'DBIx::Class::Helper::Row::ToJSON'          => 0,
        'DBIx::Class::InflateColumn::Object::Enum'  => 0,
        'HTML::Entities'                            => 0,
        'Memcached::libmemcached'                   => 0,
        'Moose'                                     => 0,
        'Template'                                  => 0,
        'Test::More'                                => 0,
        'Try::Tiny'                                 => 0,
        'YAML'                                      => 0,
    },
    dist                => { COMPRESS => 'gzip -9f', SUFFIX => 'gz', },
    clean               => { FILES => 'pval-*' },
);
