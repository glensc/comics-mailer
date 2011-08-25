#!/usr/bin/perl
package plugin::cyanide;

use strict;
use base 'plugin';
use HTML::TreeBuilder;

my $package = __PACKAGE__;
$plugin::plugins{$package}++;

my $baseurl = "http://www.explosm.net/comics/";

sub get_url {
	my $this = shift;

	my $content = $this->fetch_url($baseurl) or return;
	my $root = new HTML::TreeBuilder;
	$root->parse($content);

	my $p = $root->look_down( _tag => 'img', alt => 'Cyanide and Happiness, a daily webcomic');
	my $l = $root->look_down(
		_tag => 'font',
		size => '-2',
		sub { $_[0]->as_text =~ /^\[URL=.+\]$/ }
	);
	$l && $l->as_text =~ /^\[URL="(.+?)"\]/;
	$l = $1 || '';

	if ($p) {
		$this->add_comic($p->attr('src'), $p->attr('alt'), $l);
	}
}

1;
