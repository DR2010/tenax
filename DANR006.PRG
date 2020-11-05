/*

   SCM - Sistema de Controle Metalurgico
   RELDAN.PRG - Relatorio de Saida por Itens de Estoque

*/

#include "inkey.ch"

telanum('SCR001','REL006')
status('Relatorio de Saida de Material')

//
// Arquivos
//
abrir("ESTREPO")
abrir("EST003")
abrir("EST004")
abrir("EST007")
abrir("EST010")
abrir("EST011")
abrir("ESTTMP10") // Temporario

EST004->( dbsetorder(2) ) // FORMA+TIPO

EST010->( dbsetorder(4) ) // data da movimentacao
EST010->( dbgotop() )

//
// variaveis para controle de impressoes geradas para arquivo
//
private W_TITULO := 'Listagem de Saida de Material'
WRESP_IMP := 'I'
W_IMPARQ  := space(12)

//
// Variaveis
//
BL_CHAVE_ITEM := {|| EST010->( ! eof() ) }
W_CHAVE_ITEM := space(30)

X_FORMA   := space(03)
X_TIPO    := space(05)
X_ESTADO  := space(01)
X_BIT_MM  := 0.00      //  8.3
X_ESP_MM  := 0.00      //  8.3
X_BIT_INT := space(02)
X_BIT_FN  := space(02)
X_BIT_FD  := space(02)
X_ESP_INT := space(02)
X_ESP_FN  := space(02)
X_ESP_FD  := space(02)

WTRACO80 := replicate('-',80)

W_DATA_INI := date()
W_DATA_FIM := date()
NUMPAG	   := 1

//
// Inicio
//

tela006()

W_TELA := savescreen(,,,,)
if imp_tela()

   //
   // Limpando arquivo temporario
   //
   ESTTMP10->( dbgotop())
   while ESTTMP10->( ! eof() )
      while ESTTMP10->( ! rlock() ) ; end
      ESTTMP10->( dbdelete() )
      ESTTMP10->( dbskip() )
   end

   if dh_imprime()

      if WRESP_IMP = 'A'
	 ESTREPO->( grava( WIMP_ARQ, date(), time(), W_TITULO, 80) )
      end

      W_FORMA := EST010->FORMA
      W_TIPO  := EST010->TIPO
      cabgeral('Listagem de Saida de Material' )
      cab006()

      //
      // Gera arquivo temporario com movimentacao entre as datas
      //
      EST010->( dbsetorder(4) )
      EST010->( dbseek( dtos(W_DATA_INI), .t. ) )
      W_TOTAL_KG := 0

      while EST010->DATAMOVI >= W_DATA_INI .and. ;
	    EST010->DATAMOVI <= W_DATA_FIM .and. EST010->( ! eof() )

         g_det006()
	 EST010->( dbskip() )

      end

      //
      // Imprime arquivo temporario ordenado
      //

      mensimp("Gerando Relatorio. Aguarde... "+str( EST010->(recno()) ) )

      select ESTTMP10
      index on FORMA+TIPO+ESTADO+str(BIT_MM,8,3)+str(ESP_MM,8,3) to esttmp10

      ESTTMP10->( dbseek( W_CHAVE_ITEM ) )

      EST004->( dbseek( EST010->FORMA+EST010->TIPO ) )
      @ prow()+1, 00 say WTRACO80
      @ prow()+1, 00 say 'Material ..: '+ EST010->FORMA+' '+EST010->tipo+' '+EST010->estado+' '+EST004->descricao
      @ prow()+1, 00 say ''

      W_FORMA   := ESTTMP10->FORMA
      W_TIPO    := ESTTMP10->TIPO
      W_ESTADO  := ESTTMP10->ESTADO
      W_BIT_INT := ESTTMP10->BIT_INT
      W_BIT_FN  := ESTTMP10->BIT_FN
      W_BIT_FD  := ESTTMP10->BIT_FD
      W_BIT_MM  := ESTTMP10->BIT_MM
      W_ESP_INT := ESTTMP10->ESP_INT
      W_ESP_FN  := ESTTMP10->ESP_FN
      W_ESP_FD  := ESTTMP10->ESP_FD
      W_ESP_MM  := ESTTMP10->ESP_MM

      while ESTTMP10->( eval( BL_CHAVE_ITEM ) )

         if prow() > 55
            cabgeral('Listagem de Saida de Material' )
            cab006()
         end

         ESTTMP10->( dbseek( ESTTMP10->TIPOMOVI ) )

         W_TOTAL_KG += EST010->QTD_KG
         det006()
         ESTTMP10->( dbskip() )
      end


      //


      rodape006()
      dh_impoff()
   end
end

/*
-----------------------------------------------------------------------------
		      Procedimento Det006
-----------------------------------------------------------------------------
*/
procedure det006()

   @ prow()+1, 02       say left( dtoc(EST010->DATAMOVI),5 )
   @ prow()  , 12       say EST010->BIT_INT+' '+EST010->BIT_FN+'/'+EST010->BIT_FD+''+STR(EST010->BIT_MM,8,3)
   @ prow()  , 30       say EST010->ESP_INT+' '+EST010->ESP_FN+'/'+EST010->ESP_FD+''+STR(EST010->ESP_MM,8,3)
   @ prow()  , 51       say str(EST010->QTD_KG,12,2)
   if EST011->ACERTO = 'S'
      @ prow()  , 66       say 'ACERTO SAIDA'
   else
      @ prow()  , 66       say left( EST010->ORIGEM, 13 )
   end

return

/*
-----------------------------------------------------------------------------
                      Procedimento g_Det006
-----------------------------------------------------------------------------
*/
procedure g_det006()

   ESTTMP10->( dbappend() )
   ESTTMP10->FORMA      := EST010->FORMA
   ESTTMP10->TIPO       := EST010->TIPO
   ESTTMP10->ESTADO     := EST010->ESTADO

   ESTTMP10->DATAMOVI   := EST010->DATAMOVI
   ESTTMP10->BIT_INT    := EST010->BIT_INT
   ESTTMP10->BIT_FN     := EST010->BIT_FN
   ESTTMP10->BIT_FD     := EST010->BIT_FD
   ESTTMP10->BIT_MM     := EST010->BIT_MM
   ESTTMP10->ESP_INT    := EST010->ESP_INT
   ESTTMP10->ESP_FN     := EST010->ESP_FN
   ESTTMP10->ESP_FD     := EST010->ESP_FD
   ESTTMP10->ESP_MM     := EST010->ESP_MM
   ESTTMP10->QTD_KG     := EST010->QTD_KG
   ESTTMP10->ORIGEM     := EST010->ORIGEM

return

/*
-----------------------------------------------------------------------------
		      Procedimento cab006
-----------------------------------------------------------------------------
*/
procedure cab006()

    EST004->( dbseek( W_FORMA+W_TIPO ) )

    @ prow()+1, 00 say WTRACO80
    @ prow()+1, 00 say ' '+EST004->FORMA+' '+EST004->TIPO+' '+EST004->ESTADO+' '+EST004->DESCRICAO
    @ prow()+1, 00 say WTRACO80
    @ prow()+1, 00 say '  Data Mov.     Pol.    MM      Pol.      MM        Qtd.Kg          Destino     '
    @ prow()+1, 00 say WTRACO80

return

/*
-----------------------------------------------------------------------------
		      Procedimento Rodape006
-----------------------------------------------------------------------------
*/
procedure rodape006()

    @ prow()+1, 00     say WTRACO80
    @ prow()+1, 00     say '             Total no periodo'
    @ prow()  , 35     say str( W_TOTAL_KG,12,2)
    @ prow(), pcol()+2 say 'Kg'
    @ prow()+1, 00     say WTRACO80

return

/*
-----------------------------------------------------------------------------
		      Procedimento Tela
-----------------------------------------------------------------------------
*/
procedure TELA006()

@ 02,02 say 'ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿'
@ 03,02 say '³                                                                          ³'
@ 04,02 say '³                                                                          ³'
@ 05,02 say '³  Forma    :       -                                                      ³'
@ 06,02 say '³  Tipo     :       -                                                      ³'
@ 07,02 say '³  Estado   :       -                                                      ³'
@ 08,02 say '³  Bit./Esp.:      /                                                       ³'
@ 09,02 say '³  Bit./Larg:      /                                                       ³'
@ 10,02 say '³                                                                          ³'
@ 11,02 say '³  Periodo..:           `a                                                 ³'
@ 12,02 say '³                                                                          ³'
@ 13,02 say '³                                                                          ³'
@ 14,02 say '³                                                                          ³'
@ 15,02 say '³                                                                          ³'
@ 16,02 say '³                                                                          ³'
@ 17,02 say '³                                                                          ³'
@ 18,02 say '³                                                                          ³'
@ 19,02 say '³                                                                          ³'
@ 20,02 say '³                                                                          ³'
@ 21,02 say '³                                                                       96 ³'
@ 22,02 say 'ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ'

return

