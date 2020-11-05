/*

   CONTAS A RECEBER
   BAC999.PRG - TROCA DE CLIENTES

*/
#include "inkey.ch"
altd(1)

telanum('BAC999','BAC999')

abrir("VEN001")
abrir("BAC999")

X_DESCRICAO := SPACE(30)

private  CAMPO       := {}
private  MASCARA     := {}
private  CABECALHO   := {}
private  TAMANHO     := {}
private  BESCAPE     := {|| .T. }
private  COR         := W_COREDIT
private  TITULO      := " TROCA DE CLIENTES "
private  LININI      := 03
private  LINFIM      := 22
private  COLINI      := 02
private  COLFIM      := 77
private  BLOCK_DISP  := {|| .T. }
private  CAB_TITULO  := nil
private  BORDA       := 1

private  TECLA       := nil
private  TABELA      := nil

aadd( CAMPO     , "CODCLI"    )
aadd( CAMPO     , "DESCRICAO" )
aadd( CAMPO     , "CODNOVO"   )
aadd( MASCARA   , "@!"        )
aadd( MASCARA   , "@!"        )
aadd( MASCARA   , "@!"        )
aadd( CABECALHO , "Cod.Atual" )
aadd( CABECALHO , "Descricao" )
aadd( CABECALHO , "Cod.Novo"  )
aadd( TAMANHO   , 09          )
aadd( TAMANHO   , 40          )
aadd( TAMANHO   , 09          )

setcolor(W_COREDIT)
tedite999()

select BAC999
BAC999->(dbsetorder(2))

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

      case TEC = -2   && inclusao f3
          insere999()
          keyboard chr(1)

      case TEC = -4   &&  exclusao f5
          if !eof()
             if pergunta("Confirma exclus„o da Alteracao (S/N) ?")
                while BAC999->( ! rlock() ); end
                BAC999->( dbdelete() )
                BAC999->( dbunlock() )
                BAC999->( dbskip()   )
             end
           end
          keyboard chr(1)

      case TEC = K_ESC
         CONTINUA := .F.
   end
   select BAC999
   BAC999->(dbsetorder(2))
enddo

close data

return

************************************
function insere999()
************************************

private X_CODCLI,X_CODNOVO,X_DESCRICAO

setcursor(1)

while .t.

   telae999()

   X_CODCLI        := space(5)
   X_CODNOVO       := space(5)
   X_DESCRICAO     := space(40)

   @ 04,26 get X_CODCLI        picture "@!"  valid tes_codcli   ( X_CODCLI,04,26,30 )
   @ 05,26 get X_CODNOVO       picture "@!"  valid  ! EMPTY     ( X_CODNOVO )

   read

   X_DESCRICAO     := VEN001->GUERRA

   if lastkey()=27; exit; end

   BAC999->(dbsetorder(1))
   if BAC999->(dbseek(X_CODNOVO) )
      mensbeep(" Codigo Novo Ja Utilizado !")
      loop
   end

   BAC999->(dbsetorder(2))
   if BAC999->(dbseek(X_CODCLI) )
      mensbeep(" Codigo Atual Ja Utilizado !")
      loop
   end

   BAC999->(dbsetorder(3))
   if BAC999->(dbseek(X_CODCLI+X_CODNOVO) )
      mensbeep(" Alteracao ja cadastrada !")
      loop
   end

   if pergunta('Confirma inclus„o do Codigo novo (S/N) ?')
      BAC999->( dbappend() )
      repl BAC999->CODCLI     with X_CODCLI
      repl BAC999->CODNOVO    with X_CODNOVO
      repl BAC999->DESCRICAO  with X_DESCRICAO
      scroll(09,27,19,54,1)
      BAC999->( dbunlock() )
   end

end

return nil

/*
-------------------------------------------------------------------------------
Procedimento .: TEDITe999
Objetivo .....: Menu rapido
-------------------------------------------------------------------------------
*/
procedure tedite999()
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
Procedimento .: TELAe999
Objetivo .....: Menu rapido
-------------------------------------------------------------------------------
*/
procedure telae999()

   setcolor( W_COREDIT )
   @ 05,02 say '³'
   @ 05,77 say '³'
   setcolor( W_CORGET )
   @ 04,03 say ' Cod.Atual...........:                                                    '
   @ 05,03 say ' Cod.Novo............:                                                    '
   @ 06,03 say '                                                                          '
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

