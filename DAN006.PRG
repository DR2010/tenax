/*

   SCM - Sistema de Controle Metalurgico
   EST96.PRG - Relatorio de Saida por Itens de Estoque

   REL006.PRG - Relatorio de Saida por Itens de Estoque

*/
#include "inkey.ch"
#include "sic.ch"
local getlist := {}

telanum('SCR001','REL006')

abrir("EST003")
abrir("EST004")
abrir("EST007")
abrir("EST010")

EST010->( dbsetorder(2) )

private bl_cond := {|| EST010->( ! eof() ) }
private LINHA
private W_CABEC := 'RELATORIO DE SAIDA DE MATERIAL'
private N_BENFG := N_BENF := 0

private X_FORMA    := space(03)   ,;
	X_TIPO	   := space(05)   ,;
	X_ESTADO   := space(01)   ,;
	X_BIT_MM   := 0.00	  ,;
	X_ESP_MM   := 0.00	  ,;
	X_BIT_INT  := space(02)   ,;
	X_BIT_FN   := space(02)   ,;
	X_BIT_FD   := space(02)   ,;
	X_ESP_INT  := space(02)   ,;
	X_ESP_FN   := space(02)   ,;
	X_ESP_FD   := space(02)   ,;
	W_TOTAL_KG := 0 	  ,;
	W_DATA_INI := ctod(" ")   ,;
        W_DATA_FIM := ctod(" ")   ,;
        LINHA := replicate("-",78)

trel006()

begin sequence
   W_TELA := savescreen(,,,,W_TELA)
   if imp_tela()

      EST010->( dbseek(W_CHAVE_ITEM) )
      if EST010->( ! found() )
	 mensbeep("Nao ha registros. <ENTER>")
	 break
      end

      if dh_imprime()

	 mensimp("Aguarde termino da impressao...<ESC> interrompe impressao.")
	 W_PAG := 0

	 relcabtn( W_CABEC, ++W_PAG, 132 )

	 W_TOTAL_KG := 0

	 EST010->( dbeval( {|| rdet006() }, BL_CHAVE_ITEM ) )

	 dh_impoff()
      end
   end
end sequence

mensagem("")
/*
-----------------------------------------------------------------------------
Procedimento : detalhe
Parametros   : nenhum
Retorno      : nenhum
Objetivo     : Controlar o dbedit modulo 0220, Cadastro de Empresas
-----------------------------------------------------------------------------
*/
static procedure rdet006()

   if ( inkey() ) = K_ESC
      EST010->( dbgobottom())
      EST010->( dbskip() )
      @ prow()+1, 01 say '-----> Impressao interrompida pelo usuario <---'
      return nil
   end

   if prow() >= 55
      relcabtn( W_PAG, 79, W_CABEC )
   end

   @ prow()+1, 02 say EST010->DATAMOVI
   @ prow()  , 12 say EST010->BIT_INT+' '+EST010->BIT_FN+'/'+''+EST010->BIT_FD+''+STR(BIT_MM,8,3)
   @ prow()  , PCOL()+2 say EST010->ESP_INT+' '+EST010->ESP_FN+'/'+EST010->ESP_FD+''+STR(ESP_MM,8,3) //38 say
   @ prow()  , 47	say str(EST010->QTD_KG,12,2)
   @ prow()  , 62	say EST010->ORIGEM

   W_TOTAL_KG += EST010->QTD_KG

return


/*
-----------------------------------------------------------------------------
		      Procedimento CAB_006

-----------------------------------------------------------------------------
*/
procedure CAB_006()

    @ prow()+1, 00 say '|------------------------------------------------------------------------------|'
    @ prow()+1, 00 say '|'+EST004->FORMA+' '+EST004->TIPO+' '+EST004->ESTADO+' '+EST004->DESCRICAO
    @ prow()  , 79 say '|'
    @ prow()+1, 00 say '|------------------------------------------------------------------------------|'
    @ prow()+1, 00 say '| Data Mov.     Pol.    MM      Pol.      MM        Qtd.Kg          Destino    |'
    @ prow()+1, 00 say '|------------------------------------------------------------------------------|'

return

/*
-----------------------------------------------------------------------------
		      Procedimento Tela
-----------------------------------------------------------------------------
*/
procedure trel006()

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

