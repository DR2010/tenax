/*

   SCM - Sistema de Controle Metalurgico
   EST40.PRG - Detalhar Caixote

*/
#include "inkey.ch"

abrir("EST003")
abrir("EST004")
abrir("EST040")

X_FORMA    := space(3)
X_TIPO     := space(5)
X_ESPESSU  := 0.00
X_LARGURA  := 0.00
X_COMPRIM  := 0.00
X_ESTADO   := space(2)

telanum('SCR040','EST040')
private  CAMPO	     := {}
private  MASCARA     := {}
private  CABECALHO   := {}
private  TAMANHO     := {}
private  BESCAPE     := {|| .T. }
private  COR	     := W_COREDIT
private  TITULO      := " Manutencao do Caixote "
private  LININI      := 03
private  LINFIM      := 21
private  COLINI      := 02
private  COLFIM      := 77
private  BLOCK_DISP  := {|| .T. }
private  CAB_TITULO  := nil
private  BORDA	     := 1

private  TECLA	     := nil
private  TABELA      := nil

aadd( CAMPO     , "FORMA" )
aadd( CAMPO     , "TIPO" )
aadd( CAMPO     , "ESPESSU" )
aadd( CAMPO     , "LARGURA" )
aadd( CAMPO     , "COMPRIM" )

aadd( MASCARA   , "XXX"        )
aadd( MASCARA   , "XXXXX"      )
aadd( MASCARA   , "999999.999" )
aadd( MASCARA   , "999999.999" )
aadd( MASCARA   , "999999.999" )


aadd( CABECALHO , "Forma"       )
aadd( CABECALHO , "Tipo"        )
aadd( CABECALHO , "Espessura"   )
aadd( CABECALHO , "Largura"     )
aadd( CABECALHO , "Comprimento" )

aadd( TAMANHO   , 05 )
aadd( TAMANHO   , 06 )
aadd( TAMANHO   , 15 )
aadd( TAMANHO   , 15 )
aadd( TAMANHO   , 15 )

setcolor(W_COREDIT)

tedit40()

select EST040
EST040->( dbsetorder(1) )
EST040->( dbgotop() )

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


sh_est40_qtd() // Mostra quantidade de bloquinhos

CONTINUA := .T.
do while CONTINUA .and. ( (TEC:=tabmov(TABELA)) != K_ESC )

   do case

      case TEC == 28 ; help( "EST40", 1 )

      case TEC == 27 ; return 0

      case TEC == -9   // K8 -  Reconta total de itens
         sh_est40_qtd()

      case TEC == -4   && exclusao
          if EST040->( ! eof() )
             if pergunta("Confirma exclus„o (S/N) ?")
                while EST040->( ! rlock() ); end
                EST040->( dbdelete() )

             end
	  end
          tabela:refreshall()

      case TEC == -3   && alteracao f4
          if EST040->( ! eof() )
             edita40()
	  end
          select EST040
          EST040->( dbsetorder(1) )
          tabela:refreshall()

      case TEC = -2   && inclusao f3
          inser40()
          select EST040
          EST040->( dbsetorder(1) )
          tabela:refreshall()

      case TEC = K_ESC
	 CONTINUA := .F.
   end
enddo

close data

return

/*
------------------------------------------------------------------------------

                          INSER40

------------------------------------------------------------------------------
*/
procedure inser40()
local WSCR40 := savescreen(,,,,)

setcursor(1)

while .t.

   tela40()

   X_FORMA    := space(3)
   X_TIPO     := space(5)
   X_ESPESSU  := 0.00
   X_LARGURA  := 0.00
   X_COMPRIM  := 0.00

   @ 11,31 get X_FORMA    picture "999"         valid tes_formato(11,31)
   @ 12,31 get X_TIPO     picture "XXXXX"       valid tes_tipon( 12, 31, 15 )
   read

   if lastkey() = 27
      exit
   end

   if get40()
      if pergunta('Confirma inclus„o do bloquinho (S/N)?')
         grava40( "INCLUIR" )
      end
   end

end

restscreen(,,,,WSCR40)

return

/*
------------------------------------------------------------------------------

                          EDITA40

------------------------------------------------------------------------------
*/
procedure EDITA40
local WSCR40 := savescreen(,,,,)

setcursor(1)

tela40()
atrib40()

if get40()
   grava40("ALTERA")
end

setcursor(0)

restscreen(,,,,WSCR40)

return

/*
------------------------------------------------------------------------------

                          ATRIB40

------------------------------------------------------------------------------
*/
procedure ATRIB40

X_FORMA   := EST040->FORMA
X_TIPO    := EST040->TIPO
X_ESPESSU := EST040->ESPESSU
X_LARGURA := EST040->LARGURA
X_COMPRIM := EST040->COMPRIM

return

/*
------------------------------------------------------------------------------

                          GRAVA40

------------------------------------------------------------------------------
*/
procedure GRAVA40( P_MODO )

if P_MODO = 'INCLUIR'

   EST040->( dbappend() )
   EST040->FORMA     := X_FORMA
   EST040->TIPO      := X_TIPO
else
   while EST040->( ! rlock()); end
end

EST040->ESPESSU   := X_ESPESSU
EST040->LARGURA   := X_LARGURA
EST040->COMPRIM   := X_COMPRIM

EST040->( dbunlock() )

return


/*
-------------------------------------------------------------------------------
Procedimento .: GET40
Objetivo .....: Menu rapido
-------------------------------------------------------------------------------
*/
function GET40()
local WRET := .T.

@ 11,31 say X_FORMA    picture "999"
@ 12,31 say X_TIPO     picture "XXXXX"

@ 13,31 get X_ESPESSU  picture "9999999.999"  valid  X_ESPESSU > 0
@ 14,31 get X_LARGURA  picture "9999999.999"  valid  X_LARGURA > 0
@ 15,31 get X_COMPRIM  picture "9999999.999"  valid  X_COMPRIM > 0
read

if lastkey()=K_ESC
   WRET := .T.
end

return WRET


/*
-------------------------------------------------------------------------------
Procedimento .: TELA40
Objetivo .....: Menu rapido
-------------------------------------------------------------------------------
*/
procedure tela40()

@ 10,14 say 'ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿'
@ 11,14 say '³ Forma .......:                           ³'
@ 12,14 say '³ Tipo ........:                           ³'
@ 13,14 say '³ Espessura ...:                           ³'
@ 14,14 say '³ Largura .....:                           ³'
@ 15,14 say '³ Comprimento .:                           ³'
@ 16,14 say 'ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ'

return


/*
-------------------------------------------------------------------------------
Procedimento .: TEDIT40
Objetivo .....: Menu rapido
-------------------------------------------------------------------------------
*/
procedure tedit40()
   local W_OLDCOR := setcolor()

   setcolor(W_COREDIT)
   quadro(03,02,21,77,"")
   @ 05,02 say 'Æ'
   @ 05,77 say 'µ'
   @ 16,03 to 16,76 double
   @ 16,02 say 'Æ'
   @ 16,77 say 'µ'
   @ 22,02 say space(78)

   sombra(02,02,21,77)

   setcolor( W_OLDCOR )

return


/*
-------------------------------------------------------------------------------
Procedimento .: SH_EST40_QTD
Objetivo .....: Reconta quantidade de bloquinhos
-------------------------------------------------------------------------------
*/
procedure sh_est40_qtd()

   @ 22,02 say space(78)
   @ 22,40 say 'Quantidade Bloquinhos :  '

   mensproc('Aguarde contagem dos itens.')

   select EST040
   count to W_QTDTOTAL

   @ 22,70 say W_QTDTOTAL picture '99999'
   EST040->( dbgotop() )

   mensproc('*UNDO*')

   mensagem('')

return
