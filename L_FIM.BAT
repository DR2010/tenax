@echo off
rmake est_fim
if errorlevel 1 goto erro
rtlink @est_fim
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

