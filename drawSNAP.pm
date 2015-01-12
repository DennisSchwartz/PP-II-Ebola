#!/usr/bin/perl;

=for comment
:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

Author: Dennis Schwartz
Date: 7th January 2015

Paint visualization of SNAP2 output in comparison to ISIS binding site prediction

Input:

Output:

:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
=cut


use strict;
use warnings;
use SVG;

=for comment
#create SVG object
my $svg = SVG->new(width=>400,height=>200);

my $y=$svg->group(
	id		=> 'group_y',
	style 	=> {
		'fill-opacity'	=>0.5,
		'fill'	=>'rgb(0,255,0)',
		'stroke'	=>'rgb(255,0,0)'
	}
);

#add rect
$y->rect(
	x=>100, y=>100,
	width=>20, height=>20,
	rx=>0, ry=>0,
	id=>'rect_in_group_y');

print $svg->xmlify(-namespace=>'svg');
=cut

package DrawSNAP;
sub new
{
	my ($class, $sequence, $significantPos, $bindingSites) = @_;
	my $self = {
		#_name 			=> $name,
		_sequence 		=> $sequence,
		_sigPos 		=> $significantPos,
		_binding_sites 	=> $bindingSites
	};
	bless $self, $class;
	return $self;
}

sub draw {
	my( $self ) = @_;
	#Define spacing
	my $hor_spacing = 15;
	my $ver_spacing = 30;
	my $dot_height 	= 10;
	my $dot_width 	= 10.085;
	#Calculate necessary width from seq. length
	my $seq_length = length $self->{_sequence};
	my $width = 2 * $hor_spacing + $dot_width * $seq_length;
	#create SVG object
	my $svg = SVG->new(width=>$width,height=>200);

#	#++++++++++++++ Drawing sequence ++++++++++++++++++#
#
#	my $sequenceText = $svg->text(
#			id 		=> 'sequence',
#			x 		=> $hor_spacing + 8,
#			y 		=> $ver_spacing,
#			-cdata	=> $self->{_sequence}
#		);

	#++++++++++++++ Drawing significant SNAP2 sites ++++++++++++++++++#

	#Coloring for sig. positions
	my $sigPosGrp = $svg->group(
		id 		=> 'sigPosGrp',
		style	=> {
			'fill'		=> 'rgb(255,0,0)',
			'stroke'	=> 'rgb(0,0,0)'
		});

	#Fill sig. positions
	my $sigPos = $self->{_sigPos};
	for ( @$sigPos ) {
		$sigPosGrp->rect(
			x=>$hor_spacing + $_ * $dot_width,
			y=>$ver_spacing + 10,
			width=>$dot_width - 2, height=>$dot_height,
			rx=>0, ry=>0,
			id=>'sig_position-'.$_);
	}

	#++++++++++++++ Drawing NON-significant SNAP2 sites ++++++++++++++++++#

	#Coloring for non-sig. positions
	my $nonSigPosGrp = $svg->group(
		id 		=> 'NonSigPosGrp',
		style	=> {
			'fill'		=> 'rgb(0,0,0)',
			'stroke'	=> 'rgb(0,0,0)'
		});

	#Copy sig. positions to hash
	my %sigPosHash;
	@sigPosHash{@$sigPos} = ();

	#Fill non-sig. positions
	for (my $i=1; $i <= $seq_length; $i++) {
			$nonSigPosGrp->rect(
				x=>$hor_spacing + $i * $dot_width,
				y=>$ver_spacing + 10,
				width=>$dot_width - 2, height=>$dot_height,
				rx=>0, ry=>0,
				id=>'non_sig_position-'.$i)
			if !exists $sigPosHash{$i};
	}

	#++++++++++++++ Drawing binding sites ++++++++++++++++++#

	#Coloring for binding sites
	my $bndSiteGrp = $svg->group(
		id 		=> 'bndSiteGrp',
		style	=> {
			'fill'		=> 'rgb(0,0,255)',
			'stroke'	=> 'rgb(0,0,0)'
		});

	#Fill binding sites
	my $bndSites = $self->{_binding_sites};
	for ( @$bndSites ) {
		$bndSiteGrp->rect(
			x=>$hor_spacing + $_ * $dot_width,
			y=>$ver_spacing + 10 + 20,
			width=>$dot_width - 2, height=>$dot_height,
			rx=>0, ry=>0,
			id=>'binding_site-'.$_);
	}

=for comment
	#++++++++++++++ Drawing NON-binding sites ++++++++++++++++++#

	#Coloring for non-binding sites
	my $nonBndSiteGrp = $svg->group(
		id 		=> 'nonBndSiteGrp',
		style	=> {
			'fill'		=> 'rgb(30,30,30)',
			'stroke'	=> 'rgb(0,0,0)'
		});


	#Copy binding sites to hash
	my %bndSiteHash;
	@bndSiteHash{@$bndSites} = ();
	print %bndSiteHash;

	#Fill NON-binding sites
	for (my $i=1; $i <= $seq_length; $i++) {
		$nonBndSiteGrp->rect(
			x=>$hor_spacing + $i * $dot_width,
			y=>$ver_spacing + 20,
			width=>$dot_width - 2, height=>$dot_height,
			rx=>0, ry=>0,
			id=>'non_binding_site-'.$i)
		if !exists $bndSiteHash{$i};
	}
=cut
	#++++++++++++++ Print SVG-File ++++++++++++++++++#

	open (my $fh, '>', 'test_output.svg') or die "Can't open bla for read: $!";
	print $fh $svg->xmlify(-namespace=>'svg');
	close $fh;
}
1;













