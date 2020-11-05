/*

   CONTAS A RECEBER
   SR0400.PRG - Cadastro de Tipo de Pagamento

*/
#include "inkey.ch"
altd(1)

telanum('SCE0400','SR0400')

abrir("SR0400")
abrir("SR0300")

private  CAMPO	     := {}
private  MASCARA     := {}
private  CABECALHO   := {}
private  TAMANHO     := {}
private  BESCAPE     := {|| .T. }
private  COR         := W_COR_002
private  TITULO      := " Forma de Pagamento"
private  LININI      := 03
private  LINFIM      := 22
private  COLINI      := 02
private  COLFIM      := 77
private  BLOCK_DISP  := {|| .T. }
private  CAB_TITULO  := nil
private  BORDA	     := 1

private  TECLA	     := nil
private  TABELA      := nil

aadd( CAMPO	, "TIPOVENDA"        )
aadd( CAMPO	, "FORMAPAG"         )
aadd( CAMPO	, "DESCRICAO"        )
aadd( CAMPO	, "CHEQUE"           )
aadd( CAMPO	, "BOLETA"           )
aadd( CAMPO	, "DUPLIC"           )

aadd( MASCARA	, "99"               )
aadd( MASCARA	, "99"               )
aadd( MASCARA	, "@!"               )
aadd( MASCARA	, "@!"               )
aadd( MASCARA	, "@!"               )
aadd( MASCARA	, "@!"               )

aadd( CABECALHO , "Venda"            )
aadd( CABECALHO , "Forma"            )
aadd( CABECALHO , "Descri‡„o"        )
aadd( CABECALHO , "Cheque"           )
aadd( CABECALHO , "Boleta"           )
aadd( CABECALHO , "Duplicata"        )

aadd( TAMANHO	, 05		     )
aadd( TAMANHO	, 05		     )
aadd( TAMANHO	, 40		     )
aadd( TAMANHO	, 06		     )
aadd( TAMANHO	, 06		     )
aadd( TAMANHO	, 09		     )

setcolor( W_COR_002 )
Stedite400()

select SR0400

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

  mensagem('<F3> - Inclui / <F4> - Altera / <F5> - Exclui')

   do case
      case TEC == 28 ; help() ; return 1
      case TEC == 27 ; return 0

      case TEC == -3   && alteracao f4
	  if !eof()
	    Seditae400()
	  end
	  keyboard chr(1)

      case TEC = -2   && inclusao f3
	  Sinsere400()
	  keyboard chr(1)

      case TEC = -4   &&  exclusao f5
	  if !eof()
	     if pergunta("Confirma exclus„o da Forma de Pagamento (S/N) ?")
		while SR0400->( ! rlock() ); end
		SR0400->( dbdelete() )
		SR0400->( dbunlock() )
		SR0400->( dbskip() )
	     end
	   end
	  keyboard chr(1)

      case TEC = K_ESC
	 CONTINUA := .F.
   end
   select SR0400
enddo

close data

return

************************************
function Sinsere400()
************************************

private S_TIPOVENDA,S_FORMAPAG,S_DESCRICAO,S_CHEQUE,S_BOLETA,S_DUPLICATA

setcursor(1)

while .t.

   Stelae400()

   S_TIPOVENDA	  := space(2)
   S_FORMAPAG	  := space(2)
   S_DESCRICAO	  := space(30)
   S_CHEQUE	  := space(01)
   S_BOLETA	  := space(01)
   S_DUPLIC	  := space(01)

   @ 04,26 get S_TIPOVENDA    picture "99" valid TES_Stipovenda(04,26)
   S_DESCRICAO	  := space(30)
   @ 05,26 get S_FORMAPAG     picture "99" valid ! empty( S_FORMAPAG )
   S_DESCRICAO	  := space(30)
   @ 07,26 get S_DESCRICAO    picture "@!"
   @ 09,26 get S_CHEQUE       picture "@!"
   @ 10,26 get S_BOLETA       picture "@!" when S_CHEQUE = ' '
   @ 11,26 get S_DUPLIC       picture "@!"
   read

   if lastkey()=27; exit; end

   S_FORMAPAG := zerofill( S_FORMAPAG )

   @ 04,26 say S_FORMAPAG

   SR0400->(dbsetorder(1))
   if SR0400->(Dbseek(S_TIPOVENDA+S_FORMAPAG))
      mensbeep(" Forma de Pagamento j  cadastrada ")
      loop
   end

   if pergunta('Confirma inclus„o da Forma de Pagamento (S/N) ?')
      SR0400->( dbappend() )
      SR0400->TIPOVENDA := S_TIPOVENDA
      SR0400->FORMAPAG	:= S_FORMAPAG
      SR0400->DESCRICAO := S_DESCRICAO
      SR0400->CHEQUE	:= S_CHEQUE
      SR0400->BOLETA	:= S_BOLETA
      SR0400->DUPLIC	:= S_DUPLIC
      scroll(09,27,19,54,1)
      SR0400->( dbunlock() )
   end

end

************************************
function Seditae400()
************************************
setcursor(1)

Stelae400()

S_TIPOVENDA := SR0400->TIPOVENDA
TES_Stipovenda(04,26)

@ 04,26 say    S_TIPOVENDA
@ 05,26 say     SR0400->FORMAPAG

S_DESCRICAO :=	SR0400->DESCRICAO
S_CHEQUE    :=	SR0400->CHEQUE
S_BOLETA    :=	SR0400->BOLETA
S_DUPLIC    :=	SR0400->DUPLIC

@ 07,26 get S_DESCRICAO pict "@!"
@ 09,26 get S_CHEQUE	pict "@!"
@ 10,26 get S_BOLETA	pict "@!" when S_CHEQUE = ' '
@ 11,26 get S_DUPLIC	pict "@!"
read

if empty(S_DESCRICAO) .or. lastkey()=27
   setcursor(0)
   return nil
end

While SR0400->( ! rlock() ); end
SR0400->DESCRICAO := S_DESCRICAO
SR0400->CHEQUE	  := S_CHEQUE
SR0400->BOLETA	  := S_BOLETA
SR0400->DUPLIC	  := S_DUPLIC
SR0400->( dbunlock() )

setcursor(0)

return nil


/*
-------------------------------------------------------------------------------
Procedimento .: STEDITe400
Objetivo .....: Menu rapido
-------------------------------------------------------------------------------
*/
procedure Stedite400()
   local W_OLDCOR := setcolor()

   setcolor(W_COR_002)
   quadro(03,02,21,77,"")

   @ 05,02 say 'Æ'
   @ 05,77 say 'µ'
   @ 16,03 to 16,76 double
   @ 16,02 say 'Æ'
   @ 16,77 say 'µ'

   sombra(02,02,21,77)

   setcolor( W_OLDCOR )
return


/*
-------------------------------------------------------------------------------
Procedimento .: STELAe400
Objetivo .....: Menu rapido
-------------------------------------------------------------------------------
*/
procedure Stelae400()

   setcolor( W_COR_002 )
   @ 05,02 say '³'
   @ 05,77 say '³'
   setcolor( W_COR_002 )
   @ 04,03 say ' Tipo de Venda.......:                                                    '
   @ 05,03 say ' Forma de Pagamento..:                                                    '
   @ 06,03 say '                                                                          '
   @ 07,03 say ' Descri‡„o ..........:                                                    '
   @ 08,03 say '                                                                          '
   @ 09,03 say ' Pg. em Cheque ......:                                                    '
   @ 10,03 say ' Emite Boleta........:                                                    '
   @ 11,03 say ' Emite Duplicata.....:                                                    '
   @ 12,03 say '                                                                          '
   @ 13,03 say '                                                                          '
   @ 14,03 say '                                                                          '
   @ 15,03 say '                                                                          '
   @ 16,03 say '                                                                          '
   @ 17,03 say '                                                                          '
   @ 18,03 say '                                                                          '
   @ 19,03 say '                                                                          '
   @ 20,03 say '                                                                          '
   @ 21,03 say '                                                                          '
   @ 22,03 say '                                                                          '





