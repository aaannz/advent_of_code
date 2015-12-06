#!/bin/perl

my $grid = {};

while (<STDIN>) {
  chomp;
  my ($inst, $x1, $y1, $x2, $y2) = $_ =~ /(toggle|turn off|turn on) ([0-9]+),([0-9]+) through ([0-9]+),([0-9]+)/;
  for my $x ($x1..$x2) {
    for my $y ($y1..$y2) {
      if ($inst =~ /toggle/) {
#        $grid->{$x}{$y} = 0 if not defined $grid->{$x};
#        $grid->{$x}{$y} = $grid->{$x}{$y} ? 0 : 1;
         $grid->{$x}{$y} += 2;
      }
      elsif ($inst =~ /turn on/) {
        $grid->{$x}{$y} += 1;
      }
      elsif ($inst =~ /turn off/) {
        $grid->{$x}{$y} -= 1 if $grid->{$x}{$y};
      }
    }
  }
}

my $lighted = 0;
for my $x (keys %$grid) {
  for my $y (keys %{$grid->{$x}}) {
    $lighted += $grid->{$x}{$y};
  }
}

#print "Lighted bulbs: $lighted\n";
print "total brightness: $lighted\n";
