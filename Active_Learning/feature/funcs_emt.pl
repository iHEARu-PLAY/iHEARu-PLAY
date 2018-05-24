

sub round {
	my ($number) = shift;
	return int($number + .5);
}
sub floor {
	my ($number) = shift;
	return int($number);
}
sub ceil {
	my ($number) = shift;
	my $number_int = int($number);
	if ($number_int == $number){
		return $number_int;
	} else {
		return $number_int+1;
	}
}

sub instID_slt{
my $pred = $_[0];
my $sltNr = $_[1];
print "The selected instance Nr. is $sltNr\n";

open (PD, "<$pred");
my %ID_score;
my $n = 0;

while (<PD>){
    if ($_ =~ /\:/){
        my @infs = split(" ", $_);
        if ($infs[1] eq $infs[2]){$ID_score{$infs[0]} = $infs[3];}
        else {$ID_score{$infs[0]} = $infs[4];}
        $n++;
    }
}
print "The total instance Nr is $n\n";
close PD;

my @sltInsts;
my @insts = sort { $ID_score{$a} <=> $ID_score{$b} or $a <=> $b } keys %ID_score;

unless ($sltNr <= $n){$sltNr = $n; print "The select nr. is replaced by total instance Nr.\n ";}
foreach (0..$sltNr-1){$sltInsts[$_] = $insts[$_];}
return @sltInsts;
}

sub instID_slt_rdm {
	my $featfl = shift(@_);
	my $SltInstNr = shift(@_);

	open (FF, "<$featfl");
	my $TlInstNr = 0;
	while (<FF>){
		if (($_ =~ /^[0-9]/)||($_ =~ /^\'(.*)\'/)||($_ =~ /^T/)||($_ =~ /^\-/)){
			$TlInstNr++;
		}
	}
	print "Total instance Nr. is $TlInstNr\n";
	close FF;
	

	unless ($SltInstNr <= $TlInstNr){$SltInstNr = $TlInstNr; print "The select nr. is replaced by total instance Nr.\n ";}
	my $i=0;   
	my %rand;
	while   (1)   { 
		srand();
        my $no   =   int(rand($TlInstNr)) +1;
        if   (!$rand{$no})   {   $rand{$no}=1;   $i++;  }
        last   if   ($i >= $SltInstNr); 
	} 
	my @SltInsts  =   keys   %rand;

	return @SltInsts;
}

sub instID_slt_vote{
	my $predPath = $_[0];
	my $i = $_[1];
	my $pn = $_[2];
	my $sltNr = $_[3];
	my $train = $_[4];
	my %ID_vote;

	open (PF1, "<$predPath/$train.$i.p1.pred");
	my $tn = 0;
	while (<PF1>){
		if ($_ =~ /:/){
			my @infs = split(" ", $_);
			$ID_vote{$infs[0]} = 0;
			$tn++;
		}
	}
	close PF1;

	foreach my $p(1..$pn){
		my $predF = "$predPath/$train.$i.p$p.pred";
		open (PF, "<$predF");
		my $n = 0;
		while (<PF>){
			if ($_ =~ /\:/){
				my @infs = split(" ", $_);
				if ($infs[2] =~ /1\:NSL/){$ID_vote{$infs[0]}++;}
				$n++;
			}
		}
		if ($n != $tn){print "Error: instance Nr is not same between different prediction files.\n";}
		close PF;		
	}
	foreach my $key (keys %ID_vote){
		$ID_vote{$key} = abs($ID_vote{$key} - $pn/2);
	}
	

	my @sltInsts;
	my @insts = sort { $ID_vote{$a} <=> $ID_vote{$b} or $a <=> $b } keys %ID_vote;

	

	unless ($sltNr <= $tn){$sltNr = $tn; print "The select nr. is replaced by total instance Nr.\n ";}
	foreach (0..$sltNr-1){$sltInsts[$_] = $insts[$_];}
	return @sltInsts;
}

sub split_featfile {
	my $featfl = shift(@_);
	my $instsArray = shift(@_);
	my @insts = @$instsArray;
	my $outFeatfl1 = shift(@_);
	my $outFeatfl2 = shift(@_);
	unlink ($outFeatfl1);
	unlink ($outFeatfl2);
	my %split_insts;
	foreach (@insts){
		$split_insts{$_} = 1;
	}
	

	open (OUTF1, ">>$outFeatfl1");
	open (OUTF2, ">>$outFeatfl2");
	my $i = 0;
	open (INF, "<$featfl");
	while (<INF>){
		if (($_ =~ /^[0-9]/)||($_ =~ /^\'(.*)\'/)||($_ =~ /^T/)||($_ =~ /^\-/)){
			$i++;
			if ($split_insts{$i}){print OUTF1 "$_";}
			else {print OUTF2 "$_";}
		}else {
			print OUTF1 "$_";
			print OUTF2 "$_";
		}
	}
	close INF;
	close OUTF1;
	close OUTF2;
}

sub slt_feat{
	my $inArff = shift(@_);
	my $array = shift(@_);
	my $outFeat = shift(@_);
	my @pArray = @$array;
	my %insts;
	foreach (@pArray){
		$insts{$_} = 1;
	}
	unlink ($outFeat);
	open (OUTF, ">>$outFeat");
	my $i = 0;
	open (INF, "<$inArff");
	while (<INF>){
		if (($_ =~ /^[0-9]/)||($_ =~ /\'(.*)\'/)||($_ =~ /^\-\d/)){
			$i++;
			if ($insts{$i}){print OUTF "$_";}
		}else {
			print OUTF "$_";
		}
	}
	close INF;
	close OUTF;
}

sub split_feat_E_R {
	my $inArff = $_[0];
	my $pn = $_[1];
	my $outPath = $_[2];
	
	my $basenm = basename($inArff, ".arff");

	open (FF, "<$inArff");
	my $TlInstNr = 0;
	while (<FF>){
		if (($_ =~ /^[0-9]/)||($_ =~ /\'(.*)\'/)||($_ =~ /^\-\d/)){
			$TlInstNr++;
		}
	}
	print "Total instance Nr. is $TlInstNr\n";
	close FF;	

	my $i=0;   
	my %rand;
	while   (1)   { 
		srand();
        my $no   =   int(rand($TlInstNr)) +1;
	
        if   (!$rand{$no})   {   $rand{$no}=1;   $i++;  }
        last   if   ($i >= $TlInstNr); 
	} 
	my @SltInsts  =   keys   %rand;

	my $avgNr = &ceil($TlInstNr/$pn);

	foreach my $p(1..$pn){
		my $outFeat = "$outPath/$basenm.p$p.arff";	print "$outFeat\n";
		my $start = $avgNr*($p-1); print "start: $start\n";
		my $end = $avgNr*$p-1;	print "end: $end\n";
		unless ($end <= $TlInstNr){$end = $TlInstNr;}
		my @pArray;
		foreach ($start..$end){push (@pArray, $SltInsts[$_]);}
	
		&slt_feat($inArff, \@pArray, $outFeat);
	}
}

sub comb{
	my $inArff1 = $_[0];
	my $inArff2 = $_[1];
	my $outArff = $_[2];
	unlink ($outArff);
	open (OUTF, ">>$outArff");
	open (IN1, "<$inArff1");
	while (<IN1>){
		print OUTF $_;
	}
	close IN1;

	open (IN2, "<$inArff2");
	while (<IN2>){
		my $line;
		if (($_ =~ /^\d/)||($_ =~ /^\'/)||($_ =~ /^\-\d/)){
			$line = $_;
			print OUTF $line;
		} 
	}
	close IN2;
	close OUTF;
}

1;

