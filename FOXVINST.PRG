if file('foxview.cfg')
    copy file foxview.cfg to foxview.bak
    delete file foxview.cfg
endif
do msgline with 'Indicate your monitor type for FoxView configuration.'
dime monmenu(4)
monmenu(1) = 'Monochrome monitor'
monmenu(2) = 'Color monitor'
monmenu(3) = 'Dual monitor (COMPAQ)'
monmenu(4) = 'Composite monitor'
mi = 0		    
@ 9, 10 menu monmenu, 4 title '[ Monitor type ]'
do while mi = 0
    read menu to mi 
    do case
    case readkey() <> 15
	mi = 0 
    case mi = 1
	monitor = 'MONO'
    case mi = 2
    	monitor = 'COLOR'
    case mi = 3
	monitor = 'DUAL'
    case mi = 4
	monitor = 'COMPOSITE'
    endcase
enddo				  
do msgline with 'Enter your name and company for FoxView configuration.'
name = 'Your Name              '
co =   'Your Company           '
@ 8,8 clear to 11, 50
@ 8,8 to 11, 50 double
@ 0, 0 say sys(2002,1)
@ 9,10 say   'Your name    ' get name
@ 10, 10 say 'Your Company ' get co
read	    
@ 0,0 say sys(2002)
serno = sys(9)
! fvbrand &serno

clear
set colo to n/n
set alte to foxview.cfg
set alte on
text
* FOXVIEW.CFG
*
* ---General parameters:
endtext
? 'Video = '+ monitor + '       *  MONO,COLOR,DUAL,COMPOSITE'
text
Pause = ON         * Pause after one screen-full in Shell
FillChar = " "     * Fill character for Labels when loaded
SelectAtr = 9      * Color for selected fields (LightBlue)
StatusAtr = 1      * Color for status area (Blue)
WindowAtr = 4      * Color for window area (Red)
PromptAtr = 6      * Color for prompt area (Brown)
FormStatLines = 2  * Forms View status lines (0,1,2)
*
* ---Box parameters:
BoxAtr = 112       * Color for selected boxes (Inverse)
BoxWidth = 30
BoxHeight = 5
BoxString1 = "’Õ∏≥≥‘Õæ"
BoxString2 = #214#196#183#186#186#211#196#189
BoxString3 = "+-+||+-+"
*
* ---Code generator parameters:
endtext
? 'DefCodePath = "' + sys(2004) + 'templcod"         * Pathname to .COD files'
text
GenMemVar = OFF           * Generate Programs with memory variables
endtext			      
? 'Author = "'+ name + '"'
? 'Copyright = "'+co+'"'
text
ScreenColor = 'R+/N,N/W'  * Color for entire screen
StatusColor = "BU/N,N/W"  * Color for status area
WindowColor = "R+/N,N/W"  * Color for window area
PromptColor = "GR+/N,N/W" * Color for prompt area
HiliteColor = "N/W"       * Color for Hilited prompt char
*
* ---Product MENU parameters:
DefProductCode = "1"      * Default Product ("1".."9","A".."G")
Product1 = "FoxBASE+, version 2.10"
*
* ---Product MESSAGE parameters:
Message1 = "If ON, programs will run with FoxBASE+ 2.10"
*
* EOF: FOXVIEW.CFG
endtext
set alte off
set alte to
set colo to
return
