/*
  +---------------------------------------------------------------------------+
  | >>>>>>>>>>>>>>>>>>>>>> RODOTEC SISTEMAS DE CONTROLE <<<<<<<<<<<<<<<<<<<<< |
  |                                                                           |
  | >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>  SICP0540  <<<<<<<<<<<<<<<<<<<<<<<<<<<<<< |
  |                                                                           |
  | Sistema....: Sistema de Informacoes Cadastrais                            |
  |---------------------------------------------------------------------------|
  | Descricao..: Alteracao de Senha                                           |
  |---------------------------------------------------------------------------|
  | Cliente....: SEST/SENAT                               | Ultima Alteracao  |
  | Analista...: VanLoo/ Daniel Machado                   | Versao : 1.0      |
  | Programador: Daniel Machado                           | Data   : 20/04/94 |
  | Inicio.....: 06/04/1994                               | Hora   : 14:46    |
  +---------------------------------------------------------------------------+
*/
#include "inkey.ch"
#include "sic.ch"

local W_SCR := savescreen(), W_OLDCOR := setcolor()

private X_CODUSU   := space(05) ,;
        X_NOMEUSU  := space(30) ,;
        X_SENHAF   := space(05) ,;
        X_SENHAA   := space(05) ,;
        X_SENHAN   := space(05) ,;
        X_SENHA2   := space(05)

set cursor on

sic_proc( "0550" )
mensagem("Informe dados para alteracao de senha. ")
@ 11,14 say 'ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿'
@ 12,14 say '³ Digite Usuario .....:       ³'
@ 13,14 say '³ Digite Senha Atual .:       ³'
@ 14,14 say '³ Digite Senha Nova ..:       ³'
@ 15,14 say '³ Redigite Senha Nova :       ³'
@ 16,14 say 'ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ'
sombra(11,14,16,44)
mensagem("")

while .t.
   @ 12,38 get X_CODUSU picture "@!" valid ! empty( X_CODUSU )
   read
   if lastkey()=K_ESC
      exit
   end
   USUARIO->( dbseek( X_CODUSU ) )

   if USUARIO->( ! found())
      mensbeep("Usuario nao Cadastrado. <ENTER>")
   else
      X_SENHAF := descript( USUARIO->SENHA ) // Senha Atual

      X_SENHAA := chave(13,38) // Senha Digitada Pelo Usuario
      if ( X_SENHAA = X_SENHAF )

         X_SENHAN := chave(14,38) // Senha Nova
         X_SENHA2 := chave(15,38) // Senha Nova Redigitada
         if X_SENHAN = X_SENHA2
            while ! USUARIO->( rlock() ) ; end
            USUARIO->SENHA := encript( X_SENHAN )
            mensbeep( "Alterado. <ENTER>")
            exit
         else
            mensbeep("Senhas Diferem. <ENTER>")
         end
      else
         mensbeep("Senha Atual Invalida. <ENTER>-Continua <ESC>-Sai")
         if lastkey()=K_ESC
            exit
         end
      end
   end
end

restscreen(,,,,W_SCR)
setcolor( W_OLDCOR )
return

