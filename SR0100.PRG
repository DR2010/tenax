/*

   CONTAS A RECEBER
   CR0100.PRG - Cadastro de Bancos

*/
#include "inkey.ch"
altd(1)

telanum('SCE0100','CR0100')

abrir("CR0100")

private  CAMPO       := {}
private  MASCARA     := {}
private  CABECALHO   := {}
private  TAMANHO     := {}
private  BESCAPE     := {|| .T. }
private  COR         := W_COR_002
private  TITULO      := " Tabela de  Bancos  "
private  LININI      := 03
private  LINFIM      := 22
private  COLINI      := 02
private  COLFIM      := 77
private  BLOCK_DISP  := {|| .T. }
private  CAB_TITULO  := nil
private  BORDA       := 1

private  TECLA       := nil
private  TABELA      := nil

aadd( CAMPO     , "CODBANCO"  )
aadd( CAMPO     , "DESCRICAO" )
aadd( MASCARA   , "999"       )
aadd( MASCARA   , "@!"        )
aadd( CABECALHO , "Banco"     )
aadd( CABECALHO , "Descri‡„o" )
aadd( TAMANHO   , 05 )
aadd( TAMANHO   , 70 )

setcolor( W_COR_002 )
tedite100()

select CR0100

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
             editae100()
          end
          keyboard chr(1)

      case TEC = -2   && inclusao f3
          insere100()
          keyboard chr(1)

      case TEC = -4   &&  exclusao f5
          if !eof()
             if pergunta("Confirma exclus„o do Banco (S/N) ?")
                while CR0100->( ! rlock() ); end
                CR0100->( dbdelete() )
                CR0100->( dbunlock() )
                CR0100->( dbskip()   )
             end
           end
          keyboard chr(1)

      case TEC = K_ESC
         CONTINUA := .F.
   end
   select CR0100
enddo

close data

return

************************************
function insere100()
************************************

private X_CODBANCO,X_DESCRICAO

setcursor(1)

while .t.

   telae100()

   X_CODBANCO     := space(3)
   X_DESCRICAO    := space(30)

   @ 04,26 get X_CODBANCO     picture "999" valid ! empty( X_CODBANCO )
   @ 06,26 get X_DESCRICAO    picture "@!"
   read

   if lastkey()=27; exit; end

   X_CODBANCO := zerofill( X_CODBANCO )

   @ 04,26 say X_CODBANCO

   if dbseek(X_CODBANCO)
      mensbeep(" Banco j  cadastrado ")
      loop
   end

   if pergunta('Confirma inclus„o do Banco  (S/N) ?')
      CR0100->( dbappend() )
      repl CR0100->CODBANCO    with X_CODBANCO
      repl CR0100->DESCRICAO   with X_DESCRICAO
      scroll(09,27,19,54,1)
      CR0100->( dbunlock() )
   end

end

************************************
function editae100()
************************************
setcursor(1)

telae100()

@ 04,26 say    CR0100->CODBANCO
X_DESCRICAO := CR0100->DESCRICAO
                                 
@ 06,26 get X_DESCRICAO pict "@!"
read

if empty(X_DESCRICAO) .or. lastkey()=27
   setcursor(0)
   return nil
end

while CR0100->( ! rlock() ); end
CR0100->descricao := X_DESCRICAO
CR0100->( dbunlock() )

setcursor(0)

return nil


/*
-------------------------------------------------------------------------------
Procedimento .: TEDITe100
Objetivo .....: Menu rapido
-------------------------------------------------------------------------------
*/
procedure tedite100()
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
Procedimento .: TELAe100
Objetivo .....: Menu rapido
-------------------------------------------------------------------------------
*/
procedure telae100()

   setcolor( W_COR_002 )
   @ 05,02 say '³'
   @ 05,77 say '³'
   setcolor( W_COR_002 )
   @ 04,03 say ' C¢digo do Banco.....:                                                    '
   @ 05,03 say '                                                                          '
   @ 06,03 say ' Descri‡„o ..........:                                                    '
   @ 07,03 say '                                                                          '
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





