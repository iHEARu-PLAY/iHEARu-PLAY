#!usr/bin/perl

use File::Basename;
$BaseDir = dirname($0);
require "$BaseDir/config.inc"; 

my $inPath = $ARGV[0];
my $method = $ARGV[1];
my $outPath= $ARGV[2];

my $inFile = "$inPath/res/$method.res";
my $outFileUA = "$outPath/$method.all.ua";
my $outFileWA = "$outPath/$method.all.wa";

unless (-e $inFile){
	print "File $inFile is non-existent.\n";
	exit;
}

unless (-e $outFileUA && -e $outFileWA) {
	open (OUTUA, ">>$outFileUA");
	open (OUTWA, ">>$outFileWA");
	printf OUTUA "Nr\n";
	printf OUTWA "Nr\n";
	open (INF, "<$inFile");
	while(<INF>){
		if ($_ =~ /$corpus/g){
			my @array = split (" ", $_);
			my $iter = shift(@array); 
			printf OUTUA "$iter\n";
			printf OUTWA "$iter\n";
		}
	}
	close INF;
	close OUTUA;
	close OUTWA;
}

my %iter_ua;
my %iter_wa;
open (INF, "<$inFile");
while (<INF>){
	chomp;
	if ($_ =~ /$corpus/){
		my ($iter, $ua, $wa) = split (" ", $_);
		$iter_ua{$iter} = $ua;
		$iter_wa{$iter} = $wa;
	}
}
close INF;

$inPath =~ s/(.*\/)(\d+)/$2/;
print "$inPath\n";
my $outFileUATmp = "$outPath/$method.all.ua.tmp";
open (OUTUAT, ">>$outFileUATmp");
open (OUTUA, "<$outFileUA");
while(<OUTUA>){
	chomp;
	if ($_ =~ /$corpus/){
		my @array = split (" ", $_);
		my $iter = shift(@array); 
		my $nline = "$_\t$iter_ua{$iter}\n";
		printf OUTUAT "$nline";
	}
	elsif ($_ =~ /Nr/){
		my $nline = "$_\t$inPath\n";
		printf OUTUAT "$nline";
	}
}
close OUTUA;
close OUTUAT;

my $outFileWATmp = "$outPath/$method.all.wa.tmp";
open (OUTWAT, ">>$outFileWATmp");
open (OUTWA, "<$outFileWA");
while(<OUTWA>){
	chomp;
	if ($_ =~ /$corpus/){
		my @array = split (" ", $_);
		my $iter = shift(@array); 
		my $nline = "$_\t$iter_wa{$iter}\n";
		printf OUTWAT "$nline";
	}
	elsif ($_ =~ /Nr/){
		my $nline = "$_\t$inPath\n";
		printf OUTWAT "$nline";
	}
}
close OUTWA;
close OUTWAT;

unlink $outFileUA;
unlink $outFileWA;
rename ($outFileUATmp, $outFileUA);
rename ($outFileWATmp, $outFileWA);

1;
