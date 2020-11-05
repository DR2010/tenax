ON ERROR DO errproc		&&establish error routine
ON ESCAPE DO escproc		&&establish escape proc
SET PROCEDURE TO foxinst
DO WHILE .T.			&&this allows RETURN TO MASTER
   DO main 
ENDDO

PROCEDURE main  
homedir = SYS(2004)		&&get directory where foxplus.exe lives
SET TYPEAHEAD TO 0		
@ 18, 0 CLEAR 
SET SAFETY OFF
SET ESCAPE ON
SET TALK OFF
?? SYS(2002)			&&turn cursor off
SET SCOREBOARD OFF
SET STATUS OFF
PUBLIC lowmem
IF AT("386",VERS()) = 0
   DO checkmem
ENDIF
DO msgline WITH "Select an installation option."
DO statline
mi = 0				&&draw main pop-up menu
DIMENSION m(3)
m(1) = 'Install all optional software'
m(2) = 'Install selected optional software'
m(3) = 'Install no optional software - quit'
@ 7,16 MENUS m, 3 TITLE '[ FoxBASE+ Optional Software Installation ]'
DO WHILE mi = 0			&&loop until they select something
   READ MENUS TO mi
   DO CASE 
   CASE READKEY() <> 15		&&trap for escape key
      mi = 0
   CASE mi = 1
      DO install WITH .T.	&&install everything
   CASE mi = 2
      DO install WITH .F.	&&let them pick and choose
   ENDCASE
ENDDO
DO msgline WITH "Installation complete.  Press any key to continue."
DO finished
RETURN

PROCEDURE install 
PARAMETERS allfiles
PUBLIC thisone
SELECT A
USE foxinst.dbf 
INDEX ON STR(diskno,2) + STR(seqno,2) TO foxinst
lastdisk = 0
DO WHILE .NOT. EOF(1)
   IF lastdisk <> diskno 
      DO insrtdsk
      lastdisk = diskno
   ENDIF
   IF allfiles
      DO tellfile		&&tell them what were installing
      thisone = .T.
   ELSE
      thisone = askfile()	&&ask them if they want to install this
   ENDIF
   IF thisone
      IF .NOT. FILE("A:"+filename) 
         DO insrtdsk
      ENDIF
      IF subdir <> SPACE(8)	&&install in a sub-directory?
         DO makedir
      ENDIF
      IF archived		&&need to unarchive?
         DO unarch
      ELSE
         DO copyfile		&&just need to copy.
      ENDIF
      IF installprc <> SPACE(8)	&&any external program needed?
         SAVE SCREEN TO X
         ip = TRIM(installprc)	&&do that install proc!
         DO &ip			
         ON ERROR DO errproc
         ON ESCAPE DO escproc
         RESTORE SCREEN FROM X
         DO statline
      ENDIF
   ENDIF
   SKIP	   
ENDDO
RETURN


PROCEDURE insrtdsk		&&this routine is invoked when it's time 
DO statline			&&to insert a new disk
@ 0,0 CLEAR TO 21, 79
@ 5, 10 TO 10,70 DOUBLE
DO msgline WITH "Press Esc to abort, any other key to continue"
SET COLOR TO W+/N
@ 7, 22 SAY "Please insert disk #" + STR(diskno, 2) + " into drive A: "
SET COLOR TO
WAIT ""
DO WHILE .NOT. FILE("A:"+filename)  &&loop until we find that file
   SET COLOR TO W+/N
   @ 7, 18 SAY "The file " + TRIM(filename) + " was not found on that disk."
   @ 8, 22 SAY "Please insert disk #" + STR(diskno, 2) + " into drive A: "
   SET COLOR TO
   WAIT ""
ENDDO
@ 5, 10 CLEAR TO 10, 70
DO statline
RETURN

PROCEDURE makedir	   	&&this routine makes a directory
newdir = homedir+TRIM(subdir)
newfil = newdir + '\' + "temp.txt"
itsthere = .T.	    
ON ERROR STORE .F. TO itsthere	&&try to figure out if a dir is there already
SET ALTERNATE TO &newfil	&&by setting alternate to a file in it
ON ERROR DO errproc		&&and trapping the error if its not there
IF itsthere					
   SET ALTERNATE TO
   DELETE FILE &newfil
ELSE
   SET ALTERNATE TO
   DO msgline WITH "Making subdirectory " + newdir
   ! md &newdir
   DO statline
ENDIF
RETURN

PROCEDURE unarch   		&&this routine unarchives files using pkxarc
DO msgline WITH "Unarchiving from file " + TRIM(filename)
IF .NOT. lowmem
   arccmd = "pkxarc -r a:" + filename + " " + homedir + TRIM(subdir) + " > nul"
ELSE
   arccmd = "pkxarc -r a:" + filename + " " + homedir + TRIM(subdir) 
ENDIF
IF .NOT. FILE('pkxarc.com') 
   DO errproc2 WITH 'Unable to find PKXARC.COM.  Installation aborted.'	 
ENDIF
IF DISKSPACE() < 700000		 
   DO errproc2 WITH 'Out of disk.  Installation aborted.'
ENDIF
IF .NOT. lowmem
   ! &arccmd  
ELSE
   STORE recno() TO lastrec
   &arccmd		   
   GO lastrec
ENDIF
DO statline
RETURN

PROCEDURE copyfile		&&this routine copies files 
DO msgline WITH "Copying file " + TRIM(filename)
ff = "A:" + filename
IF LEN(TRIM(subdir)) > 0
   tf = homedir+TRIM(subdir)+'\'+TRIM(filename)
ELSE
   tf = homedir + TRIM(filename)		
ENDIF
COPY FILE &ff. TO &tf
DO statline
RETURN

PROCEDURE errproc		&&our on error routine
DO msgline WITH MESSAGE() + "  Installation aborted."
DO finished
RETURN

PROCEDURE finished		&&our clean-up-and-go-home routine
ON ESCAPE X =1
@ 0,0 SAY SYS(2002,1)		&&turn cursor on
WAIT ""	      
QUIT
RETURN

PROCEDURE errproc2		&&quit with a specified message.
PARAMETERS msg
DO msgline WITH msg
DO finished
RETURN

PROCEDURE escproc		&&handle the escape key
SAVE SCREEN TO X	
DO msgline WITH 'Esc was pressed.  Please indicate what you wish to do.'
m(1) = 'Abort installation'
m(2) = 'Return to Installation Options menu'
m(3) = 'Continue installation'
@ 9, 12 MENUS m, 3 TITLE '[ Esc Options ]'
mi = 0
DO WHILE mi = 0
   READ MENUS TO mi
   DO CASE
   CASE READKEY() <> 15
      mi = 0
   CASE mi = 1
      DO errproc2 WITH 'Installation aborted. Press a key to continue.'
   CASE mi = 2
      RETURN TO MASTER
   CASE mi = 3
      RESTORE SCREEN FROM X	
      RETRY
   ENDCASE
ENDDO
RETURN

PROCEDURE fileinfo		&&display the description fields
@ 0, 0 CLEAR TO 21, 79
@ 5, 2 TO 9,76 DOUBLE
SET COLOR TO W+/N
@ 6, 4 SAY descript1
@ 7, 4 SAY descript2
@ 8, 4 SAY descript3
SET COLOR TO
RETURN

PROCEDURE tellfile		&&tell them what we're installing 
DO fileinfo
@ 5, 30 SAY '[ Now Installing ]'
RETURN

PROCEDURE askfile		&&ask them if they want to install
DO msgline WITH 'Do you wish to install ' + TRIM(filename) + '?'
DO fileinfo
DO statline
m(1) = '  Yes  '
m(2) = '  No   '
@ 12,16 MENUS m, 2 TITLE '[ Install? ]'
mi = 0
DO WHILE mi = 0
   READ MENUS TO mi 
   DO CASE 
   CASE READKEY() <> 15		
      mi = 0
   CASE mi = 1
      @ 5, 30 SAY '[ Now Installing ]'
      RETURN .T.
   CASE mi = 2
      RETURN .F.
   ENDCASE
ENDDO


PROCEDURE statline		&&display the status line
SET COLOR TO N/W+
@ 22, 0 SAY SPACE(80)
@ 22, 1 SAY "Home directory: " + homedir
@ 22, 44 SAY "Avail. Disk Space: " + LTRIM(TRANSFORM(DISKSPACE()/1024,"999,999 Kbytes"))
SET COLOR TO
RETURN		

PROCEDURE msgline		&&display line 24
PARAMETERS msg		
SET COLOR TO W+/N
@ 24,0 CLEAR TO 24, 79
@ 24, INT(((80 - LEN(msg)) /2) - 1) SAY msg		
SET COLOR TO
RETURN			       

PROCEDURE strtbug		&&call this to start the echo output going
dbgfile = SYS(3)	        &&to a temp file on drive G:		
SET PRINT TO G:&dbgfile		&&(debugging routine)
SET DEBUG ON
SET ECHO ON
SET TALK ON
RETURN

PROCEDURE ndbug			&&call this to stop the echo output going 
SET ECHO OFF			&&to a file
SET TALK OFF
RETURN 

PROCEDURE checkmem 
IF VAL(SYS(12)) < 161000
   ON ESCAPE DO freemem
   STORE .T. TO lowmem
   STORE .T. TO freemem
   DO msgline WITH "Press escape to abort, any other key to continue"
   STORE LTRIM(STR(161000-VAL(SYS(12))))+" Bytes"  TO needmem
   @ 0,0 CLEAR TO 21,79
   @ 5, 1 TO 12,77 DOUBLE  
   @ 5,20 SAY "[ Optional Software Install Routine ]"
   SET COLOR TO W+/N
   @ 6, 3 SAY "You do not have enough memory "+;
               "to run the standard install routine.  The"
   @ 7, 3 SAY "alternate install routine will be invoked. "+;
              " The alternate install routine"
   @ 8, 3 SAY "does not execute as quickly as the standard "+;
              "install routine.  If you "
   @ 9,3 SAY "would like to run the standard install routine"+;
             " you must free "+needmem
   @ 10,3 SAY "more of memory.  Press escape to abort the "+;
              "installation routine and "
   @ 11,3 SAY "attempt to free more memory."
   WAIT ""
   ON ESCAPE DO escproc
   CLEAR
   SET COLOR TO
ELSE
   STORE .F. TO lowmem
ENDIF	 

PROCEDURE freemem
CLEAR
@ 5,7 TO 09,69 DOUBLE
@ 6,9 SAY "To restart the installation procedure simply type INSTALL2"	  
@ 7,9 SAY "at the DOS prompt of the FoxBASE+ home directory.  INSTALL2"
@ 8,9 SAY "is a batch file used to install the optional software."
DO msgline WITH "Press a key to return to DOS."
DO finished

*: EOF: FOXINST.PRG
