package plugin::simonscat;

use strict;
use warnings;
use base 'plugin';
use HTML::TreeBuilder;

my $package = __PACKAGE__;
$plugin::plugins{$package}++;

my $baseurl = "http://www.mirror.co.uk/fun-games/simons-cat/";

sub get_url {
	my $this = shift;
	my ($content, $root, $p, $a, $img, $title, $url);

	$content = $this->fetch_url($baseurl) or die("Can't fetch $url");
	$root = HTML::TreeBuilder->new(ignore_unknown => 0);
	$root->parse($content);

	$p = $root->look_down(_tag => 'div', class => 'article ma-teaser type-news last') or die("Can't find div.article");
	my $figure = $p->look_down(_tag => 'figure');
	$a = $figure->find('a');
	$url = $a->attr('href');

	$content = $this->fetch_url($url) or die("Can't fetch $url");
	$root = HTML::TreeBuilder->new;
	$root->parse($content);

	# TODO: is this special article or not?
	# http://www.mirror.co.uk/news/uk-news/video-new-simons-cat-video-940810
	$p = $root->look_down(_tag => 'div', class => qr/body/) or die("Can't find div.body");
	$img = $p->find('img');

	$this->add_comic($img->attr('src'), $img->attr('alt'), $url);
}

1;
