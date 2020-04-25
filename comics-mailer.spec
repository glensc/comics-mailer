Summary:	Comics Mailer
Name:		comics-mailer
Version:	%{version}
Release:	%{release}
License:	GPL v2
Group:		Networking/Daemons
BuildRequires:	rpm-perlprov >= 4.1-13
Requires:	perl-LWP-Protocol-https
BuildArch:	noarch
BuildRoot:	%{tmpdir}/%{name}-%{version}-root-%(id -u -n)

%description
Comics Mailer.

%prep

%install
rm -rf $RPM_BUILD_ROOT
install -d $RPM_BUILD_ROOT{%{_bindir},%{perl_vendorlib}}
install -p %{name}.pl $RPM_BUILD_ROOT%{_bindir}/%{name}
cp -a *.pm plugin $RPM_BUILD_ROOT%{perl_vendorlib}

%clean
rm -rf $RPM_BUILD_ROOT

%files
%defattr(644,root,root,755)
%attr(755,root,root) %{_bindir}/%{name}
%{perl_vendorlib}/*
