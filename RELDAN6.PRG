
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

EST010->( dbsetorder(2) )

//
// variaveis para controle de impressoes geradas para arquivo
//
private W_TITULO := 'Listagem de Saida de Material'
WRESP_IMP := 'I'
W_IMPARQ  := space(12)


//
// Variaveis
//

W_DATA_INI := date()
W_DATA_FIM := date()
NUMPAG	   := 1

if imp_tela()

   if dh_imprime()

      if WRESP_IMP = 'A'
	 ESTREPO->( grava( WIMP_ARQ, date(), time(), W_TITULO, 80) )
      end

      mensimp("Gerando Relatorio. Aguarde...")

      while EST010->( ! eof() )

	 if prow() > 55
	    cabgeral()
	    cab006()
	 end
	 det006()

	 EST010->( dbskip() )

      end


   end
end

/*
-----------------------------------------------------------------------------
		      Procedimento Det006
-----------------------------------------------------------------------------
*/
procedure det006()

      @ prow()+1, 00	   say '|'
      @ prow()	, 02	   say dtoc(EST010->DATAMOVI)
      @ prow()	, 12	   say EST010->BIT_INT+' '+EST010->BIT_FN+'/'+EST010->BIT_FD+''+STR(BIT_MM,8,3)
      @ prow()	, 30	   say EST010->ESP_INT+' '+EST010->ESP_FN+'/'+EST010->ESP_FD+''+STR(ESP_MM,8,3)
      @ prow()	, 51	   say str(EST010->QTD_KG,12,2)
      @ prow()	, 63	   say EST010->ORIGEM
      @ prow()	, 79	   say "|"

return

/*
-----------------------------------------------------------------------------
		      Procedimento CabGeral
-----------------------------------------------------------------------------
*/
procedure cabgeral()

    @ 01      , 00 say '+-----------------------------------------------------------------------------+'
    @ prow()+1, 00 say '|  TENAX A�os Especiais'
    @ prow()  , 52 say 'Data: ' + dtoc(date())
    @ prow()  , 70 say 'Pag.: ' + strzero(++NUMPAG,2) + '  |'
    @ prow()+1, 00 say '|                                                  Per :'
    @ prow()  , 57 say dtoc(W_DATA_INI)+' `a'
    @ prow()  , 69 say dtoc(W_DATA_FIM)+'  |'
    @ prow()+1, 00 say '|                       Listagem de Saida de Material                          |'
    @ prow()+1, 00 say '|------------------------------------------------------------------------------|'

return

/*
-----------------------------------------------------------------------------
		      Procedimento cab006
-----------------------------------------------------------------------------
*/
procedure cab006()

    @ prow()+1, 00 say '|------------------------------------------------------------------------------|'
    @ prow()+1, 00 say '|'+EST004->FORMA+' '+EST004->tipo+' '+EST004->estado+' '+EST004->descricao
    @ prow()  , 79 say '|'
    @ prow()+1, 00 say '|------------------------------------------------------------------------------|'
    @ prow()+1, 00 say '| Data Mov.     Pol.    MM      Pol.      MM        Qtd.Kg          Destino    |'
    @ prow()+1, 00 say '|------------------------------------------------------------------------------|'

return

/*
-----------------------------------------------------------------------------
		      Procedimento Rodape006
-----------------------------------------------------------------------------
*/
procedure rodape006()

    @ prow()+1, 00     say '|------------------------------------------------------------------------------|'
    @ prow()+1, 00     say '|            Total no periodo'
    @ prow()  , 35     say str( W_TOTAL_KG,12,2)
    @ prow(), pcol()+2 say 'Kg'
    @ prow()  , 79     say '|'
    @ prow()+1, 00     say '|------------------------------------------------------------------------------|'

return

/*
-----------------------------------------------------------------------------
		      Procedimento Tela
-----------------------------------------------------------------------------
*/
procedure TELA_96()

@ 02,02 say '��������������������������������������������������������������������������Ŀ'
@ 03,02 say '�                                                                          �'
@ 04,02 say '�                                                                          �'
@ 05,02 say '�  Forma    :       -                                                      �'
@ 06,02 say '�  Tipo     :       -                                                      �'
@ 07,02 say '�  Estado   :       -                                                      �'
@ 08,02 say '�  Bit./Esp.:      /                                                       �'
@ 09,02 say '�  Bit./Larg:      /                                                       �'
@ 10,02 say '�                                                                          �'
@ 11,02 say '�  Periodo..:           `a                                                 �'
@ 12,02 say '�                                                                          �'
@ 13,02 say '�                                                                          �'
@ 14,02 say '�                                                                          �'
@ 15,02 say '�                                                                          �'
@ 16,02 say '�                                                                          �'
@ 17,02 say '�                                                                          �'
@ 18,02 say '�                                                                          �'
@ 19,02 say '�                                                                          �'
@ 20,02 say '�                                                                          �'
@ 21,02 say '�                                                                       96 �'
@ 22,02 say '����������������������������������������������������������������������������'

return
