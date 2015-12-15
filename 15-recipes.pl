#!/bin/perl

use strict;
use warnings;
use Data::Dump qw/pp/;

my %i;
my $spoons = 100;

while (<STDIN>) {
  chomp;
  /(\w+): capacity (-?\d+), durability (-?\d+), flavor (-?\d+), texture (-?\d+), calories (-?\d+)/;
  next unless $1;
  $i{$1} = { c => $2, d => $3, f => $4, t => $5, cal => $6, used => 0 };
}

#my $recipe = {c => 0, d => 0, f => 0, t => 0};
my $maxscore = 0;

sub get_score {
  my (%recipe) = @_;
  my ($c, $d, $f, $t, $cal) = (0,0,0,0);
  for my $i (keys %recipe) {
    $c += $i{$i}{c} * $recipe{$i};
    $d += $i{$i}{d} * $recipe{$i};
    $f += $i{$i}{f} * $recipe{$i};
    $t += $i{$i}{t} * $recipe{$i};
    $cal += $i{$i}{cal} * $recipe{$i};
  }
  my $score;
  # part B added $cal != 500 condition
  if ($c < 0 || $d < 0 || $f < 0 || $t < 0 || $cal != 500) {
    $score = 0;
  }
  else {
    $score = $c * $d * $f * $t;
  }
#  print "score for " . pp(%recipe) . " is $score\n";
  return $score;
}
my @map = keys %i;


# three loops and remainder - tailoret to task input - 4 ingrediens
for my $i1 (1 .. 100) {
  for my $i2 (1 .. 100-$i1) {
    for my $i3 (1 .. 100-$i1-$i2) {
      my $i4 = 100 - $i1 - $i2 - $i3;
       my $score = get_score($map[0] => $i1, $map[1] => $i2, $map[2] => $i3, $map[3] => $i4);
       $maxscore = $score if ($score > $maxscore);
    }
  }
}

print "Total score is $maxscore\n";
