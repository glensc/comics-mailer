
package plugin;
use strict;
use warnings;

use POSIX ();
use HTTP::Request;
use LWP::UserAgent;
use Digest::MD5 qw(md5_hex);

use persistent;

use vars qw(@plugins);

my $ua = LWP::UserAgent->new;
# pandyland fix
$ua->agent("Mozilla/5.0");
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

# set http cache path
sub set_http_cache($$) {
	my ($this, $cachefile) = @_;
	$this->{http_cache} = $cachefile;
}

sub get_http_cache($$) {
	my ($this) = @_;

	$this->{http_cache} ?
		new persistent($this->{http_cache}) :
		{};
}

# set history object
sub set_history($$) {
	my ($this, $history) = @_;
	$this->{history} = $history;
}

# get history object
sub get_history($$) {
	my ($this) = @_;
	$this->{history};
}

# fetch $url
# TODO: fix duplicate with fetch_url
# uses http.cache for easier developing purposes
sub http_request {
	my ($this, $url) = @_;

	print "http_request: $url...\n" if $main::debug;
	my $http_cache = $this->get_http_cache;
    my $res = $http_cache->{$url} || $ua->request(HTTP::Request->new(GET => $url));
	$http_cache->{$url} = $res;
	return $res;
}

# fetch $url.
# also checks for response success
sub fetch_url {
	my ($this, $url) = @_;

	my $res = $this->http_request($url);
	if ($res->is_success) {
		return $res->content;
	}

	warn sprintf("HTTP[%s]: %s\n", $url, $res->status_line);

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

	my $history = $this->get_history;

	if ($history->{$url}) {
		print "skip (already exists (at ($history->{$url})): url = $url; desc = $title, link = $link\n" if $main::debug;
		return;
	}
	# store in history
	$history->{$url} = $this->{utime};

	print "add: url = $url; desc = $title, link = $link\n" if $main::debug;
	$this->{data}{$url} = {url => $url, desc => $title, link => $link};
}

# returns true if comic already exists in permanent db
sub exists {
	my ($this, $p) = @_;

	return 0 unless $this->{persistent};

	return 1 if exists $this->{persistent}{$p->{url}};

	return 0;
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

sub DESTROY {
	my $this = shift;
	# release history reference to avoid circular deps
	undef($this->{history});
}

1;
