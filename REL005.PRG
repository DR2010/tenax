/*

   SCM - Sistema de Controle Metalurgico

   REL005 - Quantidade Itens Estoque

*/
#include "inkey.ch"
telanum('SCR005','REL005')

//
// Arquivos
//
abrir("ESTREPO")
abrir("EST003")
abrir("EST004")
abrir("EST006")
abrir("EST007")
abrir("EST010")

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
        BL_CHAVE_ITEM := {|| .T. }

//
// variaveis para controle de impressoes geradas para arquivo
//
private W_TITULO := 'Quantidade Itens Estoque'
WRESP_IMP := 'I'
W_IMPARQ  := space(12)
W_CHAVE_ITEM  := space(12)

EST007->( dbgotop() )

private linha78 := replicate('-',78)

tela_005()

W_TELA := savescreen(,,,,)

if imp_tela()

   EST007->( dbsetorder(3) ) // forma+tipo+estado+str(bit_mm,8,3)+str(esp_mm,8,3)
   EST007->( dbseek( W_CHAVE_ITEM ))

   if dh_imprime()

      if WRESP_IMP = 'A'
         ESTREPO->( grava( WIMP_ARQ, date(), time(), W_TITULO, 80) )
      end

      W_PAG :=  0
      W_LIN :=  66

      while EST007->( eval( BL_CHAVE_ITEM ) ) .and. EST007->( ! eof() )

         //
         // Cabecalho
         //
         W_PAG++
         relcabtn(W_PAG)
         relcab005('Quantidades Itens Estoque')
         W_LIN := 10

         //
         // Inicio da quebra por FORMA+TIPO+ESTADO
         //
         X_CHAVE := EST007->FORMA+EST007->TIPO+EST007->ESTADO

         WTOTKG := 0
         while X_CHAVE = EST007->FORMA+EST007->TIPO+EST007->ESTADO ;
                   .and. EST007->( ! eof() )

          //  EST004->( dbsetorder(1) )
          //  EST004->( dbseek( EST007->FORMA+EST007->TIPO+EST007->ESTADO  ))

            if EST007->QTD_KGT > 0
               W_LIN++
               reldet005()
               WTOTKG += EST007->QTD_KGT
               inkey()
               if lastkey()=K_ESC
                  @ prow()+2,20 say '---Impressao interrompida pelo usuario---'
                  exit
               end
            end

            if W_LIN  > 54
               W_PAG++
               relcabtn(W_PAG)
               relcab005('Quantidades Itens Estoque')
               W_LIN := 10
            end

            EST007->( dbskip() )
         end
         @ prow()+1, 58 say 'Total : '+str(WTOTKG,12,2)
      end

      @ 01,01 say ''
      dh_impoff()
   end
end

// fim do programa


/*
-----------------------------------------------------------------------------
                      Procedimento RELCAB005
-----------------------------------------------------------------------------
*/
procedure relcab005( P_TITPROC )

    EST004->( dbsetorder(1) )
    EST004->( dbseek( EST007->FORMA+EST007->TIPO+EST007->ESTADO  ))

    @ prow()+1, int ((( 80-len(alltrim(P_TITPROC)) )/2)) say P_TITPROC
    @ prow()+1, 00 say linha78
    @ prow()+1, 00 say EST007->FORMA+'  '+EST007->TIPO+' '+EST007->ESTADO+'  '+EST004->DESCRICAO
    @ prow()+1, 00 say linha78

    @ prow()+1, 05 say 'Poleg'
    @ prow()  , 18 say 'MM'
    @ prow()  , 26 say 'Poleg'
    @ prow()  , 40 say 'MM'
    @ prow()  , 45 say 'Inteiras'
    @ prow()  , 56 say 'Cortadas'
    @ prow()  , 70 say 'Qtd (Kg)'

    @ prow()+1, 00 say linha78

return

/*
-----------------------------------------------------------------------------
                      Procedimento reldet005
-----------------------------------------------------------------------------
*/
procedure reldet005()

    @ prow()+1, 02 say TIRA_ZERO()+padl(EST007->BIT_FN,2)+'/'+padr(EST007->BIT_FD,2)
    @ prow()  , 12 say str( EST007->BIT_MM, 8, 3 )

    if EST007->ESP_MM > 0
       @ prow()  , 23 say TIRA_ZERO("ESP")+padl(EST007->ESP_FN,2)+'/'+padr(EST007->ESP_FD,2)
       @ prow()  , 34 say str( EST007->ESP_MM, 8, 3 )
    end

    @ prow()  , 48 say str(EST007->QTD_INT,5)
    @ prow()  , 59 say str(EST007->QTD_COR,5)
    @ prow()  , 66 say str(EST007->QTD_KGT,12,2)

return

/*
-----------------------------------------------------------------------------
		      Procedimento Tela
-----------------------------------------------------------------------------
*/
procedure TELA_005()

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

