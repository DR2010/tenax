@echo off
set pll=f:\clipper5\pll
map s16:=f:/clipper5\bin
set lib=f:\clipper5\lib
set lib=f:\tenax
set include=f:\clipper5\include
rmake est
if errorlevel 1 goto erro
rtlink @est
if errorlevel 1 goto erro
echo..
echo..
echo..
echo..
echo..
echo..
echo..
echo..
echo..
echo..
echo..
echo              A compila‡„o finalizou com sucesso!!
echo..
echo..
echo..
echo..
echo..
echo..
echo..
echo..
echo..
echo..
echo..
goto fim

:erro
echo.
echo.
echo **************************************  Deu Pau!  ******************************
pause > NUL

:fim
