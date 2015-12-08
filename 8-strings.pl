#!/bin/perl

use strict;

my $string_len = 0;
my $newcode_len = 0;
my $code_len = 0;

while (<STDIN>) {
  chomp;
  next unless $_;
  $code_len += length;
  my $str = $_;
# part 1 - decoding
#  $str  =~ s/^"|"$//g;
#  $str =~ s/\\\\/\\/g;
#  $str =~ s/\\"/"/g;
#  $str =~ s/\\x[0-9a-f]{2}/x/g;
#  $string_len += length $str;

# part 2 - encodin
  $str =~ s/\\/\\\\/g;
  $str =~ s/"/\\"/g;
  $str = '"' . $str . '"';
  print $str . "\n";
  $newcode_len += length $str;
}
my $diff = $newcode_len - $code_len;
print "Code length: ${code_len}, String length: ${newcode_len}, diff: $diff \n";
