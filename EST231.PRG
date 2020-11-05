
/*

   SCM - Sistema de Controle Metalurgico
   EST231.PRG - Item de Pedido de Compra  ou item de Recebimento de Material

*/
#include "inkey.ch"
telanum('SCR231','EST231')
/*
-------------------------------------------------------------------------------
                           it23_EDIT23
-------------------------------------------------------------------------------
*/
function it23_EDIT()
local WRET := .T.

// variaveis DBEDIT
P_HDSEP := "ËÍ"
P_COLSEP := "-"
P_HEADER := {"  For    Tipo   Bit/Esp    Bit/Larg     Qtd.Kg    Preco KG   Recebimento  " }
//            12XXX123XXXXX12X,XXX.XX1234X,XXX.XX1XXX,XXX.XX123456XXX.XX123456XX/XX/XX12

P_CAMPOS := {"space(2) +      EST006->FORMA        + space(3) + EST006->TIPO +"+;
             "space(2) +  STR(EST006->BIT_MM,8,2)  + space(4) + STR(EST006->ESP_MM,8,2) +"+;
             "space(1) +  STR(EST006->QTD_KG,10,2) + space(6) + STR(EST006->VAL_KG,6,2) +"+;
             "space(6) + dtoc(EST006->R_DTPED)     + space(2)" }

it23_brow()
EST006->( dbsetfilter( {|| EST006->PEDIDO = X_PEDIDO} ) )
show_total( calc_total( X_PEDIDO, 1 ), 1 )
show_total( calc_total( X_PEDIDO, 2 ), 2 )
EST006->( dbgotop() )
EST006->( dbedit(08,03,19,76,P_CAMPOS,"it23_FUNC",, P_HEADER, P_HDSEP, P_COLSEP))
EST006->( dbclearfilter())

if lastkey()=K_ESC; WRET:=.F.;end
return WRET

/*
-------------------------------------------------------------------------------
                           it23_FUNC
-------------------------------------------------------------------------------
*/
function it23_FUNC( modo, coluna )
private WRET := 1, W_ITEMSCR := savescreen(02,01,22,79)
setcursor(1)

if modo = 4
   do case
      case lastkey() = K_F3
         if ! empty( EST006->R_DTPED )
            message( "Item ja' recebido")
            WRET := 2
         else
            it23_baixa()
            show_total( calc_total( X_PEDIDO, 1 ), 1 )
            WRET := 2
         endif

      case lastkey() = K_ESC
	 WRET := 0
  endcase
end
restscreen(02,01,22,79,W_ITEMSCR )

select EST006

return WRET

/*
-------------------------------------------------------------------------------
                           IT23_BAIXA
-------------------------------------------------------------------------------
*/
function it23_baixa()

local W_OLDSCR := savescreen()

X_FORMA   := EST006->FORMA
X_TIPO    := EST006->TIPO
X_ESTADO  := EST006->ESTADO
X_BIT_MM  := EST006->BIT_MM
X_ESP_MM  := EST006->ESP_MM
X_BIT_INT := EST006->BIT_INT
X_BIT_FN  := EST006->BIT_FN
X_BIT_FD  := EST006->BIT_FD
X_ESP_INT := EST006->ESP_INT
X_ESP_FN  := EST006->ESP_FN
X_ESP_FD  := EST006->ESP_FD

X_QTD_KG  := EST006->QTD_KG      //  EST006->R_QTDKG
X_QTD_PEC := EST006->QTD_PEC
X_R_QTDKG := EST006->QTD_KG
X_R_VALKG := EST006->VAL_KG      //  EST006->R_VALKG
X_R_DTPED := date()              //  EST006->R_DTPED

X_LOTE     := space(05)
X_CUS_ITEM := 0.00

it23_tela()
get_mainkey(2)
clear gets

tes_formato(09,16,20)
tes_tipo(2)
tes_estado(2)

W_CHAVE_ITEM := ( X_FORMA+ X_TIPO+ ;
             str( X_BIT_MM, 8, 3 ) + str( X_ESP_MM, 8, 3 ) + X_ESTADO )

if it23_get()
   if it23_lote()
      it23_grava("A")
      it23_estoque()
      it23_movimenta()
   end
end

return

/*
-------------------------------------------------------------------------------
                           IT23_GRAVA
-------------------------------------------------------------------------------
*/
procedure it23_grava( P_MODO )

   while EST006->( ! rlock() ); end

   EST006->R_QTDKG   := X_R_QTDKG
   EST006->R_VALKG   := X_R_VALKG
   EST006->R_QTDPEC  := X_R_QTDPEC
   EST006->R_DTPED   := X_R_DTPED

   EST006->( dbunlock() )

return

/*
-------------------------------------------------------------------------------
                           it23_GET
-------------------------------------------------------------------------------
*/
procedure it23_get
local WRET := .T.
*/
X_FORMA := EST006->FORMA

get_mainkey(2)
clear gets

X_LOTE     := novo_lote()
X_R_QTDPEC := EST006->QTD_PEC
X_R_QTDKG  := EST006->QTD_KG
X_R_VALKG  := EST006->VAL_KG + EST006->VAL_KG * EST006->OUTRATX/100
X_R_DTPED  := date()

@ 16,25 say EST006->QTD_PEC  picture "99,999"
@ 17,25 say EST006->QTD_KG   picture "999,999.99"
@ 18,25 say X_R_VALKG        picture "999.99999"

@ 16,59 get X_R_QTDPEC picture "99999"  valid X_R_QTDPEC > 0
@ 17,59 get X_R_QTDKG  picture "999,999.99"  valid X_R_QTDKG > 0
@ 18,59 get X_R_VALKG  picture "999.99999"
@ 19,59 get X_R_DTPED  valid ! empty( X_R_DTPED )
read

if lastkey()=K_ESC; WRET:=.F.;end
return WRET

/*
-------------------------------------------------------------------------------
                           it23_BROW()
-------------------------------------------------------------------------------
*/
procedure it23_brow()

   @ 07,02 say 'ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ Itens ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´'
   @ 08,02 say '³                                                                          ³'
   @ 09,02 say '³                                                                          ³'
   @ 10,02 say '³                                                                          ³'
   @ 11,02 say '³                                                                          ³'
   @ 12,02 say '³                                                                          ³'
   @ 13,02 say '³                                                                          ³'
   @ 14,02 say '³                                                                          ³'
   @ 15,02 say '³                                                                          ³'
   @ 16,02 say '³                                                                          ³'
   @ 17,02 say '³                                                                          ³'
   @ 18,02 say '³                                                                          ³'
   @ 19,02 say '³                                                                          ³'
   @ 20,02 say 'ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´'
   @ 21,02 say '³  <F3> Recebe Item   ³                                                    ³'
   @ 22,02 say 'ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ'

return

/*
-------------------------------------------------------------------------------
                           it23_TELA
-------------------------------------------------------------------------------
*/
procedure it23_tela()

   @ 07,02 say 'ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´'
   @ 08,02 say '³                                                                          ³'
   @ 09,02 say '³  Forma    :       -                                                      ³'
   @ 10,02 say '³  Tipo     :       -                                                      ³'
   @ 11,02 say '³  Estado   :       -                                                      ³'
   @ 12,02 say '³  Bit./Esp.:      /                                                       ³'
   @ 13,02 say '³  Bit./Larg:      /                                                       ³'
   @ 14,02 say '³                                                                          ³'
   @ 15,02 say '³  Pedido                              Recebido                            ³'
   @ 16,02 say '³   Qtde. Pe‡as......:                  Qtde. Pe‡as....:                   ³'
   @ 17,02 say '³   Qtde. em KG......:                  Qtde. em Kg....:                   ³'
   @ 18,02 say '³   Pre‡o a prazo Kg :                  Pre‡o final Kg.:                   ³'
   @ 19,02 say '³                                       Data...........:                   ³'
   @ 20,02 say 'ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´'
   @ 21,02 say '³                                                                          ³'
   @ 22,02 say 'ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ'

return

/*
-------------------------------------------------------------------------------
                           it23_ESTOQUE
-------------------------------------------------------------------------------
*/

function it23_estoque()
local WRET := .T.

   EST007->( dbsetorder(1) )
   EST007->( dbseek( W_CHAVE_ITEM ) )

   if EST007->( !found())
      message('Estoque n„o atualizado ')
      WRET := .F.
   else
      while EST007->( ! rlock() ); end

      // acrescenta quantidade de inteira recebida ao estoque
      EST007->QTD_KGI  := EST007->QTD_KGI + X_R_QTDKG

      // reduz quantidade comprada  do total da quantidade do pedido do item
      EST007->QTD_PED  := EST007->QTD_PED - EST006->QTD_KG

      // acrescenta quantidade de pecas
      EST007->QTD_INT  := EST007->QTD_INT + X_R_QTDPEC

      // calcula custo medio por KG
      X_CUS_ITEM := calc_r_custo()
      EST007->CUS_MED  :=( ( X_CUS_ITEM * X_R_QTDKG ) + ( EST007->CUS_MED * EST007->QTD_KGT ) ) / ;
                          ( EST007->QTD_KGT + X_R_QTDKG )

      // acrescenta quantidade recebida ao estoque
      EST007->QTD_KGT  := EST007->QTD_KGT + X_R_QTDKG
      /*
      EST007->CUS_MED  := (EST007->CUS_ULT * EST007->QTD_KGT + X_CUS_ITEM * X_R_QTDKG ) / ;
                           EST007->QTD_KGT + X_R_QTDKG
      */

      EST007->DAT_ULT  := X_R_DTPED
      EST007->CUS_ULT  := X_CUS_ITEM

      if X_CUS_ITEM = 0
         X_CUS_ITEM       := EST007->CUS_ULT
      end

      EST007->( dbunlock() )

      EST031->( dbsetorder(W_CHAVE_ITEM ) )
      EST031->( dbseek( W_CHAVE_ITEM ) )

      while EST031->( ! rlock() ); end
      EST031->QTD_KGT  := EST031->QTD_KGT + X_R_QTDKG
      EST031->QTD_INT  := EST031->QTD_INT + X_R_QTDPEC

      // Diminui quantidade de itens pendentes
      while EST005->( ! rlock()); end
      EST005->TOTAL_PEDI := EST005->TOTAL_PEDI + EST006->CUS_ITOT
      EST005->TOTAL_PEND := EST005->TOTAL_PEND - EST006->CUS_ITOT
      EST005->QTDITPEND  := EST005->QTDITPEND - 1
      EST005->( dbunlock() )

   end

return WRET

/*
-------------------------------------------------------------------------------
                           it23_movimenta
-------------------------------------------------------------------------------
*/

function it23_movimenta()
local WRET := .T.

   EST010->( dbappend() )

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
   EST010->OPERACAO := 'E'
   EST010->ALMOXARI := '001'
   EST010->TIPOMOVI := '001'
   EST010->DATAMOVI := X_R_DTPED
   EST010->QTD_KG   := X_R_QTDKG
   EST010->QTD_INT  := X_QTD_PEC
   EST010->VAL_KG   := X_VAL_KG
   EST010->ORIGEM   := X_PEDIDO + '- COMPRA'

   EST010->( dbunlock() )

return WRET

/*
-------------------------------------------------------------------------------
                           it23_LOTE
-------------------------------------------------------------------------------
*/

function it23_lote()

private SALVATELA := savescreen(,,,,), WRET := .F.

private X_NOTAFISCAL  := space(10) ,;
        X_DTFISCAL    := date()    ,;
        X_CORRIDA     := space(9)  ,;
        X_ACABAMENTO  := space(15) ,;
        X_O_PRODUCAO  := space(9)  ,;
        X_PUNCAO      := space(9)  ,;
        X_CERTIFIC    := space(9)  ,;
        X_CAR_LOT     := space(30) ,;
        X_OBS         := space(60) ,;
        X_OBS1        := space(60)

lote31_tela()
if lote31_get()
   if X_OPERACAO=="E" .or. X_OPERACAO=="S"
      lote31_grava("M")
      WRET := .T.
   elseif X_OPERACAO = NIL
      lote31_grava("R")
      WRET := .T.
    end
else
   WRET := .F.
end

restscreen(,,,,SALVATELA)
return WRET

/*

/*
-------------------------------------------------------------------------------
                                  calc_r_custo
-------------------------------------------------------------------------------
*/
function calc_r_custo()

local WRET
//
// Calcula o custo por kg do item recebido
//

WRET := X_R_VALKG                               + ;
      ( X_R_VALKG * EST006->IPI/100 )           + ;
      ( X_R_VALKG * ( 19 - EST006->ICMS )/100 ) + ;
        EST006->FRETE

return( WRET )

// --------------  FIM DE PROGRAMA  --------------------------------- //

