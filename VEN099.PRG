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

   @ 02,02 say '旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴커'
   @ 03,02 say '�                                                                          �'
   @ 04,02 say '�  Perc. Acr굎cimo :                                                       �'
   @ 05,02 say '�                                                                          �'
   @ 06,02 say '�                                                                          �'
   @ 07,02 say '�                                                                          �'
   @ 08,02 say '�                                                                          �'
   @ 09,02 say '�                                                                          �'
   @ 10,02 say '�                                                                          �'
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


