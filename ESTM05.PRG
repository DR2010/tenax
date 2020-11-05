/*

   SCM - Sistema de Controle Metalurgico
   EST16.PRG - Arquivo Moerto de Pedido de Compra

*/
#include "inkey.ch"

/*
-------------------------------------------------------------------------------


-------------------------------------------------------------------------------
*/
abrir("EST002")
abrir("EST003")
abrir("EST004")
abrir("ESTM05")
abrir("ESTM06")
abrir("EST007")
abrir("ESTM05")
abrir("ESTM06")

setcolor(W_COREDIT)
status('Arquivo Morto de Compras')
telanum('SCRM05','ESTM05')

// TBROWSE

private  W_FILE      := {}
private  CAMPO       := {}
private  MASCARA     := {}
private  CABECALHO   := {}
private  TAMANHO     := {}
private  BESCAPE     := {|| .T. }
private  COR         := W_COREDIT
private  TITULO      := " Arquivo Morto de Compras "
private  LININI      := 05
private  LINFIM      := 18
private  COLINI      := 02
private  COLFIM      := 77
private  BLOCK_DISP  := {|| .T. }
private  CAB_TITULO  := nil
private  BORDA       := 1

private  TECLA       := nil
private  TABELA      := nil

aadd( CAMPO     , "PEDIDO" )
aadd( CAMPO     , "DTPEDIDO" )
aadd( CAMPO     , "STATUS" )
aadd( CAMPO     , "FGUERRA" )
aadd( CAMPO     , "QTDITPEND" )
aadd( CAMPO     , "QTD_ITENS" )
aadd( CAMPO     , "R_DTPED" )
aadd( CAMPO     , "TOTAL_PEND" )

aadd( MASCARA   , "XXXXXX"            )
aadd( MASCARA   , "99/99/99"       )
aadd( MASCARA   , "XX"                )
aadd( MASCARA   , "XXXXXXXXXXXXX" )
aadd( MASCARA   , "999"               )
aadd( MASCARA   , "999"               )
aadd( MASCARA   , "99/99/99"       )
aadd( MASCARA   , "9999999.99"    )

aadd( CABECALHO , "Pedido"       )
aadd( CABECALHO , "Data"         )
aadd( CABECALHO , "St"           )
aadd( CABECALHO , "Fornecedor"   )
aadd( CABECALHO , "Pd"           )
aadd( CABECALHO , "Itens"        )
aadd( CABECALHO , "Recebimento"  )
aadd( CABECALHO , "Tot.Penden" )

aadd( TAMANHO   ,  6 )
aadd( TAMANHO   ,  8 )
aadd( TAMANHO   ,  2 )
aadd( TAMANHO   , 17 )
aadd( TAMANHO   , 03 )
aadd( TAMANHO   , 03 )
aadd( TAMANHO   , 08 )
aadd( TAMANHO   , 10 )

aadd( W_FILE , "ESTM05" )
aadd( W_FILE , "ESTM05" )
aadd( W_FILE , "ESTM05" )
aadd( W_FILE , "EST002" )
aadd( W_FILE , "ESTM05" )
aadd( W_FILE , "ESTM05" )
aadd( W_FILE , "ESTM05" )
aadd( W_FILE , "ESTM05" )

// VARIAVEIS

W_SEQ_PED  := 0

X_PEDIDO   := SPACE(05)

// --> ESTM05 -> PEDIDO
private  X_FORNECEDOR := space(03)          ,;
         X_DTPEDIDO   := ctod( '  /  /  ' ) ,;
         X_DTped_R    := ctod( '  /  /  ' ) ,;
         X_STATUS     := space(1)           ,;
         X_QTD_ITENS  := 0.00,;
         X_COND_PGTO  := space(20),;
         X_CONTATO    := space(58)

// --> ESTM06 -> PEDIDO
private  X_DT_PREV    := ctod(""),;
         X_QTD_KG     := 0.00    ,;
         X_QTD_PEC    := 0       ,;
         X_VAL_KG     := 0.00000 ,;
         X_IPI        := 0.00    ,;
         X_ICMS       := 0.00    ,;
         X_FRETE      := 0.00    ,;
         X_OUTRATX    := 0.00    ,;
         X_CUSTO_KG   := 0.00
         X_CUS_ITOT   := 0.00
         WTPEDIDOS    := 0.00

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


private W_CHAVE_ITEM, X_SEQUENC

TELA := wsave(01,02,19,68)

ESTM05->( dbsetorder(1) ) // pedido + fornecedor
ESTM05->( dbgotop() ) // pedido + fornecedor

ESTM05->( dbsetrelation( "ESTM06", {|| ESTM05->PEDIDO },"ESTM05->PEDIDO" ) )
ESTM05->( dbsetrelation( "EST002", {|| ESTM05->FORNECEDOR }, "ESTM05->FORNECEDOR" ) )

W_TELA := savescreen(,,,,)
pedm_tela16()

select ESTM05

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

W_TEL16 := savescreen(,,,,)

do while CONTINUA .and. ( (TEC:=tabmov(TABELA)) != K_ESC )

   setcursor(1)

   setcolor( W_CORGET )
   do case

      case lastkey() = K_F5
         if ! empty( ESTM05->PEDIDO )
            pedm_exclui16()
            restscreen(,,,,W_TEL16)
            tabela:refreshall()
         end

      case lastkey() = K_F6
         if ! empty( ESTM05->PEDIDO )
            pedm_consulta16()
            tabela:refreshall()
         end


   endcase
   setcolor( W_COREDIT )
   select ESTM05
enddo

restscreen(,,,,W_TEL16)
dbcloseall()

return

/*
-------------------------------------------------------------------------------
                           pedm_CONSULTA16
-------------------------------------------------------------------------------
*/
Function pedm_consulta16()
local W_OLDSCR := savescreen()

pedm_atrib16()
pedm_tedit16()
pedm_show16()
X_PEDIDO := ESTM05->PEDIDO
itemm_edit16("CONSULTA")

return

/*
-------------------------------------------------------------------------------
                           pedm_EXCLUI16
-------------------------------------------------------------------------------
*/
Function pedm_exclui16()
local W_OLDSCR := savescreen()
if pergunta('Confirma Exclusao (S/N) ?')
   if pergunta('Confirma Exclus„o Total do Pedido (S/N) ?')
      itemm_zap16( ESTM05->PEDIDO )
      while ESTM05->( ! rlock() ); end
      ESTM05->( dbdelete() )
      ESTM05->( dbunlock() )
      ESTM05->( dbgotop())
   end
end
select ESTM05
return

/*
-------------------------------------------------------------------------------
                           pedm_ZERA16
-------------------------------------------------------------------------------
*/
procedure pedm_zera16()

X_FORNECEDOR := space(03)
X_DTPEDIDO   := date() // ctod( '  /  /  ' )
X_DTPED_R    := ctod( '  /  /  ' )
X_STATUS     := space(1)
X_QTD_ITENS  := 0.00
X_COND_PGTO  := space(20)
X_CONTATO    := space(58)
return

/*
-------------------------------------------------------------------------------
                           pedm_ATRIB16
-------------------------------------------------------------------------------
*/
procedure pedm_atrib16()

X_FORNECEDOR  := ESTM05->FORNECEDOR
X_DTPEDIDO    := ESTM05->DTPEDIDO
X_DTPED_R     := ESTM05->R_DTPED
X_STATUS      := ESTM05->STATUS
X_QTD_ITENS   := ESTM05->QTD_ITENS
X_COND_PGTO   := ESTM05->COND_PGTO
X_CONTATO     := ESTM05->CONTATO
return

/*
-------------------------------------------------------------------------------
                           pedm_SHOW16
-------------------------------------------------------------------------------
*/
procedure pedm_show16()

@ 03,16 say ESTM05->PEDIDO
@ 03,45 say ESTM05->FORNECEDOR
@ 04,16 say ESTM05->DTPEDIDO
@ 04,68 say ESTM05->QTDITPEND picture '999'
@ 05,68 say ESTM05->R_DTPED
@ 05,21 say ESTM05->COND_PGTO
@ 06,18 say ESTM05->CONTATO
return

/*
-------------------------------------------------------------------------------
                           pedm_TEDIT16
-------------------------------------------------------------------------------
*/
procedure pedm_tedit16()

   @ 02,02 say 'ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿'
   @ 03,02 say '³  N£mero ..:                Fornecedor .:     -                           ³'
   @ 04,02 say '³  Data ....:                                                              ³'
   @ 05,02 say '³  Condi‡”es pgto.:                                  Fechamento :          ³'
   @ 06,02 say '³  Contato/obs:                                                            ³'
   @ 07,02 say 'ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ'
   @ 08,02 say '                                                                            '
   @ 09,02 say '                                                                            '
   @ 10,02 say '                                                                            '
   @ 11,02 say '                                                                            '
   @ 12,02 say '                                                                            '
   @ 13,02 say '                                                                            '
   @ 14,02 say '                                                                            '
   @ 15,02 say '                                                                            '
   @ 16,02 say '                                                                            '
   @ 17,02 say '                                                                            '
   @ 18,02 say '                                                                            '
   @ 19,02 say '                                                                            '
   @ 20,02 say '                                                                            '
   @ 21,02 say '                                                                            '
   @ 22,02 say '                                                                            '
return

/*
-------------------------------------------------------------------------------
                           pedm_TELA16
-------------------------------------------------------------------------------
*/
procedure pedm_tela16()

   @ 02,02 say 'ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿'
   @ 03,02 say '³                      Arquivo Morto - Pedidos de Compra                   ³'
   @ 04,02 say 'ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ'
   @ 05,02 say '                                                                            '
   @ 06,02 say '                                                                            '
   @ 07,02 say '                                                                            '
   @ 08,02 say '                                                                            '
   @ 09,02 say '                                                                            '
   @ 10,02 say '                                                                            '
   @ 11,02 say '                                                                            '
   @ 12,02 say '                                                                            '
   @ 13,02 say '                                                                            '
   @ 14,02 say '                                                                            '
   @ 15,02 say '                                                                            '
   @ 16,02 say '                                                                            '
   @ 17,02 say '                                                                            '
   @ 18,02 say '                                                                            '
   @ 19,02 say 'ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿'
   @ 20,02 say '³  <F5> Exclui  ³               ³               ³                          ³'
   @ 21,02 say '³  <F6> Consulta³               ³               ³                          ³'
   @ 22,02 say 'ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ'

return

/*
-------------------------------------------------------------------------------
                           itemm_zap16
-------------------------------------------------------------------------------
*/
function itemm_zap16( P_PEDIDO )
local WRET := .T.
      select ESTM06
      ESTM06->( dbsetorder(1) )
      ESTM06->( dbgotop() )
      ESTM06->( dbseek( P_PEDIDO ))
      if ESTM06->( found() )
         while ESTM06->( ! eof() ) .and. ESTM06->PEDIDO=P_PEDIDO
            while ESTM06->( ! rlock() ); end
            ESTM06->( dbdelete() )
            ESTM06->( dbskip()   )
            ESTM06->( dbunlock() )
         end
      end

return WRET
