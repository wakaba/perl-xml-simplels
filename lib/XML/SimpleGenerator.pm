package XML::SimpleGenerator;
use strict;
use warnings;
our $VERSION = '1.0';

sub escape ($) {
    return unless $_[0] =~ /[<>&\"]/;
    $_[0] =~ s/&/&amp;/g;
    $_[0] =~ s/</&lt;/g;
    $_[0] =~ s/>/&gt;/g;
    $_[0] =~ s/\"/&quot;/g;
}

sub serialize {
    my ($class, $tree => $rref) = @_;
    my ($name, $attrs, @child) = @$tree;
    $$rref .= '<' . $name;
    for my $attr_name (sort { $a cmp $b } keys %{$attrs or {}}) {
        my $attr_value = $attrs->{$attr_name};
        $attr_value = '' unless defined $attr_value;
        escape $attr_value;
        $$rref .= ' ' . $attr_name . '="' . $attr_value . '"';
    }
    $$rref .= '>';
    for (@child) {
        if (ref $_) {
            $class->serialize($_ => $rref);
        } elsif (defined $_) {
            my $v = $_;
            escape $v;
            $$rref .= $v;
        }
    }
    $$rref .= '</' . $name . '>';
}

1;
