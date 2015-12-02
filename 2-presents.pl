#!/bin/perl -w

my $sum_area = 0;
my $ribbon = 0;
while (<STDIN>) {
  chomp;
  my ($l, $w, $h) = split /x/;
  my ($x, $y, $z) = ($l*$w, $w*$h, $h*$l);
  my $box_area = 2*$x + 2*$y + 2*$z;
  my $present_area = (sort { $a <=> $b } ($x, $y, $z))[0];
  $sum_area += $box_area + $present_area;
  my ($sx, $sy) = (sort { $a <=> $b } ($l, $w, $h))[0,1];
  my $ribbon_box = 2*$sx+2*$sy;
  my $ribbon_present = $l*$w*$h;
  $ribbon += $ribbon_box + $ribbon_present;
}

print "aread needed: $sum_area, ribbon: $ribbon\n";
