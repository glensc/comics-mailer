#FROM registry.gitlab.com/pld-linux/pld AS base
# https://github.com/jpalus/pld-linux-arm
FROM jpalus/pld-linux-armv6hl AS base
RUN <<eot
    set -xeu
	# Keep downloads in /var/cache/poldek
	poldek-config keep_downloads yes
	poldek-config cache_dir /var/cache/poldek
	# Enable /root repo
	sed -i -re 's/^((auto)[[:space:]]*)=.*/\1 = yes/' /etc/poldek/source.conf
eot

FROM base AS build-base
WORKDIR /root/rpm
RUN \
	--mount=type=cache,id=poldek,target=/var/cache/poldek \
	--mount=type=cache,id=packages,target=/root/rpm \
    <<eot
    set -xeu
	poldek --up -u \
		rpm-build-tools

	builder --init-rpm-dir
eot

FROM build-base AS build
RUN \
	--mount=type=cache,id=poldek,target=/var/cache/poldek \
	--mount=type=cache,id=packages,target=/root/rpm \
	--mount=type=bind,source=./packages.txt,target=./packages.txt \
    <<eot
    set -xeu

	# Build missing packages
	for pkg in $(grep -Ev '#' packages.txt); do
		poldek --up -u $pkg && continue
		builder -bb -R $pkg
		poldek --up -u $pkg || break
	done
eot

FROM base AS runtime

RUN \
	--mount=type=cache,id=poldek,target=/var/cache/poldek \
	--mount=type=cache,id=packages,target=/root/rpm \
    <<eot
    set -xeu
	poldek --up -u \
		perl-LWP-Protocol-https
eot
