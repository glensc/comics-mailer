package plugin::wulffmorgenthaler;

use strict;
use warnings;
use base 'plugin';
use HTML::TreeBuilder;

my $package = __PACKAGE__;
$plugin::plugins{$package}++;

my $baseurl = "http://wulffmorgenthaler.com/";

sub get_url {
	my $this = shift;

	my $content = $this->fetch_url($baseurl) or return;
	my $root = HTML::TreeBuilder->new()->parse($content);

	my $image = $root->look_down(_tag => 'meta', property => 'og:image') or return;
	my $url = $root->look_down(_tag => 'meta', property => 'og:url') or return;
	my $title = $root->look_down(_tag => 'meta', property => 'og:title') or return;

	$this->add_comic($image->attr('content'), $title->attr('content'), $url->attr('content'));
}

1;
