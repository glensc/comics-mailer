package plugin::xkcd;

use strict;
use warnings;
use base 'plugin';
use HTML::TreeBuilder;

my $package = __PACKAGE__;
$plugin::plugins{$package}++;

my $baseurl = 'http://xkcd.com/';

sub get_url {
	my $this = shift;

	my $content = $this->fetch_url($baseurl) or die("Can't fetch $baseurl");
	my $root = HTML::TreeBuilder->new;
	$root->parse($content);

	my $c = $root->look_down(_tag => 'div', id => 'comic') or die("Can't find div#comic");
	my $p = $c->find('img');

	my $m = $root->look_down(_tag => 'div', id => 'middleContainer') or die("Can't find div#middleContainer");
	my ($l) = $m->as_text =~ m{Permanent link to this comic: (\w+://[^\s]+)};

	$this->add_comic($p->attr('src'), $p->attr('alt').': '.$p->attr('title'), $l);
}


