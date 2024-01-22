# vim:ft=perl
#
# Minimum Perl required is 5.8
requires perl => '5.008';

requires 'File::BaseDir';
requires 'MIME::Tools';
requires 'HTML::Tree';

# Avoid "Can't verify SSL peers without knowing which Certificate Authorities to trust" error
requires 'Mozilla::CA';

# NOTE: this module install requires expat-devel
# On brew, this could work:
#brew install expat
#export EXPATINCPATH="$(brew --prefix)/opt/expat/include"
#export EXPATLIBPATH="$(brew --prefix)/opt/expat/lib"
requires 'XML::Feed';
