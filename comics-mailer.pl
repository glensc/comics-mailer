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
	glen@dragon.delfi.ee
	orc@infoweb.ee
	garryq@delfi.ee
	mait.tafenau@delfi.ee
	aiq@jofo.ee
	ilmars@delfi.ee
	pardla@delfi.ee
	restless.dead@mail.ee
	Andres.Kullaste@riigikogu.ee
	dustin@online.ee
	carter@delfi.ee
	darkangel@solo.delfi.ee
	alar.kuuda@microlink.ee
);

# MBOX full mega.blond@mail.ee

my @links = (
	'glen@delfi.ee'
);


$p->mail_attach(@attach);
