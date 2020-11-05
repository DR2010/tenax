/*

   SCM - Sistema de Controle Metalurgico
   EST23.PRG - Recebimento de Material

*/
#include "inkey.ch"
Local Tela

setcolor(W_COREDIT)
telanum('SCR23 ','EST23 ')
/*
-------------------------------------------------------------------------------


-------------------------------------------------------------------------------
*/

abrir("EST002")
abrir("EST003")
abrir("EST004")
abrir("EST005")
abrir("EST006")
abrir("EST007")
abrir("EST009")
abrir("EST010")
abrir("EST031")

status('Recebimento de Material')

// VARIAVEIS

W_SEQ_PED  := 0

X_PEDIDO   := SPACE(05)

// --> EST005 -> PEDIDO
private  X_FORNECEDOR := space(03) ,;
         X_DTPEDIDO   := date()    ,;
         X_R_DTPED    := date()    ,;
         X_STATUS     := space(1)  ,;
         X_QTD_ITENS  := 0.00      ,;
         X_COND_PGTO  := space(20),;
         X_CONTATO    := space(20)
// --> EST006 -> PEDIDO
private  X_QTD_KG     := 0.00  ,;
         X_QTD_PEC    := 0     ,;
         X_VAL_KG     := 0.00000  ,;
         X_VAL_PEC    := 0.00  ,;
         X_FRETE      := 0.00  ,;
         X_TAXAS      := 0.00

private W_CHAVE_ITEM        ,;
        X_SEQUENC           ,;
        X_OPERACAO          ,;
        X_R_QTDPEC:=0       ,;
        X_R_QTDKG:=0        ,;
        X_R_DTPED:=ctod(' ')
        



TELA := wsave(01,02,19,68)

//
// variaveis DBEDIT
//

P_HDSEP := "ËÍ"
P_COLSEP := "-"
P_HEADER := {"      Pedido   Data    Fornecedor         itens         Recebimento       "}
//                  XXXXX  XXXXXXXX  XXX - XXXXXXXXXXXXXXXXX XXXXX123XXXXXXXX

EST005->( dbsetrelation( "EST002", {|| EST005->FORNECEDOR } ) )
P_CAMPOS := {"'      '+EST005->PEDIDO+space(2)+dtoc(EST005->DTPEDIDO)+space(2) +"+;
             " EST005->FORNECEDOR + space(1)+left(EST002->FGUERRA,17)+space(1) +"+;
             " transform(EST005->QTD_ITENS,'99999')+space(12)+dtoc(EST005->R_DTPED)+ '     ' "}


private  X_FORMA    := space(03) ,;
         X_TIPO     := space(05) ,;
         X_ESTADO   := space(01) ,;
         X_BIT_MM   := 0.00      ,;
         X_ESP_MM   := 0.00      ,;
         X_BIT_INT  := space(02) ,;
         X_BIT_FN   := space(02) ,;
         X_BIT_FD   := space(02) ,;
         X_ESP_INT  := space(02) ,;
         X_ESP_FN   := space(02) ,;
         X_ESP_FD   := space(02)

while .t.

   W_TELA := savescreen(,,,,)
   tela23()

   EST005->( dbgotop() )
   EST005->( dbedit(05,03,18,76,P_CAMPOS,"ped23_func",, P_HEADER, P_HDSEP, P_COLSEP))
   restscreen(,,,,W_TELA)
   exit
end

return

//
//
// ----------------------------------------------------------------------------
//
//

/*
-------------------------------------------------------------------------------
                           ped23_func
-------------------------------------------------------------------------------
*/
function ped23_func( modo, coluna )
private WRET := 1, W_OLDSCR := savescreen(,,,,)
setcursor(1)

if modo = 4
   do case
      case lastkey() = K_F3
         if ! empty( EST005->R_DTPED )
            mensbeep( "Pedido ja' recebido")
            WRET := 2
         else
            ped23_altera()
            WRET := 2
         endif

      case lastkey() = K_ESC
         WRET := 0

      case lastkey() = K_F4
         if ! empty( EST005->R_DTPED )
            message( "Pedido ja' recebido")
         else
            ped23_fecha( EST005->PEDIDO )
         endif
         WRET := 2

      case lastkey() = K_ESC
         WRET := 0

  endcase
end

select EST005
restscreen(,,,,W_OLDSCR )
return WRET

/*
-------------------------------------------------------------------------------
                           ped23_altera
-------------------------------------------------------------------------------
*/
Function ped23_altera()

local W_OLDSCR := savescreen()

ped23_atrib()
ped23_tedit()
ped23_show()

X_PEDIDO := EST005->PEDIDO

if it23_edit("Altera")
   if it23_lote()
      it23_grava()
      it23_estoque()
      it23_movimenta()
   end
end

return

/*
-------------------------------------------------------------------------------
                           ped23_grava
-------------------------------------------------------------------------------
*/
procedure ped23_grava( P_MODO )

if P_MODO = "I"
   EST005->( dbappend() )
else
   while EST005->( ! rlock() ); end
end

EST005->PEDIDO     := X_PEDIDO
EST005->FORNECEDOR := X_FORNECEDOR
EST005->DTPEDIDO   := X_DTPEDIDO
EST005->R_DTPED    := X_R_DTPED
EST005->STATUS     := X_STATUS
EST005->QTD_ITENS  := X_QTD_ITENS
EST005->COND_PGTO  := X_COND_PGTO
EST005->CONTATO    := X_CONTATO
EST005->( dbunlock() )

return

/*
-------------------------------------------------------------------------------
                           PED23_ATRIB
-------------------------------------------------------------------------------
*/
procedure ped23_atrib()

X_FORNECEDOR  := EST005->FORNECEDOR
X_DTPEDIDO    := EST005->DTPEDIDO
X_R_DTPED     := EST005->R_DTPED
X_STATUS      := EST005->STATUS
X_QTD_ITENS   := EST005->QTD_ITENS
X_COND_PGTO   := EST005->COND_PGTO
X_CONTATO     := EST005->CONTATO
return

/*
-------------------------------------------------------------------------------
                           PED23_SHOW
-------------------------------------------------------------------------------
*/
procedure ped23_show()

@ 03,16 say EST005->PEDIDO
@ 03,45 say EST005->FORNECEDOR
@ 04,16 say EST005->DTPEDIDO
//@ 04,45 say EST005->STATUS
@ 04,68 say EST005->QTD_ITENS
@ 05,68 say EST005->R_DTPED
@ 05,24 say EST005->COND_PGTO
@ 06,13 SAY EST005->CONTATO
tes_forn( EST005->FORNECEDOR, 3 )

return

/*
-------------------------------------------------------------------------------
                           ped23_fecha
-------------------------------------------------------------------------------
*/
function ped23_fecha( var )
   local WRET := .T.

   select EST006
   EST006->( dbsetorder(1) )
   EST006->( dbgotop() )
   EST006->( dbseek( var ))

   if EST006->( found() )
      while EST006->( ! eof() ) .and. EST006->PEDIDO == var
         if empty( EST006->R_DTPED )
            WRET := .F.
         end
         EST006->( dbskip() )
      end
   end
   if WRET
         while EST005->( ! rlock() ); end
         EST005->R_DTPED := date()
         EST005->STATUS  := "R"
         EST005->( dbunlock() )
   else
      message("Existem iten(s) pendente(s)")
   endif

return NIL



/*
-------------------------------------------------------------------------------
                           ped23_tedit
-------------------------------------------------------------------------------
*/
procedure ped23_tedit()

   @ 02,02 say 'ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿'
   @ 03,02 say '³  N£mero ..:                Fornecedor .:     -                           ³'
   @ 04,02 say '³  Data ....:                                        Qtde Itens :          ³'
   @ 05,02 say '³  Condi‡„es de Pgto.:                               Fechamento :          ³'
   @ 06,02 say '³  Contato:                                                                ³'
   @ 07,02 say 'ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´'
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
   @ 20,02 say '³                                                                          ³'
   @ 21,02 say '³                                                                          ³'
   @ 22,02 say 'ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ'
   @ 23,02 say '                                                                            '
return

/*
-------------------------------------------------------------------------------
                           tela23
-------------------------------------------------------------------------------
*/
procedure tela23()

   @ 02,02 say 'ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿'
   @ 03,02 say '³                                Pedidos                                   ³'
   @ 04,02 say 'ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´'
   @ 05,02 say '³                                                                          ³'
   @ 06,02 say '³                                                                          ³'
   @ 07,02 say '³                                                                          ³'
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
   @ 19,02 say 'ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄ´'
   @ 20,02 say '³  <F3> Recebe  ³  <F4> Fecha   ³               ³                 ³        ³'
   @ 21,02 say '³       Itens   ³       Pedido  ³               ³                 ³        ³'
   @ 22,02 say 'ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÙ'

return

