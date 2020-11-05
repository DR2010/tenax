/*
  +---------------------------------------------------------------------------+
  | >>>>>>>>>>>>>>>>>>>>>> RODOTEC SISTEMAS DE CONTROLE <<<<<<<<<<<<<<<<<<<<< |
  |                                                                           |
  | >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>  SPVPROT   <<<<<<<<<<<<<<<<<<<<<<<<<<<<<< |
  |                                                                           |
  | Sistema....: Sistema de Informacoes Cadastrais - Modulo Empresas          |
  |---------------------------------------------------------------------------|
  | Descricao..: Funcoes particulares do sistema                              |
  |---------------------------------------------------------------------------|
  | Cliente....:                                         | Ultima Alteracao   |
  | Analista...:                                         | Versao : 1.0       |
  | Programador: Daniel Machado                          | Data   : 19/07/94  |
  | Inicio.....: 18/07/1994                              | Hora   : 15:15     |
  +---------------------------------------------------------------------------+
*/
#include "inkey.ch"
#include "sic.ch"

/*
Procedimento : TITULO
Parametros   : nenhum
Retorno      : nenhum
Objetivo     :
*/
procedure TITULO( P_TITULO )
local W_OLDCOR := setcolor()

P_TITULO := alltrim( P_TITULO )
setcolor( W_CORMENU )
@ 03,01 say padc( P_TITULO, 78 )
setcolor( W_PDCOR )

return

/*
Procedimento : WORKAREA
Parametros   : nenhum
Retorno      : nenhum
Objetivo     :
*/
procedure workarea()

setcolor( W_CORMENU )
@ 03,01 clear to 21,78

return

/*
Procedimento : SPV_DEC
Parametros   : nenhum
Retorno      : nenhum
Objetivo     : Declara matriz com bases de dados, verifica existencia de
              arquivo e cria arquivos DBFS.
*/
procedure SPV_DEC

   local W_STDBF[6], W_DBF:={}

   // DBF EMPRESA -> EMPRESA

   W_STDBF[1]:={ { "CODEMP",   "C",  3, 0 } ,;  // Codigo da Empresa
                 { "RAZSOC",   "C", 40, 0 } ,;  // Razao Social
                 { "ENDERECO", "C", 40, 0 } ,;  // Endereco
                 { "CEP",      "C",  8, 0 } ,;  // C.E.P.
                 { "BAIRRO",   "C", 20, 0 } ,;  // Bairro
                 { "CIDADE",   "C", 20, 0 } ,;  // Cidade
                 { "ESTADO",   "C",  2, 0 } ,;  // Estado
                 { "TELEFONE", "C",  7, 0 } ,;  // Telefone
                 { "RAMAL",    "C",  4, 0 } ,;  // Ramal
                 { "DDD",      "C",  4, 0 } ,;  // D.D.D.
                 { "ATVPRI",   "C",  4, 0 } ,;  // Atividade Principal
                 { "CEI",      "C",  1, 0 } ,;  // Possui C.E.I. ou nao ?
                 { "CGC",      "C", 14, 0 } ,;  // C.G.C.
                 { "QTDFUN",   "N",  4, 0 } }   // Quantidade de Funcionarios

   // DBF FUNCIONARIO -> FUNCIONARIO

   W_STDBF[2]:={ { "CODEMP"    , "C",  3, 0 } ,;
                 { "MATRICULA" , "C",  8, 0 } ,;
                 { "NOME"   ,    "C", 25, 0 } ,;
                 { "ENDERECO",   "C", 30, 0 } ,;
                 { "CEP",        "C",  8, 0 } ,;
                 { "MUNICIPIO",  "C", 15, 0 } ,;
                 { "BAIRRO",     "C", 15, 0 } ,;
                 { "DDD",        "C",  4, 0 } ,;
                 { "TELEFONE",   "C",  7, 0 } ,;
                 { "SETOR",      "C",  3, 0 } }

   // DBF TARIFA -> TARIFA

   W_STDBF[3]:={ { "CODTAR",    "C",  3,  0 } ,;
                 { "VALTAR",    "N",  9,  2 } }

   // DBF PEDIDO -> PEDIDO

   W_STDBF[4]:={ { "CODEMP",      "C",  3,  0 } ,;
                 { "MATRICULA",   "C",  8,  0 } ,;
                 { "DIAUTILP",    "C",  2,  0 } ,;
                 { "USAPADRAO",   "C",  1,  0 } }

   // DBF PEDITEM -> PEDITEM

   W_STDBF[5]:={ { "CODEMP"    , "C",  3,  0 } ,;
                 { "MATRICULA" , "C",  8,  0 } ,;
                 { "TRANSP"    , "C",  1,  0 } ,;
                 { "CODTAR"    , "C",  3,  0 } ,;
                 { "MODO"      , "C",  1,  0 } }


   // DBF PARAMETR -> PARAMETRO

   W_STDBF[6]:={ { "NOMEFANT",  "C", 40, 0 } ,;
                 { "DIASUTIL",  "N",  2, 0 } ,;
                 { "CGC",       "C", 14, 0 } ,;
                 { "USOEMP"  ,  "C", 25, 0 } }

   // DBF IMPRESSAO -> IMPRESSAO

   W_STDBF[6]:={ { "DTEMISSAO", "D",  8, 0 } ,;
                 { "TITULO",    "C", 40, 0 } ,;
                 { "HREMISSAO", "C",  5, 0 } ,;
                 { "STATUS",    "C",  1, 0 } ,;
                 { "PADRAO",    "N",  3, 0 } ,;
                 { "ARQPRN",    "C", 12, 0 } }

   aadd( W_DBF, W_DIR+"EMPRESAS.dbf") // empresa
   aadd( W_DBF, W_DIR+"FUNCIONA.dbf") // funcionario
   aadd( W_DBF, W_DIR+"TARIFA.dbf") // tarifa
   aadd( W_DBF, W_DIR+"PEDIDO.dbf") // pedido
   aadd( W_DBF, W_DIR+"PEDITENS.dbf") // item de pedido
   aadd( W_DBF, W_DIR+"PARAMETR.dbf") // parametro
   aadd( W_DBF, W_DIR+"RELATARQ.dbf") // impressao

   // Verifica existencia dos dbfs, caso nao haja algum, recria.

   for x = 1 to len( W_DBF )
      if ! file( W_DBF[x] )
        mensagem("Criando arquivo DBF => "+W_DBF[x])
        dbcreate( W_DBF[x], W_STDBF[x] )
      end
   next
   mensagem("")
return

/*
Procedimento : SPV_VERIND
Parametros   : nenhum
Retorno      : nenhum
Objetivo     : Verifica indices do sistema
*/
Procedure SPV_VERIND( P_MODO )

   local WSCREEN := savescreen( 10, 13, 14, 64 ), W_INDICE:={}, W_CONTINUA:=.F.

   aadd( W_INDICE, W_DIR+"EMPRESA1.NTX" ) // empresa
   aadd( W_INDICE, W_DIR+"EMPRESA2.NTX" ) // empresa
   aadd( W_INDICE, W_DIR+"FUNCION1.NTX" ) // funcionario
   aadd( W_INDICE, W_DIR+"FUNCION2.NTX" ) // funcionario
   aadd( W_INDICE, W_DIR+"FUNCION3.NTX" ) // funcionario
   aadd( W_INDICE, W_DIR+"FUNCION4.NTX" ) // funcionario
   aadd( W_INDICE, W_DIR+"TARIFA1.NTX" ) // tarifa
   aadd( W_INDICE, W_DIR+"TARIFA2.NTX" ) // tarifa
   aadd( W_INDICE, W_DIR+"PEDIDO1.NTX" ) // pedido
   aadd( W_INDICE, W_DIR+"PEDIDO2.NTX" ) // pedido
   aadd( W_INDICE, W_DIR+"PEDITEM1.NTX" ) // item de pedido
   aadd( W_INDICE, W_DIR+"PEDITEM2.NTX" ) // item de pedido
   aadd( W_INDICE, W_DIR+"PEDITEM3.NTX" ) // item de pedido
   aadd( W_INDICE, W_DIR+"RELATAR1.NTX" ) // impressao
   aadd( W_INDICE, W_DIR+"CONFERE1.NTX" ) // confere

   begin sequence

   W_CONTINUA := .F.
   for x = 1 to len( W_INDICE )
      if ! file( W_INDICE[x] )
        W_CONTINUA := .T.
      end
   next

   if ( ! W_CONTINUA ) .AND. ( P_MODO = "INDEX" )
      break
   end

   W_COROLD:=setcolor()
   setcolor( W_CORWIND )

   @ 10,13 say 'ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´          ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿'
   @ 11,13 say '³  0%        25%        50%        75%       100% ³'
   @ 12,13 say '³                                                 ³'
   @ 13,13 say 'ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ'
   sombra( 10, 13, 13, 63 )
   setcolor( W_COROLD )

   Indexar("EMPRESA")
   Indexar("FUNCIONARIO")
   Indexar("TARIFA")
   Indexar("PEDIDO")
   Indexar("PEDITEM")
   Indexar("IMPRESSAO")
   Indexar("CONFERE")

   dbcloseall()
   Set exclusive off
   restscreen( 10, 13, 14, 64, WSCREEN )
   end sequence

return

/*
Procedimento : ESCIND
Parametros   : nenhum
Retorno      : nenhum
Objetivo     : Verifica indices do sistema
*/
function ESCIND( )

   local   W_RET := .T.
   private WSCREEN := savescreen( 10, 13, 14, 64 ), W_INDICE:={}, W_CONTINUA:=.F.
   private W_DBF := {}, W_MENDBF := {}, W_RESP, MENDBF, W_COROLD

begin sequence
   dbcloseall()
   set exclusive on

   aadd( W_MENDBF, ">> Todos << ") // 1
   aadd( W_MENDBF, "EMPRESA     ") // 2
   aadd( W_MENDBF, "FUNCIONARIO ") // 3
   aadd( W_MENDBF, "TARIFA      ") // 4
   aadd( W_MENDBF, "PEDIDO      ") // 5
   aadd( W_MENDBF, "PEDITENS    ") // 6
   aadd( W_MENDBF, "IMPRESSAO   ") // 7
   aadd( W_MENDBF, "CONFERE     ") // 8

   aadd( W_DBF, W_DIR+"Todos.dbf   ") // 1
   aadd( W_DBF, W_DIR+"EMPRESAS    ") // 2
   aadd( W_DBF, W_DIR+"FUNCIONA    ") // 3
   aadd( W_DBF, W_DIR+"TARIFA      ") // 4
   aadd( W_DBF, W_DIR+"PEDIDO      ") // 5
   aadd( W_DBF, W_DIR+"PEDITENS    ") // 6
   aadd( W_DBF, W_DIR+"RELATARQ    ") // 7
   aadd( W_DBF, W_DIR+"CONFERE     ") // 8

   setcolor(W_CORWG)
   W_SCR := savescreen( 09, 15, 19, 53 )
   @ 09,15 say 'ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿'
   @ 10,15 say '³ Escolha o arquivo a ser reindexado ³'
   @ 11,15 say 'ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´'
   @ 12,15 say '³                                    ³'
   @ 13,15 say '³                                    ³'
   @ 14,15 say '³                                    ³'
   @ 15,15 say '³                                    ³'
   @ 16,15 say '³                                    ³'
   @ 17,15 say '³                                    ³'
   @ 18,15 say 'ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ'
   sombra( 09, 15, 18, 52 )

   W_RESP := achoice( 12, 16, 17, 51, W_MENDBF )
   restscreen( 09, 15, 19, 53, W_SCR )

   if lastkey()=K_ESC
      W_RET := .F.
      break
   endif

   W_COROLD:=setcolor()
   setcolor( W_CORWIND )

   @ 10,13 say 'ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´          ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿'
   @ 11,13 say '³  0%        25%        50%        75%       100% ³'
   @ 12,13 say '³                                                 ³'
   @ 13,13 say 'ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ'
   sombra( 10, 13, 13, 63 )
   setcolor( W_COROLD )

   do case
      case W_RESP = 1
         spv_verind("REINDEX")
      case W_RESP = 2  ; Indexar( "EMPRESA" )
      case W_RESP = 3  ; Indexar( "FUNCIONARIO" )
      case W_RESP = 4  ; Indexar( "TARIFA" )
      case W_RESP = 5  ; Indexar( "PEDIDO" )
      case W_RESP = 6  ; Indexar( "PEDITEM" )
      case W_RESP = 7  ; Indexar( "IMPRESSAO" )
      case W_RESP = 8  ; Indexar( "CONFERE" )
   endcase

   dbcloseall()
   set exclusive off
end sequence
restscreen( 10, 13, 14, 64, WSCREEN )
return( W_RET )

/*
Procedimento : ABRIR
Parametros   : nenhum
Retorno      : nenhum
Objetivo     : Abrir arquivos
*/
Procedure ABRIR( W_FILE )

   local W_ALIAS, W_DBF, W_MODO

   do case
      case W_FILE = "EMPRESA"
         W_ALIAS := "EMPRESA"
         W_DBF   := W_DIR+"EMPRESAS.DBF"
         W_MODO  := .T.

      case W_FILE = "FUNCIONARIO"
         W_ALIAS := "FUNCIONARIO"
         W_DBF   := W_DIR+"FUNCIONA.dbf"
         W_MODO  := .T.

      case W_FILE = "TARIFA"
         W_ALIAS := "TARIFA"
         W_DBF   := W_DIR+"TARIFA.dbf"
         W_MODO  := .T.

      case W_FILE = "PEDIDO"
         W_ALIAS := "PEDIDO"
         W_DBF   := W_DIR+"PEDIDO.dbf"
         W_MODO  := .T.

      case W_FILE = "PEDITEM"
         W_ALIAS := "PEDITEM"
         W_DBF   := W_DIR+"PEDITENS.dbf"
         W_MODO  := .T.

      case W_FILE = "PARAMETRO"
         W_ALIAS := "PARAMETRO"
         W_DBF   := W_DIR+"PARAMETR.dbf"
         W_MODO  := .T.

      case W_FILE = "IMPRESSAO"
         W_ALIAS := "IMPRESSAO"
         W_DBF   := W_DIR+"RELATARQ.dbf"
         W_MODO  := .T.

      case W_FILE = "UNICO"
         W_ALIAS := "UNICO"
         W_DBF   := W_DIR+"TMPUNICO.dbf"
         W_MODO  := .F.

      case W_FILE = "CONFERE"
         W_ALIAS := "CONFERE"
         W_DBF   := W_DIR+"CONFERE.dbf"
         W_MODO  := .F.

      case W_FILE = "FINAL"
         W_ALIAS := "FINAL"
         W_DBF   := W_DIR+"TMPFINAL.dbf"
         W_MODO  := .F.

   endcase

   dbusearea( .T., "DBFNTX", W_DBF, W_ALIAS, W_MODO )
   Abrir_indices( W_ALIAS )

return

/*
Procedimento : SPV_SHARQ
Parametros   : nenhum
Retorno      : nenhum
Objetivo     : Mostra o nome do arquivo na janela de indexacao
*/
procedure SPV_sharq( PARQ )
   @ 10,34 say space(8)
   @ 10,34 say PARQ
return

/*
Procedimento : SPV_PROC
Parametros   : nenhum
Retorno      : nenhum
Objetivo     : Mostra o numero do PRG que esta sendo executada.
*/
procedure SPV_proc( P_PROC )
   @ 02,06 say P_PROC
return


/*
-----------------------------------------------------------------------------
Procedimento : SHELL
Parametros   : nenhum
Retorno      : nenhum
Objetivo     :
-----------------------------------------------------------------------------
*/
procedure shell()
   local P_SCR := savescreen()
   cls
   set cursor on
   ! prompt [SPV] $p$g
   ! command
   restscreen(,,,,P_SCR)
return

/*
-----------------------------------------------------------------------------
Procedimento : M_TABELAS
Parametros   : nenhum
Retorno      : nenhum
Objetivo     :
-----------------------------------------------------------------------------
*/
function m_tabelas( P_COND )
   local P_HEADER:={}, P_CAMPOS:={}, P_SCR, getlist:={}
   local P_HDSEP := "ËÍ", P_COLSEP := "-"
   local W_OLDCOR := setcolor()

   setcolor( W_CORWIND )
   do case

      case readvar() = "X_CODEMP"

         P_SCR := savescreen(08,16,17,63)
         @  8, 16 say "ÕÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¸"
         @  9, 16 say "³                                             ³"
         @ 10, 16 say "Æ                                             µ"
         @ 11, 16 say "³                                             ³"
         @ 12, 16 say "³                                             ³"
         @ 13, 16 say "³                                             ³"
         @ 14, 16 say "³                                             ³"
         @ 15, 16 say "³                                             ³"
         @ 16, 16 say "ÔÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¾"
         sombra(08,16,16,62)

         P_HEADER := { " Empresa  " }
         P_CAMPOS := { "' '+EMPRESA->CODEMP+' - '+EMPRESA->RAZSOC+' '" }
         EMPRESA->( dbgotop() )
         EMPRESA->( dbedit(09,17,15,61,P_CAMPOS,,,P_HEADER,P_HDSEP,;
                                            P_COLSEP))
         restscreen(08,16,17,63,P_SCR)
         if lastkey() != 27
            X_CODEMP := EMPRESA->CODEMP
            keyboard chr(13)
         end
         setcolor( W_OLDCOR )

      case readvar() = "X_MATRICULA"

         P_SCR := savescreen(08,16,17,63)
         @  8, 16 say "ÕÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¸"
         @  9, 16 say "³                                             ³"
         @ 10, 16 say "Æ                                             µ"
         @ 11, 16 say "³                                             ³"
         @ 12, 16 say "³                                             ³"
         @ 13, 16 say "³                                             ³"
         @ 14, 16 say "³                                             ³"
         @ 15, 16 say "³                                             ³"
         @ 16, 16 say "ÔÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¾"
         sombra(08,16,16,62)

         P_HEADER := { "     Matricula  Funcionario " }
         P_CAMPOS := { "'     '+FUNCIONARIO->MATRICULA+' - '+"+;
                       "FUNCIONARIO->NOME+'     '" }
         FUNCIONARIO->( dbsetfilter( {||FUNCIONARIO->CODEMP = X_CODEMP} ))
         FUNCIONARIO->( dbgotop() )
         FUNCIONARIO->( dbedit(09,17,15,61,P_CAMPOS,,,P_HEADER,P_HDSEP,;
                                                    P_COLSEP))
         restscreen(08,16,17,63,P_SCR)
         if lastkey() != 27
            X_MATRICULA:= FUNCIONARIO->MATRICULA
           keyboard chr(13)
        end
        FUNCIONARIO->( dbclearfilter() )
        setcolor( W_OLDCOR )

      case readvar() = "X_CODTAR"

         P_SCR := savescreen(08,16,17,63)
         @  8, 16 say "ÕÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¸"
         @  9, 16 say "³                                             ³"
         @ 10, 16 say "Æ                                             µ"
         @ 11, 16 say "³                                             ³"
         @ 12, 16 say "³                                             ³"
         @ 13, 16 say "³                                             ³"
         @ 14, 16 say "³                                             ³"
         @ 15, 16 say "³                                             ³"
         @ 16, 16 say "ÔÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¾"
         sombra(08,16,16,62)

         P_HEADER := { " Tarifas " }
         P_CAMPOS := { "' '+TARIFA->CODTAR+' - '+"+;
                       "transform(TARIFA->VALTAR,'999,999.99')+' '" }
         TARIFA->( dbgotop() )
         TARIFA->( dbedit(09,17,15,61,P_CAMPOS,,,P_HEADER,P_HDSEP,;
                                                    P_COLSEP))
         restscreen(08,16,17,63,P_SCR)
         if lastkey() != 27
            X_CODTAR := TARIFA->CODTAR
           keyboard chr(13)
        end
        setcolor( W_OLDCOR )
   endcase
   setcolor( W_OLDCOR )

return NIL

/*
-----------------------------------------------------------------------------
Procedimento : TT_EMPRE
Parametros   : nenhum
Retorno      : nenhum
Objetivo     :
-----------------------------------------------------------------------------
*/
function tt_empre( P_COD, P_LIN, P_COL )
   local WRET:= .F.

   if ! empty( P_COD )
      EMPRESA->( dbsetorder( 1 ))
      EMPRESA->( dbseek( P_COD ))
      if EMPRESA->( found() )
        WRET := .T.
      else
        m_tabelas()
      end
      if P_LIN # NIL
         @ P_LIN, P_COL say '- '+EMPRESA->APELIDO
      end
   end

return WRET

/*
-----------------------------------------------------------------------------
Procedimento : BUSCA_EMPRESA
Parametros   : nenhum
Retorno      : nenhum
Objetivo     :
-----------------------------------------------------------------------------
*/
function busca_empresa( P_COD, P_LIN, P_COL )
   local WRET:= .F.

   if ! empty( P_COD )
      EMPRESA->( dbsetorder(1) )
      EMPRESA->( dbseek( P_COD ))
      if EMPRESA->( found() )
        WRET := .T.
      else
        m_tabelas()
      end

      if P_LIN # NIL
         if lastkey() # K_ESC
            @ P_LIN, P_COL say '- '+EMPRESA->RAZSOC
         else
            if lastkey()=K_ESC
               @ P_LIN, P_COL say '- '+space(40)
            end
         end
      end

   else
      m_tabelas()
   end

return WRET

/*
-----------------------------------------------------------------------------
Procedimento : busca_matricula
Parametros   : nenhum
Retorno      : nenhum
Objetivo     :
-----------------------------------------------------------------------------
*/
function busca_matricula( P_COD, P_LIN, P_COL, P_EMPRESA )
   local WRET:= .F.

   if ! empty( P_COD )
      FUNCIONARIO->( dbsetorder(1) )  // empresa + matricula
      FUNCIONARIO->( dbseek( P_EMPRESA+P_COD ))
      if FUNCIONARIO->( found() )
        WRET := .T.
      else
        m_tabelas()
      end

      if P_LIN # NIL
         if lastkey() # K_ESC
            @ P_LIN, P_COL say '- '+FUNCIONARIO->NOME
         else
            if lastkey()=K_ESC
               @ P_LIN, P_COL say '- '+space(25)
            end
         end
      end
   else
      m_tabelas()
   end

return WRET

/*
-----------------------------------------------------------------------------
Procedimento : BUSCA_TARIFA
Parametros   : nenhum
Retorno      : nenhum
Objetivo     :
-----------------------------------------------------------------------------
*/
function busca_tarifa( P_COD, P_LIN, P_COL )
   local WRET:= .F.

   if ! empty( P_COD )
      TARIFA->( dbsetorder(1) )
      TARIFA->( dbseek( P_COD ))
      if TARIFA->( found() )
        WRET := .T.
      else
        m_tabelas()
      end

      if lastkey() # K_ESC .and. P_LIN # NIL
         @ P_LIN, P_COL say TARIFA->VALTAR picture "999,999.99"
      else
         if lastkey()=K_ESC .and. P_LIN # NIL
            @ P_LIN, P_COL say '- '+space(25)
         end
      end
   else
      m_tabelas()
   end

return WRET

/*
-----------------------------------------------------------------------------
Procedimento : BUSCA_TRANSP
Parametros   : nenhum
Retorno      : nenhum
Objetivo     :
-----------------------------------------------------------------------------
*/
function busca_transp( P_COD, P_LIN, P_COL )
   local WRET:= .F., W_SCR := savescreen(10,20,18,41), W_OLDCOR:=setcolor()
   local VET_TRANSP := { { "O", " Onibus " } ,;
                         { "M", " Metro  " } ,;
                         { "T", " Trem   " } ,;
                         { "B", " Barca  " } }

   W_ACHAR := ascan( VET_TRANSP,{|Busca| Busca[1] == P_COD} )

   if W_ACHAR = 0

      setcolor(W_CORPERG)
      @ 10,20 say 'ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿'
      @ 11,20 say '³    Transporte     ³'
      @ 12,20 say 'ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´'
      @ 13,20 say '³  O - Onibus       ³'
      @ 14,20 say '³  M - Metro        ³'
      @ 15,20 say '³  T - Trem         ³'
      @ 16,20 say '³  B - Barca        ³'
      @ 17,20 say 'ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ'
      sombra(10,20,17,40)
      menswait("Tecle <ENTER>.")
      restscreen(10,20,18,41,W_SCR)
      WRET := .F.
   else
      WRET := .T.
      if lastkey() # K_ESC .and. P_LIN # NIL
         @ P_LIN, P_COL   say '- '
         @ P_LIN, P_COL+2 say VET_TRANSP[W_ACHAR,2]
      else
         if lastkey()=K_ESC .and. P_LIN # NIL
            @ P_LIN, P_COL say '- '+space(10)
         end
      end
   end
   setcolor(W_OLDCOR)
return WRET

/*
-----------------------------------------------------------------------------
Procedimento : BUSCA_SENTIDO
Parametros   : nenhum
Retorno      : nenhum
Objetivo     :
-----------------------------------------------------------------------------
*/
function busca_sentido( P_COD, P_LIN, P_COL )
   local WRET:= .F.
   local VET_SENTIDO := { { "R", " Residencia -> Trabalho   " } ,;
                          { "T", " Trabalho   -> Residencia " } }
   private W_SCR := savescreen(10,20,16,53), W_OLDCOR := setcolor()

   W_ACHAR := ascan( VET_SENTIDO,{|Busca| Busca[1] == P_COD} )

   if W_ACHAR = 0

      setcolor(W_CORPERG)
      @ 10,20 say 'ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿'
      @ 11,20 say '³           Sentido             ³'
      @ 12,20 say 'ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´'
      @ 13,20 say '³  R - Residencia -> Trabalho   ³'
      @ 14,20 say '³  T - Trabalho   -> Residencia ³'
      @ 15,20 say 'ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ'
      sombra(10,20,15,52)
      menswait("Tecle <ENTER>.")
      restscreen(10,20,16,53,W_SCR)
      WRET := .F.
   else
      WRET := .T.
      if lastkey() # K_ESC .and. P_LIN # NIL
         @ P_LIN, P_COL   say '- '
         @ P_LIN, P_COL+2 say VET_SENTIDO[W_ACHAR,2]
      else
         if lastkey()=K_ESC .and. P_LIN # NIL
            @ P_LIN, P_COL say '- '+space(10)
         end
      end
   end
   setcolor(W_OLDCOR)
return WRET

/*
-----------------------------------------------------------------------------
Procedimento : TT_CGCCPF
Parametros   : nenhum
Retorno      : nenhum
Objetivo     :
-----------------------------------------------------------------------------
*/
function TT_CGCCPF( NUMERO )
   local WRET := .F.
   private TAMNUM := len( NUMAUX := alltrim(NUMERO) )

   if empty( NUMERO )
      mensbeep("Nao e permitido CGC em branco. <ENTER> ", "NOBEEP")
      WRET := .F.
   else
      if TAMNUM = 14
         if val_cgc( NUMAUX )
            WRET := .T.
         else
            menstime("C.G.C. Invalido !", 1)
            WRET := .F.
         end
      else
         if TAMNUM = 11
            if val_cpf( NUMAUX )
               WRET := .T.
            else
               menstime("C.P.F. Invalido !", 1)
               WRET := .F.
            end
         else
            mensbeep("Numero nao Corresponde a CGC ou CPF. <ENTER>")
            WRET := .F.
         end
      end
   end

return WRET

/*
-----------------------------------------------------------------------------
Procedimento : TT_CGCII
Parametros   : nenhum
Retorno      : nenhum
Objetivo     :
-----------------------------------------------------------------------------
*/
function tt_cgcii( X_CGC )
   local WRET := .T.

   if empty( X_CGC )
      m_tabelas()
   end

   if ! testa_cgc( X_CGC )
      WRET := .F.
   else
      EMPRESA->( dbsetorder(2) )
      EMPRESA->( dbseek(X_CGC) )
      if EMPRESA->( ! found() )
        mensbeep("Empresa nao cadastrada. <ENTER>")
        WRET := .F.
      else
        // Busca quantidade de RODOVIARIOs para gerar novo numero
        // X_QTDFUN := EMPRESA->QTDFUN

        X_CGC            := EMPRESA->CGC
        X_COD_EMPRE := EMPRESA->COD_EMPRE
      end
   end

return WRET

/*
Procedimento : LIMPA_BUT
Parametros   :
Retorno      :
Objetivo     :
*/
procedure LIMPA_BUT()

setcolor(W_COREDIT)
@ 17,04 clear to 20,76

return
/*
Procedimento : CRIA_BUT
Parametros   :
Retorno      :
Objetivo     :
*/
procedure cria_but( LIN, COL, BOTAO, HOTLIN, HOTCOL, HOTKEY )
   local W_OLDCUR := setcursor(), W_OLDCOR := setcolor(), COLFIM

   setcursor(0)
   COLFIM := COL + len( BOTAO )
   setcolor(W_BOTOES)
   @ LIN,COL say BOTAO
   meiasombra( LIN, COL, LIN, COLFIM-1 )
   setcolor(W_FIRSTLET)
   @ HOTLIN,HOTCOL say HOTKEY
   setcursor( W_OLDCUR )
   setcolor( W_OLDCOR )
return

/*
Procedimento : PUSH_BUT
Parametros   :
Retorno      :
Objetivo     :
*/
procedure push_but( LIN, COL, BOTAO )
   local FIRSTL := left( alltrim(BOTAO), 1 ), COLFIM, TAMBOT
   local W_OLDCUR := setcursor(), W_OLDCOR := setcolor()

   setcursor(0)
   TAMBOT := len( BOTAO )

   COLFIM := COL + TAMBOT

   setcolor(W_COREDIT)
   @ LIN,  COL   say space( TAMBOT+1 )
   @ LIN+1,COL   say space( TAMBOT+1 )

   setcolor(W_BOTOES)
   @ LIN+1,COL+1 say BOTAO
   inkey(0.1)

   setcolor(W_COREDIT)
   @ LIN,  COL   say space( TAMBOT+1 )
   @ LIN+1,COL   say space( TAMBOT+1 )

   setcolor(W_PUSHBOT)
   @ LIN,COL say BOTAO
   meiasombra(LIN,COL,LIN,COLFIM-1)

   setcursor(W_OLDCUR)
   setcolor( W_OLDCOR )
return

/*
Procedimento : GRAVA
Parametros   :
Retorno      :
Objetivo     :
*/
function GRAVA( P_ARQ, P_DATA, P_HORA, P_TITULO, P_PADRAO )

IMPRESSAO->( dbappend() )
IMPRESSAO->TITULO    := P_TITULO
IMPRESSAO->DTEMISSAO := P_DATA
IMPRESSAO->HREMISSAO := P_HORA
IMPRESSAO->STATUS    := " "
IMPRESSAO->ARQPRN    := P_ARQ
IMPRESSAO->PADRAO    := P_PADRAO
return .T.

/*
Procedimento : AT_QTDFUN
Parametros   :
Retorno      :
Objetivo     :
*/
function AT_QTDFUN()

abrir("EMPRESA")
abrir("FUNCIONARIO")

EMPRESA->( dbgotop())
mensagem("Aguarde...atualizando total de funcionarios...")
while EMPRESA->( ! eof() )

   FUNCIONARIO->( dbseek( EMPRESA->CODEMP ) )
   W_TOTFUN := 0
   while FUNCIONARIO->CODEMP=EMPRESA->CODEMP .and. FUNCIONARIO->( ! eof() )

      W_TOTFUN++
      FUNCIONARIO->( dbskip() )
   end
   while EMPRESA->( ! rlock() ); end
   EMPRESA->QTDFUN := W_TOTFUN
   EMPRESA->( dbunlock() )
   EMPRESA->( dbskip() )
end
mensagem("")
dbcloseall()

return .T.

/*
Procedimento : INDEXAR
Parametros   :
Retorno      :
Objetivo     :
*/
procedure Indexar( P_ARQ )

dbcloseall()
set exclusive on

do case
   case P_ARQ = "EMPRESA"
      Use ( W_DIR + "EMPRESAS.DBF" ) Alias EMPRESA NEW
      if ! neterr()
         pack
         SPV_sharq( "EMPRESA1" )
         Index on CODEMP               to (W_DIR+"EMPRESA1.NTX") eval showbar()
         SPV_sharq( "EMPRESA2" )
         Index on RAZSOC               to (W_DIR+"EMPRESA2.NTX") eval showbar()
      end

   case P_ARQ = "FUNCIONARIO"
      Use ( W_DIR + "FUNCIONA.DBF" ) Alias FUNCIONARIO NEW
      if ! neterr()
         pack
         SPV_sharq( "FUNCION1" )
         Index on CODEMP+MATRICULA     to (W_DIR+"FUNCION1.NTX") eval showbar()
         SPV_sharq( "FUNCION2" )
         Index on NOME                 to (W_DIR+"FUNCION2.NTX") eval showbar()
         SPV_sharq( "FUNCION3" )
         Index on CODEMP+NOME          to (W_DIR+"FUNCION3.NTX") eval showbar()
         SPV_sharq( "FUNCION4" )
         Index on CODEMP+SETOR+NOME    to (W_DIR+"FUNCION4.NTX") eval showbar()
      end

   case P_ARQ = "TARIFA"
      Use ( W_DIR + "TARIFA.DBF" ) Alias TARIFA NEW
      if ! neterr()
         pack
         SPV_sharq( "TARIFA1" )
         Index on CODTAR               to (W_DIR+"TARIFA1.NTX") eval showbar()
         SPV_sharq( "TARIFA2" )
         Index on str(VALTAR,9,2)      to (W_DIR+"TARIFA2.NTX") eval showbar()
      end

   case P_ARQ = "PEDIDO"
      Use ( W_DIR + "PEDIDO.DBF" ) Alias PEDIDO NEW
      if ! neterr()
         pack
         SPV_sharq( "PEDIDO1" )
         Index on CODEMP+MATRICULA        to (W_DIR+"PEDIDO1.NTX") eval showbar()
         SPV_sharq( "PEDIDO2" )
         Index on MATRICULA+CODEMP        to (W_DIR+"PEDIDO2.NTX") eval showbar()
      end

   case P_ARQ = "PEDITEM"
      Use ( W_DIR + "PEDITENS.DBF" ) Alias PEDITEM NEW
      if ! neterr()
         pack
         SPV_sharq( "PEDITEM1" )
         Index on CODEMP+MATRICULA+MODO   to (W_DIR+"PEDITEM1.NTX") eval showbar()
         SPV_sharq( "PEDITEM2" )
         Index on MATRICULA+CODEMP        to (W_DIR+"PEDITEM2.NTX") eval showbar()
         SPV_sharq( "PEDITEM3" )
         Index on CODEMP+MATRICULA+TRANSP to (W_DIR+"PEDITEM3.NTX") eval showbar()
      end

   case P_ARQ = "IMPRESSAO"
      Use ( W_DIR + "RELATARQ.DBF" ) Alias IMPRESSAO NEW
      if ! neterr()
         pack
         SPV_sharq( "RELATAR1" )
         Index on descend(dtos(DTEMISSAO)+HREMISSAO) to (W_DIR+"RELATAR1.NTX") eval showbar()
      end

   case P_ARQ = "CONFERE"
      Use ( W_DIR + "CONFERE.DBF" ) Alias CONFERE NEW
      if ! neterr()
         pack
         SPV_sharq( "CONFERE1" )
         Index on CGC+CODEMP  to (W_DIR+"CONFERE1.NTX") eval showbar()
      end

endcase
dbcloseall()
Set exclusive off
return

/*
Procedimento : ABRIR_INDICES
Parametros   :
Retorno      :
Objetivo     :
*/
procedure Abrir_indices( P_ARQ )

do case
   case P_ARQ = "EMPRESA"
      EMPRESA->(     ordlistadd( W_DIR+"EMPRESA1.NTX" ))
      EMPRESA->(     ordlistadd( W_DIR+"EMPRESA2.NTX" ))
   case P_ARQ = "FUNCIONARIO"
      FUNCIONARIO->( ordlistadd( W_DIR+"FUNCION1.NTX" ))
      FUNCIONARIO->( ordlistadd( W_DIR+"FUNCION2.NTX" ))
      FUNCIONARIO->( ordlistadd( W_DIR+"FUNCION3.NTX" ))
      FUNCIONARIO->( ordlistadd( W_DIR+"FUNCION4.NTX" ))
   case P_ARQ = "TARIFA"
      TARIFA->(      ordlistadd( W_DIR+"TARIFA1.NTX" ))
      TARIFA->(      ordlistadd( W_DIR+"TARIFA2.NTX" ))
   case P_ARQ = "PEDIDO"
      PEDIDO->(      ordlistadd( W_DIR+"PEDIDO1.NTX" ))
      PEDIDO->(      ordlistadd( W_DIR+"PEDIDO2.NTX" ))
   case P_ARQ = "PEDITEM"
      PEDITEM->(     ordlistadd( W_DIR+"PEDITEM1.NTX" ))
      PEDITEM->(     ordlistadd( W_DIR+"PEDITEM2.NTX" ))
      PEDITEM->(     ordlistadd( W_DIR+"PEDITEM3.NTX" ))
   case P_ARQ = "IMPRESSAO"
      IMPRESSAO->(   ordlistadd( W_DIR+"RELATAR1.NTX" ))
   case P_ARQ = "CONFERE"
      CONFERE->(     ordlistadd( W_DIR+"CONFERE1.NTX" ))
endcase

return
