/*

   CONTRA RETIRADA
   CR1101.PRG - Abatimento de duplicatas

*/
#include "inkey.ch"
setcancel(.t.)
ALTD(1)

telanum('SCE1101','SR1101')

abrir("SR1000")
abrir("CR0300")
abrir("CR0400")
abrir("VEN001")
abrir("VEN030")
 
S_DUPLICATA  := SPACE(5)
X_ABATIMENTO := 0.00
S_SEQUENCIA  := SPACE(1)
X_CODCLI     := SPACE(5)
X_TIPOVENDA  := space(2)
X_FORMAPAG   := space(2)
X_DT_VENC    := ctod('')
OPCAO        := 0

TL_S1101()
t_get_S1101()

dbcloseall()

// --> Fim

/*
-----------------------------------------------------------------------------
                             Procedimento Tela
-----------------------------------------------------------------------------
*/
procedure TL_S1101()

   setcolor(W_COR_002)
   @ 02,02 say '旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴커'
   @ 03,02 say '�                                                                          �'
   @ 04,02 say '�   Cliente..................:                                             �'
   @ 05,02 say '�   N. Duplicata.............:         /      Valor...:                    �'
   @ 06,02 say '�   Opcao....................: ( )                                         �'
   @ 07,02 say '쳐컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴캑'
   @ 08,02 say '�                                                                          �'
   @ 09,02 say '�   (1) Abatimento ..........:                                             �'
   @ 10,02 say '�                                                                          �'
   @ 11,02 say '�   (2) Forma de Pagamento...:                                             �'
   @ 12,02 say '�                                                                          �'
   @ 13,02 say '�   (3) Data de vencimento...:                                             �'
   @ 14,02 say '�                                                                          �'
   @ 15,02 say '�                                                                          �'
   @ 16,02 say '�                                                                          �'
   @ 17,02 say '�                                                                          �'
   @ 18,02 say '�                                                                          �'
   @ 19,02 say '�                                                                          �'
   @ 20,02 say '쳐컴컴컴컴컴컴컴컫컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴캑'
   @ 21,02 say '�  <ESC> RETORNA �                                                         �'
   @ 22,02 say '읕컴컴컴컴컴컴컴컨컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴켸'

return

procedure T_Get_S1101()

 while .t.

   TL_S1101()

   @ 04,32 get X_CODCLI      pict "@!"  valid tes_codcli   (X_CODCLI,4,32,30)
   @ 05,32 get S_DUPLICATA   pict "@!"
   @ 05,41 get S_SEQUENCIA   pict "@!"  valid tes_Sduplicata(5,32)
   read
   if lastkey()=27;exit;end

   SR1000->( dbsetorder(2) )
   if !SR1000->( dbseek( "P" + S_DUPLICATA + S_SEQUENCIA ) )
      mensbeep("Duplicata Pendente Inexistente !")
      loop
   end

   VEN030->(dbsetorder(1))
   if !VEN030->(dbseek(S_DUPLICATA))
      mensbeep(" Nota Fiscal Inexistente ! ")
      loop
   end

   X_TIPOVENDA    := VEN030->TIPOVENDA
   OPCAO          := 0

   @ 05,58 say SR1000->VALOR picture "@E 999,999,999.99"

   @ 06,34 get OPCAO         pict "9"
   read
   if lastkey()=27;exit;end

   if OPCAO = 1
      @ 09,32 get X_ABATIMENTO  pict "@E 99,999,999.99"  valid Sabati(X_ABATIMENTO)
   else
      if OPCAO = 2
         @ 11,32 get X_FORMAPAG pict "@!"                valid tes_Sformapag(11,32,25)
      else
         if OPCAO = 3
            @ 13,32 get X_DT_VENC  pict "99/99/99"       valid !empty(X_DT_VENC)
         else
            mensbeep ("Opcao Invalida !")
            loop
         end
      end
   end

   read
   if lastkey()=27;exit;end

   if pergunta(" Confirma Dados (S/N) ?")
      while SR1000->( ! rlock() ); end
         if OPCAO = 1
            SR1000->ABATIMENTO := X_ABATIMENTO
            SR1000->FLG_ABATI  := "X"
         end
         if OPCAO = 2
            SR1000->FORMAPAG   := X_FORMAPAG
         end
         if OPCAO = 3
            SR1000->DT_VENC    := X_DT_VENC
         end
         SR1000->( dbunlock() )
         S_DUPLICATA  := SPACE(8)
         X_ABATIMENTO := 0.00
         S_SEQUENCIA  := SPACE(1)
         X_CODCLI     := SPACE(5)
         X_TIPOVENDA  := space(2)
         X_FORMAPAG   := space(2)
         X_DT_VENC    := ctod('')
      end
   end

return
 
Function SAbati( X_ABATIMENTO )
  local RET := .T.
  if SR1000->VALOR < X_ABATIMENTO
    mensbeep("Valor do Abatimento superior a Duplicata !")
    RET := .F.
   end
return ( RET )

 

