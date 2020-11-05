*---------------------------------------------------------------------------*
* >>>>>>>>>>>>>>>>>>>>>>>>>>>  F U N C A O <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<< *
*                                                                           *
* Sistema...:                                                               *
* Modulo....:                                                               *
* Descricao.: Conjunto de rotinas e funcoes comuns a todos os modulos       *
* Chamador..: *                                                             *
* Chamados..: *                                                             *
*---------------------------------------------------------------------------*
* Cliente...:                                                               *
* Analistas.: Daniel Luiz Guimaraes Machado                                 *
* Autor.....: Daniel Luiz Guimaraes Machado                                 *
* Inicio....: 01/08/93                                                      *
*---------------------------------------------------------------------------*

#include "inkey.ch"
#include "sic.ch"
#define ATTR_CONV( FORE, BACK ) (BACK)*16+(FORE)
#define BLACK 0
#define WHITE 7
#define DK_GRAY 8
#define COL_SHADOW_ATTRIBUTE ATTR_CONV(DK_GRAY, BLACK)
#define BW_SHADOW_ATTRIBUTE  ATTR_CONV(WHITE,       BLACK)
#define LI_SEPH "Ä"
#define LI_SEPR "Í"
#define LI_SEPV "³"

*---------------------------------------------------------------------------*
* Procedimento :
* Finalidade ..:
* Parametros ..:
* Autor .......: Daniel Luiz Machado
*---------------------------------------------------------------------------*
PROCEDURE status( PMSG )
local P_OLDCOR := setcolor()
   // setcolor( W_PDCOR )
   // @ 23,03 SAY '> '+pMsg
   // setcolor( P_OLDCOR  )

RETURN

*---------------------------------------------------------------------------*
* Procedure ...: conf
* Finalidade ..:
* Parametros ..:
* Autor .......: Daniel Luiz Guimaraes Machado
*---------------------------------------------------------------------------*
function conf( MSG, IMP )
static WTOP, WLEFT
private WRET := "*"
private  WBOTTOM, WRIGHT, WRET := .T., WVAR := " ", WMEIO, getlist := {}
private  W_OLDCOR := setcolor(); W_OLDCURS := setcursor()
set cursor on

MSG := MSG +"(S/N) ?"

WTOP    := 10
WLEFT   := int( (80-len( MSG ))/2 )
WBOTTOM := WTOP + 4
WRIGHT  := WLEFT + len(MSG) + 3
WMEIO   := WLEFT + 2

setcolor( W_CORPERG  )
ssavT := savescreen( WTOP, WLEFT, WBOTTOM+1, WRIGHT+1 )
ssav := savescreen( WTOP, WLEFT, WBOTTOM, WRIGHT )

_box(WTOP,WLEFT,WBOTTOM,WRIGHT,"EX")
sombra( WTOP,WLEFT, WBOTTOM, WRIGHT )

@ WTOP+2, WMEIO say MSG

WHAT_WALK := savescreen( WTOP, WLEFT, WBOTTOM, WRIGHT )

while .t.
   // setcolor( "W/B,W+/BG,N/N,N/N,N/W" ) // C_PADRAO
   @ WTOP+2, WRIGHT-2 say ''
   inkey(0)

   do case
   case lastkey()=5 // cima

      if WTOP > 0
        restscreen( WTOP, WLEFT, WBOTTOM+1, WRIGHT+1, SSAVT )
        WTOP--
        WBOTTOM--
        ssav := savescreen( WTOP, WLEFT, WBOTTOM, WRIGHT )
        ssavT := savescreen( WTOP, WLEFT, WBOTTOM+1, WRIGHT+1 )
        restscreen( WTOP, WLEFT, WBOTTOM, WRIGHT, WHAT_WALK )
        sombra( WTOP,WLEFT, WBOTTOM, WRIGHT )
      end

   case lastkey()=24 // baixo

      if WBOTTOM < 23
        restscreen( WTOP, WLEFT, WBOTTOM+1, WRIGHT+1, SSAVT )
        WTOP++
        WBOTTOM++
        ssav := savescreen( WTOP, WLEFT, WBOTTOM, WRIGHT )
        ssavT := savescreen( WTOP, WLEFT, WBOTTOM+1, WRIGHT+1 )
        restscreen( WTOP, WLEFT, WBOTTOM, WRIGHT, WHAT_WALK )
        sombra( WTOP,WLEFT, WBOTTOM, WRIGHT )
      end

   case lastkey()=4 // direita

      if WRIGHT < 78
        restscreen( WTOP, WLEFT, WBOTTOM+1, WRIGHT+1, SSAVT )
        WLEFT++
        WRIGHT++
        ssav := savescreen( WTOP, WLEFT, WBOTTOM, WRIGHT )
        ssavT := savescreen( WTOP, WLEFT, WBOTTOM+1, WRIGHT+1 )
        restscreen( WTOP, WLEFT, WBOTTOM, WRIGHT, WHAT_WALK )
        sombra( WTOP,WLEFT, WBOTTOM, WRIGHT )
      end

   case lastkey()=19 // esquerda
      if WLEFT > 0
        restscreen( WTOP, WLEFT, WBOTTOM+1, WRIGHT+1, SSAVT )
        WLEFT--
        WRIGHT--
        ssav := savescreen( WTOP, WLEFT, WBOTTOM, WRIGHT )
        ssavT := savescreen( WTOP, WLEFT, WBOTTOM+1, WRIGHT+1 )
        restscreen( WTOP, WLEFT, WBOTTOM, WRIGHT, WHAT_WALK )
        sombra( WTOP,WLEFT, WBOTTOM, WRIGHT )
      end

   case chr( lastkey() ) = "S" .or. chr( lastkey() ) = "s"
      WRET := .T.
      exit

   case chr( lastkey() ) = "N" .or. chr( lastkey() ) = "n"
      WRET := .F.
      exit
   endcase
end

restscreen( WTOP, WLEFT, WBOTTOM+1, WRIGHT+1, SSAVT )
setcursor( W_OLDCURS )
setcolor( W_OLDCOR )

return WRET


PROCEDURE zerofill( PVAR ) // strzero
local WRET

   WRET := strzero( val( PVAR ), len( PVAR ) )

RETURN WRET


PROCEDURE message(pMsg)
   local W_COR := setcolor()
   setcolor( W_PDCOR )
   @ 23,04 CLEAR to 23,78
   @ 23,03 SAY '> '+pMsg
   setcolor( W_COR )
RETURN

/*
Procedimento : LIMPA_BUT
Parametros   :
Retorno      :
Objetivo     :
*/
procedure LIMPA_BUT()

setcolor(W_COREDIT)
@ 17,04 clear to 20,76

return
/*
Procedimento : CRIA_BUT
Parametros   :
Retorno      :
Objetivo     :
*/
procedure cria_but( LIN, COL, BOTAO, HOTLIN, HOTCOL, HOTKEY )
   local W_OLDCUR := setcursor(), W_OLDCOR := setcolor(), COLFIM

   setcursor(0)
   COLFIM := COL + len( BOTAO )
   setcolor(W_BOTOES)
   @ LIN,COL say BOTAO
   meiasombra( LIN, COL, LIN, COLFIM-1 )
   setcolor(W_FIRSTLET)
   @ HOTLIN,HOTCOL say HOTKEY
   setcursor( W_OLDCUR )
   setcolor( W_OLDCOR )
return

/*
Procedimento : PUSH_BUT
Parametros   :
Retorno      :
Objetivo     :
*/
procedure push_but( LIN, COL, BOTAO )
   local FIRSTL := left( alltrim(BOTAO), 1 ), COLFIM, TAMBOT
   local W_OLDCUR := setcursor(), W_OLDCOR := setcolor()

   setcursor(0)
   TAMBOT := len( BOTAO )

   COLFIM := COL + TAMBOT

   setcolor(W_COREDIT)
   @ LIN,  COL   say space( TAMBOT+1 )
   @ LIN+1,COL   say space( TAMBOT+1 )

   setcolor(W_BOTOES)
   @ LIN+1,COL+1 say BOTAO
   inkey(0.1)

   setcolor(W_COREDIT)
   @ LIN,  COL   say space( TAMBOT+1 )
   @ LIN+1,COL   say space( TAMBOT+1 )

   setcolor(W_PUSHBOT)
   @ LIN,COL say BOTAO
   meiasombra(LIN,COL,LIN,COLFIM-1)

   setcursor(W_OLDCUR)
   setcolor( W_OLDCOR )
return

*---------------------------------------------------------------------------*
* Funcao ......: MEIASOMBRA
* Finalidade ..:
* Parametros ..:
* Retorno .....:
* Autor .......:
*---------------------------------------------------------------------------*
function meiasombra( tw, lw, bw, rw )
   local W_OLDCOR := setcolor()

   setcolor(W_COREDIT) //("N/BG")
   for X:=LW+1 to RW+1
      @ BW+1,X say 'ß'
   next

   for X:=TW to BW
      @ X,RW+1 say 'Ü'
   next

   setcolor( W_OLDCOR )
return NIL





PROCEDURE encripta( )
RETURN

PROCEDURE decripta( )
RETURN

PROCEDURE recchoice( )
RETURN


