cd foxvdemo
if not exist DEMOKEY.COM GOTO ERR
:START
ECHO OFF
CLS
ECHO 컴컴컴컴컴컴컴컴컴컴FoxView DEMO MENU컴컴컴컴컴컴컴컴컴컴컴컴
ECHO 0  -  Exit to DOS
ECHO 1  -  FoxView DEMO          (approx.  8 minutes)
ECHO 2  -  FoxView TUTORIAL      (approx. 14 minutes)
ECHO 3  -  Try it yourself!
ECHO 컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�
:CHOICE
ECHO Press 0, 1, 2, or 3
DEMOKEY
IF ERRORLEVEL 52 GOTO CHOICE
IF ERRORLEVEL 51 GOTO M3
IF ERRORLEVEL 50 GOTO M2
IF ERRORLEVEL 49 GOTO M1
IF ERRORLEVEL 48 GOTO M0
GOTO CHOICE
:M0
CLS
ECHO Returning to DOS...
ECHO 
GOTO EXIT
:M1
FoxView DemoQuik.FVT
GOTO START
:M2
FoxView DemoTutr.FVT
GOTO START
:M3
CLS
ECHO   You can try FoxView on DEMO.DBF by typing:
ECHO 
ECHO        FOXVIEW  {Return}
ECHO 
ECHO   followed by:
ECHO 
ECHO        USE DEMO  {Return}
ECHO        VIEW FORM  {Return}
ECHO 
:EXIT
GOTO FINISH
:ERR
echo Demo files not found.
:FINISH
