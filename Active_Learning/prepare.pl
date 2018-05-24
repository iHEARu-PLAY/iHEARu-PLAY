#!/usr/bin/perl

use Cwd;
use File::Basename;
my $BaseDir = dirname($0);
require "$BaseDir/funcs_emt.pl";

my $dir = $ARGV[0];

print "\n>>>>>>>>Preparing $dir.\n";
!system ("mkdir \"../$dir\" && mkdir \"../$dir/res\" && mkdir \"../$dir/tmp\"") or die "Can't make direction. Error: $!.\n";
!system ("perl ./feature/split_random.pl $corpus") or die "Can't preduce feature files.Error:$!.\n";
!system ("mv ./feature/$corpus.tr.1.arff \"../$dir/tmp\" && mv ./feature/$corpus.dv.1.arff \"../$dir/tmp\" && cp ./feature/$corpus.tx.arff \"../$dir/tmp\" && cp ./funcs_emt.pl \"../$dir\" && cp ./config.inc \"../$dir\"") or die "Moving feature and function files has problem.Error:$!.\n"; 

1;
