package plugin::mrlovenstein;

use strict;
use warnings;
use base 'plugin';
use HTML::TreeBuilder;

my $package = __PACKAGE__;
$plugin::plugins{$package}++;

my $baseurl = "http://www.mrlovenstein.com";

sub get_url {
	my $this = shift;

	my $content = $this->fetch_url($baseurl) or return;
	my $root = HTML::TreeBuilder->new()->parse($content);

	my $title= $root->look_down(_tag => 'title')->as_text;
	my $img= $baseurl.$root->look_down(_tag => 'img', id => 'comic_main_image')->attr('src');

	my @l = $root->look_down(_tag => 'div', class => 'menu_button');
	my $url;
	foreach my $l (@l) {
		if( $l->find('img')->attr('src') =~ /^\/images\/nav_last.png$/ ) {
			$url=$baseurl.$l->look_down(_tag => 'a')->attr('href');
			last;
		}
	}

	if($img){
		$this->add_comic($img, $title, $url);
	}
}

1;
