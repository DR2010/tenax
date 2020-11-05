/*

   SCM - Sistema de Controle Metalurgico
   EST96.PRG - Relatorio de Saida por Itens de Estoque

   REL006.PRG - Relatorio de Saida por Itens de Estoque

*/

#include "inkey.ch"

//
// Arquivos
//
abrir("ESTREPO")
abrir("EST003")
abrir("EST004")
abrir("EST007")
abrir("EST010")

telanum('SCR001','REL006')

//
// variaveis para controle de impressoes geradas para arquivo
//
private W_TITULO := 'Listagem de Saida de Material'
WRESP_IMP := 'I'
W_IMPARQ  := space(12)

private condicao := {|| EST010->( ! eof()) }
private detalhe  := {|| det_96() },;
	X_FORMA    := space(03)   ,;
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
	FLAG := 0		  ,;
	TUDO := 0		  ,;
	modo := 0		  ,;
	zero := 0		  ,;
	POSICAO := NIL		  ,;
	NUMPAG	   := 0 	  ,;
	X_UM_ITEM  := .t.	  ,;
	OP := 0 		  ,;
	T_MODO :=0		  ,;
	W_CHAVE_ITEM		  ,;
	WRET			  ,;
	VARIAVEL		  ,;
	OLD_STATUS := savescreen(24,00,24,79)
	@ 24,00 say padc("Gerando o relatorio. Aguarde um instante...")


SET WRAP ON


EST010->( dbsetorder(2) )
status('Relatorio de Saida de Material')

tela_96()
W_TELA := savescreen(,,,,)

zera_96()

if imp_tela()

   imp96()

end

*-------------------------------------------------------------------------------
				function  imp96()
*-------------------------------------------------------------------------------

  if dh_imprime()
       if WRESP_IMP = 'A'
	  ESTREPO->( grava( WIMP_ARQ, date(), time(), W_TITULO, 80) )
       end

       set device to screen
       @ 24,00 say padc("Gerando Relatorio. Aguarde...",80)
       set device to print
       if ! tudo == 1
	  if zero !=1
	    cab_96()
	  end
       end
       det_96()
       if ! tudo == 1
	   if zero != 1
	     rodape_96()
	   end
       end
       @ 00 , 00 say ''
       dh_impoff()
       restscreen(24,00,24,79, OLD_STATUS)
  elseif t_modo=1
   imp9601()
 end

return nil


// fim do programa

/*
-----------------------------------------------------------------------------
		      Procedimento Cab_96
-----------------------------------------------------------------------------
*/
procedure cab_96

    @ 01      , 00 say '+-----------------------------------------------------------------------------+'
    @ prow()+1, 00 say '|  TENAX A‡os Especiais'
    @ prow()  , 52 say 'Data: ' + dtoc(date())
    @ prow()  , 70 say 'Pag.: ' + strzero(++NUMPAG,2) + '  |'
    @ prow()+1, 00 say '|                                                  Per :'
    @ prow()  , 57 say dtoc(W_data_ini)+' `a'
    @ prow()  , 69 say dtoc(W_data_fim)+'  |'
    @ prow()+1, 00 say '|                       Listagem de Saida de Material                          |'
    @ prow()+1, 00 say '|------------------------------------------------------------------------------|'


return
/*
-----------------------------------------------------------------------------
		      Procedimento Rodape_96
-----------------------------------------------------------------------------
*/
procedure rodape_96()

    @ prow()+1, 00     say '|------------------------------------------------------------------------------|'
    @ prow()+1, 00     say '|            Total no periodo'
    @ prow()  , 35     say str( W_TOTAL_KG,12,2)
    @ prow(), pcol()+2 say 'Kg'
    @ prow()  , 79     say '|'
    @ prow()+1, 00     say '|------------------------------------------------------------------------------|'

return
/*
-----------------------------------------------------------------------------
		      Procedimento Tit_96
-----------------------------------------------------------------------------
*/
procedure tit_96()
   IF TUDO == 1
    select EST010
    @ prow()+1, 00 say '|------------------------------------------------------------------------------|'
    @ prow()+1, 00 say '|'+EST004->FORMA+' '+EST004->tipo+' '+EST004->estado+' '+EST004->descricao
    @ prow()  , 79 say '|'
    @ prow()+1, 00 say '|------------------------------------------------------------------------------|'
    @ prow()+1, 00 say '| Data Mov.     Pol.    MM      Pol.      MM        Qtd.Kg          Destino    |'
    @ prow()+1, 00 say '|------------------------------------------------------------------------------|'

 else

    EST004->( dbseek(left(W_CHAVE_ITEM,9))) // posiciona para pegar descricao

    @ prow()+1, 00 say '|------------------------------------------------------------------------------|'
    @ prow()+1, 00 say '|'+EST010->FORMA

    @ prow()  , 00 say '|          '+TIPO+' '+X_ESTADO+'  '+est004->descricao

    @ prow()  , 79 say '|'
    @ prow()+1, 00 say '|------------------------------------------------------------------------------|'
    @ prow()+1, 00 say '| Data Mov.     Pol.    MM      Pol.      MM        Qtd.Kg          Destino    |'
    @ prow()+1, 00 say '|------------------------------------------------------------------------------|'

end
return

/*
-----------------------------------------------------------------------------
		      Procedimento Det_96
-----------------------------------------------------------------------------
*/
procedure det_96()


if ! TUDO =1

   SELECT EST010

   EST010->( dbgotop() )
   EST010->( dbsetorder (2) )

   EST010->( dbseek( W_CHAVE_ITEM ) )

end

if TUDO == 1

  tudoprn96()
  return

end

if W_CHAVE_ITEM == ( EST010->FORMA )
   IMPTELA96001()
   RETURN
end

while W_CHAVE_ITEM ==( EST010->FORMA+EST010->TIPO+EST010->ESTADO )

   IF EST010->OPERACAO == "S"
      if FLAG++ == 0 .and. EST010->OPERACAO == "S"
	 tit_96()
      end
   end

   if prow() > 55
      @ prow()+1, 00 say '|------------------------------------------------------------------------------|'
      cab_96()
      tit_96()
   end

   // linha detalhe
   if EST010->DATAMOVI >= W_DATA_INI .and. ;
    ( EST010->DATAMOVI <= W_DATA_FIM .or. empty( W_DATA_FIM )) .and. ;
      EST010->OPERACAO == "S"

      @ prow()+1, 00	   say '|'
      @ prow()	, 02	   say dtoc(EST010->DATAMOVI)
      @ prow()	, 12	   say EST010->BIT_INT+' '+EST010->BIT_FN+'/'+''+EST010->BIT_FD+''+STR(BIT_MM,8,3)
      @ prow()	, PCOL()+2 say EST010->ESP_INT+' '+EST010->ESP_FN+'/'+EST010->ESP_FD+''+STR(ESP_MM,8,3) //38 say
      @ prow()	, 50	   say str(EST010->QTD_KG,12,2)
      @ prow()	, 63	   say EST010->ORIGEM
      @ prow()	, 79	   say "|"

      W_TOTAL_KG += EST010->QTD_KG

      modo:=1
   end
   inkey()
   if lastkey() = K_ESC
      @ prow()+1, 04 say ''
      @ prow()+1, 04 say ''
      @ prow()+1, 00 say padc('****    Impressao interrompida pelo usuario    ****',80)
      @ prow()+1, 04 say ''
      @ prow()+1, 04 say ''

      EST010->( dbgobottom())
      EST010->( dbskip())

      return
   end
   EST010->( dbskip())
end





while W_CHAVE_ITEM == ( EST010->FORMA+EST010->TIPO+EST010->ESTADO +;
		     str( EST010->BIT_MM, 8, 3 ) + STR( ESP_MM,8,3 )  )

   IF EST010->OPERACAO == "S"

      if FLAG++ = 0
	 tit_96()
      end
   end

   if prow() > 55
      @ prow()+1, 00 say '|------------------------------------------------------------------------------|'
      cab_96()
      tit_96()
   end

   // linha detalhe
   if	EST010->DATAMOVI >= W_DATA_INI .and. ;
      ( EST010->DATAMOVI <= W_DATA_FIM .or. empty( W_DATA_FIM )) .and. ;
	EST010->OPERACAO == "S"

      @ prow()+1, 00 say '|'
      @ prow()	, 02 say dtoc(EST010->DATAMOVI)
      @ prow()	,12 say EST010->BIT_INT+' '+EST010->BIT_FN+'/'+''+EST010->BIT_FD+''+STR(BIT_MM,8,3)
      @ prow()	,PCOL()+2 say EST010->ESP_INT+' '+EST010->ESP_FN+'/'+EST010->ESP_FD+''+STR(ESP_MM,8,3) //38 say
      @ prow()	, 51 say str(EST010->QTD_KG,12,2)
      @ prow()	, 64 say left( EST010->ORIGEM, 15)
      @ prow()	, 79 say "|"

      W_TOTAL_KG += EST010->QTD_KG

      modo:=1

   end

   inkey()

   if lastkey() = K_ESC
      @ prow()+1, 04 say ''
      @ prow()+1, 04 say ''
      @ prow()+1, 00 say padc('****    Impressao interrompida pelo usuario    ****',80)
      @ prow()+1, 04 say ''
      @ prow()+1, 04 say ''
      EST010->( dbgobottom())
      EST010->( dbskip())
      return
   end

   EST010->( dbskip())
end

return

/*
-----------------------------------------------------------------------------
		      Procedimento Tela
-----------------------------------------------------------------------------
*/
procedure TELA_96()

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
-----------------------------------------------------------------------------
		      Funcao ZERA_96
-----------------------------------------------------------------------------
*/
procedure zera_96()

//   X_FORMA	:= space(03)
//   X_TIPO	:= space(05)
//   X_ESTADO	:= space(01)
   X_BIT_MM   := 0.00
   X_ESP_MM   := 0.00
   X_BIT_INT  := space(02)
   X_BIT_FN   := space(02)
   X_BIT_FD   := space(02)
   X_ESP_INT  := space(02)
   X_ESP_FN   := space(02)
   X_ESP_FD   := space(02)
   X_TODOS_IT := .t.
   W_TOTAL_KG := 0
return

/*
-----------------------------------------------------------------------------
		      Funcao TIRA_ESTADO
-----------------------------------------------------------------------------
*/
function tira_estado( VAR )

   local WRET := .T.
   VAR := stuff(VAR,9,1,"") // retira o ESTADO da chave

   EST007->( dbsetorder(1) )
   EST007->( dbseek( VAR ) )

   if EST007->( ! found() )
      WRET := .F.
   end

return WRET

/*

+------------------------------------------------------------------------------+
|  TENAX A‡os Especiais 			   Data: 16/09/95    Pag.: 01  |
|									       |
|			Listagem de Saida de Material			       |
|------------------------------------------------------------------------------|
|  001 1020 L	    ACO SAE 1020 RED.					       |
|------------------------------------------------------------------------------|
| Data da Movimentacao	      Quantidade em Kg		    Destino	       |
|------------------------------------------------------------------------------|
|      12/12/12 		  123456789.12	123456789012345678901234567890 |
|      12/12/12 		  123456789.12	123456789012345678901234567890 |
|      12/12/12 		  123456789.12	123456789012345678901234567890 |
|									       |
|------------------------------------------------------------------------------|
|	     Total no periodo	  123456789.12 Kg			       |
|------------------------------------------------------------------------------|

*/

*-------------------------------------------------------------------------------
				function  imp9601()
*-------------------------------------------------------------------------------

       set device to screen
       clear
       det_9601()
    if ! tudo==1
      if zero !=1
	  rodape_9601()
	  INKEY(0)
       end
    end
      @ 24,15 say'               FIM   DE  SERVICO !!!  '
      INKEY(0)
       restscreen(24,00,24,79, OLD_STATUS)
return nil

return


// fim do programa
/*
-----------------------------------------------------------------------------
		      Procedimento Rodape_9601
-----------------------------------------------------------------------------
*/
procedure rodape_9601()

    @ row()+1, 00     say'ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿'
    @ row()+1, 00     say'³           Total no periodo :                                                ³'
    @ row()  , 30     say str( W_TOTAL_KG,12,2)
    @ row()+1, 00     say'ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ'

    return
/*
-----------------------------------------------------------------------------
		      Procedimento Tit_9601
-----------------------------------------------------------------------------
*/
procedure tit_9601()
   if ! Tudo = 1 .and. modo=0
    EST004->( dbseek(left(W_CHAVE_ITEM,9))) // posiciona para pegar descricao
   end
    @ 01     , 00 say 'ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿'
    @ row()+1, 00 say '³                             Tenax  Aco  e  Ferro                            ³'
    @ row()+1, 00 say '³                         Listagem de Saida de Material                       ³'
    @ row()  , 70 say 'Pag.: ' + strzero(++NUMPAG,2)
    @ row()+1, 00 say 'ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´'
    @ row()+1, 00 say '³                                                                             ³'
    @ row()+1, 00 say 'ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ'
    @ row()+1, 00 say 'ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿'
    @ row()+1, 00 say '³ Data Mov.     Pol.    MM      Pol.      MM        Qtd.Kg          Origem    ³'
    @ row()+1, 00 say 'ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ'

    @ 05      , 04 say EST004->FORMA

    @ row()  , 08 say  TIPO+' '+X_ESTADO+'  '+EST004->DESCRICAO

    //	  @ row()  , 41 say TIRA_ZERO("BIT10")+padl(EST010->BIT_FN,2)+'/'+padr(EST010->BIT_FD,2)
//    @ row()  , 49 say str( EST010->BIT_MM, 8, 3 )
//    @ row()  , 60 say TIRA_ZERO("ESP10")+padl(EST010->ESP_FN,2)+'/'+padr(EST010->ESP_FD,2)
//    @ row()  , 67 say str( EST010->ESP_MM, 8, 3 )
return

/*
-----------------------------------------------------------------------------
		      Procedimento Det_9601
-----------------------------------------------------------------------------
*/
procedure det_9601()


IF ! TUDO =1
SELECT EST010
EST010->( dbgotop() )
EST010->( dbsetorder (2) )
EST010->( dbseek( W_CHAVE_ITEM ) )
END
flag=0
Lin=10

     if tudo == 1
       telaprn96()
       return
     end

 if  W_CHAVE_ITEM == ( EST010->FORMA )
	    TELA96001()
	   RETURN
  end

    while W_CHAVE_ITEM ==( EST010->FORMA+EST010->TIPO+EST010->ESTADO )

       if EST010->OPERACAO == "S"
	     if FLAG++ == 0 .and. EST010->OPERACAO == "S"
		tit_9601()
	     end
      end

	     if LIN =23
		@ row()+2, 15 say 'Pressione qualquer tecla p/ continuar...'
		inkey(0)
		@ 09,01 CLEAR TO 24,79
		Lin=10
		tit_9601()
	     end

	  // linha detalhe
	     if EST010->DATAMOVI >= W_DATA_INI .and. ;
	      ( EST010->DATAMOVI <= W_DATA_FIM .or. empty( W_DATA_FIM )) .and. ;
		EST010->OPERACAO == "S"

		@ LIN	 , 02 say dtoc(EST010->DATAMOVI)
		@ lin,12 say EST010->BIT_INT+' '+EST010->BIT_FN+'/'+''+EST010->BIT_FD+''+STR(BIT_MM,8,3)
		@ lin,COL()+2 say EST010->ESP_INT+' '+EST010->ESP_FN+'/'+EST010->ESP_FD+''+STR(ESP_MM,8,3) //38 say
		@ row()  , 51 say str(EST010->QTD_KG,12,2)
		@ row()  , 64 say left( EST010->ORIGEM, 15 )

		W_TOTAL_KG += EST010->QTD_KG
		  LIN +=1
		 modo:=1
	      end
	     inkey()
	     if lastkey() = K_ESC
		@ row()+1, 04 say ''
		@ row()+1, 04 say ''
		@ row()+1, 00 say padc('****    Impressao interrompida pelo usuario    ****',80)
		@ row()+1, 04 say ''
		@ row()+1, 04 say ''
		EST010->( dbgobottom())
	       EST010->( dbskip())

	       return
	     end
	    EST010->( dbskip())
end    // else

    while W_CHAVE_ITEM == ( EST010->FORMA+EST010->TIPO+EST010->ESTADO +;
			str( EST010->BIT_MM, 8, 3 ) + STR( ESP_MM,8,3 )  )

       if EST010->OPERACAO == "S"
	     if FLAG++ == 0 .and. EST010->OPERACAO == "S"
		tit_9601()
	     end
       end
	     if LIN=23
		@ row()+2, 15 say 'Pressione qualquer tecla p/ continuar...'
		inkey(0)
		@ 09,01 CLEAR TO 24,79
		Lin=10
		tit_9601()
	     end

	  // linha detalhe
	     if EST010->DATAMOVI >= W_DATA_INI .and. ;
	      ( EST010->DATAMOVI <= W_DATA_FIM .or. empty( W_DATA_FIM )) .and. ;
		EST010->OPERACAO == "S"

		@ LIN	 , 02 say dtoc(EST010->DATAMOVI)
		@ lin,12 say EST010->BIT_INT+' '+EST010->BIT_FN+'/'+''+EST010->BIT_FD+''+STR(BIT_MM,8,3)
		@ lin,COL()+2 say EST010->ESP_INT+' '+EST010->ESP_FN+'/'+EST010->ESP_FD+''+STR(ESP_MM,8,3) //38 say
		@ row()  , 51 say str(EST010->QTD_KG,12,2)
		@ row()  , 64 say left( EST010->ORIGEM, 15 )
		W_TOTAL_KG += EST010->QTD_KG
		 LIN +=1
		 modo:=1
	      end
	     inkey()
	     if lastkey() = K_ESC
		@ row()+1, 04 say ''
		@ row()+1, 04 say ''
		@ row()+1, 00 say padc('****    Impressao interrompida pelo usuario    ****',80)
		@ row()+1, 04 say ''
		@ row()+1, 04 say ''
		EST010->( dbgobottom())
	       EST010->( dbskip())
	       return
	     end

	    EST010->( dbskip())

 end
return

//----------------------------------------------------------------------------
//----------------------------------------------------------------------------
//----------------------------------------------------------------------------
//----------------------------------------------------------------------------
//			 LISTAGEM  NA	 IMPRESSORA
//----------------------------------------------------------------------------
//----------------------------------------------------------------------------
//----------------------------------------------------------------------------
//----------------------------------------------------------------------------
/*
------------------------------------------------------------------------------
			  function tudoprn96()
------------------------------------------------------------------------------
*/
 function tudoprn96()


while EST004-> ( ! eof() )		   // IMPRESSORA  Listar todos os itens


select est004
est4:=EST004->forma+tipo
EST010->( dbsetorder (2) )
EST010->( dbseek( est4 ) )

if EST010->( ! FOUND() )
  EST004->( dbskip())
  loop
end
  while  est4  == EST010->FORMA+TIPO
  select EST010

	     if prow() > 55
	     @ prow()+1, 00 say '|------------------------------------------------------------------------------|'
	     @ 00 , 00 say ''
	     flag:=1
	     cab_96()
	     tit_96()
	     end

	  // linha detalhe
	     if EST010->DATAMOVI >= W_DATA_INI .and. ;
	      ( EST010->DATAMOVI <= W_DATA_FIM .or. empty( W_DATA_FIM )) .and. ;
		EST010->OPERACAO == "S"

		 if flag==0
		    cab_96()
		    tit_96()
		    flag:=1
		 end

		@ prow()+1, 00 say '|'
		@ prow()  , 02 say dtoc(EST010->DATAMOVI)
		@ prow()  ,12 say EST010->BIT_INT+' '+EST010->BIT_FN+'/'+''+EST010->BIT_FD+''+STR(BIT_MM,8,3)
		@ prow()  ,PCOL()+2 say EST010->ESP_INT+' '+EST010->ESP_FN+'/'+EST010->ESP_FD+''+STR(ESP_MM,8,3) //38 say
		@ prow()  , 51 say str(EST010->QTD_KG,12,2)
		@ prow()  , 64 say left( EST010->ORIGEM, 15 )
		@ prow()  , 79 say "|"
		W_TOTAL_KG += EST010->QTD_KG
		 modo:=1

	      end
	     inkey()
	     if lastkey() = K_ESC
		@ prow()+1, 04 say ''
		@ prow()+1, 04 say ''
		@ prow()+1, 00 say padc('****    Impressao interrompida pelo usuario    ****',80)
		@ prow()+1, 04 say ''
		@ prow()+1, 04 say ''
		EST010->( dbgobottom())
	       EST010->( dbskip())

	       return
	     end
	      EST010->( dbskip())
	   if  est4 != EST010->FORMA+TIPO .and. flag == 1
	    rodape_96()
	    w_total_kg := 0
	   end
    end
	      EST004->( dbskip())
	      flag:=0

end
return
//----------------------------------------------------------------------------
//----------------------------------------------------------------------------
//----------------------------------------------------------------------------
//----------------------------------------------------------------------------
//			   LISTAGEM  NA    TELA
//----------------------------------------------------------------------------
//----------------------------------------------------------------------------
//----------------------------------------------------------------------------
//----------------------------------------------------------------------------

/*
------------------------------------------------------------------------------
			  function telaprn96()
------------------------------------------------------------------------------
*/
 function telaprn96()


while EST004-> ( ! eof() )		   //	   TELA    Listar todos os itens
    select est004
    est4:=EST004->forma+tipo
    EST010->( dbsetorder (2) )
    EST010->( dbseek( est4 ) )
    LIN:=10
    if EST010->( ! FOUND() )
      EST004->( dbskip())
      loop
    end

  while  est4  == EST010->FORMA+TIPO
   select EST010

	     if LIN = 23
		@ row()+2, 15 say 'Pressione qualquer tecla p/ continuar...'
		inkey(0)
		@ 09,01 CLEAR TO 24,79
		Lin=10
		flag:=1
		tit_9601()
	     end

	   // linha detalhe
	      if EST010->DATAMOVI >= W_DATA_INI .and. ;
	       ( EST010->DATAMOVI <= W_DATA_FIM .or. empty( W_DATA_FIM )) .and. ;
		 EST010->OPERACAO == "S"

		 if flag==0
		    tit_9601()
		    flag:=1
		 end

		@ LIN	 , 02 say dtoc(EST010->DATAMOVI)
		@ lin,12 say EST010->BIT_INT+' '+EST010->BIT_FN+'/'+''+EST010->BIT_FD+''+STR(BIT_MM,8,3)
		@ lin,COL()+2 say EST010->ESP_INT+' '+EST010->ESP_FN+'/'+EST010->ESP_FD+''+STR(ESP_MM,8,3) //38 say
		@ row()  , 51 say str(EST010->QTD_KG,12,2)
		@ row()  , 63 say left( EST010->ORIGEM, 15  )
		 W_TOTAL_KG += EST010->QTD_KG
		  LIN += 1
		 modo:=1
	       end
	      inkey()
	      if lastkey() = K_ESC
		 @ row()+1, 04 say ''
		 @ row()+1, 04 say ''
		 @ row()+1, 00 say padc('****    Impressao interrompida pelo usuario    ****',80)
		 @ row()+1, 04 say ''
		 @ row()+1, 04 say ''
		 EST010->( dbgobottom())
		EST010->( dbskip())
		return
	      end
	   EST010->( dbskip())
       end
	     if  est4 != EST010->FORMA+TIPO .and. flag == 1
	      rodape_9601()
	     w_total_kg := 0
	     INKEY(0)
	     @ 09,00 CLEAR TO 24,79
	    end

      EST004->( dbskip())
      flag:=0

end
return

//-----------
//-----------
//-----------
//-----------
//-----------

function   tela96001()
//-----------
//-----------
//-----------
//-----------
//-----------

//while EST004->forma == w_chave_item			   //	   TELA    Listar todos os itens
    select est004

    est4:= w_chave_item //:= EST004->forma
    EST010->( dbsetorder (2) )
    EST010->( dbseek( est4 ) )
    LIN:=10
    if EST010->( ! FOUND() )
      EST004->( dbskip())
      return
    end


  while  est4  == EST010->FORMA
   select EST010

     forti:=forma+tipo

  while  forti	== EST010->FORMA+tipo
	     if LIN = 23
		@ row()+2, 15 say 'Pressione qualquer tecla p/ continuar...'
		inkey(0)
		@ 09,01 CLEAR TO 24,79
		Lin=10
		flag:=1
		tit_9601()
	     end
	      if EST010->DATAMOVI >= W_DATA_INI .and. ;
	       ( EST010->DATAMOVI <= W_DATA_FIM .or. empty( W_DATA_FIM )) .and. ;
		 EST010->OPERACAO == "S"

		 if flag == 0
		   tit_9601()
		   flag:=1
		 end
		@ LIN	 , 02 say dtoc(EST010->DATAMOVI)
		@ lin,12 say EST010->BIT_INT+' '+EST010->BIT_FN+'/'+''+EST010->BIT_FD+''+STR(BIT_MM,8,3)
		@ lin,COL()+2 say EST010->ESP_INT+' '+EST010->ESP_FN+'/'+EST010->ESP_FD+''+STR(ESP_MM,8,3) //38 say
		@ row()  , 51 say str(EST010->QTD_KG,12,2)
		@ row()  , 63 say left( EST010->ORIGEM, 15  )
		 W_TOTAL_KG += EST010->QTD_KG
		  lin += 1
		  MODO:=1
	       end
	      inkey()
	      if lastkey() = K_ESC
		 @ row()+1, 04 say ''
		 @ row()+1, 04 say ''
		 @ row()+1, 00 say padc('****    Impressao interrompida pelo usuario    ****',80)
		 @ row()+1, 04 say ''
		 @ row()+1, 04 say ''
		 EST010->( dbgobottom())
		EST010->( dbskip())
	       return
	      end
	   EST010->( dbskip())
       end

	     if  forti != EST010->FORMA+tipo .and. flag == 1
	      rodape_9601()
	     w_total_kg := 0
	     INKEY(0)
	     @ 09,00 CLEAR TO 24,79
	     lin:=10
	     flag:=0
	    end

   end

return


//----------------------------------------------------------------------------
//----------------------------------------------------------------------------
//----------------------------------------------------------------------------
//			Impressao    so    001
//----------------------------------------------------------------------------
//----------------------------------------------------------------------------
//----------------------------------------------------------------------------
//----------------------------------------------------------------------------

function  imptela96001()

select est004
est4:= w_chave_item //:= EST004->forma
EST010->( dbsetorder (2) )
EST010->( dbseek( est4 ) )

if EST010->( ! FOUND() )
  EST004->( dbskip())
  return
end

  while  est4  == EST010->FORMA
  select EST010
     forti:=forma+tipo

  while  forti	== EST010->FORMA+tipo

	     if prow() > 55
		@ 00, 00 say ''
		@ prow()+1, 00 say '|------------------------------------------------------------------------------|'
		flag:=1
		cab_96()
		tit_96()
	     end

	   // linha detalhe
	      if EST010->DATAMOVI >= W_DATA_INI .and. ;
	       ( EST010->DATAMOVI <= W_DATA_FIM .or. empty( W_DATA_FIM )) .and. ;
		 EST010->OPERACAO == "S"


		 if flag == 0
		   cab_96()
		   tit_96()
		   flag:=1
		 end

		 @ prow()+1, 00 say '|'
		 @ prow()  , 02 say dtoc(EST010->DATAMOVI)
		 @ prow()  ,12 say EST010->BIT_INT+' '+EST010->BIT_FN+'/'+''+EST010->BIT_FD+''+STR(BIT_MM,8,3)
		 @ prow()  ,PCOL()+2 say EST010->ESP_INT+' '+EST010->ESP_FN+'/'+EST010->ESP_FD+''+STR(ESP_MM,8,3) //38 say
		@ row()  , 51 say str(EST010->QTD_KG,12,2)
		@ row()  , 63 say left( EST010->ORIGEM, 15  )
		 @ prow()  , 79 say "|"
		 W_TOTAL_KG += EST010->QTD_KG
		  modo:=1
	       end
	      inkey()
	      if lastkey() = K_ESC
		 @ prow()+1, 04 say ''
		 @ prow()+1, 04 say ''
		 @ prow()+1, 00 say padc('****    Impressao interrompida pelo usuario    ****',80)
		 @ prow()+1, 04 say ''
		 @ prow()+1, 04 say ''
		 EST010->( dbgobottom())
		EST010->( dbskip())

	       return
	     end
	      EST010->( dbskip())
       end

	     if  forti != EST010->FORMA+tipo .and. flag == 1
	      rodape_96()
	     w_total_kg := 0
	     flag:=0
	    end

   end

return

