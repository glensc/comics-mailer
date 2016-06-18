package plugin::nsfw;

use strict;
use warnings;
use base 'plugin';
use HTML::TreeBuilder;

my $package = __PACKAGE__;
$plugin::plugins{$package}++;

my $baseurl = "http://nsfw-comix.com/nsfw.htm";

sub get_url {
	my $this = shift;

	my $content = $this->fetch_url($baseurl) or return;
	my $root = HTML::TreeBuilder->new;
	$root->parse($content);

	my $p = $root->look_down( _tag => 'span', class => 'style1');

	my @l = $root->look_down(_tag => 'img');
	my $img;

	foreach my $l (@l) {
		if( $l->attr('src') =~ /^comix\// ) {
			$img = 'http://nsfw-comix.com/'.$l->attr('src');
			last;
		}
	}

	if ($p) {
		$this->add_comic($img, $p->as_text, $baseurl);
	}
}

1;
