=head
Perl script to compute reverse complement 
Author Lalitha Viswanathan
Org TCS 
=cut
%codon_usage="";
if($#ARGV!=0)
{
	print "Usage perl rev_comp.pl <file in single/multifasta format>\n";
	exit(1);
}
process_file(@ARGV[0]);
filewrite();

=head
Perl routine to read file and compute codon usage
=cut
sub process_file
{
$fname=$_[0];
open(fread,$fname);
$line=<fread>;
$totalsentence="";
@DNA_seq="";
@COMP_seq="";
@REV_seq="";@identity="";
$rev="";
	while($line)
	{
		chomp($line);
		if(substr($line,0,1) ne '>')
		{
			$totalsentence.=$line;
		}
		else
		{
			#DNA_sequence
			if($totalsentence)
			{
				push(@DNA_seq,$totalsentence);
			}
			#compute codon usage
			for($counter=0;$counter<length($totalsentence);$counter++)
			{
				$codon=substr($totalsentence,$counter,3);
				if($codon_usage{$codon})
				{
					$codon_usage{$codon}++;
				}
				else
				{
					$codon_usage{$codon}=1;
				}
			}
			#first line
			push(@identity,$line);
			#reverse 
			for($counter=length($totalsentence);$counter>=0;$counter--)
			{
				$rev.=substr($totalsentence,$counter,1);
			}
			if($rev)
			{
				push(@REV_seq,$rev);
			}
			#complement
			$totalsentence =~ tr/ATGC/TACG/;
			if($totalsentence)
			{
				push(@COMP_seq,$totalsentence);
			}
			#initialize
			$rev="";
			$totalsentence="";
		}
		$line=<fread>;
	}
#print pop(@DNA_seq)."\nITs complement is ".pop(@COMP_seq)."and the reverse is \n".pop(@REV_seq);
close(fread);
}

=head
Perl routine to write to file (reverse complement)
=cut
sub filewrite
{
	sort(%codon_usage);
	print "after sorting hash table\n";
	#after writing complement of DNA sequence	
	open(fwrite,">complement.txt");
	foreach ($counter=0;$i<$#COMP_seq;$i++)
	{
		print fwrite $identity[$counter]."\n";
		print fwrite $COMP_seq[$counter]."\n";
	}
	close(fwrite);
	#writing reverse of DNA sequence
	open(fwrite,">reverse.txt");
	foreach ($counter=0;$counter<$#REV_seq;$i++)
	{
		print fwrite $identity[$counter]."\n"; 
		print fwrite $REV_seq[$counter]."\n";
	}
	close(fwrite);
	open(fwrite,">codon_usage.txt");
	foreach $elem (%codon_usage)
	{
		print fwrite $elem."\n";
	}
	close(fwrite);
}
