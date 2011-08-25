#!/usr/bin/perl
package plugin::postimees;

use strict;
use base 'plugin';

my $package = __PACKAGE__;
$plugin::plugins{$package}++;

my $baseurl = 'http://www.postimees.ee';

sub get_url {
	my $this = shift;

	my $a = sprintf("%s/?r=202&d=%s", $baseurl, $this->strftime("%Y%m%d"));
	local $_ = $this->fetch_url($a) or return;

	@_ = split /\n+/;
	my ($url, $desc);

	while (defined($_ = shift(@_))) {
		last if /<div class="koomiks_link_vasak">/;
	}

	while (defined($_ = shift(@_))) {
		if (m#<a href="\?r=202[^"]+">(\S.+)</a>#) {
			$desc = $1;
			next;
		}

		if (m#<img.*? src="(http://f.postimees.ee/s/koomiks/.+)".*?/>#) {
			$url = $1;
			$this->add_comic($url, $desc);
			undef $url; undef $desc;
		}

		last if m#<div class="koomiks_link_vasak">#;
	}
}

1;
