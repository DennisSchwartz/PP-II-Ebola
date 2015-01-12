#!/usr/bin/perl

package Set;
sub new
{
	my ($class, $position, $scores, $mean) = @_;
	my $self = {
		_position => $position,
		_scores => $scores,
		_mean => $mean,
	};
	bless $self, $class;
	return $self;
}

sub getPosition {
	my( $self ) = @_;
	return $self->{_position};
}

sub getScores {
	my( $self ) = @_;
	return $self->{_scores};
}

sub getMean {
	my( $self ) = @_;
	return $self->{_mean};
}

sub myPrint {
	my( $self ) = @_;
	$scores = $self->{_scores};
	print "Position: $self->{_position}\nScores: ";
	for ( @$scores ) {
		print "$_ ";
	}
	print "\nMean Score: $self->{_mean}\n\n";
}
1;