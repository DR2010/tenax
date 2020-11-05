@echo off

SET PLL=C:\CLIPPER5\PLL
SET LIB=C:\CLIPPER5\LIB
SET INCLUDE=C:\CLIPPER5\INCLUDE

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
