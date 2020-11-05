/*
  +---------------------------------------------------------------------------+
  | >>>>>>>>>>>>>>>>>>>>>> RODOTEC SISTEMAS DE CONTROLE <<<<<<<<<<<<<<<<<<<<< |
  |									      |
  | >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>  SICP0540  <<<<<<<<<<<<<<<<<<<<<<<<<<<<<< |
  |									      |
  | Sistema....: Sistema de Informacoes Cadastrais			      |
  |---------------------------------------------------------------------------|
  | Descricao..: Tabela de Direitos					      |
  |---------------------------------------------------------------------------|
  | Cliente....: SEST/SENAT				  | Ultima Alteracao  |
  | Analista...: VanLoo/ Daniel Machado 		  | Versao : 1.0      |
  | Programador: Daniel Machado 			  | Data   : 20/04/94 |
  | Inicio.....: 06/04/1994				  | Hora   : 14:46    |
  +---------------------------------------------------------------------------+
*/
#include "inkey.ch"
#include "sic.ch"
// Arquivo   : SICADIR	(DIREITO)

private X_CODUSU   := space(05) ,;
	X_CODROT   := space(04) ,;
        X_ACESSO   := space(01) ,;
        X_DIRVER   := space(11)

private X_CODROT   := space(04) ,;
	X_DESCROT  := space(30)

private ;
W_CA0540 := { "DIREITO->CODUSU+' - '+DIREITO->CODROT+' - '+ROTINA->DESCROT+' - '+DIREITO->ACESSO" }

private W_HEADER := { "Direitos" }

// >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

DIREITO->( dbsetorder(1) )
ROTINA->(  dbsetorder(1) )
DIREITO->( dbsetrelation( "ROTINA", {|| DIREITO->CODROT }) )

sic_proc( "0540" )
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

   case lastkey() = K_INS
      T_INS()

   case ! ( REGIAO->( eof() ) .OR. REGIAO->( bof() ) )
      do case
	 case lastkey() = K_DEL
	    T_DEL()
	 case lastkey() = K_F2
	    T_F2()
	 case lastkey() = K_F3
	    T_F3()
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
   @ 04,00 say 'ÚÂÄÄÄÂÂÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂ¿'
   @ 05,00 say '³³   ³³³                                              ³  Cadastro de Direitos ³³'
   @ 06,00 say '³ÃÄÄÄÁÁÙ                                              ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ³'
   @ 07,00 say '³³                                                                             ³'
   @ 08,00 say '³³                                                                             ³'
   @ 09,00 say '³Æ                                                                             µ'
   @ 10,00 say '³³                                                                             ³'
   @ 11,00 say '³³                                                                             ³'
   @ 12,00 say '³³                                                                             ³'
   @ 13,00 say '³³                                                                             ³'
   @ 14,00 say '³³                                                                             ³'
   @ 15,00 say '³³                                                                             ³'
   @ 16,00 say '³³                                                                             ³'
   @ 17,00 say '³ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´'
   @ 18,00 say '³³ <INS> - Incluir ³ <F2> - Alterar        ³ <F10> - Imprimir  ³               ³'
   @ 19,00 say '³³ <DEL> - Excluir ³ <F3> - Trocar Usuario ³                   ³               ³'
   @ 20,00 say '³ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´'
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

   X_CODROT   := space(04)
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
Procedimento : T_F2
Parametros   : nenhum
Retorno      : nenhum
Objetivo     : Alteracao de registro com cargo
-----------------------------------------------------------------------------
*/
static function t_f2()
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
Procedimento : T_F3
Parametros   : nenhum
Retorno      : nenhum
Objetivo     :
-----------------------------------------------------------------------------
*/
static function t_f3()

   X_CODUSU := tela_usu()
   if ( X_CODUSU != "*" )
      DIREITO->( dbclearfilter() )
      DIREITO->( dbsetfilter( {|| DIREITO->CODUSU = X_CODUSU} ) )
   end

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
   local W_SCR := savescreen(10,14,15,45), WRET:=" ", W_USU := space(5)
   local W_OLDCOR := setcolor()

   setcolor( W_CORWIND )
   while .t.
      @ 10,17 say 'ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿'
      @ 11,17 say '³                             ³'
      @ 12,17 say '³ Entre com Usuario :         ³'
      @ 13,17 say '³                             ³'
      @ 14,17 say 'ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ'
      sombra(10,17,14,47)
      @ 12,39 get W_USU picture "@!" valid ! empty( W_USU )
      read
      if lastkey()=K_ESC
	 WRET := "*"
	 exit
      end

      USUARIO->( dbseek( W_USU ) )
      if USUARIO->( ! found())
	 mensbeep("Usuario Nao Cadastrado. <ENTER>")
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

   @ 11,17 say 'ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿'
   @ 12,17 say '³ Usuario .:                                       ³'
   @ 13,17 say '³ Rotina ..:                                       ³'
   @ 14,17 say '³ Direitos :                                       ³'
   @ 15,17 say 'ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ'
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
      @ 13,37 say ROTINA->DESCROT
      DIREITO->( dbseek( X_CODUSU+P_ROT ))
      if DIREITO->( ! found())
	 WRET := .T.
      else
         mensbeep( "Direitos Ja Informados. <ENTER>","NOBEEP" )
      end
   else
      mensbeep( "Rotina Nao Cadastrada. <ENTER>","NOBEEP" )
   end
return WRET

