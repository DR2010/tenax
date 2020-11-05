/*
  +---------------------------------------------------------------------------+
  | >>>>>>>>>>>>>>>>>>>>>>                              <<<<<<<<<<<<<<<<<<<<< |
  |                                                                           |
  | >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>  EST83     <<<<<<<<<<<<<<<<<<<<<<<<<<<<<< |
  |                                                                           |
  | Sistema....:                                                              |
  |---------------------------------------------------------------------------|
  | Descricao..: Alteracao de Senha                                           |
  |---------------------------------------------------------------------------|
  | Cliente....:                                          | Ultima Alteracao  |
  | Analista...:                                          | Versao : 1.0      |
  | Programador: Daniel Machado                           | Data   : 20/04/94 |
  | Inicio.....: 06/04/1994                               | Hora   : 14:46    |
  +---------------------------------------------------------------------------+
*/
#include "inkey.ch"
#include "sic.ch"
local W_SCR := savescreen(), W_OLDCOR := setcolor()

abrir("USUARIO")
abrir("ROTINA")
abrir("DIREITO")

private X_CODUSU   := space(06) ,;
        X_NOMEUSU  := space(30) ,;
        X_SENHAF   := space(07) ,;
        X_SENHAA   := space(07) ,;
        X_SENHAN   := space(07) ,;
        X_SENHA2   := space(07)

set cursor on

mensagem("Informe dados para alteracao de senha. ")
@ 11,14 say 'ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿'
@ 12,14 say '³ Digite Usu rio .....:       ³'
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
      mensbeep("Usu rio nao Cadastrado. <ENTER>")
   else

      X_SENHAF := upper( descript( USUARIO->SENHA ) ) // Senha Atual

      X_SENHAA := get_senha(6,13,38) // Senha Digitada Pelo Usuario
      X_SENHAA := upper( X_SENHAA )

      if ( X_SENHAA = X_SENHAF )

         X_SENHAN := get_senha(6,14,38) // Senha Nova
         X_SENHA2 := get_senha(6,15,38) // Senha Nova Redigitada
         if X_SENHAN = X_SENHA2
            while ! USUARIO->( rlock() ) ; end
            USUARIO->SENHA := encript( X_SENHAN )
            mensbeep( "Alterado. <ENTER>")
            exit
         else
            mensbeep("Senhas Diferem. <ENTER>")
         end
      else
         mensbeep("Senha Atual Inv lida. <ENTER>-Continua <ESC>-Sai")
         if lastkey()=K_ESC
            exit
         end
      end
   end
end

restscreen(,,,,W_SCR)
setcolor( W_OLDCOR )

dbcloseall()
return

