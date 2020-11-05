/*

   CONTAS A RECEBER
   CR9991.PRG - Cadastro de Parametros

*/

#include "inkey.ch"
setcancel(.t.)
ALTD(1)

X_JUROS     := 0.00
X_VALOR     := 0.00
X_DTJUROS   := DATE()

// --> Inicio

telanum('SCE9991','CR9991')

abrir("CR9991")
CR9991->( dbgotop() )

if CR9991->( eof() )
   CR9991->( dbappend() )
end

while .T.

   status(' P a r a m e t r o s ')

   tela_9991()

   X_JUROS := CR9991->JUROS
   @ 06,31 get X_JUROS picture "@E 999.99"

   X_VALOR := CR9991->VALOR
   @ 08,31 get X_VALOR picture "@E 99.99"

   X_DTJUROS := CR9991->DTJUROS
   @ 10,31 get X_DTJUROS
   read

   if lastkey()=K_ESC; exit; end

   if pergunta(" Confirma Dados (S/N) ")
      while CR9991->( ! rlock() ); end
      CR9991->JUROS     := X_JUROS
      CR9991->VALOR     := X_VALOR
      CR9991->DTJUROS   := X_DTJUROS
      CR9991->( dbunlock() )
   end

end

dbcloseall()

// --> Fim

/*
-----------------------------------------------------------------------------
                             Procedimento Tela
-----------------------------------------------------------------------------
*/
procedure TELA_9991()

   @ 02,02 say 'ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿'
   @ 03,02 say '³                                                                          ³'
   @ 04,02 say '³  Contas a Receber                                                        ³'
   @ 05,02 say '³                                                                          ³'
   @ 06,02 say '³    Juros.............  % :         ao mˆs                                ³'
   @ 07,02 say '³                                                                          ³'
   @ 08,02 say '³    Dif. Vencimentos.. R$ :                                               ³'
   @ 09,02 say '³                                                                          ³'
   @ 10,02 say '³    Data................. :                                               ³'
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



