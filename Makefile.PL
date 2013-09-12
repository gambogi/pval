use strict;
use warnings;
use ExtUtils::MakeMaker;

WriteMakefile(
    NAME                => 'pval',
    AUTHOR              => q{William Orr <worr@csh.rit.edu},
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
        'DateTime'  => 0,
        'Moose'     => 0,
        'Cache::Memcached::Fast'    => 0,
        'DBIx::Class::InflateColumn::Object::Enum'  => 0,
        'Try::Tiny' => 0,
        'HTML::Entities' => 0,
        'Template' => 0,
    },
    dist                => { COMPRESS => 'gzip -9f', SUFFIX => 'gz', },
    clean               => { FILES => 'pval-*' },
);
