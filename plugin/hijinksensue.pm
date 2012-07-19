#!/usr/bin/perl
package plugin::hijinksensue;

# HijiNKS Ensue
# http://hijinksensue.com/about/
#
# Geeking for the sake of geekery. If you are into sci-fi, technology, geek TV,
# geek movies or geek life in general you should find something to laugh at
# here.

use strict;
use base 'plugin';
use HTML::TreeBuilder;

my $package = __PACKAGE__;
$plugin::plugins{$package}++;

my $baseurl = 'http://hijinksensue.com';
my $feedurl = 'http://feeds.feedburner.com/hijinksensue';

sub get_url {
	my $this = shift;

	my $content = $this->fetch_url($baseurl) or return;
	my $root = new HTML::TreeBuilder;
	$root->parse($content);

	my $title = $root->look_down( _tag => 'h2', class => 'post-title') or return;
	my $url = $title->look_down(_tag => 'a') or return;
	my $img = $root->look_down(_tag => 'div', id => 'comic') or return;
	$img = $img->look_down(_tag => 'img');

	$this->add_comic($img->attr('src'), $title->as_text, $url->attr('href'));
}

1;
