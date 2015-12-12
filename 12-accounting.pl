#!/bin/perl

use warnings;
use strict;

use JSON qw/decode_json/;

my $input = <STDIN>;
chomp $input;
$input = decode_json($input);

# part A
#my @numbers = $input =~ /([-\d]+)/g;
#my $sum = 0;
#for (@numbers) {
#  $sum += $_;
#}

#part B

my $sum = 0;
sub traverse_json {
  my $in = shift;
  if (ref($in) eq 'ARRAY') {
    for my $e (@$in) {
      traverse_json($e);
    }
  }
  elsif (ref($in) eq 'HASH') {
    # check for red firt
    my $red = 0;
    for my $k (keys %$in) {
      if ($in->{$k} =~ /red/) {
        $red = 1;
        last;
      }
    }
    return if ($red);
    for my $k (keys %$in) {
      traverse_json($in->{$k});
    }
  }
  else {
    if ($in =~ /\d+/) {
      $sum += $in;
    }
  }
}

traverse_json($input);

print "Sum is $sum\n";
