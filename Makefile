# Makefile for comics-mailer
CACHE_DIR       := $(CURDIR)/cache
CPANM_CACHE     := $(CACHE_DIR)/cpanm

all:

test:
	perl -c comics-mailer.pl 

installdeps:
	cpanm --installdeps -Llocal -n . \
		--cascade-search \
		--save-dists=$(CPANM_CACHE) \
		--mirror=$(CPANM_CACHE) \
		--mirror=http://search.cpan.org/CPAN
