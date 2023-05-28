FROM alpine:3.18 AS os-base
WORKDIR /app

FROM os-base AS base
RUN --mount=type=cache,id=apk,target=/var/cache/apk \
	<<eot
	set -xeu

	ln -vs /var/cache/apk /etc/apk/cache
	flock /etc/apk/cache apk update

	# Add packages needed runtime
	apk add \
		perl-class-data-inheritable \
		perl-class-errorhandler \
		perl-datetime-format-builder \
		perl-datetime-format-iso8601 \
		perl-datetime-format-mail \
		perl-datetime-format-natural \
		perl-datetime-format-w3cdtf \
		perl-file-basedir \
		perl-html-tree \
		perl-list-moreutils \
		perl-lwp-protocol-https \
		perl-lwp-useragent-determined \
		perl-mime-tools \
		perl-module-pluggable \
		perl-xml-rss \
		perl-xml-xpath \
	&& true

	rm /etc/apk/cache
eot

FROM base AS build
RUN --mount=type=cache,id=apk,target=/var/cache/apk \
	<<eot
	set -xeu

	ln -vs /var/cache/apk /etc/apk/cache
	flock /etc/apk/cache apk update

	# base deps and cpanm
	apk add \
		alpine-sdk \
		perl \
		perl-app-cpanminus \
		perl-dev \
	&& true

	# test deps
	apk add \
		perl-module-build \
		perl-test-deep \
		perl-test-needs \
		perl-xml-libxml \
	&& true

	rm /etc/apk/cache

	# install package not available on alpine itself
	cpanm XML::Feed
eot

FROM base AS runtime
VOLUME /root/.cache
COPY --from=build /usr/local/share/perl5/site_perl/ /usr/local/share/perl5/site_perl/
COPY --chmod=755 comics-mailer.pl .
COPY *.pl *.pm .
COPY plugin ./plugin
