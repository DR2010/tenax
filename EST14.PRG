/*

   SCM - Sistema de Controle Metalurgico
   EST14.PRG - Cadastro de Tipo de Material

*/
#include "inkey.ch"
local divisor,campos

abrir("EST003")
abrir("EST004")

telanum('SCR014','EST014')
private  X_FORMA   :=space(3)    ,;
         W_DES_FOR :=space(40)   ,;
         X_TIPO    :=space(5)    ,;
         X_ESTADO  :=space(1)    ,;
         W_DES     :=space(40)   ,;
         X_COR     :=space(12)


private  CAMPO       := {}
private  MASCARA     := {}
private  CABECALHO   := {}
private  TAMANHO     := {}
private  W_FILE      := {}
private  BESCAPE     := {|| .T. }
private  COR14       := W_COREDIT
private  TITULO      := " Tipo de Material "
private  LININI      :=  7
private  LINFIM      := 22
private  COLINI      :=  3
private  COLFIM      := 76
private  BLOCK_DISP  := {|| .T. }
private  CAB_TITULO  := nil
private  BORDA	     := 1

private  TECLA	     := nil
private  TABELA      := nil

aadd( CAMPO     , "FORMA" )
aadd( CAMPO     , "DESCRICAO" )
aadd( CAMPO     , "TIPO" )
aadd( CAMPO     , "ESTADO" )
aadd( CAMPO     , "COR" )

aadd( MASCARA   , "999"       )
aadd( MASCARA   , "@!"        )
aadd( MASCARA   , "@!"        )
aadd( MASCARA   , "@!"        )
aadd( MASCARA   , "@!"        )

aadd( CABECALHO , "Forma"     )
aadd( CABECALHO , "Descri‡„o" )
aadd( CABECALHO , "Tipo"      )
aadd( CABECALHO , "Estado"    )
aadd( CABECALHO , "Cor"       )

aadd( TAMANHO   , 05 )
aadd( TAMANHO   , 40 )
aadd( TAMANHO   ,  5 )
aadd( TAMANHO   ,  5 )
aadd( TAMANHO   , 12 )

aadd( W_FILE , "EST004" )
aadd( W_FILE , "EST004" )
aadd( W_FILE , "EST004" )
aadd( W_FILE , "EST004" )
aadd( W_FILE , "EST004" )

setcolor(W_COREDIT)

EST004->( dbsetorder(1) )
EST004->( dbsetrelation("EST003",{|| EST004->forma},"EST004->forma") )

status('Cadastro de Tipo de Material')

X_FORMA2 := space(3)

select EST004
EST004->( dbgotop() )

TABELA := tabelanew( CAMPO	    , ;
		     MASCARA	    , ;
		     CABECALHO	    , ;
		     TAMANHO	    , ;
		     BESCAPE	    , ;
                     COR14          , ;
		     TITULO	    , ;
		     LININI	    , ;
		     LINFIM	    , ;
		     COLINI	    , ;
		     BLOCK_DISP     , ;
		     CAB_TITULO     , ;
		     BORDA	    , ;
                     COLFIM         , ;
                     W_FILE           ;
		   )


CONTINUA := .T.
do while CONTINUA .and. ( (TEC:=tabmov(TABELA)) != K_ESC )

   do case
      case TEC == 28 ; help() ; return 1
      case TEC == 27 ; return 0
      case TEC == -3   && alteracao f4
         if EST004->( ! eof() )
            edita14()
            TABELA:refreshall()
         end

      case TEC = -2   && inclusao f3
         inser14()
         TABELA:refreshall()

      case TEC = -4   &&  exclusao f5
         if EST004->( ! eof() )
            if pergunta("Confirma exclus„o do Tipo de Material ? ")
               while EST004->( ! rlock() ); end
               EST004->( dbdelete() )
            end
            TABELA:refreshall()
         end
   end
   select EST004
enddo

close data

return

dbcloseall()

return

/*
----------------------------------------------------------------------------

                               INSER14

----------------------------------------------------------------------------
*/

function inser14
setcursor(1)

while .t.

   WINS14 := savescreen(12,14,18,70)
   @ 12,14 say 'ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿'
   @ 13,14 say '³ Forma ..:                                             ³'
   @ 14,14 say '³ Tipo ...:                                             ³'
   @ 15,14 say '³ Estado .:                                             ³'
   @ 16,14 say '³ Desc ...:                                             ³'
   @ 17,14 say '³ Cor ....:                                             ³'
   @ 18,14 say 'ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ'

   X_FORMA   :=space(3)
   W_DES_FOR :=space(40)
   X_TIPO    :=space(5)
   X_ESTADO  :=space(1)
   W_DES     :=space(40)
   X_COR     :=space(12)

   @ 13,26 get X_FORMA     pict "@!" valid tes_for2( zerofill( X_FORMA ), 3 )
   @ 14,26 get X_TIPO      pict "@!" valid tes_tipo2( X_TIPO )
   @ 15,26 get X_ESTADO    pict "@!" valid tes_cod_estado(X_ESTADO,1)
   @ 16,26 get W_DES       pict "@!"
   @ 17,26 get X_COR       pict "@!"
   read

   if lastkey()=27
      setcursor(0)
      return nil
   end

   if pergunta('Confirma inclus„o do Tipo de Material ? ' )


      select EST004
      EST004->( dbappend() )
      EST004->TIPO      := X_TIPO
      EST004->FORMA     := X_FORMA
      EST004->ESTADO    := X_ESTADO
      EST004->DESCRICAO := W_DES
      EST004->COR       := X_COR

      EST004->( dbunlock() )
   end
   restscreen(12,14,18,70,WINS14 )

end

return .t.

/*
----------------------------------------------------------------------------

                               EDITA14

----------------------------------------------------------------------------
*/

function edita14
setcursor(1)

while .t.

   WINS14 := savescreen(12,14,18,70)
   @ 12,14 say 'ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿'
   @ 13,14 say '³ Forma ..:                                             ³'
   @ 14,14 say '³ Tipo ...:                                             ³'
   @ 15,14 say '³ Estado .:                                             ³'
   @ 16,14 say '³ Desc ...:                                             ³'
   @ 17,14 say '³ Cor ....:                                             ³'
   @ 18,14 say 'ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ'

   X_FORMA   := EST004->FORMA
   X_TIPO    := EST004->TIPO
   X_ESTADO  := EST004->ESTADO
   W_DES     := EST004->DESCRICAO
   X_COR     := EST004->COR

   @ 13,26 say X_FORMA
   @ 14,26 say X_TIPO
   @ 15,26 get X_ESTADO    pict "@!" valid tes_cod_estado(X_ESTADO,1)
   @ 16,26 get W_DES       pict "@!"
   @ 17,26 get X_COR       pict "@!"
   read

   if lastkey()=27
      setcursor(0)
      return nil
   end

   if pergunta('Confirma altera‡„o do Tipo de Material ? ' )

      select EST004
      while EST004->( ! rlock() ); end

      EST004->TIPO      := X_TIPO
      EST004->FORMA     := X_FORMA
      EST004->ESTADO    := X_ESTADO
      EST004->DESCRICAO := W_DES
      EST004->COR       := X_COR

      EST004->( dbunlock() )
      exit
   end
   restscreen(12,14,18,70,WINS14 )

end

return .t.


/*
----------------------------------------------------------------------------

                               BUSCA14

----------------------------------------------------------------------------
*/
function busca14()

local X_TIPO  := space(5)
local X_FORMA := space(3)
local tb      := restscreen(10,29,14,47)

setcursor(1)

@ 10,29 say "ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿"
@ 11,29 say '³ Forma...      ³'
@ 12,29 say '³ Tipo....      ³'
@ 13,29 say "ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ"

sombra(10,29,13,46)

@ 11,40 get X_FORMA pict "@!"
@ 12,40 get X_TIPO pict "@!"

read

if empty(X_FORMA) .or.empty(X_TIPO) .or. lastkey()=27
   setcursor(0)
   keyboar " "
   restscreen(10,29,14,47,tb)
   return nil
end

dbseek(X_FORMA+X_TIPO,.t.)

setcursor(0)

restscreen(10,29,14,47,tb)

return nil

/*
----------------------------------------------------------------------------

                               TES_FOR2

----------------------------------------------------------------------------
*/
function tes_for2(var)
local WRET := .F.

EST003->( dbseek(var) )

if EST003->( ! found() ) .or. empty( VAR )
   m_tabelas()
   WRET := .T.
   if lastkey() = 27
      WRET := .F.
   end
else
   X_FORMA := zerofill( X_FORMA )
   WRET := .F.
end

X_FORMA2 := X_FORMA

@ 13,30 say est003->descricao  pict "@!"

return .t.

/*
----------------------------------------------------------------------------

                               TES_TIPO2

----------------------------------------------------------------------------
*/
function tes_tipo2( P_TIPO )
local WRET := .T.

EST004->( dbsetorder(1) )

if EST004->( dbseek( X_FORMA+P_TIPO ) )
   mensbeep('Forma/Tipo de material j  cadastrado')
   WRET := .F.
end

return WRET


