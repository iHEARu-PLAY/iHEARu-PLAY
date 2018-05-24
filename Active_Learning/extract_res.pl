#!usr/bin/perl

use File::Basename;
$BaseDir = dirname($0);
require "$BaseDir/config.inc"; 

my $inPath = $ARGV[0];
my $outf = $ARGV[1];

unlink $outf;
open (OUTF, ">>$outf");
print OUTF "Train_Nr\tUA\tWA\n";
my @files = `ls --sort=t -v $inPath | grep semi.res -v | grep actv.res -v | grep coActv.res -v | grep tr1 -v | grep tr2 -v`;
foreach my $file(@files){
	my $bn = basename($file, ".res"); 
	chomp $bn;
	$file = "$inPath/".$file;

	open (EF, "<$file");
	my @uas; 
	my @was;
	while (<EF>){
		if ((($_ =~ /$pos$/) || ($_ =~ /$neg/))&& ($_ !~ /\|/) && ($_ !~ /^Classifier/)){
			my @datas = split (" ", $_);
			push (@uas, $datas[3]);
		} elsif ($_ =~ /^Weighted/){
			my @datas = split (" ", $_);
			push (@was, $datas[5]);
		}
	}
	my $ua = 100 * ($uas[0] + $uas[1]) / 2;
	my $wa = 100 * $was[0];
	printf OUTF "%s\t%.2f\t%.2f\n", $bn, $ua, $wa; 
	close EF;
}
close OUTF;
