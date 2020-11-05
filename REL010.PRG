/*

   SCM - Sistema de Controle Metalurgico

   REL010 - Quantidade minima em estoque

*/
#include "inkey.ch"
telanum('SCR010','REL010')

//
// Arquivos
//
abrir("ESTREPO")
abrir("EST006")
abrir("EST007")

//
// variaveis para controle de impressoes geradas para arquivo
//
private W_TITULO := 'Itens Conferencia'
WRESP_IMP := 'I'
W_IMPARQ  := space(12)

EST007->( dbgotop() )

private linha78 := replicate('-',78)

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
      if W_LIN  > 55
         W_PAG++
         relcabtn(W_PAG)
         relcab010('Itens Conferencia')
         W_LIN := 10
      end

      W_CHAVE_ITEM = EST007->FORMA           +;
                     EST007->TIPO            +;
                str( EST007->BIT_MM,8,3)     +;
                str( EST007->ESP_MM,8,3)     +;
                     EST007->ESTADO

      WQTD_ACHA := totrealped( W_CHAVE_ITEM )
      if WQTD_ACHA <> EST007->QTD_PED
         // atualiza
         while EST007->( ! rlock() ) ; END
         EST007->QTD_PED := WQTD_ACHA
         EST007->( dbunlock() )
         W_LIN++
         reldet010()

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
                      Procedimento RELCAB010
-----------------------------------------------------------------------------
*/
procedure relcab010( P_TITPROC )

    @ prow()+1, int ((( 80-len(alltrim(P_TITPROC)) )/2)) say P_TITPROC
    @ prow()+1, 00 say linha78


    @ prow()+2, 01 say 'Forma'
    @ prow()  , 07 say 'Tipo'
    @ prow()  , 13 say 'Est'
    @ prow()  , 20 say 'Bit/Esp'
    @ prow()  , 29 say 'Bit/Lar'
    @ prow()  , 38 say 'Qtd Min'
    @ prow()  , 48 say 'Qtd Est'
    @ prow()  , 58 say 'Qtd Ped'
    @ prow()  , 70 say 'Achada'
    @ prow()+1, 00 say linha78

return

/*
-----------------------------------------------------------------------------
                      Procedimento reldet010
-----------------------------------------------------------------------------
*/
procedure reldet010()

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
Data Mov Forma Tipo  Est    Bit_mm   Esp_mm  OP    Qtd Kg TM  Origem
1        10    16    22     29       38      46    52     59  63

99/99/99 XXX   XXXXX  L   9999.999 9999.999  X  999999.99 XXX XXXXXXXXXXXXXXXXXX
1        10    16     23  27       36        46 49        59  63

*/

