package plugin::oglaf;

use strict;
use warnings;
use base 'plugin';
use HTML::TreeBuilder;

my $package = __PACKAGE__;
$plugin::plugins{$package}++;

my $baseurl = "https://oglaf.com";

sub get_url {
	my $this = shift;
	my $content = $this->fetch_url($baseurl) or return;

	my $root = HTML::TreeBuilder->new()->parse($content);

	my $c = $root->look_down(_tag => 'img', id => 'strip');

	if ($c) {
		$this->add_comic($c->attr('src'), $c->attr('alt'), $baseurl);
	}
}

1;
