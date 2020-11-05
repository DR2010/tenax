@echo off
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
