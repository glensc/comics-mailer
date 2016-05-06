# Makefile for comics-mailer
CACHE_DIR       := $(CURDIR)/cache
CPANM_CACHE     := $(CACHE_DIR)/cpanm

export PERL5LIB := local/lib/perl5

all:

test:
	perl -c comics-mailer.pl 

installdeps:
	cpanm --installdeps -Llocal --notest . \
		--cascade-search \
		--save-dists=$(CPANM_CACHE) \
		--mirror=$(CPANM_CACHE) \
		--mirror=http://search.cpan.org/CPAN
