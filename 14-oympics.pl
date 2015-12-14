#!/bin/perl

use strict;
use warnings;
use integer;
use Data::Dump qw/pp/;

my %reindeers = ();

while (<STDIN>) {
  chomp;
  /(\w+) can fly (\d+) km\/s for (\d+) seconds, but then must rest for (\d+) seconds\./;
  $reindeers{$1} = { speed => $2, duration => $3, resting => $4, points => 0, travelled => 0 };
}

my $racetime = 2503;
my $actualtime = 0;

# calculate fly time and rest time for each reindeer
for my $s (1..$racetime) {
  my $maxd = 0;
  my @maxr = ('');
  for my $r (keys %reindeers) {
    my $time = $reindeers{$r}{duration} + $reindeers{$r}{resting};
    my $cycles = $s / $time;
    my $flytime = 0;
    if (($s - ($cycles * $time)) > $reindeers{$r}{duration}) {
      $flytime = ($cycles + 1) * $reindeers{$r}{duration};
    }
    else {
      $flytime = $cycles * $reindeers{$r}{duration} + ($s - ($cycles * $time));
    }
    my $travelled = $reindeers{$r}{speed} * $flytime;
    $reindeers{$r}{travelled} = $travelled;
    if ($travelled > $maxd) {
      @maxr = ($r);
      $maxd = $travelled;
    }
    elsif ($travelled == $maxd) {
      push @maxr, $r;
    }
  }
  for (@maxr) {
    $reindeers{$_}{points} += 1;
  }
}

my $maxpoints = 0;
my $maxr = '';
for my $r (keys %reindeers) {
  my $points = $reindeers{$r}{points};
  if ($points > $maxpoints) {
    $maxpoints = $points;
    $maxr = $r;
  }
}

pp %reindeers;

print "Max points: $maxpoints has $maxr\n";
