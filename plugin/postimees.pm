package plugin::postimees;

use strict;
use warnings;
use base 'plugin';
use HTML::TreeBuilder;

my $package = __PACKAGE__;
$plugin::plugins{$package}++;

my $baseurl = 'http://www.postimees.ee';

sub get_url {
	my $this = shift;

	my $url = sprintf("%s/?r=202&d=%s", $baseurl, $this->strftime("%Y%m%d"));
	my $content = $this->fetch_url($url) or return;

	my $root = new HTML::TreeBuilder();
	$root->parse($content);

	my $c = $root->look_down(_tag => 'div', class => 'sisu_keskmine_paremata') or return;

	my @l = $c->look_down(
		_tag => 'div',
		sub {
		   	$_[0]->look_down(_tag => 'div', class => 'koomiks_nimetus')
			&&
		   	$_[0]->look_down(_tag => 'div', class => 'koomiks_pilt')
			&&
			!$_[0]->look_down(_tag => 'div', class => 'clearer')
	   	}
	);

	foreach my $l (@l) {
		my $t = $l->look_down(_tag => 'div', class => 'koomiks_nimetus')->find('a');
		my $p = $l->look_down(_tag => 'div', class => 'koomiks_pilt')->find('img');
		if ($p && $t) {
			$this->add_comic($p->attr('src'), $t->as_text, $url);
		}
	}
}

1;
