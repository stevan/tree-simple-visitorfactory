use strict;
use warnings;

use ExtUtils::MakeMaker;

WriteMakefile
(
	NAME         => 'Tree::Simple::VisitorFactory',
	VERSION_FROM => 'lib/Tree/Simple/VisitorFactory.pm',
	PREREQ_PM    =>
	{
		'base'                  => 2.16,
		'File::Spec'            => 0.60,
		'Scalar::Util'          => 1.10,
		'Test::More'            => 0.47,
		'Test::Exception'       => 0.15,
		'Tree::Simple'          => 1.12,
		'Tree::Simple::Visitor' => 1.22,
		'strict'                => 0,
		'warnings'              => 0,
	},
	META_MERGE  => {
		resources => {
			repository => 'https://github.com/stevan/tree-simple-visitorfactory',
		},
	},
);
