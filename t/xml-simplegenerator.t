package test::XML::SimpleGenerator;
use strict;
use warnings;
use Path::Class;
use lib file(__FILE__)->dir->parent->subdir('lib')->stringify;
use base qw(Test::Class);
use Test::Differences;
use XML::SimpleGenerator;

sub _serialize : Test(6) {
    for (
        [['el'] => '<el></el>'],
        [['el', undef, undef, undef] => '<el></el>'],
        [['el', undef, undef, undef, '<p>'] => '<el>&lt;p&gt;</el>'],
        [['el', {'attr1' => 'value<&>"', attr2 => undef}] => '<el attr1="value&lt;&amp;&gt;&quot;" attr2=""></el>'],
        [['el', {}, '<>&"<![CDATA[<p>]]>'] => '<el>&lt;&gt;&amp;&quot;&lt;![CDATA[&lt;p&gt;]]&gt;</el>'],
        [['el', undef, ["\x{5000}", {"\x{2000}" => "\x{1000}"}, "\x{1000}", "\x{2000}", ['foo']]] => qq'<el><\x{5000} \x{2000}="\x{1000}">\x{1000}\x{2000}<foo></foo></\x{5000}></el>'],
    ) {
        my $r = '';
        XML::SimpleGenerator->serialize($_->[0], \$r);
        eq_or_diff $r, $_->[1];
    }
}

__PACKAGE__->runtests;

1;
