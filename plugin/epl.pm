#!/usr/bin/perl
package plugin::epl;

use plugin;
push(@ISA, 'plugin');
my $package = __PACKAGE__;
$plugin::plugins{$package}++;


use POSIX qw/strftime/;
my $url = "http://www.epl.ee/koomiks.php";



sub get_url {
	my $this = shift;
	my $t = $_[0] ? shift : time;
	my $date = strftime("%Y-%m-%d", localtime($t));

	local $_ = $this->fetch_url("$url?KP=$date") or return;

	s/>/$&\n/gm;
	@_ = split /[\r\n]+/;
	while ($_ = shift(@_)) {
		next unless m#<img src="(http://images\.epl\.ee/g/pics/.+)" alt="(.+)" border="0">#;
		$this->add_comic($1, $2);
	}
}

1;
