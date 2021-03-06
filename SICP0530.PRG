/*
  +---------------------------------------------------------------------------+
  | >>>>>>>>>>>>>>>>>>>>>> RODOTEC SISTEMAS DE CONTROLE <<<<<<<<<<<<<<<<<<<<< |
  |                                                                           |
  | >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>  SICP0530  <<<<<<<<<<<<<<<<<<<<<<<<<<<<<< |
  |                                                                           |
  | Sistema....: Sistema de Informacoes Cadastrais                            |
  |---------------------------------------------------------------------------|
  | Descricao..: Tabela de Usuarios                                           |
  |---------------------------------------------------------------------------|
  | Cliente....: SEST/SENAT                               | Ultima Alteracao  |
  | Analista...: VanLoo/ Daniel Machado                   | Versao : 1.0      |
  | Programador: Daniel Machado                           | Data   : 20/04/94 |
  | Inicio.....: 06/04/1994                               | Hora   : 14:46    |
  +---------------------------------------------------------------------------+
*/
#include "inkey.ch"
#include "sic.ch"

// Arquivo   : SICA0800 (REGIAO)

private X_CODUSU   := space(02) ,;
        X_NOMEUSU  := space(20) ,;
        X_SENHA    := space(05)

private X_CODUSU   := space(02) ,;
        X_ROTINA   := space(04) ,;
        X_DIREITO  := space(01) ,;
        X_DIRVER   := space(07) ,;
        X_SENHAI   := space(05)

private W_CAMPOS := { "USUARIO->CODUSU+' - '+USUARIO->NOMEUSU" },;
        W_HEADER := { "Usuarios" }

// >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

sic_proc( "0530" )
mensagem("Selecione um dos itens do menu ou <ESC> para abandonar.")

while .t.
   tdbe_0530() // Tela para dbedit
   USUARIO->( dbedit(08,02,15,78,W_CAMPOS,"DB_0530",,W_HEADER))
   exit
end

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

   case lastkey() = K_INS
      T_INS()

   case ! ( REGIAO->( eof() ) .OR. REGIAO->( bof() ) )
      do case
         case lastkey() = K_DEL
            T_DEL()
         case lastkey() = K_F2
            T_F2()
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
   @ 04,00 say '������������������������������������������������������������������������������¿'
   @ 05,00 say '��   ���                                              �  Cadastro de Usuarios ��'
   @ 06,00 say '��������                                              ������������������������ٳ'
   @ 07,00 say '��                                                                             �'
   @ 08,00 say '��                                                                             �'
   @ 09,00 say '��                                                                             �'
   @ 10,00 say '��                                                                             �'
   @ 11,00 say '��                                                                             �'
   @ 12,00 say '��                                                                             �'
   @ 13,00 say '��                                                                             �'
   @ 14,00 say '��                                                                             �'
   @ 15,00 say '��                                                                             �'
   @ 16,00 say '��                                                                             �'
   @ 17,00 say '������������������������������������������������������������������������������Ĵ'
   @ 18,00 say '�� <INS> - Incluir � <F2> - Alterar      � <F10> - Imprimir    �               �'
   @ 19,00 say '�� <DEL> - Excluir � <F3> - Direitos     �                     �               �'
   @ 20,00 say '������������������������������������������������������������������������������Ĵ'
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
      X_CODUSU    := space(5)
      X_NOMEUSU   := space(20)
      X_SENHA     := space(5)

      @ 10,17 say '���������������������������������Ŀ'
      @ 11,17 say '� Usuario :                       �'
      @ 12,17 say '� Nome ...:                       �'
      @ 13,17 say '� Senha ..:                       �'
      @ 14,17 say '�����������������������������������'
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

      X_SENHA := chave(13,29)
      @ 13,17 say '� Senha II:                       �'
      X_SENHAI := chave(13,29)

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
Procedimento : T_F2
Parametros   : nenhum
Retorno      : nenhum
Objetivo     : Alteracao de registro com cargo
-----------------------------------------------------------------------------
*/
static function t_f2()
   local W_SCR := savescreen(10,14,15,52), W_OLDCOR := setcolor()
   set cursor on
   setcolor( W_CORWIND )

   X_CODUSU    := USUARIO->CODUSU
   X_NOMEUSU   := space(20)
   X_SENHA     := space(05)

   @ 10,17 say '���������������������������������Ŀ'
   @ 11,17 say '� Usuario :                       �'
   @ 12,17 say '� Nome ...:                       �'
   @ 13,17 say '� Senha ..:                       �'
   @ 14,17 say '�����������������������������������'
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
