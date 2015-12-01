#!/bin/perl -w

my $in = 'in.txt';
my $fh;

open($fh, '<', $in) or $fh = \*STDIN;

my $floor = 0;
my $x;
my $p = 1;
while (read($fh, $x, 1)) {
  $floor +=1 if($x eq '(');
  $floor -=1 if($x eq ')');
  last if ($floor  == -1);
  $p +=1;
}
close $fh;
print "final floor: $floor at position $p\n";
