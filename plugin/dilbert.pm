package plugin::dilbert;

use strict;
use warnings;
use base 'plugin';
use HTML::TreeBuilder;

my $package = __PACKAGE__;
$plugin::plugins{$package}++;

my $baseurl = "http://dilbert.com";

sub get_url {
    my $this = shift;
    my $content = $this->fetch_url($baseurl) or return;

    my $root = HTML::TreeBuilder->new()->parse($content);

    my $c = $root->look_down(_tag => 'div', class =>
        'comic-item-container') or return;

    my $src = $c->attr('data-image');
    $src =~ s/^\Qhttps:\E/http:/g;

    my $url = $c->attr('data-url') || $baseurl;

    $this->add_comic($src, $c->attr('data-title'), $url);
}
