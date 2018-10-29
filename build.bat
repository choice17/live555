@rem Place this file at the live/ directory of the downloaded LIVE555 source files.
@rem Based on instructions at https://nspool.github.io/2016/02/building-live555/
@rem Tested with Visual Studio 2015 on Windows 10
@echo off

if exist "%TEMP%\sed.vbs" goto skip_gen_sed
> "%TEMP%\sed.vbs" (
  REM thanks to https://stackoverflow.com/questions/127318/is-there-any-sed-like-utility-for-cmd-exe
  @echo.Dim pat, patparts, rxp, inp
  @echo.pat = WScript.Arguments(0^)
  @echo.patparts = Split(pat,Mid(pat,2,1^)^)
  @echo.Set rxp = new RegExp
  @echo.rxp.Global = True
  @echo.rxp.Multiline = False
  @echo.rxp.Pattern = patparts(1^)
  @echo.Do While Not WScript.StdIn.AtEndOfStream
  @echo.  inp = WScript.StdIn.ReadLine(^)
  @echo.  WScript.Echo rxp.Replace(inp, patparts(2^)^)
  @echo.Loop
)
:skip_gen_sed

>nul,where cl && goto skip_vsvars
call "%VS140COMNTOOLS%\vsvars32.bat"
:skip_vsvars

if exist win32config.orig goto skip_win32config
cscript //NoLogo %TEMP%\sed.vbs "s/(^TOOLS32.*$)/TOOLS32	=		%VCINSTALLDIR:~0,-1%/" < win32config | ^
cscript //NoLogo %TEMP%\sed.vbs "s|(-out)|/out|" | ^
cscript //NoLogo %TEMP%\sed.vbs "s/(^!include)/#!include/" | ^
cscript //NoLogo %TEMP%\sed.vbs "s|(\$\(link\))|link ws2_32.lib|" | ^
cscript //NoLogo %TEMP%\sed.vbs "s/(msvcirt.lib)/msvcrt.lib/" > win32config.new
>nul,move win32config win32config.orig
>nul,move win32config.new win32config
:skip_win32config

call genWindowsMakefiles

cd liveMedia
del *.obj *.lib
nmake /B -f liveMedia.mak
cd ..\groupsock
del *.obj *.lib
nmake /B -f groupsock.mak
cd ..\UsageEnvironment
del *.obj *.lib
nmake /B -f UsageEnvironment.mak
cd ..\BasicUsageEnvironment
del *.obj *.lib
nmake /B -f BasicUsageEnvironment.mak
cd ..\testProgs
del *.obj *.lib
nmake /B -f testProgs.mak
cd ..\mediaServer
del *.obj *.lib
nmake /B -f mediaServer.mak
cd ..