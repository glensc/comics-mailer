#!/usr/bin/perl
package plugin::postimees;

use plugin;
push(@ISA, 'plugin');
my $package = __PACKAGE__;
$plugin::plugins{$package}++;


my $baseurl = "http://www.postimees.ee";


sub get_url {
	my $this = shift;

	local $_ = $this->fetch_url($baseurl) or return;
	my ($url, $last);

	@_ = split /[\r\n]+/;
	while (defined($_ = shift(@_))) {
		$last = $_, next unless m#<font color=\S+>Koomiks</font></a>#;
		
		return unless $last =~ m#<a\s+href="(.+?)".*>#i;
		$url = "$baseurl/$1";
		last;
	}

	return unless $url;

	local $_ = $this->fetch_url($url) or return;

	@_ = split /\n+/;
	while (defined($_ = shift(@_))) {
		next unless m#<font color="[A-Z0-9]{6}"><b>.*</b></font>#;
		my ($u, $d);
		foreach (split(/\cM/, $_)) {
			$d = $1,next if /(?:<font color="\S+"><b>|<br>)([^<]+)$/i;
			$u = $1 if /<img.+?src="(.+?)".*>/i;
			if ($u) {
				$this->add_comic($u, $d);
			}
		}
	}
}

1;
