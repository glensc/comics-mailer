
package plugin;

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

sub http_request {
	my $this = shift;
	my $url = shift;

	print "http_request: $url...\n" if $main::debug;
    my $res = $ua->request(HTTP::Request->new(GET => $url));
	return $res;
}

sub fetch_url {
	my $this = shift;
	my $url = shift;

	my $res = $this->http_request($url);
	if ($res->is_success) {
		return $res->content;
	}

	warn sprintf("HTTP[%s]: %s\n", $url, $res->message);

	return undef;
}

sub strftime {
	my $this = shift;
	my $fmt = shift;
	my $t = $_[0] ? shift : time;

	my $date = POSIX::strftime($fmt, localtime($t));
}

sub add_comic {
	my $this = shift;
	my $url = shift;
	my $desc = shift;

	my %h = (url => $url, desc => $desc);
	$this->{data}{$url} = \%h;
}

sub fetch_gfx {
	my $this = shift;

	foreach (keys %{ $this->{data} }) {
		my $p = $this->{data}{$_};
		my $res = $this->http_request($p->{url});
		if ($res->is_success) {
			$content_type = $res->header('Content-type');
			$file = $p->{url};
			if ($file =~ m#([^/?=]+?)$#) {
				$file = $1;
				if ($file !~ /\./ && $content_type =~ m#/(.*)$#) {
					$file .= ".$1";
				}
			}
			$p->{content_type} = $content_type;
			$p->{content_id} = md5_hex($p->{url});
			$p->{data} = $res->content;
#			$p->{data} = "DATA HERE";
			$p->{filename} = $file;
		} else {
			warn "Failed to fetch: $p->{url}\n";
		}
	}
}

sub get_data {
	my $this = shift;

	return $this->{data};
}

1;
