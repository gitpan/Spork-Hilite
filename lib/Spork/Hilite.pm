package Spork::Hilite;
our $VERSION = '0.10';

use Kwiki::Plugin -Base;
use Kwiki::Installer -base;

const class_title => 'Color Hiliting for Spork';
const class_id => 'hilite';
const css_file => 'hilite.css';

sub register {
    my $registry = shift;
    $registry->add(preload => 'hilite');
    $registry->add(wafl => hilite => 'Spork::Hilite::Wafl');
}

sub init {
    $self->hub->css->add_file($self->css_file);
}

package Spork::Hilite::Wafl;
use Spoon::Formatter;
use base 'Spoon::Formatter::WaflBlock';

sub QQQ {
    no warnings;
    XXX(@_) if ++$::xxx == 3;
    @_;
}

sub to_html {
    my ($code, $directives) = $self->split;
    my $map = $self->parse($code, $directives);
    $self->format($code, $map);
}

sub format {
    my ($code, $map) = @_;
    my @output;
    for (my $i = 0; $i < @$code; $i++) {
        my $line = $code->[$i];
        $line = $self->markup($line, $map->[$i])
          if defined $map->[$i];
        push @output, $line;
    }
    join '', map "$_\n", "<pre>", @output, "</pre>";
}

my %color_map = (
    r => 'red',
    g => 'green',
    b => 'blue',
    c => 'cyan',
    m => 'magenta',
    y => 'yellow',
    w => 'white',
);
sub markup {
    my ($line, $mark) = @_;
    my $out = '';
    my $current = '';
    for (my $i = 0; $i < length($line); $i++) {
        my $hilite = $mark->[$i] ? $mark->[$i][0] : '';
        if ($current ne $hilite) {
            $out .= '</span>' if $current;
            $out .= qq[<span class="hilite_$color_map{$hilite}">]
              if $hilite;
            $current = $hilite;
        }
        $out .= substr($line, $i, 1);
    }
    $out .= '</span>' if $current;
    return $out;
}

sub parse {
    my ($code, $directives) = @_;
    my @map;
    my $num = 0;
    for my $line (@$code) {
        $num += 1;
        for my $dir (@$directives) {
            next unless $dir =~ s/\s+$num\s*//;
            my $repeat_char = '';
            for (my $i = 0; $i < length($line); $i++) {
                no warnings;
                my $char = substr($dir, $i, 1) || '';
                $char = '' if $char eq ' ';
                $repeat_char = $char eq '+'
                  ? substr($dir, $i - 1, 1)
                  : $char
                    ? ''
                    : $repeat_char;
                $char = undef if $char eq '+';
                $char ||= $repeat_char
                  if $repeat_char;
                push @{$map[$num - 1]->[$i]}, $char
                  if $char;
            }
        }
    }
    return \ @map;
}

sub split {
    my $text = $self->text;
    my @lines = map {chomp; $_} ($text =~ /^(.*\n?)/gm);
    my(@code, @directives);
    
    while (@lines) {
        last if $lines[0] =~ /^[rgb\+\ ]+\d+$/;
        push @code, shift @lines;
    }
    pop @code while (@code and $code[-1] eq '');
    for (reverse @lines) {
        next unless ($_ or @directives);
        last unless $_;
        unshift @directives, $_;
    }
    return (\@code, \@directives);
}

package Spork::Hilite;

__DATA__

=head1 NAME

Spork::Hilite - Hilite Code Snippets in Spork

=head1 SYNOPSIS

=head1 DESCRIPTION

This plugin lets you mark code snippets with specific colors. It is
especially good for changing colors several times on the same snippet.

=head1 AUTHOR

Brian Ingerson <ingy@cpan.org>

=head1 COPYRIGHT

Copyright (c) 2005. Brian Ingerson. All rights reserved.

This program is free software; you can redistribute it and/or modify it
under the same terms as Perl itself.

See http://www.perl.com/perl/misc/Artistic.html

=cut
__css/hilite.css__
.hilite_red     { color: red;}
.hilite_green   { color: green;}
.hilite_blue    { color: blue;}
.hilite_yellow  { color: yellow;}
.hilite_cyan    { color: cyan;}
.hilite_magenta { color: magenta;}
.hilite_white   { color: white;}
