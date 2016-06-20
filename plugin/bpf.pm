package plugin::bpf;

use strict;
use warnings;
use base 'plugin';
use XML::Feed;
use HTML::TreeBuilder;

my $package = __PACKAGE__;
$plugin::plugins{$package}++;

my $baseurl = "http://pbfcomics.com/feed/feed.xml";

sub get_url {
	my $this = shift;
	my $content = $this->fetch_url($baseurl) or return;

	my @items = XML::Feed->parse(\$content)->entries;
	my $url = $items[0]->link;

	my $content2 = $this->fetch_url($url) or return;

	my $root = HTML::TreeBuilder->new()->parse($content2);

	my $title = $root->look_down(_tag => 'meta', property => 'og:title')->attr('content');
	my $img = $root->look_down(_tag => 'meta', property => 'og:image')->attr('content');

	if($img) {
		$this->add_comic($img, $title, $url);
	}
}

1;
