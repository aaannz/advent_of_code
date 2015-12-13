#!/bin/perl

use strict;
use warnings;
use Data::Dump qw/pp/;
my $graph = {};
my $total_max = -999;
my $total_min = 999;

sub count_hapiness {
  my @seated = @_;
  my $first = shift @seated;
  my $current = $first;
  my $hapiness = 0;
  for (@seated) {
    $hapiness += $graph->{$current}{$_};
    $hapiness += $graph->{$_}{$current};
    $current = $_;
  }
  $hapiness += $graph->{$current}{$first};
  $hapiness += $graph->{$first}{$current};
  return $hapiness;
}

sub explore_seating {
  my $seated = shift;
  my $to_be_seated = shift;
#  print "Exploring seating: seated: ". pp($seated) .", to be seated: ".pp($to_be_seated)."\n";
  if (scalar @$to_be_seated == 1) {
    my @seated = (@$seated, $to_be_seated->[0]);
#    print "Counting hapiness for " . pp(@seated);
    my $happiness = count_hapiness(@seated);
#    print " : $happiness\n";
    if ($happiness > $total_max) {
      $total_max = $happiness;
    }
    elsif ($happiness < $total_min) {
      $total_min = $happiness;
    }
    return;
  }
  for my $next (@$to_be_seated) {
    my @seated = (@$seated, $next);
    my @left = grep !/$next/, @$to_be_seated;
    explore_seating(\@seated, \@left);
  }
}

while (<STDIN>) {
  chomp;
  next unless $_;
  my ($person, $gain, $value, $neighbour) = $_ =~ /(\w+) would (gain|lose) (\d+) happiness units by sitting next to (\w+)/;
  $value = -$value if ($gain eq 'lose');
  print "$person - $neighbour: $value\n";
  $graph->{$person}{$neighbour} = $value;
  # for part two adding myself with 0 gain
  $graph->{$person}{'me'} = 0;
  $graph->{'me'}{$person} = 0
}

explore_seating([], [keys %$graph]);

print "Total MAX happiness: $total_max, MIN happiness: $total_min\n";
