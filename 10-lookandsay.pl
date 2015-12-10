#!/bin/perl

use strict;
use warnings;

my $input = readline;
chomp $input;
my $value = $input;

for my $cycle (1..50) {
  my $newvalue;
  my @chars = split '', $value;
  my $cur_char = shift @chars;
  my $count = 1;
  for my $next_char(@chars) {
    if ($next_char == $cur_char) {
      $count += 1;
    }
    else {
      $newvalue = $newvalue . "${count}${cur_char}";
      $count = 1;
      $cur_char = $next_char;
    }
  }
  # parse the last char
  $newvalue = $newvalue . "${count}${cur_char}";
#  print "Cycle ${cycle}: $value -> $newvalue\n";
  $value = $newvalue;
}

print "After 40 cycles length of output is: ". length ($value) . "\n";
