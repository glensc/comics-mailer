package plugin::geekandpoke;

# Geek And Poke

use strict;
use warnings;
use base 'plugin';
use HTML::TreeBuilder;

my $package = __PACKAGE__;
$plugin::plugins{$package}++;

my $baseurl = "https://geek-and-poke.com/";

sub get_url {
	my $this = shift;

	my $content = $this->fetch_url($baseurl) or die("Can't fetch $baseurl");
	my $root = HTML::TreeBuilder->new;
	$root->parse($content);

	my $t = $root->look_down(_tag => 'h1', class => 'entry-title')->find('a');
	my $c = $root->look_down(_tag => 'img', class => 'thumb-image');

	$this->add_comic($c->attr('data-image'), $t->as_text, $baseurl);
}

1;
