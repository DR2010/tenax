REM ********HOUSE KEEPING ***********
@ECHO OFF
SET ERROR10=0
SET ERROR17=0

:SelfCheckOK
CLS
ECHO *
ECHO *
ECHO *                  MCAFEE VIRUS REMOVAL TOOL
ECHO *
ECHO *    THIS DISKETTE IS USED TO SIMPLIFY THE TASK OF REMOVING A
ECHO *    VIRUS FROM YOUR COMPUTER.  IT IS IMPORTANT TO ENSURE THAT
ECHO *    YOU COLD BOOTED YOUR MACHINE BEFORE USING THIS DISKETTE.
ECHO *    A COLD BOOT MEANS THAT THE POWER TO THE COMPUTER IS TURNED
ECHO *    OFF AND THEN TURNED ON WITH THIS DISKETTE IN THE A: DRIVE.
ECHO *
ECHO *

A:\GETREPLY.EXE Did you cycle the power off and on (Y/N)? ;yn
IF ERRORLEVEL 2 GOTO NoCyclePWR	

:DoScan
REM ******************************************************************
REM **** PERFORM THE SCAN
REM ******************************************************************

CLS
ECHO *
ECHO *
ECHO *			MCAFEE VIRUS REMOVAL TOOL
ECHO *
ECHO *    WE ARE NOW READY TO BEGIN SCANNING YOUR DRIVE.  THANK YOU 
ECHO *    FOR CHOSING MCAFEE'S VIRUSSCAN FOR YOUR VIRUS PROTECTION NEEDS. 
ECHO *
ECHO *    MCAFEE WILL PERFORM A SCAN OF ALL LOCAL DRIVES FOR VIRUSES 
ECHO *    AND ATTEMPT TO CLEAN ANY INFECTIONS THAT ARE FOUND.  CERTAIN
ECHO *    VIRUSES MAY REQUIRE YOU TO REBOOT AND PERFORM THIS SCAN
ECHO *    AGAIN.  IF THE SCAN STALLS FOR MORE THAN 30 SECONDS THEN TURN
ECHO *    THE POWER OFF AND THEN BACK ON AGAIN WITH THIS DISKETTE IN 
ECHO *    THE A: DRIVE.
ECHO *
ECHO *
PAUSE

CLS
SCAN /ADL /ALL /CLEAN /NOBREAK
PAUSE

:DoErrors
REM ******************************************************************
REM ***  DO ERROR CHECKING
REM ******************************************************************
IF ERRORLEVEL 100 GOTO ErrorDOS
IF ERRORLEVEL 17 GOTO NoTarget
IF ERRORLEVEL 16 GOTO BadAccess
IF ERRORLEVEL 15 GOTO BadScanEXE
IF ERRORLEVEL 14 GOTO Update
IF ERRORLEVEL 13 GOTO VirusFound
IF ERRORLEVEL 12 GOTO BadClean
IF ERRORLEVEL 11 GOTO ProgError
IF ERRORLEVEL 10 GOTO VirusInMemory
IF ERRORLEVEL 8  GOTO MissingDat
IF ERRORLEVEL 6  GOTO ProgError
IF ERRORLEVEL 5  GOTO ProgError
IF ERRORLEVEL 3  GOTO BadAccess
IF ERRORLEVEL 2  GOTO BadDats
IF ERRORLEVEL 1  GOTO BadAccess
IF ERRORLEVEL 0  GOTO Nada

REM ******************************************************************
REM ******  ERROR CHECKING ROUTINES                             ******
REM ******************************************************************

:Nada
REM ******************************************************************
REM *** errorlevel 0
REM ******************************************************************
CLS
IF %ERROR10%==1 GOTO ExitNoMem
ECHO *
ECHO *
ECHO *    No viruses were found in memory, or on any local drives!
ECHO *    When the prompt returns you should remove this diskette
ECHO *    and reboot your system.
ECHO *
ECHO *
GOTO Exit

:BadAccess
REM ******************************************************************
REM *** errorlevels 1, 3 & 16
REM ******************************************************************
CLS
ECHO *
ECHO *
ECHO *    An error has occurred while trying to access one of your local
ECHO *    drives.  Please reboot the machine with this diskette in the A: 
ECHO *    drive and reattempt the procedure.  If this error continues 
ECHO *    then it may be necessary to run some kind of disk diagnostic 
ECHO *    software on the drive before re-attempting the removal procedure.
ECHO *
ECHO *
GOTO Exit

:BadDats
REM ******************************************************************
REM *** errorlevel 2
REM ******************************************************************
CLS
ECHO *
ECHO *
ECHO *    An error occurred while trying to read the data files.  This 
ECHO *    could mean that either the diskette is damaged, has been 
ECHO *    modified or the floppy drive is slightly misaligned.  If you 
ECHO *    have a second machine you could boot from this disk and verify 
ECHO *    if the floppy drive is OK.  Since the diskette is write protected
ECHO *    it is unlikely that the file(s) were modified unless the write-
ECHO *    protection was forcefully over-ridden.
ECHO *
ECHO *
ECHO *
GOTO Exit

:ProgError
REM ******************************************************************
REM *** errorlevels 5, 6 and 11
REM ******************************************************************
CLS
ECHO *
ECHO *
ECHO *    There has been a problem with the VirusScan program. This 
ECHO *    could be caused by a corrupted file, low memory or a conflict 
ECHO *    with a piece of hardware. It is also possible that a virus 
ECHO *    is active and interfering with the program. Please cold boot 
ECHO *    this system again with this disk and try the scan again. If 
ECHO *    this problem continues please consult your manual on how
ECHO *    to create a new Emgergency Disk.
ECHO *
ECHO *
GOTO Exit

:MissingDat
REM ******************************************************************
REM *** errorlevel 8
REM ******************************************************************
CLS
ECHO *
ECHO *
ECHO *    One or more of the following files are missing: SCAN.DAT, 
ECHO *    NAMES.DAT, and CLEAN.DAT.  There is a good chance that this 
ECHO *    diskette may have been modified.  Please cold boot this system 
ECHO *    again with this disk and try the scan again. If this problem 
ECHO *    continues please consult your manual on how  to get a new copy
ECHO *    of this disk.
ECHO *
ECHO *

GOTO Exit


:VirusInMemory
REM ******************************************************************
REM *** errorlevel 10
REM ******************************************************************
CLS
ECHO *
ECHO *
ECHO *        W       A       R       N       I       N       G
ECHO *		
ECHO *    The signature of a virus was found in memory while performing
ECHO *    the memory scan.  It is unlikely that this disk is infected
ECHO *    as long as the write protect tab on the diskette was never
ECHO *    bypassed.  There are other possibilities.  You should check
ECHO *    the boot sequence in CMOS.  The hardware documentation that
ECHO *    came with your computer should discuss how to access this area.
ECHO *    Ensure that the sequence is A: first THEN C:.
ECHO *
ECHO *    It is also possible that you have a hard drive controller that
ECHO *    is placing an IMAGE of the infected Boot Record into memory.
ECHO *    If this is the case then the virus may not be active and could
ECHO *    possibly be removed.
ECHO *
ECHO *
A:\GETREPLY.EXE Would you like to attempt anyway (Y/N)? ;yn
IF ERRORLEVEL 2 GOTO Exit
GOTO ScanNOMEM

:BadClean
REM ******************************************************************
REM *** errorlevel 12
REM ******************************************************************
CLS
ECHO *
ECHO *
ECHO *    A problem has occurred in trying to clean a virus. Either the
ECHO *    CLEAN.DAT file is missing or corrupted or VirusScan was unable 
ECHO *    to clean the virus. Please check this diskette with the Validate
ECHO *    program included to make sure the files are all there and are 
ECHO *    not corrupted. If the files are ok, please cold boot the machine 
ECHO *    with this diskette and try the scan again. If the file will still 
ECHO *    not clean, you will need to delete them.
ECHO *
GOTO Exit

:VirusFound
REM ******************************************************************
REM *** errorlevel 13
REM ******************************************************************
CLS
ECHO *
ECHO *        W       A       R       N       I       N       G
ECHO *
ECHO *    One or more viruses were found on this computer. In many cases
ECHO *    the viruses were cleaned at the same time by the program. It 
ECHO *    is recommended that you cold boot this machine with this 
ECHO *    disk again and have it run another scan to insure that the 
ECHO *    computer is clean and no viruses were missed or were not cleaned.
ECHO *
ECHO *    In some cases, an infected file can not be cleaned without
ECHO *    damaging the file.  It will then be necessary to identify and
ECHO *    delete the infected file.  Please refer to the manual for
ECHO *    additional information on /Report {filename} to identify the
ECHO *    infected file and /Del to delete the file.  Then restore the file
ECHO *    from a backup.
ECHO *
GOTO Exit

:Update
REM ******************************************************************
REM *** errorlevel 14
REM ******************************************************************
CLS
ECHO *
ECHO *
ECHO *    Your virus data files are getting old and you should update 
ECHO *    them.  This is not a major problem.  However, there may be 
ECHO *    viruses on this machine that are not detectable by this version 
ECHO *    of the software.  By updating your software you are getting 
ECHO *    the most protection possible.  Please consult your manual for 
ECHO *    update information.
ECHO *
ECHO *
GOTO Exit

:BadscanEXE
REM ******************************************************************
REM *** errorlevel 15
REM ******************************************************************
CLS
ECHO *
ECHO *
ECHO *    The self-check has failed.  This may be caused by a damaged 
ECHO *    or modified SCAN.EXE file or problem with the floppy drive. 
ECHO *    First, at the A: prompt run VALIDATE SCAN.EXE and verify the 
ECHO *    validation code against the code in the PACKING.LST file. 
ECHO *    The PACKING.LST file will be displayed on exit.
ECHO *
ECHO *
PAUSE
GOTO AbortSLFCHK

:NoTarget
REM ******************************************************************
REM *** errorlevel 17:  Possible encrypting virus
REM ******************************************************************
IF %ERROR17%==1 GOTO EncManualRemove
CLS
ECHO *
ECHO *
ECHO *    Scan has reported that there is no target specified for 
ECHO *    scanning.  This could be due to an encrypting virus or a 
ECHO *    possible hardware issue.  Another scan will be attempted 
ECHO *    to remedy the situation.
ECHO *
ECHO *    Please stand by...
ECHO *
ECHO *
GOTO ScanCDrive

:ErrorDOS
REM ******************************************************************
REM *** DOS Error
REM ******************************************************************
CLS
ECHO *
ECHO *
ECHO *    A DOS error has occurred.  Please consult your DOS manual 
ECHO *    for details or contact your DOS vendor for assistance.
ECHO *
ECHO *
GOTO Exit


REM ******************************************************************
REM ****  AUXILLARY PROCEDURES
REM ******************************************************************


:AbortSLFCHK
REM ******************************************************************
REM self check failed
REM ******************************************************************
CLS
TYPE PACKING.LST
GOTO Exit

:NoCyclePwr
REM ******************************************************************
REM user said that he did not cycle the power off
REM ******************************************************************
CLS
ECHO *
ECHO *
ECHO *    It is strongly recommended that you leave this diskette in the
ECHO *    the A: drive and turn the power to the computer off and then 
ECHO *    on.  Some viruses are capable of surviving a warm boot or a
ECHO *    CTRL+ALT+DEL by remaining in memory.
ECHO *
ECHO *
GOTO Exit

:ScanNOMEM
REM ******************************************************************
REM *****  ATTEMPT TO BYPASS MEMORY SCAN
REM ******************************************************************
CLS
ECHO *
ECHO *
ECHO *    If no virus is found on the hard drive(s) then most likely 
ECHO *    the virus is active and it is a stealth type virus.  If a 
ECHO *    virus is found it is recommended that you boot to this diskette
ECHO *    a second time to ensure the virus has been removed.
ECHO *
ECHO *
SET ERROR10=1
SCAN /ADL /ALL /CLEAN /NOMEM /NOBREAK
GOTO DoErrors

:ScanCDrive
REM ******************************************************************
REM ***  Run scan on only the C: drive
REM ******************************************************************
SET ERROR17=1
SCAN C: /NOBREAK /ALL
GOTO DoErrors

:EncManualRemove
REM ******************************************************************
REM *** The Scan C: /CLEAN didn't work
REM ******************************************************************
CLS
ECHO *
ECHO *
ECHO *    The same error has occurred again.  If this is due to a virus 
ECHO *    you may need to perform a manual removal in this case.  It 
ECHO *    is also possible that you are experiencing some hardware issues.
ECHO *    Try running a disk diagnostic program to see if it can clear up 
ECHO *    the problem.
ECHO *
ECHO *
GOTO Exit

:ExitNoMem
REM ******************************************************************
REM *****  EXIT AFTER USING NOMEM AND VIRUS WAS FOUND PREVIOUSLY
REM ******************************************************************
CLS
ECHO *
ECHO *
ECHO *    Scan did not find a virus on the second pass.  However, because 
ECHO *    a virus was found in memory it is possible that there may still 
ECHO *    be a virus active on the hard drive.  Again, as long as the write 
ECHO *    protect tab on this diskette was never bypassed, it is unlikely 
ECHO *    that this disk is infected.  There are other possibilities why 
ECHO *    traces of a virus are still in memory.  
ECHO *
ECHO *    You should check the boot sequence in CMOS.  The hardware 
ECHO *    documentation that came with your computer should discuss 
ECHO *    how to access this area.  Ensure that the sequence is A: 
ECHO *    first THEN C:  Try cold booting your system again using this diskette
ECHO *    and run another scan.  If a virus continues to show up in memory, 
ECHO *    then there may be a compatibility issue with some hardware 
ECHO *    in the computer.
ECHO *
ECHO *
GOTO Exit

@ECHO OFF
:Exit
echo exit
