#!/usr/bin/perl -s
use strict;
use warnings;
use File::BaseDir qw/config_home cache_home/;

use lib '.';
use comic;
use plugin::postimees;
use plugin::cyanide;
use plugin::xkcd;
use plugin::simonscat;
use plugin::wulffmorgenthaler;
use plugin::geekandpoke;
use plugin::pandyland;
use plugin::garfield;

our ($debug, $date);
$debug = 1 if -t STDIN;

my $p = comic->new();

$p->set_date($date) if $date;
# use config_home, as config_files returns only existing files
my $history_file = config_home('comics-mailer.hist');
$p->set_history_file($history_file);
$p->set_http_cache(cache_home("comics-mailer-http.cache")) if $debug;

$p->fetch_data;
$p->compose_mail;

if (@ARGV) {
	$p->mail_attach(@ARGV);
}
