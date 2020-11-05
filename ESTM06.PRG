/*

   SCM - Sistema de Controle Metalurgico
   ESTM06.PRG - Arq. Morto de Item de Pedido de Compra

*/
#include "inkey.ch"
ALTD(1)
setcancel(.T.)


/*
-------------------------------------------------------------------------------
                              ITEMM_EDIT16
-------------------------------------------------------------------------------
*/
function ITEMM_EDIT16( P_MODO )
local WRET := .T.

private  W_FILE      := {}
private  CAMPO       := {}
private  MASCARA     := {}
private  CABECALHO   := {}
private  TAMANHO     := {}
private  BESCAPE     := {|| ESTM06->PEDIDO = X_PEDIDO }
private  COR         := W_COREDIT
private  TITULO      := " Arquivo Morto de Compras "
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

aadd( W_FILE , "ESTM06" )
aadd( W_FILE , "ESTM06" )
aadd( W_FILE , "ESTM06" )
aadd( W_FILE , "ESTM06" )
aadd( W_FILE , "ESTM06" )
aadd( W_FILE , "ESTM06" )
aadd( W_FILE , "ESTM06" )
aadd( W_FILE , "ESTM06" )
aadd( W_FILE , "ESTM06" )

// variaveis DBEDIT

ESTM06->( dbsetorder(1) )
ESTM06->( dbseek(X_PEDIDO) )

select ESTM06

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

      case lastkey() = K_F5
         if P_MODO = 'ALTERA'
            if empty( ESTM06->R_DTPED )
               ITEMM_exclui16()
            end
            restscreen(,,,,W_TEL161)
            tabela:refreshall()
         end

      case lastkey() = K_F6
         if ! empty( ESTM06->PEDIDO )

	    W1_ITEMSCR := savescreen(21,00,24,79)
            ITEMM_consulta16()
	    @ 24, 00 say padc(" Tecle para continuar ",80)
	    inkey(0)
	    restscreen(21,00,24,79,W1_ITEMSCR)
            restscreen(,,,,W_TEL161)
            tabela:refreshall()
         end

   endcase

   setcolor( W_COREDIT )
   select ESTM06

enddo

if lastkey()=K_ESC
   WRET := .F.
end

restscreen(,,,,W_TEL16)

return WRET

/*
-------------------------------------------------------------------------------
                           ITEMM_CONSULTA16
-------------------------------------------------------------------------------
*/
Function ITEMM_consulta16()
local W_OLDSCR := savescreen()

ITEMM_atrib16()
ITEMM_tela16()
ITEMM_show16()

return

/*
-------------------------------------------------------------------------------
                           ITEMM_EXCLUI16
-------------------------------------------------------------------------------
*/
Function ITEMM_exclui16()

local W_OLDSCR := savescreen()

ITEMM_tela16()
ITEMM_atrib16()
ITEMM_show16()

if conf(' Confirma Exclus„o ')

   while ESTM05->( ! rlock() ); end
   ESTM05->QTD_ITENS := ESTM05->QTD_ITENS-1
   ESTM05->QTDITPEND := ESTM05->QTDITPEND-1
   ESTM05->( dbunlock() )

   while ESTM06->( ! rlock() ); end
   ESTM06->( dbdelete() )

end
return

/*
-------------------------------------------------------------------------------
                           ITEMM_ZERA16
-------------------------------------------------------------------------------
*/
procedure ITEMM_zera16()

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
                           ITEMM_ATRIB16
-------------------------------------------------------------------------------
*/
procedure ITEMM_atrib16()

   X_PEDIDO     :=  ESTM06->PEDIDO
   X_SEQUENC    :=  ESTM06->SEQUENC

   X_FORMA      :=  ESTM06->FORMA
   X_TIPO       :=  ESTM06->TIPO
   X_ESTADO     :=  ESTM06->ESTADO
   X_BIT_MM     :=  ESTM06->BIT_MM
   X_ESP_MM     :=  ESTM06->ESP_MM
   X_BIT_INT    :=  ESTM06->BIT_INT
   X_BIT_FN     :=  ESTM06->BIT_FN
   X_BIT_FD     :=  ESTM06->BIT_FD
   X_ESP_INT    :=  ESTM06->ESP_INT
   X_ESP_FN     :=  ESTM06->ESP_FN
   X_ESP_FD     :=  ESTM06->ESP_FD
   X_STATUS     :=  ESTM05->STATUS

   X_CUS_ITOT   :=  ESTM06->CUS_ITOT
   X_CUSTO_KG   :=  ESTM06->CUSTO_KG
   X_DT_PREV    :=  ESTM06->DT_PREV
   X_QTD_KG     :=  ESTM06->QTD_KG
   X_QTD_PEC    :=  ESTM06->QTD_PEC
   X_VAL_KG     :=  ESTM06->VAL_KG
   X_IPI        :=  ESTM06->IPI
   X_ICMS       :=  ESTM06->ICMS
   X_FRETE      :=  ESTM06->FRETE
   X_OUTRATX    :=  ESTM06->OUTRATX

return

/*
-------------------------------------------------------------------------------
                           ITEMM_SHOW16
-------------------------------------------------------------------------------
*/
procedure ITEMM_show16()

get_mainkey(2)
tes_formato(09,16,20)
tes_tipo(2)
tes_estado(2)
clear gets

@ 15,27 say ESTM06->DT_PREV
@ 17,27 say ESTM06->QTD_PEC  picture "99999"
@ 18,27 say ESTM06->QTD_KG   picture "999,999.99"

// ESTM06->VAL_KG

@ 20,25 say ESTM06->VAL_KG  picture "999.99999"
@ 13,64 say ESTM06->IPI     picture "99.99"
@ 14,64 say ESTM06->ICMS    picture "99.99"
@ 15,64 say ESTM06->FRETE   picture "999,999.99"
@ 16,64 say ESTM06->OUTRATX picture "99.99"
read

X_CUS_ITOT := X_CUSTO_KG * ESTM06->QTD_KG

@ 18,64 say X_CUSTO_KG picture "999,999.99999"
@ 19,64 say X_CUS_ITOT picture "999,999.99999"

return

/*
-------------------------------------------------------------------------------
                           ITEMM_TELA16
-------------------------------------------------------------------------------
*/
procedure ITEMM_tela16()

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

