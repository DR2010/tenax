/*

   CONTAS A RECEBER
   CR0400.PRG - Cadastro de Tipo de Pagamento

*/
#include "inkey.ch"
altd(1)

telanum('SCE0400','CR0400')

abrir("CR0400")
abrir("CR0300")

private  CAMPO       := {}
private  MASCARA     := {}
private  CABECALHO   := {}
private  TAMANHO     := {}
private  BESCAPE     := {|| .T. }
private  COR         := W_COREDIT
private  TITULO      := " Forma de Pagamento"
private  LININI      := 03
private  LINFIM      := 22
private  COLINI      := 02
private  COLFIM      := 77
private  BLOCK_DISP  := {|| .T. }
private  CAB_TITULO  := nil
private  BORDA       := 1

private  TECLA       := nil
private  TABELA      := nil

aadd( CAMPO     , "TIPOVENDA"        )
aadd( CAMPO     , "FORMAPAG"         )
aadd( CAMPO     , "DESCRICAO"        )
aadd( CAMPO     , "CHEQUE"           )
aadd( CAMPO     , "BOLETA"           )
aadd( CAMPO     , "DUPLIC"           )
aadd( CAMPO     , "DEVOLUC"          )

aadd( MASCARA   , "99"               )
aadd( MASCARA   , "99"               )
aadd( MASCARA   , "@!"               )
aadd( MASCARA   , "@!"               )
aadd( MASCARA   , "@!"               )
aadd( MASCARA   , "@!"               )
aadd( MASCARA   , "@!"               )

aadd( CABECALHO , "Venda"            )
aadd( CABECALHO , "Forma"            )
aadd( CABECALHO , "Descri‡„o"        )
aadd( CABECALHO , "Cheque"           )
aadd( CABECALHO , "Boleta"           )
aadd( CABECALHO , "Dupli"            )
aadd( CABECALHO , "Devol"            )

aadd( TAMANHO   , 05                 )
aadd( TAMANHO   , 05                 )
aadd( TAMANHO   , 35                 )
aadd( TAMANHO   , 06                 )
aadd( TAMANHO   , 06                 )
aadd( TAMANHO   , 06                 )
aadd( TAMANHO   , 06                 )

setcolor(W_COREDIT)
tedite400()

select CR0400

TABELA := tabelanew( CAMPO          , ;
                     MASCARA        , ;
                     CABECALHO      , ;
                     TAMANHO        , ;
                     BESCAPE        , ;
                     COR            , ;
                     TITULO         , ;
                     LININI         , ;
                     LINFIM         , ;
                     COLINI         , ;
                     BLOCK_DISP     , ;
                     CAB_TITULO     , ;
                     BORDA          , ;
                     COLFIM           ;
                   )

CONTINUA := .T.
keyboard(chr(32))
do while CONTINUA .and. ( (TEC:=tabmov(TABELA)) != K_ESC )

  mensagem('<F3> - Inclui / <F4> - Altera / <F5> - Exclui')

   do case
      case TEC == 28 ; help() ; return 1    
      case TEC == 27 ; return 0

      case TEC == -3   && alteracao f4
          if !eof()
             editae400()
          end
          keyboard chr(1)

      case TEC = -2   && inclusao f3
          insere400()
          keyboard chr(1)

      case TEC = -4   &&  exclusao f5
          if !eof()
             if pergunta("Confirma exclus„o da Forma de Pagamento (S/N) ?")
                while CR0400->( ! rlock() ); end
                CR0400->( dbdelete() )
                CR0400->( dbunlock() )
                CR0400->( dbskip() )
             end
           end
          keyboard chr(1)

      case TEC = K_ESC
         CONTINUA := .F.
   end
   select CR0400
enddo

close data

return

************************************
function insere400()
************************************

private X_TIPOVENDA,X_FORMAPAG,X_DESCRICAO,X_CHEQUE,X_BOLETA,X_DUPLICATA

setcursor(1)

while .t.

   telae400()

   X_TIPOVENDA    := space(2)
   X_FORMAPAG     := space(2)
   X_DESCRICAO    := space(30)
   X_CHEQUE       := space(01)
   X_BOLETA       := space(01)
   X_DUPLIC       := space(01)
   X_DEVOLUC      := space(01)

   @ 04,26 get X_TIPOVENDA    picture "99" valid tes_tipovenda(04,26)
   X_DESCRICAO    := space(30)
   @ 05,26 get X_FORMAPAG     picture "99" valid ! empty( X_FORMAPAG )
   X_DESCRICAO    := space(30)
   @ 07,26 get X_DESCRICAO    picture "@!"
   @ 09,26 get X_CHEQUE       picture "@!"
   @ 10,26 get X_BOLETA       picture "@!" when X_CHEQUE = ' '
   @ 11,26 get X_DUPLIC       picture "@!"
   @ 12,26 get X_DEVOLUC      picture "@!"
   read

   if lastkey()=27; exit; end

   X_FORMAPAG := zerofill( X_FORMAPAG )

   @ 04,26 say X_FORMAPAG

   CR0400->(dbsetorder(1))
   if CR0400->(Dbseek(X_TIPOVENDA+X_FORMAPAG))
      mensbeep(" Forma de Pagamento j  cadastrada ")
      loop
   end

   if pergunta('Confirma inclus„o da Forma de Pagamento (S/N) ?')
      CR0400->( dbappend() )
      CR0400->TIPOVENDA := X_TIPOVENDA
      CR0400->FORMAPAG  := X_FORMAPAG
      CR0400->DESCRICAO := X_DESCRICAO
      CR0400->CHEQUE    := X_CHEQUE
      CR0400->BOLETA    := X_BOLETA
      CR0400->DUPLIC    := X_DUPLIC
      CR0400->DEVOLUC   := X_DEVOLUC
      scroll(09,27,19,54,1)
      CR0400->( dbunlock() )
   end

end

************************************
function editae400()
************************************
setcursor(1)

telae400()

X_TIPOVENDA := CR0400->TIPOVENDA
tes_tipovenda(04,26)

@ 04,26 say    X_TIPOVENDA
@ 05,26 say     CR0400->FORMAPAG

X_DESCRICAO :=  CR0400->DESCRICAO
X_CHEQUE    :=  CR0400->CHEQUE
X_BOLETA    :=  CR0400->BOLETA
X_DUPLIC    :=  CR0400->DUPLIC
X_DEVOLUC   :=  CR0400->DEVOLUC

@ 07,26 get X_DESCRICAO pict "@!"
@ 09,26 get X_CHEQUE    pict "@!"
@ 10,26 get X_BOLETA    pict "@!" when X_CHEQUE = ' '
@ 11,26 get X_DUPLIC    pict "@!"
@ 12,26 get X_DEVOLUC   pict "@!"
read

if empty(X_DESCRICAO) .or. lastkey()=27
   setcursor(0)
   return nil
end

While CR0400->( ! rlock() ); end
CR0400->DESCRICAO := X_DESCRICAO
CR0400->CHEQUE    := X_CHEQUE
CR0400->BOLETA    := X_BOLETA
CR0400->DUPLIC    := X_DUPLIC
CR0400->DEVOLUC   := X_DEVOLUC
CR0400->( dbunlock() )

setcursor(0)

return nil


/*
-------------------------------------------------------------------------------
Procedimento .: TEDITe400
Objetivo .....: Menu rapido
-------------------------------------------------------------------------------
*/
procedure tedite400()
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


/*
-------------------------------------------------------------------------------
Procedimento .: TELAe400
Objetivo .....: Menu rapido
-------------------------------------------------------------------------------
*/
procedure telae400()

   setcolor( W_COREDIT )
   @ 05,02 say '³'
   @ 05,77 say '³'
   setcolor( W_CORGET )
   @ 04,03 say ' Tipo de Venda.......:                                                    '
   @ 05,03 say ' Forma de Pagamento..:                                                    '
   @ 06,03 say '                                                                          '
   @ 07,03 say ' Descri‡„o ..........:                                                    '
   @ 08,03 say '                                                                          '
   @ 09,03 say ' Pg. em Cheque ......:                                                    '
   @ 10,03 say ' Emite Boleta........:                                                    '
   @ 11,03 say ' Emite Duplicata.....:                                                    '
   @ 12,03 say ' Devolucao...........:                                                    '
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





