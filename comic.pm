package comic;

# $Id$
# Date: 21/11/2002
# Author: glen@delfi.ee
#
# Fetches from various websites comics and sends them away with email.
# Can do email with image attachments and just with url to direct resource.

use strict;

sub new {
	my $self = shift;
	my $class = ref($self) || $self;
	my $props = shift;

	my $this = { $props ? %$props : () };
	bless($this, $class);
}


sub fetch_data {
	my $this = shift;

	$this->{debug} = 1 if -t STDERR;

	my @data;
	foreach (keys(%plugin::plugins)) {
		my $p = new $_;
		$p->get_url();
		$p->fetch_gfx();
		push(@data, $p->get_data());
	}

	$this->{data} = \@data;
}

sub compose_mail {
	my $this = shift;

	# make html part
	use MIME::Entity;
	my $entity = build MIME::Entity
		'Subject'			=> 'DAILY: comics at estonian web',
		'Reply-To'			=> 'glen@delfi.ee',
		'List-Unsubscribe:'	=> '<mailto:glen-comics@delfi.ee?subject=unsub>',
		'Type'				=> 'multipart/related';


	my $body = '
	<!doctype html public "-//w3c//dtd html 4.0 transitional//en">
	<html>
	<head>
	<meta name="qrichtext" content="1" />
	<style>
	body {
		background-color: white;
	}
	img {
		border: 1px outset black;
		width: 574px;
		display: block;
		padding: 2px;
	}
	b {
		color: #79965f;
		font-size: 12pt;
		font-family: Verdana, Arial, Helvetica;
		font-weight: bold;
		display: block;
		padding-top: 6px;
		padding-left: 6px;
	}
	</style>
	</head>
	<body>
	';

	my @data = @{ $this->{data} };
	foreach (@data) {
		foreach (values(%$_)) {
			my %h = %$_;
			printf "cid: %s\n", $h{content_id} if $main::debug;
			next unless $h{content_id};
			$body .= sprintf("<b>%s</b><img alt=\"%s\" src=\"cid:%s\">\n",
				$h{desc}, $h{desc}, $h{content_id});
		}
	}

	$body .= '
	</body>
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

	$this->{attach} = $entity;
}

sub mailer {
	my $this = shift;
	my $ent = shift;

	my @recip = (ref $_[0] ? $_[0] : @_);

	use Mail::Mailer;

	my $hdr = $ent->head->header_hashref;
	my $body = $ent->stringify_body;
	foreach (@recip) {
		$$hdr{To} = $_;
		my $msg = new Mail::Mailer;
		my $fh = $msg->open($hdr);
		print $fh $body;
		$fh->close;
	}
}

sub dump {
	my $this = shift;
	my $ent = $this->{attach};

	print $ent->head->header_hashref;
	print $ent->stringify_body;
}

sub mail_attach {
	my $this = shift;
	$this->mailer($this->{attach}, @_);
}

1;
