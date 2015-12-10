package plugin::cuek;

use strict;
use warnings;
use base 'plugin';
use HTML::TreeBuilder;

my $package = __PACKAGE__;
$plugin::plugins{$package}++;

my $baseurl = "http://cuek.co";

sub get_url {
	my $this = shift;
	my $content = $this->fetch_url($baseurl) or return;

	my $root = HTML::TreeBuilder->new()->parse($content);

	my $c = $root->look_down(_tag => 'div', id => 'comic') or die("cannot find comic");
	$c = $c->look_down( _tag => 'img') or die("cannot find image");

	if ($c) {
		$this->add_comic($c->attr('src'), $c->attr('alt'), $baseurl);
	}
}

1;
