use strict;
use warnings;
use ExtUtils::MakeMaker;

WriteMakefile(
	      NAME          => 'Config::AutoConf',
	      AUTHOR        => 'Alberto Simões <ambs@cpan.org>',
	      VERSION_FROM  => 'lib/Config/AutoConf.pm',
	      ABSTRACT_FROM => 'lib/Config/AutoConf.pm',
	      PL_FILES      => {},
	      PREREQ_PM     => {
				'ExtUtils::CBuilder' => 0.07,
				'Test::More'         => 0,
			       },
	      dist          => {
				COMPRESS => 'gzip -9f',
				SUFFIX   => 'gz'
			       },
	      clean         => {
				FILES => 'Config-AutoConf-*'
			       },
	     );
