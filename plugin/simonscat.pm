#!/usr/bin/perl
package plugin::simonscat;

use HTML::TreeBuilder;

use plugin;
push(@ISA, 'plugin');
my $package = __PACKAGE__;
$plugin::plugins{$package}++;

my $baseurl = "http://www.mirror.co.uk/fun-games/simons-cat/";

sub get_url {
	my $this = shift;
	my ($content, $root, $p, $a, $img, $title, $url);

	$content = $this->fetch_url($baseurl) or return;
	$root = new HTML::TreeBuilder;
	$root->parse($content);

	$p = $root->look_down( _tag => 'div', class => 'storylst-body') or return;
	$a = $p->find('a') or return;
	$url = $a->attr('href') or return;

	$content = $this->fetch_url($url) or return;
	$root = new HTML::TreeBuilder;
	$root->parse($content);

	$p = $root->look_down( _tag => 'div', class => 'cartoons') or return;
	$a = $p->find('a') or return;
	$img = $p->find('img') or return;
	($title = $img->attr('title')) =~ s/ - Click the above image to close this window//;

	$this->add_comic($a->attr('href'), $title, $url);
}

1;
