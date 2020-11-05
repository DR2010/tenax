/*

   SCM - Sistema de Controle Metalurgico
   EST36.PRG - Composicao Quimica/ Tipo de Material

*/
#include "inkey.ch"

abrir("EST003")
abrir("EST004")
abrir("EST035")
abrir("EST036")

X_FORMA    := space(3)
X_TIPO     := space(5)
X_CODCOMP  := space(2)
X_MINIMO  := 0.00
X_MAXIMO  := 0.00

telanum('SCR036','EST036')
private  CAMPO	     := {}
private  MASCARA     := {}
private  CABECALHO   := {}
private  TAMANHO     := {}
private  BESCAPE     := {|| .T. }
private  COR	     := W_COREDIT
private  TITULO      := " Composi‡„o Qu¡mica "
private  LININI      := 03
private  LINFIM      := 16
private  COLINI      := 02
private  COLFIM      := 77
private  BLOCK_DISP  := {|| .T. }
private  CAB_TITULO  := nil
private  BORDA	     := 1

private  TECLA	     := nil
private  TABELA      := nil

aadd( CAMPO     , "TIPO" )
aadd( CAMPO     , "CODCOMP" )
aadd( CAMPO     , "MINIMO"  )
aadd( CAMPO     , "MAXIMO"  )

aadd( MASCARA   , "XXXXX"      )
aadd( MASCARA   , "999999.999" )
aadd( MASCARA   , "999999.999" )
aadd( MASCARA   , "999999.999" )


aadd( CABECALHO , "Tipo"        )
aadd( CABECALHO , "Componente"  )
aadd( CABECALHO , "M¡nimo"      )
aadd( CABECALHO , "M ximo"      )

aadd( TAMANHO   , 06 )
aadd( TAMANHO   , 15 )
aadd( TAMANHO   , 15 )
aadd( TAMANHO   , 15 )

setcolor(W_COREDIT)

tedit36()

select EST036
EST036->( dbsetorder(1) )
EST036->( dbgotop() )

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
          if EST036->( ! eof() )
             if pergunta("Confirma exclus„o (S/N) ?")
                while EST036->( ! rlock() ); end
                EST036->( dbdelete() )

             end
	  end
          tabela:refreshall()

      case TEC == -3   && alteracao f4
          if EST036->( ! eof() )
             edita36()
	  end
          select EST036
          EST036->( dbsetorder(1) )
          tabela:refreshall()

      case TEC = -2   && inclusao f3
          inser36()
          select EST036
          EST036->( dbsetorder(1) )
          tabela:refreshall()

      case TEC = K_ESC
	 CONTINUA := .F.
   end
enddo

close data

return

/*
------------------------------------------------------------------------------

                          INSER36

------------------------------------------------------------------------------
*/
procedure inser36()
local WSCR36 := savescreen(,,,,)

setcursor(1)


while .t.

   tela36()

   X_FORMA  := ""
   X_ESTADO := ""
   X_TIPO     := space(5)
   @ 11,31 get X_TIPO     picture "XXXXX" valid tes_tipo(3) // 3=sem descricao
   read

   if lastkey()=K_ESC
      exit
   end

   while .t.
      X_CODCOMP  := space(2)
      @ 12,31 get X_CODCOMP  picture "@!"    valid tes_compon()
      read

      if lastkey()=K_ESC
         exit
      end

      EST036->(dbsetorder(1))
      if EST036->(dbseek(X_TIPO + X_CODCOMP))
         mensbeep(" Composicao Qu¡mica j  Cadastrada ! ")
         loop
         exit
      end

      X_MINIMO   := 0.00
      X_MAXIMO   := 0.00
      if get36()
        if pergunta('Confirma inclus„o ( S/N )  ? ')
           grava36( "INCLUIR" )
        end
      end
   end

end

restscreen(,,,,WSCR36)

return

/*
------------------------------------------------------------------------------

                          EDITA36

------------------------------------------------------------------------------
*/
procedure EDITA36()
local WSCR36 := savescreen(,,,,)

setcursor(1)

tela36()
atrib36()

if get36()
  grava36("ALTERA")
end

setcursor(0)

restscreen(,,,,WSCR36)

return

/*
------------------------------------------------------------------------------

                          ATRIB36

------------------------------------------------------------------------------
*/
procedure ATRIB36()

X_TIPO    := EST036->TIPO
X_CODCOMP := EST036->CODCOMP
X_MINIMO  := EST036->MINIMO
X_MAXIMO  := EST036->MAXIMO

return

/*
------------------------------------------------------------------------------

                          GRAVA36

------------------------------------------------------------------------------
*/
procedure GRAVA36( P_MODO )

if P_MODO = 'INCLUIR'

   EST036->( dbappend() )
   EST036->TIPO      := X_TIPO
   EST036->CODCOMP   := X_CODCOMP
 else
    while EST036->( ! rlock()); end
 end

    EST036->MINIMO   := X_MINIMO
    EST036->MAXIMO   := X_MAXIMO

 EST036->( dbunlock() )

return


/*
-------------------------------------------------------------------------------
Procedimento .: GET36
Objetivo .....: Menu rapido
-------------------------------------------------------------------------------
*/
procedure GET36()
local WRET := .T.

@ 11,31 say X_TIPO     picture "XXXXX"
@ 12,31 say X_CODCOMP  picture "@!"
@ 13,31 get X_MINIMO   picture "9999999.99"  valid  X_MINIMO > 0
@ 14,31 get X_MAXIMO   picture "9999999.99"  valid  X_MAXIMO > X_MINIMO
read

if lastkey()=K_ESC
   WRET := .T.
end

return WRET


/*
-------------------------------------------------------------------------------
Procedimento .: TELA36
Objetivo .....: Menu rapido
-------------------------------------------------------------------------------
*/
procedure tela36()

@ 10,14 say 'ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿'
@ 11,14 say '³ Tipo ........:                           ³'
@ 12,14 say '³ Componente...:                           ³'
@ 13,14 say '³ M¡nimo .... .:                           ³'
@ 14,14 say '³ M ximo ......:                           ³'
@ 15,14 say 'ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ'

return


/*
-------------------------------------------------------------------------------
Procedimento .: TEDIT36
Objetivo .....: Menu rapido
-------------------------------------------------------------------------------
*/
procedure tedit36()
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

