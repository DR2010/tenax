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

   @ 02,02 say '旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴커'
   @ 03,02 say '�                                                                          �'
   @ 04,02 say '�  Contas a Receber                                                        �'
   @ 05,02 say '�                                                                          �'
   @ 06,02 say '�    Juros.............  % :         ao m늮                                �'
   @ 07,02 say '�                                                                          �'
   @ 08,02 say '�    Dif. Vencimentos.. R$ :                                               �'
   @ 09,02 say '�                                                                          �'
   @ 10,02 say '�    Data................. :                                               �'
   @ 11,02 say '�                                                                          �'
   @ 12,02 say '�                                                                          �'
   @ 13,02 say '�                                                                          �'
   @ 14,02 say '�                                                                          �'
   @ 15,02 say '�                                                                          �'
   @ 16,02 say '�                                                                          �'
   @ 17,02 say '�                                                                          �'
   @ 18,02 say '�                                                                          �'
   @ 19,02 say '쳐컴컴컴컴컴컴컴컫컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴캑'
   @ 20,02 say '�  <ESC> Retorna �                                                         �'
   @ 21,02 say '�                �                                                         �'
   @ 22,02 say '읕컴컴컴컴컴컴컴컨컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴켸'

return



