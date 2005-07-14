#!/usr/bin/perl

use strict;
use warnings;

use Test::More tests => 22;
use Test::Exception;

BEGIN { 
    use_ok('Tree::Simple::Visitor::FindByPath');
}

use Tree::Simple;

my $first_search = Tree::Simple->new("1.2.2");
isa_ok($first_search, 'Tree::Simple');

my $second_search = Tree::Simple->new("3.2.1");
isa_ok($second_search, 'Tree::Simple');

my $tree = Tree::Simple->new(Tree::Simple->ROOT)
                       ->addChildren(
                            Tree::Simple->new("1")
                                        ->addChildren(
                                            Tree::Simple->new("1.1"),
                                            Tree::Simple->new("1.2")
                                                        ->addChildren(
                                                            Tree::Simple->new("1.2.1"),
                                                            $first_search
                                                        ),
                                            Tree::Simple->new("1.3")                                                                                                
                                        ),
                            Tree::Simple->new("2")
                                        ->addChildren(
                                            Tree::Simple->new("2.1"),
                                            Tree::Simple->new("2.2")
                                        ),                            
                            Tree::Simple->new("3")
                                        ->addChildren(
                                            Tree::Simple->new("3.1"),
                                            Tree::Simple->new("3.2")->addChild($second_search),
                                            Tree::Simple->new("3.3")                                                                                                
                                        ),                            
                            Tree::Simple->new("4")                                                        
                                        ->addChildren(
                                            Tree::Simple->new("4.1")
                                        )                            
                       );
isa_ok($tree, 'Tree::Simple');

can_ok("Tree::Simple::Visitor::FindByPath", 'new');

my $visitor = Tree::Simple::Visitor::FindByPath->new();
isa_ok($visitor, 'Tree::Simple::Visitor::FindByPath');
isa_ok($visitor, 'Tree::Simple::Visitor');

can_ok($visitor, 'setSearchPath');
can_ok($visitor, 'visit');
can_ok($visitor, 'getResult');

# test our first search path
$visitor->setSearchPath(qw(1 1.2 1.2.2));
$tree->accept($visitor);
is($visitor->getResult(), $first_search, '... this should be what we got back');

# add a node filter
can_ok($visitor, 'setNodeFilter');
$visitor->setNodeFilter(sub { "Tree_" . $_[0]->getNodeValue() });

# test our new search path with filter
$visitor->setSearchPath(qw(Tree_3 Tree_3.2 Tree_3.2.1));
$tree->accept($visitor);
is($visitor->getResult(), $second_search, '... this should be what we got back');

# use the trunk
can_ok($visitor, 'includeTrunk');
$visitor->includeTrunk(1);

# test path failure
$visitor->setSearchPath(qw(Tree_root 1 5 35));
$tree->accept($visitor);
ok(!defined($visitor->getResult()), '... should fail, and we get back undef');

my ($last_found_result) = $visitor->getResults();
is($last_found_result, $tree, '... we should not have gotten farther than the root');

# test total path failure
$visitor->setSearchPath(qw(1 5 35));
$tree->accept($visitor);
ok(!defined($visitor->getResult()), '... should fail, and we get back undef');

# test some error conditions

throws_ok {
    $visitor->visit();
} qr/Insufficient Arguments/, '... this should die';

throws_ok {
    $visitor->visit("Fail");
} qr/Insufficient Arguments/, '... this should die';

throws_ok {
    $visitor->visit([]);
} qr/Insufficient Arguments/, '... this should die';

throws_ok {
    $visitor->visit(bless({}, "Fail"));
} qr/Insufficient Arguments/, '... this should die';

throws_ok {
    $visitor->setSearchPath();
} qr/Insufficient Arguments/, '... this should die';
