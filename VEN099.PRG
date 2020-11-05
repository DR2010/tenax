/*
   TENAX - Demonstrativo de Aplicacao Financeira
   TENAX99.PRG - Cadastro de Parametros
*/

#include "inkey.ch"
setcancel(.t.)
ALTD(1)

X_ACRESCIMO   := 0.00

// --> Inicio

abrir("VEN099")
VEN099->( dbgotop() )

if VEN099->( eof() )
   VEN099->( dbappend() )
end

while .T.

   status(' P a r a m e t r o s ')

   tela_99()

   X_ACRESCIMO := VEN099->ACRESCIMO
   @ 04,23 get X_ACRESCIMO picture "999999.99"
   read

   if lastkey()=K_ESC; exit; end

   if conf(" Confirma Dados (S/N) ")
      while VEN099->( ! rlock() ); end
      VEN099->ACRESCIMO := X_ACRESCIMO
      VEN099->( dbunlock() )
      EXIT
   end

end

dbcloseall()

// --> Fim

/*
-----------------------------------------------------------------------------
                             Procedimento Tela
-----------------------------------------------------------------------------
*/
procedure TELA_99()

   @ 02,02 say 'ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿'
   @ 03,02 say '³                                                                          ³'
   @ 04,02 say '³  Perc. Acr‚scimo :                                                       ³'
   @ 05,02 say '³                                                                          ³'
   @ 06,02 say '³                                                                          ³'
   @ 07,02 say '³                                                                          ³'
   @ 08,02 say '³                                                                          ³'
   @ 09,02 say '³                                                                          ³'
   @ 10,02 say '³                                                                          ³'
   @ 11,02 say '³                                                                          ³'
   @ 12,02 say '³                                                                          ³'
   @ 13,02 say '³                                                                          ³'
   @ 14,02 say '³                                                                          ³'
   @ 15,02 say '³                                                                          ³'
   @ 16,02 say '³                                                                          ³'
   @ 17,02 say '³                                                                          ³'
   @ 18,02 say '³                                                                          ³'
   @ 19,02 say 'ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´'
   @ 20,02 say '³  <ESC> Retorna ³                                                         ³'
   @ 21,02 say '³                ³                                                         ³'
   @ 22,02 say 'ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ'

return


