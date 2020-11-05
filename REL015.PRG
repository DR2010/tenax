/*

   SCM - Sistema de Controle Metalurgico

   REL015 -  Quantidade Comprada

*/
#include "inkey.ch"
telanum('SCR015','REL015')
SET EXACT ON
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
	X_TIPO     := space(05)   ,;
	X_ESTADO   := space(01)   ,;
	X_BIT_MM   := 0.00        ,;
	X_ESP_MM   := 0.00        ,;
	X_BIT_INT  := space(02)   ,;
	X_BIT_FN   := space(02)   ,;
	X_BIT_FD   := space(02)   ,;
	X_ESP_INT  := space(02)   ,;
	X_ESP_FN   := space(02)   ,;
	X_ESP_FD   := space(02)   ,;
	W_TOTAL_KG := 0           ,;
	W_DATA_INI := ctod(" ")   ,;
	W_DATA_FIM := ctod(" ")   ,;
	BL_CHAVE_ITEM := {|| .T. }

//
// variaveis para controle de impressoes geradas para arquivo
//
private W_TITULO := 'Quantidade Comprada'
private m_busca := {'T','F','L',' '}, id := 1
WRESP_IMP := 'I'
W_IMPARQ  := space(12)
W_CHAVE_ITEM  := space(12)

EST007->( dbgotop() )

private linha78 := replicate('-',78)

tela_015()

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
	 relcab015('Quantidades Comprada')
	 W_LIN := 10

	 //
	 // Inicio da quebra por FORMA+TIPO+ESTADO
	 //
	 X_CHAVE := EST007->FORMA+EST007->TIPO+EST007->ESTADO

	 WTOTKG1 := 0
	 WTOTKG2 := 0
	 WTOTKG3 := 0
	WTOTKG4 := 0
	 WTOTKG5 := 0
	 
	 while X_CHAVE = EST007->FORMA+EST007->TIPO+EST007->ESTADO ;
		   .and. EST007->( ! eof() )
	    id      := 1

	    W_LIN++
	    reldet015()
	    WTOTKG1 += EST007->QTD_INT
	    WTOTKG2 += EST007->QTD_COR
	    WTOTKG3 += EST007->QTD_KGT
	    WTOTKG4 += EST007->QTD_KGT
	    WTOTKG5 += EST007->QTD_PED

	    inkey()
	    if lastkey()=K_ESC
	       @ prow()+2,20 say '---Impressao interrompida pelo usuario---'
	       exit
	    end

	    if W_LIN  > 54
	       W_PAG++
	       relcabtn(W_PAG)
	       relcab015('Quantidades Comprada')
	       W_LIN := 10
	    end


	    EST007->( dbskip() )
	 end
	 @ prow()+1, 01 say '=======================> TOTAIS : '
	 @ prow()  , 39 say WTOTKG1 picture '99999'
	 @ prow()  , pcol()+3 say WTOTKG2 picture '99999'
	 @ prow()  , pcol()+1 say WTOTKG3 picture '9999999.99'
	 @ prow()  , pcol()+1 say WTOTKG5 picture '999999.99'
      end


      @ 01,01 say ''
      dh_impoff()
   end
end

// fim do programa


/*
-----------------------------------------------------------------------------
		      Procedimento RELCAB015
-----------------------------------------------------------------------------
*/
procedure relcab015( P_TITPROC )
	    EST004->( dbsetorder(3) )
	    EST004->( dbseek( EST007->FORMA+EST007->TIPO+EST007->ESTADO  ))
	    while !EST004->(FOUND()) .AND. id <= 4
	      EST004->( dbseek( EST007->FORMA+EST007->TIPO+m_busca[ id ] ) )
	      id++                
	      
	    end
   

    @ prow()+1, int ((( 80-len(alltrim(P_TITPROC)) )/2)) say P_TITPROC
    @ prow()+1, 00 say linha78
    @ prow()+1, 00 say EST007->FORMA+'  '+EST007->TIPO+' '+EST007->ESTADO+'  '+EST004->DESCRICAO
    @ prow()+1, 00 say linha78

    @ prow()+1, 04 say 'Poleg'
    @ prow()  , 16 say 'MM'
    @ prow()  , 22 say 'Poleg'
    @ prow()  , 34 say 'MM'
    @ prow()  , 39 say 'Intei'
    @ prow()  , 45 say 'Corta'
    @ prow()  , 53 say 'Est (Kg)'
    @ prow()  , 64 say 'Qtd Comprada'

    @ prow()+1, 00 say linha78

return

/*
-----------------------------------------------------------------------------
		      Procedimento reldet015
-----------------------------------------------------------------------------
*/
procedure reldet015()

    @ prow()+1, 02 say TIRA_ZERO()+padl(EST007->BIT_FN,2)+'/'+padr(EST007->BIT_FD,2)
    @ prow()  , 10 say str( EST007->BIT_MM, 8, 3 )
    @ prow()  , 21 say TIRA_ZERO("ESP")+padl(EST007->ESP_FN,2)+'/'+padr(EST007->ESP_FD,2)
    @ prow()  , 30 say IF(EST007->ESP_MM>0,str( EST007->ESP_MM, 8, 3 ),space(8))
    @ prow()  , 39 say EST007->QTD_INT picture '99999'
    @ prow()  , 47 say EST007->QTD_COR picture '99999'
    @ prow()  , 53 say EST007->QTD_KGT picture '9999999.99'
    @ prow()  , 64 say EST007->QTD_PED picture "999999.99"


return

/*
-----------------------------------------------------------------------------
		      Procedimento Tela
-----------------------------------------------------------------------------
*/
procedure TELA_015()

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


/*
   4           16    22          34 37    43      51         62        72
   Poleg       MM    Poleg       MM Intei Corta   Qtd (Kg)   Qtd Est   Qtd Ped
 2       10       19       28       37    43    49         60        70
 9999999 9999.999 99999999 9999.999 99999 99999 9999999999 999999.99 999999.99
*/
