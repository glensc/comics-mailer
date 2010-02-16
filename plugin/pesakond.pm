#!/usr/bin/perl
package plugin::pesakond;

use plugin;
push(@ISA, 'plugin');
my $package = __PACKAGE__;
$plugin::plugins{$package}++;

my $url = 'http://www.jippii.ee/ee/fun/pesakond/';

sub get_url {
	my $this = shift;
	local $_ = $this->fetch_url($url) or return;

	@_ = split /[\r\n]+/;
	while ($_ = shift(@_)) {
		next unless m#/ee/fun/koom/#;
		next unless /<img.+?src="(.+?)".*>/i;
		return sprintf("http://www.jippii.ee%s", $1);
	}
}

1;
