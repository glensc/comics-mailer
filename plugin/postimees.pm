#!/usr/bin/perl
package plugin::postimees;

use plugin;
push(@ISA, 'plugin');
my $package = __PACKAGE__;
$plugin::plugins{$package}++;


my $baseurl = "http://www.postimees.ee";

sub get_url {
	my $this = shift;

	my $a = sprintf("%s/%s/vabal_ajal/koomiks/index.php", $baseurl, $this->strftime("%d%m%y"));
	local $_ = $this->fetch_url($a) or return;

	@_ = split /\n+/;
	my ($url, $desc);
	while (defined($_ = shift(@_))) {
		if (m#class="TextRedBig"><b>(.*?)</b></a>#) {
			$desc = $1;
		}

		if (m#<img src="(/foto/\d+/\d+/[\da-f]+\.\w+)" width="\d+" height="\d+" alt=""> </span>#) {
			$url = $1;

			$this->add_comic("$baseurl$url", $desc);
			undef $url; undef $desc;
		}
	}
}

1;
