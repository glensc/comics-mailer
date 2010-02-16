#!/usr/bin/perl
package plugin::xkcd;

use HTML::TreeBuilder;

use plugin;
push(@ISA, 'plugin');
my $package = __PACKAGE__;
$plugin::plugins{$package}++;

my $baseurl = 'http://xkcd.com/';

sub get_url {
	my $this = shift;

    my $content = $this->fetch_url($baseurl) or return;
    my $root = new HTML::TreeBuilder;
    $root->parse($content);

	my $p = $root->look_down(_tag => 'div', id => 'contentContainer') or return;
	$p = $p->look_down(_tag => 'div', class => 's') or return;
	$p = $p->find('img') or return;

	if ($p) {
		$this->add_comic($p->attr('src'), $p->attr('alt').': '.$p->attr('title'));
	}
}

1;
