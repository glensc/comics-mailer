#!/usr/bin/perl
package plugin::epl;

use plugin;
push(@ISA, 'plugin');
my $package = __PACKAGE__;
$plugin::plugins{$package}++;


my $baseurl = "http://www.epl.ee/koomiks.php";

sub get_url {
	my $this = shift;
	my $date = $this->strftime("%Y-%m-%d");

	local $_ = $this->fetch_url("$baseurl?KP=$date") or return;

	s/>/$&\n/gm;
	@_ = split /[\r\n]+/;
	while ($_ = shift(@_)) {
		next unless m#<img src="(http://static\.epl\.ee/g/pics/.+)" alt="(.+)" border="0"#;
		$this->add_comic($1, $2);
	}
}

1;
