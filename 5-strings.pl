#!/bin/perl

my $nice = 0;
while (<STDIN>) {
  chomp;
# part 1
#  my $str = $_;
#  for (1..3) {
#     $str =~ s/[aeiou]//;
#  }
#  next unless ((length($_) - length ($str)) == 3);
#  next unless (/([a-z])\1/);
#  next if (/ab|cd|pq|xy/);
# part 2
  next unless (/([a-z]{2}).*\1/);
  next unless (/([a-z])[a-z]\1/);
  $nice += 1;
}

print "Nice strings: $nice\n";
