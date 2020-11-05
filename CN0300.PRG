/*

   CONTAS A RECEBER
   CN0300.PRG - Cadastro de tipo de venda

*/
#include "inkey.ch"
altd(1)

telanum('SCE0300','CN0300')

abrir("CN0300")

private  CAMPO       := {}
private  MASCARA     := {}
private  CABECALHO   := {}
private  TAMANHO     := {}
private  BESCAPE     := {|| .T. }
private  COR         := W_COREDIT
private  TITULO      := " Tipo de Venda "
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
aadd( CAMPO     , "DESCRICAO"        )
aadd( CAMPO     , "PARCELA"          )

aadd( MASCARA   , "99"               )
aadd( MASCARA   , "@!"               )
aadd( MASCARA   , "@!"               )
aadd( MASCARA   , "@!"               )

aadd( CABECALHO , "C¢digo"           )
aadd( CABECALHO , "Descri‡„o"        )
aadd( CABECALHO , "Parcelamento"     )

aadd( TAMANHO   , 06                 )
aadd( TAMANHO   , 50                 )
aadd( TAMANHO   , 12                 )

setcolor(W_COREDIT)
tedite300()

select CN0300

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
do while CONTINUA .and. ( (TEC:=tabmov(TABELA)) != K_ESC )

  mensagem('<F3> - Inclui / <F4> - Altera / <F5> - Exclui')

   do case
      case TEC == 28 ; help() ; return 1    
      case TEC == 27 ; return 0

      case TEC == -3   && alteracao f4
          if !eof()
             editae300()
          end
          keyboard chr(1)

      case TEC = -2   && inclusao f3
          insere300()
          keyboard chr(1)

      case TEC = -4   &&  exclusao f5
          if !eof()
             if pergunta("Confirma exclus„o do Tipo de Venda (S/N) ?")
                while CN0300->( ! rlock() ); end
                CN0300->( dbdelete() )
                CN0300->( dbunlock() )
                CN0300->( dbskip() )
             end
           end
          keyboard chr(1)

      case TEC = K_ESC
         CONTINUA := .F.
   end
   select CN0300
enddo

close data

return

************************************
function insere300()
************************************

private X_TIPOVENDA,X_DESCRICAO,X_PARCELA

setcursor(1)

while .t.

   telae300()

   X_TIPOVENDA    := space(2)
   X_DESCRICAO    := space(30)
   X_PARCELA      := space(01)

   @ 04,26 get X_TIPOVENDA    picture "99" valid ! empty( X_TIPOVENDA )
   @ 06,26 get X_DESCRICAO    picture "@!"
   @ 07,26 get X_PARCELA      picture "@!" // valid X_PARCELA  = 'X' .or. X_PARCELA = ' '
   read

   if lastkey()=27; exit; end

   X_TIPOVENDA := zerofill( X_TIPOVENDA )

   @ 04,26 say X_TIPOVENDA

   CN0300->(Dbsetorder(1))
   if CN0300->(Dbseek(X_TIPOVENDA))
      mensbeep(" Tipo de Venda j  cadastrado ")
      loop
   end

   if pergunta('Confirma inclus„o do Tipo de Venda (S/N) ?')
      CN0300->( dbappend() )
      repl CN0300->TIPOVENDA   with X_TIPOVENDA
      repl CN0300->DESCRICAO   with X_DESCRICAO
      repl CN0300->PARCELA     with X_PARCELA
      scroll(09,27,19,54,1)
      CN0300->( dbunlock() )
   end

end

************************************
function editae300()
************************************
setcursor(1)

telae300()

@ 04,26 say    CN0300->TIPOVENDA
X_DESCRICAO := CN0300->DESCRICAO
X_PARCELA   := CN0300->PARCELA
                                 
@ 06,26 get X_DESCRICAO pict "@!"
@ 07,26 get X_PARCELA   pict "@!"
read

if empty(X_DESCRICAO) .or. lastkey()=27
   setcursor(0)
   return nil
end

while CN0300->( ! rlock() ); end
CN0300->DESCRICAO := X_DESCRICAO
CN0300->PARCELA   := X_PARCELA
CN0300->( dbunlock() )

setcursor(0)

return nil

/*
-------------------------------------------------------------------------------
Procedimento .: TEDITe300
Objetivo .....: Menu rapido
-------------------------------------------------------------------------------
*/
procedure tedite300()
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
Procedimento .: TELAe300
Objetivo .....: Menu rapido
-------------------------------------------------------------------------------
*/
procedure telae300()

   setcolor( W_COREDIT )
   @ 05,02 say '³'
   @ 05,77 say '³'
   setcolor( W_CORGET )
   @ 04,03 say ' C¢digo..............:                                                    '
   @ 05,03 say '                                                                          '
   @ 06,03 say ' Descri‡„o...........:                                                    '
   @ 07,03 say ' Aceita Parcelamento.:                                                    '
   @ 08,03 say '                                                                          '
   @ 09,03 say '                                                                          '
   @ 10,03 say '                                                                          '
   @ 11,03 say '                                                                          '
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




