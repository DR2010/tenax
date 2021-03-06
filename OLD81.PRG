/*

   SCM - Sistema de Controle Metalurgico
   EST81.PRG - Cadastrar Senha

*/
#include "inkey.ch"
abrir("EST000")

X_ACESSO := space(7)
X_SENHA  := space(7)
X_NOME   := space(30)
X_NIVEL  := space(5)

XW_ACESSO := space(7)
XW_SENHA  := space(6)
XW_SENHA1 := space(6)
XW_SENHA2 := space(6)
XW_NIVEL  := 0

while .T.

   tela_81()

   XW_ACESSO := space(7)
   XW_SENHA  := space(6)

   @ 07,39 get XW_ACESSO pict "@!" valid ! empty( XW_ACESSO )
   read
   X_ACESSO = ( XW_ACESSO )

   if lastkey()=K_ESC; exit; end

   EST000->( dbseek( X_ACESSO ))

   W_CRIAR := .T.
   if EST000->( found() )
      W_CRIAR := .F.
      X_NOME := EST000->NOME
      XW_SENHA := descript( EST000->SENHA )
      XW_NIVEL := val( descript( EST000->NIVEL ))

      @ 09,27 say X_NOME
      @ 15,35 say XW_NIVEL picture "9999"
   else
      @ 09,27 get X_NOME picture "@!"
      read
      if lastkey()=K_ESC; loop; end
   endif

   if W_CRIAR

      @ 15, 35 get XW_NIVEL picture "9999"
      read
      if lastkey()=K_ESC; loop; end

      XW_SENHA1 := get_senha(6,11,35)
      XW_SENHA1 := upper( XW_SENHA1 )

      XW_SENHA2 := get_senha(6,13,35)
      XW_SENHA2 := upper( XW_SENHA2 )

      if XW_SENHA1 = XW_SENHA2

         EST000->( dbappend() )

         EST000->ACESSO:= X_ACESSO
         EST000->NOME  := X_NOME
         EST000->SENHA := encript( XW_SENHA1 )
         EST000->NIVEL := encript( strzero(XW_NIVEL,4) )
         EST000->( dbunlock() )
         exit
      else
         mensbeep("Senhas nao conferem !")
      end

   else

      if C_USU_NIVEL >= 10
         @ 15, 35 get XW_NIVEL picture "9999"
         read
         if lastkey()=K_ESC; loop; end
      end

      if pergunta("Deseja alterar senha (S/N) ?")
         XW_SENHA1 := get_senha(6,11,35)
         XW_SENHA1 := upper( XW_SENHA1 )

         if XW_SENHA1 <> XW_SENHA
            mensbeep("Senha Invalida !")
            loop
         end

         XW_SENHA2 := get_senha(6,13,35)
         XW_SENHA2 := upper( XW_SENHA2 )

         if XW_SENHA1 <> XW_SENHA2

            while EST000->( ! rlock() ); end
            EST000->SENHA := encript( XW_SENHA2 )
            EST000->NIVEL := encript( strzero(XW_NIVEL,4) )
            EST000->( dbunlock() )
            exit
         else
            mensbeep("Senhas Iguais !")
         end
      else
         while EST000->( ! rlock() ); end
         EST000->NIVEL := encript( strzero(XW_NIVEL,4) )
         EST000->( dbunlock() )
      end
   end
end

dbcloseall()

return


/*
-----------------------------------------------------------------------------
			     Procedimento Tela
-----------------------------------------------------------------------------
*/
procedure TELA_81()
telanum('SCR012','EST012')
   @ 02,02 say '旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴커'
   @ 03,02 say '�                                                                          �'
   @ 04,02 say '�                                                                          �'
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
   @ 19,02 say '�                                                                          �'
   @ 20,02 say '�                                                                          �'
   @ 21,02 say '�                                                                          �'
   @ 22,02 say '읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴켸'

   @ 06,19 say '旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�'
   @ 07,19 say '� Codigo de Acesso                        �'
   @ 08,19 say '�                                         �'
   @ 09,19 say '� Nome                                    �'
   @ 10,19 say '쳐컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�'
   @ 11,19 say '�         Senha                           �'
   @ 12,19 say '쳐컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�'
   @ 13,19 say '�         Senha                           �'
   @ 14,19 say '쳐컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�'
   @ 15,19 say '�         Nivel                           �'
   @ 16,19 say '읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�'
   sombra(06,19,16,61)
return
