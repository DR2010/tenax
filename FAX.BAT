@echo off

if "%1"=="" goto erro
if "%2"=="" goto erro

ssfaxer 2 P0w%1 %2
goto fim

:erro
echo Erro !!!
echo ----------------------------------------------------
echo Parametros :
echo   fax <telefone> <nome arquivo>
echo .
echo Exemplo :
echo .
echo    fax 5155555 rel048.prn
echo .
echo ----------------------------------------------------
goto fim2

:fim
echo ----------------------------------------------------
echo Parabens funcionou !!!!!!!!!!
echo ----------------------------------------------------

:fim2
