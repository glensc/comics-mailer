package plugin::catversushuman;

use strict;
use warnings;
use base 'plugin';
use HTML::TreeBuilder;

my $package = __PACKAGE__;
$plugin::plugins{$package}++;

my $baseurl = "http://www.catversushuman.com";

sub get_url {
	my $this = shift;
	my $content = $this->fetch_url($baseurl) or return;

	my $root = HTML::TreeBuilder->new()->parse($content);

	my @c = $root->look_down(_tag => 'div', class => 'post-body entry-content') or return;

  foreach my $c (@c) {
    my $i = $c->look_down(_tag => 'img') or next;
    my $src = $i->attr('src') or next;
    $src =~ s/\Qhttps:\E/http:/g;

    my @t = $c->look_down(_tag => 'div', class => 'separator');
    my $t = @t[1] && @t[1]->as_text || "catversushuman.com";

    $this->add_comic($src, $t, $baseurl);

    # one cat cartoon a day
    last;
  }
}

1;
