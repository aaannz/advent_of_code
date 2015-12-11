#!/bin/perl

use strict;
use warnings;

my $input = readline;
chomp $input;

my %char_inctable = ();

sub gen_regex {
  my $out = 'abc';
  for (ord('b')..ord('x')) {
    $out = $out . '|' . chr($_) . chr($_+1) . chr($_+2);
  }
  return $out;
}

my $regex = gen_regex;
$regex = qr/$regex/;

sub inc_password {
  my $pass = shift;
  if ($pass) {
    unless ($pass =~ s/([a-y])$/chr(ord($1)+1)/e) {
      # remove z, we'll add it back shortly
      $pass =~ s/z$//;
      $pass = inc_password($pass) . 'a';
    }
  }
  else {
    $pass = 'a';
  }
  return $pass;
}

my $new_pass = inc_password($input);
while (1) {
  if ($new_pass !~ /[iol]/) {
    if ($new_pass =~ /([a-z])\1/ && $new_pass =~ /([^$1])\1/) {
      if ($new_pass =~ $regex) {
        last;
      }
    }
  }
  $new_pass = inc_password($new_pass);
}

print "New password: $new_pass\n";
