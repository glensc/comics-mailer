# $Revision: 1.20 $, $Date: 2012-08-12 16:20:22 $
%include	/usr/lib/rpm/macros.perl
Summary:	Comics Mailer
Name:		comics-mailer
Version:	1.5
Release:	1
License:	GPL v2
Group:		Networking/Daemons
BuildRequires:	rpm-perlprov >= 4.1-13
BuildArch:	noarch
BuildRoot:	%{tmpdir}/%{name}-%{version}-root-%(id -u -n)

# This macro defines when release rules must be applied, i.e integer build
%if %{!?debug:1}%{?debug:0} && %{!?_cvstag:1}%{?_cvstag:0} && %([[ %{release} = *.* ]] && echo 0 || echo 1)
%define		with_release	1
%else
%undefine	with_release
%endif

%define		_gitroot	git@github.com:glensc/comics-mailer.git

%description
Comics Mailer.

%prep
# check early if build is ok to be performed
%if %{with release}
# break if spec is not commited
cd %{_specdir}
if [ "$(cvs status %{name}.spec | awk '/Status:/{print $NF}')" != "Up-to-date" ]; then
	: "Integer build not allowed: %{name}.spec is not up-to-date with CVS"
	exit 1
fi
cd -
%endif
%setup -qcT
cd ..
git clone  %{_gitroot} %{name}-%{version}
cd -

%build
# skip tagging if we checkouted from tag or have debug enabled
# also make make tag only if we have integer release
%if %{with release}
# do tagging by version
tag=%{name}-%(echo %{version} | tr . _)-%(echo %{release} | tr . _)
gittag=%{version}-%{release}

cd %{_specdir}
if [ $(cvs status -v %{name}.spec | egrep -c "$tag[[:space:]]") != 0 ]; then
	: "Tag $tag already exists"
	exit 1
fi
cvs tag $tag %{name}.spec
cd -
git tag $gittag
git push origin $gittag
%endif

%install
rm -rf $RPM_BUILD_ROOT
install -d $RPM_BUILD_ROOT{%{_bindir},%{perl_vendorlib}}
install -p %{name}.pl $RPM_BUILD_ROOT%{_bindir}/%{name}
cp -a *.pm plugin $RPM_BUILD_ROOT%{perl_vendorlib}
rm -rf $RPM_BUILD_ROOT%{perl_vendorlib}/CVS
rm -rf $RPM_BUILD_ROOT%{perl_vendorlib}/plugin/CVS

%clean
rm -rf $RPM_BUILD_ROOT

%files
%defattr(644,root,root,755)
%attr(755,root,root) %{_bindir}/%{name}
%{perl_vendorlib}/*

%define date	%(echo `LC_ALL="C" date +"%a %b %d %Y"`)
%changelog
* %{date} RPM Team <rpm@cvs.delfi.ee>
All persons listed below can be reached at <cvs_login>@cvs.delfi.ee

$Log: comics-mailer.spec,v $
Revision 1.20  2012-08-12 16:20:22  glen
- up to 1.5: comics sent out are remembered, plugins can die with errors

Revision 1.19  2012-07-19 07:30:37  glen
- hijinksensue: add also alt if different from title

Revision 1.18  2012-07-19 07:16:37  glen
- 1.4.6: add HijiNKS Ensue comic

Revision 1.17  2011-11-19 12:22:55  glen
- update bin path

Revision 1.16  2011-11-14 18:16:23  glen
- pm site changes

Revision 1.15  2011-10-31 10:06:57  glen
- newline between comits

Revision 1.14  2011-08-25 14:03:46  glen
- rel 3, more permalinks to comics

Revision 1.13  2011-07-03 21:02:46  glen
- add link to simon's cat

Revision 1.12  2011-06-27 22:47:34  glen
- add wulffmorgenthaler

Revision 1.11  2011-06-21 06:37:00  glen
- add simons cat

Revision 1.10  2010-07-25 09:24:04  glen
- include link to original image in emails
- version 1.4.3

Revision 1.9  2010-02-16 11:17:09  glen
- v1.4.2: add xkcd.com on Toomas Laasik suggestion

Revision 1.8  2010-01-15 15:01:30  glen
- cyanide swf fix

Revision 1.7  2009/09/11 18:54:48  glen
- v1.4: add cyanide & happyness

Revision 1.6  2008/11/04 10:37:32  glen
- match postimees.ee site changes

Revision 1.5  2008/10/16 12:24:02  glen
- v1.2: include date in subject

Revision 1.4  2008/10/16 12:02:07  glen
- match postimees.ee site changes
- add -date=YYYYMMDD support
- auto tag sources on build
- version 1.1

Revision 1.3  2008/07/20 09:24:27  glen
- noarch

Revision 1.2  2008/07/20 09:20:27  glen
- works with new site

Revision 1.1  2008/07/20 08:53:59  glen
- new
