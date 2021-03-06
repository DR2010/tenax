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

P_HDSEP := "箇"
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

   @ 02,02 say '旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴커'
   @ 03,02 say '�  N즡ero ..:                Fornecedor .:     -                           �'
   @ 04,02 say '�  Data ....:                                        Qtde Itens :          �'
   @ 05,02 say '�  Condi뇙es de Pgto.:                               Fechamento :          �'
   @ 06,02 say '�  Contato:                                                                �'
   @ 07,02 say '쳐컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴캑'
   @ 08,02 say '�                                                                          �'
   @ 09,02 say '�                                                                          �'
   @ 10,02 say '�                                                                          �'
   @ 11,02 say '�                                                                          �'
   @ 12,02 say '�                                                                          �'
   @ 13,02 say '�                                                                          �'
   @ 14,02 say '�                                                                          �'
   @ 15,02 say '�                                                                          �'
   @ 16,02 say '�                                                                          �'
   @ 17,02 say '�                                                                          �'
   @ 18,02 say '�                                                                          �'
   @ 19,02 say '�                                                                          �'
   @ 20,02 say '�                                                                          �'
   @ 21,02 say '�                                                                          �'
   @ 22,02 say '읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴켸'
   @ 23,02 say '                                                                            '
return

/*
-------------------------------------------------------------------------------
                           tela23
-------------------------------------------------------------------------------
*/
procedure tela23()

   @ 02,02 say '旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴커'
   @ 03,02 say '�                                Pedidos                                   �'
   @ 04,02 say '쳐컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴캑'
   @ 05,02 say '�                                                                          �'
   @ 06,02 say '�                                                                          �'
   @ 07,02 say '�                                                                          �'
   @ 08,02 say '�                                                                          �'
   @ 09,02 say '�                                                                          �'
   @ 10,02 say '�                                                                          �'
   @ 11,02 say '�                                                                          �'
   @ 12,02 say '�                                                                          �'
   @ 13,02 say '�                                                                          �'
   @ 14,02 say '�                                                                          �'
   @ 15,02 say '�                                                                          �'
   @ 16,02 say '�                                                                          �'
   @ 17,02 say '�                                                                          �'
   @ 18,02 say '�                                                                          �'
   @ 19,02 say '쳐컴컴컴컴컴컴컴쩡컴컴컴컴컴컴컴쩡컴컴컴컴컴컴컴쩡컴컴컴컴컴컴컴컴쩡컴컴컴캑'
   @ 20,02 say '�  <F3> Recebe  �  <F4> Fecha   �               �                 �        �'
   @ 21,02 say '�       Itens   �       Pedido  �               �                 �        �'
   @ 22,02 say '읕컴컴컴컴컴컴컴좔컴컴컴컴컴컴컴좔컴컴컴컴컴컴컴좔컴컴컴컴컴컴컴컴좔컴컴컴켸'

return

