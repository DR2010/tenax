@echo off
set lib=c:\clipper5\lib
set pll=c:\clipper5\pll
set bin=c:\clipper5\bin
set include=c:\clipper5\include
rmake FAT
if not errorlevel 1 rtlink @FAT
