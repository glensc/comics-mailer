#!/usr/bin/perl -w
# $Id$
# Date: 21/11/2002
# Author: glen@delfi.ee
#
# Fetches from various websites comics and sends them away with email
# Can do email with image attachments and just with url to direct resouce

use lib 'plugin';

#use plugin::pesakond;
#use plugin::everyday;
use plugin::epl;
use plugin::postimees;

my $debug = 1 if -t STDERR;

my @data;
foreach (keys(%plugin::plugins)) {
	my $p = new $_;
	$p->get_url();
	$p->fetch_gfx();
	push(@data, $p->get_data());
}

use Data::Dumper;
#print Dumper(\@data);

# make html part
use MIME::Entity;
my $entity = build MIME::Entity
	'To'                => 'glen@delfi.ee',
#	'BCC'				=> 'viki_ng@hotmail.com, orc@infoweb.ee, lendya@home.se, garryq@online.ee, mait.tafenau@delfi.ee, aiq@jofo.ee, ilmars@online.ee, pardla@delfi.ee, restless.dead@mail.ee, Andres.Kullaste@riigikogu.ee, dustin@online.ee, grunge11@mail.ee, mega.blond@mail.ee, carter@online.ee, darkangel@solo.delfi.ee, alar.kuuda@microlink.ee',
    'Subject'			=> 'DAILY: comics at estonian web',
	'Reply-To'			=> 'glen@delfi.ee',
	'List-Help:'		=> '<mailto:glen@online.ee>',
	'List-Unsubscribe:'	=> '<mailto:glen@online.ee>',
	'List-Post:'		=> '<mailto:glen@online.ee>',
    'Type'				=> 'multipart/related';


my $body = '<!doctype html public "-//w3c//dtd html 4.0 transitional//en">
<html>
<table border=0 bgcolor="#ffffff" cellpadding=0 cellspacing=0 width=574>
';

foreach (@data) {
	foreach (values(%$_)) {
		my %h = %$_;
		next unless $h{content_id};
		$body .= sprintf("<tr><td width=100%%><img border=1 alt=\"%s\" src=cid:%s><br></td></tr>\n",
			$h{desc}, $h{content_id});
	}
}

$body .= '
</table><p>
</html>
';

$entity->attach(Type => 'text/html', 'Data' => $body);



# add attachments
foreach (@data) {
	foreach (values(%$_)) {
		my %h = %$_;
		next unless $h{data};
		$entity->attach(
			'Type' => $h{content_type},
			'Encoding' => 'base64',
			'Content-ID' => "<$h{content_id}>",
			'Filename' => $h{filename},
			'Data' => $h{data},
		);
	}
}

$entity->print(\*STDOUT);


