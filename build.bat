@echo off

if not defined DEV_ENV_DIR (
	call "C:\Program Files (x86)\Microsoft Visual Studio 14.0\VC\vcvarsall.bat" x86
)
set DEV_ENV_DIR=???

set SFML_DIR=W:\external\SFML-2.4.2
set SFGUI_DIR=W:\external\sfgui-0.3.1

set INCLUDE_DIR=%SFML_DIR%\include -I %SFGUI_DIR%\include

set CFLAGS= /DEBUG -nologo -MDd -EHsc 
REM -Gm- -GR- -Oi -WX -W4 -wd4127 -wd4273 -wd4275 -wd4244 -wd4201 -wd4100 -wd4189 -wd4996 -wd4505 -FC -Z7
set LFLAGS= /LIBPATH:"W:\lib" sfgui-d.lib sfml-graphics-d.lib sfml-window-d.lib sfml-system-d.lib opengl32.lib user32.lib kernel32.lib
REM winmm.lib gdi32.lib jpeg.lib freetype.lib gdi32.lib winspool.lib shell32.lib ole32.lib oleaut32.lib uuid.lib comdlg32.lib advapi32.lib
REM glew.lib sndfile.lib
REM /LIBPATH:"%SFGUI_DIR%\lib" sfgui-d.lib


if not exist .\bin mkdir .\bin
pushd .\bin

del *.pdb > NUL 2> NUL

REM game dll
echo "WAITING FOR PDB ..." > lock.tmp
cl %CFLAGS% -DDLL_EXPORTS=1 ..\src\game.cpp -I %INCLUDE_DIR% -LD /link -PDB:game_%random%.pdb  %LFLAGS% /EXPORT:createGame /EXPORT:runGame /EXPORT:destroyGame
del lock.tmp

REM platform exe
REM COPY /B main.exe+NUL main.exe >NUL 2< NUL || GOTO :POPD
2>nul (
	>>main.exe echo off
) && (echo Building Main) || (GOTO :POPD)
cl %CFLAGS% ..\src\main.cpp -I %INCLUDE_DIR% /link %LFLAGS%
:POPD
popd

echo Done!