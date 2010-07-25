# $Revision: 1.9 $, $Date: 2010-02-16 11:17:09 $
%include	/usr/lib/rpm/macros.perl
Summary:	Comics Mailer
Name:		comics-mailer
Version:	1.4.3
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

%define		_cvsroot	:ext:glen.alkohol.ee/home/glen/CVSROOT
%define		_cvsmodule	comics

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
cvs -d %{_cvsroot} co -d %{name}-%{version} %{_cvsmodule}
cd -

%build
# skip tagging if we checkouted from tag or have debug enabled
# also make make tag only if we have integer release
%if %{with release}
# do tagging by version
tag=%{name}-%(echo %{version} | tr . _)-%(echo %{release} | tr . _)

cd %{_specdir}
if [ $(cvs status -v %{name}.spec | egrep -c "$tag[[:space:]]") != 0 ]; then
	: "Tag $tag already exists"
	exit 1
fi
cvs tag $tag %{name}.spec
cd -
cvs tag $tag
%endif

%install
rm -rf $RPM_BUILD_ROOT
install -d $RPM_BUILD_ROOT{%{_bindir},%{perl_vendorlib}}
install -p main.pl $RPM_BUILD_ROOT%{_bindir}/%{name}
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
