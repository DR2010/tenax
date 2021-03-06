/*
  +---------------------------------------------------------------------------+
  | >>>>>>>>>>>>>>>>>>>>>>                              <<<<<<<<<<<<<<<<<<<<< |
  |                                                                           |
  | >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>  EST81     <<<<<<<<<<<<<<<<<<<<<<<<<<<<<< |
  |                                                                           |
  | Sistema....:                                                              |
  |---------------------------------------------------------------------------|
  | Descricao..: Tabela de Usuarios                                           |
  |---------------------------------------------------------------------------|
  | Cliente....:                                          | Ultima Alteracao  |
  | Analista...:                                          | Versao : 1.0      |
  | Programador: Daniel Machado                           | Data   : 20/04/94 |
  | Inicio.....: 06/04/1994                               | Hora   : 14:46    |
  +---------------------------------------------------------------------------+
*/
#include "inkey.ch"
#include "sic.ch"

abrir("USUARIO")
abrir("ROTINA")
abrir("DIREITO")

private X_CODUSU   := space(06) ,;
        X_NOMEUSU  := space(20) ,;
        X_SENHA    := space(06)

private X_CODUSU   := space(06) ,;
        X_ROTINA   := space(04) ,;
        X_DIREITO  := space(01) ,;
        X_DIRVER   := space(07) ,;
        X_SENHAI   := space(06)

private W_CAMPOS := { "USUARIO->CODUSU+' - '+USUARIO->NOMEUSU" },;
        W_HEADER := { "Usuarios" }

// >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

mensagem("Selecione um dos itens do menu ou <ESC> para abandonar.")

while .t.
   tdbe_0530() // Tela para dbedit
   USUARIO->( dbedit(05,02,15,78,W_CAMPOS,"DB_0530",,W_HEADER))
   exit
end

dbcloseall()
return

// >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

/*
-----------------------------------------------------------------------------
Procedimento : DB_0530
Parametros   : nenhum
Retorno      : nenhum
Objetivo     : Controlar o dbedit modulo 0530
-----------------------------------------------------------------------------
*/
function DB_0530( MODO, COLUNA )
private WRET :=2

do case
   case MODO < 4 // Nao reconhecida
      WRET := 1

   case lastkey() = K_ESC
      WRET := 0

   case lastkey() = K_F3
      T_INS()

   case ! ( USUARIO->( eof() ) .OR. USUARIO->( bof() ) )
      do case
         case lastkey() = K_F5
            T_DEL()
         case lastkey() = K_F4
            TEST81_DEL()
      endcase
endcase

return WRET

/*
-----------------------------------------------------------------------------
Procedimento : TDBE_0530
Parametros   : nenhum
Retorno      : nenhum
Objetivo     :
-----------------------------------------------------------------------------
*/
procedure tdbe_0530()

   setcolor( W_PDCOR )
   @ 04,00 say '旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴커'
   @ 05,00 say '�                                                                              �'
   @ 06,00 say '�                                                                              �'
   @ 07,00 say '�                                                                              �'
   @ 08,00 say '�                                                                              �'
   @ 09,00 say '�                                                                              �'
   @ 10,00 say '�                                                                              �'
   @ 11,00 say '�                                                                              �'
   @ 12,00 say '�                                                                              �'
   @ 13,00 say '�                                                                              �'
   @ 14,00 say '�                                                                              �'
   @ 15,00 say '�                                                                              �'
   @ 16,00 say '�                                                                              �'
   @ 17,00 say '쳐컴컴컴컴컴컴컴컴컫컴컴컴컴컴컴컴컴컴컴컫컴컴컴컴컴컴컴컴컴컴컫컴컴컴컴컴컴컴캑'
   @ 18,00 say '�  <F3>  - Incluir � <F4> - Alterar      �                     �               �'
   @ 19,00 say '�  <F5>  - Excluir �                     �                     �               �'
   @ 20,00 say '읕컴컴컴컴컴컴컴컴컨컴컴컴컴컴컴컴컴컴컴컨컴컴컴컴컴컴컴컴컴컴컨컴컴컴컴컴컴컴켸'
return

/*
-----------------------------------------------------------------------------
Procedimento : T_INS
Parametros   : nenhum
Retorno      : nenhum
Objetivo     : Inclusao de Usuarios
-----------------------------------------------------------------------------
*/
static function t_ins()
   local W_SCR:=savescreen(10,14,15,52), W_OLDCOR:=setcolor()
   set cursor on
   setcolor( W_CORWIND )

   while .t.
      X_CODUSU    := space(6)
      X_NOMEUSU   := space(20)
      X_SENHA     := space(6)

      @ 10,17 say '旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�'
      @ 11,17 say '� Usu쟲io :                       �'
      @ 12,17 say '� Nome ...:                       �'
      @ 13,17 say '� Senha ..:                       �'
      @ 14,17 say '읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�'
      sombra(10,17,14,51)

      @ 11,29 get X_CODUSU picture "@!" valid ! empty( X_CODUSU )
      read

      if lastkey()=K_ESC
         exit
      end

      USUARIO->( dbseek( X_CODUSU ))
      if USUARIO->( found())
         mensbeep("Usuario ja incluido. <ENTER>")
         loop
      end

      @ 12,29 get X_NOMEUSU  picture "@!" valid ! empty( X_NOMEUSU )
      read
      if lastkey()=K_ESC
         exit
      end

      X_SENHA := get_senha(6,13,29)
      @ 13,17 say '� Senha II:                       �'
      X_SENHAI := get_senha(6,13,29)

      if ( X_SENHA=X_SENHAI )

         USUARIO->( dbappend() )
         USUARIO->CODUSU  := X_CODUSU
         USUARIO->NOMEUSU := X_NOMEUSU
         USUARIO->SENHA   := encript( X_SENHA )
         USUARIO->( dbcommit() )
         USUARIO->( dbunlock() )

         mensbeep("Incluido. <ENTER>")
         exit
      else
         mensbeep("Senhas Diferem. <ENTER>")
      end
   end

   restscreen(10,14,15,52)
   setcolor( W_OLDCOR )
   set cursor off
return NIL

/*
-----------------------------------------------------------------------------
Procedimento : TEST81_DEL
Parametros   : nenhum
Retorno      : nenhum
Objetivo     : Alteracao de registro com cargo
-----------------------------------------------------------------------------
*/
function TEST81_DEL()
   local W_SCR := savescreen(10,14,15,52), W_OLDCOR := setcolor()
   set cursor on
   setcolor( W_CORWIND )

   X_CODUSU    := USUARIO->CODUSU
   X_NOMEUSU   := space(20)
   X_SENHA     := space(06)

   @ 10,17 say '旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�'
   @ 11,17 say '� Usu쟲io :                       �'
   @ 12,17 say '� Nome ...:                       �'
   @ 13,17 say '� Senha ..:                       �'
   @ 14,17 say '읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�'
   sombra(10,14,14,51)

   @ 11,29 say X_CODUSU   picture "@!"
   X_NOMEUSU := USUARIO->NOMEUSU

   @ 12,29 get X_NOMEUSU  picture "@!"  valid ! empty( X_NOMEUSU )
   read
   if lastkey()!=K_ESC
      while USUARIO->( ! rlock()); end
      USUARIO->NOMEUSU := X_NOMEUSU
      USUARIO->( dbcommit() )
      USUARIO->( dbunlock() )
      mensbeep("Alterado. <ENTER>","NOBEEP")
   end

   restscreen(10,14,15,52)
   setcolor( W_OLDCOR )
   set cursor off

return NIL

/*
-----------------------------------------------------------------------------
Procedimento : T_DEL
Parametros   : nenhum
Retorno      : nenhum
Objetivo     : Inclusao de empresa
-----------------------------------------------------------------------------
*/
static function t_del()

   local W_SCR:=savescreen()

   if pergunta("Confirma (S/N) ?")
      while USUARIO->( ! rlock()) ; end
      USUARIO->( dbdelete() )
      mensbeep("Eliminado. Tecle <ENTER>.")
   end
   restscreen(,,,,W_SCR)
return NIL
