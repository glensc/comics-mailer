package plugin::garfield;

# Garfield
# http://www.listen-project.de/garfield/

use strict;
use warnings;
use base 'plugin';
use HTML::TreeBuilder;

my $package = __PACKAGE__;
$plugin::plugins{$package}++;

my $baseurl = "http://www.listen-project.de/garfield/";

sub get_url {
	my $this = shift;

	my $date = $this->strftime("%d.%m.%Y");
	my $url = "$baseurl?date=$date";
	my $content = $this->fetch_url($url) or die("Can't fetch $url");
	my $root = HTML::TreeBuilder->new;
	$root->parse($content);

	my $img = $root->look_down(_tag => 'img', id => 'content') or die("Can't find img#content");

	(my $title = $img->attr('alt')) =~ s/ from \d+\.\d+\.\d+//;

	$this->add_comic($img->attr('src'), $title, $url);
}

1;
