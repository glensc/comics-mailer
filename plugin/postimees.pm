#!/usr/bin/perl
package plugin::postimees;

use plugin;
push(@ISA, 'plugin');
my $package = __PACKAGE__;
$plugin::plugins{$package}++;


my $baseurl = "http://www.postimees.ee";


sub get_url {
	my $this = shift;

	my $a = sprintf("%s/%s/meelelahutus/koomiks/index.php", $baseurl, $this->strftime("%d%m%y"));
	local $_ = $this->fetch_url($a) or return;

	@_ = split /\n+/;
	my ($url, $desc);
	while (defined($_ = shift(@_))) {
		if (m#<a href="/\d+/koomiks\.php.*?" class="TextRedBig"><b>(.*?)</b></a>#) {
			$desc = $1;
		}

		if (m#<img src="(/\d+/gfx/[\da-f]+\.jpg)" width="\d+" height="\d+">#) {
			$url = $1;

			$this->add_comic("$baseurl$url", $desc);
			undef $url; undef $desc;
		}
	}
}

1;
