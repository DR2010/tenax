/*

   SCM - Sistema de Controle Metalurgico

   REL016 -  Quantidade Comprada

*/
#include "inkey.ch"
telanum('SCR016','REL016')
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
private W_TITULO := 'QUANT.MIN./GRUPO/SUBGRUPO/COLUNA/SUBFATOR'
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
	 relcab016(W_TITULO)
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
	    reldet016()
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
	       relcab016(W_TITULO)
	       W_LIN := 10
	    end


	    EST007->( dbskip() )
	 end
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
procedure relcab016( P_TITPROC )
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

    @ prow()+1, 02       say 'Poleg'
    @ prow()  , 14       say 'MM'
    @ prow()  , 22       say 'Poleg'
    @ prow()  , 32       say 'MM'
    @ prow()  , 46       say 'QTDE.MIN.'
    @ prow()  , PCOL()+5 say 'G'
    @ prow()  , PCOL()+3 say 'SG'
    @ prow()  , PCOL()+3 say 'COL'
    @ prow()  , PCOL()+3 say 'SF'

    @ prow()+1, 00 say linha78

return

/*
-----------------------------------------------------------------------------
		      Procedimento reldet015
-----------------------------------------------------------------------------
*/
procedure reldet016()

    @ prow()+1, 02 say TIRA_ZERO()+padl(EST007->BIT_FN,2)+'/'+padr(EST007->BIT_FD,2)
    @ prow()  , 10 say str( EST007->BIT_MM, 8, 3 )
    @ prow()  , 21 say TIRA_ZERO("ESP")+padl(EST007->ESP_FN,2)+'/'+padr(EST007->ESP_FD,2)
    @ prow()  , 30 say IF(EST007->ESP_MM>0,str( EST007->ESP_MM, 8, 3 ),space(8))
    @ prow()  , 46 say EST007->QTD_MIN picture '9999999.99'
    @ prow()  , PCOL()+4 say EST007->GRUPO picture '99'
    @ prow()  , PCOL()+3 say EST007->SUBGRUPO picture '99'
    @ prow()  , PCOL()+3 say EST007->COLUNA picture '99'
    @ prow()  , PCOL()+3 say EST007->SUBFATOR picture "99"


return

