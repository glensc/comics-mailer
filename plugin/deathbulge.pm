package plugin::deathbulge;

use strict;
use warnings;
use base 'plugin';
use XML::Feed;

my $package = __PACKAGE__;
$plugin::plugins{$package}++;

my $baseurl = "https://www.deathbulge.com/rss.xml";

sub get_url {
	my $this = shift;
	my $content = $this->fetch_url($baseurl) or return;

	my @items = XML::Feed->parse(\$content)->entries;
	my ($img) = $items[0]->content->body =~ m{src="([^\s]+)"};

	$this->add_comic($img, $items[0]->title, $items[0]->link);
}

1;
