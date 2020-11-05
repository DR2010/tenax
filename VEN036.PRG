/*
-------------------------------------------------------------------------------
   Vendas
   VEN036.prg - Separacao
-------------------------------------------------------------------------------
*/
#include "inkey.ch"
Local Tela

abrir("EST002")
abrir("EST003")
abrir("EST004")
abrir("EST006")
abrir("EST007")
abrir("VEN001")
abrir("VEN002")
abrir("VEN005")
abrir("VEN006")
abrir("VEN016") // Header Separacao
abrir("VEN099")

setcolor(W_COREDIT)
status(' S e p a r a c a o ')

// VARIAVEIS

W_SEQ_PED  := 0

X_PEDVEN   := SPACE(05)

// --> VEN005 -> Header do Pedido
private  X_CODCLI     := space(05)          ,;
         X_COMPRADOR  := space(20)          ,;
         X_DT_PEDIDO  := ctod( '  /  /  ' )

// --> VEN006 -> detalhe do Pedido
private     X_SEQUENC    := 0                  ,;
            X_COMPRIM    := 0.00               ,;
            X_LARGURA    := 0.00               ,;
            X_PESO_TEO   := 0.00               ,;
            X_COM_VEND   := 0.00               ,;
            X_COM_COMP   := 0.00               ,;
            X_PER_ACRES  := 0.00               ,;
            X_TIPO_SEP   := space(01)          ,;
            X_PESO_BALAN := 0.0                ,;
            X_DT_PEDIDO  := ctod( '  /  /  ' ) ,;
            X_DT_EMISSAO := ctod( '  /  /  ' ) ,;
            X_DT_SEPARA  := ctod( '  /  /  ' ) ,;
            X_SEQ_SEPARA := 0                  ,;
            X_PESO_COBRA := 0.00               ,;
            X_PRECO      := 0                  ,;
            X_NOTAFISCAL := space(10)          ,;
            X_CONSULTA   := space(08)          ,;
            X_CODVEN     := space(02)          ,;
            X_COMPRADOR  := space(20)

private W_CHAVE_ITEM

TELA := wsave(01,02,19,68)

//
//  Tbrowse
//

private  W_FILE      := {}
private  CAMPO       := {}
private  MASCARA     := {}
private  CABECALHO   := {}
private  TAMANHO     := {}
private  BESCAPE     := {|| .t. }
private  COR         := W_COREDIT
private  TITULO      := " Separacao "
private  LININI      := 08
private  LINFIM      := 03
private  COLINI      := 18
private  COLFIM      := 76
private  BLOCK_DISP  := {|| .T. }
private  CAB_TITULO  := nil
private  BORDA       := 1

private  TECLA       := nil
private  TABELA      := nil

aadd( CAMPO     , "FORMA"     )
aadd( CAMPO     , "TIPO"      )
aadd( CAMPO     , "BIT_MM"    )
aadd( CAMPO     , "ESP_MM"    )
aadd( CAMPO     , "LARGURA"   )
aadd( CAMPO     , "QTD_PECAS" )
aadd( CAMPO     , "PRECO"     )
aadd( CAMPO     , "UNIDADE"   )
aadd( CAMPO     , "SEPARADO"  )
aadd( CAMPO     , "USUARIO"   )

aadd( MASCARA   , "XXX"         )
aadd( MASCARA   , "XXXXX"       )
aadd( MASCARA   , "9999.999"    )
aadd( MASCARA   , "9999.999"    )
aadd( MASCARA   , "9999.999"    )
aadd( MASCARA   , "99"          )
aadd( MASCARA   , "999999.99"   )
aadd( MASCARA   , "XX"          )
aadd( MASCARA   , "X"           )
aadd( MASCARA   , "X"           )

aadd( CABECALHO , "Forma"     )
aadd( CABECALHO , "Tipo"      )
aadd( CABECALHO , "Bit MM"    )
aadd( CABECALHO , "Esp MM"    )
aadd( CABECALHO , "Largura"   )
aadd( CABECALHO , "Qtd"       )
aadd( CABECALHO , "Preco"     )
aadd( CABECALHO , "U"         )
aadd( CABECALHO , "S"         )
aadd( CABECALHO , "*"         )

aadd( TAMANHO   , 03 )
aadd( TAMANHO   , 05 )
aadd( TAMANHO   , 08 )
aadd( TAMANHO   , 08 )
aadd( TAMANHO   , 08 )
aadd( TAMANHO   , 04 )
aadd( TAMANHO   , 10 )
aadd( TAMANHO   , 02 )
aadd( TAMANHO   , 01 )
aadd( TAMANHO   , 01 )

aadd( W_FILE , "VEN006" )
aadd( W_FILE , "VEN006" )
aadd( W_FILE , "VEN006" )
aadd( W_FILE , "VEN006" )
aadd( W_FILE , "VEN006" )
aadd( W_FILE , "VEN006" )
aadd( W_FILE , "VEN006" )
aadd( W_FILE , "VEN006" )
aadd( W_FILE , "VEN006" )

select VEN006
VEN006->( dbsetorder(1) )
VEN006->( dbseek( X_PEDVEN ) )

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

W_TEL21 := savescreen(,,,,)

do while CONTINUA .and. ( (TEC:=tabmov(TABELA)) != K_ESC )

   X_CODCLI   := VEN003->CODCLI
   X_CONSULTA := VEN003->CONSULTA
   setcursor(1)

   setcolor( W_CORGET )
   do case
      case TEC == 28 ; help() ; return 1
      case TEC == 27 ; return 0

      case lastkey() = K_F3
         P33_inclui()
         tabela:refreshall()

      case lastkey() = K_F4
         P33_altera()
         tabela:refreshall()

      case lastkey() = K_F5
         P33_exclui()
         tabela:refreshall()
         WRET := 2

      case lastkey() = K_F6
         P33_marca()
         tabela:refreshall()

      case lastkey() = K_ESC
         WRET := 0

   endcase

   setcolor( W_COREDIT )
   select VEN003
enddo

restscreen(,,,,W_TEL21)

return WRET




//
// variaveis DBEDIT
//

P_HDSEP := "ËÍ"
P_COLSEP := "-"
P_HEADER := {"Pedido  Data     Cliente                    Comprador    Vendedor      Valor"}
//            XXXXXX  XXXXXXXX XXXXX XXXXXXXXXXXXXXXXXXXX XXXXXXXXXXXXXXX 99 999999,999.99

VEN001->( dbsetorder(1) )
VEN005->( dbsetorder(1) )

VEN005->( dbsetrelation( "VEN001", {|| VEN005->CODCLI } ) )
P_CAMPOS := {"VEN005->PEDVEN +space(2)+dtoc(VEN005->DT_PEDIDO)+space(1) +"+;
             "VEN005->CODCLI + space(1)+left(VEN001->RAZAO,20)+' '+" +;
             "left(VEN005->COMPRADOR,15)+ ' ' + VEN005->CODVEN + ' '+ str(VEN005->VALOR,12,2)"}

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

   P36_tela()

   VEN005->( dbgotop() )
   VEN005->( dbedit(05,03,21,76,P_CAMPOS,"P36_FUNC",, P_HEADER, P_HDSEP, P_COLSEP))

   restscreen(,,,,W_TELA)

   dbcloseall()
   exit
end

return

//
// ----------------------------------------------------------------------------
//

/*
-------------------------------------------------------------------------------
                                P36_FUNC
-------------------------------------------------------------------------------
*/
function P36_FUNC( modo, coluna )

private WRET := 1, W_OLDSCR := savescreen(,,,,)
setcursor(1)

if modo = 4
   do case

      case lastkey() = K_F4
         p361_edit()
         WRET := 2

      case lastkey() = K_ESC
         WRET := 0
  endcase
end

restscreen(,,,,W_OLDSCR )
return WRET

/*
-------------------------------------------------------------------------------
                           P36_INCLUI
-------------------------------------------------------------------------------
*/
Function P36_inclui()
local W_OLDSCR := savescreen()

P36_zera()
P36_tedit()

VEN005->( dbsetorder(1) )
X_PEDVEN := VEN005->( gera_consulta( "VEN005->PEDVEN" ) )
@ 03,16 get X_PEDVEN picture "@!" valid ! v_acha_pedido( X_PEDVEN )
read

if lastkey() # K_ESC
   VEN005->( dbsetorder(1))
   VEN005->( dbseek( X_PEDVEN ))

   if VEN005->( ! found() )
      if P36_get()
         P36_grava("I") // inclui header
         if P361_edit("Altera")
            P361_grava()
         end
      end
   else
      message('Pedido Ja Cadastrado. <ENTER>')
   end
end

return

/*
-------------------------------------------------------------------------------
                           P36_ALTERA
-------------------------------------------------------------------------------
*/
Function P36_altera()

local W_OLDSCR := savescreen()

P36_atrib()
P36_tedit()
P36_show()

X_PEDVEN := VEN005->PEDVEN
if P36_get()
   P36_grava("A")
   if P361_edit("Altera")
      P361_grava()
   end
end

return

/*
-------------------------------------------------------------------------------
                           P36_CONSULTA
-------------------------------------------------------------------------------
*/
Function P36_consulta()
local W_OLDSCR := savescreen()

P36_atrib()
P36_tedit()
P361_edit("Consulta")

return

/*
-------------------------------------------------------------------------------
                           P36_ZERA
-------------------------------------------------------------------------------
*/
procedure P36_zera()

 X_CODCLI     := space(05)
 X_COMPRADOR  := space(20)
 X_DT_PEDIDO  := ctod( '  /  /  ' )

return

/*
-------------------------------------------------------------------------------
                           P36_GRAVA
-------------------------------------------------------------------------------
*/
procedure P36_grava( P_MODO )

if P_MODO = "I"
   VEN005->( dbappend() )
else
   while VEN005->( ! rlock() ); end
end

VEN005->PEDVEN     := X_PEDVEN
VEN005->CODCLI     := X_CODCLI
VEN005->COMPRADOR  := X_COMPRADOR
VEN005->DT_PEDIDO  := X_DT_PEDIDO

return

/*
-------------------------------------------------------------------------------
                           P36_ATRIB
-------------------------------------------------------------------------------
*/
procedure P36_atrib()

X_CODCLI     :=  VEN005->CODCLI
X_COMPRADOR  :=  VEN005->COMPRADOR
X_DT_PEDIDO  :=  VEN005->DT_PEDIDO

return

/*
-------------------------------------------------------------------------------
                           P36_SHOW
-------------------------------------------------------------------------------
*/
procedure P36_show()

@ 03,16 say VEN005->PEDVEN
@ 03,42 say VEN005->CODCLI
@ 05,42 say VEN005->DT_PEDIDO

return

/*
-------------------------------------------------------------------------------
                           P36_GET
-------------------------------------------------------------------------------
*/
function P36_get()
local WRET := .T.

@ 03,42 get X_CODCLI valid tes_codcli( X_CODCLI, 03, 42, 26)
@ 05,42 get X_DT_PEDIDO
read

if lastkey()=K_ESC; WRET := .F.; end

return  WRET

/*
-------------------------------------------------------------------------------
                           P36_TEDIT
-------------------------------------------------------------------------------
*/
procedure P36_tedit()

   @ 02,02 say 'ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿'
   @ 03,02 say '³  N£mero ..:                Cliente  :                                    ³'
   @ 04,02 say '³                                                                          ³'
   @ 05,02 say '³                            Data     :                                    ³'
   @ 06,02 say '³                                                                          ³'
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

return

/*
-------------------------------------------------------------------------------
                           P36_TELA
-------------------------------------------------------------------------------
*/
procedure P36_tela()

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
   @ 19,02 say '³                                                                          ³'
   @ 20,02 say '³                                                                          ³'
   @ 21,02 say '³                                                                          ³'
   @ 22,02 say 'ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ'

return



