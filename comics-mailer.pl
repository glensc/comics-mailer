#!/usr/bin/perl -ws
use strict;

use comic;
use lib 'plugin';
use plugin::postimees;

our ($debug, $date);
$debug = 1 if -t STDIN;

my $p = new comic;

$p->set_date($date) if $date;

$p->fetch_data;
$p->compose_mail;

if (@ARGV) {
	$p->mail_attach(@ARGV);
} else {
	$p->dump;
}
