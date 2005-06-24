use t::SporkHilite;

__DATA__
=== One
--- code
# This is a comment
sub divide {
    my $numerator = shift;
    my $divisor = shift;
    return $numerator / $divisor;
}

bbb g+ 2
--- html
<pre>
# This is a comment
BBBsub/// GGGdivide {///
    my $numerator = shift;
    my $divisor = shift;
    return $numerator / $divisor;
}
</pre>

=== Two Tests
--- code

        rrrrrrr  4
--- html
<pre>
# This is a comment
sub divide {
    my $numerator = shift;
    my $RRRdivisor/// = shift;
    return $numerator / $divisor;
}
</pre>

=== Third
--- code

bygbygbygbygbyg  1

--- html
<pre>
BBB#///YYY ///GGGT///BBBh///YYYi///GGGs///BBB ///YYYi///GGGs///BBB ///YYYa///GGG ///BBBc///YYYo///GGGm///ment
sub divide {
    my $numerator = shift;
    my $divisor = shift;
    return $numerator / $divisor;
}
</pre>

