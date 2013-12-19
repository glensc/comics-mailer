package plugin::deathbulge;

use strict;
use warnings;
use base 'plugin';
use HTML::TreeBuilder;

my $package = __PACKAGE__;
$plugin::plugins{$package}++;

my $baseurl = "http://www.deathbulge.com";

sub get_url {
	my $this = shift;
	my $content = $this->fetch_url($baseurl) or return;

	my $root = HTML::TreeBuilder->new()->parse($content);

	my $c = $root->look_down(_tag => 'div', id => 'comic')->find('img');

	$this->add_comic($baseurl.$c->attr('src'), "deathbulge", $baseurl);
}

1;
