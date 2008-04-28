#!/bin/sh

mkdir moxy
cd moxy

svn co http://svn.coderepos.org/share/lang/perl/Encode/trunk Encode
svn co http://svn.coderepos.org/share/lang/perl/Class-Component/trunk Class-Component
svn co http://svn.coderepos.org/share/lang/perl/HTTP-MobileAttribute/trunk HTTP-MobileAttribute
svn co http://svn.coderepos.org/share/lang/perl/HTTP-Engine/trunk HTTP-Engine
svn co http://svn.coderepos.org/share/lang/perl/HTML-ReplacePictogramMobileJp/trunk HTML-ReplacePictogramMobileJp
svn co http://svn.coderepos.org/share/lang/perl/Encode-JP-Mobile/trunk Encode-JP-Mobile
svn co http://svn.coderepos.org/share/lang/perl/Encode-JP-Mobile/trunk Encode-JP-Mobile
svn co http://svn.coderepos.org/share/lang/perl/Moxy/trunk Moxy

cd Encode-JP-Mobile
perl ./Makefile.PL
make
cd ..

echo "---
global:
  server:
    module: Interface::Standalone
    conf:
      port: 3128
  timeout: 23
  log:
    level: debug
  storage:
    module: DBM_File
    file: ../moxy.dbm
#    dbm_class: DBM_File

plugins:
  - module: DisplayWidth
  - module: ControlPanel
  - module: UserID
  - module: XMLisHTML
  - module: UserAgentSwitcher
  - module: Pictogram
  - module: RefererCutter
  - module: CookieCutter
  - module: FlashUseImgTag
  - module: DisableTableTag
  - module: GPS
  - module: HTTPHeader
  - module: LocationBar
  - module: QRCode
  - module: ShowHTTPHeaders
" > config.yaml

echo "#!/bin/sh

export PERL5LIB=../Encode/lib:../Class-Component/lib:../Moxy/lib:../HTTP-MobileAttribute/lib:../HTTP-Engine/lib:../HTML-ReplacePictogramMobileJp/lib:../Encode-JP-Mobile/blib/lib:../Encode-JP-Mobile/blib/arch
cd Moxy
perl moxy.pl -c=../config.yaml
" > moxystart.sh
chmod 0755 moxystart.sh
