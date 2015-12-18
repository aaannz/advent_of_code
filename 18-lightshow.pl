#!/bin/perl
use strict;
use warnings;
use Data::Dump qw/pp/;

my @grid;

my $row = 0;
while (<STDIN>) {
  chomp;
  next unless $_;
  my @row = split //, $_;
  my $column = 0;
  while(@row) {
    my $state = shift @row;
    $grid[$row][$column] = $state eq '#' ? 1 : 0;
    $column++;
  }
  $row++;
}

my $steps = 100;
my $lightson = 0;
my $maxx = scalar @grid - 1;
my $maxy = scalar @{$grid[0]} - 1;
#pp(@grid);
for my $step (1 .. $steps) {
  my @ngrid;
  my $lon = 0;
  # partB, corner lights are always on
  $grid[0][0] = 1;
  $grid[0][$maxy] = 1;
  $grid[$maxx][$maxy] = 1;
  $grid[$maxx][0] = 1;
  for my $x (0 .. $maxx) {
    for my $y (0 .. $maxy) {
      # part B
      if (($x == 0 and $y == 0) or ($x == 0 and $y == $maxy) or
          ($x == $maxx and $y == $maxy) or ($x == $maxx and $y == 0)) {
        $ngrid[$x][$y] = 1;
        $lon++;
        next;
      }
      my $on = 0;
      if ($x > 0) {
        $on++ if ($grid[$x-1][$y]);
        if ($y > 0) {
          $on++ if ($grid[$x-1][$y-1]);
        }
        if ($y < $maxy) {
          $on++ if ($grid[$x-1][$y+1]);
        }
      }
      if ($y > 0) {
        $on++ if ($grid[$x][$y-1]);
        if ($x < $maxx) {
          $on++ if ($grid[$x+1][$y-1]);
        }
      }
      if ($y < $maxy) {
        $on++ if ($grid[$x][$y+1]);
        if ($x < $maxx) {
          $on++ if ($grid[$x+1][$y+1]);
        }
      }
      if ($x < $maxx) {
        $on++ if ($grid[$x+1][$y]);
      }
      if ($grid[$x][$y]) {
        unless ($on == 2 or $on == 3) {
          $ngrid[$x][$y] = 0;
        }
        else {
          $ngrid[$x][$y] = 1;
          $lon++;
        }
      }
      else {
        if ($on == 3) {
         $ngrid[$x][$y] = 1;
         $lon++;
        }
        else {
         $ngrid[$x][$y] = 0;
        }
      }
    }
  }
  @grid = @ngrid;
  $lightson = $lon;
#  pp(@grid);
}

print "Lights on: $lightson\n";
