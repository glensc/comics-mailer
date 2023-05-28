#FROM registry.gitlab.com/pld-linux/pld AS base
# https://github.com/jpalus/pld-linux-arm
FROM jpalus/pld-linux-armv6hl AS base

RUN --mount=type=cache,id=poldek,target=/var/cache/poldek \
    <<eot
    set -xeu

    set -- --caplookup --up -O 'keep downloads=yes'

	poldek "$@" -u \
		perl-LWP-Protocol-https
eot
