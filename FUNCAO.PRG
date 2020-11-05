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
/*

--> Procedimentos ou funcoes do sistema contidos neste modulo <---

BUSCA        - Busca determinado conteudo em determinado arquivo
BUSCAIMP     - Faz busca em arquivo e mostra conteudo do campo
CENTRO       - Retorna coluna para impressao
CONFIRMAIMP  - Pergunta de confirma impressao
DH_DECTIME   - Mostra tempo decorrido.
DH_HORPROJ   - Projeta tempo final.
DH_IMPRIME   - Envia impressao para arquivo ou impressora.
DH_IMPOFF    - Desliga impressora.
DH_SHOWTIME  - Mostra relogios de projecao.
DH_TEMPDEC   - Calcula tempo decorrido.
DH_ERRO      - Mostra mensagem de erro em local padrao
DESCRIPT     - Descriptografar
ENCRIPT      - Criptografar
ESPERA       - Emite mensagem e espera usuario teclar ENTER
ESTADO       - Valida estados brasileiros
GETSENHA     - Pede senha.
LOC          - Bloqueio de registro
LER_REL      - mostra relatorio no video.
MENU         - Cria menu estilo pop-up
MENSAGEM     - Mostra mensagem em local padrao
MENSBEEP     - Mostra mensagem de advertencia ou conclusao de procedimento
PERGUNTA     - Faz pergunta com resposta sim/nao
PERGRESP     - Faz pergunta para qualquer resposta
QUADRO       - Desenha quadro
SHOW_BAR     - Mostra barra horizontal de acordo com arquivo.
TELA         - Monta tela padrao
ZERO         - Retorna caracter com zeros a esquerda
*/

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

*- (01) --------------------------------------------------------------------*
* funcao ......: BUSCA
* finalidade ..: fazer uma busca em arquivo
* parametros ..: <expc> alias do arquivo
*                <expc> chave
*                <expn> ordem
* retorno .....: <expl> .t. = chave encontrada
* autor .......: Daniel Luiz Guimaraes Machado
*---------------------------------------------------------------------------*
function busca(PARQ,PCHAVE,PORDEM)
local WRET
select &PARQ
set order to pordem
seek PCHAVE
WRET = .t.
if ! found()
   WRET = .f.
endif
return(WRET)

*- (02) --------------------------------------------------------------------*
* Funcao ......: BUSCAIMP
* Finalidade ..: Fazer uma busca em arquivo e mostrar conteudo de um campo
* Parametros ..: <ExpC> Chave
*                <ExpC> Alias do arquivo
*                <ExpN 1,2> Linha,coluna onde vai ser impresso o campo
*                <ExpC> Campo a ser impresso
* Retorno .....: <ExpL> .T. = Chave encontrada
* Autor .......: Daniel Luiz Guimaraes Machado
*---------------------------------------------------------------------------*
FUNCTION buscaImp(PCHAVE, PARQ, PLIN, PCOL, PCAMPO)
LOCAL wRet
select &PARQ
seek PCHAVE
WRET := .F.
if FOUND()
   WRET := .T.
   @ PLIN, PCOL say &PCAMPO
endif
return( WRET )

*- (03) --------------------------------------------------------------------*
* Funcao ......: CENTRO
* Finalidade ..: Fornecer col. inicial para centralizar uma msg.
* Parametros ..: <ExpC> Msg. a ser centralizada
* Retorno .....: <ExpN> Coluna inicial
* Autor .......: Hugo B. Peixoto
*---------------------------------------------------------------------------*
FUNCTION Centro(pMsg)
RETURN (80 - LEN(pMsg))/2

*- (04) --------------------------------------------------------------------*
* Funcao ......: LOC
* Finalidade ..: Bloqueio de registro por N segundos
* Parametros ..: <Exp N> - numero de tentativas
* Retorno .....: <Exp L>
* Autor .......: Daniel Luiz Machado
*---------------------------------------------------------------------------*
function loc(N)
local WRET := .F., WSCR:=savescreen(10,16,15,39)

N:=if(N=NIL,0,N)

if N=0
   BLTENTATIVA := {|| .T. }
else
   BLTENTATIVA := {|| X <= N }
end

@ 10,16 say 'ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿'
@ 11,16 say '³                    ³'
@ 12,16 say '³ Tentativas :       ³'
@ 13,16 say '³                    ³'
@ 14,16 say 'ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ'
sombra(10,16,14,38)

X:=0
while eval( BLTENTATIVA )
   if rlock()
      WRET := .T.
      exit
   end
   @ 12,16 say X picture '9999'
   X++
end
restscreen(10,16,15,39,WSCR)
return WRET

*- (05) --------------------------------------------------------------------*
* Funcao ......: CONFIRMAIMP
* Finalidade ..: Confirmar se a impressora esta pronta para imprimir
* Parametros ..: <ExpC> Mensagem
* Retorno .....: <ExpL> .T. = Impressora pronta
* Autor .......: Hugo B. Peixoto
*---------------------------------------------------------------------------*
FUNCTION CONFIRMAIMP(pMsg)
LOCAL wTelaImp := SAVESCREEN(24,00,24,79), ;
      wMsg := IF(pMsg = NIL,'Coloque a impressora em linha ou tecle ESC para abortar.',pMsg)

IF .NOT. ISPRINTER() .AND. LASTKEY() # 27
   @ 24,00 CLEAR
       Mensagem(wMsg)
       DO WHILE .NOT. ISPRINTER() .AND. INKEY() # 27
       ENDDO
   RESTSCREEN(24,00,24,79,wTelaImp)
ENDIF

RETURN IF(LASTKEY() = 27,.F.,.T.)


*---------------------------------------------------------------------------*
* Procedimento : Mensagem
* Finalidade ..: Mostrar mensagem, em local padrao, ao usuario.
* Parametros ..: <ExpC> - Mensagem
* Autor .......: Daniel Luiz Machado
*---------------------------------------------------------------------------*
PROCEDURE mensagem(pMsg)
   local W_COR := setcolor()
   setcolor( W_PDCOR )
   @ 23,04 CLEAR to 23,78
   @ 23,03 SAY '> '+pMsg
   setcolor( W_COR )
RETURN

*---------------------------------------------------------------------------*
* Procedimento : MensWait
* Finalidade ..: Mostrar mensagem, em local padrao, ao usuario.
* Parametros ..: <ExpC> - Mensagem
* Autor .......: Daniel Luiz Machado
*---------------------------------------------------------------------------*
PROCEDURE menswait(pMsg)
   local W_COR := setcolor()
   setcolor( W_PDCOR )
   @ 23,04 CLEAR to 23,78
   @ 23,03 SAY '> '+pMsg
   setcolor( W_COR )
   // ?? chr(7)
   inkey(0)
RETURN

*---------------------------------------------------------------------------*
* Procedimento : MensImp
* Finalidade ..: Mostrar mensagem, enquanto imprime
* Parametros ..: <ExpC> - Mensagem
* Autor .......: Daniel Luiz Machado
*---------------------------------------------------------------------------*
PROCEDURE mensimp(pMsg)
   local W_COR := setcolor()
   set device to screen
   setcolor( W_PDCOR )
   @ 23,04 CLEAR to 23,78
   @ 23,03 SAY '> '+pMsg
   setcolor( W_COR )
   set device to print
RETURN

*---------------------------------------------------------------------------*
* Procedimento : dh_erro
* Finalidade ..: Mostrar mensagem de erro, em local padrao, ao usuario.
* Parametros ..: <ExpC> - Mensagem de erro.
* Autor .......: Daniel Luiz Machado
*---------------------------------------------------------------------------*
PROCEDURE dh_erro(pMsg)
LOCAL wLinha24 := SAVESCREEN(24,00,24,79)
@ 24,00 CLEAR
@ 24,00 SAY 'ERRO > '+pMsg
@ 00,00 SAY ''
// ? CHR(7)
INKEY(0)
RESTSCREEN(24,00,24,79,wLinha24)
RETURN

*---------------------------------------------------------------------------*
* Procedure ...: pergunta
* Finalidade ..:
* Parametros ..:
* Autor .......: Daniel Luiz Guimaraes Machado
*---------------------------------------------------------------------------*
function pergunta( MSG, IMP )
static WTOP, WLEFT
private WRET := "*"
private  WBOTTOM, WRIGHT, WRET := .T., WVAR := " ", WMEIO, getlist := {}
private  W_OLDCOR := setcolor(); W_OLDCURS := setcursor()

if IMP = NIL
   IMP := "N"
end

// pergunta enquanto imprime

if IMP = "S"
   set device to screen
end
set cursor on

if WTOP = NIL
   WTOP    := 10
   WLEFT   := int( (80-len( MSG ))/2 )
end

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
   setcolor( W_CORPERG )
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

if IMP = "S"
   set device to print
end

return WRET

*---------------------------------------------------------------------------*
* Procedure ...: pergresp
* Finalidade ..:
* Parametros ..:
* Autor .......: Daniel Luiz Guimaraes Machado
*---------------------------------------------------------------------------*
function pergresp( MSG, PCONDICAO, WTOP, WLEFT )
// static WTOP, WLEFT
private WRET := "*"
private  WBOTTOM, WRIGHT, WRET := "", WVAR := " ", WMEIO, getlist := {}
private  W_OLDCOR := setcolor(); W_OLDCURS := setcursor()

set cursor on

if WTOP = NIL
   WTOP    := 10
   WLEFT   := int( (80-len( MSG ))/2 )
end

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
   setcolor( W_CORPERG  )
   @ WTOP+2, WRIGHT-2 say ''
   /*
   @ 23,04 CLEAR to 23,67
   @ 23,03 SAY '> ' + pPerg GET wResp PICTURE '!' VALID wResp $ pCondicao
   READ
   @ 23,04 CLEAR to 23,67
   IF LASTKEY() = 27
      wResp := '*'
   ENDIF

   */
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

   case upper( chr( lastkey() )) $ pCondicao .or. lastkey()=13
      if lastkey()#13
         WRET := upper( chr( lastkey() ))
      else
         WRET := upper( left( pCondicao, 1 ) )
      end
      exit
   case lastkey() = K_ESC
      WRET := "*"
      exit

   endcase
end

restscreen( WTOP, WLEFT, WBOTTOM+1, WRIGHT+1, SSAVT )
setcursor( W_OLDCURS )
setcolor( W_OLDCOR )

return WRET

*---------------------------------------------------------------------------*
* Procedure ...: WINDOW
* Finalidade ..:
* Parametros ..:
* Autor .......: Daniel Luiz Guimaraes Machado
*---------------------------------------------------------------------------*
procedure window( WTOP, WLEFT, WBOTTOM, WRIGHT, FSOMBRA )
local W_OLDCOR := setcolor()

setcolor( W_CORPERG  )
_box( WTOP, WLEFT, WBOTTOM, WRIGHT, "EX")

if FSOMBRA
   sombra( WTOP, WLEFT, WBOTTOM, WRIGHT )
end
setcolor( W_OLDCOR )
return

*---------------------------------------------------------------------------*
* Procedure ...: MENU
* Finalidade ..:
* Parametros ..:
* Autor .......: Daniel Luiz Guimaraes Machado
*---------------------------------------------------------------------------*
function menu( WVETOR, WTOP, WLEFT, WTIT,WCOR )
local W_OLDCOR, WBOTTOM:=WRIGHT:=0, X:=0, ;
      WMAIORTAM:=0, WRET:="000", WESP := 0, PVET := {}, ;
      WSCREEN := savescreen(,,,,)

if len( WVETOR ) > 0
   W_OLDCOR := setcolor()

   if WTIT <> nil
      WMAIORTAM := len( WTIT )
   end

   if WCOR = NIL
     setcolor( W_CORSUBM  )
   ELSE
     setcolor( WCOR )
   END
   for X := 1 to len( WVETOR )
      aadd( PVET, WVETOR[X,1] )
      if len( WVETOR[X,1] ) > WMAIORTAM
	 WMAIORTAM := len( WVETOR[X,1] )
      end
   next
   WRIGHT  := WLEFT + WMAIORTAM + 3
   WBOTTOM := WTOP  + len( WVETOR ) + 1

   @ WTOP, WLEFT to WBOTTOM, WRIGHT
   sombra( WTOP, WLEFT, WBOTTOM, WRIGHT )

   if WTIT <> nil
      WIMP := int (( (WRIGHT-WLEFT)-LEN(WTIT) ) / 2) + WLEFT
      if WIMP-2 <= WLEFT
	 @ WTOP,WIMP say ' ' + WTIT + ' '
      else
	 @ WTOP,WIMP-1 say '´ ' + WTIT + ' Ã'
      end
   end

   // WESP := achoice( WTOP+1, WLEFT+1, WBOTTOM, WRIGHT-1, PVET )

   for X := 1 to len( PVET )
      @ ++WTOP,WLEFT+1 prompt ' '+PVET[X]+' '
   next
   menu to WESP

   WRET := strzero( WESP, 3 )

   do case
      case lastkey() = 27
	 WRET := '000'
      case lastkey() = 19
	 WRET := "ESQ" // esquerda
      case lastkey() =  4
	 WRET := "DIR" // direita
      otherwise
	 X := " {|| " + WVETOR[ WESP, 2 ] + "() }"
	 Y := &( X )
	 setcolor( W_OLDCOR )
	 eval( Y )

   endcase

   restscreen(,,,,WSCREEN )

   setcolor( W_OLDCOR )
end

return WRET

*---------------------------------------------------------------------------*
* Procedure ...: ESPERA
* Finalidade ..: Apresentar mensagem na tela e aguadar usuario
* Parametros ..: <ExpC> Mensagem
* Autor .......: Hugo Bastos Peixoto
*---------------------------------------------------------------------------*
PROCEDURE ESPERA(pMsg)
LOCAL wTelaAnt := SAVESCREEN(24,00,24,79)
Mensagem(pMsg)
INKEY(0)
RESTSCREEN(24,00,24,79,wTelaAnt)
RETURN

*---------------------------------------------------------------------------*
* Procedure ...: QUADRO
* Finalidade ..: Montar moldura com titulo
* Parametros ..: <ExpN 1,2,3,4> Coordenadas para montar moldura
*               <ExpC> Titulo
* Autor .......: Daniel Luiz Guimaraes Machado
*---------------------------------------------------------------------------*
PROCEDURE QUADRO(pX1,pY1,pX2,pY2,pTitulo)
@ pX1,pY1 CLEAR TO pX2,pY2
@ pX1,pY1 TO pX2,pY2
IF !EMPTY(pTitulo)
   wMeio = pY1+INT(((pY2-pY1)-LEN(pTitulo))/2)
   @ pX1,wMeio SAY pTitulo
   @ pX1,wMeio-1 SAY CHR(180)
   @ pX1,wMeio+LEN(pTitulo) SAY CHR(195)
ENDIF
RETURN

*---------------------------------------------------------------------------*
* Funcao ......: ESTADO
* Finalidade ..: Validar a entrada de uma UF
* Parametros ..: <ExpC> UF a ser validada
* Retorno .....: <ExpL> .T. = UF valida ou vazia
* Autor .......: Daniel Luiz Guimaraes Machado
*---------------------------------------------------------------------------*
FUNCTION ESTADO(pUF)
LOCAL wRetorno := .T.
LOCAL wEstados := 'ACºALºAPºAMºBAºCEºDFºESºGOºMAºMTºMSºMGºPAºPBºPRºPEºPIºRJºRNºRSºRDºRRºSCºSPºSEºTO'
IF ! (pUF $ wEstados .OR. EMPTY(pUF))
   MensBeep('Estado inv lido.')
   wRetorno := .F.
ENDIF
RETURN wRetorno

*- (06) --------------------------------------------------------------------*
* Procedure ...: DH_IMPOFF
* Finalidade ..:
* Parametros ..:
* Autor .......: Daniel Luiz Guimaraes Machado
*---------------------------------------------------------------------------*
function dh_impoff()
   set print off
   set device to screen
   set console on
   set printer to

return NIL

*---------------------------------------------------------------------------*
* Funcao ......: dh_imprime
* Finalidade ..: Envia impressao para arquivo ou impressora
* Parametros ..:
* Retorno .....:
* Autor .......: Daniel Luiz Guimaraes Machado
*---------------------------------------------------------------------------*
function DH_IMPRIME( P_MODO )
local wresp :=  pergresp('(I)mpressora/(T)ela/(A)rquivo/(R)etorna ?','ITAR') ,;
      wret := .T.               ,;
      vet_tudo[adir("*.PRN")]   ,;
      wnum

adir("REL*.PRN",vet_tudo)
asort( vet_tudo )

// WNUM    := len( VET_TUDO ) + 1


if len( VET_TUDO ) = 0
   WNUM  := 1
else
   WNUM  := val( substr( VET_TUDO[ len(VET_TUDO) ], 4, 5 ) ) + 1
end

ARQ_GER := "REL"+strzero( WNUM, 5)+".PRN"

WRESP_IMP := WRESP
WIMP_ARQ  := ARQ_GER

do case
   case WRESP = 'I'

      set device to print
      set console off
      if P_MODO = NIL
	 @ prow(),pcol() say chr(18)
      else
	 @ prow(),pcol() say chr(15)
      end

   case WRESP = 'A'

      set device to print
      set console off
      set printer to &arq_ger

   case WRESP = 'T'

      WRET:=.F.
      T_MODO:=1

   otherwise
      wret := .F.
endcase

return wret


*---------------------------------------------------------------------------*
* Funcao ......: SHOWBAR
* Finalidade ..: Mostra barra percentual.
* Parametros ..:
* Retorno .....:
* Autor .......: Daniel Luiz Guimaraes Machado
*---------------------------------------------------------------------------*
Function ShowBar()
local Perc, titulo

Perc   := Recno()/LastRec()
titulo := 'Indexing :'

pol1 := Int( (Perc*100) )
pol  := Int( (pol1*45)/100 )

if recno()=1
   @ 12,16 say space(45)
end
@ 12,16 say Replicate('²',pol)

Return .T.

*---------------------------------------------------------------------------*
* Funcao ......: SHOWBARP
* Finalidade ..: Mostra barra percentual enquanto imprime
* Parametros ..:
* Retorno .....:
* Autor .......: Daniel Luiz Guimaraes Machado
*---------------------------------------------------------------------------*
Function ShowBarP()
local Perc, titulo

set device to screen

Perc   := Recno()/LastRec()
titulo := 'Indexing :'

pol1 = Int((Perc*100))
pol = Int((pol1*45)/100)

if recno()=1
   @ 12,16 say space(45)
end
@ 12,16 say Replicate('²',pol)

set device to print

Return .T.

*---------------------------------------------------------------------------*
* Procedimento : TELA
* Finalidade ..: Monta tela padrao
* Parametros ..: <ExpC> Nome do programa chamador
*               <ExpC> Nome da usuario
*               <ExpC> Titulo do sistema
* Autor .......: Hugo B. Peixoto
*---------------------------------------------------------------------------*
PROCEDURE Tela(pProg,pFuncao,pTitulo)
@ 00,00 CLEAR TO 03,79
@ 00,00 TO 03,79
@ 23,00 TO 23,79
@ 01,02 SAY pProg
@ 02,02 SAY pFuncao
@ 01,36 SAY 'PROCESSOS'
@ 02,Centro(pTitulo) SAY pTitulo
@ 01,70 SAY TIME()
@ 02,70 SAY DTOC(DATE())
RETURN

*---------------------------------------------------------------------------*
* Funcao ......: TOTAL_PE
* Finalidade ..: Calcula o total geral
* Parametros ..: <Exp C> Tipo do total ( Ex. 10 - Consorcio )
*               <Exp C> Numero de inscricao do associado
*               <Exp C> Ano
*               <Exp C> Mes
*
* Retorno .....: <Exp N> Total
* Autor .......: Daniel Luiz Guimaraes Machado
*---------------------------------------------------------------------------*
function TOTAL_PE( PBL_CODEVE, PINSCRICAO, PANO, PMES )
local WTOTAL := 0                                           ,;
BL_ANOMES:={|| Pano+Pmes >= right(alltrim(str(year(EVENTO->DtIniEve),4)),2) + ;
			 strzero( month( EVENTO->DtIniEve ), 2) .and.      ;
	  Pano+Pmes <= right(alltrim(str(year( EVENTO->DtFIMEve ),4 )), 2) + ;
			 strzero( month( EVENTO->DtFIMEve ), 2) .and.      ;
	  ( ! EVENTO->encerrado ) }

INSCEVENTO->( dbclearrelation() )

EVENTO->( dbsetorder( 1 ))     // Numeve + codeve
INSCEVENTO->( dbsetorder( 2 )) // Inscricao + Numeve

INSCEVENTO->( dbsetrelation( "EVENTO",  {|| INSCEVENTO->NUMEVE } ) )
INSCEVENTO->( dbsetrelation( "VLEVENTO",{|| INSCEVENTO->NUMEVE } ) )
INSCEVENTO->( dbseek( PINSCRICAO ))

while ( INSCEVENTO->INSCRICAO = PINSCRICAO )

   if eval( PBL_CODEVE ) .AND. eval( BL_ANOMES )

      VLEVENTO->( dbseek( INSCEVENTO->numeve+PANO+PMES ) )
      WTOTAL += VLEVENTO->VALORPAR
   end

   INSCEVENTO->( dbskip() )
end

return( WTOTAL )


*---------------------------------------------------------------------------*
* Funcao ......: TOTAL_TX
* Finalidade ..: Total de taxas
* Parametros ..: <Exp C> Numero de inscricao do associado
*               <Exp C> Ano
*               <Exp C> Mes
*
* Retorno .....: <Exp N> Total
* Autor .......: Daniel Luiz Guimaraes Machado
*---------------------------------------------------------------------------*
function TOTAL_TX( PINSCRICAO, PANO, PMES )
local WTAXAS := 0

TAXA->( dbseek( PInscricao+PAno+PMes ) )
if TAXA->( found() )
   WTAXAS = ( 3 * TAXA->Adit_Mes )
end

return WTAXAS

*---------------------------------------------------------------------------*
* Funcao ......: Zero
* Finalidade ..: Retornar uma cadeia de caract. preenchida por '0'
* Parametros ..: <ExpC> Variavel
*               <ExpN> Nro. de posicoes
* Retorno .....: <ExpL> .T.
* Autor .......: Daniel Luiz Machado
*---------------------------------------------------------------------------*
FUNCTION ZERO(pVar,pTam)
LOCAL wVar
wVar  := READVAR()
&wVar := strzero( val( pVar), pTam )
RETURN .T.

*---------------------------------------------------------------------------*
* Funcao ......: ENCRIPT
* Finalidade ..: Criptografar sequencia de carateres
* Parametros ..: <ExpC> Expressao A SER criptografada
* Observacao ..: Recebe faixa de caracteres com cod. ASC entre 0 e 195
* Retorno .....: <ExpC> Expressao criptigrafada
* Autor .......: Hugo Bastos Peixoto
*---------------------------------------------------------------------------*
FUNCTION ENCRIPT(pExpressao)
LOCAL wSemente, wExpCript, wCont
// wSemente recebe o valor em segundos do momento da criptografia para ser
// adicionado ao codigo ASCII da expressao a ser criptografada. O caract. ASC
// desta semente ocupara sempre a primeira posicao da expressao criptografada
wSemente := VAL(RIGHT(TIME(),2))
wExpCript := CHR(wSemente)
FOR wCont = 1 TO LEN(TRIM(pExpressao))
   wExpCript := wExpCript + CHR(ASC(SUBSTR(pExpressao,wCont,1)) + wSemente)
NEXT
RETURN wExpCript

*---------------------------------------------------------------------------*
* Funcao ......: DESCRIPT
* Finalidade ..: Descriptografar sequencia de caracteres
* Parametros ..: <ExpC> Expressao A SER descriptografada
* Retorno .....: <ExpC> Expressao descriptografada
* Autor .......: Hugo Bastos Peixoto
*---------------------------------------------------------------------------*
FUNCTION DESCRIPT(pExpressao)
LOCAL wSemente, wExpDescript := '', wCont
wSemente := ASC(LEFT(pExpressao,1))  // Le o valor da semente
FOR wCont = 2 TO LEN(TRIM(pExpressao))
   wExpDescript := wExpDescript + CHR(ASC(SUBSTR(pExpressao,wCont,1)) - wSemente)
NEXT
RETURN wExpDescript

*---------------------------------------------------------------------------*
* Funcao ......: SOMBRA
* Finalidade ..:
* Parametros ..:
* Retorno .....:
* Autor .......:
*---------------------------------------------------------------------------*
function sombra( tw, lw, bw, rw )
local W_OLDCOR := setcolor()

sha_attr( BW+1, LW+1, BW+1, RW+1 )
sha_attr( TW+1, RW+1, BW+1, RW+1 )

setcolor( W_OLDCOR )
return NIL

*---------------------------------------------------------------------------*
* Funcao ......: SHA_ATTR
* Finalidade ..:
* Parametros ..:
* Retorno .....:
* Autor .......:
*---------------------------------------------------------------------------*
static function sha_attr( t, l, b, r )

local OLD_SCR_AREA, NEW_SCR_AREA, I, NEW_ATTR := 8

OLD_SCR_AREA := savescreen( t, l, b, r )
NEW_SCR_AREA := ""

for I = 1 to len( OLD_SCR_AREA ) step 2
   NEW_SCR_AREA := NEW_SCR_AREA + substr( OLD_SCR_AREA, I, 1 )+ chr( NEW_ATTR )
next
restscreen( t, l, b, r, NEW_SCR_AREA )
return NIL

*---------------------------------------------------------------------------*
* Funcao ......: _BOX
* Finalidade ..:
* Parametros ..:
* Retorno .....:
* Autor .......: Daniel Luiz Guimaraes Machado
*---------------------------------------------------------------------------*
procedure _box( T, L, B, R, HOW )

   if ( how = "EX" ) // explode

      MC := int((R-L)/2)+L ; MR := int((B-T)/2)+T
      DIFROW := B-T          ; DIFCOL := R-L

      VT:=VB:=MR          ; VL:=VR:=MC

      if ( difcol >= difrow )
	razcol := int( (difcol/difrow) )
	razrow := 1
      else
	razrow := int( (difcol/difrow) )
	razcol := 1
      end

      while .t.
       @ vt,vl clear to vb,vr
       @ vt,vl to vb,vr
       inkey(.01)
       // @ vt,vl to vb,vr color "W/W,N/G,N/N,N/N,N/G"
       @ vt,vl to vb,vr

       if vt<=t .or. vb>=b .or. vr>=r .or. vl<=l
	  exit
       end

       vt-=razrow ; vl-=razcol
       vb+=razrow ; vr+=razcol
      end

      vt:=t ; vb:=b ; vl:=l ; vr := r
      @ vt,vl clear to vb,vr
      @ vt,vl to vb,vr
   else

      pr:=l-1

      while .t.
	@ t,l to b,++pr
	// @ t,l to b,pr color "W/W,N/G,N/N,N/N,N/G"
	@ t,l to b,pr
	if ( pr=r )
	   exit
	end
      end
      @ t,l to b,pr
   end
return

*---------------------------------------------------------------------------*
* Funcao ......: EXT_DAY
* Finalidade ..:
* Parametros ..:
* Retorno .....:
* Autor .......:
*---------------------------------------------------------------------------*

function EXT_DAY( PDATA )
local WRET := " "

do case
   case dow( PDATA ) = 1
      WRET := "Domingo"

   case dow( PDATA ) = 2
      WRET := "Segunda"

   case dow( PDATA ) = 3
      WRET := "Terca"

   case dow( PDATA ) = 4
      WRET := "Quarta"

   case dow( PDATA ) = 5
      WRET := "Quinta"

   case dow( PDATA ) = 6
      WRET := "Sexta"

   case dow( PDATA ) = 7
      WRET := "Sabado"

endcase

return WRET

/*
-----------------------------------------------------------------------------
Procedimento : ERR_BEEP
Parametros   : nenhum
Retorno      : nenhum
Objetivo     :
-----------------------------------------------------------------------------
*/
function err_beep()
   mensbeep("Voce nao possui direitos para executar esta rotina. <ENTER>")
return

*---------------------------------------------------------------------------*
* Procedure ...: mensboxv
* Finalidade ..: Mensagem em box com vetor
* Parametros ..:
* Autor .......: Daniel Luiz Guimaraes Machado
*---------------------------------------------------------------------------*
procedure mensboxv( V_MSG )
static WTOP, WLEFT
private  WBOTTOM, WRIGHT, WRET := .T., WVAR := " ", WMEIO, getlist := {}
private  W_OLDCOR := setcolor(); W_OLDCURS := setcursor()

setcursor(0)

WTOP  := int( (24-len( V_MSG ) )/2 )
WBOTTOM := WTOP + 3 + len( V_MSG )

MAIOR := len( V_MSG[1] )
for x := 1 to len( V_MSG )
    if len( V_MSG[x] ) > MAIOR
       MAIOR := len( V_MSG[x] )
    end
next

WLEFT := int( (80-MAIOR)/2 )
WRIGHT := WLEFT + MAIOR + 3
WMEIO := WLEFT + 2

if WRIGHT > 79 .or. WLEFT < 0
   WTOP := 10
   WLEFT := 20
   WBOTTOM := WTOP + 4
   WRIGHT := WLEFT + len( MSG ) + 3
   WMEIO := WLEFT + 2
end

setcolor( W_CORMENS  )

ssavT := savescreen( WTOP, WLEFT, WBOTTOM+1, WRIGHT+1 )
ssav := savescreen( WTOP, WLEFT, WBOTTOM, WRIGHT )

//@ WTOP,WLEFT clear to WBOTTOM, WRIGHT
// @ WTOP,WLEFT       to WBOTTOM, WRIGHT double

_box(WTOP,WLEFT,WBOTTOM,WRIGHT,"EX")
sombra( WTOP,WLEFT, WBOTTOM, WRIGHT )

for x := 1 to len( V_MSG )
   @ WTOP+x+1, WMEIO say V_MSG[x]
end

WHAT_WALK := savescreen( WTOP, WLEFT, WBOTTOM, WRIGHT )

while .t.
   setcolor( W_CORMENS ) //"W/B,W+/BG,N/N,N/N,N/W" ) // C_PADRAO
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

   case lastkey()=13 // enter
      exit
   endcase
//   sombra( WTOP, WLEFT, WBOTTOM, WRIGHT )
end

restscreen( WTOP, WLEFT, WBOTTOM+1, WRIGHT+1, SSAVT )
setcursor( W_OLDCURS )
setcolor( W_OLDCOR )

return WRET

*---------------------------------------------------------------------------*
* Procedure ...: mensproc
* Finalidade ..: Mostra mensagem enquanto ha processamento
* Parametros ..:
* Autor .......: Daniel Luiz Guimaraes Machado
*---------------------------------------------------------------------------*
procedure mensproc( MSG )
static WTOP, WLEFT, WBOTTOM,  WRIGHT, SOLDPROC
private  WRET := .T., WVAR := " ", WMEIO, getlist := {}
private  W_OLDCOR := setcolor(); W_OLDCURS := setcursor()

setcursor(0)

if MSG = '*UNDO*'

   restscreen( WTOP, WLEFT, WBOTTOM+1, WRIGHT+1,  SOLDPROC )
else
   WTOP    := 10
   WLEFT   := int( (80-len( MSG ))/2 )
   WBOTTOM := WTOP + 4
   WRIGHT  := WLEFT + len( MSG ) + 3
   WMEIO   := WLEFT + 2

   setcolor( W_CORMENS  )

   SOLDPROC := savescreen( WTOP, WLEFT, WBOTTOM+1, WRIGHT+1 )

   _box( WTOP, WLEFT, WBOTTOM, WRIGHT, "EX")
   sombra( WTOP,WLEFT, WBOTTOM, WRIGHT )

   @ WTOP+2, WMEIO say MSG

end
return WRET

*---------------------------------------------------------------------------*
* Procedure ...: mensbeep
* Finalidade ..:
* Parametros ..:
* Autor .......: Daniel Luiz Guimaraes Machado
*---------------------------------------------------------------------------*
procedure mensbeep( MSG, W_BEEP )
static WTOP, WLEFT
private  WBOTTOM, WRIGHT, WRET := .T., WVAR := " ", WMEIO, getlist := {}
private  W_OLDCOR := setcolor(); W_OLDCURS := setcursor()

setcursor(0)

if W_BEEP = NIL
   W_BEEP := "NO_BEEP"
end

WTOP    := 10
WLEFT   := int( (80-len( MSG ))/2 )
WBOTTOM := WTOP + 4
WRIGHT  := WLEFT + len( MSG ) + 3
WMEIO   := WLEFT + 2

setcolor( W_CORMENS  )

SSAVT := savescreen( WTOP, WLEFT, WBOTTOM+1, WRIGHT+1 )
SSAV  := savescreen( WTOP, WLEFT, WBOTTOM, WRIGHT )

_box( WTOP, WLEFT, WBOTTOM, WRIGHT, "EX")
sombra( WTOP,WLEFT, WBOTTOM, WRIGHT )

@ WTOP+2, WMEIO say MSG

if W_BEEP = "BEEP"
   tone(250, 2)
   tone(650, 2)
   tone(450, 3)
end
WHAT_WALK := savescreen( WTOP, WLEFT, WBOTTOM, WRIGHT )

while .t.
   setcolor( W_CORMENS )
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

   case lastkey() = 13 .or. lastkey()=27
      exit

   endcase
end

restscreen( WTOP, WLEFT, WBOTTOM+1, WRIGHT+1, SSAVT )
setcursor( W_OLDCURS )
setcolor( W_OLDCOR )

return WRET

*---------------------------------------------------------------------------*
* Procedure ...: TESTA_CGC
* Finalidade ..:
* Parametros ..:
* Autor .......: Daniel Luiz Guimaraes Machado
*---------------------------------------------------------------------------*
function Testa_CGC( NUMERO )
   local WRET := .T., NUMAUX := alltrim( NUMERO )

   if empty( NUMERO )
      mensbeep("Nao e permitido CGC em branco. <ENTER> ", "NOBEEP")
      WRET := .F.
   else
      if ! Val_CGC( NUMAUX )
	 mensbeep("CGC Invalido. <ENTER>","NOBEEP")
	 WRET := .F.
      end
   end

return WRET

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Procedure ...: VAL_CGC                                                     ³
//³ Finalidade ..:                                                             ³
//³ Parametros ..:                                                             ³
//³ Autor .......: Daniel Luiz Guimaraes Machado                               ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
function val_cgc( NUMBER )

   local POSICAO[12], INDICE, CALCULO, RESTO, DIGITO1, DIGITO2, NUM
   local WRET := .T.

   INDICE:=CALCULO:=RESTO:=DIGITO1:=DIGITO2:=0

   // MASCARA DO CGC -> 99.999.999/9999-99
   // NUM := left( NUMBER,2 )      +;
   //        substr( NUMBER,4,3 )  +;
   //        substr( NUMBER,8,3 )  +;
   //        substr( NUMBER,12,4 ) +;
   //        substr( NUMBER,17,2 )
   // NUMBER := NUM

   for INDICE = 1 to 12
      POSICAO[INDICE] := val( substr( NUMBER, INDICE, 1 ))
   next

   //  primeiro digito

   for INDICE = 1 to 12
      if INDICE < 5
	 CALCULO+=( POSICAO[INDICE] * (6-INDICE) )
      else
	 CALCULO+=( POSICAO[INDICE] * (14-INDICE) )
      end
   next

   RESTO := CALCULO%11

   if RESTO=0 .or. RESTO=1
      DIGITO1 := 0
   else
      DIGITO1 := 11-RESTO
   end

   //  segundo digito

   CALCULO := 0
   for INDICE = 1 to 12
      if INDICE < 6
	 CALCULO+=( POSICAO[INDICE] * (7-INDICE) )
      else
	 CALCULO+=( POSICAO[INDICE] * (15-INDICE) )
      end
   next

   CALCULO+=( DIGITO1 * 2 )

   RESTO := CALCULO%11

   if RESTO=0 .or. RESTO=1
      DIGITO2 := 0
   else
      DIGITO2 := 11-RESTO
   end

   if DIGITO1 <> val( substr( NUMBER,13,1)) .or. ;
      DIGITO2 <> val( substr( NUMBER,14,1))
      WRET := .F.
   end

return WRET

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Procedimento : VAL_CPF                                                      ³
//³Parametros   : NUMBER -  numero do CPF                                      ³
//³Retorno      : .T./.F.                                                      ³
//³Objetivo     : validar o CPF                                                ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
function val_cpf( NUMBER )

local WRET := .T.

Private Posicao[9],;
	Indice    ,;
	Calculo   ,;
	Resto     ,;
	Digito1   ,;
	Digito2

For Indice = 1 to 9
    Posicao[Indice] = Val(SubStr(Number,Indice,1))
Next

****  TESTE DO PRIMEIRO DIGITO (UNIDADE)

Calculo = 0

For Indice = 1 to 9
    Calculo = Calculo + (Posicao[Indice] * (11 - Indice))
Next

Resto = Calculo%11

If Resto = 0 .Or. Resto = 1
   Digito1 = 0
Else
   Digito1 = 11 - Resto
EndIf

****  TESTE DO SEGUNDO DIGITO (DEZENA)

Calculo = 0

For Indice = 1 to 9
    Calculo = Calculo + (Posicao[Indice] * (12 - Indice))
Next

Calculo = Calculo + (Digito1 * 2)
Resto   = Calculo%11

If Resto = 0 .Or. Resto = 1
   Digito2 = 0
Else
   Digito2 = 11 - Resto
EndIf

If Digito1 <> Val(SubStr(Number,10,1)) .Or. Digito2 <> Val(SubStr(Number,11,1))
   WRET := .F.
EndIf

Return( WRET )

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Procedimento : VAL_PIS                                                      ³
//³Parametros   : K_PIS  -  numero do PIS                                      ³
//³Retorno      : .T./.F.                                                      ³
//³Objetivo     : validar o PIS                                                ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
function val_pis( K_PIS )

   local NUM  := {}, WRET := .F., WAC := 0, X
   local PESO := {3,2,9,8,7,6,5,4,3,2}, WLASTNUM

   WLASTNUM := val( substr( K_PIS, 11) )

   for x := 1 to len( K_PIS )-1
      WAC+= ( val( substr( K_PIS,X,1) ) * PESO[X] )
   next

   WTOT := (WAC*10)%11

   if WTOT = WLASTNUM
      WRET:= .T.
   end

return( WRET )

*---------------------------------------------------------------------------*
* Procedure ...: TESTA_PIS
* Finalidade ..:
* Parametros ..:
* Autor .......: Daniel Luiz Guimaraes Machado
*---------------------------------------------------------------------------*
function Testa_PIS( NUMERO )
   local WRET := .T., NUMAUX := alltrim( NUMERO )

   if empty( NUMERO )
      // mensbeep("Nao e permitido PIS em branco. <ENTER> ", "NOBEEP")
      WRET := .T.
   else
      if ! Val_PIS( NUMAUX )
	 mensbeep("PIS Invalido. <ENTER>","NOBEEP")
	 WRET := .F.
      end
   end

return WRET


*---------------------------------------------------------------------------*
* Procedure ...: TESTA_CPF
* Finalidade ..:
* Parametros ..:
* Autor .......: Daniel Luiz Guimaraes Machado
*---------------------------------------------------------------------------*
function Testa_CPF( NUMERO )
   local WRET := .T., NUMAUX := alltrim( NUMERO )

   if empty( NUMERO )
      // mensbeep("Nao e permitido CPF em branco. <ENTER> ", "NOBEEP")
      WRET := .T.
   else
      if ! Val_CPF( NUMAUX ) .AND. val( NUMAUX ) # 0
	 mensbeep("CPF Invalido. <ENTER>","NOBEEP")
	 WRET := .F.
      end
   end

return WRET

/*
-----------------------------------------------------------------------------
Procedimento : VER_PIS
Parametros   : K_PIS  -  numero do PIS
Retorno      : .T./.F.
Objetivo     : validar o PIS
-----------------------------------------------------------------------------
*/
FUNCTION VER_PIS( K_PIS )
   local NUM  := {}, WRET := .F., WAC := 0, X
   local PESO := {3,2,9,8,7,6,5,4,3,2}, WLASTNUM

   if empty( K_PIS )
      WRET := .T.
   else
      WLASTNUM := val( substr( K_PIS, 11) )

      for x := 1 to len( K_PIS )-1
	 WAC+= ( val( substr( K_PIS,X,1) ) * PESO[X] )
      next

      WTOT := (WAC*10)%11
      if WTOT = WLASTNUM
	 WRET:= .T.
      else
	 mensbeep("PIS invalido. <ENTER>")
      end
   end

return WRET

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ TABELANEW() - Funcao para definir a tabela.                               ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
 function tabelanew( CAMPO          , ; // Vetor de campos do arquivo
		     MASCARA        , ; // Vetor de picture dos campos
		     CABECALHO      , ; // Vetor de cabecalho da tabela
		     TAMANHO        , ; // Vetor de tamanho das colunas da tabela
		     BESCAPE        , ; // Bloco de codigo de condicao da tabela
		     TBCOR            , ; // Cor da tabela
		     TITULO         , ; // Titulo da tabela
		     LININI         , ; // Linha inicial da tabela
		     LINFIM         , ; // Linha final da tabela
		     COLINI         , ; // Coluna inicial da tabela
		     BLOCK_DISP     , ; // Bloco de codigo para definicao da visualizacao da coluna
		     CAB_TITULO     , ; // Cabecalho do titulo da tabela
		     BORDA          , ; // Define o tipo de borda usada na tabela
		     COLFIM         , ; //
		     W_FILE           ; //
		   )

local  COR_OLD     := setcolor()
local  N           := 0
local  TABELA      := nil
local  TBCOL      := nil
// local  COLFIM      := 0
local  TAMCOL      := 0

local LISEPH     := "Ä"
local LISEPR     := if( BORDA=1,'Ä','Í' )
local LISEPV     := '³'
local LISEPB     := if( BORDA=1,"Á","Ï" )

setcolor( TBCOR )

for N:=1 to len(TAMANHO)
    TAMCOL += TAMANHO[N]
    TAMCOL += if( N>1 , 1 , 0 )
next

BORDA  := if( BORDA==NIL  , 2  , 1      )
LININI := if( LININI==NIL , 03 , LININI )
LINFIM := if( LINFIM==NIL , 20 , LINFIM )
COLINI := if( COLINI==NIL , int((80-TAMCOL)/2)-1 , COLINI )

if COLFIM = NIL
   COLFIM := COLINI + TAMCOL + 1
end

if TAMCOL <= 80

   if CAB_TITULO == nil
      if BORDA == 1
	 @ LININI,COLINI to LINFIM,COLFIM
      else
	 @ LININI,COLINI to LINFIM,COLFIM double
      endif
      if TITULO <> NIL
	 @ LININI,COLINI+1+(((COLFIM-COLINI)-(len(TITULO)))/2) say TITULO
      end
   else
      @ LININI-1,COLINI clear to LININI+3,COLFIM
      if BORDA == 1
	 @ LININI-1,COLINI to LINFIM,COLFIM
      else
	 @ LININI-1,COLINI to LINFIM,COLFIM double
      endif
      if TITULO <> NIL
	 @ LININI-1,COLINI+1+(((COLFIM-COLINI)-(len(TITULO)))/2) say TITULO
      end
      @ LININI,COLINI+1 say CAB_TITULO
   endif

   TABELA := tbrowsedb( LININI+1, COLINI+1, LINFIM, COLFIM-1 )

   TABELA:headsep := LISEPH
   TABELA:footsep := LISEPR
   TABELA:colsep  := LISEPV

   TABELA:skipblock := {|x| mudareg(X,BESCAPE) }

   TABELA:colorspec := TBCOR

   for N:=1 to len(CAMPO)
       if W_FILE = NIL
	  TBCOL := tbcolumnnew( CABECALHO[N],fieldwblock(CAMPO[N],select()) )
       else
	  TBCOL := tbcolumnnew( CABECALHO[N],fieldwblock(CAMPO[N],select( W_FILE[N] ) ) )
       end
       TBCOL:width := TAMANHO[N]
       if N > 1
	  TBCOL:headsep := replicate("Ä",TAMANHO[N]-1)
	  TBCOL:headsep := "Â" + TBCOL:headsep
	  TBCOL:footsep := replicate(LISEPR,TAMANHO[N]-1)
	  TBCOL:footsep := LISEPB + TBCOL:footsep
       endif
       TIPO := valtype(eval(TBCOL:block))
       TBCOL:defcolor := {1,2}
       TBCOL:picture  := MASCARA[N]
       TABELA:addcolumn(TBCOL)
   next

   TABELA:freeze := len(CAMPO)-1 // Congela as colunas mais a esquerda

endif

setcolor( COR_OLD )

return( TABELA )


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ TABMOV() - Funcao para controlar o movimento da tabela.                   ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
function tabmov( TABELA )

// Nao permite que o cursor seja posicionado nas coluna congeladas
if TABELA:colpos <= TABELA:freeze
   TABELA:colpos := TABELA:freeze + 1
endif

// Faz estabilizacao da tabela ate terminar ou uma tecla for pressionada
//do while nextkey()==0 .and. .not. TABELA:stabilize()
do while .not. TABELA:stabilize()
enddo

TABELA:colorrect( {TABELA:rowpos,1,TABELA:rowpos,TABELA:colcount},{2,1} )

if ( TABELA:stable )
   if ( TABELA:hittop .OR. TABELA:hitbottom )
      tone( 125,0 )
   endif
endif
TK := inkey(0)

do case
   case ( TK == K_DOWN )
	TABELA:down()
   case ( TK == K_UP )
	TABELA:up()
   case ( TK == K_PGDN )
	TABELA:pagedown()
   case ( TK == K_PGUP )
	TABELA:pageup()
   case ( TK == K_CTRL_PGUP )
	TABELA:gotop()
   case ( TK == K_CTRL_PGDN )
	TABELA:gobottom()
   case ( TK == K_RIGHT )
	TABELA:right()
   case ( TK == K_LEFT )
	TABELA:left()
   case ( TK == K_HOME )
	TABELA:gotop()
	//TABELA:home()
   case ( TK == K_END )
	TABELA:gobottom()
	//TABELA:end()
   case ( TK == K_CTRL_LEFT )
	TABELA:panleft()
   case ( TK == K_CTRL_RIGHT )
	TABELA:panright()
   case ( TK == K_CTRL_HOME )
	TABELA:panhome()
   case ( TK == K_CTRL_END )
	TABELA:panend()
endcase
TABELA:refreshcurrent()

return( TK )

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ MUDAREG() - Funcao para movimentar o ponteiro do arquivo .DBF             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
function mudareg( N,BESCAPE )

local  I          := 0
local  REG_ANT    := recno()
local  CONT       := 0

do case
   case N > 0 .AND. recno() < lastrec() + 1
	CONT := 1
	do while CONT <= N
	   dbskip()
	   if eof() .or. ! eval( BESCAPE )
	      dbskip(-1)
	      CONT := N + 1
	   else
	      I++
	      CONT ++
	   endif
	enddo
   case N < 0
	CONT := -1
	do while CONT >= N
	   dbskip(-1)
	   if bof() .or. eof() .or. ! eval( BESCAPE )
	      CONT := N - 1
	      if !bof() .and. !eof()
		 dbskip()
	      endif
	   else
	      I --
	      CONT --
	   endif
	enddo
   case N == 0
	if deleted()
	   dbskip()
	   I++
	endif
	if ! eval( BESCAPE )
	   dbskip(-1)
	   if ! eval( BESCAPE )
	      dbgobottom()
	      dbskip()
	      I := 10
	   endif
	endif

endcase

return( I )

// ---------------------------------------------------------------------------
//                           Mostra arquivo binario
// ---------------------------------------------------------------------------

procedure ler_rel( P_ARQUIVO )
local old_car := ' '

set exact on

nFirstHandle := nHandle := fopen( P_ARQUIVO, 0 )

if ferror() != 0
   mensbeep( 'erro : Arquivo sendo usado !' )

else
   cls
   while .t.

      caracter := freadstr( nHandle, 1)
      if caracter = chr(13) .or. old_car = chr(13)
	 if caracter = chr(13)
	    @ row()+1,00 say ''
	 else
	 end
      else
	 @ row(),col() say caracter
      end
      if row()=23
	 inkey(0)
	 if lastkey()= K_ESC
	    exit
	 end
	 cls
      end
      old_car := caracter
   end
end
set exact off
mensbeep("Tecle Algo ...")

return

*---------------------------------------------------------------------------*
* Funcao ......: ler_rel
* Finalidade ..: mostrar relatorio no video
* Parametros ..:
* Retorno .....:
* Autor .......: Daniel Luiz Guimaraes Machado
*---------------------------------------------------------------------------*
procedure OLD_LER_REL
private VET_TUDO[adir("*.PRN")], ANTES := savescreen(), WRESP, ARQ
private W_OLDCOR := setcolor()

adir("*.PRN",vet_tudo)

if ! len( vet_tudo ) = 0
   @ 10,10 clear to 20,25
   @ 10,10 to 20,25
   sombra(10,10,20,25)
   WRESP := achoice(11,11,19,24,vet_tudo)

   if WRESP > 0
      setcursor(1)
      ARQ := vet_tudo[WRESP]
      mensagem("Aguarde ... ")
      LARQ := memoread( ARQ )
      cls
      memoedit( LARQ, 0, 0, 24, 79, .F.,, 132 )
      setcursor(0)
   end
end
restscreen(,,,,antes)
return

/*
-----------------------------------------------------------------------------
Procedimento : VERREPO
Objetivo     : Consultar relatorio
-----------------------------------------------------------------------------
*/
procedure VERREPO( P_QUAL )
local ANTES := savescreen(,,,,)  ,;
      vet_tudo[adir("*.prn")]    ,;
      vet_size[adir("*.prn")]    ,;
      wnum

adir("*.PRN",vet_tudo,vet_size)

if P_QUAL = NIL
   @ 10,10 clear to 20,40
   @ 10,10 to 20,40
   wnum := achoice(11,11,19,39,vet_tudo )

   if wnum > 0
      ARQ := VET_TUDO[ WNUM ]
      if VET_SIZE[ WNUM ] < 65530
	 LARQ := memoread( ARQ )
	 ARQ := memoread( P_QUAL )
         memoedit( LARQ, 0, 0, 24, 79, .F.,, 134 )
      else
	 mensbeep("Arquivo muito grande... <ENTER>")
	 ler_rel( P_QUAL )
      end
   end
else

   P_QUAL := alltrim( P_QUAL )
   WR := ascan( VET_TUDO, P_QUAL )
   if WR > 0
      if VET_SIZE[ WR ] < 65530
	 LARQ := memoread( P_QUAL )
         memoedit( LARQ, 0, 0, 24, 79, .F.,, 134 )
      else
	 mensbeep("Arquivo muito grande... <ENTER>")
	 ler_rel( P_QUAL )
      end
   end

end

restscreen(,,,,ANTES)
