#!/usr/bin/perl -w
use strict;

use comic;
use plugin::postimees;

our $debug;
$debug = 1 if -t STDIN;

my $p = new comic;

$p->fetch_data;
$p->compose_mail;

if (@ARGV) {
	$p->mail_attach(@ARGV);
} else {
	$p->dump;
}
