/*

   SCM - Sistema de Controle Metalurgico
   EST92.PRG - Rotinas Utilitarias do Sistema de Estoque

*/

#include "inkey.ch"
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
      case P_FILE = "VEN001"
         use VEN001  index  VEN00101,VEN00102             shared new
      case P_FILE = "VEN002"
         use VEN002  index  VEN00201                      shared new
      case P_FILE = "VEN003"
         use VEN003  index  VEN00301, VEN00302, VEN00303  shared new
      case P_FILE = "VEN004"
         use VEN004  index  VEN00401, VEN00402            shared new
      case P_FILE = "VEN005"
         use VEN005  index  VEN00501                      shared new
      case P_FILE = "VEN006"
         use VEN006  index  VEN00601, VEN00602, VEN00603, VEN00604 shared new
      case P_FILE = "VEN007"
         use VEN007  index  VEN00701                      shared new
      case P_FILE = "VEN008"
         use VEN008  index  VEN00801                      shared new
      case P_FILE = "VEN009"
         use VEN009  index  VEN00901                      shared new
      case P_FILE = "VEN010"
         use VEN010  index  VEN01001                      shared new
      case P_FILE = "VEN011"
         use VEN011  index  VEN01101                      shared new
      case P_FILE = "VEN012"
         use VEN012  index  VEN01201                      shared new
      case P_FILE = "VEN013"
         use VEN013  index  VEN01301                      shared new
      case P_FILE = "VEN014"
         use VEN014  index  VEN01401                      shared new
      case P_FILE = "VEN015"
         use VEN015  index  VEN01501                      shared new
      case P_FILE = "VEN016"
         use VEN016  index  VEN01601, VEN01602            shared new
      case P_FILE = "VEN017"
         use VEN017  index  VEN01701                      shared new
      case P_FILE = "VEN018"
         use VEN018  index  VEN01801                      shared new
      case P_FILE = "VEN019"
         use VEN019  index  VEN01901                      shared new
      case P_FILE = "VEN020"
         use VEN020  index  VEN02001                      shared new
      case P_FILE = "VEN021"
         use VEN021  index  VEN02101                      shared new
      case P_FILE = "VEN099"
         use VEN099                                       shared new

      case P_FILE = "EST000"
         use EST000  index  EST00001                      shared new
      case P_FILE = "EST001"
         use EST001  index  EST00101                      shared new
      case P_FILE = "EST002"
         use EST002  index  EST00201, EST00202            shared new
      case P_FILE = "EST003"
         use EST003  index  EST00301                      shared new
      case P_FILE = "EST004"
         use EST004  index  EST00401, EST00402            shared new
      case P_FILE = "EST005"
         use EST005  index  EST00501                      shared new
      case P_FILE = "EST006"
         use EST006  index  EST00601, EST00602, EST00603  shared new
      case P_FILE = "EST007"
         use EST007  index  EST00701, EST00702            shared new
      case P_FILE = "EST008"
         use EST008  index  EST00801, EST00802, EST00803  shared new
      case P_FILE = "EST009"
         use EST009  index  EST00901                      shared new
      case P_FILE = "EST010"
         use EST010  index  EST01001, EST01002            shared new
      case P_FILE = "EST011"
         use EST011  index  EST01101                      shared new
      case P_FILE = "EST031"
         use EST031  index  EST03101                      shared new

   endcase
end
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
   local P_HDSEP := "หอ", P_COLSEP := "-"
   local W_OLDCOR := W_CORWIND := setcolor()

   setcolor( W_CORWIND )
   do case
      case readvar() = "X_FORMA"

	 P_SCR := savescreen(06,17,24,55)
	 @ 06, 24 say "ีออออออออออ Formas ออออออออออธ"
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

	 P_HEADER := {" Cod   Descricao                " }
         P_CAMPOS := { "' '+EST003->FORMA+' - '+EST003->DESCRICAO+' '"}
         EST003->( dbgotop() )
         EST003->( dbedit(07,25,15,52,P_CAMPOS,,, P_HEADER, P_HDSEP, P_COLSEP))
         restscreen(06,17,24,55,P_SCR)
         if lastkey() != 27
            X_FORMA     := EST003->FORMA
            X_DESCRICAO := EST003->DESCRICAO
         end

      case readvar() = "X_BIT_INT"

         EST003->( dbsetorder(1) )
         EST003->( dbseek( X_FORMA ))

         if EST003->P_MATERIAL = 2


            // -----------------------------
            // -----------------------------
            // -----------------------------
            // -----------------------------

            // alterar - colocar mais campos

            // -----------------------------
            // -----------------------------
            // -----------------------------
            // -----------------------------
            // -----------------------------
            // -----------------------------

            P_SCR := savescreen(06,17,24,75)
            @ 06, 24 say "ีออออออออออออออ Bitola / Espessura ออออออออออออออธ"
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

            P_HEADER := { space(3)+ 'Pol.'+space(9)+ 'MM' +space(6)+ 'Kg Total' }

            P_CAMPOS := { "' '+EST007->BIT_INT+' '+EST007->BIT_FN+'/'+EST007->BIT_FD+' ->' + " +;
                          "str( EST007->BIT_MM, 8, 3 ) + str(EST007->QTD_KGT,12,2) "+;
                          "EST007->ESP_INT+' '+EST007->ESP_FN+'/'+EST007->BIT_FD+' ->'      "}

            EST007->( dbsetfilter( {|| EST007->FORMA = X_FORMA .and.;
                                       EST007->TIPO  = X_TIPO  .and.;
                                       EST007->ESTADO= X_ESTADO } ) )
            EST007->( dbgotop() )
            EST007->( dbedit(07,25,15,72,P_CAMPOS,,, P_HEADER, P_HDSEP, P_COLSEP))
            EST007->( dbclearfilter() )
            restscreen(06,17,24,75,P_SCR)
            if lastkey() != 27
               X_BIT_INT := EST007->BIT_INT
               X_BIT_FN  := EST007->BIT_FN
               X_BIT_FD  := EST007->BIT_FD
               X_BIT_MM  := EST007->BIT_MM
               keyboard chr(13) + chr(13)
            end

         else

            P_SCR := savescreen(06,17,24,75)
            @ 06, 24 say "ีออออออออออออออ Bitola / Espessura ออออออออออออออธ"
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

            P_HEADER := { space(3)+ 'Pol.'+space(9)+ 'MM' +space(6)+ 'Kg Total' }

            P_CAMPOS := { "' '+EST007->BIT_FN+'/'+EST007->BIT_FD+' ->' + " +;
                          "str( EST007->BIT_MM, 8, 3 ) + str(EST007->QTD_KGT,12,2) "}
            EST007->( dbsetfilter( {|| EST007->FORMA = X_FORMA .and.;
                                       EST007->TIPO  = X_TIPO  .and.;
                                       EST007->ESTADO= X_ESTADO } ) )
            EST007->( dbgotop() )
            EST007->( dbedit(07,25,15,72,P_CAMPOS,,, P_HEADER, P_HDSEP, P_COLSEP))
            EST007->( dbclearfilter() )
            restscreen(06,17,24,75,P_SCR)
            if lastkey() != 27
               X_BIT_INT := EST007->BIT_INT
               X_BIT_FN  := EST007->BIT_FN
               X_BIT_FD  := EST007->BIT_FD
               X_BIT_MM  := EST007->BIT_MM
               keyboard chr(13) + chr(13)
            end
         end

      case readvar() = "X_ESP_INT"

         P_SCR := savescreen(06,17,24,75)
         @ 06, 24 say "ีอออออออออออออออ Largura / Bitola อออออออออออออออธ"
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

         P_HEADER := { space(3)+ 'Pol.'+space(9)+ 'MM' +space(6)+ 'Kg Total' }
         P_CAMPOS := { "' '+TIRA_ZERO('ESP')+EST007->ESP_FN+'/'+EST007->ESP_FD+' ->'+"+;
                       "str( EST007->ESP_MM, 8, 3 ) + space(3)+ str(EST007->QTD_KGT,12,2) "}
         EST007->( dbsetfilter( {|| EST007->FORMA  = X_FORMA   .and.;
                                    EST007->TIPO   = X_TIPO    .and.;
                                    EST007->ESTADO = X_ESTADO  .and.;
                                    EST007->BIT_INT= X_BIT_INT .and.;
                                    EST007->BIT_FN = X_BIT_FN  .and.;
                                    EST007->BIT_FD = X_BIT_FD  .and.;
                                    EST007->BIT_MM = X_BIT_MM } ) )
         EST007->( dbgotop() )
         EST007->( dbedit(07,25,15,72,P_CAMPOS,,, P_HEADER, P_HDSEP, P_COLSEP))
         EST007->( dbclearfilter() )
         restscreen(06,17,24,75,P_SCR)
	 if lastkey() != 27
            X_ESP_INT := EST007->ESP_INT
            X_ESP_FN  := EST007->ESP_FN
            X_ESP_FD  := EST007->ESP_FD
            X_ESP_MM  := EST007->ESP_MM
            keyboard chr(13) + chr(13)
	 end

      case readvar() == "X_TIPO"

	 P_SCR := savescreen(05,15,17,67)
	 @ 05, 15 say "ีออออออออออออออออ Tipo de Material อออออออออออออออธ"
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

	 P_HEADER := {"  Cod   Est        Descricao             Cor      "}

         P_CAMPOS := {" ' '+EST004->TIPO      +'  '                              "+;
                      "    +EST004->ESTADO    +' '    +EST004->DESCRICAO +' '    "+;
                      "    +EST004->COR       +' '                               "}

         EST004->( dbsetfilter( {|| EST004->FORMA = P_COND } ) )
	 EST004->( dbgotop() )

         EST004->( dbedit(06,16,15,64,P_CAMPOS,,, P_HEADER, P_HDSEP, P_COLSEP))
         EST004->( dbclearfilter() )

	 restscreen(05,15,17,67,P_SCR)
	 if lastkey() != 27
            X_TIPO    := EST004->TIPO
	 end

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
         VEN001->( dbedit(07,25,15,72,P_CAMPOS,,,P_HEADER, P_HDSEP, P_COLSEP) )
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

*                        Lote     Data   Qtd.Pecas        Qtd.Kg      Valor Total
*                        xxxxx  xxxxxxxx   xxxxxxx  xxxxxxxxxxxx  xxxxxxxxxxxxxxx

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
   setcolor( W_OLDCOR )

return NIL

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

   X_ESTADO := EST004->ESTADO

   if POSICAO = 1
      @ 06,16 say X_TIPO     picture '@!'
      @ 06,24 say EST004->DESCRICAO   picture  '@!'
      @ 07,16 say X_ESTADO  picture '@!'
   else
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
function tes_codcli( POSICAO, P_LIN, P_COL, P_TAM )

   local WRET := .T.

   P_TAM := if(P_TAM=NIL, len( VEN001->RAZAO ), P_TAM )

   VEN001->( dbsetorder(1) )
   VEN001->( dbseek( POSICAO ) )

   if VEN001->( ! found() )
      m_tabelas( X_CODCLI )
      if lastkey()=27
          WRET := .F.
      end
   end
   if ! empty (P_LIN)
      @ P_LIN, P_COL+7 say '- '+ left( VEN001->RAZAO, P_TAM )
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

   X_FORMA   := left ( VAR, 3    )
   X_TIPO    := subst( VAR, 4, 5 )
   X_ESTADO  := right( VAR, 1    )

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

   @ 13,28 say X_TIPOMOVI        picture '@!'
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

   EST002->( dbsetorder(1) )
   EST002->( dbseek( VAR ) )

   if EST002->( ! found() ) .or. empty( VAR )
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
         FD   := X_BIT_FD

   local W_BITCM := FRES := 0.00

   if POSICAO = NIL
      POSICAO := 1
   end

   // Calcula Bitola em MM atraves da medida em Polegada, so' se ela nao existir
   if X_BIT_MM <= 0
      FINT := val( FINT ); FN := val( FN ); FD := val( FD )
      FRES := FINT +( FN/ FD)
      W_BITCM  := 2.54 * FRES * 10
      X_BIT_MM := W_BITCM
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
         FD   := X_ESP_FD

   local W_BITCM := FRES := 0.00

   if POSICAO = NIL
      POSICAO := 1
   end

   FINT := val( FINT ); FN := val( FN ); FD := val( FD )

   FRES := FINT +( FN/ FD)

   W_BITCM := 2.54 * FRES * 10
   X_ESP_MM := W_BITCM

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

   status ( 'Escolha Opcao Desejada Alteracao / Exclusao ' )
   @ 24,41 prompt "Alteracao"
   @ 24,53 prompt "Exclusao"
   menu to TEC

   do case
   case TEC = 1
      WRET := "A"
   case TEC = 2
      WRET := "E"
   case TEC = 0  // ESC
      WRET := "*"
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


/******************************************************************************
                          Get da chave principal
*******************************************************************************/

procedure GET_MAINKEY(POSICAO)

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

function movimentacao( P_BUSCA )
   local WRET := .F.

   EST010->( dbsetorder(1))
   EST010->( dbseek( P_BUSCA ))
   if EST010->( found() )
      WRET := .T.
   else
      WRET := .F.
   end
return WRET

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

****************************
function calc_total( W_PEDTOT, POSICAO )
****************************
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

         if ! empty( EST006->R_DTPED )  // Calcula apenas o total
            EST006->( dbskip() )      // dos pedidos pendentes
            loop
         end

         W_STOTAL := (EST006->VAL_KG * EST006->QTD_KG                       ) + ;
                     (EST006->VAL_KG * EST006->QTD_KG * EST006->OUTRATX/100 )

         W_TOTAL +=  W_STOTAL                             + ;
                    (W_STOTAL * EST006->IPI/100         ) + ;
                    (W_STOTAL * (19 - EST006->ICMS)/100 ) + ;
                    (EST006->FRETE  * EST006->QTD_KG    )

         W_QUANT++
         EST006->( dbskip() )
      end
   end

   if POSICAO = 1
      WRET := W_TOTAL
   else
      WRET := W_QUANT
   end
   EST006->( dbgoto( W_OLDREC ) )

return WRET

****************************
function calc_tot_pend( W_PEDTOT, POSICAO )
****************************
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

         if ! empty( EST006->R_DTPED )  // Calcula apenas o total
            EST006->( dbskip() )      // dos pedidos pendentes
            loop
         end

/*
         W_TOTAL += (EST006->VAL_KG * EST006->QTD_KG                       ) + ;
                    (EST006->VAL_KG * EST006->QTD_KG * EST006->IPI/100     ) + ;
                    (EST006->VAL_KG * EST006->QTD_KG * (19 - EST006->ICMS)/100 ) + ;
                    (EST006->FRETE  * EST006->QTD_KG                       ) + ;
                    (EST006->VAL_KG * EST006->QTD_KG * EST006->OUTRATX/100 )
*/

         W_STOTAL := (EST006->VAL_KG * EST006->QTD_KG                       ) + ;
                     (EST006->VAL_KG * EST006->QTD_KG * EST006->OUTRATX/100 )

         W_TOTAL +=   W_STOTAL                                 + ;
                    ( W_STOTAL * EST006->IPI/100             ) + ;
                    ( W_STOTAL * ( 19 - EST006->ICMS ) / 100 ) + ;
                    ( EST006->FRETE  * EST006->QTD_KG        )

         W_QUANT++
         EST006->( dbskip() )
      end
   end

   if POSICAO = 1
      WRET := W_TOTAL
   else
      WRET := W_QUANT
   end
   EST006->( dbgoto( W_OLDREC ) )

return WRET

/*
-----------------------------------------------------------------------------
                      Funcao V_CALC_TOTAL
-----------------------------------------------------------------------------
*/
function v_calc_total( W_PEDTOT )

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

************************
static func tes_sta_ped(var)
************************

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
                    Funcao TELA_PECA_CORT()
-----------------------------------------------------------------------------
*/
procedure tela_peca_cort()

private W_HEADER := { "     Largura       Comprimento  " }
//                     12X,XXX,XXX.XX1234X,XXX,XXX.XX12
private W_FIELDS := { " str( EST008->LARGURA, 12, 2 ) + '  ' +" +;
                      " str( EST008->COMPRIM, 12, 2 ) + '  ' " }

W_SCR := savescreen( 03, 43, 12, 76 )

if W_CHAVE_ITEM # NIL

    @ 03,43 say 'ีอออออออ Pecas Cortadas อออออออธ'
    @ 04,43 say 'ณ                              ณ'
    @ 05,43 say 'ฦออออออออออออออออออออออออออออออต'
    @ 06,43 say 'ณ                              ณ'
    @ 07,43 say 'ณ                              ณ'
    @ 08,43 say 'ณ                              ณ'
    @ 09,43 say 'ณ                              ณ'
    @ 10,43 say 'ณ                              ณ'
    @ 11,43 say 'ิออออออออออออออออออออออออออออออพ'
    sombra( 03,43,11,75)

    EST008->( dbsetfilter( {|| W_CHAVE_ITEM = EST008->FORMA           +;
                                              EST008->TIPO            +;
                                              str(EST008->BIT_MM,8,3) +;
                                              str(EST008->ESP_MM,8,3) +;
                                              EST008->ESTADO           }))
//    EST008->( dbsetorder(3) )   // Ordena por tamanho de peca
    EST008->( dbgotop() )
    EST008->( dbedit( 04,44,10,73,W_FIELDS,,,W_HEADER ))

    restscreen( 03, 43, 12, 76, W_SCR )
    setcursor(1)
//    EST008->( dbsetorder(1) )
else
   message("Escolha o item de estoque primeiro")
end
return

/*
-----------------------------------------------------------------------------
                    Funcao TELA_PED_COMPRA()
-----------------------------------------------------------------------------
*/
procedure tela_ped_compra()

local OLD_AREA := select()
private W_HEADER := { "Data Prevista  Qtd em KG  Fornecedor" }
//                     XX/XX/XX123456XXX,XXX.XX12XXXXXXXXXXXXXX

select EST005

EST005->( dbsetrelation( "EST002",{|| EST005->FORNECEDOR } ) )
EST005->( dbsetrelation( "EST006",{|| EST005->PEDIDO } ) )


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
    sombra( 03,39,11,76)

    EST006->( dbsetfilter( {|| empty( EST006->R_DTPED)}))
    EST006->( dbsetfilter( {|| W_CHAVE_ITEM = EST006->FORMA           +;
                                              EST006->TIPO            +;
                                              str(EST006->BIT_MM,8,3) +;
                                              str(EST006->ESP_MM,8,3) +;
                                              EST006->ESTADO           }))

    EST006->( dbgotop() )
    EST006->( dbedit( 04,40,10,75, P_CAMPOS,,,W_HEADER ))

    restscreen( 03, 38, 12, 77, W_SCR )
    EST005->( dbclearrelation() )
else
   message("Escolha o item de estoque primeiro")
end

select (OLD_AREA)
return
*/

/*
-------------------------------------------------------------------------------
                           GERA_PEDIDO
-------------------------------------------------------------------------------
*/
function GERA_PEDIDO( P_CAMPO )
local WRET

dbgobottom()      //

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

