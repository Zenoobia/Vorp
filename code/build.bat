@echo off
if not defined DEV_ENV_DIR (
	call "C:\Program Files (x86)\Microsoft Visual Studio 14.0\VC\vcvarsall.bat" x86
)
set DEV_ENV_DIR=???

if "%2"=="s" (call "..\misc\shell.bat" %1)

echo Building for %1
REM "/MDd switch for debug and /MTd for release"
REM "-wd4099 : .pdb missing for debug library (?)"
REM "-wd4505 : unreferenced local function has been removed"
REM "-wd4275: non dll-interface class used as base for dll-interface class"
REM "-wd4127: conditional expression is constant"
set CommonCompilerFlags=-nologo -MDd /EHsc -Gm- -GR- -Oi -WX -W4 -wd4127 -wd4273 -wd4275 -wd4244 -wd4201 -wd4100 -wd4189 -wd4996 -wd4505 -FC -Z7 -DTERRIFIC_INTERNAL=1 -DTERRIFIC_SLOW=1
set CommonLinkerFlags= -incremental:no -opt:ref user32.lib gdi32.lib winmm.lib
set CommonExport= /EXPORT:CreateGame /EXPORT:RunGame /EXPORT:DestroyGame

set Classes= ..\code\KeyboardManager.cpp 
REM ..\code\terrific.cpp

set SFMLLibsDebug= /libpath:"W:\external\SFML-2.4.2\lib" sfml-audio-d.lib sfml-graphics-d.lib sfml-main-d.lib sfml-network-d.lib sfml-system-d.lib sfml-window-d.lib /libpath:"C:\SFGUI-testing\lib" openal32.lib jpeg.lib glew.lib freetype.lib opengl32.lib sndfile.lib
set NEWTONLibsDebug= /libpath:"C:\newton-dynamics\coreLibrary_300\projects\windows\project_vs2010_static_md\Win32\newton\Debug" newton_d.lib
set BOX2DLibsDebug= /libpath:"C:\Box2D\Build\vs2013\bin\x32\Debug" Box2D.lib
set Flags= -D_WIN32=1 -D_NEWTON_STATIC_LIB=1

IF NOT EXIST ..\build mkdir ..\build
pushd ..\build
REM cl -nologo -MTd /EHsc -Gm- -GR- -Oi -WX -W4 -wd4201 -wd4100 -wd4189 -wd4996 -Z7 -Fmwin32_terrific.map -DTERRIFIC_INTERNAL=1 -DTERRIFIC_SLOW=1 ..\code\win32_terrific.cpp /link -opt:ref -subsystem:windows,5.01 user32.lib gdi32.lib
REM Optimization Switches: /O2 /Oi /fp:fast(?) 
REM /PDB:terrific_%random%.pdb

REM -subsystem:windows,5.01 32 (Windows XP)

REM if "%1"=="x64" (cl %CommonCompilerFlags% ..\code\terrific.cpp -Fmterrific.map /PDB:terrific_%random%.pdb -LD  /I "J:\include" /link /libpath:"J:\build" entityx-d.lib -incremental:no)

del *.pdb > NUL 2> NUL
del *.tri > NUL 2> NUL
echo Waiting for pdb > lock.tmp 
if "%1"=="x86" (cl  %CommonCompilerFlags%  ..\code\terrific.cpp %Classes% -Fmterrific.map  /DEBUG -DDLL_EXPORTS=1 %Flags% -LD /I "W:\include" /I "W:\external\SFML-2.4.2\include" /I "C:\SFGUI-testing\include" /I "C:\newton-dynamics\coreLibrary_300\source\newton" /I "C:\Box2D" /I "D:\Visual Studio Projects\Holm" /link /PDB:terrific_%random%.pdb /libpath:"W:\libs" entityx-d.lib Framework.lib /libpath:"C:\SFGUI-testing\build\lib\Debug" sfgui-d.lib %SFMLLibsDebug% %NEWTONLibsDebug% %BOX2DLibsDebug% -incremental:no -subsystem:windows,5.01 %CommonExport%)
del lock.tmp
REM -Fmwin32_terrific.map
REM if "%1"=="x86"
REM del tmp.dll
tasklist /FI "IMAGENAME eq win32_terrific.exe" 2>NUL | find /I /N "win32_terrific.exe">NUL
if "%ERRORLEVEL%"=="1" (echo Program is not running)
if "%ERRORLEVEL%"=="1" (del ..\build\tmp.dll)

if not exist ..\build\tmp.dll (echo Building new Exe!)
if not exist ..\build\tmp.dll (cl  %CommonCompilerFlags%  ..\code\win32_terrific.cpp /I "J:\include" /I "C:\SFML-master\include" /I "C:\SFGUI-testing\include" /link /libpath:"J:\libs\32" entityx-d.lib /libpath:"C:\SFGUI-testing\build\lib\Debug" sfgui-d.lib %SFMLLibsDebug% /libpath:"J:\build" %CommonLinkerFlags% -subsystem:windows,5.01)
if not exist ..\build\tmp.dll (start "" J:\build\win32_terrific.exe)
popd