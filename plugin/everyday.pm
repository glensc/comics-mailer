#!/usr/bin/perl
package plugin::everyday;

use plugin;
push(@ISA, 'plugin');
my $package = __PACKAGE__;
$plugin::plugins{$package}++;


my $cookie = 'wmp4UjtydGxQoF54dfun';
my $url = 'http://www.comics.ee.everyday.com';


sub get_url {
	my $this = shift;
	local $_ = $this->fetch_url(
			"$url/\@$cookie\@/",
			-useragent => 'Mozilla/4.76 [en] (Windows NT 5.0; U)',
			-cookie => $cookie
		) or return;

	@_ = split /[\r\n]+/;
	while ($_ = shift(@_)) {
		print "$_\n";
		next unless m#http://www.comics.ee.everyday.com/.+/picture.phtml\?id=#;
		/id=(\d+)/;
		return sprintf "http://www.comics.ee.everyday.com/picture.phtml?id=%d", $1;
	}
}

1;
