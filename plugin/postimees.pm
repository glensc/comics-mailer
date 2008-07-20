#!/usr/bin/perl
package plugin::postimees;

use plugin;
push(@ISA, 'plugin');
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
		last if /<p class="horoskoop_name">/;
	}

	while (defined($_ = shift(@_))) {
		if (m#^\s+(\S.+) <small>\d{2}.\d{2}.\d{4}</small>#) {
			$desc = $1;
		}

		if (m#<img width="\d+" src="(http://f.postimees.ee/s/koomiks/.+)" alt="" border="0" />#) {
			$url = $1;
			$this->add_comic($url, $desc);
			undef $url; undef $desc;
		}

		last if m#</div>#;
	}
}

1;
