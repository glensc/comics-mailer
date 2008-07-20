# $Revision: 1.2 $, $Date: 2008/07/20 09:20:27 $
%include	/usr/lib/rpm/macros.perl
Summary:	Comics Mailer
Name:		comics-mailer
Version:	0.9
Release:	1
License:	GPL v2
Group:		Networking/Daemons
BuildRequires:	rpm-perlprov >= 4.1-13
BuildArch:	noarch
BuildRoot:	%{tmpdir}/%{name}-%{version}-root-%(id -u -n)

%define		_cvsroot	:ext:glen.alkohol.ee/home/glen/CVSROOT
%define		_cvsmodule	comics

%description
Comics Mailer.

%prep
%setup -qTc
cd ..
cvs -d %{_cvsroot} co -d %{name}-%{version} %{_cvsmodule}
cd -

%install
rm -rf $RPM_BUILD_ROOT
install -d $RPM_BUILD_ROOT{%{_bindir},%{perl_vendorlib}}
install main.pl $RPM_BUILD_ROOT%{_bindir}/%{name}
cp -a *.pm plugin $RPM_BUILD_ROOT%{perl_vendorlib}

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
Revision 1.2  2008/07/20 09:20:27  glen
- works with new site

Revision 1.1  2008/07/20 08:53:59  glen
- new
