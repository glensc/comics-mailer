package plugin::postimees;

use strict;
use warnings;
use base 'plugin';
use HTML::TreeBuilder;

my $package = __PACKAGE__;
$plugin::plugins{$package}++;

my $baseurl = 'http://www.postimees.ee/koomiks';

sub get_url {
	my $this = shift;

	my $content = $this->fetch_url($baseurl) or return;

	my $root = HTML::TreeBuilder->new;
	$root->parse($content);

	my $c = $root->look_down(_tag => 'div', class => 'dailyComics') or return;
	my @l = $c->look_down(_tag => 'img');

	foreach my $l (@l) {
		my $img = $l->attr('src');
		if( $img !~ /^(http|HTTP)/ ) { $img='http:'.$img; }
		(my $title = $l->attr('alt')) =~ s/ -  \d+\. \w+ \d+//;
		$this->add_comic($img, $title, $baseurl);
	}
}

1;
