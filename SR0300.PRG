/*

   CONTAS A RECEBER/CONTRA RETIRADA
   SR0300.PRG - Cadastro de tipo de venda

*/
#include "inkey.ch"
altd(1)

telanum('SCE0300','SR0300')

abrir("SR0300")

private  CAMPO       := {}
private  MASCARA     := {}
private  CABECALHO   := {}
private  TAMANHO     := {}
private  BESCAPE     := {|| .T. }
private  COR         := W_COR_002
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

setcolor( W_COR_002 )
Stedite300()

select SR0300

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
             Seditae300()
          end
          keyboard chr(1)

      case TEC = -2   && inclusao f3
          Sinsere300()
          keyboard chr(1)

      case TEC = -4   &&  exclusao f5
          if !eof()
             if pergunta("Confirma exclus„o do Tipo de Venda (S/N) ?")
                while SR0300->( ! rlock() ); end
                SR0300->( dbdelete() )
                SR0300->( dbunlock() )
                SR0300->( dbskip() )
             end
           end
          keyboard chr(1)

      case TEC = K_ESC
         CONTINUA := .F.
   end
   select SR0300
enddo

close data

return

************************************
function Sinsere300()
************************************

private S_TIPOVENDA,S_DESCRICAO,S_PARCELA

setcursor(1)

while .t.

   Stelae300()

   S_TIPOVENDA    := space(2)
   S_DESCRICAO    := space(30)
   S_PARCELA      := space(01)

   @ 04,26 get S_TIPOVENDA    picture "99" valid ! empty( S_TIPOVENDA )
   @ 06,26 get S_DESCRICAO    picture "@!"
   @ 07,26 get S_PARCELA      picture "@!" // valid S_PARCELA  = 'X' .or. S_PARCELA = ' '
   read

   if lastkey()=27; exit; end

   S_TIPOVENDA := zerofill( S_TIPOVENDA )

   @ 04,26 say S_TIPOVENDA

   SR0300->(Dbsetorder(1))
   if SR0300->(Dbseek(S_TIPOVENDA))
      mensbeep(" Tipo de Venda j  cadastrado ")
      loop
   end

   if pergunta('Confirma inclus„o do Tipo de Venda (S/N) ?')
      SR0300->( dbappend() )
      repl SR0300->TIPOVENDA   with S_TIPOVENDA
      repl SR0300->DESCRICAO   with S_DESCRICAO
      repl SR0300->PARCELA     with S_PARCELA
      scroll(09,27,19,54,1)
      SR0300->( dbunlock() )
   end

end

************************************
function Seditae300()
************************************
setcursor(1)

Stelae300()

@ 04,26 say    SR0300->TIPOVENDA
S_DESCRICAO := SR0300->DESCRICAO
S_PARCELA   := SR0300->PARCELA
                                 
@ 06,26 get S_DESCRICAO pict "@!"
@ 07,26 get S_PARCELA   pict "@!"
read

if empty(S_DESCRICAO) .or. lastkey()=27
   setcursor(0)
   return nil
end

while SR0300->( ! rlock() ); end
SR0300->DESCRICAO := S_DESCRICAO
SR0300->PARCELA   := S_PARCELA
SR0300->( dbunlock() )

setcursor(0)

return nil

/*
-------------------------------------------------------------------------------
Procedimento .: STEDITe300
Objetivo .....: Menu rapido
-------------------------------------------------------------------------------
*/
procedure Stedite300()
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
Procedimento .: STELAe300
Objetivo .....: Menu rapido
-------------------------------------------------------------------------------
*/
procedure Stelae300()

   setcolor( W_COR_002 )
   @ 05,02 say '³'
   @ 05,77 say '³'
   setcolor( W_COR_002 )
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

