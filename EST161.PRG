/*

   SCM - Sistema de Controle Metalurgico
   EST161.PRG - Item de Pedido de Compra

*/
#include "inkey.ch"
ALTD(1)
setcancel(.T.)


/*
-------------------------------------------------------------------------------
			      ITEM_EDIT16
-------------------------------------------------------------------------------
*/
function ITEM_EDIT16( P_MODO )
local WRET := .T.

private  W_FILE      := {}
private  CAMPO       := {}
private  MASCARA     := {}
private  CABECALHO   := {}
private  TAMANHO     := {}
private  BESCAPE     := {|| EST006->PEDIDO = X_PEDIDO }
private  COR         := W_COREDIT
private  TITULO      := " Compras "
private  LININI      := 08
private  LINFIM      := 20
private  COLINI      := 02
private  COLFIM      := 77
private  BLOCK_DISP  := {|| .T. }
private  CAB_TITULO  := nil
private  BORDA       := 1

private  TECLA       := nil
private  TABELA      := nil

aadd( CAMPO     , "FORMA" )
aadd( CAMPO     , "TIPO" )
aadd( CAMPO     , "BIT_MM" )
aadd( CAMPO     , "ESP_MM" )
aadd( CAMPO     , "QTD_KG" )
aadd( CAMPO     , "VAL_KG" )
aadd( CAMPO     , "CUSTO_KG" )
aadd( CAMPO     , "CUS_ITOT" )
aadd( CAMPO     , "R_DTPED" )

aadd( MASCARA   , "XXX"       )
aadd( MASCARA   , "XXXXX"     )
aadd( MASCARA   , "99999.99" )
aadd( MASCARA   , "99999.99" )
aadd( MASCARA   , "999999.99" )
aadd( MASCARA   , "99999.999"  )
aadd( MASCARA   , "99999.99"  )
aadd( MASCARA   , "9999999.99")
aadd( MASCARA   , "99/99" )

aadd( CABECALHO , "For"        )
aadd( CABECALHO , "Tipo"       )
aadd( CABECALHO , "Bit/Esp"    )
aadd( CABECALHO , "Bit/Larg"   )
aadd( CABECALHO , " Qtd Kg"    )
aadd( CABECALHO , "Pre‡o Kg"   )
aadd( CABECALHO , "Custo Kg"   )
aadd( CABECALHO , "Custo Item" )
aadd( CABECALHO , "Sit."       )

aadd( TAMANHO   ,  3 )
aadd( TAMANHO   ,  6 )
aadd( TAMANHO   ,  8 )
aadd( TAMANHO   ,  8 )
aadd( TAMANHO   ,  9 )
aadd( TAMANHO   ,  9 )
aadd( TAMANHO   ,  8 )
aadd( TAMANHO   , 10 )
aadd( TAMANHO   ,  5 )

aadd( W_FILE , "EST006" )
aadd( W_FILE , "EST006" )
aadd( W_FILE , "EST006" )
aadd( W_FILE , "EST006" )
aadd( W_FILE , "EST006" )
aadd( W_FILE , "EST006" )
aadd( W_FILE , "EST006" )
aadd( W_FILE , "EST006" )
aadd( W_FILE , "EST006" )

// variaveis DBEDIT

// item_brow16()

EST006->( dbsetorder(1) )
EST006->( dbseek(X_PEDIDO) )

show_total( calc_total( X_PEDIDO, 1 ), 1 )

// EST006->( dbedit(08,03,19,76,P_CAMPOS,"ITEM_FUNC16",, P_HEADER, P_HDSEP, P_COLSEP))

select EST006

TABELA := tabelanew( CAMPO          , ;
                     MASCARA        , ;
                     CABECALHO      , ;
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
                     COLFIM         , ;
                     W_FILE         , ;
                   )

CONTINUA := .T.

W_TEL161 := savescreen(,,,,)

do while CONTINUA .and. ( (TEC:=tabmov(TABELA)) != K_ESC )


   setcursor(1)

   setcolor( W_CORGET )
   do case
      case lastkey() = K_F3

         if P_MODO = 'ALTERA'
            item_inclui16()
            show_total( calc_total( X_PEDIDO, 2 ), 3 )
         end

         restscreen(,,,,W_TEL161)
         tabela:refreshall()

      case lastkey() = K_F4
         if P_MODO = 'ALTERA'
            if empty( EST006->R_DTPED )
               item_altera16()
               show_total( calc_total( X_PEDIDO, 2 ), 3 )
            end
         end

         restscreen(,,,,W_TEL161)
         tabela:refreshall()

      case lastkey() = K_F5
         if P_MODO = 'ALTERA'
            if empty( EST006->R_DTPED )
               item_exclui16()
               show_total( calc_total( X_PEDIDO, 2 ), 3 )
            end
            restscreen(,,,,W_TEL161)
            tabela:refreshall()
         end

      case lastkey() = K_ENTER
	 if ! empty( EST006->PEDIDO )

	    W1_ITEMSCR := savescreen(21,00,24,79)
	    item_consulta16()
	    @ 24, 00 say padc(" Tecle para continuar ",80)
	    inkey(0)
	    restscreen(21,00,24,79,W1_ITEMSCR)
            restscreen(,,,,W_TEL161)
            tabela:refreshall()
         end

   endcase

   setcolor( W_COREDIT )
   select EST006
enddo
if lastkey()=K_ESC
   WRET := .F.
end



restscreen(,,,,W_TEL16)

return WRET

/*
-------------------------------------------------------------------------------
			   ITEM_INCLUI16
-------------------------------------------------------------------------------
*/
Function item_inclui16()
local W_OLDSCR := savescreen()

item_zera16()
item_tela16()
get_mainkey(2)
read
W_CHAVE_ITEM := ( X_FORMA+ X_TIPO+ ;
	     str( X_BIT_MM, 8, 3 ) + str( X_ESP_MM, 8, 3 ) + X_ESTADO )

EST007->( dbsetorder(1) )
EST007->( dbseek( W_CHAVE_ITEM ))

if lastkey()#K_ESC
   if EST007->( ! found() )
      mensbeep("Material n„o cadastrado. <ENTER>")
   else
      if item_get16("INCLUSAO")
         item_grava16("I")
      end
   end
end
return

/*
-------------------------------------------------------------------------------
			   ITEM_ALTERA16
-------------------------------------------------------------------------------
*/
function item_altera16()

local W_OLDSCR := savescreen()

item_atrib16()
item_tela16()
get_mainkey(2)
clear gets

tes_formato(09,16,20)
tes_tipo(2)
tes_estado(2)

W_CHAVE_ITEM := ( X_FORMA+ X_TIPO+ ;
	     str( X_BIT_MM, 8, 3 ) + str( X_ESP_MM, 8, 3 ) + X_ESTADO )

if item_get16("ALTERACAO")
   item_grava16("A")
end

return

/*
-------------------------------------------------------------------------------
			   ITEM_CONSULTA16
-------------------------------------------------------------------------------
*/
Function item_consulta16()
local W_OLDSCR := savescreen()

item_atrib16()
item_tela16()
item_show16()

return

/*
-------------------------------------------------------------------------------
			   ITEM_EXCLUI16
-------------------------------------------------------------------------------
*/
Function item_exclui16()

local W_OLDSCR := savescreen()

item_tela16()
item_atrib16()
item_show16()

if conf(' Confirma Exclus„o ')

   // atualiza quantidade de itens
   while EST005->( ! rlock() ); end
   EST005->QTD_ITENS := EST005->QTD_ITENS-1
   EST005->QTDITPEND := EST005->QTDITPEND-1
   EST005->( dbunlock() )

   // --------------------------------------------------------
   // atualiza quantidade comprada somente quando o item nao
   // tiver sido recebido
   // --------------------------------------------------------
   if empty( EST006->R_DTPED )
      W_CHAVE_ITEM := ( EST006->FORMA+ EST006->TIPO+ EST006->ESTADO +;
                   str( EST006->BIT_MM,8,3) + STR( EST006->ESP_MM,8,3 ))

      EST007->( dbsetorder(3))
      EST007->( dbseek( W_CHAVE_ITEM ) )
      while EST007->( ! rlock() ); end
      EST007->QTD_PED := EST007->QTD_PED - EST006->QTD_KG
      EST007->( dbunlock() )
   end

   while EST006->( ! rlock() ); end
   EST006->( dbdelete() )

end
return

/*
-------------------------------------------------------------------------------
                           ITEM_ZERA16
-------------------------------------------------------------------------------
*/
procedure item_zera16()

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
   X_STATUS   := SPACE(1)

   X_CUS_ITOT := 0.00
   X_CUSTO_KG := 0.00
   X_DT_PREV  := ctod("")
   X_QTD_KG   := 0.00
   X_QTD_PEC  := 0
   X_VAL_KG   := 0.00000
   X_IPI      := 5
   X_ICMS     := 0.00
   X_FRETE    := 0.00
   X_OUTRATX  := 0.00

return

/*
-------------------------------------------------------------------------------
			   item_GRAVA16
-------------------------------------------------------------------------------
*/
procedure item_grava16( P_MODO )

   while EST007->( ! rlock() ); end

   if P_MODO = "I" // ( Inclusao )

      X_SEQUENC := 1

      // cria item de pedido
      EST006->( dbappend())
      EST006->PEDIDO := X_PEDIDO
      EST006->SEQUENC  := X_SEQUENC

      // atualiza quantidade de itens e o total do item

      while EST005->( ! rlock() ); end
      EST005->QTD_ITENS  := EST005->QTD_ITENS + 1
      EST005->STATUS	:= "P"
      EST005->( dbunlock() )

      // atualiza quantidade comprada

      EST007->( dbsetorder(1))
      EST007->( dbseek( W_CHAVE_ITEM ) )
      while EST007->( ! rlock() ); end
      EST007->QTD_PED := EST007->QTD_PED + X_QTD_KG
      EST007->( dbunlock() )

   else
      X_SEQUENC := nova_sequencia( X_PEDIDO )

      // atualiza quantidade comprada no item de estoque

      EST007->( dbsetorder(1))
      EST007->( dbseek( W_CHAVE_ITEM ) )
      while EST007->( ! rlock() ); end
      EST007->QTD_PED := EST007->QTD_PED - EST006->QTD_KG + X_QTD_KG
      EST007->( dbunlock() )

      // bloqueia registro do item de pedido
      while EST006->( ! rlock() ); end

   end

   EST006->FORMA    := X_FORMA
   EST006->TIPO     := X_TIPO
   EST006->ESTADO   := X_ESTADO
   EST006->BIT_MM   := X_BIT_MM
   EST006->ESP_MM   := X_ESP_MM
   EST006->BIT_INT  := X_BIT_INT
   EST006->BIT_FN   := X_BIT_FN
   EST006->BIT_FD   := X_BIT_FD
   EST006->ESP_INT  := X_ESP_INT
   EST006->ESP_FN   := X_ESP_FN
   EST006->ESP_FD   := X_ESP_FD

   EST006->CUS_ITOT := X_CUS_ITOT
   EST006->CUSTO_KG := X_CUSTO_KG
   EST006->DT_PREV  := X_DT_PREV
   EST006->QTD_KG   := X_QTD_KG
   EST006->QTD_PEC  := X_QTD_PEC
   EST006->VAL_KG   := X_VAL_KG
   EST006->IPI	    := X_IPI
   EST006->ICMS     := X_ICMS
   EST006->FRETE    := X_FRETE
   EST006->OUTRATX  := X_OUTRATX

   EST006->( dbunlock() )

   // atualiza o total do item

   while EST005->( ! rlock() ); end
   EST005->QTDITPEND  := EST005->QTDITPEND + 1
   EST005->TOTAL_PEND := calc_total( EST005->PEDIDO, 1 )
   EST005->STATUS    := "P"
   EST005->( dbunlock() )

return

/*
-------------------------------------------------------------------------------
			   item_ATRIB16
-------------------------------------------------------------------------------
*/
procedure item_atrib16()

   X_PEDIDO	:=  EST006->PEDIDO
   X_SEQUENC	:=  EST006->SEQUENC

   X_FORMA	:=  EST006->FORMA
   X_TIPO	:=  EST006->TIPO
   X_ESTADO	:=  EST006->ESTADO
   X_BIT_MM	:=  EST006->BIT_MM
   X_ESP_MM	:=  EST006->ESP_MM
   X_BIT_INT	:=  EST006->BIT_INT
   X_BIT_FN	:=  EST006->BIT_FN
   X_BIT_FD	:=  EST006->BIT_FD
   X_ESP_INT	:=  EST006->ESP_INT
   X_ESP_FN	:=  EST006->ESP_FN
   X_ESP_FD	:=  EST006->ESP_FD
   X_STATUS     :=  EST005->STATUS

   X_CUS_ITOT   :=  EST006->CUS_ITOT
   X_CUSTO_KG   :=  EST006->CUSTO_KG
   X_DT_PREV    :=  EST006->DT_PREV
   X_QTD_KG	:=  EST006->QTD_KG
   X_QTD_PEC	:=  EST006->QTD_PEC
   X_VAL_KG     :=  EST006->VAL_KG
   X_IPI	:=  EST006->IPI
   X_ICMS	:=  EST006->ICMS
   X_FRETE	:=  EST006->FRETE
   X_OUTRATX	:=  EST006->OUTRATX

return

/*
-------------------------------------------------------------------------------
			   item_SHOW16
-------------------------------------------------------------------------------
*/
procedure item_show16()

get_mainkey(2)
tes_formato(09,16,20)
tes_tipo(2)
tes_estado(2)
clear gets

@ 15,27 say EST006->DT_PREV
@ 17,27 say EST006->QTD_PEC  picture "99999"
@ 18,27 say EST006->QTD_KG   picture "999,999.99"

// EST006->VAL_KG

@ 20,25 say EST006->VAL_KG  picture "999.99999"
@ 13,64 say EST006->IPI     picture "99.99"
@ 14,64 say EST006->ICMS    picture "99.99"
@ 15,64 say EST006->FRETE   picture "999,999.99"
@ 16,64 say EST006->OUTRATX picture "99.99"
read
//
// Calcula o custo do item por kg
//
X_CUSTO_KG := calc_x_custo()

X_CUS_ITOT := X_CUSTO_KG * EST006->QTD_KG

@ 18,64 say X_CUSTO_KG picture "999,999.99999"
@ 19,64 say X_CUS_ITOT picture "999,999.99999"

return

/*
-------------------------------------------------------------------------------
                           ITEM_GET16
-------------------------------------------------------------------------------
*/
procedure item_get16( P_ACAO )
local WRET := .F.

if P_ACAO = 'INCLUSAO'
   @ 15,27 get X_DT_PREV                         valid X_DT_PREV >= date()
else
   @ 15,27 get X_DT_PREV
end

@ 17,27 get X_QTD_PEC  picture "99999"
@ 18,27 get X_QTD_KG   picture "999,999.99"      valid X_QTD_KG > 0

// X_VAL_KG

@ 20,25 get X_VAL_KG  picture "999.99999" valid X_VAL_KG > 0
@ 13,64 get X_IPI     picture "99.99"         valid X_IPI >= 0
@ 14,64 get X_ICMS    picture "99.99"         valid X_ICMS >= 0
@ 15,64 get X_FRETE   picture "999,999.99"    valid X_FRETE >= 0
@ 16,64 get X_OUTRATX picture "99.99"         valid X_FRETE >= 0
read

X_CUSTO_KG := calc_x_custo()
X_CUS_ITOT := X_CUSTO_KG * X_QTD_KG

@ 18,64 say X_CUSTO_KG picture "999,999.99999"
@ 19,64 say X_CUS_ITOT picture "999,999.99"

if ! lastkey()=K_ESC
   if conf(' Confirma Inclusao ')
      WRET := .T.
   end
end

return WRET

/*
-------------------------------------------------------------------------------
			   item_TELA16
-------------------------------------------------------------------------------
*/
procedure item_tela16()

   @ 07,02 say 'ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´'
   @ 08,02 say '³                                                                          ³'
   @ 09,02 say '³  Forma    :       -                                                      ³'
   @ 10,02 say '³  Tipo     :       -                                                      ³'
   @ 11,02 say '³  Estado   :       -                                                      ³'
   @ 12,02 say '³  Bit./Esp.:      /                                                       ³'
   @ 13,02 say '³  Bit./Larg:      /                  Taxas  - IPI   (%)    :              ³'
   @ 14,02 say '³                                            - ICMS  (%)    :              ³'
   @ 15,02 say '³  Data Entrega (Prev.):                     - Frete Kg     :              ³'
   @ 16,02 say '³                                            - Desp. Fin.(%):              ³'
   @ 17,02 say '³  Quantidade - Pe‡a   :                                                   ³'
   @ 18,02 say '³               KG     :             Custo do Item - por KG :              ³'
   @ 19,02 say '³                                                  - Total  :              ³'
   @ 20,02 say '³  Pre‡o a vista Kg :                                                      ³'
   @ 21,02 say '³                                                                          ³'
   @ 22,02 say 'ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ'

return

// --------------  FIM DE PROGRAMA  --------------------------------- //

***************************
Function reduz_estoque(var)
***************************

arq := alias()

sele est007
dbsetorder(2)

if ! dbseek(X_FORMA+X_TIPO+str(X_BIT_MM,8,3)+str(X_ESP_MM,8,3)+X_ESTADO)
   message('Item de Estoque n„o Atualizado')
   return .f.
end

if EST007->QTD_KG < var
   message('Saldo em Kg do Material Insuficiente')
   return .f.
else
   while EST007->( ! rlock() ); end
   EST007->QTD_KG := EST007->QTD_KG - var
   EST007->( dbunlock() )
end

sele &arq

return .t.


/*
-------------------------------------------------------------------------------
			   show_total
-------------------------------------------------------------------------------
*/
procedure show_total( P_TOT, POSICAO )

if POSICAO = 1
   @ 21,38 say 'Custo Total Pendente...:'
   @ 21,63 say P_TOT picture "999,999,999.99"
else
   @ 04,68 say P_TOT picture "99999"
end

return
******************************** TELAS **********************************

/*
-------------------------------------------------------------------------------
			   nova_sequencia
-------------------------------------------------------------------------------
*/

procedure nova_sequencia( P_PEDIDO )
local W_ULTSEQ:=0, W_ANTREG := EST006->( recno())

EST006->( dbsetorder(1))
EST006->( dbseek( P_PEDIDO ) )

while EST006->PEDIDO = P_PEDIDO .and. EST006->( ! eof())
   W_ULTSEQ := EST006->SEQUENC
   EST006->( dbskip())
end
W_ULTSEQ++

EST006->( dbgoto( W_ANTREG ))
return W_ULTSEQ

/*
-------------------------------------------------------------------------------
				  calc_KG
-------------------------------------------------------------------------------
*/
function calc_KG( W_QTD )
   local WRET

   EST007->( dbsetorder(1))
   EST007->( dbseek( W_CHAVE_ITEM ))

   if EST007->PES_INT # 0
      WRET := W_QTD * EST007->PES_INT
      X_QTD_KG := WRET
   end

return .T.

/*
-------------------------------------------------------------------------------
				  calc_x_custo
-------------------------------------------------------------------------------
*/
function calc_x_custo()

local WRET
//
// Calcula o custo por kg do item

/*
WRET := X_VAL_KG			 + ;
      ( X_VAL_KG * X_IPI/100 )		 + ;
      ( X_VAL_KG * ( 19 - X_ICMS )/100 ) + ;
	X_FRETE 			 + ;
      ( X_VAL_KG * X_OUTRATX/ 100 )
*/

WRET := X_VAL_KG		     + ;
      ( X_VAL_KG * X_OUTRATX/ 100 )	      // Despesas financeiras

WRET :=   WRET			       + ;
	( WRET * X_IPI/100 )	       + ;
	( WRET * ( 19 - X_ICMS )/100 ) + ;
	  X_FRETE

return( WRET )

/*
-------------------------------------------------------------------------------
			     calc_custo
-------------------------------------------------------------------------------
*/
function calc_custo( X_SEQUENC, POSICAO )
   local W_CUSTO := 0,;
	 WRET	 := 0

//
// Calcula custo por KG do item e do custo total do item
//
   W_SCUSTO :=	EST006->VAL_KG +  ;
	      ( EST006->VAL_KG * EST006->OUTRATX/100 )

   W_CUSTO :=	W_SCUSTO			       + ;
	      ( W_SCUSTO * EST006->IPI/100	       + ;
	      ( W_SCUSTO * ( 19 - EST006->ICMS )/100 ) + ;
		EST006->FRETE )

   if POSICAO = 1
      WRET := W_CUSTO
   else
      WRET := W_CUSTO * EST006->QTD_KG
   end

return WRET

/*
-------------------------------------------------------------------------------
function calc_total( W_PEDTOT, POSICAO )

Parametros

        POSICAO : 1 - Retorna o total PENDENTE
		  2 - Retorna a quantidade de itens do pedido
                  3 - Retorna o total PEDIDO
-------------------------------------------------------------------------------
*/
function calc_total( W_PEDTOT, POSICAO )
   local W_TOTAL := W_QUANT := 0, WRET := 0, W_TOTPEND := 0,;
         W_OLDREC := EST006->( recno() )

   select EST006
   EST006->( dbsetorder(1) )
   EST006->( dbgotop() )
   EST006->( dbseek( W_PEDTOT ))

   if EST006->( found() )

      while EST006->( ! eof() ) .and. EST006->PEDIDO=W_PEDTOT

         //
	 // Calcula valor total dos itens (custo total dos itens de um pedido)
	 //


	 W_STOTAL := (EST006->VAL_KG * EST006->QTD_KG			    ) + ;
		     (EST006->VAL_KG * EST006->QTD_KG * EST006->OUTRATX/100 )


         if empty( EST006->R_DTPED )  // Calcula apenas o total pendente

            W_TOTPEND +=  W_STOTAL                             + ;
                       (W_STOTAL * EST006->IPI/100         ) + ;
                       (W_STOTAL * (19 - EST006->ICMS)/100 ) + ;
                       (EST006->FRETE  * EST006->QTD_KG    )
         end

         W_TOTAL +=  W_STOTAL                             + ;
                    (W_STOTAL * EST006->IPI/100         ) + ;
                    (W_STOTAL * (19 - EST006->ICMS)/100 ) + ;
                    (EST006->FRETE  * EST006->QTD_KG    )

	 W_QUANT++ // Contar numero de itens
	 EST006->( dbskip() )
      end
   end

   do case

      case POSICAO = 1 // Retornar total do pedido pendente
         WRET := W_TOTPEND

      case POSICAO = 2 // Retornar quantidade de itens do pedido
	 WRET := W_QUANT

      case POSICAO = 3 // Retornar o total do pedido
         WRET := W_TOTAL
   endcase

   EST006->( dbgoto( W_OLDREC ) )

return WRET
