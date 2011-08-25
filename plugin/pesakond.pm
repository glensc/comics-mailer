#!/usr/bin/perl
package plugin::pesakond;

use strict;
use base 'plugin';
use JSON;

my $package = __PACKAGE__;
$plugin::plugins{$package}++;

my $graph_url = 'https://graph.facebook.com/118079068203119/feed';
my $limit = 10;

# access token who can read the wall, you can use yours if you're not afraid
my $access_token = '';

# uid of wall owner (i.e accept posts only from that uid)
my $owner = '118079068203119';

sub get_url {
	my $this = shift;

	my $url = $graph_url . '&access_token=' . $access_token . '&limit=' . $limit;
	my $content = $this->fetch_url($url) or return;

	my $json = JSON->new->decode($content);
	use Data::Dumper;
	foreach my $data (@{$json->{data}}) {
		next unless $data->{from}->{id} eq $owner;
		print "from:", $data->{from}->{id}, "\n";

		next unless defined $data->{name};
	   	next unless $data->{name} eq 'Wall Photos';
		print "name:", $data->{name}, "\n";

		print "Link: ", $data->{link}, "\n";
#		print Dumper \$data;
	}
	die;

}

1;
