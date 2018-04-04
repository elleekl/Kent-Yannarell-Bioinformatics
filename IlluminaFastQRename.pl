#!/usr/bin/perl
use strict;
use warnings;

# This script is to rename all the reads in a Illumina Miseq output in the following
# format:
# SampleName_ReadCount;
# followed by the sequences in fastq format

# This program is written so that if an argument for the sequencer header is applied,
# the program will match that header when renaming sequence reads.
# If no argument is supplied, then the program will try matching headers from a pre-set
# array of headers (supplied by sequencing lab in April 2017).

####1. Import sample name from a file;
# All sample names will be saved to an array called "SampleNames";
# The number of samples will be saved in "$SampleSize";
# Input the file names.txt (which user will need to have created beforehand with sample
# names);

print "Please input the file name that contains all the sample names: \n";
open (INFILE, <STDIN>) or die "Can't open <STDIN>\n";
my @SampleNames=<INFILE>;
close(INFILE);
chomp @SampleNames;
my $SampleSize=@SampleNames;

####2. For each sample name, search for the corresponding sample file
# Declare $i to set loop iteration
# Declare $suffix to add ending ".extendedFrags" to each sample file
# Declare $ReadCount to keep track of number of sequences ???
# Declare and define @SeqHeaders, which includes all known headers
# Declare header variable
my $i=0;
my $suffix=".extendedFrags";
my $ReadCount=0;
my @SeqHeader = ('@HWI', '@DBR', '@MISEQ', '@M00626', '@M01323', '@M03023', '@D000758',
'@K00317', '@K00363');
my $header;
# Declare index for SeqHeader
my $j=0;
# Declare length of ARGV
my $ARGVlength=@ARGV;


# Headers use at UIUC Biotech Center: @HWI, @DBR, @MISEQ, @M00626, @M01323, @M03023, 
# @D00758, @D00553, @K00317, @K00363

# For each iteration of the loop where $i=0, is less than the sample size or when it
# increases by one, rename infile as "SampleNames(number).extendedFrags.fastq"
# and rename the outfile as "SampleNames(number).renamed.fastq"
# then open the infile and direct to "infilename" as described above
# then open outfile and direct to "outfilename" as described above
# start ReadCount at 0
# While loop:
# The program opens the "infile" and reads through line by line
# If the line starts with the header as marked by @ARGV (user input argument),
# then rename the line with the title of the file "SamplesNames(number)_Seq(number)

# If the user does not supply an argument, OR if the argument does not match the header 
# in the file, match the first line on the file with the array "SeqHeaders"
# If the first line matches with on the the "SeqHeaders" then rename all lines that start
# with the the SeqHeader as "SampleNames(number)_Seq(number)"
# Then close the infile and close the outfile

# Print "Finished renaming sequences for sample "SampleNames(number)"

for ($i=0; $i<$SampleSize; $i++){
    my $infilename= $SampleNames[$i].$suffix.".fastq";
    my $outfilename= $SampleNames[$i]."renamed.fastq";
    open (INFILE, "<$infilename") or die "can't open $infilename\n";
    open (OUTFILE,">$outfilename") or die "can't open $outfilename\n";
    $ReadCount=0;
    my $firstline = <INFILE>;
	# Reset file handle
	seek INFILE, 0, 0;
    while (my $line=<INFILE>) {
    	if ($ARGVlength > 0) {
    		$header = "$ARGV[0]";    	
        	if ($line =~ /^$header/) {
            	$ReadCount++;
            	$line="$SampleNames[$i]_Seq$ReadCount\n";
#				Print if you want to view what is happening with each sequence
#           	print "Finished renaming sequences for sample $SampleNames[$i] using $header\n";
            	}
            }
    		
        	my $SeqHeaderSize = @SeqHeader;
			for ($j=0; $j<$SeqHeaderSize; $j++) {
				if ($firstline =~ /^$SeqHeader[$j]/) {
					$header = $SeqHeader[$j];
				}
			}        
        	if ($line =~ /^$header/) {
        		$ReadCount++;
            	$line="$SampleNames[$i]_Seq$ReadCount\n";
#				Print if you want to view what is happening with each sequence
#           	print "Finished renaming sequences for sample $SampleNames[$i] using $header\n";
            	}
    	print OUTFILE $line;  
    }
    close (INFILE);
    close (OUTFILE);
    print("Finished renaming sequences for sample $SampleNames[$i]\n");
}