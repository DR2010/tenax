@echo off
cls
Echo Compactando...
Echo ARJ A %1 *.PRG *.DBF *.BAT *.RMK *.LNK *.CH *.LIB *.DOC *.DES *.DOC
ARJ A %1 *.PRG *.DBF *.DBT *.BAT *.RMK *.LNK *.CH *.LIB *.DOC *.DES *.DOC
ARJ T %1

COPY %1.ARJ A: /V



