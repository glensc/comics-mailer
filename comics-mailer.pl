#!/usr/bin/perl -w
use strict;

use comic;
use lib 'plugin';

#use plugin::pesakond;
#use plugin::everyday;
#use plugin::epl;
use plugin::postimees;


my $p = new comic;

$p->fetch_data;
$p->compose_mail;

my @attach = (
	'glen@hellsgate.online.ee'
);
my @links = (
	'glen@delfi.ee'
);


$p->mail_attach(@attach);

