@echo off
if "%1" == "" goto erro
if "%1" == "b" goto COPIAB
if "%1" == "B" goto COPIAB
if "%1" == "a" goto COPIAA
if "%1" == "A" goto COPIAA
if "%1" == "f" goto COPIAF
if "%1" == "F" goto COPIAF

:COPIAA
@COPY A:\*.DBF C:\TENAX /V
del c:\tenax\*.ntx
goto fim


:COPIAB
@COPY B:\*.DBF C:\TENAX /V
del c:\tenax\*.ntx
goto fim

:COPIAF
@COPY F:\TENAX\menu.EXE C:\TENAX /V
@COPY F:\TENAX\*.DBF C:\TENAX /V
del c:\tenax\*.ntx
goto fim

:erro
echo.
echo.
echo.   Digite ATUALIZA A        para backup do diskete grande
echo.
echo.   Digite ATUALIZA B        para backup do diskete pequeno
echo.
echo.   Digite ATUALIZA F        para backup da Rede
echo.
goto fim

:fim
