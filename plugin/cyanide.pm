package plugin::cyanide;

use strict;
use warnings;
use base 'plugin';
use HTML::TreeBuilder;

my $package = __PACKAGE__;
$plugin::plugins{$package}++;

my $baseurl = "https://www.explosm.net/";

sub get_url {
	my $this = shift;

	my $content = $this->fetch_url($baseurl) or return;
	my $root = HTML::TreeBuilder->new;
	$root->parse($content);

	my $p = $root->look_down( _tag => 'img', id => 'featured-comic') or die("cannot find id=featured_comic");
	my $img = $p->attr('src');
	if( $img !~ /^(http|HTTP)/ ) { $img='http:'.$img; }

	my $a = $root->look_down( _tag => 'h3', class => 'zeta small-bottom-margin past-week-comic-title')->find('a');

	if ($p) {
		$this->add_comic($img, $a->as_text, $a->attr('href'));
	}
}

1;
