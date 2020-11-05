/*

   SCM - Sistema de Controle Metalurgico
   ESTFUNC.PRG - Modulo de Procedimentos e Funcoes

*/

#include "inkey.ch"
#include "sic.ch"
#define ATTR_CONV( FORE, BACK ) (BACK)*16+(FORE)
#define BLACK 0
#define WHITE 7
#define DK_GRAY 8
#define COL_SHADOW_ATTRIBUTE ATTR_CONV(DK_GRAY, BLACK)
#define BW_SHADOW_ATTRIBUTE  ATTR_CONV(WHITE,       BLACK)
#define LI_SEPH "ฤ"
#define LI_SEPR "อ"
#define LI_SEPV "ณ"


/*
-----------------------------------------------------------------------------
                             Procedimento get_senha
-----------------------------------------------------------------------------
*/

function get_senha( P_TAM, P_LIN, P_COL )
local WRET := space(6), W_CONTADOR := P_LIN

   @ P_LIN, P_COL say ''
   for X := P_COL to P_COL+P_TAM-1

      inkey(0)

      WRET := alltrim(WRET)+chr( lastkey() )

      @ P_LIN, X say '*'

   next
return WRET

/*
-----------------------------------------------------------------------------
Procedimento : M_TABELAS
Parametros   : nenhum
Retorno      : nenhum
Objetivo     :
-----------------------------------------------------------------------------
*/
function m_tabelas( P_COND )

   local P_OLDCOR := setcolor()
   local P_HDSEP := "หอ"
   local P_COLSEP := "-"

   local P_SCR := savescreen(,,,)
   local getlist:={}

   local P_CAMPOS    := {}
   local MASCARA     := {}
   local P_HEADER    := {}
   local TAMANHO     := {}
   local BESCAPE     := {|| .T. }
   local COR	     := W_CORWIND
   local TITULO      := ""
   local LININI      := 06
   local LINFIM      := 15
   local COLINI      := 15
   local BLOCK_DISP  := {|| .T. }
   local CAB_TITULO  := nil
   local BORDA	     := 1

   local TECLA	     := nil
   local TABELA      := nil
   local IS_TBROWSE  := .F.

   do case
      case readvar() = "X_CODBANCO"
         IS_TBROWSE  := .T.

                TITULO      := " Tabela de Bancos "
                LININI      := 05
                COLINI      := 30
                LINFIM      := 15

         aadd( P_HEADER, "Codigo"    )
         aadd( P_HEADER, "Descricao" )

         aadd( P_CAMPOS, "CODBANCO"  )
         aadd( P_CAMPOS, "DESCRICAO" )

         aadd( MASCARA  , "999"        )
         aadd( MASCARA  , "@!"         )

         aadd( TAMANHO  , 05 )
         aadd( TAMANHO  , 25 )

         select CR0100
         CR0100->( dbsetorder(1) )
         CR0100->( dbgotop() )

      case readvar() = "X_CODAGENCIA"
         IS_TBROWSE  := .T.

         TITULO      := " Tabela de Agencias "
         LININI      := 08
         COLINI      := 20
         LINFIM      := 15

         aadd( P_HEADER, "Codigo"    )
         aadd( P_HEADER, "Descricao" )

         aadd( P_CAMPOS, "CODAGENCIA"  )
         aadd( P_CAMPOS, "DESCRICAO"   )

         aadd( MASCARA  , "9999"       )
         aadd( MASCARA  , "@!"         )

         aadd( TAMANHO  , 05 )
         aadd( TAMANHO  , 25 )

         select CR0200
         CR0200->( dbsetorder(1) )
         CR0200->( dbgotop() )

      case readvar() = "X_FORMA"
      IS_TBROWSE  := .T.

      TITULO      := " Formas "
      LININI      := 07
      COLINI      := 25
      LINFIM      := 15

      aadd( P_HEADER, "Codigo"    )
      aadd( P_HEADER, "Descricao" )

      aadd( P_CAMPOS, "FORMA"     )
      aadd( P_CAMPOS, "DESCRICAO" )

      aadd( MASCARA	 , "999"        )
      aadd( MASCARA	 , "@!"         )

      aadd( TAMANHO	 , 03 )
      aadd( TAMANHO	 , 25 )

      select EST003
      EST003->( dbsetorder(1) )
      EST003->( dbgotop() )

      case readvar() = "X_BIT_INT"

	 EST003->( dbsetorder(1) )
	 EST003->( dbseek( X_FORMA ))

	 if EST003->P_MATERIAL = 2 .or. ;
	    EST003->P_MATERIAL = 3

	    IS_TBROWSE	:= .T.

	    TITULO	:= " Bitola / Espessura "
	    LININI	:= 04
	    COLINI	:= 10
	    LINFIM	:= 20
	    BESCAPE	:= {|| FORMA = X_FORMA .and.;
			       TIPO  = X_TIPO  .and.;
			       ESTADO= X_ESTADO }

	    if X_FORMA = '007'
	       aadd( P_HEADER, "BIT EXT"   )
	       aadd( P_HEADER, "BIT INT"   )
	       aadd( P_HEADER, "Kg Total" )

	       aadd( P_CAMPOS, "BIT_MM"   )
	       aadd( P_CAMPOS, "ESP_MM"   )
	       aadd( P_CAMPOS, "QTD_KGT"  )

	       aadd( MASCARA   , "99999.999"    )
	       aadd( MASCARA   , "99999.999"    )
	       aadd( MASCARA   , "999999999.99" )

	       aadd( TAMANHO   , 10 )
	       aadd( TAMANHO   , 10 )
	       aadd( TAMANHO   , 15 )

	    else

	       aadd( P_HEADER, "Bit"      )
	       aadd( P_HEADER, " "        )
	       aadd( P_HEADER, " "        )
	       aadd( P_HEADER, "MM"       )
	       aadd( P_HEADER, "Esp"      )
	       aadd( P_HEADER, " "        )
	       aadd( P_HEADER, " "        )
	       aadd( P_HEADER, "MM"       )
	       aadd( P_HEADER, "Kg Total" )

	       aadd( P_CAMPOS, "BIT_INT"  )
	       aadd( P_CAMPOS, "BIT_FN"   )
	       aadd( P_CAMPOS, "BIT_FD"   )
	       aadd( P_CAMPOS, "BIT_MM"   )
	       aadd( P_CAMPOS, "ESP_INT"  )
	       aadd( P_CAMPOS, "ESP_FN"   )
	       aadd( P_CAMPOS, "ESP_FD"   )
	       aadd( P_CAMPOS, "ESP_MM"   )
	       aadd( P_CAMPOS, "QTD_KGT"  )

	       aadd( MASCARA   , "999"          )
	       aadd( MASCARA   , "999"          )
	       aadd( MASCARA   , "999"          )
	       aadd( MASCARA   , "99999.999"    )
	       aadd( MASCARA   , "999"          )
	       aadd( MASCARA   , "999"          )
	       aadd( MASCARA   , "999"          )
	       aadd( MASCARA   , "99999.999"    )
	       aadd( MASCARA   , "999999999.99" )

	       aadd( TAMANHO   , 03 )
	       aadd( TAMANHO   , 03 )
               aadd( TAMANHO   , 03 )
	       aadd( TAMANHO   , 10 )
	       aadd( TAMANHO   , 03 )
	       aadd( TAMANHO   , 03 )
	       aadd( TAMANHO   , 03 )
	       aadd( TAMANHO   , 10 )
	       aadd( TAMANHO   , 15 )
	    end
	 else

	    IS_TBROWSE	:= .T.

	    TITULO	:= " Bitola / Espessura "
	    LININI	:= 04
	    COLINI	:= 10
	    LINFIM	:= 20
	    BESCAPE	:= {|| FORMA = X_FORMA .and.;
			       TIPO  = X_TIPO  .and.;
			       ESTADO= X_ESTADO }

	    aadd( P_HEADER, "Int"      )
	    aadd( P_HEADER, "Pol"      )
	    aadd( P_HEADER, " "        )
	    aadd( P_HEADER, "MM"       )
	    aadd( P_HEADER, "Kg Total" )

	    aadd( P_CAMPOS, "BIT_INT"  )
	    aadd( P_CAMPOS, "BIT_FN"   )
	    aadd( P_CAMPOS, "BIT_FD"   )
	    aadd( P_CAMPOS, "BIT_MM"   )
	    aadd( P_CAMPOS, "QTD_KGT"  )

	    aadd( MASCARA   , "999"          )
	    aadd( MASCARA   , "999"          )
	    aadd( MASCARA   , "999"          )
	    aadd( MASCARA   , "99999.999"    )
	    aadd( MASCARA   , "999999999.99" )

	    aadd( TAMANHO   , 03 )
	    aadd( TAMANHO   , 03 )
	    aadd( TAMANHO   , 03 )
	    aadd( TAMANHO   , 10 )
	    aadd( TAMANHO   , 15 )
	 end

	 select EST007
	 EST007->( dbgotop() )
	 EST007->( dbsetorder(3) )
	 EST007->( dbseek(X_FORMA+X_TIPO+X_ESTADO) )


      case readvar() = "N" // Nao editando => "X_ESP_INT"
	 EST003->( dbsetorder(1) )
	 EST003->( dbseek( X_FORMA ))

	 if ! ( EST003->P_MATERIAL = 2 .or. ;
		EST003->P_MATERIAL = 3 )
	    IS_TBROWSE	:= .T.

	    TITULO	:= " Largura / Bitola "
	    LININI	:= 06
	    COLINI	:= 17
	    LINFIM	:= 24
	    BESCAPE	:= {|| FORMA  = X_FORMA   .and.;
			       TIPO   = X_TIPO	  .and.;
			       ESTADO = X_ESTADO  .and.;
			       BIT_INT= X_BIT_INT .and.;
			       BIT_FN = X_BIT_FN  .and.;
			       BIT_FD = X_BIT_FD  .and.;
			       BIT_MM = X_BIT_MM }

	    aadd( P_HEADER, "Polegada" )
	    aadd( P_HEADER, ""         )
	    aadd( P_HEADER, "MM"       )
	    aadd( P_HEADER, "Kg Total" )

	    aadd( P_CAMPOS, "ESP_FN"   )
	    aadd( P_CAMPOS, "ESP_FD"   )
	    aadd( P_CAMPOS, "ESP_MM"   )
	    aadd( P_CAMPOS, "QTD_KGT"  )

	    aadd( MASCARA   , "999"          )
	    aadd( MASCARA   , "999"          )
	    aadd( MASCARA   , "99999.999"    )
	    aadd( MASCARA   , "999999999.99" )

	    aadd( TAMANHO   , 03 )
	    aadd( TAMANHO   , 03 )
	    aadd( TAMANHO   , 06 )
	    aadd( TAMANHO   , 25 )

	    select EST007
	    EST007->( dbsetorder(2) )
	    EST007->( dbgotop() )
	    EST007->( dbseek( X_FORMA+X_TIPO+X_ESTADO+X_BIT_INT+X_BIT_FN+X_BIT_FD+X_BIT_MM ))
	 end
      case readvar() == "X_TIPO"
	 IS_TBROWSE  := .T.

	 TITULO      := " Tipo de Material "
	 LININI      := 05
	 COLINI      := 15
	 LINFIM      := 17
	 BESCAPE     := {|| FORMA = X_FORMA }

	 aadd( P_HEADER, "Tipo"      )
	 aadd( P_HEADER, "Descricao" )
	 aadd( P_HEADER, "Cor"       )

	 aadd( P_CAMPOS, "TIPO"      )
	 aadd( P_CAMPOS, "DESCRICAO" )
	 aadd( P_CAMPOS, "COR"       )

	 aadd( MASCARA	 , "99999"      )
	 aadd( MASCARA	 , "@!"         )
	 aadd( MASCARA	 , "@!"         )

	 aadd( TAMANHO	 , 06 )
	 aadd( TAMANHO	 , 25 )
	 aadd( TAMANHO	 , 10 )

	 select EST004
	 EST004->( dbgotop() )
	 EST004->( dbsetorder(1) )
	 EST004->( dbseek(X_FORMA) )

      case readvar() = "X_ALMOXARI"

	 P_SCR := savescreen(05,15,17,67)
	 @ 05, 15 say "ีออออออออออออออออ Almoxarifado อออออออออออออออออออธ"
	 @ 06, 15 say "ณ                                                 ณ"
	 @ 07, 15 say "ฦ                                                 ต"
	 @ 08, 15 say "ณ                                                 ณ"
	 @ 09, 15 say "ณ                                                 ณ"
	 @ 10, 15 say "ณ                                                 ณ"
	 @ 11, 15 say "ณ                                                 ณ"
	 @ 12, 15 say "ณ                                                 ณ"
	 @ 13, 15 say "ณ                                                 ณ"
	 @ 14, 15 say "ณ                                                 ณ"
	 @ 15, 15 say "ณ                                                 ณ"
	 @ 16, 15 say "ิอออออออออออออออออออออออออออออออออออออออออออออออออพ"
	 sombra(05,15,16,65)

	 P_HEADER := {"  Cod              Descricao  "}

	 P_CAMPOS := {" ' '+EST001->ALMOXARI+'  '         "+;
		      "    +EST001->DESCRICAO+' '        "}

	 EST001->( dbgotop() )
	 EST001->( dbedit(06,16,15,64,P_CAMPOS,,, P_HEADER, P_HDSEP, P_COLSEP))

	 restscreen(05,15,17,67,P_SCR)
	 if lastkey() != 27
	    X_ALMOXARI := EST001->ALMOXARI
	 end

      case readvar() = "X_CODCLI" .or. P_COND == "X_CODCLI"

	 P_SCR1 := savescreen(06,24,17,74)

	 @ 06, 24 say "ีออออออออออออออออออออ Cliente อออออออออออออออออออธ"
	 @ 07, 24 say "ณ                                                ณ"
	 @ 08, 24 say "ฦ                                                ต"
	 @ 09, 24 say "ณ                                                ณ"
	 @ 10, 24 say "ณ                                                ณ"
	 @ 11, 24 say "ณ                                                ณ"
	 @ 12, 24 say "ณ                                                ณ"
	 @ 13, 24 say "ณ                                                ณ"
	 @ 14, 24 say "ณ                                                ณ"
	 @ 15, 24 say "ณ                                                ณ"
	 @ 16, 24 say "ิออออออออออออออออออออออออออออออออออออออออออออออออพ"
	 sombra(06,24,16,73)

	 P_HEADER :=  {" Cod  Razao Social           " }

	 P_CAMPOS :=  { "' '+VEN001->CODCLI+'  '+VEN001->RAZAO+' '"}
	 VEN001->( dbsetorder(2) )
	 VEN001->( dbgotop() )

	 keyboard chr(K_F5)

	 VEN001->( dbedit(07,25,15,72,P_CAMPOS,"FCLI_BUSCA",,P_HEADER, P_HDSEP, P_COLSEP) )
	 restscreen( 06, 24, 17, 74, P_SCR1 )

	 if lastkey() != 27
	    X_CODCLI := VEN001->CODCLI
	 end
	 VEN001->( dbsetorder(1) )

      case readvar() = "X_CODVEN"

	 P_SCR1 := savescreen(06,24,17,74)

	 @ 06, 24 say "ีอออออออออออออออออออ Vendedor อออออออออออออออออออธ"
	 @ 07, 24 say "ณ                                                ณ"
	 @ 08, 24 say "ฦ                                                ต"
	 @ 09, 24 say "ณ                                                ณ"
	 @ 10, 24 say "ณ                                                ณ"
	 @ 11, 24 say "ณ                                                ณ"
	 @ 12, 24 say "ณ                                                ณ"
	 @ 13, 24 say "ณ                                                ณ"
	 @ 14, 24 say "ณ                                                ณ"
	 @ 15, 24 say "ณ                                                ณ"
	 @ 16, 24 say "ิออออออออออออออออออออออออออออออออออออออออออออออออพ"
	 sombra(06,24,16,73)

	 P_HEADER :=  {" Cod  Nome " }

	 P_CAMPOS :=  { "' '+VEN002->CODVEN+'  '+VEN002->NOME+' '"}
	 VEN002->( dbgotop() )
	 VEN002->( dbedit(07,25,15,72,P_CAMPOS,,,P_HEADER, P_HDSEP, P_COLSEP) )

	 restscreen( 06, 24, 17, 74, P_SCR1 )

	 if lastkey() != 27
	    X_CODVEN := VEN002->CODVEN
	 end

      case readvar() = "X_FORNECEDOR" .or. P_COND = "X_FORNECEDOR"

	 P_SCR1 := savescreen(06,24,17,55)

	 @ 06, 24 say "ีออออออออ Fornecedor ออออออออธ"
	 @ 07, 24 say "ณ                            ณ"
	 @ 08, 24 say "ฦ                            ต"
	 @ 09, 24 say "ณ                            ณ"
	 @ 10, 24 say "ณ                            ณ"
	 @ 11, 24 say "ณ                            ณ"
	 @ 12, 24 say "ณ                            ณ"
	 @ 13, 24 say "ณ                            ณ"
	 @ 14, 24 say "ณ                            ณ"
	 @ 15, 24 say "ณ                            ณ"
	 @ 16, 24 say "ิออออออออออออออออออออออออออออพ"
	 sombra(06,24,16,53)

	 P_HEADER :=  {" Cod  Descricao              " }
	 P_CAMPOS :=  { "' '+EST002->FORNECEDOR+'  '+EST002->FGUERRA+' '"}
	 EST002->( dbgotop() )
	 EST002->( dbedit(07,25,15,52,P_CAMPOS,,,P_HEADER, P_HDSEP, P_COLSEP) )

	 restscreen( 06, 24, 17, 55, P_SCR1 )

	 if lastkey() != 27
	    X_FORNECEDOR := EST002->FORNECEDOR
	    @ 04,21 say X_FORNECEDOR
	 end

      case readvar() = "X_LOTE"

	 P_SCR := savescreen(05,10,21,72)
	 @ 05, 10 say "ีออออออออออออออออออออออออ Lote ออออออออออออออออออออออออออออธ"
	 @ 06, 10 say "ณ                                                          ณ"
	 @ 07, 10 say "ฦ                                                          ต"
	 @ 08, 10 say "ณ                                                          ณ"
	 @ 09, 10 say "ณ                                                          ณ"
	 @ 10, 10 say "ณ                                                          ณ"
	 @ 11, 10 say "ณ                                                          ณ"
	 @ 12, 10 say "ณ                                                          ณ"
	 @ 13, 10 say "ณ                                                          ณ"
	 @ 14, 10 say "ณ                                                          ณ"
	 @ 15, 10 say "ณ                                                          ณ"
	 @ 16, 10 say "ณ                                                          ณ"
	 @ 17, 10 say "ณ                                                          ณ"
	 @ 18, 10 say "ณ                                                          ณ"
	 @ 19, 10 say "ิออออออออออออออออออออออออออออออออออออออออออออออออออออออออออพ"

*			 Lote	  Data	 Qtd.Pecas	  Qtd.Kg      Valor Total
*			 xxxxx	xxxxxxxx   xxxxxxx  xxxxxxxxxxxx  xxxxxxxxxxxxxxx

	 sombra(05,10,19,70)

	 P_HEADER := {" Lote     Data   Qtd.Pecas        Qtd.Kg      Valor Total "}

	 P_CAMPOS := {" ' '+EST009->LOTE      +'  '                                  "+;
		      "    +DTOC(EST009->DTFISCAL)   +'   ' +STR(EST009->QTD_PECA,7)+'  '"+;
		      "    +STR(EST009->QTD_KG,12,2) +'  '+STR(EST009->VALTOTAL,15,2) +' '"}

	 EST009->( dbgotop() )
	 EST009->( dbedit(06,11,18,67,P_CAMPOS,,, P_HEADER, P_HDSEP, P_COLSEP))

	 restscreen(05,10,21,72,P_SCR)
	 if lastkey() = 13
	    X_LOTE     := EST009->LOTE
	    X_QTD_PECA := EST009->QTD_PECA
	 end

      case readvar() = "X_TIPOMOVI"

	 P_SCR := savescreen(05,15,17,67)
	 @ 05, 15 say "ีอออออออออออออ Tipo de Movimento อออออออออออออออออธ"
	 @ 06, 15 say "ณ                                                 ณ"
	 @ 07, 15 say "ฦ                                                 ต"
	 @ 08, 15 say "ณ                                                 ณ"
	 @ 09, 15 say "ณ                                                 ณ"
	 @ 10, 15 say "ณ                                                 ณ"
	 @ 11, 15 say "ณ                                                 ณ"
	 @ 12, 15 say "ณ                                                 ณ"
	 @ 13, 15 say "ณ                                                 ณ"
	 @ 14, 15 say "ณ                                                 ณ"
	 @ 15, 15 say "ณ                                                 ณ"
	 @ 16, 15 say "ิอออออออออออออออออออออออออออออออออออออออออออออออออพ"
	 sombra(05,15,16,65)

	 if X_OPERACAO == "E"
	    EST011->( dbsetfilter( {|| EST011->ES = "E" } ))
	 elseif X_OPERACAO == "S"
	    EST011->( dbsetfilter( {|| EST011->ES = "S" } ))
	 endif

	 P_HEADER := {"  Cod              Descricao  "}

	 P_CAMPOS := {" ' '+EST011->TIPOMOVI+'  '         "+;
		      "    +EST011->DESCRICAO+' '        "}

	 EST011->( dbgotop() )
	 EST011->( dbedit(06,16,15,64,P_CAMPOS,,, P_HEADER, P_HDSEP, P_COLSEP))

	 restscreen(05,15,17,67,P_SCR)
	 if lastkey() != 27
	    X_TIPOMOVI := EST011->TIPOMOVI
	 end

      case readvar() = "X_PEDIDO"

	 P_SCR := savescreen(05,10,21,72)
	 @ 05, 10 say "ีออออออออออออออออออออออออ Pedidos ออออออออออออออออออออออออออธ"
	 @ 06, 10 say "ณ                                                           ณ"
	 @ 07, 10 say "ฦ                                                           ต"
	 @ 08, 10 say "ณ                                                           ณ"
	 @ 09, 10 say "ณ                                                           ณ"
	 @ 10, 10 say "ณ                                                           ณ"
	 @ 11, 10 say "ณ                                                           ณ"
	 @ 12, 10 say "ณ                                                           ณ"
	 @ 13, 10 say "ณ                                                           ณ"
	 @ 14, 10 say "ณ                                                           ณ"
	 @ 15, 10 say "ณ                                                           ณ"
	 @ 16, 10 say "ณ                                                           ณ"
	 @ 17, 10 say "ณ                                                           ณ"
	 @ 18, 10 say "ณ                                                           ณ"
	 @ 19, 10 say "ิอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออพ"

*			 Pedido    Forma  Tipo Est  Bitola Espessura	    Qtd.Kg
*			 xxxxx	->   xxx xxxxx	x xxxxxxxx  xxxxxxxx xxxxxxxxxxxxx

	 sombra(05,10,19,70)

	 P_HEADER := {" Pedido    Forma  Tipo Est  Bitola Espessura        Qtd.Kg "}

	 P_CAMPOS := {" ' '+EST006->PEDIDO    +'  ->   '                               "+;
		      "    +EST006->FORMA     +' '    +EST006->TIPO      +'  '         "+;
		      "    +EST006->ESTADO    +' '    +STR(EST006->BIT_MM,8,3) +'  '"+;
		      "    +STR(EST006->ESP_MM,8,3)+' '+STR(EST006->QTD_KG,13,2)  +' '"}

	 EST006->( dbgotop() )
	 EST006->( dbedit(06,11,18,69,P_CAMPOS,,, P_HEADER, P_HDSEP, P_COLSEP))

	 restscreen(05,10,21,72,P_SCR)
	 if lastkey() = 13
	    X_PEDIDO  := EST006->PEDIDO
	    X_FORMA   := EST006->FORMA
	    X_TIPO    := EST006->TIPO
	    X_ESTADO  := EST006->ESTADO
	    X_BIT_MM  := EST006->BIT_MM
	    X_ESP_MM  := EST006->ESP_MM
	    DIGITA_OK := .F.
	 end

      case readvar() = "X_PEDVEN"

	 P_SCR := savescreen(05,10,21,72)
	 @ 05, 10 say "ีออออออออออออออออออ Pedidos de Venda อออออออออออออออออออออออธ"
	 @ 06, 10 say "ณ                                                           ณ"
	 @ 07, 10 say "ฦ                                                           ต"
	 @ 08, 10 say "ณ                                                           ณ"
	 @ 09, 10 say "ณ                                                           ณ"
	 @ 10, 10 say "ณ                                                           ณ"
	 @ 11, 10 say "ณ                                                           ณ"
	 @ 12, 10 say "ณ                                                           ณ"
	 @ 13, 10 say "ณ                                                           ณ"
	 @ 14, 10 say "ณ                                                           ณ"
	 @ 15, 10 say "ณ                                                           ณ"
	 @ 16, 10 say "ณ                                                           ณ"
	 @ 17, 10 say "ณ                                                           ณ"
	 @ 18, 10 say "ณ                                                           ณ"
	 @ 19, 10 say "ิอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออพ"

	 sombra(05,10,19,70)

	 P_HEADER := {" Pedido      Data      Cliente     Comprador"}

	 P_CAMPOS := {" ' '+VEN005->PEDVEN +space(4)+dtoc(VEN005->DT_PEDIDO)+"+;
		      " space(4)+VEN005->CODCLI +space(7)+VEN005->COMPRADOR  " }

	 VEN005->( dbgotop() )
	 VEN005->( dbedit(06,11,18,69,P_CAMPOS,,, P_HEADER, P_HDSEP, P_COLSEP))

	 restscreen(05,10,21,72,P_SCR)
	 if lastkey() = 13
	    X_PEDVEN  := VEN005->PEDVEN
	 end

      case readvar() = "X_MEDIDA"

	 P_SCR := savescreen(05,15,17,67)
	 @ 06, 15 say "ีออออออออออออออ   Medida Padrao   อออออออออออออออธ"
	 @ 07, 15 say "ณ                                                ณ"
	 @ 07, 15 say "ฦ                                                ต"
	 @ 08, 15 say "ณ                                                ณ"
	 @ 09, 15 say "ณ                                                ณ"
	 @ 10, 15 say "ณ                                                ณ"
	 @ 11, 15 say "ณ                                                ณ"
	 @ 12, 15 say "ณ                                                ณ"
	 @ 13, 15 say "ณ                                                ณ"
	 @ 14, 15 say "ณ                                                ณ"
	 @ 15, 15 say "ณ                                                ณ"
	 @ 16, 15 say "ิออออออออออออออออออออออออออออออออออออออออออออออออพ"

	 sombra(05,15,16,64)

	 P_HEADER := {"  Medida    Minimo     Maximo        Preco "}

	 P_CAMPOS := {" ' '+ VEN015->MEDIDA  +' '+Str(VEN015->MINIMO,7)  +' '+"+;
		      " str(VEN015->MAXIMO,7)+' '+str(VEN015->PRECO,12,2)+'  '"}

	 VEN015->( dbgotop() )
	 VEN015->( dbedit(06,16,15,64,P_CAMPOS,,, P_HEADER, P_HDSEP, P_COLSEP))

	 restscreen(05,15,17,67,P_SCR)
	 if lastkey() != 27
	    X_MEDIDA := VEN015->MEDIDA
	 end

   endcase

   // ----------------
   // ---- tbrowse
   // ----------------

   if IS_TBROWSE

      TABELA := tabelanew( P_CAMPOS	  , ;
			   MASCARA	  , ;
			   P_HEADER	  , ;
			   TAMANHO	  , ;
			   BESCAPE	  , ;
			   COR		  , ;
			   TITULO	  , ;
			   LININI	  , ;
			   LINFIM	  , ;
			   COLINI	  , ;
			   BLOCK_DISP	  , ;
			   CAB_TITULO	  , ;
			   BORDA	    ;
			 )

      CONTINUA := .T.
      do while CONTINUA .and. ( (TEC:=tabmov(TABELA) ) != K_ESC )
	 if TEC == 13 ; exit ; end
      enddo
      // ----------------
      // ---- fim tbrowse
      // ----------------

      // ----------------
      // ---- Retorno ...
      // ----------------

      if lastkey() = 13
	 do case
            case readvar() = "X_CODBANCO"
               X_CODBANCO  := CR0100->CODBANCO
               X_DESCRICAO := CR0100->DESCRICAO
               CR0100->( dbsetorder(1) )

            case readvar() = "X_CODAGENCIA"
               X_CODAGENCIA  := CR0200->CODAGENCIA
               X_DESCRICAO   := CR0200->DESCRICAO
               CR0200->( dbsetorder(1) )

            case readvar() = "X_FORMA"
	       X_FORMA	   := EST003->FORMA
	       X_DESCRICAO := EST003->DESCRICAO
	       EST003->( dbsetorder(1) )

	    case readvar() = "X_BIT_INT"
	       X_BIT_INT := EST007->BIT_INT
	       X_BIT_FN  := EST007->BIT_FN
	       X_BIT_FD  := EST007->BIT_FD
	       X_BIT_MM  := EST007->BIT_MM
	       X_ESP_INT := EST007->ESP_INT
	       X_ESP_FN  := EST007->ESP_FN
	       X_ESP_FD  := EST007->ESP_FD
	       X_ESP_MM  := EST007->ESP_MM
	       EST007->( dbsetorder(1) )

	    case readvar() = "X_ESP_INT"
	       X_ESP_INT := EST007->ESP_INT
	       X_ESP_FN  := EST007->ESP_FN
	       X_ESP_FD  := EST007->ESP_FD
	       X_ESP_MM  := EST007->ESP_MM
	       EST007->( dbsetorder(1) )

	    case readvar() = "X_TIPO"
	       X_TIPO	 := EST004->TIPO
	       X_ESTADO  := EST004->ESTADO
	       EST004->( dbsetorder(1) )

	 endcase
      end
      restscreen(,,,,P_SCR)
   end

   setcolor( P_OLDCOR )
return NIL

/*
-----------------------------------------------------------------------------

                          GET_MAINKEY

-----------------------------------------------------------------------------
*/
procedure GET_MAINKEY( POSICAO )

   if POSICAO = NIL
      POSICAO := 1
   end

   if POSICAO = 1

      @ 05,16 get X_FORMA    picture "@!"     valid tes_formato()
      @ 06,16 get X_TIPO     picture "@!"     valid tes_tipo()
      @ 07,16 get X_ESTADO   picture "@!"     valid tes_estado()
      @ 08,16 get X_BIT_INT  picture "99"     valid tes_bitola() when T_BIT
      @ 08,19 get X_BIT_FN   picture "99"     when T_BIT
      @ 08,22 get X_BIT_FD   picture "99"     valid calc_bit() when T_BIT
      @ 08,25 get X_BIT_MM   picture "99999.999"   when ( val(X_BIT_INT) + ;
			     val(X_BIT_FN)+val(X_BIT_FD) = 0 ) .and. T_BIT

      @ 09,16 get X_ESP_INT  picture "99"      valid tes_espessura() when T_LARG
      @ 09,19 get X_ESP_FN   picture "99"      when T_LARG
      @ 09,22 get X_ESP_FD   picture "99"      valid calc_esp() when T_LARG
      @ 09,25 get X_ESP_MM   picture "99999.999" when ( val(X_ESP_INT)+;
			     val(X_ESP_FN)+val(X_ESP_FD) = 0 ) .and. ( T_LARG )

   else

      @ 09,16 get X_FORMA    picture "@!"     valid tes_formato(2)
      @ 10,16 get X_TIPO     picture "@!"     valid tes_tipo(2)
      @ 11,16 get X_ESTADO   picture "@!"     valid tes_estado(2)
      @ 12,16 get X_BIT_INT  picture "99"     valid tes_bitola(2) when T_BIT
      @ 12,19 get X_BIT_FN   picture "99"     when T_BIT
      @ 12,22 get X_BIT_FD   picture "99"     valid calc_bit(2) when T_BIT
      @ 12,25 get X_BIT_MM   picture "99999.999"   when ( val(X_BIT_INT) + ;
			     val(X_BIT_FN)+val(X_BIT_FD) = 0 ) .and. T_BIT

      @ 13,16 get X_ESP_INT  picture "99"      valid tes_espessura(2) when T_LARG
      @ 13,19 get X_ESP_FN   picture "99"      when T_LARG
      @ 13,22 get X_ESP_FD   picture "99"      valid calc_esp(2) when T_LARG
      @ 13,25 get X_ESP_MM   picture "99999.999" when ( val(X_ESP_INT)+;
			     val(X_ESP_FN)+val(X_ESP_FD) = 0 ) .and. ( T_LARG )

   end

return


/*
-----------------------------------------------------------------------------

                            VERINDEX

-----------------------------------------------------------------------------
*/

Function verindex()

dbcloseall()
set cursor off

mensagem( 'Indexando : USUARIO ' )
use ESTUSUAR
if ! neterr()
   if ! file('ESTUSU1.ntx')
      pack
      index on CODUSU to ESTUSU1
   end
end

mensagem( 'Indexando : ROTINA ' )
use ESTROTIN
if ! neterr()
   if ! file('ESTROT1.ntx')
      pack
      index on CODROT to ESTROT1
   end
end

mensagem( 'Indexando : DIREITO ' )
use ESTDIREI
if ! neterr()
   if ! file('ESTDIR1.ntx')
      pack
      index on CODUSU+CODROT to ESTDIR1
   end
end

mensagem( 'Indexando : AGENDA ' )
use AGE001
if ! neterr()
   if ! file('AGE00101.ntx')
      pack
      index on NOME to AGE00101
   end
end

mensagem( 'Indexando : SENHA ' )
use est000
if ! neterr()
   if ! file('est00001.ntx')
      pack
      index on acesso to est00001
   end
end

mensagem( 'Indexando : ROTINA ' )
use est999
if ! neterr()
   if ! file('est99901.ntx')
      pack
      index on rotina to est99901
   end
end

mensagem( 'Indexando : ALMOXARIFADO ' )
use est001
if ! neterr()
    if ! file('est00101.ntx')
      pack
      index on almoxari to est00101
   end
end

mensagem( 'Indexando : FORNECEDOR ' )
use est002
if ! neterr()
   if ! file('est00201.ntx')
      pack
      index on fornecedor to est00201
   end
   if ! file('est00202.ntx')
      pack
      index on fguerra	  to est00202
   end
end

mensagem( 'Indexando : FORMA DE MATERIAL ' )
use est003
if ! neterr()
   if ! file('est00301.ntx')
      pack
      index on forma to est00301
   end
end

mensagem( 'Indexando : TIPO DE MATERIAL ' )
use est004
if ! neterr()
   if ! file('est00401.ntx')
      pack
      index on forma+tipo	 to est00401
   end
   if ! file('est00402.ntx')
      pack
      index on tipo+forma	 to est00402
   end
   if ! file('est00403.ntx')
      pack
      index on forma+tipo+estado to est00403
   end
end

mensagem( 'Indexando : PEDIDO DE COMPRA ' )
use est005
if ! neterr()
   if ! file('est00501.ntx')
      pack
      index on pedido+fornecedor to est00501
   end
   if ! file('est00502.ntx')
      pack
      index on fornecedor+pedido to est00502
   end
end

mensagem( 'Indexando : ITEM DE PEDIDO DE COMPRA ' )
use est006
if ! neterr()
   if ! file('est00601.ntx')
      pack
      index on pedido							to est00601
   end
   if ! file('est00602.ntx')
      pack
      index on pedido+str(sequenc,3,0)					to est00602
   end
   if ! file('est00603.ntx')
      pack
      index on pedido+forma+tipo+str(bit_mm,8,3)+str(esp_mm,8,3)+estado to est00603
   end
   if ! file('est00604.ntx')
      pack
      index on forma+tipo+str(bit_mm,8,3)+str(esp_mm,8,3)+estado+dtoc(R_DTPED)+pedido to est00604
   end
end

mensagem( 'Indexando : ITEM DE ESTOQUE ' )
use est007
if ! neterr()
   if ! file('est00701.ntx')
      pack
      index on forma+tipo+str(bit_mm,8,3)+str(esp_mm,8,3)+estado	     to est00701
   end
   if ! file('est00702.ntx')
      pack
      index on forma+tipo+estado+bit_int+bit_fn+bit_fd+esp_int+esp_fn+esp_fd to est00702
   end
   if ! file('est00703.ntx')
      pack
      index on forma+tipo+estado+str(bit_mm,8,3)+str(esp_mm,8,3)             to est00703
   end
   if ! file('est00704.ntx')
      pack
      index on forma+tipo+estado+str(bit_mm,8,3)+str(esp_mm,8,3)+dtos(dat_ult) to est00704
    end
end

mensagem( 'Indexando : PECA CORTADA ' )
use est008
if ! neterr()
   if ! file('est00801.ntx')
      pack
      index on forma+tipo+str(bit_mm,8,3)+str(esp_mm,8,3)+estado		to est00801
   end
   if ! file('est00802.ntx')
      pack
      index on forma+tipo+str(bit_mm,8,3)+str(esp_mm,8,3)+estado+str(sequenc,5) to est00802
   end
   if ! file('est00803.ntx')
      pack
      index on comprim								to est00803
   end
end

mensagem( 'Indexando : LOTE ' )
use est009
if ! neterr()
   if ! file('est00901.ntx')
      pack
      index on lote to est00901
   end
end

mensagem( 'Indexando : MOVIMENTACAO ' )
use est010
if ! neterr()
   if ! file('est01001.ntx')
      pack
      index on forma+tipo+str(bit_mm,8,3)+str(esp_mm,8,3)+estado		to est01001
   end
   if ! file('est01002.ntx')
      pack
      index on forma+tipo+estado+str(bit_mm,8,3)+str(esp_mm,8,3)+dtos(datamovi) to est01002
   end
   if ! file('est01003.ntx')
      pack
      index on forma to est01003
   end
   if ! file('est01004.ntx')
      pack
      index on dtos( DATAMOVI ) + FORMA + TIPO + ESTADO to est01004
   end
end

mensagem( 'Indexando : TIPO DE MOVIMENTACAO ' )
use est011
if ! neterr()
   if ! file('est01101.ntx')
      index on tipomovi to est01101
   end
end

mensagem( 'Indexando : LOTE ' )
use est031
if ! neterr()
   if ! file('est03101.ntx')
      pack
      index on lote							       to est03101
   end
   if ! file('est03102.ntx')
      pack
      index on forma+tipo+str(bit_mm,8,3)+str(esp_mm,8,3)+estado+lote	       to est03102
   end
   if ! file('est03103.ntx')
      pack
      index on forma+tipo+str(bit_mm,8,3)+str(esp_mm,8,3)+estado+descend(lote) to est03103
   end
   if ! file('est03104.ntx')
      pack
      index on descend( lote )                                                 to est03104
   end
end

// vendas

mensagem( 'Indexando : CLIENTE ' )
use ven001
if ! neterr()
   if ! file('ven00101.ntx')
      pack
      index on codcli	     to ven00101
   end
   if ! file('ven00102.ntx')
      pack
      index on razao	     to ven00102
   end
end

mensagem( 'Indexando : VENDEDOR ' )
use ven002
if ! neterr()
   if ! file('ven00201.ntx')
      pack
      index on codven	     to ven00201
   end
end

mensagem( 'Indexando : CONSULTA ' )
use ven003
if ! neterr()
   if ! file('ven00301.ntx')
      pack
      index on consulta+codcli			to ven00301
   end
   if ! file('ven00302.ntx')
      pack
      index on codcli+comprador+dtos(dt_cons)	to ven00302
   end
   if ! file('ven00303.ntx')
      pack
      index on codcli+consulta			to ven00303
   end
end

mensagem( 'Indexando : ITEM DE CONSULTA ' )
use ven004
if ! neterr()
   if ! file('ven00401.ntx')
      pack
      index on consulta+str(sequenc,3)	to ven00401
   end
   if ! file('ven00402.ntx')
      pack
      index on usuario			to ven00402
   end
end

mensagem( 'Indexando : PEDIDO DE VENDA ' )
use ven005
if ! neterr()
   if ! file('ven00501.ntx')
      pack
      index on pedven+codcli		to ven00501
   end
end

mensagem( 'Indexando : ITEM DE PEDIDO DE VENDA ' )
use ven006
if ! neterr()
   if ! file('ven00601.ntx')
      pack
      index on pedven+str(sequenc,3)+forma+tipo+str(bit_mm,8,3)+str(esp_mm,8,3)+estado	 to ven00601
   end
   if ! file('ven00602.ntx')
      pack
      index on notafiscal		    to ven00602
   end
   if ! file('ven00603.ntx')
      pack
      index on usuario+notafiscal	    to ven00603
   end
   if ! file('ven00604.ntx')
      pack
      index on separacao		    to ven00604
   end
end

mensagem( 'Indexando : COMISSAO DE VENDEDOR ' )
use ven008
if ! neterr()
   if ! file('ven00801.ntx')
      pack
      index on codven+pedven			   to ven00801
   end
end

mensagem( 'Indexando : PAGAMENTO DE VENDEDOR ' )
use ven009
if ! neterr()
   if ! file('ven00901.ntx')
      pack
      index on codven				   to ven00901
   end
end

mensagem( 'Indexando : COMISSAO DE COMPRADOR' )
use ven010
if ! neterr()
   if ! file('ven01001.ntx')
      pack
      index on codcli+pedven			   to ven01001
   end
end

mensagem( 'Indexando : PAGAMENTO DE COMPRADOR ' )
use ven011
if ! neterr()
   if ! file('ven01101.ntx')
      pack
      index on codcli				   to ven01101
   end
end

mensagem( 'Indexando : NOTA FISCAL ' )
use ven012
if ! neterr()
   if ! file('ven01201.ntx')
      pack
      index on notafiscal			   to ven01201
   end
end

mensagem( 'Indexando : COMISSAO DE VENDA ' )
use ven014
if ! neterr()
   if ! file('ven01401.ntx')
      pack
      index on grupo+str(descmax,8,2)		   to ven01401
   end
end

mensagem( 'Indexando :  GRUPO ' )
use ven015
if ! neterr()
   if ! file('ven01501.ntx')
      pack
      index on grupo				   to ven01501
   end
end

mensagem( 'Indexando : SEPARACAO ' )
use ven016
if ! neterr()
   if ! file('ven01601.ntx')
      pack
      index on separacao			   to ven01601
   end
   if ! file('ven01602.ntx')
      pack
      index on pedven				   to ven01602
   end
end

mensagem( 'Indexando : GRUPO - TB PRECOS ' )
use ven017
if ! neterr()
   if ! file('ven01701.ntx')
      pack
      index on grupo				   to ven01701
   end
end

mensagem( 'Indexando : SUBGRUPO - TB PRECOS ' )
use ven018
if ! neterr()
  if ! file('ven01801.ntx')
     pack
     index on grupo+subgrupo			  to ven01801
  end
end

mensagem( 'Indexando :  PRECO DE VENDA ' )
use ven019
if ! neterr()
   if ! file('ven01901.ntx')
      pack
      index on grupo+subgrupo+coluna               to ven01901
   end
end

mensagem( 'Indexando : SUBFATOR - TB PRECOS ' )
use ven020
if ! neterr()
   if ! file('ven02001.ntx')
      pack
      index on grupo+subfator+str(medidafim,8,3)   to ven02001
   end
end


mensagem( 'Indexando :  BANCO ' )
use cr0100
if ! neterr()
   if ! file('cr010001.ntx')
      pack
      index on codbanco                             to cr010001
   end
end

mensagem( 'Indexando :  AGENCIA ' )
use cr0200
if ! neterr()
   if ! file('cr020001.ntx')
      pack
      index on codbanco+codagencia                  to cr020001
   end
end

mensagem( 'Indexando :  TIPO DE COBRANCA ' )
use cr0300
if ! neterr()
   if ! file('cr030001.ntx')
      pack
      index on codcobra                             to cr030001
   end
end

mensagem( 'Indexando :  FORMA DE COBRANCA ' )
use cr0400
if ! neterr()
   if ! file('cr040001.ntx')
      pack
      index on codforma                             to cr040001
   end
end

mensagem( 'Indexando :  TABELA DE VENCIMENTOS ' )
use cr0500
if ! neterr()
   if ! file('cr050001.ntx')
      pack
      index on codvenc                              to cr050001
   end
end

mensagem( 'Indexando :  CADASTRO DE CHEQUES   ' )
use cr0600
if ! neterr()
   if ! file('cr060001.ntx')
      pack
      index on nr_cheque                            to cr060001
   end
end


mensagem( 'Indexando :  DUPLICATA ' )
use cr1000
if ! neterr()
   if ! file('cr100001.ntx')
      pack
      index on duplicata+sequencia                  to cr100001
   end
   if ! file('cr100002.ntx')
      pack
      index on status+duplicata+sequencia           to cr100002
   end
end

set cursor on

return nil


*-------------------------------------*
Function vazio

message(' Preenchimento obrigatorio ! ')

return .f.

/*
-----------------------------------------------------------------------------
Procedimento : ABRIR
Parametros   : Nome do arquivo
Retorno      : nenhum
Objetivo     :
-----------------------------------------------------------------------------
*/
Procedure abrir( P_FILE )

if select( P_FILE ) == 0
   do case
      case P_FILE = "ESTUSUAR"
         use ESTUSUAR index ESTUSU1   alias USUARIO       shared new
      case P_FILE = "ESTDIREI"
         use ESTDIREI index ESTDIR1   alias DIREITO       shared new
      case P_FILE = "ESTROTIN"
         use ESTROTIN index ESTROT1   alias ROTINA        shared new

      case P_FILE = "ESTREPO"
         use ESTREPO                                      shared new

      case P_FILE = "AGE001"
	 use AGE001  index  AGE00101			  shared new

      case P_FILE = "VEN001"
	 use VEN001  index  VEN00101,VEN00102		  shared new
      case P_FILE = "VEN002"
	 use VEN002  index  VEN00201			  shared new
      case P_FILE = "VEN003"
	 use VEN003  index  VEN00301, VEN00302, VEN00303  shared new
      case P_FILE = "VEN004"
	 use VEN004  index  VEN00401, VEN00402		  shared new
      case P_FILE = "VEN005"
	 use VEN005  index  VEN00501			  shared new
      case P_FILE = "VEN006"
	 use VEN006  index  VEN00601, VEN00602, VEN00603, VEN00604 shared new
      case P_FILE = "VEN007"
	 use VEN007  index  VEN00701			  shared new
      case P_FILE = "VEN008"
	 use VEN008  index  VEN00801			  shared new
      case P_FILE = "VEN009"
	 use VEN009  index  VEN00901			  shared new
      case P_FILE = "VEN010"
	 use VEN010  index  VEN01001			  shared new
      case P_FILE = "VEN011"
	 use VEN011  index  VEN01101			  shared new
      case P_FILE = "VEN012"
	 use VEN012  index  VEN01201			  shared new
      case P_FILE = "VEN013"
	 use VEN013  index  VEN01301			  shared new
      case P_FILE = "VEN014"
	 use VEN014  index  VEN01401			  shared new
      case P_FILE = "VEN015"
	 use VEN015  index  VEN01501			  shared new
      case P_FILE = "VEN016"
	 use VEN016  index  VEN01601, VEN01602		  shared new
      case P_FILE = "VEN017"
	 use VEN017  index  VEN01701			  shared new
      case P_FILE = "VEN018"
	 use VEN018  index  VEN01801			  shared new
      case P_FILE = "VEN019"
	 use VEN019  index  VEN01901			  shared new
      case P_FILE = "VEN020"
	 use VEN020  index  VEN02001			  shared new
      case P_FILE = "VEN099"
	 use VEN099					  shared new

      case P_FILE = "EST000"
	 use EST000  index  EST00001			  shared new
      case P_FILE = "EST999"
	 use EST999  index  EST99901			  shared new
      case P_FILE = "EST001"
	 use EST001  index  EST00101			  shared new
      case P_FILE = "EST002"
	 use EST002  index  EST00201, EST00202		  shared new
      case P_FILE = "EST003"
	 use EST003  index  EST00301			  shared new
      case P_FILE = "EST004"
	 use EST004  index  EST00401, EST00402		  shared new
      case P_FILE = "EST005"
	 use EST005  index  EST00501			  shared new
      case P_FILE = "EST006"
	 use EST006  index  EST00601, EST00602, EST00603, EST00604  shared new
      case P_FILE = "EST007"
	 use EST007  index  EST00701, EST00702, EST00703,EST00704  shared new
      case P_FILE = "EST008"
	 use EST008  index  EST00801, EST00802, EST00803  shared new
      case P_FILE = "EST009"
	 use EST009  index  EST00901			  shared new
      case P_FILE = "EST010"
         use EST010  index  EST01001, EST01002,EST01003,EST01004 shared new
      case P_FILE = "EST011"
	 use EST011  index  EST01101			  shared new
      case P_FILE = "EST031"
	 use EST031  index  EST03101 ,EST03102, EST03103, EST03104  shared new

      case P_FILE = "CR0100"
         use CR0100  index  CR010001                      shared new
      case P_FILE = "CR0200"
         use CR0200  index  CR020001                      shared new
      case P_FILE = "CR0300"
         use CR0300  index  CR030001                      shared new
      case P_FILE = "CR0400"
         use CR0400  index  CR040001                      shared new
      case P_FILE = "CR0500"
         use CR0500  index  CR050001                      shared new
     case P_FILE = "CR0600"
         use CR0600  index  CR060001                      shared new
     case P_FILE = "CR1000"
         use CR1000  index  CR100001, CR100002            shared new
 
   endcase
end
return
/*
-----------------------------------------------------------------------------

                           NOVO_LOTE

-----------------------------------------------------------------------------
*/
function novo_lote()

EST031->( dbsetorder(4) )
EST031->( dbgotop() )

if EST031->( ! eof() )

    WRET := val ( EST031->lote )
    WRET :=  strzero( ++WRET, 5 )
else
    WRET := "00001"
end

return WRET


**********************
function tira_zero(VAR)
**********************
local WRET

if VAR == "ESP"
   MEDIDA := EST007->ESP_INT

elseif VAR == "BIT10"
   MEDIDA := EST010->BIT_INT

elseif VAR == "EST10"
   MEDIDA := EST010->EST_INT

else
   MEDIDA := EST007->BIT_INT
end

if MEDIDA == "0 " .or. MEDIDA == "  "
   WRET := space(3)
else
   WRET := MEDIDA + '+'
end

return WRET

**********************
function s_material()
**********************

   local WRET := .F.
   local P_HEADER:={}, P_CAMPOS:={}, P_SCR, getlist:={}
   local P_HDSEP := "หอ", P_COLSEP := "-"
   local W_OLDCOR := W_CORWIND := setcolor()


   if readvar()="X_FORMA"
      P_SCR := savescreen(06,21,18,71)
      @ 06, 21 say "ีอออออออออออออออออ Material ออออออออออออออออออออธ"
      @ 07, 21 say "ณ                                               ณ"
      @ 08, 21 say "ฦ                                               ต"
      @ 09, 21 say "ณ                                               ณ"
      @ 10, 21 say "ณ                                               ณ"
      @ 11, 21 say "ณ                                               ณ"
      @ 12, 21 say "ณ                                               ณ"
      @ 13, 21 say "ณ                                               ณ"
      @ 14, 21 say "ณ                                               ณ"
      @ 15, 21 say "ณ                                               ณ"
      @ 16, 21 say "ิอออออออออออออออออออออออออออออออออออออออออออออออพ"
      sombra(06,21,16,69)

      P_HEADER := {" Forma  Tipo  Estado  Bitola     Espessura " }
      V_VETOR  := "  EST007->FORMA   + ' ' +            " +;
		  "  EST007->ESTADO  + ' ' +            " +;
		  "  EST007->BIT_INT + '+' +            " +;
		  "  EST007->BIT_FN  + '/' +            " +;
		  "  EST007->BIT_FD  + '-' +            " +;
		  "  str( EST007->BIT_MM,9,2)  + ' ' +  " +;
		  "  EST007->ESP_INT + '+' +            " +;
		  "  EST007->ESP_FN  + '/' +            " +;
		  "  EST007->ESP_FD  + '-' +            " +;
		  "  str( EST007->ESP_MM,9,2)  + ' '    "

      P_CAMPOS := { V_VETOR }

      EST007->( dbgotop() )
      EST007->( dbedit(07,22,15,68,P_CAMPOS,,, P_HEADER, P_HDSEP, P_COLSEP))
      restscreen(06,21,18,71,P_SCR)

      if lastkey() != 27
	 WRET := .T.

	 X_FORMA   := EST007->FORMA
	 X_TIPO    := EST007->TIPO
	 X_ESTADO  := EST007->ESTADO
	 X_BIT_INT := EST007->BIT_INT
	 X_BIT_FN  := EST007->BIT_FN
	 X_BIT_FD  := EST007->BIT_FD
	 X_BIT_MM  := EST007->BIT_MM
	 X_ESP_INT := EST007->ESP_INT
	 X_ESP_FN  := EST007->ESP_FN
	 X_ESP_FD  := EST007->ESP_FD
	 X_ESP_MM  := EST007->ESP_MM
	 keyboard chr(13)
	 keyboard chr(13)
	 keyboard chr(13)
	 keyboard chr(13)
	 keyboard chr(13)
	 keyboard chr(13)
	 keyboard chr(13)
      end
   end

return WRET

/*
-----------------------------------------------------------------------------
		      Funcao TES_FORMATO
-----------------------------------------------------------------------------
*/
function tes_formato( POSICAO )

   local WRET := .T., VAR := zerofill( X_FORMA ) // preenche com zeros

   if POSICAO = NIL
      POSICAO := 1
   end

   X_FORMA     := VAR
   X_DESCRICAO := SPACE(20)

   EST003->( dbsetorder(1) )
   EST003->( dbseek( VAR ) )

   if EST003->( ! found() )
      m_tabelas()
      if lastkey() = K_ESC
	 WRET := .F.
      end
   else
      WRET := .T.
   end
   if WRET
      do case
	 case EST003->P_MATERIAL = 1
	    T_BIT := .T. ; T_LARG := .F.
	 case EST003->P_MATERIAL = 2
	    T_BIT := .T. ; T_LARG := .T.
	 case EST003->P_MATERIAL = 3
	    T_BIT := .T. ; T_LARG := .T.
       end
   end

   if POSICAO == 1
      @ 05,16 say X_FORMA      picture '@!'
      @ 05,24 say EST003->DESCRICAO  picture '@!'
   else
      @ 09,16 say X_FORMA      picture '@!'
      @ 09,24 say EST003->DESCRICAO  picture '@!'
   end

return WRET

/*
------------------------------------------------------------------------------
		      Funcao TES_TIPO
-----------------------------------------------------------------------------
*/
function tes_tipo(POSICAO)

   local WRET := .T., VAR := X_FORMA+X_TIPO

   if POSICAO = NIL
      POSICAO := 1
   end

   X_FORMA   := left(  VAR, 3 )
   X_TIPO    := right( VAR, 5 )

   // cadastro de tipos
   EST004->( dbsetorder(1) )
   EST004->( dbseek(VAR ) )

   if EST004->( ! found() )
      m_tabelas( X_FORMA )
      if lastkey()=27
	 WRET := .F.
      end
   end


   if POSICAO = 1
      X_ESTADO := EST004->ESTADO
      @ 06,16 say X_TIPO     picture '@!'
      @ 06,24 say EST004->DESCRICAO   picture  '@!'
      @ 07,16 say X_ESTADO  picture '@!'
   else
     if x_estado=" "
      X_ESTADO := EST004->ESTADO
     end
      @ 10,16 say X_TIPO     picture '@!'
      @ 10,24 say EST004->DESCRICAO   picture  '@!'
      @ 11,16 say X_ESTADO  picture '@!'
   end

return WRET

/*
------------------------------------------------------------------------------
		      Funcao TES_CODCLI
-----------------------------------------------------------------------------
*/
function tes_codcli( P_CODCLI, P_LIN, P_COL, P_TAM )

   local WRET := .T.

   P_TAM := if(P_TAM=NIL, len( VEN001->GUERRA ), P_TAM )

   VEN001->( dbsetorder(1) )
   VEN001->( dbseek( P_CODCLI ) )

   X_CODVEN := VEN001->CODVEN

   if VEN001->( ! found() )
      m_tabelas( X_CODCLI )

      VEN001->( dbsetorder(1) )
      VEN001->( dbseek( X_CODCLI ) )

      X_CODVEN := VEN001->CODVEN
   end

   if ! empty (P_LIN)
      @ P_LIN, P_COL+7 say '- '+ left( VEN001->GUERRA, P_TAM )
   end

return WRET

/*
------------------------------------------------------------------------------
		      Funcao TES_PEDVEN
-----------------------------------------------------------------------------
*/
function tes_pedven( POSICAO )

   local WRET := .T.

   VEN005->( dbsetorder(1) )
   VEN005->( dbseek( POSICAO ) )

   if VEN005->( ! found() )
      m_tabelas( X_PEDVEN )
      if lastkey()=27; WRET := .F.; end
   end

return WRET

/*
------------------------------------------------------------------------------
		      Funcao TES_VENDEDOR
-----------------------------------------------------------------------------
*/
function tes_codven( POSICAO, P_LIN, P_COL, P_TAM )

   local WRET := .T.

   P_TAM := if(P_TAM=NIL,len(VEN002->NOME),P_TAM)

   VEN002->( dbsetorder(1) )
   VEN002->( dbseek( POSICAO ) )

   if VEN002->( ! found() )
      m_tabelas( X_CODVEN )
      if lastkey()=27
	  WRET := .F.
      end
   end

   if P_LIN # NIL
      @ P_LIN, P_COL+3 say '- '+ left( VEN002->NOME, P_TAM )
   end

return WRET

/*
------------------------------------------------------------------------------
		      Funcao TES_CODVEN
-----------------------------------------------------------------------------
*/
function tes_vendedor( POSICAO, P_LIN, P_COL )

   local WRET := .T.

   VEN002->( dbsetorder(1) )
   VEN002->( dbseek( POSICAO ) )

   if VEN002->( ! found() )
      m_tabelas( X_CODVEN )
      if lastkey()=27
	  WRET := .F.
      end
   end

   if P_LIN # NIL
      @ P_LIN, P_COL+7 say '- '+ VEN002->NOME
   end

return WRET

/*
------------------------------------------------------------------------------
		      Funcao TES_BITOLA
-----------------------------------------------------------------------------
*/
function tes_bitola()

   local WRET := .T., VAR := X_FORMA+X_TIPO+X_ESTADO, VAR1 := X_BIT_INT

   if empty ( VAR1 )
      m_tabelas( VAR )
   end

return WRET

/*
------------------------------------------------------------------------------
		      Funcao TES_ESPESSURA
-----------------------------------------------------------------------------
*/
function tes_espessura()

   local WRET := .T., VAR := X_FORMA+X_TIPO+X_ESTADO, VAR1 := X_ESP_INT

   if empty ( VAR1 )
      m_tabelas( VAR )
   end

return WRET

/*
-----------------------------------------------------------------------------
		      Funcao TES_COD_ESTADO
-----------------------------------------------------------------------------
*/
function tes_cod_estado(VAR)

local WRET := .T.

   if var == 'T' .or. var == 'F' .or. var == 'L' .or. var == ' '
      WRET := .T.
   else
      message('Estado invalido')
      WRET := .F.
   end

return WRET
/*
-----------------------------------------------------------------------------
		      Funcao TES_ESTADO
-----------------------------------------------------------------------------
*/
function tes_estado(POSICAO)

   local WRET  := .F., VAR := X_FORMA+X_TIPO+X_ESTADO
   local W_MSG := space(09)

   if POSICAO = NIL
      POSICAO := 1
   end

   X_FORMA   := left ( VAR, 3	 )
   X_TIPO    := subst( VAR, 4, 5 )
   X_ESTADO  := right( VAR, 1	 )

   EST004->( dbsetorder( 1 ) )
   EST004->( dbseek( VAR ) )

   if EST004->( ! found() )
      message("Estado nao cadastrado !")
   else
      WRET := .T.
      do case
	 case X_ESTADO = 'T'
	    W_MSG := 'Trefilado'

	 case X_ESTADO = 'F'
	    W_MSG := 'Forjado  '

	 case X_ESTADO = 'L'
	    W_MSG := 'Laminado '

	 case X_ESTADO = ' '
	    W_MSG := '         '

	 otherwise
	    W_MSG := '*********'
      end

      if POSICAO = 1
	 @ 07,16 say X_ESTADO  picture '@!'
	 @ 07,24 say W_MSG     picture '@!'
      else
	 @ 11,16 say X_ESTADO  picture '@!'
	 @ 11,24 say W_MSG     picture '@!'
      end

   end

return WRET

/*
-----------------------------------------------------------------------------
		      Funcao TES_MOVIME
-----------------------------------------------------------------------------
*/
function tes_movime( VAR )

   local WRET := .T.


   VAR := X_TIPOMOVI := zerofill( VAR )
   EST011->( dbsetorder(1) )
   EST011->( dbseek( VAR ) )

   if EST011->( ! found() )
      m_tabelas()
      if lastkey() = K_ESC
	 WRET := .F.
      else
	 X_TIPOMOVI := EST011->TIPOMOVI
      end
   end

   @ 13,28 say X_TIPOMOVI	 picture '@!'
   @ 13,34 say EST011->DESCRICAO picture '@!'

return WRET

/*
-----------------------------------------------------------------------------
		      Funcao TES_MOV2
-----------------------------------------------------------------------------
*/
function tes_mov2( VAR )

   local WRET := .T.

   X_TIPOMOVI := VAR

   EST011->( dbsetorder(1) )
   EST011->( dbseek( VAR ) )

   if EST011->( found() )
      @ 19,27 say X_TIPOMOVI
      message("Tipo de movimentacao ja' cadastrado")
      WRET := .F.
   end
return WRET

/*
-----------------------------------------------------------------------------
		      Funcao TES_ALMOXA
-----------------------------------------------------------------------------
*/
function tes_almoxa( VAR, POSICAO )
   local WRET := .T.

   if POSICAO = NIL; POSICAO := 1; end
   X_ALMOXARI := VAR := zerofill( X_ALMOXARI )

   begin sequence
      EST001->( dbsetorder(1) )
      EST001->( dbseek( VAR ) )

      if EST001->( ! found() )
	 m_tabelas()
	 if lastkey() = K_ESC
	    WRET := .F.
	    break
	 else
	    X_ALMOXARI := EST001->ALMOXARI
	 end
      end
      @ 11,26 say EST001->DESCRICAO picture '@!'
   end sequence

return WRET

/*
-----------------------------------------------------------------------------
		      Funcao TES_FORN
-----------------------------------------------------------------------------
*/
function tes_forn( VAR, POSICAO )

   local WRET := .T.

   if POSICAO = NIL
      POSICAO := 1
   end

   VAR := X_FORNECEDOR

   EST002->( dbsetorder(1) )
   EST002->( dbseek( VAR ) )

   if  empty( VAR ) // EST002->( ! found() ) .or.
      m_tabelas()
      if lastkey() = K_ESC
	 WRET := .F.
      else
	 X_FORNECEDOR := EST002->FORNECEDOR
      end
   end

   if WRET
      if POSICAO == 1
	 @ 19,24 say left( EST002->FGUERRA, 24 )  picture '@!'
      end

      if POSICAO == 2
	 @ 17,24 say left( EST002->FGUERRA, 24 )  picture '@!'
      end

      if POSICAO == 3
	 @ 03,51 say left( EST002->FGUERRA, 24 )  picture '@!'
      end
   end

return .t.
return WRET

/*
-----------------------------------------------------------------------------
		      Funcao CALC_BIT
-----------------------------------------------------------------------------
*/
Function calc_bit(POSICAO)
   local FINT := X_BIT_INT,;
	 FN   := X_BIT_FN ,;
	 FD   := X_BIT_FD ,;
	 FMM  := X_BIT_MM

   local W_BITCM := FRES := 0.00

   if POSICAO = NIL
      POSICAO := 1
   end

   if FMM = 0
      // Calcula Bitola em MM atraves da medida em Polegada, so' se ela nao existir
      if X_BIT_MM <= 0
	 FINT := val( FINT ); FN := val( FN ); FD := val( FD )
	 FRES := FINT +( FN/ FD)
	 W_BITCM  := 2.54 * FRES * 10
	 X_BIT_MM := W_BITCM
      end
   end

   if POSICAO = 1
      @ 08,25 say X_BIT_MM  picture "99999.999"
   else
      @ 12,25 say X_BIT_MM  picture "99999.999"
   end

return ( .T. )

/*
------------------------------------------------------------------------------
		      Funcao TES_GRUPO
-----------------------------------------------------------------------------
*/
function tes_grupo( POSICAO, P_LIN, P_COL, P_TAM )

   local WRET := .T.

   P_TAM := if(P_TAM=NIL, len( VEN015->DESCRICAO ), P_TAM )

   VEN015->( dbsetorder(1) )
   VEN015->( dbseek( POSICAO ) )

   if VEN015->( ! found() )
      m_tabelas( X_GRUPO )
      if lastkey()=27
	  WRET := .F.
      end
   end
   if ! empty (P_LIN)
      @ P_LIN, P_COL+7 say '- '+ left( VEN015->DESCRICAO, P_TAM )
   end

return WRET

/*
------------------------------------------------------------------------------
		      Funcao TES_MEDIDA
-----------------------------------------------------------------------------
*/
function tes_medida( POSICAO, P_LIN, P_COL, P_TAM )

   local WRET := .T.

   P_TAM := if(P_TAM=NIL, len( str(VEN015->PRECO,12,2)), P_TAM )

   VEN015->( dbsetorder(1) )
   VEN015->( dbseek( POSICAO ) )

   if VEN015->( ! found() )
      m_tabelas( X_MEDIDA )
      if lastkey()=27
	  WRET := .F.
      end
   end
   if ! empty (P_LIN)
      @ P_LIN, P_COL+7 say '- '+ left(  STR(VEN015->PRECO,12,2) , P_TAM )
   end

return WRET

/*
-----------------------------------------------------------------------------
		      Funcao CALC_ESP
-----------------------------------------------------------------------------
*/
Function calc_esp(POSICAO)
   local FINT := X_ESP_INT,;
	 FN   := X_ESP_FN ,;
	 FD   := X_ESP_FD ,;
	 FMM  := X_ESP_MM

   local W_BITCM := FRES := 0.00

   if POSICAO = NIL
      POSICAO := 1
   end

   if FMM = 0
      FINT := val( FINT ); FN := val( FN ); FD := val( FD )

      FRES := FINT +( FN/ FD)

      W_BITCM := 2.54 * FRES * 10
      X_ESP_MM := W_BITCM
   end

   if POSICAO = 1
      @ 09,25 say X_ESP_MM  picture "99999.999"
   else
      @ 13,25 say X_ESP_MM  picture "99999.999"
   end

return ( .T. )

/*
-----------------------------------------------------------------------------
		      Funcao EBITOLA
-----------------------------------------------------------------------------
*/
Function Ebitola( FORMA )
   local WRET := .F.

   EST003->( dbseek( FORMA ))

   if EST003->( found() )
      if EST003->P_MATERIAL = 1
	 WRET := .T.
      endif
   else
      message( "Forma do Material nao Cadastrada" )
   endif

return( WRET )


/*
-----------------------------------------------------------------------------
		      Funcao VER_MATERIAL
-----------------------------------------------------------------------------
*/
function ver_material( VAR )

   local WRET := .T.

   EST007->( dbsetorder(1) )
   EST007->( dbseek( VAR ) )

   if EST007->( ! found() )
      WRET := .F.
   end

   W_QTD_INT := EST007->QTD_INT

return WRET


/*
-----------------------------------------------------------------------------
		      Funcao ESP_ALT
-----------------------------------------------------------------------------
*/
function esp_alt()
local TEC

WRET := pergresp( 'Consulta/ Alterar/ Excluir/ Retornar ? ','CAER', 3, 36)

do case
case WRET = 'A'
   WRET := "A"
case WRET = 'E'
   WRET := "E"
case WRET = 'R'
   WRET := "*"
case WRET = 'C'
   WRET := "C"
endcase

return ( WRET )

/*
-----------------------------------------------------------------------------
		      Funcao PEDIDO
-----------------------------------------------------------------------------
*/

function PEDIDO( VAR )

  local WRET := .T.

   EST005->( dbsetorder(1) )

   EST005->( dbseek( VAR ) )

   if EST005->( ! found() )
      message('Pedido nao encontrado !')
      WRET := .F.
   end

return WRET

/*
-----------------------------------------------------------------------------
		      Funcao PEDIDO_PENDENTE
-----------------------------------------------------------------------------
*/

function PEDIDO_PENDENTE( VAR )

  local WRET := .F.

   EST006->( dbsetorder(3) )

   EST006->( dbseek( VAR ) )

   if EST006->( ! found() )
      message('Item de Pedido nao encontrado !')
      WRET := .F.
   end

   while EST006->( !EOF() ) .and. VAR = EST006->FORMA +EST006->FORMA + EST006->TIPO + EST006->ESTADO + ;
					str(EST006->BIT_MM,8,3) + str(EST006->ESP_MM,8,3)
      if EST006->status = 'P'
	 WRET := .T.
	 exit
      end

      EST006->(dbskip())

   enddo

return WRET

/*
-----------------------------------------------------------------------------
		      Funcao PEDIDO_RECEBIDO
-----------------------------------------------------------------------------
*/

function PEDIDO_RECEBIDO( VAR )

  local WRET := .T.

   EST005->( dbsetorder(1) )

   EST005->( dbseek( VAR ) )

   if EST005->( ! found() )
      message('Pedido nao encontrado !')
      WRET := .F.
   end

   replace EST005->status with 'R'

return WRET



/*
-----------------------------------------------------------------------------

                            MOVIMENTACAO

-----------------------------------------------------------------------------
*/
function MOVIMENTACAO( P_BUSCA )
   local WRET := .F.

   EST010->( dbsetorder(1))
   EST010->( dbseek( P_BUSCA ))
   if EST010->( found() )
      WRET := .T.
   else
      WRET := .F.
   end
return WRET

/*
-----------------------------------------------------------------------------

                            BUSCA_PECA

-----------------------------------------------------------------------------
*/
function busca_peca( )
   local WRET := .F.

   EST007->( dbsetorder(1))
   EST007->( dbseek( W_CHAVE_ITEM ))
   if EST007->( found() )
      WRET := .T.
   else
      WRET := .F.
   end

return WRET


/*
-----------------------------------------------------------------------------

                        CALC_TOT_PEND

-----------------------------------------------------------------------------
/*
function calc_tot_pend( W_PEDTOT, POSICAO )

   local W_TOTAL := W_QUANT := 0, WRET := 0,;
	 W_OLDREC := est006->( recno() )

   select EST006
   EST006->( dbsetorder(1) )
   EST006->( dbgotop() )
   EST006->( dbseek( W_PEDTOT ))

   if EST006->( found() )

      while EST006->( ! eof() ) .and. EST006->PEDIDO=W_PEDTOT
         //
         // Calcula valor total dos itens (custo total dos itens de um pedido)
         //

	 if ! empty( EST006->R_DTPED )	// Calcula apenas o total
	    EST006->( dbskip() )      // dos pedidos pendentes
	    loop
	 end


	 W_STOTAL := (EST006->VAL_KG * EST006->QTD_KG			    ) + ;
		     (EST006->VAL_KG * EST006->QTD_KG * EST006->OUTRATX/100 )

	 W_TOTAL +=   W_STOTAL				       + ;
		    ( W_STOTAL * EST006->IPI/100	     ) + ;
		    ( W_STOTAL * ( 19 - EST006->ICMS ) / 100 ) + ;
		    ( EST006->FRETE  * EST006->QTD_KG	     )

	 W_QUANT++
	 EST006->( dbskip() )
      end
   end

   WRET := if( POSICAO=1, W_TOTAL, W_QUANT )

   EST006->( dbgoto( W_OLDREC ) )

return WRET


/*
-----------------------------------------------------------------------------

                       V_CALC_TOTAL

-----------------------------------------------------------------------------
*/
function V_CALC_TOTAL( W_PEDTOT )

   local W_QUANT := 0, WRET := 0,;
	 W_OLDREC := VEN006->( recno() )

   select VEN006
   VEN006->( dbsetorder(1) )
   VEN006->( dbgotop() )
   VEN006->( dbseek( W_PEDTOT ))

   if VEN006->( found() )
      while VEN006->( ! eof() ) .and. VEN006->PEDVEN=W_PEDTOT
	 W_QUANT++
	 VEN006->( dbskip() )
      end
   end

   WRET := W_QUANT

   VEN006->( dbgoto( W_OLDREC ) )

return WRET


/*
-------------------------------------------------------------------------------

			   V_NOVA_SEQUENCIA

-------------------------------------------------------------------------------
*/

procedure v_nova_sequencia( P_PEDIDO )

local W_ULTSEQ:=0, W_ANTREG := VEN006->( recno())

VEN006->( dbsetorder(1))
VEN006->( dbseek( P_PEDIDO ) )

while VEN006->PEDVEN = P_PEDIDO .and. VEN006->( ! eof())
   W_ULTSEQ := VEN006->SEQUENC
   VEN006->( dbskip())
end
W_ULTSEQ++

VEN006->( dbgoto( W_ANTREG ))

return W_ULTSEQ

/*
-------------------------------------------------------------------------------

			   V_ACHA_PEDIDO

-------------------------------------------------------------------------------
*/
function v_acha_pedido( VAR )

local WRET := .F.

if empty( VAR )
   m_tabelas()
   if lastkey() # K_ESC
      WRET := .T.
   end
else
   VEN005->( dbseek(var) )
   VEN005->( dbsetorder(1) )
   if VEN005->( found() )
      message('Pedido Existente. <ENTER>')
      WRET := .T.
   else
      WRET := .F.
   end
end

return WRET

/*
-------------------------------------------------------------------------------

			   NO_ZERO

-------------------------------------------------------------------------------
*/

function no_zero( VAR, INTEIRO, DECIMAL )

RETORNA := if( VAR = 0, space(INTEIRO), str( VAR, INTEIRO, DECIMAL ) )

return RETORNA

/*
-----------------------------------------------------------------------------

                        TELA_PECA_CORT()

-----------------------------------------------------------------------------
*/
procedure tela_peca_cort()

// ===========

   local P_OLDCOR := setcolor()
   local P_HDSEP := "หอ"
   local P_COLSEP := "-"

   local W_SCR := savescreen( 03, 43, 12, 76 )
   local getlist:={}

   local P_CAMPOS    := {}
   local MASCARA     := {}
   local P_HEADER    := {}
   local TAMANHO     := {}
   local BESCAPE     := {|| W_CHAVE_ITEM = EST008->FORMA	   +;
					   EST008->TIPO 	   +;
					   str(EST008->BIT_MM,8,3) +;
					   str(EST008->ESP_MM,8,3) +;
					   EST008->ESTADO	    }
   local COR	     := W_CORWIND
   local TITULO      := "Pecas Cortadas"
   local LININI      := 03
   local LINFIM      := 11
   local COLINI      := 43
   local COLFIM      := 75
   local BLOCK_DISP  := {|| .T. }
   local CAB_TITULO  := nil
   local BORDA	     := 1

   local TECLA	     := nil
   local TABELA      := nil

   select EST008
   EST008->( dbsetorder(1) )
   EST008->( dbseek( W_CHAVE_ITEM ) )

   if EST008->( found() )

      aadd( P_HEADER, "Largura"    )
      aadd( P_HEADER, "Comprimento" )

      aadd( P_CAMPOS, "LARGURA"     )
      aadd( P_CAMPOS, "COMPRIM" )

      aadd( MASCARA   , "9999999999.99" )
      aadd( MASCARA   , "9999999999.99" )

      aadd( TAMANHO   , 13 )
      aadd( TAMANHO   , 13 )

      TABELA := tabelanew( P_CAMPOS	  , ;
			   MASCARA	  , ;
			   P_HEADER	  , ;
			   TAMANHO	  , ;
			   BESCAPE	  , ;
			   COR		  , ;
			   TITULO	  , ;
			   LININI	  , ;
			   LINFIM	  , ;
			   COLINI	  , ;
			   BLOCK_DISP	  , ;
			   CAB_TITULO	  , ;
			   BORDA	    ;
			 )

      CONTINUA := .T.
      do while CONTINUA .and. ( (TEC:=tabmov(TABELA) ) != K_ESC )
	 if TEC == 13 ; exit ; end
      enddo

   end
   restscreen( 03, 43, 12, 76, W_SCR  )

return

/*
-----------------------------------------------------------------------------

                    TELA_PED_COMPRA()

-----------------------------------------------------------------------------
*/
procedure tela_ped_compra()

local OLD_AREA := select()
local WSCR := savescreen(,,,,)

// private W_HEADER := { "Data Prevista  Qtd em KG  Fornecedor" }
//		       XX/XX/XX123456XXX,XXX.XX12XXXXXXXXXXXXXX

private  CAMPO	     := {}
private  MASCARA     := {}
private  CABECALHO   := {}
private  TAMANHO     := {}
private  W_FILE      := {}
private  BESCAPE     := {|| W_CHAVE_ITEM = EST006->FORMA	   +;
					   EST006->TIPO 	   +;
				      str( EST006->BIT_MM,8,3)	   +;
				      str( EST006->ESP_MM,8,3)	   +;
					   EST006->ESTADO     .and. ;
				    empty( EST006->R_DTPED ) }
private  COR	     := W_COREDIT
private  TITULO      := " Pedido de Compra "
private  LININI      := 03
private  LINFIM      := 12
private  COLINI      := 38
private  COLFIM      := 75
private  BLOCK_DISP  := {|| .T. }
private  CAB_TITULO  := nil
private  BORDA	     := 1

private  TECLA	     := nil
private  TABELA      := nil

aadd( CAMPO	, "DT_PREV" )
aadd( CAMPO	, "QTD_KG" )
aadd( CAMPO	, "FGUERRA" )

aadd( MASCARA	, "999"        )
aadd( MASCARA	, "9999999.99" )
aadd( MASCARA	, "@!"         )

aadd( CABECALHO , "Data Prev"  )
aadd( CABECALHO , "Qtd Kg" )
aadd( CABECALHO , "Fornecedor" )

aadd( TAMANHO	, 10 )
aadd( TAMANHO	, 10 )
aadd( TAMANHO	, 10 )

aadd( W_FILE	, "EST006" )
aadd( W_FILE	, "EST006" )
aadd( W_FILE	, "EST002" )

select EST006
EST006->( dbsetorder(4) )

EST002->( dbsetorder(1) ) // FORNECEDOR
EST005->( dbsetorder(1) ) // PEDIDO+FORNECEDOR
// EST006->( dbsetorder(1) ) // PEDIDO
EST006->( dbsetrelation( "EST005",{|| EST006->PEDIDO } ) )
EST005->( dbsetrelation( "EST002",{|| EST005->FORNECEDOR } ) )

EST006->( dbseek( W_CHAVE_ITEM + dtoc(ctod('  /  /  '))  ))

TABELA := tabelanew( CAMPO	    , ;
		     MASCARA	    , ;
		     CABECALHO	    , ;
		     TAMANHO	    , ;
		     BESCAPE	    , ;
		     COR	    , ;
		     TITULO	    , ;
		     LININI	    , ;
		     LINFIM	    , ;
		     COLINI	    , ;
		     BLOCK_DISP     , ;
		     CAB_TITULO     , ;
		     BORDA	    , ;
		     COLFIM	    , ;
		     W_FILE	      ;
		   )

CONTINUA := .T.
do while CONTINUA .and. ( (TEC:=tabmov(TABELA)) != K_ESC )

enddo

restscreen(,,,,WSCR )

return

/*
-----------------------------------------------------------------------------

                        OLD_TELA_PED_COMPRA

-----------------------------------------------------------------------------
*/
procedure old_tela_ped_compra()

local OLD_AREA := select()
private W_HEADER := { "Data Prevista  Qtd em KG  Fornecedor" }
//		       XX/XX/XX123456XXX,XXX.XX12XXXXXXXXXXXXXX

select EST005

EST002->( dbsetorder(1) ) // FORNECEDOR
EST005->( dbsetorder(1) ) // PEDIDO+FORNECEDOR
EST006->( dbsetorder(1) ) // PEDIDO
EST006->( dbsetrelation( "EST005",{|| EST006->PEDIDO } ) )
EST005->( dbsetrelation( "EST002",{|| EST005->FORNECEDOR } ) )

P_CAMPOS := {"dtoc(EST006->DT_PREV)+space(6)+STR(EST006->QTD_KG,10,2) + space(2)+" +;
		  "EST002->FGUERRA"}
W_SCR := savescreen( 03, 38, 12, 77 )

if W_CHAVE_ITEM # NIL

    @ 03,38 say ' ีอออออออออ Pedido de Compraออออออออออธ'
    @ 04,38 say ' ณ                                    ณ'
    @ 05,38 say ' ฦออออออออออออออออออออออออออออออออออออต'
    @ 06,38 say ' ณ                                    ณ'
    @ 07,38 say ' ณ                                    ณ'
    @ 08,38 say ' ณ                                    ณ'
    @ 09,38 say ' ณ                                    ณ'
    @ 10,38 say ' ณ                                    ณ'
    @ 11,38 say ' ิออออออออออออออออออออออออออออออออออออพ'
    @ 12,38 say '                                  992'
    sombra( 03,39,11,76)

    EST006->( dbsetfilter( {|| W_CHAVE_ITEM = EST006->FORMA	      +;
					      EST006->TIPO	      +;
					      str(EST006->BIT_MM,8,3) +;
					      str(EST006->ESP_MM,8,3) +;
					      EST006->ESTADO	       ;
					      .and. ;
					      empty( EST006->R_DTPED ) }))

    EST006->( dbgotop() )
    EST006->( dbedit( 04,40,10,75, P_CAMPOS,,,W_HEADER ))

    restscreen( 03, 38, 12, 77, W_SCR )
    EST005->( dbclearrelation() )
else
   message("Escolha o item de estoque primeiro")
end

select (OLD_AREA)
return

/*
-------------------------------------------------------------------------------

                           GERA_PEDIDO

-------------------------------------------------------------------------------
*/
function GERA_PEDIDO( P_CAMPO )
local WRET

dbgobottom()	  //

VAR := &P_CAMPO   // retorna o conteudo do campo
TAM := len( VAR ) // retorna o tamanho

WRET := strzero( val( VAR )+1, TAM) // retorna +1

return WRET

/*
-------------------------------------------------------------------------------
			   POSIC_EST_CONSULTA
-------------------------------------------------------------------------------
*/
procedure posic_est_consulta( P_POS )

EST007->( dbsetorder(1))
EST007->( dbseek( P_POS ))

@ 09,45 say 'Posicao do Estoque `as ' + left( time(), 5 )
@ 11,45 say 'Pecas Inteiras..: ' + str( EST007->QTD_INT, 5 )
@ 12,45 say 'Pecas Cortadas..: ' + str( EST007->QTD_COR, 5 )
@ 13,45 say 'Total em Kg ....: ' + str( EST007->QTD_KGT, 10,2)

return


*- (01) --------------------------------------------------------------------*
* funcao ......: IMP_TELA
* finalidade ..: Mostrar listagem na tela
* parametros ..:
* retorno .....:.T. .or. .F.
* autor .......: Eduardo Pereira Mello
*---------------------------------------------------------------------------*

function imp_tela()

local WRET := .T.

BL_CHAVE_ITEM := space(3)

setcolor( W_COREDIT ) // C_PADRAO

@ 10,24 SAY'ษอออออออออออออออออออออออออออออออออออออออป'
@ 11,24 SAY'บ                                       บ'
@ 12,24 SAY'บ                                       บ'
@ 13,24 SAY'บ                                       บ'
@ 14,24 SAY'บ                                       บ'
@ 15,24 SAY'บ                                       บ'
@ 16,24 SAY'บ                                       บ'
@ 17,24 SAY'ศอออออออออออออออออออออออออออออออออออออออผ'
sombra ( 10,24,17,64)

@ 12,26 prompt "  1 - LISTAR  FORMA                   "
@ 13,26 prompt "  2 - LISTAR  FORMA TIPO e ESTADO     "
@ 14,26 prompt "  3 - LISTAR  FORMA ESTADO TIPO e BIT "
@ 15,26 prompt "  4 - LISTAR  TUDO                    "
MENU TO OP

restscreen(,,,,W_TELA)

do case
   case op=1

      @ 05,16 get X_FORMA    picture "@!"     valid tes_formato()
      @ 11,16 get W_DATA_INI
      @ 11,30 get W_DATA_FIM
      read

      ZERO := 1
      W_CHAVE_ITEM := X_FORMA
      BL_CHAVE_ITEM := {|| X_FORMA=FORMA }

   case op=2

      @ 05,16 get X_FORMA    picture "@!"     valid tes_formato()
      @ 06,16 get X_TIPO     picture "@!"     valid tes_tipo()
      @ 07,16 get X_ESTADO   picture "@!"       valid tes_estado()
      @ 11,16 get W_DATA_INI
      @ 11,30 get W_DATA_FIM
      read

      W_CHAVE_ITEM := ( X_FORMA+X_TIPO+ X_ESTADO  )
      BL_CHAVE_ITEM := {|| X_FORMA+X_TIPO+ X_ESTADO=;
                           FORMA+TIPO+ESTADO }


   case op=3

      if POSICAO = NIL
         POSICAO := 1
      end

      if POSICAO = 1

	 @ 05,16 get X_FORMA	picture "@!"     valid tes_formato()
	 @ 06,16 get X_TIPO	picture "@!"     valid tes_tipo()
	 @ 07,16 get X_ESTADO	picture "@!"     valid tes_estado()
	 @ 08,16 get X_BIT_INT	picture "99"     valid tes_bitola() when T_BIT
	 @ 08,19 get X_BIT_FN	picture "99"     when T_BIT
	 @ 08,22 get X_BIT_FD	picture "99"     valid calc_bit() when T_BIT
	 @ 08,25 get X_BIT_MM	picture "99999.999"   when ( val(X_BIT_INT) + ;
				 val(X_BIT_FN)+val(X_BIT_FD) = 0 ) .and. T_BIT

	 @ 09,16 get X_ESP_INT	picture "99"      valid tes_espessura() when T_LARG
	 @ 09,19 get X_ESP_FN	picture "99"      when T_LARG
	 @ 09,22 get X_ESP_FD	picture "99"      valid calc_esp() when T_LARG
	 @ 09,25 get X_ESP_MM	picture "99999.999" when ( val(X_ESP_INT)+;
				 val(X_ESP_FN)+val(X_ESP_FD) = 0 ) .and. ( T_LARG )

      else

	  @ 09,16 get X_FORMA	 picture "@!"     valid tes_formato(2)
	  @ 10,16 get X_TIPO	 picture "@!"     valid tes_tipo(2)
	  @ 11,16 get X_ESTADO	 picture "@!"     valid tes_estado(2)
	  @ 12,16 get X_BIT_INT  picture "99"     valid tes_bitola(2) when T_BIT
	  @ 12,19 get X_BIT_FN	 picture "99"     when T_BIT
	  @ 12,22 get X_BIT_FD	 picture "99"     valid calc_bit(2) when T_BIT
	  @ 12,25 get X_BIT_MM	 picture "99999.999"   when ( val(X_BIT_INT) + ;
				 val(X_BIT_FN)+val(X_BIT_FD) = 0 ) .and. T_BIT

	  @ 13,16 get X_ESP_INT  picture "99"      valid tes_espessura(2) when T_LARG
	  @ 13,19 get X_ESP_FN	 picture "99"      when T_LARG
	  @ 13,22 get X_ESP_FD	 picture "99"      valid calc_esp(2) when T_LARG
	  @ 13,25 get X_ESP_MM	 picture "99999.999" when ( val(X_ESP_INT)+;
				 val(X_ESP_FN)+val(X_ESP_FD) = 0 ) .and. ( T_LARG )

       end

       @ 11,16 get W_DATA_INI
       @ 11,30 get W_DATA_FIM
       read

       W_CHAVE_ITEM := ( X_FORMA+X_TIPO+X_ESTADO+str( X_BIT_MM,8,3 )+;
			 STR( X_ESP_MM,8,3 )  )

      BL_CHAVE_ITEM := {|| X_FORMA+ X_TIPO+ X_ESTADO+ str(X_BIT_MM,8,3) + str(X_ESP_MM,8,3) =;
                          EST010->FORMA+EST010->TIPO+EST010->ESTADO+;
			 str( EST010->BIT_MM,8,3 )+;
			 str( EST010->ESP_MM,8,3 )  }
   case op=4

      @ 11,16 get W_DATA_INI
      @ 11,30 get W_DATA_FIM
      read

      TUDO := 1

      EST004->( dbgotop() )

 otherwise
 wret := .f.

 endcase

 if lastkey()=K_ESC; WRET := .F. ; end

return WRET


function FCLI_BUSCA()
local getlist := {}
local WRET := 1; WSCRCLI := savescreen(10,19,14,62)

do case
   case lastkey() = K_ESC
      WRET := 0
   case lastkey() = K_ENTER
      WRET := 0
   case lastkey() = K_F5
      WRET := 2

      @ 10,19 say 'ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ'
      @ 11,19 say 'ณ                                          ณ'
      @ 12,19 say 'ณ Nome :                                   ณ'
      @ 13,19 say 'ณ                                          ณ'
      @ 14,19 say 'ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู'

      SETCURSOR(1)
      PNOME := space(50)
      @ 12, 28 get PNOME PICTURE "@S32"
      read
      SETCURSOR(0)
      keyboard chr(7)
      VEN001->( dbseek( alltrim( PNOME ) ) )

endcase


restscreen(10,19,14,62,WSCRCLI )

return WRET


*- (01) --------------------------------------------------------------------*
* funcao ......: ACES_NIVEL
* finalidade ..: Nivel de acesso
* parametros ..:
* retorno .....:
* autor .......:
*---------------------------------------------------------------------------*
function ACES_NIVEL(P_ROTINA)
local WRET := .F., PUSER_NIVEL := PROT_NIVEL := 0

   ROTINA->( dbseek( P_ROTINA ))
   if ROTINA->( found() )

      DIREITO->( dbseek( C_ACESSO+P_ROTINA ))
      if DIREITO->( found() )
         WRET := .T.
      end
   end

return WRET

function VER_NIVEL()

local WRET := 0, ;
      W_OLDSCR := savescreen(10,13,16,41),;
      W_OLDCOR := setcolor()


   abrir("EST000")
   abrir("EST999")

   setcolor(W_CORWIND )
   @ 10,17 say 'ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ'
   @ 11,17 say 'ณ ACESSO :              ณ'
   @ 12,17 say 'ณ SENHA .:              ณ'
   @ 13,17 say 'ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู'

   W_ACESSO := space(7)
   @ 11,27 get W_ACESSO picture "@!" valid ! empty( W_ACESSO )
   read
   if lastkey() <> K_ESC
      W_SENHA  := get_senha(6,12,27)

      setcolor( W_CORWIND )

      EST000->( dbseek( W_ACESSO ) )
      if EST000->( found())
	 if W_SENHA = descript( EST000->SENHA )
	    WRET := val( descript(EST000->NIVEL))
	 end
      end
   end
   restscreen(10,13,16,41,W_OLDSCR )
   setcolor( W_OLDCOR )
   EST000->( dbclosearea() )
   EST999->( dbclosearea() )

return WRET

procedure CABECALHO( P_CABEC )

   @ 02,02 say 'ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ'
   @ 03,02 say 'ณ                                                                          ณ'
   @ 04,02 say 'ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู'
   @ 03,20 say P_CABEC

return

/*
-----------------------------------------------------------------------------
		      Procedimento RELCABTN
-----------------------------------------------------------------------------
*/
procedure relcabtn( P_PAG, P_TAM, P_CABEC )

   P_TAM := if( P_TAM=NIL, 78, P_TAM)

   @ 01      , 00 say replicate('-', P_TAM )
   @ prow()+1, 00 say '   TENAX Aos Especiais'
   @ prow()  , P_TAM-33 say 'Data: ' + dtoc(date())
   @ prow()  , P_TAM-13 say 'Pag.: ' + strzero(P_PAG,3)
   @ prow()+1, 05 say if( P_CABEC=NIL,'',P_CABEC )
   @ prow()+1, 00 say replicate('-', P_TAM )


return

/*
-----------------------------------------------------------------------------
		      Procedimento totrealped

Objetivo : Retornar a quantidade pedida encontrada.
-----------------------------------------------------------------------------
*/
function totrealped( P_CHAVE_ITEM )

local WRET := 0

   EST006->( dbsetorder(4) )

   /*

   W_CHAVE_ITEM = EST007->FORMA 	  +;
		  EST007->TIPO		  +;
	     str( EST007->BIT_MM,8,3)	  +;
	     str( EST007->ESP_MM,8,3)	  +;
		  EST007->ESTADO

   */

   EST006->( dbseek( P_CHAVE_ITEM + dtoc(ctod('  /  /  '))  ))

   while  P_CHAVE_ITEM = EST006->FORMA		 +;
			 EST006->TIPO		 +;
		    str( EST006->BIT_MM,8,3)	 +;
		    str( EST006->ESP_MM,8,3)	 +;
			 EST006->ESTADO    .and. +;
		  empty( EST006->R_DTPED )

      WRET += EST006->QTD_KG
      EST006->( dbskip() )
   end

return WRET

/*
-----------------------------------------------------------------------------

                          TES_STA_PED

-----------------------------------------------------------------------------
*/
func tes_sta_ped(var)

if empty(var)
   message('Campo Obrigatorio')
   return .f.
end

if var == 'P'
   return .t.
else
   if var == 'R'
      return .t.
   else
      message ('Status do Pedido Invalido')
      return .f.
   end
end

db_dat_ped := var
db_dat_ent := var_ent_05
db_sta_ped := var

return .t.

/*
-----------------------------------------------------------------------------

                      Funcao SEQ_DETALHE

-----------------------------------------------------------------------------
*/
function SEQ_DETALHE( VAR )

   local W_SEQ := 0

   EST006->( dbsetorder (2) )
   EST006->( dbseek( VAR) )

   while !(EST006->(EOF())) .and. VAR = EST006->PEDIDO
      W_SEQ := EST006->SEQUENC
      EST006->( dbskip() )
   enddo

   W_SEQ++

return W_SEQ

*---------------------------------------------------------------------------*
* >>>>>>>>>>>>>>>>>>>>>>>>>>>  F U N C A O <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<< *
*                                                                           *
* Sistema...:                                                               *
* Modulo....:                                                               *
* Descricao.: Conjunto de rotinas e funcoes comuns a todos os modulos       *
* Chamador..: *                                                             *
* Chamados..: *                                                             *
*---------------------------------------------------------------------------*
* Cliente...:                                                               *
* Analistas.: Daniel Luiz Guimaraes Machado                                 *
* Autor.....: Daniel Luiz Guimaraes Machado                                 *
* Inicio....: 01/08/93                                                      *
*---------------------------------------------------------------------------*


*---------------------------------------------------------------------------*
* Procedimento :
* Finalidade ..:
* Parametros ..:
* Autor .......: Daniel Luiz Machado
*---------------------------------------------------------------------------*
PROCEDURE status( PMSG )
local P_OLDCOR := setcolor()
   // setcolor( W_PDCOR )
   // @ 23,03 SAY '> '+pMsg
   // setcolor( P_OLDCOR  )

RETURN

*---------------------------------------------------------------------------*
* Procedure ...: conf
* Finalidade ..:
* Parametros ..:
* Autor .......: Daniel Luiz Guimaraes Machado
*---------------------------------------------------------------------------*
function conf( MSG, IMP )
static WTOP, WLEFT
private WRET := "*"
private  WBOTTOM, WRIGHT, WRET := .T., WVAR := " ", WMEIO, getlist := {}
private  W_OLDCOR := setcolor(); W_OLDCURS := setcursor()
set cursor on

MSG := MSG +"(S/N) ?"

WTOP    := 10
WLEFT   := int( (80-len( MSG ))/2 )
WBOTTOM := WTOP + 4
WRIGHT  := WLEFT + len(MSG) + 3
WMEIO   := WLEFT + 2

setcolor( W_CORPERG  )
ssavT := savescreen( WTOP, WLEFT, WBOTTOM+1, WRIGHT+1 )
ssav := savescreen( WTOP, WLEFT, WBOTTOM, WRIGHT )

_box(WTOP,WLEFT,WBOTTOM,WRIGHT,"EX")
sombra( WTOP,WLEFT, WBOTTOM, WRIGHT )

@ WTOP+2, WMEIO say MSG

WHAT_WALK := savescreen( WTOP, WLEFT, WBOTTOM, WRIGHT )

while .t.
   // setcolor( "W/B,W+/BG,N/N,N/N,N/W" ) // C_PADRAO
   @ WTOP+2, WRIGHT-2 say ''
   inkey(0)

   do case
   case lastkey()=5 // cima

      if WTOP > 0
        restscreen( WTOP, WLEFT, WBOTTOM+1, WRIGHT+1, SSAVT )
        WTOP--
        WBOTTOM--
        ssav := savescreen( WTOP, WLEFT, WBOTTOM, WRIGHT )
        ssavT := savescreen( WTOP, WLEFT, WBOTTOM+1, WRIGHT+1 )
        restscreen( WTOP, WLEFT, WBOTTOM, WRIGHT, WHAT_WALK )
        sombra( WTOP,WLEFT, WBOTTOM, WRIGHT )
      end

   case lastkey()=24 // baixo

      if WBOTTOM < 23
        restscreen( WTOP, WLEFT, WBOTTOM+1, WRIGHT+1, SSAVT )
        WTOP++
        WBOTTOM++
        ssav := savescreen( WTOP, WLEFT, WBOTTOM, WRIGHT )
        ssavT := savescreen( WTOP, WLEFT, WBOTTOM+1, WRIGHT+1 )
        restscreen( WTOP, WLEFT, WBOTTOM, WRIGHT, WHAT_WALK )
        sombra( WTOP,WLEFT, WBOTTOM, WRIGHT )
      end

   case lastkey()=4 // direita

      if WRIGHT < 78
        restscreen( WTOP, WLEFT, WBOTTOM+1, WRIGHT+1, SSAVT )
        WLEFT++
        WRIGHT++
        ssav := savescreen( WTOP, WLEFT, WBOTTOM, WRIGHT )
        ssavT := savescreen( WTOP, WLEFT, WBOTTOM+1, WRIGHT+1 )
        restscreen( WTOP, WLEFT, WBOTTOM, WRIGHT, WHAT_WALK )
        sombra( WTOP,WLEFT, WBOTTOM, WRIGHT )
      end

   case lastkey()=19 // esquerda
      if WLEFT > 0
        restscreen( WTOP, WLEFT, WBOTTOM+1, WRIGHT+1, SSAVT )
        WLEFT--
        WRIGHT--
        ssav := savescreen( WTOP, WLEFT, WBOTTOM, WRIGHT )
        ssavT := savescreen( WTOP, WLEFT, WBOTTOM+1, WRIGHT+1 )
        restscreen( WTOP, WLEFT, WBOTTOM, WRIGHT, WHAT_WALK )
        sombra( WTOP,WLEFT, WBOTTOM, WRIGHT )
      end

   case chr( lastkey() ) = "S" .or. chr( lastkey() ) = "s"
      WRET := .T.
      exit

   case chr( lastkey() ) = "N" .or. chr( lastkey() ) = "n"
      WRET := .F.
      exit
   endcase
end

restscreen( WTOP, WLEFT, WBOTTOM+1, WRIGHT+1, SSAVT )
setcursor( W_OLDCURS )
setcolor( W_OLDCOR )

return WRET


PROCEDURE zerofill( PVAR ) // strzero
local WRET

   WRET := strzero( val( PVAR ), len( PVAR ) )

RETURN WRET


PROCEDURE message(pMsg)
   local W_COR := setcolor()
   setcolor( W_PDCOR )
   @ 23,04 CLEAR to 23,78
   @ 23,03 SAY '> '+pMsg
   setcolor( W_COR )
RETURN

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

*---------------------------------------------------------------------------*
* Funcao ......: MEIASOMBRA
* Finalidade ..:
* Parametros ..:
* Retorno .....:
* Autor .......:
*---------------------------------------------------------------------------*
function meiasombra( tw, lw, bw, rw )
   local W_OLDCOR := setcolor()

   setcolor(W_COREDIT) //("N/BG")
   for X:=LW+1 to RW+1
      @ BW+1,X say '฿'
   next

   for X:=TW to BW
      @ X,RW+1 say 'Ü'
   next

   setcolor( W_OLDCOR )
return NIL




PROCEDURE encripta( )
RETURN

PROCEDURE decripta( )
RETURN

PROCEDURE recchoice( )
RETURN




// ---------------------------------------------------------
// ---------------------------------------------------------
// ---------------------------------------------------------
// ---------------------------------------------------------
// ---------------------------------------------------------
// ---------------------------------------------------------
// ---------------------------------------------------------
// ---------------------------------------------------------
// ---------------------------------------------------------
// ---------------------------------------------------------
// ---------------------------------------------------------
// ---------------------------------------------------------
// ---------------------------------------------------------
// ---------------------------------------------------------
// ---------------------------------------------------------
// ---------------------------------------------------------
// ---------------------------------------------------------
// ---------------------------------------------------------
// ---------------------------------------------------------

*------------------------------------*
function socorro1
message(' <F3>  Inclui    ',;
	' <F4>  Altera    ',;
	' <F5>  Exclui    ',;
	' <F6>  Consulta  ')
set curso off
return nil

*------------------------------------*
function help( prog, lin )

if prog == "GET_17" .or. prog == "ITEM_C_GET"  // apresenta mensagem apenas nos gets
   message(' <F7>  Pecas Cortadas   ',;    // do item de estoque ou em consulta
	   ' <F8>  Pedido de Compra ' )
else
   message(' <F3>  Inclui    ',;
	   ' <F4>  Altera    ',;
	   ' <F5>  Exclui    ',;
	   ' <F6>  Consulta  ')
end

set curso off
return nil

/* =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= */
Function wsave(lin1,col1,lin2,col2)
lin1:=if(valtype(lin1)!="N",0,lin1)
col1:=if(valtype(col1)!="N",0,col1)
lin2:=if(valtype(lin2)!="N",maxrow(),lin2)
col2:=if(valtype(col2)!="N",maxcol(),col2)
return str(lin1,2)+str(col1,2)+str(lin2,2)+str(col2,2)+;
       savescreen(lin1,col1,lin2,col2)


/* =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= */
Function wrest(telar)
RestScreen(val(substr(telar,1,2)),val(substr(telar,3,2)),;
	   val(substr(telar,5,2)),val(substr(telar,7,2)),;
	   substr(telar,9))
return nil


/* =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= */
Function at_next(var,texto,pos)
local valat:=0,z,pos_atu
pos:=if(valtype(pos)!="N",1,pos)
for z:=1 to pos
   pos_atu := at(var,texto)
   if pos_atu==0
      return 0
   endif
   valat+=pos_atu
   texto := substr(texto,pos_atu+1)
next
return valat
/*
	 1	   2	     3	       4
123456/890123/567890123456/8901234567890
*/


/* =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= */
Function wbox(lin1,col1,titulo,texto,opcao,vborda)
local i,tamtxt:=0,colant:=0,topc:=" ",tela,resp:=0,;
      lin2:=if(valtype(texto)=="A",len(texto)+1,2),;
      col2:=if(valtype(titulo)=="C",len(titulo)+4,0)
vborda:=if(valtype(vborda)=="U","ษอปบผอศบ ",vborda)

for i:=1 to len(opcao)
   topc+=alltrim(opcao[i])+"~~"
next
topc:=substr(topc,1,len(topc)-1)
col2:=if(col2>len(topc)+1,col2,len(topc)+1)
if valtype(texto)=="A"
   for i:=1 to len(texto)
      col2:=if(col2>len(alltrim(texto[i]))+2,col2,len(alltrim(texto[i]))+2)
   next
elseif valtype(texto)=="C"
   col2:=if(col2>len(alltrim(texto))+2,col2,len(alltrim(texto))+2)
endif
lin2+=2
lin1:=if(valtype(lin1)=="C",int(11-(lin2/2)),lin1)
col1:=if(valtype(col1)=="C",int(40-(col2/2)),col1)

tela := wsave(lin1,col1,lin1+lin2+1,col1+col2+2)

dispbox(lin1,col1,lin1+lin2,col1+col2,vborda)
sombra(lin1,col1,lin1+lin2,col1+col2)

if valtype(titulo)=="C"
   resp:=((col2+1-len(titulo))/2)+col1
   @ lin1,resp-1	   say if(substr(vborda,2,1)=="อ","ต","ด")
   @ lin1,resp		   say titulo color c_wtitle
   @ lin1,resp+len(titulo) say if(substr(vborda,2,1)=="อ","ฦ","ร")
endif
if valtype(texto)=="A"
   for i:=1 to len(texto)
      if tamtxt<len(texto[i])
	 tamtxt:=len(texto[i])
      endif
      @ lin1+i,col1+2 say texto[i]
   next
elseif valtype(texto)=="C"
   resp:=((col2+1-len(texto))/2)+col1+1
   tamtxt:=len(texto)
   @ lin1+1,resp say texto
endif

resp:=1
if tamtxt<len(topc)
   col2:=2
else
   col2:=((col2-len(topc))/2)+2
endif
for i:=1 to len(opcao)
   @ lin1+lin2-1,col1+col2 prompt alltrim(opcao[i])
   col2+=at_next("~~",topc,i)
next
menu to resp
wrest(tela)
return resp

*___________________________________________*
Function tst_dt(data_)
 Private ret_dt:=.F.
 if valtype(data_)="D" ; data_:=dtoc(data_) ; end
 if alltrim(data_)="/  /" .or. empty(data_)
    return .t.
 end
 dd:=val(substr(data_,1,2)) ; mm:=zerofill(SUBSTR(data_,4,2))
 aa:=zerofill(SUBSTR(data_,7,2))
 if !empty(aa)
    if mm$"01,03,05,07,08,10,12"
       if dd<=31 .and. dd>0 ; ret_dt:=.t. ; end
    elseif mm$"04,06,09,11"
       if dd<=30 .AND. dd>0 ; ret_dt:=.t. ; end
    elseif mm$"02"

       if aa%4=0   // int(val(aa)/4)=val(aa)/4	 // Ano Bissexto
	  if dd<=29 .and. dd>0 ; ret_dt:=.t. ; end
       else
	  if dd<=28 .AND. dd>0 ; ret_dt:=.t. ; end
       end
    end
 end
 if !ret_dt ; message('Data invalida!!') ; end
 return ret_dt



/* =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= */
Function ScreenSys(atela,wvezes,wnome,wbeep)
Local lin:=3,col,x,wtam:=0,wnum,wlimite,wcolnome,wpara1,wtime:=0.09
if valtype(wbeep)='U' ; wbeep:=.f. ; end
wnum:=len(atela)
for x:=1 to wnum
   if wtam<len(atela[x])
      wtam:=len(atela[x])
   end
next
col:=(80-wtam)/2
setcursor(0)
for x:=1 to wnum
   @ lin+x-1,col say atela[x]
next
for lin:=3 to wvezes
   scroll(lin,col,lin+wnum,col+wtam,-1)
   if wbeep
*      tone(500)
   else
       inkey(wtime)
   end
next
wlimite:=col-2
wlimite:=wlimite-3
wcolnome:=(80-len(wnome))/2
for x:=1 to wlimite
   dispbox(if(lin-2-x>2,lin-2-x,2),col-(2+x),if(lin+lin+1+x<22,lin+lin+1+x,22),col+wtam+1+x,"       ")
   dispbox(if(lin-3-x>2,lin-3-x,2),col-(3+x),if(lin+lin+2+x<22,lin+lin+2+x,22),col+wtam+2+x)
   @ lin+wnum+1,wcolnome say wnome
   if wbeep
      if x==wlimite
*	  tone(700)
      else
*	  tone(500)
	inkey(.1)
      end
   else
      inkey(wtime)
   end
next
setcursor(1)
return nil

/* =-=-=-=-=-=-=-= */
FUNCTION editar(ee,linha,coluna)
// Funcao para ser usada com memoedit
******************************************
 ret_val = 0
 IF ee == 3
    ret_val=initstat()
 ELSE
    ret_val=tecexcecao()
 end
 @ 20,16 say "Linha "+str(linha,3)+" Coluna "+str(coluna,3)
 RETU ret_val

***
* tecexcecao()
* PROCESSA TECLAS DA FUNCAO EDITAR
***
FUNC tecexcecao
PRIV teclas
teclas = LASTKEY()
IF teclas = 28	 // F1
   message(' <F1>    Aciona Ajuda     ',;
	   ' <F2>    Finaliza         ',;
	   ' <PgUp>  Avanca Pagina    ',;
	   ' <PgDn>  Retrocede Pagina ')
   ret_val:=22
elseif lastkey()==27
   opcal  :={"Gravar","No Gravar"}
   atext2 :='Sair do Texto:'

   opcal:=wbox("C","C",,atext2,opcal,"ีอธณพอิณ ")
   if lastkey()==27
      ret_val:=22
   end
   if opcal==1
      keyb chr(23)
      ret_val:=22
   end

elseif teclas==22
   ins_on:=set(29)
   ret_val=22
   if !ins_on
      @20,58 say 'ตInsฦ'
   else
      @20,58 say 'อออออ'
   end
end
RETU ret_val
***
* initstat()
*
FUNC initstat
IF init_count == 1
   // READINSERT(.F.)
   set(29,.f.)
   ins_mode=set(29) // READINSERT()
   IF (ins_on .AND. !ins_mode) .OR. (!ins_on .AND. ins_mode)
      ret_val=22
   ELSE
      init_count=2
   end
ELSE
   ret_val=0
end
RETU ret_val
***
* tecexcept()
* PROCESSA TECLAGENS
***
FUNC tecexcept
PRIV teclas
teclas = LASTKEY()
line_num=linha
col_num=coluna
IF teclas == 22
   READINSERT(.T.)
   ins_on=READINSERT()
   ret_val=22
end
RETU ret_val

// FORMULAS



/*
	 W_TOTAL += (EST006->VAL_KG * EST006->QTD_KG			   ) + ;
		    (EST006->VAL_KG * EST006->QTD_KG * EST006->IPI/100	   ) + ;
		    (EST006->VAL_KG * EST006->QTD_KG * (19 - EST006->ICMS)/100 ) + ;
		    (EST006->FRETE  * EST006->QTD_KG			   ) + ;
		    (EST006->VAL_KG * EST006->QTD_KG * EST006->OUTRATX/100 )
*/


/*
-----------------------------------------------------------------------------
		      Procedimento CabGeral
-----------------------------------------------------------------------------
*/
procedure cabgeral( P_TITULO )

    @ 01      , 00 say WTRACO80
    @ prow()+1, 00 say '   TENAX Aos Especiais'
    @ prow()  , 52 say 'Data: ' + dtoc(date())
    @ prow()  , 70 say 'Pag.: ' + strzero(++NUMPAG,2) + '  '
    @ prow()+1, 00 say '                                                   Per :'
    @ prow()  , 57 say dtoc(W_DATA_INI)+' `a'
    @ prow()  , 69 say dtoc(W_DATA_FIM)+'   '
    @ prow()+1, 04 say P_TITULO

return

/*
-----------------------------------------------------------------------------
                      Funcao TES_CODBANCO
-----------------------------------------------------------------------------
*/
function tes_CODBANCO( LIN,COL,TAM )

   local WRET := .T.

   TAM := if(TAM=NIL, len(CR0100->DESCRICAO), TAM )

   X_CODBANCO := zerofill(X_CODBANCO)

   CR0100->( dbsetorder(1) )
   CR0100->( dbseek( X_CODBANCO ) )

   if CR0100->( ! found() )  .or. X_CODBANCO = "000"
      m_tabelas("X_CODBANCO")
      if lastkey() = K_ESC
	 WRET := .F.
      end
   else
      WRET := .T.
   end

   if LIN # NIL
      @ LIN     , COL         say        X_CODBANCO
      @ LIN     , COL     + 4 say '- ' + left(CR0100->DESCRICAO,TAM)
   else
      @ 04,26 say X_CODBANCO
      @ 04,28 say left(CR0100->DESCRICAO,TAM)
  end

return WRET

/*
-----------------------------------------------------------------------------
                      Funcao TES_CODAGENCIA
-----------------------------------------------------------------------------
*/
function tes_CODAGENCIA( LIN,COL,TAM )

   local WRET := .T.

   TAM := if(TAM=NIL, len(CR0200->DESCRICAO), TAM )

   X_CODAGENCIA := zerofill(X_CODAGENCIA)

   CR0200->( dbsetorder(1) )
   CR0200->( dbseek( X_CODAGENCIA ) )

   if CR0200->( ! found() )  .or. X_CODAGENCIA = "000"
      m_tabelas("X_CODAGENCIA")
      if lastkey() = K_ESC
	 WRET := .F.
      end
   else
      WRET := .T.
   end

   if LIN # NIL
      @ LIN     , COL         say        X_CODAGENCIA
      @ LIN     , COL     + 4 say '- ' + left(CR0200->DESCRICAO,TAM)
   else
      @ 04,26 say X_CODAGENCIA
      @ 04,28 say left(CR0200->DESCRICAO,TAM)
  end

return WRET

/*
-----------------------------------------------------------------------------
                         funcao  ESPI_ALT
-----------------------------------------------------------------------------
*/
procedure espi_alt()
local TEC

WRET := pergresp( 'Alterar/ Excluir/ Retornar (A/E/R) ? ','AER')

do case
case WRET = 'A'
   WRET := "A"
case WRET = 'E'
   WRET := "E"
case WRET = 'R'
   WRET := "*"
endcase

return ( WRET )

