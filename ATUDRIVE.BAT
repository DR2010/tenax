@echo off
ECHO -------------------------------------------------------------
ECHO                         ATUDRIVE
ECHO 
ECHO Atualizando arquivos do drive %2
ECHO
ECHO                      origem : %1:
ECHO                     destino : %2:
ECHO
ECHO
ECHO                         (alterado por Daniel em 01/Jun/1996)
ECHO -------------------------------------------------------------

if "%1"=="" goto erro
if "%2"=="" goto erro

%1:
CD\TENAX
ARJ A %2:TNDRIVE *.DBF MENU.EXE -Y

ECHO --- ATUALIZADO ---

:erro
ECHO 
ECHO Falta parametro.
ECHO Ex. ATUDRIVE F A

goto fim

:fim

