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

	my $url = $root->look_down(_tag => 'meta', property => 'og:url') or return;

	my $c = $root->look_down(_tag => 'div', class => 'striben') or return;
	$c = $c->look_down(_tag => 'div', class => 'purple') or return;
	$c = $c->look_down(_tag => 'div', class => 'inner') or return;
	$c = $c->look_down(_tag => 'div', class => 'stribe')->find('img');

	$this->add_comic($baseurl.$c->attr('src'), $c->attr('alt'), $url->attr('content'));
}

1;
