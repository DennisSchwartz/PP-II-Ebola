#!/usr/bin/env perl;

=for comment
:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

Author: Dennis Schwartz
Date: 18th December 2014

Extract Distributions from SNAP2 output.

Input: SNAP2 raw output

Output: TODO

:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
=cut

use strict;
use warnings;
use Set;
use DrawSNAP;


my $file;
my $pVal;
#my $output;

if(!defined $ARGV[0]){
    print "No input file specified!\n";
    print "Usage: perl $0 <path/to/inputfile> <p-Value>";
    exit 1;
}

if(!defined $ARGV[1]) {
	print "No cutoff set, using 5% p-Value.";
	print "Usage: perl $0 <path/to/inputfile> <p-Value>";
	$pVal = 5;
} else {
	$pVal = $ARGV[1];
}

##### GLOBAL VARS ######
$file = $ARGV[0];
my $subst_file = $ARGV[2];


open (my $subst_FH, "< $subst_file") or die "Can't open $subst_file for read: $!";

my @substitutions;

while (<$subst_FH>) {
	chomp $_;
	push (@substitutions, $_);
}
#print @substitutions;

close $subst_FH or die "Cannot close $file: $!";


open (FH, "< $file") or die "Can't open $file for read: $!";

my $currentPos = 0;
my $prevPos = 0;
my @set;
my @result;

my $line = <FH>;
($currentPos) = $line =~ m/\w(\d*)\w\s/;
push (@set, $line);
my $mean = -101;

while (<FH>) {
	#Set next position
	$prevPos = $currentPos;
	#Read new Line
	$line = $_;
	#Extract current position
	($currentPos) = $line =~ m/\w(\d*)\w\s/;
	#Check for new position
	if ($currentPos != $prevPos) {
		#If new position,
		#do sth. with current set
		#print "Position: ${currentPos}\n";
		#print_set(@set);
=for comment
		my @scores = get_scores(@set);
		#print "scores: @scores \n";
		$mean = mean(@scores);
		#then start new set.
		my $currentSet = "Position: ${prevPos}\nscores: @scores \n";
		if (defined($mean)) {
			$currentSet = "${currentSet}Mean: ${mean} \n";
		} else {
			$currentSet = "${currentSet}mean undefinded!";
		}
		#print $currentSet;
		#push (@sets, $currentSet);
		my $setObj = new Set($prevPos, \@scores, $mean);
		push (@sets, $setObj);
		undef(@set);
=cut
		foreach my $s (@substitutions) {
			foreach my $x (@set) {
				my ($currentSubst) = $x =~ m/(\w\d*\w)\s/;
				#print "$s - $currentSubst\n";
				if ($s eq $currentSubst) {
					push (@result, $x);
				}
			}
		}
		undef (@set);


	}

	push (@set, $line);
	#print $currentPos, "\n";
}

close FH or die "Cannot close $file: $!";


print @result;
=for comment
#++++++++++++++ Write last set ++++++++++++++++++#
my @scores = get_scores(@set);
$mean = mean(@scores);
my $currentSet = "Position: ${prevPos}\nscores: @scores \n";
if (defined($mean)) {
	$currentSet = "${currentSet}Mean: ${mean} \n";
} else {
	$currentSet = "${currentSet}mean undefinded!";
}
my $setObj = new Set($prevPos, \@scores, $mean);
push (@sets, $setObj);
undef(@set);

#++++++++++++++ Extract means & Print ++++++++++++++++++#

my @means;

foreach my $x (@sets) {
	# Print sets
	#$x->myPrint();
	# Get mean of position
	push (@means, $x->getMean());
}
#print (@sets);



#++++++++++++++ Calculate 5th percentile ++++++++++++++++++#

@means = sort { $a <=> $b } @means;
#print "\n" x 5, "Means: @means", "\n" x 5;
my $meanSize = @means;
my $fifth = ( $meanSize / 100) * $pVal;
$fifth = int $fifth;
print "Fifth percentile cutoff: $fifth\n";
print "Positions: $meanSize\n";
my $cutoff = $means[$meanSize - $fifth];
print "Cutoff Value: $cutoff\n\n";


#++++++++++++++ Get significant Positions ++++++++++++++++++#

my @significantPositions;

foreach my $x (@sets) {
	#Check set for significant mean;
	if ( $x->getMean() > $cutoff ) {
		push (@significantPositions, $x->getPosition());
	}
}

print "Significant Positions: @significantPositions\n";



#++++++++++++++ Read binding sites ++++++++++++++++++#

my @binding_sites;

open (FH2, "< $subst_file") or die "Can't open $subst_file for read: $!";
while (<FH2>) {
	push (@binding_sites, $_);
}
close FH2 or die "Cannot close $file: $!";


#++++++++++++++ Test draw class ++++++++++++++++++#

my $sequence = 'MEASYERGRPRAARQHSRDGHDHHVRARSSSRENYRGEYR
QSRSASQVRVPTVFHKKRVEPLTVPPAPKDICPTLKKGFL
CDSSFCKKDHQLESLTDRELLLLIARKTCGSVEQQLNITA
PKDSRLANPTADDFQQEEGPKITLLTLIKTAEHWARQDIR
TIEDSKLRALLTLCAVMTRKFSKSQLSLLCETHLRREGLG
QDQAEPVLEVYQRLHSDKGGSFEAALWQQWDRQSLIMFIT
AFLNIALQLPCESSAVVVSGLRTLVPQSDNEEASTNPGTC
SWSDEGTP';

my $figure = new DrawSNAP($sequence, \@significantPositions, \@binding_sites);

$figure->draw();

print "=" x 20,  "All done!", "=" x 20, "\n";

=cut
#++++++++++++++ Subroutines ++++++++++++++++++#

sub print_set {
	print "=" x 20,  "New Set!", "=" x 20, "\n";
	print @_;
}

sub get_scores {
	my @dist;
	my $score = undef;
	#For all mutations at current position
	#a.k.a all lines of the current set
	for (@_) {
		#extract score
		($score) = $_ =~ m/sum\s=\s(-*\d*)/;
		#if regex matched a score (i.e. every other line)
		if (defined($score)) {
			#print $score, ",\n";
			#save score to array
			push(@dist, $score);
		}

	}
	return @dist;
}

sub median {
    my @a = sort {$a <=> $b} @_;
    my $length = scalar @a;
    return undef unless $length;
    ($length % 2)
        ? $a[$length/2]
        : ($a[$length/2] + $a[$length/2-1]) / 2.0;
}

sub sum {
    my $total = 0;
    $total += $_ for (@_);
    $total;
}

sub mean {
    @_ ? sum(@_) / (scalar @_) : undef;
}