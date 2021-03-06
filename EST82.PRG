/*
  +---------------------------------------------------------------------------+
  | >>>>>>>>>>>>>>>>>>>>>>                              <<<<<<<<<<<<<<<<<<<<< |
  |									      |
  | >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>  EST82     <<<<<<<<<<<<<<<<<<<<<<<<<<<<<< |
  |									      |
  | Sistema....:                                                              |
  |---------------------------------------------------------------------------|
  | Descricao..: Tabela de Direitos					      |
  |---------------------------------------------------------------------------|
  | Cliente....:                                          | Ultima Alteracao  |
  | Analista...:                                          | Versao : 1.0      |
  | Programador: Daniel Machado 			  | Data   : 20/04/94 |
  | Inicio.....: 06/04/1994				  | Hora   : 14:46    |
  +---------------------------------------------------------------------------+
*/
#include "inkey.ch"
#include "sic.ch"

abrir("USUARIO")
abrir("ROTINA")
abrir("DIREITO")

private X_CODUSU   := space(06) ,;
        X_CODROT   := space(10) ,;
        X_ACESSO   := space(01) ,;
        X_DIRVER   := space(11)

private X_CODROT   := space(10) ,;
	X_DESCROT  := space(30)

private ;
W_CA0540 := { "DIREITO->CODUSU+' - '+DIREITO->CODROT+' - '+ROTINA->DESCROT+' - '+DIREITO->ACESSO" }

private W_HEADER := { "Direitos" }

// >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

DIREITO->( dbsetorder(1) )
ROTINA->(  dbsetorder(1) )
DIREITO->( dbsetrelation( "ROTINA", {|| DIREITO->CODROT }) )

while .t.
   mensagem("Informe o Codigo do usuario. ")
   X_CODUSU := tela_usu()
   if X_CODUSU = "*"
      exit
   end

   USUARIO->( dbseek( X_CODUSU ))
   if USUARIO->( ! found() )
      mensbeep("Usuario Nao Cadastrado. <ENTER>")
   else
      DIREITO->( dbsetfilter( {|| DIREITO->CODUSU = X_CODUSU} ) )
      DIREITO->( dbgotop() )
      tdbe_0540() // Tela para dbedit
      mensagem("Selecione um item do menu ou <ESC> para abandonar.")
      DIREITO->( dbedit(08,02,15,78,W_CA0540,"DB_0540",,W_HEADER))
      mensagem("")
   end

end
DIREITO->( dbclearfilter() )
DIREITO->( dbclearrelation() )

dbcloseall()
return

// >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

/*
-----------------------------------------------------------------------------
Procedimento : DB_0540
Parametros   : nenhum
Retorno      : nenhum
Objetivo     : Controlar o dbedit modulo 0540
-----------------------------------------------------------------------------
*/
function DB_0540( MODO, COLUNA )
private WRET := 2

do case
   case MODO < 4 // Nao reconhecida
      WRET := 1

   case lastkey() = K_ESC
      WRET := 0

   case lastkey() = K_F3
      T_INS()

   case ! ( DIREITO->( eof() ) .OR. DIREITO->( bof() ) )
      do case
         case lastkey() = K_F5
            TEST82_DEL()
         case lastkey() = K_F4
            TEST82_ALT()
         case lastkey() = K_F7
            TEST_TUSU()
      endcase
endcase

return WRET

/*
-----------------------------------------------------------------------------
Procedimento : TDBE_0540
Parametros   : nenhum
Retorno      : nenhum
Objetivo     :
-----------------------------------------------------------------------------
*/
procedure tdbe_0540()

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
   @ 17,00 say '쳐컴컴컴컴컴컴컴컴컫컴컴컴컴컴컴컴컴컴컴컴컫컴컴컴컴컴컴컴컴컴컫컴컴컴컴컴컴컴캑'
   @ 18,00 say '�  <F3>  - Incluir � <F4> - Alterar        �                   �               �'
   @ 19,00 say '�  <F5>  - Excluir �                       �                   �               �'
   @ 20,00 say '읕컴컴컴컴컴컴컴컴컨컴컴컴컴컴컴컴컴컴컴컴컨컴컴컴컴컴컴컴컴컴컨컴컴컴컴컴컴컴켸'
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
   local W_SCR := savescreen(), W_OLDCOR := setcolor()
   set cursor on

   setcolor( W_CORWIND )
   t_right()

   X_CODROT   := space(10)
   X_ACESSO   := space(01)
   X_DIRVER   := space(11)

   @ 12,30 say X_CODUSU

   while .t.
      @ 13,30 get X_CODROT picture "@!" valid b_rotina( X_CODROT )
      @ 14,30 get X_ACESSO picture "!"  valid X_ACESSO $ "IACS"
      read
      setcolor( W_PDCOR )

      if lastkey()=K_ESC
         exit
      end

      DIREITO->( dbappend() )
      DIREITO->CODUSU  := X_CODUSU
      DIREITO->CODROT  := X_CODROT
      DIREITO->ACESSO  := X_ACESSO
      DIREITO->DIRVER  := encript( X_CODUSU+X_CODROT+X_ACESSO )
      DIREITO->( dbcommit() )
      DIREITO->( dbunlock() )
      mensbeep("Incluido. <ENTER>")
      exit
   end
   restscreen(,,,,W_SCR)
   setcolor( W_OLDCOR )
   set cursor off
return NIL

/*
-----------------------------------------------------------------------------
Procedimento : TEST82_ALT
Parametros   : nenhum
Retorno      : nenhum
Objetivo     : Alteracao de registro com cargo
-----------------------------------------------------------------------------
*/
static function TEST82_ALT()
   local W_SCR := savescreen(), W_OLDCOR:=setcolor()
   X_CODUSU := DIREITO->CODUSU
   X_CODROT := DIREITO->CODROT
   set cursor on

   setcolor( W_CORWIND )
   t_right()
   @ 12,30 say DIREITO->CODUSU
   @ 13,30 say DIREITO->CODROT

   X_ACESSO  := DIREITO->ACESSO
   @ 14,30 get X_ACESSO picture "!"  valid X_ACESSO $ "IACS"
   read
   setcolor( W_PDCOR )

   if ( lastkey() != K_ESC )
      while DIREITO->(! rlock()) ; end
      DIREITO->CODUSU  := X_CODUSU
      DIREITO->CODROT  := X_CODROT
      DIREITO->ACESSO  := X_ACESSO
      DIREITO->DIRVER  := encript( X_CODUSU+X_CODROT+X_ACESSO )
      DIREITO->( dbunlock() )
   end
   restscreen(,,,,W_SCR)
   setcolor( W_OLDCOR )
   set cursor off
return NIL

/*
-----------------------------------------------------------------------------
Procedimento : TEST_TUSU
Parametros   : nenhum
Retorno      : nenhum
Objetivo     :
-----------------------------------------------------------------------------
*/
function TEST_TUSU()

   X_CODUSU := tela_usu()
   if ( X_CODUSU != "*" )
      DIREITO->( dbclearfilter() )
      DIREITO->( dbsetfilter( {|| DIREITO->CODUSU = X_CODUSU} ) )
   end

return NIL

/*
-----------------------------------------------------------------------------
Procedimento : TEST82_DEL
Parametros   : nenhum
Retorno      : nenhum
Objetivo     : Inclusao de empresa
-----------------------------------------------------------------------------
*/
function TEST82_DEL()

   local W_SCR:=savescreen()

   if pergunta("Confirma (S/N) ?")
      while DIREITO->( ! rlock() ); end
      DIREITO->( dbdelete() )
      mensbeep("Eliminado. Tecle <ENTER>.")
   end
   restscreen(,,,,W_SCR)
return NIL

// EVENTO->( dbsetrelation( "TPEVENTO", {|| EVENTO->codeve } ) )
// EVENTO->( dbsetfilter( {|| TPEVENTO->CODEVE = "10" } ) )

/*
-----------------------------------------------------------------------------
Procedimento : TELA_USU
Parametros   : nenhum
Retorno      : nenhum
Objetivo     :
-----------------------------------------------------------------------------
*/
function tela_usu()
   local W_SCR := savescreen(10,14,15,45), WRET:=" ", W_USU := space(6)
   local W_OLDCOR := setcolor()

   setcolor( W_CORWIND )
   while .t.
      @ 10,17 say '旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴�'
      @ 11,17 say '�                             �'
      @ 12,17 say '� Entre com Usu쟲io :         �'
      @ 13,17 say '�                             �'
      @ 14,17 say '읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴�'
      sombra(10,17,14,47)
      @ 12,39 get W_USU picture "@!" valid ! empty( W_USU )
      read
      if lastkey()=K_ESC
	 WRET := "*"
	 exit
      end

      USUARIO->( dbseek( W_USU ) )
      if USUARIO->( ! found())
         mensbeep("Usu쟲io Nao Cadastrado. <ENTER>")
      else
	 if lastkey()=K_ESC
	    WRET := "*"
	 else
	    WRET := W_USU
	 end
	 exit
      end
   end
   restscreen(10,14,15,45)
   setcolor( W_OLDCOR )
return( WRET )

/*
-----------------------------------------------------------------------------
Procedimento : T_RIGHT
Parametros   : nenhum
Retorno      : nenhum
Objetivo     :
-----------------------------------------------------------------------------
*/
procedure t_right()

   @ 11,17 say '旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴커'
   @ 12,17 say '� Usu쟲io .:                                       �'
   @ 13,17 say '� Rotina ..:                                       �'
   @ 14,17 say '� Direitos :                                       �'
   @ 15,17 say '읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴켸'
   sombra(11,17,15,68)

return


/*
-----------------------------------------------------------------------------
Procedimento : B_ROTINA
Parametros   : nenhum
Retorno      : nenhum
Objetivo     :
-----------------------------------------------------------------------------
*/
function b_rotina( P_ROT )
   local WRET := .F.

   ROTINA->( dbseek( P_ROT ))
   if ROTINA->( found())
      @ 13,42 say left( ROTINA->DESCROT, 24 )
      DIREITO->( dbseek( X_CODUSU+P_ROT ))
      if DIREITO->( ! found())
	 WRET := .T.
      else
         mensbeep( "Direitos J� Informados. <ENTER>","NOBEEP" )
      end
   else
      mensbeep( "Rotina N꼘 Cadastrada. <ENTER>","NOBEEP" )
   end
return WRET

