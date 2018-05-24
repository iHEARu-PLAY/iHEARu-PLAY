#!/usr/bin/perl

use strict;
use Cwd;
use File::Basename;
my $BaseDir = getcwd();

my $start = shift(@ARGV);
my $end = shift(@ARGV);
my @methods =  @ARGV;

until (-e "../res"){mkdir "../res"};

foreach my $i($start..$end){
	unless (-d "../$i"){
		!system("perl ./prepare.pl $i") or warn "Direction or feature preparation has problem. Error:$!.\n";
	}

	foreach my $method(@methods){
		print "\n$method is running........\n";
		my $basename = basename($method, ".pl");
		!system("cp \"$method\" \"../$i\"") or warn "Coping methods scripts has problem. Error:$!.\n";
		!system("perl \"../$i/$method\"") or warn "Running $method has error. Error:$!.\n";
		!system("perl ./extract_res.pl \"../$i/$basename/res\" \"../$i/res/$basename.res\"") or warn "Can't extract the results of $method.\n";
		print "Done.\n";
        }

}

1;
