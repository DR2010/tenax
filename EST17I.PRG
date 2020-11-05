/*

   SCM - Sistema de Controle Metalurgico
   EST17i.PRG - Cadastro do Item de Estoque

*/
local DIVISOR, CAMPOS
#include "inkey.ch"

abrir("EST007")
setcolor(W_COREDIT)

status('Cadastro de Item de Estoque')

// Inicializa variaveis

Private X_FORMA   := space(03) ,;
        X_TIPO    := space(05) ,;
        X_ESTADO  := space(01) ,;
        X_BIT_MM  := 0.00      ,; //  8.3
        X_ESP_MM  := 0.00      ,; //  8.3
        X_QTD_KG := 0.00       ,; // 12.2
        X_QTD_PED := 0.00      ,; // 12.2
        X_QTD_INT := 0         ,; //  5.0
        X_QTD_COR := 0         ,; //  5.0
        X_PES_PEC := 0.00      ,; // 10.1
        X_PER_COR := 0.00      ,; //  6.1
        X_CUS_ULT := 0.00      ,; // 12.2
        X_CUS_MED := 0.00      ,; // 12.2
        X_OBS_MAT := space(40) ,;
        X_DAT_ULT := ctod(" ") ,;
        X_BIT_INT := space(02) ,;
        X_BIT_FN  := space(02) ,;
        X_BIT_FD  := space(02) ,;
        X_ESP_INT := space(02) ,;
        X_ESP_FN  := space(02) ,;
        X_ESP_FD  := space(02) ,;
        T_BIT     := .F.       ,;
        T_LARG    := .F.

// --> Inicio

While .T.

   status('Cadastro de Item de Estoque')
   tela_17()
   zera_17()

   get_mainkey()
   read

   if lastkey()=K_ESC
      exit
   end

   W_CHAVE_ITEM := ( X_FORMA+ X_TIPO+ ;
                str( X_BIT_MM, 8, 3 ) + str( X_ESP_MM, 8, 3 ) + X_ESTADO )

   if ver_material( W_CHAVE_ITEM )

      show_17()
      W_RESP := esp_alt()
      status('Cadastro de Item de Estoque')
      do case
      case W_RESP = "*"
	 exit
      case W_RESP = "A"
	 atribui_17()
	 while .t.
	    get_17()
	    if lastkey() = K_ESC
	       if conf('Abandona Alteracoes')
		  exit
	       end
	    end
	    if conf('Confirma Dados')
	       grava_17('A')
	       exit
	    end
	 end
      case W_RESP = "E"
	 if conf( 'Confirma Exclusao')
            if movimentacao( W_CHAVE_ITEM )
               mensbeep("H  movimenta‡„o para este ¡tem. Imposs¡vel excluir.")
            else
               while EST007->( ! rlock() ); end
               EST007->( dbdelete() )
               EST007->( dbunlock() )
               mensbeep("Excluido. <ENTER>")
            end
	 end
      end
   else
      while .t.
	 get_17()
	 if lastkey() = K_ESC
            if conf('Abandona Altera‡”es')
	       exit
	    end
	 end
	 if conf('Confirma Dados')
	    grava_17('I')
	    exit
	 end
      end
   end
End

dbcloseall()

// --> Fim


/*
-----------------------------------------------------------------------------
			     Procedimento Tela
-----------------------------------------------------------------------------
*/
procedure TELA_17()

   @ 02,02 say 'ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿'
   @ 03,02 say '³                                                                   Est17i ³'
   @ 04,02 say '³                                                                          ³'
   @ 05,02 say '³  Forma    :       -                                                      ³'
   @ 06,02 say '³  Tipo     :       -                                                      ³'
   @ 07,02 say '³  Estado   :       -                                                      ³'
   @ 08,02 say '³  Bit./Esp.:      /                                                       ³'
   @ 09,02 say '³  Bit./Larg:      /                                                       ³'
   @ 10,02 say '³                                                                          ³'
   @ 11,02 say '³  Qtd. em Estoque     :                Qtd. Comprada     :                ³'
   @ 12,02 say '³                                                                          ³'
   @ 13,02 say '³  Qtd. Pe‡a Inteira   :                Qtd. Pe‡a Cortada :                ³'
   @ 14,02 say '³                                                                          ³'
   @ 15,02 say '³  Peso por Pe‡a       :                Perda por Corte   :                ³'
   @ 16,02 say '³                                                                          ³'
   @ 17,02 say '³  Data Ultima Compra  :                Custo Medio       :                ³'
   @ 18,02 say '³                                                                          ³'
   @ 19,02 say '³  Custo Ultima Compra :                                                   ³'
   @ 20,02 say '³                                                                          ³'
   @ 21,02 say '³                                                                          ³'
   @ 22,02 say '³  Obs :                                                                   ³'
   @ 23,02 say 'ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ'

return

/*
-----------------------------------------------------------------------------
		      Funcao GET_17
-----------------------------------------------------------------------------
*/
function get_17()
   local WRET := .T.

   @ 11,27 get X_QTD_KG picture "999999999.99"
   @ 11,63 get X_QTD_PED picture "999999999.99"
   @ 13,27 get X_QTD_INT picture "99999"
   @ 13,63 get X_QTD_COR picture "99999"
   @ 15,27 get X_PES_PEC picture "99999999.9"
   @ 15,63 get X_PER_COR picture "9999.99"
   @ 17,27 get X_DAT_ULT
   @ 17,63 get X_CUS_MED picture "999,999,999.99"
   @ 19,27 get X_CUS_ULT picture "999,999,999.99"
   @ 22,11 get X_OBS_MAT picture "@!"
   read


return WRET


/*
-----------------------------------------------------------------------------
		      Funcao SHOW_17
-----------------------------------------------------------------------------
*/
procedure SHOW_17()

   @ 11,27 say EST007->QTD_KG picture "999999999.99"
   @ 11,63 say EST007->QTD_PED picture "999999999.99"
   @ 13,27 say EST007->QTD_INT picture "99999"
   @ 13,63 say EST007->QTD_COR picture "99999"
   @ 15,27 say EST007->PES_PEC picture "99999999.9"
   @ 15,63 say EST007->PER_COR picture "9999.99"
   @ 17,27 say EST007->DAT_ULT
   @ 17,63 say EST007->CUS_MED picture "999,999,999.99"
   @ 19,27 say EST007->CUS_ULT picture "999,999,999.99"
   @ 22,11 say EST007->OBS_MAT picture "@!"

return


/*
-----------------------------------------------------------------------------
		      Funcao ZERA_17
-----------------------------------------------------------------------------
*/
procedure zera_17()

   X_FORMA := space(03)
   X_TIPO := space(05)
   X_ESTADO := space(01)
   X_BIT_MM  := 0.00
   X_ESP_MM  := 0.00
   X_QTD_KG := 0.00
   X_QTD_PED := 0.00
   X_QTD_INT := 0
   X_QTD_COR := 0
   X_PES_PEC := 0.00
   X_PER_COR := 0.00
   X_CUS_ULT := 0.00
   X_CUS_MED := 0.00
   X_OBS_MAT := space(40)
   X_DAT_ULT := ctod(" ")
   X_BIT_INT := space(02)
   X_BIT_FN  := space(02)
   X_BIT_FD  := space(02)
   X_ESP_INT := space(02)
   X_ESP_FN  := space(02)
   X_ESP_FD  := space(02)

return

/*
-----------------------------------------------------------------------------
		      Funcao ATRIBUI_17
-----------------------------------------------------------------------------
*/
procedure atribui_17()

   X_FORMA   :=  EST007->FORMA
   X_TIPO    :=  EST007->TIPO
   X_ESTADO  :=  EST007->ESTADO
   X_BIT_MM  :=  EST007->BIT_MM
   X_ESP_MM  :=  EST007->ESP_MM
   X_QTD_KG  :=  EST007->QTD_KG
   X_QTD_PED :=  EST007->QTD_PED
   X_QTD_INT :=  EST007->QTD_INT
   X_QTD_COR :=  EST007->QTD_COR
   X_PES_PEC :=  EST007->PES_PEC
   X_PER_COR :=  EST007->PER_COR
   X_CUS_ULT :=  EST007->CUS_ULT
   X_CUS_MED :=  EST007->CUS_MED
   X_OBS_MAT :=  EST007->OBS_MAT
   X_DAT_ULT :=  EST007->DAT_ULT
   X_BIT_INT :=  EST007->BIT_INT
   X_BIT_FN  :=  EST007->BIT_FN
   X_BIT_FD  :=  EST007->BIT_FD
   X_ESP_INT :=  EST007->ESP_INT
   X_ESP_FN  :=  EST007->ESP_FN
   X_ESP_FD  :=  EST007->ESP_FD

return

/*
-----------------------------------------------------------------------------
		      Funcao GRAVA_17()
-----------------------------------------------------------------------------
*/
procedure GRAVA_17( MODO )

   if MODO = "I"
      EST007->( dbappend() )
   else
      while EST007->( ! rlock() ); end
   end

   EST007->FORMA   := X_FORMA
   EST007->TIPO    := X_TIPO
   EST007->ESTADO  := X_ESTADO
   EST007->BIT_MM  := X_BIT_MM
   EST007->ESP_MM  := X_ESP_MM
   EST007->QTD_KG := X_QTD_KG
   EST007->QTD_PED := X_QTD_PED
   EST007->QTD_INT := X_QTD_INT
   EST007->QTD_COR := X_QTD_COR
   EST007->PES_PEC := X_PES_PEC
   EST007->PER_COR := X_PER_COR
   EST007->CUS_ULT := X_CUS_ULT
   EST007->CUS_MED := X_CUS_MED
   EST007->OBS_MAT := X_OBS_MAT
   EST007->DAT_ULT := X_DAT_ULT
   EST007->BIT_INT := X_BIT_INT
   EST007->BIT_FN  := X_BIT_FN
   EST007->BIT_FD  := X_BIT_FD
   EST007->ESP_INT := X_ESP_INT
   EST007->ESP_FN  := X_ESP_FN
   EST007->ESP_FD  := X_ESP_FD

   EST007->( dbunlock() )

return

