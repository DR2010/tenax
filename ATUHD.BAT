@echo off
ECHO -------------------------------------------------------------
ECHO                         ATUHD
ECHO 
ECHO Atualizando arquivos do drive C:
ECHO
ECHO                      origem : %1:
ECHO
ECHO                         (alterado por Daniel em 01/Jun/1996)
ECHO -------------------------------------------------------------

if "%1"=="" goto erro

C:
CD\TENAX
ARJ X %1:TNDRIVE -Y

ECHO --- ATUALIZADO ---

:erro
ECHO 
ECHO Falta parametro.
ECHO Ex. ATUHD A ( origem )

goto fim

:fim

