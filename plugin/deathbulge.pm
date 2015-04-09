package plugin::deathbulge;

use strict;
use warnings;
use base 'plugin';
use XML::RSS;

my $package = __PACKAGE__;
$plugin::plugins{$package}++;

my $baseurl = "http://www.deathbulge.com/rss.xml";

sub get_url {
	my $this = shift;
	my $content = $this->fetch_url($baseurl) or return;

	my $root = new XML::RSS();
	$root->parse($content);

	my $items = $root->{'items'};

	my ($img) = @$items[0]->{'description'} =~ m{src="([^\s]+)"};
	$this->add_comic($img, @$items[0]->{'title'}, @$items[0]->{'link'});
}

1;
