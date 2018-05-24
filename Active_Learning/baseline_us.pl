#!/usr/bin/perl

use Cwd;
use File::Basename;
my $BaseDir = dirname($0);
require "$BaseDir/funcs_emt.pl";

my $basePath = "$BaseDir/baseline_us";
my $predPath = "$basePath/pred";
my $resPath = "$basePath/res";
my $tmpFeatPath = "$basePath/tmp";

unless (-d $basePath){system("mkdir $basePath");}
unless (-d $predPath){system("mkdir $predPath");}
unless (-d $resPath){system("mkdir $resPath");}
unless (-d $tmpFeatPath){system("cp -r $BaseDir/tmp $basePath");}

my $testArff = "$tmpFeatPath/$corpus.tx.arff";

foreach my $i(1..$iter){
	print "\n----> $i interation\n";

	my $trainArff = "$tmpFeatPath/$corpus.tr.$i.arff";
	my $develArff = "$tmpFeatPath/$corpus.dv.$i.arff";




		
		my $pred = "$predPath/$corpus.$i.pred";
		my $res = "$resPath/$corpus.$i.res";
		my $model = "$tmpFeatPath/$corpus.$i.model";

		my $ustrainArff = "$tmpFeatPath/$corpus.$i.us.arff";
		my $cmd0 = "java -Xmx4096m -classpath $wekaPath weka.filters.supervised.instance.Resample -B 1.0 -S 1 -Z $smpRate -i $trainArff -o $ustrainArff -c last";
		!system($cmd0) or warn "Can't resample $trainArff. Error: $!\n";
	
	
		my $cmd1 = "java -Xmx4096m -classpath $wekaPath weka.classifiers.functions.SMO -v -o -no-cv -C $c -L 0.0010 -P 1.0E-12 -N 0 -V -1 -W 1 -M -K \"weka.classifiers.functions.supportVector.PolyKernel -C 250007 -E 1.0\" -t $ustrainArff -T $develArff -p 0  > $pred";
		!system($cmd1) or warn "Can't produce the prediction of $develArff. Error: $!\n";
		my $cmd2 = "java -Xmx4096m -classpath $wekaPath weka.classifiers.functions.SMO -v -o  -C $c -L 0.0010 -P 1.0E-12 -N 0 -V -1 -W 1 -K \"weka.classifiers.functions.supportVector.PolyKernel -C 250007 -E 1.0\" -t $ustrainArff -T $testArff -i > $res";
		!system($cmd2) or warn "Can't produce the result of $testArff. Error: $!\n";
	



		my @array = &SltID_rdm($develArff, $InstNr);
		print "The instance Nr is $#array+1.\n";
		unless (@array){print "Can't generate selected instance IDs.\n";}
		


		my $ii = $i + 1; 
		my $passArff = "$tmpFeatPath/$corpus.dv.$i.pass.arff";
		my $NewDevelArff = "$tmpFeatPath/$corpus.dv.$ii.arff";

		&feat_insts ($develArff, \@array, $passArff);

		my $v = 1;
		&feat_insts ($develArff, \@array, $NewDevelArff, $v);
		
	


		my $newTrainArff = "$tmpFeatPath/$corpus.tr.$ii.arff";
		&comb($trainArff, $passArff, $newTrainArff);
		
		unlink ($trainArff);
		unlink ($develArff);
		unlink ($passArff);
		unlink ($ustrainArff);		
}

my $last = $iter + 1; 
unlink "$tmpFeatPath/$corpus.dv.$last.arff";
unlink "$tmpFeatPath/$corpus.tr.$last.arff";
unlink $testArff;
1;
