#!/bin/perl

use Digest::MD5 qw/md5_hex/;

my $input = <STDIN>;
chomp $input;

my $c = 0;
while (1) {
    my $test = "${input}${c}";
    my $md5 = md5_hex($test);
    last if $md5 =~ /^000000/;
    $c += 1;
}

print "result is: $c\n";
