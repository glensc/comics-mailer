#!/usr/bin/perl
package plugin::postimees;

use plugin;
push(@ISA, 'plugin');
my $package = __PACKAGE__;
$plugin::plugins{$package}++;


my $baseurl = "http://www.nali.postimees.ee";


sub get_url {
	my $this = shift;

	my $a = sprintf("%s/%s/naljakulg.php?SECT=koomiks", $baseurl, $this->strftime("%d%m%y"));
	local $_ = $this->fetch_url($a) or return;

	@_ = split /\n+/;
	my ($url, $desc);
	while (defined($_ = shift(@_))) {
		if (m#<tr><td><p class=TextTitle>(.*?)</td></tr>#) {
			$desc = $1;
		}

		if (m#<td><img src="(/\d+/gfx/[\da-f]+\.\w+)">#) {
			$url = $1;

			$this->add_comic("$baseurl$url", $desc);
			undef $url; undef $desc;
		}
	}
}

1;
