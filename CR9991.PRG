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



