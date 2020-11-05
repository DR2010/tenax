/*

   CONTAS A RECEBER
   SR9991.PRG - Cadastro de Parametros

*/

#include "inkey.ch"
setcancel(.t.)
ALTD(1)

S_JUROS     := 0.00
S_VALOR     := 0.00
S_DTJUROS   := DATE()

// --> Inicio

setcolor(W_COR_002)
telanum('SCR9991','SR9991')

abrir("SR9991")
SR9991->( dbgotop() )

if SR9991->( eof() )
   SR9991->( dbappend() )
end

while .T.

   status(' P a r a m e t r o s ')

   Stela_9991()

   S_JUROS := SR9991->JUROS
   @ 06,31 get S_JUROS picture "@E 999.99"

   S_VALOR := SR9991->VALOR
   @ 08,31 get S_VALOR picture "@E 99.99"

   S_DTJUROS := SR9991->DTJUROS
   @ 10,31 get S_DTJUROS
   read

   if lastkey()=K_ESC; exit; end

   if pergunta(" Confirma Dados (S/N) ")
      while SR9991->( ! rlock() ); end
      SR9991->JUROS     := S_JUROS
      SR9991->VALOR     := S_VALOR
      SR9991->DTJUROS   := S_DTJUROS
      SR9991->( dbunlock() )
   end

end

dbcloseall()

// --> Fim

/*
-----------------------------------------------------------------------------
                             Procedimento Tela
-----------------------------------------------------------------------------
*/

procedure STELA_9991()

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



