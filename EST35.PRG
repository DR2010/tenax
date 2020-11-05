/*

   SCM - Sistema de Controle Metalurgico
   EST35.PRG - Cadastro da Tabela Periodica de Elementos Quimicos

*/
#include "inkey.ch"

abrir("EST003")
abrir("EST004")
abrir("EST035")

X_FORMA    := space(3)
X_TIPO     := space(5)
X_ESPESSU  := 0.00
X_COMPRIM  := 0.00
X_LARGURA  := 0.00
X_ESTADO   := space(2)

telanum('SCR035','EST035')
private  CAMPO	     := {}
private  MASCARA     := {}
private  CABECALHO   := {}
private  TAMANHO     := {}
private  BESCAPE     := {|| .T. }
private  COR	     := W_COREDIT
private  TITULO      := " Tabela Peri¢dica de Elementos "
private  LININI      := 03
private  LINFIM      := 16
private  COLINI      := 02
private  COLFIM      := 77
private  BLOCK_DISP  := {|| .T. }
private  CAB_TITULO  := nil
private  BORDA	     := 1

private  TECLA	     := nil
private  TABELA      := nil

aadd( CAMPO     , "CODCOMP"   )
aadd( CAMPO     , "DESCRICAO" )

aadd( MASCARA   , "@!")
aadd( MASCARA   , "@!")

aadd( CABECALHO , "S¡mbolo"     )
aadd( CABECALHO , "Descri‡„o"   )

aadd( TAMANHO   ,  7 )
aadd( TAMANHO   , 65 )

setcolor(W_COREDIT)

tedit35()

select EST035
EST035->( dbsetorder(1) )
EST035->( dbgotop() )

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

   do case

      case TEC == 28 ; help() ; return 1
      case TEC == 27 ; return 0
      case TEC == -4   && exclusao
          if EST035->( ! eof() )
             if pergunta("Confirma exclus„o (S/N) ?")
                while EST035->( ! rlock() ); end
                EST035->( dbdelete() )

             end
	  end
          tabela:refreshall()

      case TEC == -3   && alteracao f4
          if EST035->( ! eof() )
             edita35()
	  end
          select EST035
          EST035->( dbsetorder(1) )
          tabela:refreshall()

      case TEC = -2   && inclusao f3
          inser35()
          select EST035
          EST035->( dbsetorder(1) )
          tabela:refreshall()

      case TEC = K_ESC
	 CONTINUA := .F.
   end
enddo

close data

return

/*
------------------------------------------------------------------------------

                          INSER35

------------------------------------------------------------------------------
*/
procedure inser35()
local WSCR35 := savescreen(,,,,)

setcursor(1)

while .t.

   tela35()

   X_CODCOMP   := space(2)
   X_DESCRICAO := space(30)

   @ 11,31 get X_CODCOMP    picture "@!"       valid ! empty( X_CODCOMP )
   read

   if lastkey() = 27
      exit
   end

   if dbseek(X_CODCOMP)
      mensbeep( 'Composi‡„o j  cadastrada')
      loop
   end

   if get35()
      if pergunta('Confirma inclusao ? ')
         grava35( "INCLUIR" )
      end
   end

end

restscreen(,,,,WSCR35)

return

/*
------------------------------------------------------------------------------

                          EDITA35

------------------------------------------------------------------------------
*/
procedure EDITA35
local WSCR35 := savescreen(,,,,)

setcursor(1)

tela35()
atrib35()

if get35()
   grava35("ALTERA")
end

setcursor(0)

restscreen(,,,,WSCR35)

return

/*
------------------------------------------------------------------------------

                          ATRIB35

------------------------------------------------------------------------------
*/
procedure ATRIB35

X_CODCOMP   := EST035->CODCOMP
X_DESCRICAO := EST035->DESCRICAO

return

/*
------------------------------------------------------------------------------

                          GRAVA35

------------------------------------------------------------------------------
*/
procedure GRAVA35( P_MODO )

if P_MODO = 'INCLUIR'

   EST035->( dbappend() )
   EST035->CODCOMP := X_CODCOMP
else
   while EST035->( ! rlock()); end
end

EST035->DESCRICAO := X_DESCRICAO

EST035->( dbunlock() )

return


/*
-------------------------------------------------------------------------------
Procedimento .: GET35
Objetivo .....: Menu rapido
-------------------------------------------------------------------------------
*/
function GET35()
local WRET := .T.

@ 12,31 get X_DESCRICAO  picture "@!"       valid ! empty( X_DESCRICAO )
read

if lastkey()=K_ESC
   WRET := .T.
end

return WRET


/*
-------------------------------------------------------------------------------
Procedimento .: TELA35
Objetivo .....: Menu rapido
-------------------------------------------------------------------------------
*/
procedure tela35()

@ 10,14 say 'ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿'
@ 11,14 say '³ S¡mbolo .....:                                ³'
@ 12,14 say '³ Descri‡„o ...:                                ³'
@ 13,14 say 'ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ'

return


/*
-------------------------------------------------------------------------------
Procedimento .: TEDIT35
Objetivo .....: Menu rapido
-------------------------------------------------------------------------------
*/
procedure tedit35()
   local W_OLDCOR := setcolor()

   setcolor(W_COREDIT)
   quadro(03,02,21,77,"")
   @ 05,02 say 'Æ'
   @ 05,77 say 'µ'
   @ 16,03 to 16,76 double
   @ 16,02 say 'Æ'
   @ 16,77 say 'µ'

   sombra(02,02,21,77)

   setcolor( W_OLDCOR )

return

