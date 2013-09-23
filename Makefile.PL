use strict;
use warnings;

use ExtUtils::MakeMaker;

WriteMakefile
(
	NAME         => 'Tree::Simple::VisitorFactory',
	VERSION_FROM => 'lib/Tree/Simple/VisitorFactory.pm',
	PREREQ_PM    =>
	{
		'File::Spec'      => 0.60,
		'Scalar::Util'    => 1.10,
		'strict'          => 0,
		'Test::More'      => 0.47,
		'Test::Exception' => 0.15,
		'Tree::Simple'    => 1.12,
		'warnings'        => 0,
	}
);
