package plugin::wulffmorgenthaler;

use strict;
use warnings;
use base 'plugin';
use HTML::TreeBuilder;

my $package = __PACKAGE__;
$plugin::plugins{$package}++;

my $baseurl = "http://wumo.com/";

sub get_url {
	my $this = shift;

	my $content = $this->fetch_url($baseurl) or return;
	my $root = HTML::TreeBuilder->new()->parse($content);

	my $url = $root->look_down(_tag => 'div', class => 'box-content')->find('img');

	$this->add_comic($url->attr('src'), $url->attr('alt'), $baseurl);
}

1;
