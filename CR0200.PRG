/*

   CONTAS A RECEBER
   CR0200.PRG - Cadastro de Agencias

*/
#include "inkey.ch"
altd(1)

telanum('SCE0200','CR0200')

abrir("CR0100")
abrir("CR0200")

private  CAMPO       := {}
private  MASCARA     := {}
private  CABECALHO   := {}
private  TAMANHO     := {}
private  BESCAPE     := {|| .T. }
private  COR         := W_COREDIT
private  TITULO      := " Tabela de Agˆncias "
private  LININI      := 03
private  LINFIM      := 22
private  COLINI      := 02
private  COLFIM      := 77
private  BLOCK_DISP  := {|| .T. }
private  CAB_TITULO  := nil
private  BORDA       := 1

private  TECLA       := nil
private  TABELA      := nil

aadd( CAMPO     , "CODBANCO"    )
aadd( CAMPO     , "CODAGENCIA"    )
aadd( CAMPO     , "DESCRICAO" )
aadd( MASCARA   , "999"       )
aadd( MASCARA   , "9999"    )
aadd( MASCARA   , "@!"        )
aadd( CABECALHO , "Banco"     )
aadd( CABECALHO , "Agˆncia"   )
aadd( CABECALHO , "Descri‡„o" )
aadd( TAMANHO   , 05 )
aadd( TAMANHO   , 07 )
aadd( TAMANHO   , 63 )

setcolor(W_COREDIT)
tedite200()

select CR0200

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
             editae200()
          end
          keyboard chr(1)

      case TEC = -2   && inclusao f3
          insere200()
          keyboard chr(1)

      case TEC = -4   &&  exclusao f5
          if !eof()
             if pergunta("Confirma exclus„o da Agˆncia (S/N) ?")
                while CR0200->( ! rlock() ); end
                CR0200->( dbdelete() )
                CR0200->( dbunlock() )
                CR0200->( dbskip()   )
             end
           end
          keyboard chr(1)

      case TEC = K_ESC
         CONTINUA := .F.
   end
   select CR0200
enddo

close data

return

************************************
function insere200()
************************************

private X_CODBANCO,X_CODAGENCIA,X_DESCRICAO

setcursor(1)

while .t.

   telae200()

   X_CODBANCO      := space(3)
   X_CODAGENCIA    := space(4)
   X_DESCRICAO     := space(30)

   @ 04,26 get X_CODBANCO      picture "999"     valid tes_codbanco ( 04, 26)
   @ 05,26 get X_CODAGENCIA    picture "9999"  valid ! empty( X_CODAGENCIA )

   X_DESCRICAO     := space(30)
   @ 07,26 get X_DESCRICAO     picture "@!"
   read

   if lastkey()=27; exit; end

   @ 05,26 say X_CODAGENCIA

   CR0200->(dbsetorder(1))

   if CR0200->(dbseek(X_CODBANCO+X_CODAGENCIA) )
      mensbeep(" Banco/Agˆncia j  cadastrado ")
      loop
   end

   if pergunta('Confirma inclus„o da Agˆncia (S/N) ?')
      CR0200->( dbappend() )
      repl CR0200->CODBANCO      with X_CODBANCO
      repl CR0200->CODAGENCIA    with X_CODAGENCIA
      repl CR0200->DESCRICAO     with X_DESCRICAO
      scroll(09,27,19,54,1)
      CR0200->( dbunlock() )
   end

end

************************************
function editae200()
************************************
setcursor(1)

telae200()

@ 04,26 say    CR0200->CODBANCO
@ 05,26 say    CR0200->CODAGENCIA
X_DESCRICAO := CR0200->DESCRICAO

@ 07,26 get X_DESCRICAO pict "@!"
read

if empty(X_DESCRICAO) .or. lastkey()=27
   setcursor(0)
   return nil
end

while CR0200->( ! rlock() ); end
CR0200->descricao := X_DESCRICAO
CR0200->( dbunlock() )

setcursor(0)

return nil

/*
-------------------------------------------------------------------------------
Procedimento .: TEDITe200
Objetivo .....: Menu rapido
-------------------------------------------------------------------------------
*/
procedure tedite200()
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
Procedimento .: TELAe200
Objetivo .....: Menu rapido
-------------------------------------------------------------------------------
*/
procedure telae200()

   setcolor( W_COREDIT )
   @ 05,02 say '³'
   @ 05,77 say '³'
   setcolor( W_CORGET )
   @ 04,03 say ' Banco...............:                                                    '
   @ 05,03 say ' Agˆncia.............:                                                    '
   @ 06,03 say '                                                                          '
   @ 07,03 say ' Descri‡„o ..........:                                                    '
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
