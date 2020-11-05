/*

   SCM - Sistema de Controle Metalurgico
   REL009.PRG Itens Abaixo da quantidade minima em estoque

*/

#include "inkey.ch"
telanum('SCR009','REL009')

//
// Arquivos
//
abrir("ESTREPO")
abrir("EST006")
abrir("EST007")

//
// variaveis para controle de impressoes geradas para arquivo
//
private W_TITULO := 'Estoque Abaixo do Minimo'
WRESP_IMP := 'I'
W_IMPARQ  := space(12)

private linha78 := replicate('-',78)
private condicao := {|| EST010->( ! eof()) }


EST007->( dbgotop() )

if dh_imprime()
   if WRESP_IMP = 'A'
      ESTREPO->( grava( WIMP_ARQ, date(), time(), W_TITULO, 80) )
   end

   W_PAG :=  0
   W_LIN :=  66


   while EST007->( ! eof() )

      inkey()
      if lastkey()=K_ESC
         @ prow()+2,20 say '---Impressao interrompida pelo usuario---'
         exit
      end
      if W_LIN  > 52
         W_PAG++
         relcabtn(W_PAG)
         relcab009('Itens Abaixo da Quantidade MINIMA')
         W_LIN := 10
      end

      if EST007->QTD_MIN > EST007->QTD_KGT
         W_CHAVE_ITEM = EST007->FORMA           +;
                        EST007->TIPO            +;
                   str( EST007->BIT_MM,8,3)     +;
                   str( EST007->ESP_MM,8,3)     +;
                        EST007->ESTADO

         WQTD_ACHA := totrealped( W_CHAVE_ITEM )

         W_LIN++
         reldet009()
      end

      EST007->( dbskip() )
   end

   dh_impoff()
end

// fim do programa

/*
-----------------------------------------------------------------------------
                      Procedimento RELCAB009
-----------------------------------------------------------------------------
*/
procedure relcab009( P_TITPROC )

    @ prow()+1, int ((( 80-len(alltrim(P_TITPROC)) )/2)) say P_TITPROC
    @ prow()+1, 00 say linha78


    @ prow()+2, 01 say 'Forma'
    @ prow()  , 07 say 'Tipo'
    @ prow()  , 13 say 'Est'
    @ prow()  , 20 say 'Bit_mm'
    @ prow()  , 29 say 'Esp_mm'
    @ prow()  , 38 say 'Qtd Min'
    @ prow()  , 48 say 'Qtd Est'
    @ prow()  , 58 say '---- Qtd Ped ------'
    @ prow()+1, 58 say 'Consta'
    @ prow()  , 68 say 'Achada'

    @ prow()+1, 00 say linha78

return

/*
-----------------------------------------------------------------------------
                      Procedimento reldet009
-----------------------------------------------------------------------------
*/
procedure reldet009()

    @ prow()+1, 01 say EST007->FORMA
    @ prow()  , 07 say EST007->TIPO
    @ prow()  , 14 say EST007->ESTADO
    @ prow()  , 20 say EST007->BIT_MM  picture "9999.999"
    @ prow()  , 29 say EST007->ESP_MM  picture "9999.999"
    @ prow()  , 38 say EST007->QTD_MIN picture "999999.99"
    @ prow()  , 48 say EST007->QTD_KGT picture "999999.99"

    @ prow()  , 58 say EST007->QTD_PED picture "999999.99"
    @ prow()  , 68 say WQTD_ACHA       picture "999999.99"

return

/*


Forma Tipo  Est    Bit_mm   Esp_mm    Qtd.Min    Qtd.Est |--- QTD PED -----|
1     7     13     20       29        39         50        60
                                                             Consta     Achada
                                                             62         73

XXX   XXXXX  L     9999.999 9999.999 999999.99 999999.99 999999.99 999999.99
1     7      14    20       29       38        48        58        68
return

*/


