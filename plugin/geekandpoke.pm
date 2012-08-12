package plugin::geekandpoke;

# Geek And Poke
# http://geekandpoke.typepad.com/geekandpoke/

use strict;
use warnings;
use base 'plugin';
use HTML::TreeBuilder;

my $package = __PACKAGE__;
$plugin::plugins{$package}++;

my $baseurl = "http://geekandpoke.typepad.com/geekandpoke/";

sub get_url {
	my $this = shift;

	my $content = $this->fetch_url($baseurl) or die("Can't fetch $baseurl");
	my $root = HTML::TreeBuilder->new;
	$root->parse($content);

	my $a = $root->look_down(_tag => 'a', class => 'asset-img-link') or die("Can't find a.asset-img-link");
	my $img = $a->find('img') or die("Can't find img");

	$this->add_comic($img->attr('src'), $img->attr('title'));
}

1;
