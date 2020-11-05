/*

   SCM - Sistema de Controle Metalurgico
   EST22.PRG - Detalhar Peca Curta

*/

#include "inkey.ch"
setcolor(W_COREDIT)
telanum('SCR22 ','EST22 ')

abrir("EST003")
abrir("EST004")
abrir("EST007")
abrir("EST008")
abrir("EST009")
abrir("EST040")

EST008->( dbgotop() )

X_FORMA       := space(03)
X_TIPO	      := space(05)
X_ESTADO      := space(01)
X_BIT_MM      := 0.00
X_ESP_MM      := 0.00
X_BIT_INT     := space(02)
X_BIT_FN      := space(02)
X_BIT_FD      := space(02)
X_ESP_INT     := space(02)
X_ESP_FN      := space(02)
X_ESP_FD      := space(02)

X_SEQUENC     := 0
X_COMPRIM     := 0.00
X_LARGURA     := 0.00
X_ESPESSU     := 0.00
X_QTD_KG      := 0.00
X_LOTE	      := space(05)
X_FORNECEDOR  := space(03)
X_PES_PECA    := space(03)

// --> Inicio

While .T.

   status('Detalhar Peca Curta')

   tela_22()
   zera_22()
   get_mainkey()
   read

   if lastkey()=K_ESC
      exit
   end

   W_CHAVE_ITEM := ( X_FORMA+ X_TIPO+;
		str( X_BIT_MM, 8, 3 ) + str( X_ESP_MM, 8, 3 ) + X_ESTADO )

   if ! ver_material( W_CHAVE_ITEM )
      mensbeep('Material nao Cadastrado')
      loop
   end

   if EST007->QTD_INT <= 0
      mensbeep("N„o existem mais pe‡as inteiras")
      loop
   end

   while .T.

      if EST007->QTD_INT <= 0
         mensbeep("N„o existem mais pe‡as inteiras")
         exit
      end

      get_22( X_FORMA )

      if lastkey() = K_ESC
         exit
      else
         if conf('Confirma Dados')
	    grava_22('I')
	 end
      end
   Enddo

Enddo
dbcloseall()
return
// --> Fim

/*
-----------------------------------------------------------------------------
			     Procedimento Tela
-----------------------------------------------------------------------------
*/
procedure TELA_22()

   @ 02,02 say 'ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿'
   @ 03,02 say '³                                                                          ³'
   @ 04,02 say '³                                                                          ³'
   @ 05,02 say '³  Forma    :       -                                                      ³'
   @ 06,02 say '³  Tipo     :       -                                                      ³'
   @ 07,02 say '³  Estado   :       -                                                      ³'
   @ 08,02 say '³  Bit./Esp.:      /                                                       ³'
   @ 09,02 say '³  Bit./Larg:      /                                                       ³'
   @ 10,02 say '³                                                                          ³'
   @ 11,02 say '³                                          Especifica‡„o                   ³'
   @ 12,02 say '³                                                                          ³'
   @ 13,02 say '³  Largura ....:                     Tamanho Pe‡a Inteira :         (min.) ³'
   @ 14,02 say '³                                                                          ³'
   @ 15,02 say '³  Comprimento :                     Qtde pe‡as inteiras  :                ³'
   @ 16,02 say '³                                                                          ³'
   @ 17,02 say '³                                                                          ³'
   @ 18,02 say '³                                                                          ³'
   @ 19,02 say '³                                                                          ³'
   @ 20,02 say '³                                                                          ³'
   @ 21,02 say '³                                                                          ³'
   @ 22,02 say 'ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ'

return

/*
-----------------------------------------------------------------------------
		      Funcao GET_22
-----------------------------------------------------------------------------
*/
function get_22( P_FORMA )
   local WRET := .T.

   X_COMPRIM := 0
   X_LARGURA := 0
   @ 13,61 say EST007->TAM_INT
   @ 15,61 say EST007->QTD_INT

   EST003->( dbsetorder(1))
   EST003->( dbseek( P_FORMA ))

   @ 13,19 get X_LARGURA       picture "99999.99" valid X_LARGURA > 0 ;
                                                   when EST003->P_CORTE = 5
   @ 15,19 get X_COMPRIM       picture "99999.99" valid X_COMPRIM > 0
   read

   // nao se pode digitar os dois campos,  um dos dois e calculado.

   if X_QTD_KG > 0 .and. X_COMPRIM > 0
      WRET := .F.
   end

return WRET

/*
-----------------------------------------------------------------------------
		      Funcao ZERA_22
-----------------------------------------------------------------------------
*/
procedure zera_22()

   X_FORMA	 := space(03)
   X_TIPO	 := space(05)
   X_ESTADO	 := space(01)
   X_BIT_MM	 := 0.00
   X_ESP_MM	 := 0.00
   X_BIT_INT	 := space(02)
   X_BIT_FN	 := space(02)
   X_BIT_FD	 := space(02)
   X_ESP_INT	 := space(02)
   X_ESP_FN	 := space(02)
   X_ESP_FD	 := space(02)

   X_SEQUENC	 := 0
   X_COMPRIM	 := 0.00
   X_QTD_KG	 := 0.00
   X_LOTE	 := space(05)
   X_FORNECEDOR  := space(03)
   X_PES_PECA	 := space(03)

return

/*
-----------------------------------------------------------------------------
		      Funcao ATRIBUI_22
-----------------------------------------------------------------------------
*/
procedure atribui_22()

   X_FORMA	 := EST008->FORMA
   X_TIPO	 := EST008->TIPO
   X_ESTADO	 := EST008->ESTADO
   X_BIT_MM	 := EST008->BIT_MM
   X_ESP_MM	 := EST008->ESP_MM
   X_BIT_INT	 := EST008->BIT_INT
   X_BIT_FN	 := EST008->BIT_FN
   X_BIT_FD	 := EST008->BIT_FD
   X_ESP_INT	 := EST008->ESP_INT
   X_ESP_FN	 := EST008->ESP_FN
   X_ESP_FD	 := EST008->ESP_FD
   X_SEQUENC	 := EST008->SEQUENC
   X_COMPRIM	 := EST008->COMPRIM
   X_LARGURA     := EST008->LARGURA
   X_QTD_KG	 := EST008->QTD_KG
   X_LOTE	 := EST008->LOTE

   // depois, buscar no cadastro de lote
   // X_FORNECEDOR  := EST008->FORNECEDOR
return

/*
-----------------------------------------------------------------------------
		      Funcao GRAVA_22()
-----------------------------------------------------------------------------
*/
procedure GRAVA_22( MODO )

   while EST007->( ! rlock() ); end

   X_SEQUENC := sequencia( W_CHAVE_ITEM )

   // atualizar item de estoque
   EST007->( dbsetorder(1))
   EST007->( dbseek( W_CHAVE_ITEM ))

   // quantidade de KG pecas cortadas
   EST007->QTD_KGC := EST007->QTD_KGC + X_QTD_KG

   // quantidade total em KG
   // EST007->QTD_KGT += EST007->PES_MTR * X_COMPRIM

   // numero de pecas cortadas
   EST007->QTD_COR := EST007->QTD_COR + 1

   // quantidade de KG pecas inteiras
   EST007->QTD_KGI -= EST007->PES_INT

   // numero de pecas inteiras
   EST007->QTD_INT := EST007->QTD_INT - 1

   if MODO = "I"
      EST008->( dbappend() )
   else
      while EST008->( ! rlock() ); end
   end

   EST008->FORMA      := X_FORMA
   EST008->TIPO       := X_TIPO
   EST008->ESTADO     := X_ESTADO
   EST008->BIT_MM     := X_BIT_MM
   EST008->ESP_MM     := X_ESP_MM
   EST008->BIT_INT    := X_BIT_INT
   EST008->BIT_FN     := X_BIT_FN
   EST008->BIT_FD     := X_BIT_FD
   EST008->ESP_INT    := X_ESP_INT
   EST008->ESP_FN     := X_ESP_FN
   EST008->ESP_FD     := X_ESP_FD
   EST008->SEQUENC    := X_SEQUENC
   EST008->COMPRIM    := X_COMPRIM
   EST008->LARGURA    := X_LARGURA
   EST008->QTD_KG     := X_COMPRIM * EST007->PES_MTR
   EST008->LOTE       := X_LOTE

   EST007->( dbunlock() )
   EST008->( dbunlock() )

   dbcommitall()

return

/*
-----------------------------------------------------------------------------
		      Funcao ESP_ALT
-----------------------------------------------------------------------------
*/
static function esp_alt()

   local TEC

   status ( 'Escolha Op‡ao Desejada Altera‡„o / Exclus„o ' )
   @ 24,41 prompt "Alteracao"
   @ 24,53 prompt "Exclusao"
   menu to TEC

   do case
   case TEC = 1
      WRET := "A"
   case TEC = 2
      WRET := "E"
   case TEC = 0  // ESC
      WRET := "*"
   endcase

return ( WRET )

/*
-----------------------------------------------------------------------------
		      Funcao TES_LOTE
-----------------------------------------------------------------------------
*/
function tes_lote( VAR )
   local WRET := .T.

   X_LOTE := zerofill(X_LOTE)

   EST009->( dbsetorder(1) )
   EST009->( dbseek( X_LOTE ) )

   if EST009->( ! found() )
      m_tabelas()
      if lastkey() = K_ESC
	 WRET := .F.
      end
   end

   X_LOTE     := EST009->LOTE
   X_QTD_PECA := EST009->QTD_PECA

   @ 12,19 say X_LOTE	   picture '@!'
   @ 12,45 say X_QTD_PECA  picture '99999999'

return WRET

/*
-----------------------------------------------------------------------------
		      Funcao TES_COMPRIM
-----------------------------------------------------------------------------
*/
function tes_comprim( VAR )
   local WRET := .T.

   if var = 0
      mensbeep('Comprimento Inv lido')
      WRET := .F.
   end

return WRET


/*
-----------------------------------------------------------------------------
		      Funcao SEQUENCIA
-----------------------------------------------------------------------------
*/
function sequencia( VAR )

   local W_SEQ	 := 0,;
	 OLD_REC := recno()

   EST008->( dbsetorder (2) )
   EST008->( dbseek( VAR) )

   while EST008->( !EOF() ) .and. ;
	 VAR == EST008->FORMA + EST008->TIPO  + ;
	 str(EST008->BIT_MM,8,3) + str(EST008->ESP_MM,8,3)+ EST008->ESTADO

      W_SEQ := EST008->SEQUENC
      EST008->( dbskip() )
   enddo

   EST008->( dbsetorder (1) )
   W_SEQ++

   goto( OLD_REC )
return W_SEQ


* ----------> Fim do meu programa

return

function VER_TAM( P_VAL )
   local WRET := .T.

   if X_QTD_KG >= EST007->PES_INT
      mensbeep('Peso maior ou igual a Pe‡a Inteira')
      WRET := .F.
   end
return WRET
