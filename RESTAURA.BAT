@echo off
ECHO -------------------------------------------------------------
ECHO                        RESTAURA
ECHO 
ECHO Restaurando arquivos do dia : %1
ECHO                      origem : %2
ECHO                     destino : C
ECHO
ECHO                         (alterado por Daniel em 01/Jun/1996)
ECHO -------------------------------------------------------------

if "%2"=="" goto ERRO
if %1==SEGUNDA goto SEGUNDA
if %1==TERCA   goto TERCA
if %1==QUARTA  goto QUARTA
if %1==QUINTA  goto QUINTA
if %1==SEXTA   goto SEXTA
if %1==SABADO  goto SABADO
if %1==DOMINGO goto DOMINGO

if %1==segunda goto segunda
if %1==terca   goto terca
if %1==quarta  goto quarta
if %1==quinta  goto quinta
if %1==sexta   goto sexta
if %1==sabado  goto sabado
if %1==domingo goto domingo

goto ERRO

:SEGUNDA
C:
CD\TENAX
IF NOT EXIST A:\TNSEG.ARJ GOTO ERROARQ
COPY A:\TNSEG.ARJ C: /V
ARJ X TNSEG -Y
DEL *.NTX
goto FIM

:TERCA
C:
CD\TENAX
IF NOT EXIST A:\TNTER.ARJ GOTO ERROARQ
COPY A:\TNTER.ARJ C: /V
ARJ X TNTER -Y
DEL *.NTX
goto FIM

:QUARTA
C:
CD\TENAX
IF NOT EXIST A:\TNQUA.ARJ GOTO ERROARQ
COPY A:\TNQUA.ARJ C: /V
ARJ X TNQUA -Y
DEL *.NTX
goto FIM

:QUINTA
C:
CD\TENAX
IF NOT EXIST A:\TNQUI.ARJ GOTO ERROARQ
COPY A:\TNQUI.ARJ C: /V
ARJ X TNQUI -Y
DEL *.NTX
goto FIM

:SEXTA
C:
CD\TENAX
IF NOT EXIST A:\TNSEX.ARJ GOTO ERROARQ
COPY A:\TNSEX.ARJ C: /V
ARJ X TNSEX -Y
DEL *.NTX
goto FIM

:SABADO
C:
CD\TENAX
IF NOT EXIST A:\TNSAB.ARJ GOTO ERROARQ
COPY A:\TNSAB.ARJ C: /V
ARJ X TNSAB -Y
DEL *.NTX
goto FIM

:DOMINGO
C:
CD\TENAX
IF NOT EXIST A:\TNDOM.ARJ GOTO ERROARQ
COPY A:\TNDOM.ARJ C: /V
ARJ X TNDOM -Y
DEL *.NTX
goto FIM


REM -----------------------------------------------------------------------
REM --------------              FIM                     -------------------
REM -----------------------------------------------------------------------
:FIM
ECHO. **********************************************************************
ECHO. **********************************************************************
ECHO. *************************   ±±±±  ±  ±±   ±±  ************************
ECHO. *************************   ±     ±  ± ± ± ±  ************************
ECHO. *************************   ±±±   ±  ±  ±  ±  ************************
ECHO. *************************   ±     ±  ±     ±  ************************
ECHO. *************************   ±     ±  ±     ±  ************************
ECHO. **********************************************************************
ECHO. **********************************************************************
GOTO FIMII

REM -----------------------------------------------------------------------
REM --------------              ERRO                    -------------------
REM -----------------------------------------------------------------------
:ERRO
ECHO 
ECHO FALTA PARAMETRO
ECHO EX1.  RESTAURA SEGUNDA A
goto FIMII

REM -----------------------------------------------------------------------
REM --------------             ERROARQ                  -------------------
REM -----------------------------------------------------------------------
:ERROARQ
ECHO 
ECHO Arquivo de %1 nao encontrado no drive %2:
goto FIMII

:FIMII
