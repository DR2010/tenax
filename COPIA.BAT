@echo off
ECHO -------------------------------------------------------------
ECHO                          COPIA
ECHO .
ECHO Copiando arquivos do dia : %1
ECHO                   origem : F:
ECHO                  destino : C:, A:, F:
ECHO .
ECHO .
ECHO                         (alterado por Daniel em 01/Jun/1996)
ECHO -------------------------------------------------------------

REM -- COPIANDO PARA O DRIVE C: -------------
ECHO Copiando para o drive C:
ECHO ~~~~~~~~~~~~~~~~~~~~~~~~
COPY F:\TENAX\*.DBF C:\TENAX /B/V/B
COPY F:\TENAX\MENU.EXE C:\TENAX /B/V/B
DEL  C:\TENAX\*.NTX > nul
REM -----------------------------------------

if "%1"=="SEGUNDA" goto SEGUNDA
if "%1"=="TERCA"   goto TERCA
if "%1"=="QUARTA"  goto QUARTA
if "%1"=="QUINTA"  goto QUINTA
if "%1"=="SEXTA"   goto SEXTA
if "%1"=="SABADO"  goto SABADO
if "%1"=="DOMINGO" goto DOMINGO
if "%1"=="segunda" goto segunda
if "%1"=="terca"   goto terca
if "%1"=="quarta"  goto quarta
if "%1"=="quinta"  goto quinta
if "%1"=="sexta"   goto sexta
if "%1"=="sabado"  goto sabado
if "%1"=="domingo" goto domingo

goto COPIA_C

REM -----------------------------------------------------------------------
REM --------------              SEGUNDA                 -------------------
REM -----------------------------------------------------------------------
:SEGUNDA
F:
CD\TENAX
ECHO Criando arquivo de LOG
ECHO ~~~~~~~~~~~~~~~~~~~~~~~~
WHOAMI > F:\BACKUP\USERSEG.LOG
ECHO Retirando atributo READ-ONLY
ECHO ~~~~~~~~~~~~~~~~~~~~~~~~~~~~
ATTRIB -R F:\BACKUP\TNSEG.ARJ
ECHO Compactando para F:\BACKUP
ECHO ~~~~~~~~~~~~~~~~~~~~~~~~~~~~
ARJ A F:\BACKUP\TNSEG *.DBF MENU.EXE M.BAT -Y
ECHO Testando o BACKUP
ECHO ~~~~~~~~~~~~~~~~~~~
ARJ T F:\BACKUP\TNSEG
ECHO Colocando atributo READ_ONLY
ECHO ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
ATTRIB +R F:\BACKUP\TNSEG.ARJ
if "%2"=="" goto FIM
ECHO Copiando para disquete
ECHO ~~~~~~~~~~~~~~~~~~~~~~~
COPY F:\BACKUP\TNSEG.ARJ %2: /B/V/B
goto FIM

:TERCA
F:
CD\TENAX
ECHO Criando arquivo de LOG
ECHO ~~~~~~~~~~~~~~~~~~~~~~~~
WHOAMI > F:\BACKUP\USERTER.LOG
ECHO Retirando atributo READ-ONLY
ECHO ~~~~~~~~~~~~~~~~~~~~~~~~~~~~
ATTRIB -R F:\BACKUP\TNTER.ARJ
ECHO Compactando para F:\BACKUP
ECHO ~~~~~~~~~~~~~~~~~~~~~~~~~~~~
ARJ A F:\BACKUP\TNTER *.DBF MENU.EXE M.BAT -Y
ECHO Testando o BACKUP
ECHO ~~~~~~~~~~~~~~~~~~~
ARJ T F:\BACKUP\TNTER
ECHO Colocando atributo READ_ONLY
ECHO ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
ATTRIB +R F:\BACKUP\TNTER.ARJ
if "%2"=="" goto FIM
COPY F:\BACKUP\TNTER.ARJ %2: /B/V/B
goto FIM

:QUARTA
F:
CD\TENAX
ECHO Criando arquivo de LOG
ECHO ~~~~~~~~~~~~~~~~~~~~~~~~
WHOAMI > F:\BACKUP\USERQUA.LOG
ECHO Retirando atributo READ-ONLY
ECHO ~~~~~~~~~~~~~~~~~~~~~~~~~~~~
ATTRIB -R F:\BACKUP\TNQUA.ARJ
ECHO Compactando para F:\BACKUP
ECHO ~~~~~~~~~~~~~~~~~~~~~~~~~~~~
ARJ A F:\BACKUP\TNQUA *.DBF MENU.EXE M.BAT -Y
ECHO Testando o BACKUP
ECHO ~~~~~~~~~~~~~~~~~~~
ARJ T F:\BACKUP\TNQUA
ECHO Colocando atributo READ_ONLY
ECHO ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
ATTRIB +R F:\BACKUP\TNQUA.ARJ
if "%2"=="" goto FIM
COPY F:\BACKUP\TNQUA.ARJ %2: /B/V/B
goto FIM

:QUINTA
F:
CD\TENAX
ECHO Criando arquivo de LOG
ECHO ~~~~~~~~~~~~~~~~~~~~~~~~
WHOAMI > F:\BACKUP\USERQUI.LOG
ECHO Retirando atributo READ-ONLY
ECHO ~~~~~~~~~~~~~~~~~~~~~~~~~~~~
ATTRIB -R F:\BACKUP\TNQUI.ARJ
ECHO Compactando para F:\BACKUP
ECHO ~~~~~~~~~~~~~~~~~~~~~~~~~~~~
ARJ A F:\BACKUP\TNQUI *.DBF MENU.EXE M.BAT -Y
ECHO Testando o BACKUP
ECHO ~~~~~~~~~~~~~~~~~~~
ARJ T F:\BACKUP\TNQUI
ECHO Colocando atributo READ_ONLY
ECHO ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
ATTRIB +R F:\BACKUP\TNQUI.ARJ
if "%2"=="" goto FIM
COPY F:\BACKUP\TNQUI.ARJ %2: /B/V/B
goto FIM

:SEXTA
F:
CD\TENAX
ECHO Criando arquivo de LOG
ECHO ~~~~~~~~~~~~~~~~~~~~~~~~
WHOAMI > F:\BACKUP\USERSEX.LOG
ECHO Retirando atributo READ-ONLY
ECHO ~~~~~~~~~~~~~~~~~~~~~~~~~~~~
ATTRIB -R F:\BACKUP\TNSEX.ARJ
ECHO Compactando para F:\BACKUP
ECHO ~~~~~~~~~~~~~~~~~~~~~~~~~~~~
ARJ A F:\BACKUP\TNSEX *.DBF MENU.EXE M.BAT -Y
ECHO Testando o BACKUP
ECHO ~~~~~~~~~~~~~~~~~~~
ARJ T F:\BACKUP\TNSEX
ECHO Colocando atributo READ_ONLY
ECHO ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
ATTRIB +R F:\BACKUP\TNSEX.ARJ
if "%2"=="" goto FIM
COPY F:\BACKUP\TNSEX.ARJ %2: /B/V/B
goto FIM

:SABADO
F:
CD\TENAX
ECHO Criando arquivo de LOG
ECHO ~~~~~~~~~~~~~~~~~~~~~~~~
WHOAMI > F:\BACKUP\USERSAB.LOG
ECHO Retirando atributo READ-ONLY
ECHO ~~~~~~~~~~~~~~~~~~~~~~~~~~~~
ATTRIB -R F:\BACKUP\TNSAB.ARJ
ECHO Compactando para F:\BACKUP
ECHO ~~~~~~~~~~~~~~~~~~~~~~~~~~~~
ARJ A F:\BACKUP\TNSAB *.DBF MENU.EXE M.BAT -Y
ECHO Testando o BACKUP
ECHO ~~~~~~~~~~~~~~~~~~~
ARJ T F:\BACKUP\TNSAB
ECHO Colocando atributo READ_ONLY
ECHO ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
ATTRIB +R F:\BACKUP\TNSAB.ARJ
if "%2"=="" goto FIM
COPY F:\BACKUP\TNSAB.ARJ %2: /B/V/B
goto FIM

:DOMINGO
F:
CD\TENAX
ECHO Criando arquivo de LOG
ECHO ~~~~~~~~~~~~~~~~~~~~~~~~
WHOAMI > F:\BACKUP\USERDOM.LOG
ECHO Retirando atributo READ-ONLY
ECHO ~~~~~~~~~~~~~~~~~~~~~~~~~~~~
ATTRIB -R F:\BACKUP\TNDOM.ARJ
ECHO Compactando para F:\BACKUP
ECHO ~~~~~~~~~~~~~~~~~~~~~~~~~~~~
ARJ A F:\BACKUP\TNDOM *.DBF MENU.EXE M.BAT -Y
ECHO Testando o BACKUP
ECHO ~~~~~~~~~~~~~~~~~~~
ARJ T F:\BACKUP\TNDOM
ECHO Colocando atributo READ_ONLY
ECHO ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
ATTRIB +R F:\BACKUP\TNDOM.ARJ
if "%2"=="" goto FIM
COPY F:\BACKUP\TNDOM.ARJ %2: /B/V/B
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
ECHO EX1.  COPIA SEGUNDA
ECHO EX2.  COPIA SEGUNDA A
ECHO            DIA_SEMANA

REM -----------------------------------------------------------------------
REM --------------              COPIA C                 -------------------
REM -----------------------------------------------------------------------
:COPIA_C
ECHO 
ECHO Arquivos copiados apenas para o DRIVE C.
ECHO EX1.  COPIA SEGUNDA
ECHO EX2.  COPIA SEGUNDA A
ECHO            DIA_SEMANA

:FIMII
