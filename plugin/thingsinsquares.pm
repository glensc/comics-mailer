package plugin::thingsinsquares;

use strict;
use warnings;
use base 'plugin';
use HTML::TreeBuilder;

my $package = __PACKAGE__;
$plugin::plugins{$package}++;

my $baseurl = "https://www.thingsinsquares.com";

sub get_url {
	my $this = shift;
	my $content = $this->fetch_url($baseurl) or return;

	my $root = HTML::TreeBuilder->new()->parse($content);

	my @c = $root->look_down(_tag => 'div', class => 'entry-content') or return;

	foreach my $c (@c) {
		my $p = $c->find('img');
		my $src = $p->attr('src') or next;
		$src =~ s/^\Qhttps:\E/http:/g;

		my $url = $root->look_down(_tag => 'a', 'rel' => 'bookmark')->attr('href') || $baseurl;

		$this->add_comic($src, $p->attr('alt'), $url);
	}
}

