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

# MBOX full mega.blond@mail.ee

my @links = (
	'glen@delfi.ee'
);


$p->mail_attach(@attach);
