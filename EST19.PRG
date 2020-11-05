/*

   SCM - Sistema de Controle Metalurgico
   EST19.PRG - Saida de Material

   Dt UltAtu :
   Autor ....:
   Motivo ...:

*/

#include "inkey.ch"
if f_separa
 setcolor(W_CORWD)
else
 setcolor(W_COREDIT)
end
private WRET      := .T. ,;
	W_QTD_TOT :=  0   ,;
	W_QTD_COR :=  EST007->QTD_COR ,;
	CORTES_OK := .F. ,;
	W_CHAVE_ITEM := ( X_FORMA+ X_TIPO+ str( X_BIT_MM, 8, 3 ) + ;
			str( X_ESP_MM, 8, 3 ) + X_ESTADO )      
private W_HEADER := { "   N§      Largura            Comprim  " }
//                     1XXXXX1234X,XXX,XXX.XX123X,XXX,XXX.XX12

private W_FIELDS := { "' '+ str( EST008->SEQUENC, 5 ) + '    ' +" +;
		      " str( EST008->LARGURA, 12, 2 ) + '   '  +" +;
		      " str( EST008->COMPRIM, 12, 2 ) + '  '    "   }

private X_PESO, X_NUM_COR := 0 ,;
		X_N_INT_C := 0 ,;
		X_N_COR_C := 0 ,;
		X_N_BLOQ  := 0 ,;
		X_QSOBCOR := 0 ,;
		X_QSOBBLO := 0 ,;
		X_QTD_SOB := 0


tela_19()

// ------------------------------------------------------------------------
//
// Inicio do laco inicial
//
// ------------------------------------------------------------------------

while .t.

   status('Saida de Material')


   do case
      case X_FORMA = '005'
	 //
	 //
	 //  Saida de CHAPA
	 //
	 //
	 tela_chapa()
	 get_chapa()
	 read
	 if lastkey() = K_ESC; exit; end

	 EST011->( dbsetorder(1) )
	 EST011->( dbseek(X_TIPOMOVI) )

	 //
	 // Verifica numero de cortes
	 //
	 
	  if EST011->ACERTO = 'N' .AND. ( X_N_INT_C = 0 .and. X_N_COR_C = 0 )
	     mensbeep("Numero de pecas inteiras e cortadas = 0")
	     loop
	  end
	

	 @ 10,20 say 'ÚÄÄÄÄÄÄÄ´ Pe‡as Feitas ÃÄÄÄÄÄÄÄ¿'
	 @ 11,20 say '³                              ³'
	 @ 12,20 say '³ Pe‡a n§ ....:       /        ³'
	 @ 13,20 say '³                              ³'
	 @ 14,20 say '³ Quantidade .:                ³'
	 @ 15,20 say '³ R/A/D/M     :                ³'
	 @ 16,20 say '³ Largura ....:                ³'
	 @ 17,20 say '³ Comprimento :                ³'
	 @ 18,20 say '³ Espessura ..:                ³'
	 @ 19,20 say '³ Perda ......:                ³'
	 @ 20,20 say 'ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ'

	 F_SAIDANORMAL := .T.

	 WTOT_PERDA := 0
	 for X := 1 to X_NUM_COR // Qtde pecas vendidas diferentes
	    @ 12,36 say strzero( X, 6)
	    @ 12,43 say strzero( X_NUM_COR, 6)

	    X_PERDA    := 0
	    X_QTDPECAS := 0
	    X_LARGURA  := 0
	    X_COMPRIM  := 0
	    X_ESPESSU  := 0
	    X_SUBFORMA := 'R'

	    while .t.
	       @ 16,20 say '³ Largura ....:                ³'
	       @ 17,20 say '³ Comprimento :                ³'
	       @ 18,20 say '³ Espessura ..:                ³'
	       @ 19,20 say '³ Perda ......:                ³'

	       @ 14,36 get X_QTDPECAS  picture "99999"    valid X_QTDPECAS > 0
	       @ 15,36 get X_SUBFORMA  picture "@!"       valid ! empty( X_SUBFORMA ) .and. X_SUBFORMA $ "RADM"
	       read

	       if lastkey()=K_ESC
		  exit
	       end

	       do case
		  case X_SUBFORMA = 'R' // Retangulo
		     @ 16,20 say '³ Largura ....:                ³'
		     @ 17,20 say '³ Comprimento :                ³'
		     @ 18,20 say '³                              ³'

		     @ 16,36 get X_LARGURA picture "99999.99" valid X_LARGURA > 0
		     @ 17,36 get X_COMPRIM picture "99999.99" valid X_COMPRIM > 0

		  case X_SUBFORMA = 'D' // Disco
		     @ 16,20 say '³ Diametro ...:                ³'
		     @ 17,20 say '³                              ³'
		     @ 18,20 say '³                              ³'

		     @ 16,36 get X_LARGURA picture "99999.99" valid X_LARGURA > 0

		  case X_SUBFORMA = 'A' // Anel
		     @ 16,20 say '³ Diam. Ext.  :                ³'
		     @ 17,20 say '³ Diam. Int.  :                ³'
		     @ 18,20 say '³                              ³'

		     @ 16,36 get X_LARGURA picture "99999.99" valid X_LARGURA > 0
		     @ 17,36 get X_COMPRIM picture "99999.99" valid X_COMPRIM > 0

		  case X_SUBFORMA = 'M' // Modelo
		     @ 16,20 say '³ Perda em Kg :                ³'
		     @ 17,20 say '³                              ³'
		     @ 18,20 say '³                              ³'

		     @ 16,36 get X_PERDA  picture "99999.99" valid X_PERDA > 0

	       endcase
	       read
	       if lastkey()=K_ESC
		  loop
	       else
		  exit
	       end
	    end

	    if lastkey()=27
	       F_SAIDANORMAL := .F.
	       exit
	    end

	    if X_SUBFORMA <> 'M'
	       WTOT_PERDA += calcperda( X_SUBFORMA, X_LARGURA, X_COMPRIM, X_ESPESSU)
	    else
	       WTOT_PERDA += X_PERDA
	    end

	    @ 19,36 say WTOT_PERDA picture '99999.999'
	    inkey(0)

	 next

	 //
	 // Colocar pe‡as que saem do estoque
	 //
	 X_LARGURA := 0
	 X_COMPRIM := 0
	 X_ESPESSU := 0

	 tchapa_cor()
	 chapa_cortada()

	 //
	 // Incluir pe‡as no estoque
	 //
	 @ 10,20 say 'ÚÄÄÄÄÄÄÄ´ Sobra Pe‡as  ÃÄÄÄÄÄÄÄ¿'
	 @ 11,20 say '³                              ³'
	 @ 12,20 say '³ Pe‡a n§ ....:       /        ³'
	 @ 13,20 say '³                              ³'
	 @ 14,20 say '³                              ³'
	 @ 15,20 say '³                              ³'
	 @ 16,20 say '³ Largura ....:                ³'
	 @ 17,20 say '³ Comprimento :                ³'
	 @ 18,20 say '³                              ³'
	 @ 19,20 say '³                              ³'
	 @ 20,20 say 'ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ'

	 F_SAIDANORMAL := .T.

	 for X := 1 to X_QTD_SOB
	    @ 12,36 say strzero( X, 6)
	    @ 12,43 say strzero( X_QTD_SOB, 6)

	    X_QTDPECAS  := 0

	    @ 16,36 get X_LARGURA picture "99999.999" valid X_LARGURA > 0
	    @ 17,36 get X_COMPRIM picture "99999.999" valid X_COMPRIM > 0
	    read
	    if lastkey()=27
	       F_SAIDANORMAL := .F.
	       exit
	    end

	    //
	    // incluir como peca cortada
	    //
	    EST008->( dbappend() )

	    EST008->FORMA   := X_FORMA
	    EST008->TIPO    := X_TIPO
	    EST008->ESTADO  := X_ESTADO
	    EST008->BIT_MM  := X_BIT_MM
	    EST008->ESP_MM  := X_ESP_MM
	    EST008->BIT_INT := X_BIT_INT
	    EST008->BIT_FN  := X_BIT_FN
	    EST008->BIT_FD  := X_BIT_FD
	    EST008->ESP_INT := X_ESP_INT
	    EST008->ESP_FN  := X_ESP_FN
	    EST008->ESP_FD  := X_ESP_FD

	    EST008->SEQUENC := sequencia( W_CHAVE_ITEM )
	    EST008->COMPRIM := X_COMPRIM
	    EST008->LARGURA := X_LARGURA
	 next

	 if F_SAIDANORMAL
	    // Baixa no estoque da qtd total de Kg
	    while EST007->( ! rlock() ); end
	    while EST008->( ! rlock() ); end

	    // diminuir a quantidade de pecas inteiras
	    EST007->QTD_INT := EST007->QTD_INT - X_N_INT_C

	    // diminuir o peso das inteiras
	    EST007->QTD_KGI = EST007->QTD_KGI - WTOT_PERDA - X_QTD_KG - X_SUCATA

	    // diminuir o peso total
	    IF f_separa
	      EST007->QTD_KGT = EST007->QTD_KGT - WTOT_PERDA - X_SUCATA
	    else
	     EST007->QTD_KGT = EST007->QTD_KGT - WTOT_PERDA - X_QTD_KG - X_SUCATA
	    end
	    // Acertar o numero de pecas cortadas
	    EST007->QTD_COR = EST007->QTD_COR - X_N_COR_C + X_QTD_SOB

	 end

      case X_FORMA = '006'
	 //--------------------------------------------------------------
	 //
	 //  Saida de BLOCO
	 //
	 //--------------------------------------------------------------
	 tela_bloco()
	 if get_bloco()

	    if lastkey() = K_ESC; exit; end

	    EST011->( dbsetorder(1) )
	    EST011->( dbseek(X_TIPOMOVI) )

	    //
	    // Verifica numero de cortes
	    //
	    if EST011->ACERTO = 'N' .AND. ( X_N_INT_C = 0 .and. X_N_COR_C = 0 .and. X_N_BLOQ = 0 )
	       mensbeep("Numero de pecas inteiras/cortadas/caixote = 0")
	       loop
	    end

	    X_QTD_KG := 0
	    //
	    // Acertar pecas inteiras
	    //
	    WSCRBLQ := savescreen(10,20,20,57)

	    for X := 1 to X_N_INT_C
	       @ 10,20 say 'ÚÄÄÄÄÄÄÄ´ Inteiras ÃÄÄÄÄÄÄÄÄÄÄÄ¿'
	       @ 11,20 say '³                              ³'
	       @ 12,20 say '³ Pe‡a n§ ....:       /        ³'
	       @ 13,20 say '³                              ³'
	       @ 14,20 say '³ Entrada no                   ³'
	       @ 15,20 say '³ Bloco mm ...:                ³'
	       @ 16,20 say '³                              ³'
	       @ 17,20 say '³ Sobra ......:                ³'
	       @ 18,20 say '³                              ³'
	       @ 19,20 say '³                              ³'
	       @ 20,20 say 'ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ'
	       @ 12,36 say strzero(X  , 6)
	       @ 12,43 say strzero(X_N_INT_C, 6)

	       X_ENTCOMP := 0
	       X_COMPRIM := 0

	       @ 15,36 get X_ENTCOMP picture "99999.999" valid X_ENTCOMP > 0 .and. X_ENTCOMP <= 8000
	       @ 17,36 get X_COMPRIM picture "99999.999" valid X_COMPRIM >= 0
	       read
	       X_QTD_KG := X_QTD_KG + X_ENTCOMP
	       if lastkey()=27
		  F_SAIDANORMAL := .F.
		  exit
	       end

	       //
	       // incluir como peca cortada
	       //

	       if X_COMPRIM > 0 // Incluir peca cortada

		  // Acertar o numero de pecas cortadas
		  while EST007->( ! rlock() ); end
		  EST007->QTD_COR = EST007->QTD_COR + 1
		  EST007->( dbunlock() )

		  select EST008
		  EST008->( dbappend() )

		  EST008->FORMA   := X_FORMA
		  EST008->TIPO    := X_TIPO
		  EST008->ESTADO  := X_ESTADO
		  EST008->BIT_MM  := X_BIT_MM
		  EST008->ESP_MM  := X_ESP_MM
		  EST008->BIT_INT := X_BIT_INT
		  EST008->BIT_FN  := X_BIT_FN
		  EST008->BIT_FD  := X_BIT_FD
		  EST008->ESP_INT := X_ESP_INT
		  EST008->ESP_FN  := X_ESP_FN
		  EST008->ESP_FD  := X_ESP_FD
		  EST008->SEQUENC := sequencia( W_CHAVE_ITEM )
		  EST008->COMPRIM := X_COMPRIM
		  mensbeep('Peca cortada com sucesso.')
	       else

		  while EST008->( ! rlock() ); end
		  EST008->( dbdelete() )
		  mensbeep("Peca excluida com sucesso. <ENTER>")
	       end

	       // diminuir a quantidade de pecas inteiras
	       while EST007->( ! rlock() ); end
	       EST007->QTD_INT := EST007->QTD_INT - 1
	       EST007->( dbunlock())

	    next
	    restscreen(10,20,20,57,WSCRBLQ)
	    //
	    // Diminuir blocos cortados
	    //
	    tchapa_cor()
	    bloco_cortado()

	    //
	    // Diminuir bloquinhos cortados
	    //
	    tchapa_cor()
	    bloquinhos()

	    //
	    // Incluir pe‡as no estoque
	    //
	    @ 10,20 say 'ÚÄÄÄÄÄÄÄ´ Bloquinhos ÃÄÄÄÄÄÄÄÄÄ¿'
	    @ 11,20 say '³                              ³'
	    @ 12,20 say '³ Pe‡a n§ ....:       /        ³'
	    @ 13,20 say '³                              ³'
	    @ 14,20 say '³                              ³'
	    @ 15,20 say '³                              ³'
	    @ 16,20 say '³ Espessura ..:                ³'
	    @ 17,20 say '³ Largura ....:                ³'
	    @ 18,20 say '³ Comprimento :                ³'
	    @ 19,20 say '³                              ³'
	    @ 20,20 say 'ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ'

	    F_SAIDANORMAL := .T.
	    for X := 1 to X_QSOBBLO
	       @ 12,36 say strzero( X, 6)
	       @ 12,43 say strzero( X_QSOBBLO, 6)

	       X_QTDPECAS  := 0
	       X_ESPESSU   := 0
	       X_LARGURA   := 0
	       X_COMPRIM   := 0

	       @ 16,36 get X_ESPESSU picture "99999.999" valid X_ESPESSU > 0
	       @ 17,36 get X_LARGURA picture "99999.999" valid X_LARGURA > 0
	       @ 18,36 get X_COMPRIM picture "99999.999" valid X_COMPRIM > 0
	       read
	       if lastkey()=27
		  F_SAIDANORMAL := .F.
		  exit
	       end

	       //
	       // incluir como bloquinho
	       //
	       EST040->( dbappend() )
	       EST040->FORMA     := X_FORMA
	       EST040->TIPO      := X_TIPO
	       EST040->ESPESSU   := X_ESPESSU
	       EST040->LARGURA   := X_LARGURA
	       EST040->COMPRIM   := X_COMPRIM
	    next

	    if F_SAIDANORMAL
	       // Baixa no estoque da qtd total de Kg
	       while EST007->( ! rlock() ); end
	       while EST008->( ! rlock() ); end

	       WTOTSAIKG := X_QTD_KG * EST007->PES_MTR /1000

	       // diminuir o peso das inteiras
	       EST007->QTD_KGI = EST007->QTD_KGI - WTOTSAIKG

	       // diminuir o peso total
	       if f_separa
	       *  EST007->QTD_KGT = EST007->QTD_KGT - WTOTSAIKG
	       else
		 EST007->QTD_KGT = EST007->QTD_KGT - WTOTSAIKG
	      end

	    end
	 end

      Otherwise

	 //
	 //
	 //  Saida NORMAL
	 //
	 //

	 get_19()
	 read
	 if lastkey() = K_ESC; exit; end

	 EST011->( dbsetorder(1) )
	 EST011->( dbseek(X_TIPOMOVI) )
	  if (EST011->ACERTO = 'N' .AND. X_TIPO # 'APW' .AND. X_TIPO#'APC') .AND. ( X_N_INT_C = 0 .and. X_N_COR_C = 0 ) 
	     mensbeep("N£mero de pe‡as inteiras e cortadas = 0")
	     loop
	  end

	 conta_cortadas()
	 AX_NUM_COR := X_NUM_COR

	 //
	 // Cortes peca inteira
	 //

	 if X_N_INT_C # 0
	    tela_19int()
	    CORTES_OK := peca_inteira()
	 end

	 //
	 // Cortes peca cortada
	 //

	 if X_N_COR_C # 0
	    tela_19cor()
	    clear typeahead
	    CORTES_OK := peca_cortada()
	 end

	 // Retira do estoque a quantidade cortada apenas se ocorrerem
	 // todos os cortes previstos.
	 //

	 if CORTES_OK
	    while EST007->( ! rlock() ); end
	    IF f_separa
	     EST007->QTD_KGT -= AX_NUM_COR * EST007->PER_COR
	    else
	     EST007->QTD_KGT -= X_QTD_KG + AX_NUM_COR * EST007->PER_COR
	    end
	    EST007->( dbunlock() )
	 else
	    if EST011->ACERTO = 'S' .OR. ( X_TIPO = 'APW' .OR. X_TIPO='APC')
	       // EST011->ACERTO = 'S'
	       // Apenas para acerto de saida
	       while EST007->( ! rlock() ); end
	       EST007->QTD_KGT -= X_QTD_KG
	       EST007->( dbunlock() )
	    end
	 end
   endcase

   conta_cortadas()

   exit
end
if f_separa
  grava_19('I')
end
return WRET


/*
--------------------------------------------------------------------------



--------------------------------------------------------------------------
*/
function peca_cortada()
   local P_CAMPOS    := {}
   local MASCARA     := {}
   local P_HEADER    := {}
   local TAMANHO     := {}
   local BESCAPE     := {|| W_CHAVE_ITEM = EST008->FORMA +;
			    EST008->TIPO            +;
			    str(EST008->BIT_MM,8,3) +;
			    str(EST008->ESP_MM,8,3) +;
			    EST008->ESTADO           }

   local COR         := W_COREDIT
   local TITULO      := NIL // "Pe‡as Cortadas"
   local LININI      := 13
   local COLINI      := 06
   local LINFIM      := 21
   local COLFIM      := 73
   local BLOCK_DISP  := {|| .T. }
   local CAB_TITULO  := nil
   local BORDA       := 1

   local TECLA       := nil
   local TABELA      := nil
   local IS_TBROWSE  := .F.

   private X_NCORT := 0, WRET    := .t.

   begin sequence
      EST008->( dbsetorder(2) )

      aadd( P_HEADER, "Sequˆncia"    )
      aadd( P_HEADER, "Comprimento" )
      aadd( P_HEADER, "Largura" )

      aadd( P_CAMPOS, "SEQUENC" )
      aadd( P_CAMPOS, "COMPRIM" )
      aadd( P_CAMPOS, "LARGURA" )

      aadd( MASCARA   , "99999"         )
      aadd( MASCARA   , "9999999999.999" )
      aadd( MASCARA   , "9999999999.999" )

      aadd( TAMANHO   , 15 )
      aadd( TAMANHO   , 20 )
      aadd( TAMANHO   , 20 )

      select EST008
      EST008->( dbsetorder(2) )
      EST008->( dbseek( W_CHAVE_ITEM ) )

      do while ++X_NCORT <= X_N_COR_C
	 mostra_19("CORTADA")

	 TABELA := tabelanew( P_CAMPOS       , ;
			      MASCARA        , ;
			      P_HEADER       , ;
			      TAMANHO        , ;
			      BESCAPE        , ;
			      COR            , ;
			      TITULO         , ;
			      LININI         , ;
			      LINFIM         , ;
			      COLINI         , ;
			      BLOCK_DISP     , ;
			      CAB_TITULO     , ;
			      BORDA          , ;
			      COLFIM           ;
			    )

	 CONTINUA := .T.
	 do while CONTINUA .and. ( (TEC:=tabmov(TABELA) ) != K_ESC )
	    if TEC == 13 ; exit ; end
	 enddo

	 if lastkey() == K_ESC
	    message("        Procedimento interrompido.           ",;
		    "Estoque pode ter sido alterado parcialmente. "  )
	    WRET := .f.
	    break
	 end


	 if X_NUM_COR # 0
	    W_SCR := savescreen(10,20,15,68)
	    telanum('SCR19 ','EST18 ')

	    @ 10,20 say 'ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿'
	    @ 11,20 say '³                                              ³'
	    @ 12,20 say '³ Entre com a sobra (MM) :                     ³'
	    @ 13,20 say '³                                              ³'
	    @ 14,20 say 'ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ'
	    sombra(10,20,14,67)

	    while .t.
	       X_SOBRA := 0
	       @ 12,47 get X_SOBRA picture "99999.99"   valid X_SOBRA >= 0
	       read
	       if X_SOBRA = EST008->COMPRIM
		  message('Sobra igual a peca cortada! <ENTER>')
	       elseif X_SOBRA > EST008->COMPRIM
		  message("Sobra e' maior do que a peca cortada! <ENTER>")
	       else
		  exit
	       end
	    end
	    if lastkey() == K_ESC
	       message("        Procedimento interrompido.           ",;
		       "Estoque pode ter sido alterado parcialmente. "  )
	       WRET := .f.
	       break
	    end

	    restscreen(10,20,15,68,W_SCR)
	 else
	    X_SOBRA := 0
	 end

	 // caso a sobra seja igual a zero, excluir a peca cortada.

	 while EST007->( ! rlock() ); end
	 while EST008->( ! rlock() ); end

	 if X_SOBRA == 0

	    // diminuir a quantidade de quilos do arquivo MATERIAL
	    EST007->QTD_KGC -= EST008->QTD_KG - EST007->PES_MTR * X_SOBRA*1000

	    W_QTD_TOT := EST007->QTD_KGC

	    // diminui o numero de pecas cortadas
	    EST007->QTD_COR := EST007->QTD_COR - 1  // Banco
	    W_QTD_COR       := EST007->QTD_COR      // Display

	    // exclui peca
	    EST008->( dbdelete() )
	    mensbeep("Pe‡a retirada de estoque com sucesso. <ENTER>")

	 else
	    // caso a sobra seja maior que zero...
	    // diminuir a quantidade de quilos do arquivo MATERIAL
	    W_QTD_TOT := EST007->QTD_KGC -= EST008->QTD_KG - ;
					    EST007->PES_MTR * X_SOBRA/1000

	    // diminuir a quantidade de QUILOS da peca no arquivo de
	    // pecas cortadas
	    EST008->QTD_KG := EST007->PES_MTR * X_SOBRA/1000

	    // diminuir o comprimento da peca no arquivo de pecas cortadas
	    EST008->COMPRIM := X_SOBRA

	    if X_NUM_COR # 0
	       X_NUM_COR--
	    end
	    mensbeep("Pe‡a cortada com sucesso. <ENTER>")
	 end

	 EST007->( dbunlock() )
	 EST008->( dbunlock() )
      enddo

   end sequence

return( WRET )

/*
--------------------------------------------------------------------------



--------------------------------------------------------------------------
*/
function peca_inteira()
   local WRET    := .t. ,;
	 W_SCR  := savescreen(10,00,15,79)

   private X_NINT := 0 ,;
	   N_AREA := select()

   select( "EST008" )
   begin sequence

      do while ++X_NINT <= X_N_INT_C

	 mostra_19("INTEIRA")
	 if X_NUM_COR # 0
	    telanum('SCR19 ','EST18 ')
	    @ 10,20 say 'ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿'
	    @ 11,20 say '³                                              ³'
	    @ 12,20 say '³ Entre com a sobra (MM) :                     ³'
	    @ 13,20 say '³                                              ³'
	    @ 14,20 say 'ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ'
	    sombra(10,20,14,67)

	    X_SOBRA := 0
	    @ 12,47 get X_SOBRA picture "99999.99"
	    read
	    restscreen(10,00,15,79,W_SCR)
	 else
	    X_SOBRA := 0
	 end

	 if lastkey() == K_ESC
	    message("        Procedimento interrompido.           ",;
		    "Estoque pode ter sido alterado parcialmente. "  )
	    WRET    := .f.
	    break
	 end

	 while EST007->( ! rlock() ); end
	 while EST008->( ! rlock() ); end

	 // diminuir a quantidade de pecas inteiras
	 EST007->QTD_INT := EST007->QTD_INT - 1

	 // diminuir o peso das inteiras
	 EST007->QTD_KGI = EST007->QTD_KGI - EST007->PES_INT

	 // so inclui nova peca como peca cortada, se tiver sobra

	 if X_SOBRA > 0
	    // atualiza quantidade de pecas cortadas no arquivo EST007,
	    // ITEM DE MATERIAL
	    EST007->QTD_COR := EST007->QTD_COR - 1

	    // incrementa o numero de pecas cortadas no display
	    W_QTD_COR := EST007->QTD_COR

	    // incluir como peca cortada
	    EST008->( dbappend() )

	    EST008->FORMA   := X_FORMA
	    EST008->TIPO    := X_TIPO
	    EST008->ESTADO  := X_ESTADO
	    EST008->BIT_MM  := X_BIT_MM
	    EST008->ESP_MM  := X_ESP_MM
	    EST008->BIT_INT := X_BIT_INT
	    EST008->BIT_FN  := X_BIT_FN
	    EST008->BIT_FD  := X_BIT_FD
	    EST008->ESP_INT := X_ESP_INT
	    EST008->ESP_FN  := X_ESP_FN
	    EST008->ESP_FD  := X_ESP_FD

	    EST008->SEQUENC := sequencia( W_CHAVE_ITEM )
	    EST008->COMPRIM := X_SOBRA

	    // peso da peca cortada ( KG/MTR )
	    EST008->QTD_KG := X_SOBRA/1000 * EST007->PES_MTR

	    if X_NUM_COR # 0
	       X_NUM_COR--   // Controla o get da Sobra
	    end

	    mensbeep("Pe‡a cortada com sucesso. <ENTER>")
	 else
	    mensbeep("Pe‡a retirada de estoque com sucesso. <ENTER>")
	 end
	 EST007->( dbunlock() )
	 EST008->( dbunlock() )
      enddo
   end sequence
   select ( N_AREA )

return WRET


/*
--------------------------------------------------------------------------



--------------------------------------------------------------------------
*/
procedure get_19()

   if !f_separa
     @ 11,20 get X_ALMOXARI picture "@K!"        valid TES_ALMOXA( X_ALMOXARI, 1 )
     @ 13,28 get X_TIPOMOVI picture "@K!"        valid TES_MOVIME( X_TIPOMOVI )
     @ 15,28 get X_DATAMOVI                      valid ! empty( X_DATAMOVI )
   end
   @ 17,24 get X_NUM_COR  picture "9999999"    valid X_NUM_COR >= 0
   @ 18,44 get X_N_INT_C  picture "99999"      valid TES_QTD( X_N_INT_C, 1 )
   @ 19,44 get X_N_COR_C  picture "99999"      valid TES_QTD( X_N_COR_C, 2 )
   if !f_separa
     @ 17,62 get X_QTD_KG   picture "9999999.99" valid TES_QTD_KG( X_QTD_KG )
   end
   @ 21,14 get X_ORIGEM   picture "@!"

return


/*
--------------------------------------------------------------------------



--------------------------------------------------------------------------
*/
procedure Conta_Cortadas()


   EST008->( dbsetorder(1) )
   EST008->( dbseek( W_CHAVE_ITEM ) )

   // para saber o numero de pecas cortadas
   W_QTD_COR := 0
   while W_CHAVE_ITEM = EST008->FORMA               +;
			EST008->TIPO               +;
			str( EST008->BIT_MM, 8, 3 )   +;
			str( EST008->ESP_MM, 8, 3 )   +;
			EST008->ESTADO

      W_QTD_COR++                   // conta o numero de pecas cortadas
      EST008->( dbskip() )

   end

   // atualiza numero de pecas cortadas
   while EST007->( ! rlock() ); end
   EST007->QTD_COR := W_QTD_COR
   EST007->( dbunlock() )

return


/*
--------------------------------------------------------------------------



--------------------------------------------------------------------------
*/
function tes_qtd( N_PECA, POSICAO )
   local WRET := .t.
   EST007->( dbsetorder(1) )
   EST007->( dbseek( W_CHAVE_ITEM ) )

   if ( POSICAO == 1 .and. N_PECA > EST007->QTD_INT ) .or. ;
      ( POSICAO == 2 .and. N_PECA > EST007->QTD_COR )
      mensbeep("N£mero de pe‡as insuficiente em estoque. <ENTER>")
      WRET := .f.
   end

return( WRET )


/*
--------------------------------------------------------------------------
		  TES_QTD_KG
--------------------------------------------------------------------------
*/
function tes_qtd_kg( PESO )
   local WRET := .t.
   EST007->( dbsetorder(1) )
   EST007->( dbseek( W_CHAVE_ITEM ) )

   if PESO > EST007->QTD_KGT
      mensbeep("Quantidade insuficiente em estoque. <ENTER>")
      WRET := .f.
   elseif PESO == 0
      mensbeep("Peso inv lido! <ENTER>")
      WRET := .f.
   end

return( WRET )



/*
-----------------------------------------------------------------------------

		      Funcao ZERA_19

-----------------------------------------------------------------------------
*/
procedure zera_19()

   X_FORMA    := space(03)
   X_TIPO     := space(05)
   X_ESTADO   := space(01)
   X_BIT_MM   := 0.00
   X_ESP_MM   := 0.00
   X_BIT_INT  := space(02)
   X_BIT_FN   := space(02)
   X_BIT_FD   := space(02)
   X_ESP_INT  := space(02)
   X_ESP_FN   := space(02)
   X_ESP_FD   := space(02)

   X_OPERACAO := space(01)
   X_ALMOXARI := space(03)
   X_TIPOMOVI := space(03)
   X_DATAMOVI := date()
   X_QTD_KG   := 0
   X_QTD_INT  := 0
   X_VAL_KG   := 0.00000
   X_ORIGEM   := space(30)

return

/*
-----------------------------------------------------------------------------

		      Funcao ATRIBUI_19

-----------------------------------------------------------------------------
*/
procedure atribui_19()

   X_FORMA    := EST010->FORMA
   X_TIPO     := EST010->TIPO
   X_ESTADO   := EST010->ESTADO
   X_BIT_MM   := EST010->BIT_MM
   X_ESP_MM   := EST010->ESP_MM
   X_BIT_INT  := EST010->BIT_INT
   X_BIT_FN   := EST010->BIT_FN
   X_BIT_FD   := EST010->BIT_FD
   X_ESP_INT  := EST010->ESP_INT
   X_ESP_FN   := EST010->ESP_FN
   X_ESP_FD   := EST010->ESP_FD
   X_OPERACAO := EST010->OPERACAO
   X_ALMOXARI := EST010->ALMOXARI
   X_TIPOMOVI := EST010->TIPOMOVI
   X_DATAMOVI := EST010->DATAMOVI
   X_QTD_KG   := EST010->QTD_KG
   X_QTD_INT  := EST010->QTD_INT
   X_VAL_KG   := EST010->VAL_KG
   X_ORIGEM   := EST010->ORIGEM

return

/*
-----------------------------------------------------------------------------

		      Funcao GRAVA_19()

-----------------------------------------------------------------------------
*/
procedure GRAVA_19( MODO )

   if MODO = "I"
      EST010->( dbappend() )
   else
      while EST010->( ! rlock() ); end
   end

   EST010->FORMA    := X_FORMA
   EST010->TIPO     := X_TIPO
   EST010->ESTADO   := X_ESTADO
   EST010->BIT_MM   := X_BIT_MM
   EST010->ESP_MM   := X_ESP_MM
   EST010->BIT_INT  := X_BIT_INT
   EST010->BIT_FN   := X_BIT_FN
   EST010->BIT_FD   := X_BIT_FD
   EST010->ESP_INT  := X_ESP_INT
   EST010->ESP_FN   := X_ESP_FN
   EST010->ESP_FD   := X_ESP_FD
   IF f_separa
     EST010->QTD_KG   := VEN006->PESO_COBRA
     EST010->OPERACAO := 'S'
     EST010->ALMOXARI := '001'
     EST010->TIPOMOVI := '002'
     EST010->DATAMOVI := DATE()
   ELSE
     EST010->QTD_KG   := X_QTD_KG
     EST010->OPERACAO := X_OPERACAO
     EST010->ALMOXARI := X_ALMOXARI
     EST010->TIPOMOVI := X_TIPOMOVI
     EST010->DATAMOVI := X_DATAMOVI

   END

   EST010->QTD_INT  := X_QTD_INT
   EST010->VAL_KG   := X_VAL_KG
   EST010->ORIGEM   := X_ORIGEM

   EST010->( dbunlock() )

return


/*
-----------------------------------------------------------------------------

		      Funcao calcperda

 -> Calcula perda

-----------------------------------------------------------------------------
*/
function calcperda( P_SUBFORMA, P_LARGMOV, P_COMPMOV, P_ESPEMOV )
local WRET := 0
do case
   case P_SUBFORMA = 'R' // Retangulo
      WRET := (EST007->PER_COR*EST007->PES_MTR*((P_LARGMOV+P_COMPMOV)*2)*X_QTDPECAS)/1000

   case P_SUBFORMA = 'D' // Disco
      WRET := (EST007->PER_COR*EST007->PES_MTR)*((P_LARGMOV*3.1416)/1000)*X_QTDPECAS

   case P_SUBFORMA = 'A' // Anel
      WRET := (EST007->PER_COR*EST007->PES_MTR)*(((P_LARGMOV+P_COMPMOV)*3.1416)/1000)*X_QTDPECAS

   case P_SUBFORMA = 'M' // Modelo
      WRET := -1
endcase

return WRET

/*
--------------------------------------------------------------------------



--------------------------------------------------------------------------
*/
procedure mostra_19( WHAT )

  if WHAT == "INTEIRA"
     // atualiza numero de pecas inteira na tela
     @ 11, 50 say EST007->QTD_INT
     @ 09, 61 say X_NINT    picture '9999'
     @ 09, 67 say X_N_INT_C picture '9999'

  elseif WHAT == "CORTADA"
     // atualiza numero de pecas cortadas na tela
     @ 11, 50 say W_QTD_COR picture "99999"
     @ 09, 61 say X_NCORT   picture '9999'
     @ 09, 67 say X_N_COR_C picture '9999'
  end

return

/*
-----------------------------------------------------------------------------

			     Procedimento Tela

-----------------------------------------------------------------------------
*/
procedure TELA_19(flag)

   if f_separa
     @ 15,02 say 'ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ  Baixa de material  ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿'
     @ 17,02 say '³  N£mero de Cortes :                                                      ³'
   else
     @ 17,02 say '³  N£mero de Cortes :                           Qtd em Kg :                ³'
   end
   @ 16,02 say '³                                                                          ³'
   @ 18,02 say '³  N£mero de Pe‡as Utilizadas - Inteiras:                                  ³'
   @ 19,02 say '³                               Cortadas:                                  ³'
   @ 20,02 say '³                                                                          ³'
   @ 21,02 say '³  Destino :                                                               ³'
   @ 22,02 say 'ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ'
   if !f_separa
     @ 23,02 say '                                                                      Est19 '
     telanum('SCR19 ','EST19 ')
  end
return



/*
-----------------------------------------------------------------------------

			     Procedimento Tela

-----------------------------------------------------------------------------
*/
procedure TELA_19INT(flag)

   @ 09,02 say '³   ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ Pecas Inteiras ...../..... ¿   ³'
   @ 10,02 say '³   ³                                                                  ³   ³'
   @ 11,02 say '³   ³       N£mero de Pecas Inteiras em Estoque -                      ³   ³'
   @ 12,02 say '³   ³                                                                  ³   ³'
   @ 13,02 say '³   ÆÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍµ   ³'
   @ 14,02 say '³   ³                                                                  ³   ³'
   @ 15,02 say '³   ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´   ³'
   @ 16,02 say '³   ³                                                                  ³   ³'
   @ 17,02 say '³   ³                                                                  ³   ³'
   @ 18,02 say '³   ³                                                                  ³   ³'
   @ 19,02 say '³   ³                                                                  ³   ³'
   @ 20,02 say '³   ³                                                                  ³   ³'
   @ 21,02 say '³   ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ   ³'
   @ 22,02 say 'ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ'
   if !f_separa
     @ 23,02 say '                                                                      Est19 '
     telanum('SCR19 ','EST19 ')
  end
return

/*
-----------------------------------------------------------------------------

			     Procedimento Tela

-----------------------------------------------------------------------------
*/
procedure TELA_19COR(flag)


   @ 09,02 say '³   ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ Pe‡as Cortadas ...../..... ¿   ³'
   @ 10,02 say '³   ³                                                                  ³   ³'
   @ 11,02 say '³   ³                                                                  ³   ³'
   @ 12,02 say '³   ³                                                                  ³   ³'
   @ 13,02 say '³   ÆÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍµ   ³'
   @ 14,02 say '³   ³                                                                  ³   ³'
   @ 15,02 say '³   ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´   ³'
   @ 16,02 say '³   ³                                                                  ³   ³'
   @ 17,02 say '³   ³                                                                  ³   ³'
   @ 18,02 say '³   ³                                                                  ³   ³'
   @ 19,02 say '³   ³                                                                  ³   ³'
   @ 20,02 say '³   ³                                                                  ³   ³'
   @ 21,02 say '³   ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ   ³'
   @ 22,02 say 'ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ'
   if !f_separa
     @ 23,02 say '                                                                      Est19 '
     telanum('SCR19 ','EST19 ')
  end
return


// ##########################################################################
//
//                             * CHAPA *
//
// ##########################################################################
/*
--------------------------------------------------------------------------



--------------------------------------------------------------------------
*/
procedure get_chapa()

   X_SUCATA   := 0.00000
   if !f_separa
     @ 11,20 get X_ALMOXARI picture "@K!"        valid TES_ALMOXA( X_ALMOXARI, 1 )
     @ 13,28 get X_TIPOMOVI picture "@K!"        valid TES_MOVIME( X_TIPOMOVI )
     @ 15,28 get X_DATAMOVI                      valid ! empty( X_DATAMOVI )
   end
   @ 17,30 get X_NUM_COR  picture "9999999"    valid X_NUM_COR >= 0
   @ 18,30 get X_N_INT_C  picture "99999"      valid TES_QTD( X_N_INT_C, 1 )
   @ 19,30 get X_N_COR_C  picture "99999"      valid TES_QTD( X_N_COR_C, 2 )
   if !f_separa
     @ 17,58 get X_QTD_KG   picture "9999999.99" valid TES_QTD_KG( X_QTD_KG )
   end
   @ 19,56 get X_QTD_SOB  picture "9999999"    valid if( X_NUM_COR=0,X_QTD_SOB=0,X_QTD_SOB>=0)
   @ 20,56 get X_SUCATA   picture "9999999.99" valid X_SUCATA >= 0
   @ 21,14 get X_ORIGEM   picture "@!"

return

/*
-----------------------------------------------------------------------------

			     Procedimento

-----------------------------------------------------------------------------
*/
procedure TCHAPA_COR()

   @ 09,02 say '³   ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ Pe‡as Excluidas ...../..... ¿   ³'
   @ 10,02 say '³   ³                                                                  ³   ³'
   @ 11,02 say '³   ³                                                                  ³   ³'
   @ 12,02 say '³   ³                                                                  ³   ³'
   @ 13,02 say '³   ³                                                                  ³   ³'
   @ 14,02 say '³   ³                                                                  ³   ³'
   @ 15,02 say '³   ³                                                                  ³   ³'
   @ 16,02 say '³   ³                                                                  ³   ³'
   @ 17,02 say '³   ³                                                                  ³   ³'
   @ 18,02 say '³   ³                                                                  ³   ³'
   @ 19,02 say '³   ³                                                                  ³   ³'
   @ 20,02 say '³   ³                                                                  ³   ³'
   @ 21,02 say '³   ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ   ³'
   @ 22,02 say 'ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ'
   if !f_separa
     @ 23,02 say '                                                                      Est19 '
     telanum('SCR19 ','EST19 ')
  end
return

/*
-----------------------------------------------------------------------------

		       Procedimento Tela de Chapa

-----------------------------------------------------------------------------
*/
procedure TELA_CHAPA()

 
  if f_separa
   @ 15,02 say 'ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ  Baixa de material  ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿'
  end
   @ 16,02 say '³                                                                          ³'
   @ 17,02 say '³  Tipos de P‡s cort. dif :           Qtd Kg Pesado :                      ³'
   @ 18,02 say '³  Qtd pe‡as usadas : Int :                                                ³'
   @ 19,02 say '³                     Cor :             Qtde Sobras :                      ³'
   @ 20,02 say '³                                 Sucata+Retalho Kg :                      ³'
   @ 21,02 say '³  Destino :                                                               ³'
   @ 22,02 say 'ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ'
   if !f_separa
     @ 23,02 say '                                                                      Est19 '
     telanum('SCR19 ','EST19 ')
  end

   
return

/*
-----------------------------------------------------------------------------

		      Funcao p_chapa

 -> Chapa

-----------------------------------------------------------------------------
*/
procedure p_chapa

   @ 10,20 say 'ÚÄÄÄÄÄÄÄÄÄÄÄÄÄ Movimenta‡„o ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿'
   @ 11,20 say '³                                              ³'
   @ 12,20 say '³                                              ³'
   @ 12,20 say '³                                              ³'
   @ 13,20 say '³                                              ³'
   @ 14,20 say 'ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ'
   sombra(10,20,14,67)


   X_SUBFORMA :=  pergresp( "Retangulo/ Disco/ Anel/ M-desenho ? (RDAM) ","RDAM")
   X_CSUB := ' '

   do case
      case X_SUBFORMA = 'R'
	 X_CSUB := 'Retangulo'
	 @ 12,20 say '³   Largura   (mm): '
	 @ 13,20 say '³   Comprim.  (mm): '

      case X_SUBFORMA = 'D'
	 X_CSUB := 'Disco    '

	 @ 12,20 say '³   Diametro  (mm): '
	 @ 13,20 say '³                   '

      case X_SUBFORMA = 'A'
	 X_CSUB := 'Anel     '

	 @ 12,20 say '³   Diam.Ext  (mm): '
	 @ 13,20 say '³   Diam.Int  (mm): '

      case X_SUBFORMA = 'M'
	 X_CSUB := 'Modelo   '
   endcase

   X_LARGMOV  := 0
   X_COMPMOV  := 0
   X_QTDPECAS := 0

   @ 10,20 say 'ÚÄÄÄÄÄÄÄÄÄÄÄÄÄ Movimenta‡„o ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿'
   @ 11,20 say '³   Qtd Pecas (mm): '
   @ 11,40 get X_QTDPECAS picture "99999"    valid X_QTDPECAS >= 0
   @ 12,40 get X_LARGMOV  picture "99999.99" valid X_LARGMOV >= 0
   @ 13,40 get X_COMPMOV  picture "99999.99" valid X_COMPMOV >= 0;
					  when X_SUBFORMA $ 'RA'
   read

   if lastkey()=K_ESC
      WRET := .f.
   else

      X_LARGSOB  := 0
      X_COMPSOB  := 0

      @ 10,20 say 'ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ Sobra ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿'
      @ 11,20 say '³                                             '
      @ 12,40 get X_LARGSOB  picture "99999.99" when X_SUBFORMA $ 'RAD'
      @ 13,40 get X_COMPSOB  picture "99999.99" when X_SUBFORMA $ 'RA'
      read

      if lastkey() == K_ESC
	 message("        Procedimento interrompido.           ",;
		 "Estoque pode ter sido alterado parcialmente. "  )
	 WRET := .f.
	 break
      end
   end

return

/*
--------------------------------------------------------------------------



--------------------------------------------------------------------------
*/
function Chapa_cortada()
   local P_CAMPOS    := {}
   local MASCARA     := {}
   local P_HEADER    := {}
   local TAMANHO     := {}
   local BESCAPE     := {|| W_CHAVE_ITEM = EST008->FORMA +;
			    EST008->TIPO            +;
			    str(EST008->BIT_MM,8,3) +;
			    str(EST008->ESP_MM,8,3) +;
			    EST008->ESTADO           }

   local COR         := W_COREDIT
   local TITULO      := NIL // "Pecas Cortadas"
   local LININI      := 10
   local COLINI      := 06
   local LINFIM      := 21
   local COLFIM      := 73
   local BLOCK_DISP  := {|| .T. }
   local CAB_TITULO  := nil
   local BORDA       := 1

   local TECLA       := nil
   local TABELA      := nil
   local IS_TBROWSE  := .F.

   private X_NCORT := 0, WRET    := .t.

   begin sequence
      EST008->( dbsetorder(2) )

      aadd( P_HEADER, "Sequˆncia"    )
      aadd( P_HEADER, "Largura" )
      aadd( P_HEADER, "Comprimento" )

      aadd( P_CAMPOS, "SEQUENC" )
      aadd( P_CAMPOS, "LARGURA" )
      aadd( P_CAMPOS, "COMPRIM" )

      aadd( MASCARA   , "99999"         )
      aadd( MASCARA   , "9999999999.99" )
      aadd( MASCARA   , "9999999999.99" )

      aadd( TAMANHO   , 15 )
      aadd( TAMANHO   , 20 )
      aadd( TAMANHO   , 20 )

      select EST008
      EST008->( dbsetorder(2) )
      EST008->( dbseek( W_CHAVE_ITEM ) )

      do while ++X_NCORT <= X_N_COR_C
	 mostra_19("CORTADA")

	 TABELA := tabelanew( P_CAMPOS       , ;
			      MASCARA        , ;
			      P_HEADER       , ;
			      TAMANHO        , ;
			      BESCAPE        , ;
			      COR            , ;
			      TITULO         , ;
			      LININI         , ;
			      LINFIM         , ;
			      COLINI         , ;
			      BLOCK_DISP     , ;
			      CAB_TITULO     , ;
			      BORDA          , ;
			      COLFIM           ;
			    )

	 CONTINUA := .T.
	 do while CONTINUA .and. ( (TEC:=tabmov(TABELA) ) != K_ESC )
	    if TEC == 13 ; exit ; end
	 enddo

	 if lastkey() == K_ESC
	    message("        Procedimento interrompido.           ",;
		    "Estoque pode ter sido alterado parcialmente. "  )
	    WRET := .f.
	    break
	 end

	 X_SOBRA := 0

	 while EST008->( ! rlock() ); end

	 // exclui peca
	 X_LARGURA := EST008->LARGURA
	 X_COMPRIM := EST008->COMPRIM

	 EST008->( dbdelete() )
	 mensbeep("Peca excluida com sucesso. <ENTER>")

	 EST008->( dbunlock() )
      enddo

   end sequence

return( WRET )


// ##########################################################################
//
//                             * BLOCO *
//
// ##########################################################################

/*
--------------------------------------------------------------------------



--------------------------------------------------------------------------
*/
function get_bloco()
WRET := .T.
   if !f_separa
     @ 11,20 get X_ALMOXARI picture "@K!"        valid TES_ALMOXA( X_ALMOXARI, 1 )
     @ 13,28 get X_TIPOMOVI picture "@K!"        valid TES_MOVIME( X_TIPOMOVI )
     @ 15,28 get X_DATAMOVI                      valid ! empty( X_DATAMOVI )
   end

 while .t.

   @ 18,30 get X_N_INT_C  picture "99999"         valid TES_QTD ( X_N_INT_C, 1 )
   @ 19,30 get X_N_COR_C  picture "99999"         valid TES_QTD ( X_N_COR_C, 2 )
   @ 20,30 get X_N_BLOQ   picture "99999"         valid TES_BLOQ()
   // @ 17,58 get X_QTD_KG   picture "9999999.99" valid TES_QTD_KG( X_QTD_KG )
   // @ 19,59 get X_QSOBCOR  picture "99999"      valid X_QSOBCOR <= X_N_INT_C + X_N_COR_C
   @ 19,59 get X_QSOBBLO  picture "99999"         valid X_QSOBBLO >= 0
   @ 21,14 get X_ORIGEM   picture "@!"
   read


   if lastkey()=27
      WRET := .f.
      exit
   end

//   if X_N_INT_C + X_N_COR_C + X_N_BLOQ = 0
//      mensbeep('Inteiras + Cortadas + Caixote = 0')
//   end

   EXIT

end


return WRET
/*
-----------------------------------------------------------------------------

		       Procedimento Tela de Bloco

-----------------------------------------------------------------------------
*/
procedure TELA_BLOCO()


   @ 16,02 say '³                                                                          ³'
   @ 17,02 say '³                                                                          ³'
   @ 18,02 say '³  Qtd pe‡as usadas : Int :                                                ³'
   @ 19,02 say '³                     Cor :         N§ sobras p/caixote:                   ³'
   @ 20,02 say '³                     Caix:                                                ³'
   @ 21,02 say '³  Destino :                                                               ³'
   @ 22,02 say 'ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ'
   if !f_separa
     telanum('SCR19 ','EST19 ')
     @ 23,02 say '                                                                            '
   end
return


/*
-----------------------------------------------------------------------------

			    BLOCO_CORTADO

-----------------------------------------------------------------------------
*/

function bloquinhos()
   local P_CAMPOS    := {}
   local MASCARA     := {}
   local P_HEADER    := {}
   local TAMANHO     := {}
   local BESCAPE     := {|| W_CHAVE_ITEM = EST040->FORMA +;
			    EST040->TIPO }

   local COR         := W_COREDIT
   local TITULO      := "Caixote (Bloquinhos)"
   local LININI      := 10
   local COLINI      := 06
   local LINFIM      := 21
   local COLFIM      := 73
   local BLOCK_DISP  := {|| .T. }
   local CAB_TITULO  := nil
   local BORDA       := 1

   local TECLA       := nil
   local TABELA      := nil
   local IS_TBROWSE  := .F.

   private X_NCORT := 0, WRET    := .t.

   begin sequence
      EST040->( dbsetorder(1) )

      aadd( P_HEADER, "Sequˆncia"    )
      aadd( P_HEADER, "Largura" )
      aadd( P_HEADER, "Comprimento" )

      aadd( P_CAMPOS, "ESPESSU" )
      aadd( P_CAMPOS, "LARGURA" )
      aadd( P_CAMPOS, "COMPRIM" )

      aadd( MASCARA   , "9999999999.999" )
      aadd( MASCARA   , "9999999999.999" )
      aadd( MASCARA   , "9999999999.999" )

      aadd( TAMANHO   , 20 )
      aadd( TAMANHO   , 20 )
      aadd( TAMANHO   , 20 )

      select EST040
      EST040->( dbsetorder(1) )
      EST040->( dbseek( X_FORMA+X_TIPO ) )

      X_NCORT := 0
      do while ++X_NCORT <= X_N_BLOQ

	 @ 09, 61 say X_NCORT   picture '9999'
	 @ 09, 67 say X_N_BLOQ  picture '9999'

	 TABELA := tabelanew( P_CAMPOS       , ;
			      MASCARA        , ;
			      P_HEADER       , ;
			      TAMANHO        , ;
			      BESCAPE        , ;
			      COR            , ;
			      TITULO         , ;
			      LININI         , ;
			      LINFIM         , ;
			      COLINI         , ;
			      BLOCK_DISP     , ;
			      CAB_TITULO     , ;
			      BORDA          , ;
			      COLFIM           ;
			    )

	 CONTINUA := .T.
	 do while CONTINUA .and. ( (TEC:=tabmov(TABELA) ) != K_ESC )
	    if TEC == 13 ; exit ; end
	 enddo

	 if lastkey() == K_ESC
	    message("        Procedimento interrompido.           ",;
		    "Estoque pode ter sido alterado parcialmente. "  )
	    WRET := .f.
	    break
	 end


	 X_SOBRA := 0

	 while EST040->( ! rlock() ); end

	 // exclui peca
	 EST040->( dbdelete() )
	 mensbeep("Peca excluida com sucesso. <ENTER>")

	 EST040->( dbunlock() )
      enddo

   end sequence

return .T.

/*
--------------------------------------------------------------------------



--------------------------------------------------------------------------
*/
function Bloco_cortado()
   local P_CAMPOS    := {}
   local MASCARA     := {}
   local P_HEADER    := {}
   local TAMANHO     := {}
   local BESCAPE     := {|| W_CHAVE_ITEM = EST008->FORMA +;
			    EST008->TIPO            +;
			    str(EST008->BIT_MM,8,3) +;
			    str(EST008->ESP_MM,8,3) +;
			    EST008->ESTADO           }

   local COR         := W_COREDIT
   local TITULO      := "Blocos Cortados"
   local LININI      := 10
   local COLINI      := 06
   local LINFIM      := 21
   local COLFIM      := 73
   local BLOCK_DISP  := {|| .T. }
   local CAB_TITULO  := nil
   local BORDA       := 1

   local TECLA       := nil
   local TABELA      := nil
   local IS_TBROWSE  := .F.

   private X_NCORT := 0, WRET    := .t.

   begin sequence
      EST008->( dbsetorder(2) )

      aadd( P_HEADER, "Sequˆncia"    )
      aadd( P_HEADER, "Largura" )
      aadd( P_HEADER, "Comprimento" )

      aadd( P_CAMPOS, "SEQUENC" )
      aadd( P_CAMPOS, "LARGURA" )
      aadd( P_CAMPOS, "COMPRIM" )

      aadd( MASCARA   , "99999"         )
      aadd( MASCARA   , "9999999999.99" )
      aadd( MASCARA   , "9999999999.99" )

      aadd( TAMANHO   , 15 )
      aadd( TAMANHO   , 20 )
      aadd( TAMANHO   , 20 )

      select EST008
      EST008->( dbsetorder(2) )
      EST008->( dbseek( W_CHAVE_ITEM ) )

      do while ++X_NCORT <= X_N_COR_C
	 @ 09, 61 say X_NCORT    picture '9999'
	 @ 09, 67 say X_N_COR_C  picture '9999'

	 TABELA := tabelanew( P_CAMPOS       , ;
			      MASCARA        , ;
			      P_HEADER       , ;
			      TAMANHO        , ;
			      BESCAPE        , ;
			      COR            , ;
			      TITULO         , ;
			      LININI         , ;
			      LINFIM         , ;
			      COLINI         , ;
			      BLOCK_DISP     , ;
			      CAB_TITULO     , ;
			      BORDA          , ;
			      COLFIM           ;
			    )

	 CONTINUA := .T.
	 do while CONTINUA .and. ( (TEC:=tabmov(TABELA) ) != K_ESC )
	    if TEC == 13 ; exit ; end
	 enddo

	 //
	 // Alterar pecas cortadas
	 //
	 WSCRBLQ := savescreen(10,20,20,57)
	 @ 10,20 say 'ÚÄÄÄÄÄÄÄ´ Sobra Pe‡as  ÃÄÄÄÄÄÄÄ¿'
	 @ 11,20 say '³                              ³'
	 @ 12,20 say '³ Pe‡a n§ ....:       /        ³'
	 @ 13,20 say '³                              ³'
	 @ 14,20 say '³ Entrada no                   ³'
	 @ 15,20 say '³ Bloco mm ...:                ³'
	 @ 16,20 say '³                              ³'
	 @ 17,20 say '³ Sobra ......:                ³'
	 @ 18,20 say '³                              ³'
	 @ 19,20 say '³                              ³'
	 @ 20,20 say 'ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ'
	 @ 12,36 say strzero(X_NCORT  , 6)
	 @ 12,43 say strzero(X_N_COR_C, 6)

	 X_COMPRIM := 0
	 X_ENTCOMP := 0

	 @ 15,36 get X_ENTCOMP picture "99999.99" valid X_ENTCOMP > 0 //.and. X_ENTCOMP <= X_COMPRIM
	 @ 17,36 get X_COMPRIM picture "99999.99" valid X_COMPRIM >= 0
	 read

	 restscreen(10,20,20,57,WSCRBLQ)
	 if lastkey()=27
	    F_SAIDANORMAL := .F.
	    exit
	 end

	 if X_ENTCOMP + X_COMPRIM > EST008->COMPRIM
	    mensbeep('Tam Peca : '+str(EST008->COMPRIM)+' Digitado :'+str(X_ENTCOMP+X_COMPRIM))
	    --X_NCORT
	    loop
	 end

	 X_QTD_KG := X_QTD_KG + X_ENTCOMP
	 //
	 // incluir como peca cortada
	 //

	 while EST008->( ! rlock() ); end

	 if X_COMPRIM > 0

	    EST008->SEQUENC := sequencia( W_CHAVE_ITEM )
	    EST008->COMPRIM := X_COMPRIM
	    mensbeep('Peca alterada com sucesso.')
	 else

	    EST008->( dbdelete() )
	    mensbeep("Pe‡a excluida com sucesso. <ENTER>")
	 end

	 EST008->( dbunlock() )
      enddo

   end sequence

return( WRET )


/*
--------------------------------------------------------------------------
		  TES_BLOQ
--------------------------------------------------------------------------
*/
function tes_bloq ()
   local WRET := .t.

    if X_N_BLOQ > EST040_QTD(X_FORMA,X_TIPO)
      mensbeep(" Qtd Caixote insuficiente em Cadastro ! <ENTER> ")
      WRET := .F.
    end

return( WRET )
