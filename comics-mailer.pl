#!/usr/bin/perl -w
use strict;

use comic;
use lib 'plugin';

use plugin::epl;
use plugin::postimees;

our $debug;
$debug = 1 if -t STDIN;

my $p = new comic;

$p->fetch_data;
$p->compose_mail;

my @attach = qw(
	comics@lists.delfi.ee
);

#$p->dump;
$p->mail_attach(@attach);
