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

my $seq1 = "MEASYERGRPRAARQHSRDGHDHHVRARSSSRENYRGEYRQSRSASQVRVPTVFHKKRVEPLTVPPAPKDICPTLKKGFLCDSSFCKKDHQLESLTDRELLLLIARKTCGSVEQQLNITAPKDSRLANPTADDFQQEEGPKITLLTLIKTAEHWARQDIRTIEDSKLRALLTLCAVMTRKFSKSQLSLLCETHLRREGLGQDQAEPVLEVYQRLHSDKGGSFEAALWQQWDRQSLIMFITAFLNIALQLPCESSAVVVSGLRTLVPQSDNEEASTNPGTCSWSDEGTP";
my $seq2 = "MERGRERGRSRNSRADQQNSTGPQFRTRSISRDKTTTDYRSSRSTSQVRVPTVFHKKGTGTLTVPPAPKDVCPTLRKGFLCDSNFCKKDHQLESLTDRELLLLIARKTCGSTDSSLNIAAPKDLRLANPTADDFKQDGSPKLTLKLLVETAEFWANQNINEVDDAKLRALLTLSAVLVRKFSKSQLSQLCESHLRRENLGQDQAESVLEVYQRLHSDKGGAFEAALWQQWDRQSLTMFISAFLHVALQLSCESSTVVISGLRLLAPPSVNEGLPPAPGEYTWSEDSTT";

if (length $seq1 != length $seq2) {
	print "Differing sequence lengths!";
	exit 1;
}

my @seq1 = split("", $seq1);
my @seq2 = split("", $seq2);

for (my $i = 1; $i <= length $seq1; $i++) {
	my $a = shift(@seq1);
	my $b = shift(@seq2);
	if ($a ne $b) {
		print "$a$i$b\n";
	}
}

