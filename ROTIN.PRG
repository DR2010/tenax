/*

   ROTIN.PRG - Cadastro de Programas

*/
#include "inkey.ch"
altd(1)

telanum('SROTIN','ROTIN')

abrir("ROTINA")

private  CAMPO       := {}
private  MASCARA     := {}
private  CABECALHO   := {}
private  TAMANHO     := {}
private  BESCAPE     := {|| .T. }
private  COR         := W_COREDIT
private  TITULO      := " Programas "
private  LININI      := 03
private  LINFIM      := 22
private  COLINI      := 02
private  COLFIM      := 77
private  BLOCK_DISP  := {|| .T. }
private  CAB_TITULO  := nil
private  BORDA       := 1

private  TECLA       := nil
private  TABELA      := nil

aadd( CAMPO     , "CODROT"           )
aadd( CAMPO     , "DESCROT"          )
aadd( CAMPO     , "FASTKEY"          )
aadd( CAMPO     , "NIVEL"            )

aadd( MASCARA   , "@!"               )
aadd( MASCARA   , "@!"               )
aadd( MASCARA   , "@!"               )
aadd( MASCARA   , "99999"            )

aadd( CABECALHO , "Codigo"           )
aadd( CABECALHO , "Descri‡„o"        )
aadd( CABECALHO , "FastKey"          )
aadd( CABECALHO , "Nivel"            )

aadd( TAMANHO   , 10                 )
aadd( TAMANHO   , 35                 )
aadd( TAMANHO   , 10                 )
aadd( TAMANHO   ,  5                 )

setcolor(W_COREDIT)
t0_ROTIN()

select ROTINA

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
           if ROTINA->(!eof())
              edit_ROTIN()
           end
           keyboard chr(1)

      case TEC = -2   && inclusao f3
           ins_ROTIN()
           keyboard chr(1)

      case TEC = -4   &&  exclusao f5
           if ROTINA->(!eof())
              if pergunta("Confirma exclusao da Rotina (S/N) ?")
                 while ROTINA->( ! rlock() ); end
                 ROTINA->( dbdelete() )
                 ROTINA->( dbunlock() )
                 ROTINA->( dbskip() )
              end
           end
           keyboard chr(1)

      case TEC = K_ESC
           CONTINUA := .F.

   end

   select ROTINA
   ROTINA->( dbsetorder(1) )
enddo

close data

return

************************************
function ins_ROTIN()
************************************

private X_CODROT,X_DESCROT, X_FASTKEY

setcursor(1)

while .t.

   t1_ROTIN()

   X_CODROT    := space(10)
   X_DESCROT   := space(30)
   X_FASTKEY   := space(10)

   @ 04,26 get X_CODROT   picture "@!" valid ! empty( X_CODROT )
   @ 06,26 get X_DESCROT
   @ 08,26 get X_FASTKEY  picture "@!"
   read

   if lastkey()=27; exit; end

   ROTINA->(Dbsetorder(1))
   if ROTINA->(Dbseek(X_CODROT))
      mensbeep(" Rotina ja Cadastrada ")
      loop
   end

   if pergunta('Confirma inclusao da Rotina (S/N) ?')
      ROTINA->( dbappend() )
      repl ROTINA->CODROT   with X_CODROT
      repl ROTINA->DESCROT  with X_DESCROT
      repl ROTINA->FASTKEY  with X_FASTKEY
      scroll(09,27,19,54,1)
      ROTINA->( dbunlock() )
   end

end

************************************
function edit_ROTIN()
************************************
setcursor(1)

t1_ROTIN()

X_CODROT := ROTINA->CODROT

@ 04,26 say    ROTINA->CODROT

X_DESCROT := ROTINA->DESCROT
X_FASTKEY := ROTINA->FASTKEY
                                 
while .t.
   @ 06,26 get X_DESCROT
   @ 08,26 get X_FASTKEY picture "@!"
   read

   if empty(X_DESCROT) .or. lastkey()=27
      setcursor(0)
      return nil
   end

   // Busca por FASTKEY existente
   ROTINA->( dbsetorder(2) )
   ROTINA->( dbseek( X_FASTKEY ))
   if ROTINA->( found() )
      mensbeep("Fastkey ja cadastrada !")
      loop
   end
   exit

end

ROTINA->( dbsetorder(1) )
ROTINA->( dbseek( X_CODROT ))

while ROTINA->( ! rlock() ); end
ROTINA->DESCROT := X_DESCROT
ROTINA->FASTKEY := X_FASTKEY
ROTINA->( dbunlock() )


setcursor(0)

return nil

/*
-------------------------------------------------------------------------------
Procedimento .: T0_ROTIN
Objetivo .....: Menu rapido
-------------------------------------------------------------------------------
*/
procedure t0_ROTIN()
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
Procedimento .: T1_ROTIN
Objetivo .....: Menu rapido
-------------------------------------------------------------------------------
*/
procedure t1_ROTIN()

   setcolor( W_COREDIT )
   @ 05,02 say '³'
   @ 05,77 say '³'
   setcolor( W_CORGET )
   @ 04,03 say ' Codigo da Rotina....:                                                    '
   @ 05,03 say '                                                                          '
   @ 06,03 say ' Descricao...........:                                                    '
   @ 07,03 say '                                                                         '
   @ 08,03 say ' Fastkey ............:                                                    '
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






