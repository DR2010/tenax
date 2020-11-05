/*

   SCM - Sistema de Controle Metalurgico
   AGE001.PRG - Agenda

*/
#include "inkey.ch"

abrir("AGE001")

X_NOME	     := space(40)
X_DDD	     := space(4)
X_TEL1	     := space(10)
X_TEL2	     := space(10)
X_FAX	     := space(10)
X_CONTATO    := space(40)
X_CODCLI     := space(6)
X_END01      := space(55)
X_END02      := space(55)
X_OBS	     := space(55)
X_OBS1	     := space(55)
X_OBS2	     := space(55)

telanum('SCR001','AGE001')

private  CAMPO	     := {}
private  MASCARA     := {}
private  CABECALHO   := {}
private  TAMANHO     := {}
private  BESCAPE     := {|| .T. }
private  COR	     := W_COREDIT
private  TITULO      := " Agenda "
private  LININI      := 03
private  LINFIM      := 17
private  COLINI      := 01
private  COLFIM      := 78
private  BLOCK_DISP  := {|| .T. }
private  CAB_TITULO  := nil
private  BORDA	     := 1

private  TECLA	     := nil
private  TABELA      := nil

aadd( CAMPO	, "NOME" )
aadd( CAMPO	, "DDD" )
aadd( CAMPO	, "TEL1" )
aadd( CAMPO     , "TEL2" )
aadd( CAMPO	, "CONTATO" )
aadd( CAMPO	, "CODCLI" )

aadd( MASCARA	, "@!"       )
aadd( MASCARA	, "@!"       )
aadd( MASCARA	, "@!" )
aadd( MASCARA	, "@!" )
aadd( MASCARA	, "@!"       )
aadd( MASCARA	, "XXXXXX"   )

aadd( CABECALHO , "Nome"     )
aadd( CABECALHO , "DDD"      )
aadd( CABECALHO , "Tel. 1"   )
aadd( CABECALHO , "Tel. 2"   )
aadd( CABECALHO , "Contato"  )
aadd( CABECALHO , "Codigo"   )

aadd( TAMANHO	, 25 )
aadd( TAMANHO	,  4 )
aadd( TAMANHO	, 10 )
aadd( TAMANHO	, 10 )
aadd( TAMANHO	, 15 )
aadd( TAMANHO	,  6 )

setcolor(W_COREDIT)
status('Agenda')

age_tbrowse()

select AGE001

TABELA := tabelanew( CAMPO	    , ;
		     MASCARA	    , ;
		     CABECALHO	    , ;
		     TAMANHO	    , ;
		     BESCAPE	    , ;
		     COR	    , ;
		     TITULO	    , ;
		     LININI	    , ;
		     LINFIM	    , ;
		     COLINI	    , ;
		     BLOCK_DISP     , ;
		     CAB_TITULO     , ;
		     BORDA	    , ;
		     COLFIM	      ;
		   )

CONTINUA := .T.
do while CONTINUA .and. ( (TEC:=tabmov(TABELA)) != K_ESC )
   WSCR_AGE := savescreen(,,,,)
   do case
      case TEC == 28 ; help() ; return 1
      case TEC == 13

	 age_tela()
	 age_show()
	 inkey(0)

      case TEC == -2  // INCLUSAO  = F3
	 age_inclui()
	 TABELA:refreshall()

      case TEC == -3  // ALTERACAO = F4
	 if AGE001->( ! eof() )
	    age_altera()
	    TABELA:refreshall()
	 end

      case TEC == -4   // EXCLUSAO = F5
	 if AGE001->( ! eof() )
	    age_exclui()
	    TABELA:refreshall()
	 end

      case TEC == -5   // BUSCA DIRETA = F6
	 if AGE001->( ! eof() )
	    age_busD()
	    TABELA:refreshall()
	 end

      case TEC ==  -6  // BUSCA STRING = F7
	 if AGE001->( ! eof() )
	    age_busS()
	    TABELA:refreshall()
	 end
   end
   restscreen(,,,,WSCR_AGE)

enddo

close data

return
/*
-------------------------------------------------------------------------------
Procedimento .: age_inclui
Objetivo .....:
-------------------------------------------------------------------------------
*/
procedure age_inclui()
local WSCR_INC := savescreen(,,,,)
setcursor(1)

while .t.
   age_show()
   age_tela()
   age_zera()

   @ 05,11 get X_NOME	 picture "@!" valid ! empty( X_NOME )
   read

   if lastkey()=K_ESC; exit; end

   AGE001->( dbseek( X_NOME ))

   if AGE001->( found())
      mensbeep("Ja cadastrado !")
      X_NOME := space(40)
      loop
   end

   if age_get()
      if pergunta( 'Confirma Dados (S/N) ? ')
	 age_grava("inclui")
      end
   else
      exit
   end
end

restscreen(,,,,WSCR_INC)

return

/*
-------------------------------------------------------------------------------
Procedimento .: age_altera
Objetivo .....:
-------------------------------------------------------------------------------
*/
procedure age_altera()
local WSCR_ALT := savescreen(,,,,)

setcursor(1)

age_tela()
age_zera()
age_atrib()
age_show()

if age_get()
   if pergunta("Confirma Dados (S/N) ?")
      age_grava("altera")
   end
end

setcursor(0)
restscreen(,,,,WSCR_ALT)

return

/*
-------------------------------------------------------------------------------
Procedimento .: age_get
Objetivo .....:
-------------------------------------------------------------------------------
*/
function age_get()
local WRET := .T.

@ 07,17 get X_DDD	 picture "@!"
@ 07,24 get X_TEL1	 picture "@!"
@ 07,48 get X_TEL2	 picture "@!"
@ 09,11 get X_FAX	 picture "@!"
@ 11,14 get X_CONTATO	 picture "@!"
@ 13,24 get X_CODCLI	 picture "@!"
@ 15,14 get X_END01      picture "@!"
@ 16,14 get X_END02      picture "@!"
@ 18,09 get X_OBS	 picture "@!"
@ 19,09 get X_OBS1	 picture "@!"
@ 20,09 get X_OBS2	 picture "@!"
read

if lastkey() = K_ESC
   WRET := .F.
end

return WRET

/*
-------------------------------------------------------------------------------
Procedimento .: age_show
Objetivo .....:
-------------------------------------------------------------------------------
*/
function age_show()
local WRET := .T.

@ 05,11 say AGE001->NOME       picture "@!"
@ 07,17 say AGE001->DDD        picture "@!"
@ 07,24 say AGE001->TEL1       picture "@!"
@ 07,48 say AGE001->TEL2       picture "@!"
@ 09,11 say AGE001->FAX        picture "@!"
@ 11,14 say AGE001->CONTATO    picture "@!"
@ 13,24 say AGE001->CODCLI     picture "999999"
@ 15,14 say AGE001->END01      picture "@!"
@ 16,14 say AGE001->END02      picture "@!"
@ 18,09 say AGE001->OBS        picture "@!"
@ 19,09 say AGE001->OBS1       picture "@!"
@ 20,09 say AGE001->OBS2       picture "@!"

return WRET

/*
-------------------------------------------------------------------------------
Procedimento .: age_grava
Objetivo .....:
-------------------------------------------------------------------------------
*/
function age_grava( P_MODO )
local WRET := .T.

begin sequence

if P_MODO = 'altera'
   while AGE001->( ! rlock());end
else
   AGE001->( dbappend() )
   AGE001->NOME     := X_NOME
end

AGE001->DDD	   := X_DDD
AGE001->TEL1	   := X_TEL1
AGE001->TEL2	   := X_TEL2
AGE001->FAX	   := X_FAX
AGE001->CONTATO    := X_CONTATO
AGE001->CODCLI	   := X_CODCLI
AGE001->END01      := X_END01
AGE001->END02      := X_END02
AGE001->OBS	   := X_OBS
AGE001->OBS1	   := X_OBS1
AGE001->OBS2	   := X_OBS2

end sequence

return WRET

/*
-------------------------------------------------------------------------------
Procedimento .: age_busD
Objetivo .....: BUSCA DIRETA
-------------------------------------------------------------------------------
*/
procedure age_busD()
local TB := savescreen(14,14,17,67)

setcursor(1)

@ 14,14 say 'ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿'
@ 15,14 say '³                                                   ³'
@ 15,14 say '³ Nome :                                            ³'
@ 15,14 say '³                                                   ³'
@ 16,14 say 'ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ'
sombra(14,14,16,66)

X_NOME := space(40)
@ 15,23 get X_NOME picture "@!"
read

AGE001->( dbseek( X_NOME, .T. ) )

restscreen(14,29,17,46,TB)

setcursor(0)

return

/*
-------------------------------------------------------------------------------
Procedimento .: age_busS
Objetivo .....: BUSCA STRING
-------------------------------------------------------------------------------
*/
function age_busS()
local TB := savescreen(14,14,17,67)
local V_NOME := {}

setcursor(1)

@ 14,14 say 'ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿'
@ 15,14 say '³                                                   ³'
@ 15,14 say '³ Nome :                                            ³'
@ 15,14 say '³                                                   ³'
@ 16,14 say 'ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ'
sombra(14,14,16,66)

X_NOME := space(40)
@ 15,23 get X_NOME picture "@!"
read

if lastkey() <> K_ESC

   X_STRNOME := alltrim( X_NOME )
   AGE001->( dbgotop() )

   while AGE001->( ! eof() )
      if X_STRNOME $ AGE001->NOME
	 aadd( V_NOME, AGE001->NOME  )
      end
      AGE001->( dbskip() )
   end

   if len( V_NOME ) > 0

      WSCR_BUS := savescreen(10,10,17,54)
      @ 10,10 say 'ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿'
      @ 11,10 say '³                                          ³'
      @ 12,10 say '³                                          ³'
      @ 13,10 say '³                                          ³'
      @ 14,10 say '³                                          ³'
      @ 15,10 say '³                                          ³'
      @ 16,10 say 'ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ'
      sombra(10,10,16,53)
      WESC := achoice( 11,11,15,52, V_NOME )

      restscreen(10,10,17,54,WSCR_BUS)

      if WESC > 0
	 AGE001->( dbseek( V_NOME[WESC] ) )
      end

   else
      mensbeep("Nao ha registros.")
   end

end
restscreen(14,29,17,46,TB)

setcursor(0)

return nil


/*
-------------------------------------------------------------------------------
Procedimento .: age_tela
Objetivo .....: Menu rapido
-------------------------------------------------------------------------------
*/
procedure age_tela()

   setcolor( W_COREDIT )
   @ 05,02 say ' ³                                                                            ³ '
   setcolor( W_CORGET )
   @ 04,00 say ' ³                                                                            ³ '
   @ 05,00 say ' ³ Nome :                                                                     ³ '
   @ 06,00 say ' ³                                                                            ³ '
   @ 07,00 say ' ³ Telefone 1 :                   Telefone 2 :                                ³ '
   @ 08,00 say ' ³                                                                            ³ '
   @ 09,00 say ' ³ FAX  :                                                                     ³ '
   @ 10,00 say ' ³                                                                            ³ '
   @ 11,00 say ' ³ Contato :                                                                  ³ '
   @ 12,00 say ' ³                                                                            ³ '
   @ 13,00 say ' ³ Codigo do Cliente :                                                        ³ '
   @ 14,00 say ' ³                                                                            ³ '
   @ 15,00 say ' ³ Endereco:                                                                  ³ '
   @ 16,00 say ' ³                                                                            ³ '
   @ 17,00 say ' ³                                                                            ³ '
   @ 18,00 say ' ³ Obs :                                                                      ³ '
   @ 19,00 say ' ³                                                                            ³ '
   @ 20,00 say ' ³                                                                            ³ '
   @ 21,00 say ' ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ '

return

/*
-------------------------------------------------------------------------------
Procedimento .: age_tbrowse
Objetivo .....: Menu rapido
-------------------------------------------------------------------------------
*/
procedure age_tbrowse()

   @ 04,00 say '                                                                                '
   @ 05,00 say '                                                                                '
   @ 06,00 say '                                                                                '
   @ 07,00 say '                                                                                '
   @ 08,00 say '                                                                                '
   @ 09,00 say '                                                                                '
   @ 10,00 say '                                                                                '
   @ 11,00 say '                                                                                '
   @ 12,00 say '                                                                                '
   @ 13,00 say '                                                                                '
   @ 14,00 say '                                                                                '
   @ 15,00 say '                                                                                '
   @ 16,00 say '                                                                                '
   @ 17,00 say '                                                                                '
   @ 18,00 say ' ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿ '
   @ 19,00 say ' ³   <F3> Incluir   <F4> Alterar  <F5> Excluir  <F6> Busca Rapida             ³ '
   @ 20,00 say ' ³                                              <F7> Busca Parte              ³ '
   @ 21,00 say ' ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ '

return


/*
-------------------------------------------------------------------------------
Procedimento .: age_zera
Objetivo .....:
-------------------------------------------------------------------------------
*/
procedure age_zera()

X_NOME	     := space(40)
X_DDD	     := space(4)
X_TEL1	     := space(10)
X_TEL2	     := space(10)
X_FAX	     := space(10)
X_CONTATO    := space(40)
X_CODCLI     := space(6)
X_END01      := space(55)
X_END02      := space(55)
X_OBS	     := space(55)
X_OBS1	     := space(55)
X_OBS2	     := space(55)

return

/*
-------------------------------------------------------------------------------
Procedimento .: age_atrib
Objetivo .....:
-------------------------------------------------------------------------------
*/
procedure age_atrib

X_NOME	    := AGE001->NOME
X_DDD	    := AGE001->DDD
X_TEL1	    := AGE001->TEL1
X_TEL2	    := AGE001->TEL2
X_FAX	    := AGE001->FAX
X_CONTATO   := AGE001->CONTATO
X_CODCLI    := AGE001->CODCLI
X_END01     := AGE001->END01
X_END02     := AGE001->END02
X_OBS	    := AGE001->OBS
X_OBS1	    := AGE001->OBS1
X_OBS2	    := AGE001->OBS2

return

/*
-------------------------------------------------------------------------------
Procedimento .: age_exclui
Objetivo .....:
-------------------------------------------------------------------------------
*/
procedure age_exclui

if pergunta('Confirma Exclusao (S/N) ?')
   while AGE001->( ! rlock() ); end
   AGE001->( dbdelete() )
end

return
