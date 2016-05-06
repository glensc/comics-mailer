# Makefile for comics-mailer
CACHE_DIR       := $(CURDIR)/cache
CPANM_CACHE     := $(CACHE_DIR)/cpanm

export PERL5LIB := local/lib/perl5

all:

test:
	perl -c comics-mailer.pl

run-test:
	install -d $(CACHE_DIR)
	XDG_CONFIG_HOME=$(CURDIR) XDG_CACHE_HOME=$(CACHE_DIR) perl comics-mailer.pl

installdeps:
	cpanm --installdeps -Llocal --notest . \
		--cascade-search \
		--save-dists=$(CPANM_CACHE) \
		--mirror=$(CPANM_CACHE) \
		--mirror=http://search.cpan.org/CPAN
