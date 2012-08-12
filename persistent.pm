package persistent;
use warnings;
use strict;

use Storable qw//;

sub new {
	my $self = shift;
	my $class = ref($self) || $self;
	my $file = shift;

	my $this = {};
	if (-f $file and -s $file) {
		$this = Storable::retrieve($file);
	}

	$this->{_persistent_file} = $file;

	bless($this, $class);
}

sub store {
	my ($this) = @_;

	my $file = $this->{_persistent_file} or return; # already stored
	undef($this->{_persistent_file});

	Storable::store($this, $file);
}

sub DESTROY {
	my $this = shift;
	$this->store;
}

1;
