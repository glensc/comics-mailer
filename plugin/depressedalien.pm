package plugin::depressedalien;

use strict;
use warnings;
use base 'plugin';
use HTML::TreeBuilder;

my $package = __PACKAGE__;
$plugin::plugins{$package}++;

my $baseurl = "http://www.depressedalien.com";

sub get_url {
	my $this = shift;
	my $content = $this->fetch_url($baseurl) or return;

	my $root = HTML::TreeBuilder->new()->parse($content);

	my $img = $root->look_down(_tag => 'meta', property => 'og:image')->attr('content');
	my $url = $root->look_down(_tag => 'meta', property => 'og:url')->attr('content');
	my $title = $root->look_down(_tag => 'meta', name => 'twitter:title')->attr('content');

	$this->add_comic($img, $title, $url);
}

1;
