/*

   SCM - Sistema de Controle Metalurgico
   RELDAN.PRG - Relatorio de Entrada por Itens de Estoque

*/

#include "inkey.ch"

telanum('SCR001','REL007')
status('Relatorio de Entrada de Material')

//
// Arquivos
//
abrir("ESTREPO")
abrir("EST003")
abrir("EST004")
abrir("EST007")
abrir("EST010")
abrir("EST011")

EST004->( dbsetorder(2) ) // FORMA+TIPO

EST010->( dbsetorder(4) ) // data da movimentacao
EST010->( dbgotop() )

//
// variaveis para controle de impressoes geradas para arquivo
//
private W_TITULO := 'Listagem de Entrada de Material'
WRESP_IMP := 'I'
W_IMPARQ  := space(12)

//
// Variaveis
//
BL_CHAVE_ITEM := {|| EST010->( ! eof() ) }

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

tela007()

W_TELA := savescreen(,,,,)
if imp_tela()

   if dh_imprime()

      if WRESP_IMP = 'A'
	 ESTREPO->( grava( WIMP_ARQ, date(), time(), W_TITULO, 80) )
      end

      W_FORMA := EST010->FORMA
      W_TIPO  := EST010->TIPO
      cabgeral('Listagem de Entrada de Material' )
      cab007()

      EST010->( dbsetorder(4) )
      EST010->( dbseek( dtos(W_DATA_INI), .t. ))
      W_TOTAL_KG := 0

      while EST010->DATAMOVI >= W_DATA_INI .and. ;
	    EST010->DATAMOVI <= W_DATA_FIM .and. EST010->( ! eof() )

	 mensimp("Gerando Relatorio. Aguarde... "+str( EST010->(recno()) ) )

	 if prow() > 55
            cabgeral('Listagem de Entrada de Material')
            cab007()
	 end

         EST011->( dbseek( EST010->TIPOMOVI ) )

         if EST010->( eval( BL_CHAVE_ITEM ) ) .and. EST011->ES = 'E'

	    if EST010->FORMA+EST010->TIPO <> W_FORMA+W_TIPO




               EST004->( dbseek( EST010->FORMA+EST010->TIPO ) )
               @ prow()+1, 00 say WTRACO80
               @ prow()+1, 00 say 'Material ..: '+ EST010->FORMA+' '+EST010->tipo+' '+EST010->estado+' '+EST004->descricao
               @ prow()+1, 00 say ''
	    end
            W_TOTAL_KG += EST010->QTD_KG
            det007()
	 end
	 W_FORMA := EST010->FORMA
	 W_TIPO  := EST010->TIPO

	 EST010->( dbskip() )

      end
      rodape007()
      dh_impoff()
   end
end

/*
-----------------------------------------------------------------------------
                      Procedimento Det007
-----------------------------------------------------------------------------
*/
procedure det007()

   @ prow()+1, 02       say left( dtoc(EST010->DATAMOVI),5 )
   @ prow()  , 12       say EST010->BIT_INT+' '+EST010->BIT_FN+'/'+EST010->BIT_FD+''+STR(EST010->BIT_MM,8,3)
   @ prow()  , 30       say EST010->ESP_INT+' '+EST010->ESP_FN+'/'+EST010->ESP_FD+''+STR(EST010->ESP_MM,8,3)
   @ prow()  , 51       say str(EST010->QTD_KG,12,2)
   if EST011->ACERTO = 'S'
      @ prow()  , 66       say 'ACERTO ENTRADA'
   else
      @ prow()  , 66       say left( EST010->ORIGEM, 13 )
   end

return


/*
-----------------------------------------------------------------------------
                      Procedimento cab007
-----------------------------------------------------------------------------
*/
procedure cab007()

    EST004->( dbseek( W_FORMA+W_TIPO ) )

    @ prow()+1, 00 say WTRACO80
    @ prow()+1, 00 say ' '+EST004->FORMA+' '+EST004->tipo+' '+EST004->estado+' '+EST004->descricao
    @ prow()+1, 00 say WTRACO80
    @ prow()+1, 00 say '  Data Mov.     Pol.    MM      Pol.      MM        Qtd.Kg          Origem      '
    @ prow()+1, 00 say WTRACO80

return

/*
-----------------------------------------------------------------------------
                      Procedimento Rodape007
-----------------------------------------------------------------------------
*/
procedure rodape007()

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
procedure TELA007()

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

