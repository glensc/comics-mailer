package comic;

# $Id$
# Date: 2002-11-21
# Author: glen@delfi.ee
#
# Fetches from various websites comics and sends them away with email.
# Can do email with image attachments and just with url to direct resource.

use strict;
use POSIX qw(strftime);
use HTTP::Date qw(str2time);
use HTML::Entities;

sub new {
	my $self = shift;
	my $class = ref($self) || $self;
	my $props = shift;

	my $this = { $props ? %$props : () };
	bless($this, $class);
}

sub set_date {
	my $this= shift;
	my ($date) = @_;
	my $t = str2time($date);
	my $p = strftime('%Y%m%d', localtime($t));
	die "\`$date' isn't valid timestamp (resolves to $p)" unless $date == $p;

	$this->{utime} = $t;
}

=cut
encode $value safe to be used in html attribute.

encoded are:
'&' (ampersand)
'"' (double quote)
''' (single quote)
'<' (less than)
'>' (greater than)
=cut
sub hsc {
	my ($this, $value) = @_;
	my $res = encode_entities($value, q/<>&"'/);
	return $res;
}

sub fetch_data {
	my $this = shift;

	$this->{debug} = 1 if -t STDERR;

	# set fetch time
	$this->{utime} = time() unless $this->{utime};

	my @data;
	foreach (keys(%plugin::plugins)) {
		my $p = new $_;
		$p->set_date($this->{utime});
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
	my $t = strftime('%B %d, %Y', localtime($this->{utime}));
	my $entity = MIME::Entity->build(
		'Subject'			=> "DAILY: comics at estonian web ($t)",
		'Reply-To'			=> 'glen@delfi.ee',
		'List-Unsubscribe:'	=> '<mailto:glen@delfi.ee?subject=unsub-comics>',
		'Type'				=> 'multipart/related',
	);

	my $body = '
	<!doctype html public "-//w3c//dtd html 4.0 transitional//en">
	<html>
	<head>
	<meta name="qrichtext" content="1" />
	<style>
	b { color: #79965f; font-size: 11pt; font-family: Verdana, Arial, Helvetica; font-weight: bold; display: block; padding-left: 6px; }
	blockquote img { border: 1px outset black; display: block; }
	blockquote { background-color: white; width: 600px; border: 12px solid white; }
	</style>
	</head>
	<body><blockquote>
	';

	my @data = @{ $this->{data} };
	foreach (@data) {
		foreach (values(%$_)) {
			my %h = %$_;
			printf "cid: %s\n", $h{content_id} if $main::debug;
			next unless $h{content_id};
			$body .= sprintf("<br /><b><div>%s</div></b>", $this->hsc($h{desc}));
			if ($h{link}) {
				$body .= sprintf("<a href=\"%s\"><img alt=\"%s\" src=\"cid:%s\"></a>\n",
					$h{link}, $this->hsc($h{desc}), $h{content_id});
			} else {
				$body .= sprintf("<img alt=\"%s\" src=\"cid:%s\">\n",
					$this->hsc($h{desc}), $h{content_id});
			}
		}
	}

	$body .= '
	</blockquote>
	</body>
	</html>
	';

	$entity->attach(Type => 'text/html; charset=utf-8', 'Data' => $body);

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
		my $msg = Mail::Mailer->new;
		my $fh = $msg->open($hdr);
		print $fh $body;
		$fh->close;
	}
}

sub dump {
	my $this = shift;
	my $ent = $this->{attach};

	print $ent->head->as_string;
	print $ent->stringify_body;
}

sub mail_attach {
	my $this = shift;
	$this->mailer($this->{attach}, @_);
}

1;
