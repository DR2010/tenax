/*

   SCM - Sistema de Controle Metalurgico
   REL011.PRG Itens Conferencia

*/

private condicao := {|| EST011->( ! eof()) }
#include "inkey.ch"

private linha78 := replicate('-',78)

telanum('SCR011','REL011')

abrir("EST010")

EST007->( dbgotop() )

if dh_imprime()

   W_PAG :=  0
   W_LIN :=  66


   while EST010->( ! eof() )

      inkey()
      if lastkey()=K_ESC
         @ prow()+2,20 say '---Impressao interrompida pelo usuario---'
         exit
      end

      if W_LIN  > 55
         W_PAG++
         relcabtn(W_PAG)
         relcab011('Saida de Material')
         W_LIN := 10
      end

      W_CHAVE_ITEM = EST007->FORMA           +;
                     EST007->TIPO            +;
                str( EST007->BIT_MM,8,3)     +;
                str( EST007->ESP_MM,8,3)     +;
                     EST007->ESTADO

      WQTD_ACHA := totrealped( W_CHAVE_ITEM )
      if WQTD_ACHA <> EST007->QTD_PED
         W_LIN++
         reldet011()

      end

      EST007->( dbskip() )
   end
   @ prow()+1,20 say '---FIM DA IMPRESSAO - NORMAL ---'
   @ 01,01 say ''

   dh_impoff()
end

// fim do programa


/*
-----------------------------------------------------------------------------
                      Procedimento RELCAB011
-----------------------------------------------------------------------------
*/
procedure relcab011( P_TITPROC )

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
                      Procedimento reldet011
-----------------------------------------------------------------------------
*/
procedure reldet011()

    @ prow()+1, 01 say EST010->DATAMOVI
    @ prow()  , 10 say EST010->FORMA
    @ prow()  , 16 say EST010->TIPO
    @ prow()  , 23 say EST010->ESTADO
    @ prow()  , 27 say EST010->BIT_MM   picture '9999.999'
    @ prow()  , 36 say EST010->ESP_MM   picture '9999.999'
    @ prow()  , 46 say EST010->OPERACAO
    @ prow()  , 49 say EST010->QTD_KG   picture '999999.99'
    @ prow()  , 59 say left( EST010->ORIGEM, 10 )
    @ prow()  , 63 say EST010->TIPOMOVI

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


