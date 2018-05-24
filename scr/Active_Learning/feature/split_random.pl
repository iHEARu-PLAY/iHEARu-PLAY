#!/usr/bin/perl

use strict;
use Cwd;
use File::Basename;
my $BaseDir = dirname($0);
require "$BaseDir/funcs_emt.pl";
print "$BaseDir/funcs_emt.pl\n";
my $corpus = $ARGV[0];
my $infeat = "$BaseDir/$corpus.tr.arff";
my $nr = "200";
my @array = &instID_slt_rdm($infeat, $nr);
print "The selected instance nr is $#array\n";
my $lowArff = "$BaseDir/$corpus.tr.1.arff";
my $highArff = "$BaseDir/$corpus.dv.1.arff";
&split_featfile($infeat, \@array, $lowArff, $highArff);
