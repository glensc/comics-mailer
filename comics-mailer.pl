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
	glen@hellsgate.online.ee
	orc@infoweb.ee
	garryq@delfi.ee
	mait.tafenau@delfi.ee
	aiq@jofo.ee
	ilmars@delfi.ee
	pardla@delfi.ee
	restless.dead@mail.ee
	Andres.Kullaste@riigikogu.ee
	dustin@delfi.ee
	mega.blond@mail.ee
	carter@delfi.ee
	darkangel@solo.delfi.ee
	alar.kuuda@microlink.ee
);

my @links = (
	'glen@delfi.ee'
);


$p->mail_attach(@attach);
