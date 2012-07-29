
package plugin;
use strict;
use warnings;

use POSIX ();
use HTTP::Request;
use LWP::UserAgent;
use Digest::MD5 qw(md5_hex);

use vars qw(@plugins);

my $ua = LWP::UserAgent->new;
$ua->env_proxy();

sub new {
	my $self = shift;
	my $class = ref($self) || $self;
	my $props = shift;

	my $this = { $props ? %$props : () };
	bless($this, $class);

	push(@plugin::plugins, $this);

	return $this;
}

sub set_date {
	my ($this, $t) = @_;

	$this->{utime} = $t;
}

sub http_request {
	my ($this, $url) = @_;

	print "http_request: $url...\n" if $main::debug;
    my $res = $ua->request(HTTP::Request->new(GET => $url));
	return $res;
}

sub fetch_url {
	my ($this, $url) = @_;

	my $res = $this->http_request($url);
	if ($res->is_success) {
		return $res->content;
	}

	warn sprintf("HTTP[%s]: %s\n", $url, $res->message);

	return undef;
}

sub strftime {
	my ($this, $fmt) = @_;
	my $t = $this->{utime};
	my $date = POSIX::strftime($fmt, localtime($t));
}

sub add_comic {
	my ($this, $url, $title, $link) = @_;
	$link ||= '';

	my %h = (url => $url, desc => $title, link => $link);
	print "add: url = $url; desc = $title, link = $link\n" if $main::debug;
	$this->{data}{$url} = \%h;
}

sub fetch_gfx {
	my ($this) = @_;

	foreach (keys %{ $this->{data} }) {
		my $p = $this->{data}{$_};
		my $res = $this->http_request($p->{url});
		if (!$res->is_success) {
			warn "Failed to fetch: $p->{url}\n";
			next;
		}

		my $content_type = $res->header('Content-type');
		my $file = $p->{url};
		if ($file =~ m#([^/?=]+?)$#) {
			$file = $1;
			if ($file !~ /\./ && $content_type =~ m#/(.*)$#) {
				$file .= ".$1";
			}
		}
		$p->{content_type} = $content_type;
		$p->{content_id} = md5_hex($p->{url});
		$p->{data} = $res->content;
		$p->{filename} = $file;
	}
}

sub get_data {
	my ($this) = @_;

	return $this->{data};
}

1;
