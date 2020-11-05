/*
EEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEE
EEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEE
-------------------------------------------------------------------------------
   Vendas
   VEN032.prg - NAO UTILIZAR
-------------------------------------------------------------------------------
EEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEE
EEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEE
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
abrir("VEN099")

setcolor(W_COREDIT)
status(' P e d i d o ')

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
            X_UNIDADE    := 'K'

private  W_COMISVEN  := 0
private  W_DESCMAX   := 0

private W_CHAVE_ITEM

TELA := wsave(01,02,19,68)

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

// Tbrowse

private  W_FILE      := {}
private  CAMPO       := {}
private  MASCARA     := {}
private  CABECALHO   := {}
private  TAMANHO     := {}
private  BESCAPE     := {|| .T. }
private  COR         := W_COREDIT
private  TITULO      := " Pedido de Venda "
private  LININI      := 02
private  LINFIM      := 22
private  COLINI      := 02
private  COLFIM      := 77
private  BLOCK_DISP  := {|| .T. }
private  CAB_TITULO  := nil
private  BORDA       := 1

private  TECLA       := nil
private  TABELA      := nil

VEN001->( dbsetorder(1) )
VEN005->( dbsetorder(1) )

VEN005->( dbsetrelation( "VEN001", {|| VEN005->CODCLI } ) )

aadd( CAMPO     , "PEDVEN"    )
aadd( CAMPO     , "DT_PEDIDO" )
aadd( CAMPO     , "CODCLI"    )
aadd( CAMPO     , "RAZAO"     )
aadd( CAMPO     , "COMPRADOR" )
aadd( CAMPO     , "CODVEN"    )
aadd( CAMPO     , "VALOR"     )

aadd( MASCARA   , "XXXXXX"               )
aadd( MASCARA   , "@E 99/99/99"          )
aadd( MASCARA   , "XXXXX"                )
aadd( MASCARA   , "XXXXXXXXXXXXXXXXXXXX" )
aadd( MASCARA   , "XXXXXXXXXXXX"         )
aadd( MASCARA   , "99"          )
aadd( MASCARA   , "999999.99"   )

aadd( CABECALHO , "Pedido"       )
aadd( CABECALHO , "Data"         )
aadd( CABECALHO , "Cliente"      )
aadd( CABECALHO , "Razao Social" )
aadd( CABECALHO , "Comprador"    )
aadd( CABECALHO , "Vendedor"     )
aadd( CABECALHO , "Valor"        )

aadd( TAMANHO   , 06 )
aadd( TAMANHO   , 08 )
aadd( TAMANHO   , 06 )
aadd( TAMANHO   , 20 )
aadd( TAMANHO   , 12 )
aadd( TAMANHO   , 03 )
aadd( TAMANHO   , 10 )

aadd( W_FILE , "VEN005" )
aadd( W_FILE , "VEN005" )
aadd( W_FILE , "VEN005" )
aadd( W_FILE , "VEN001" )
aadd( W_FILE , "VEN005" )
aadd( W_FILE , "VEN005" )
aadd( W_FILE , "VEN005" )

W_TELA := savescreen(,,,,)

P32_tela()

select VEN005
VEN005->( dbsetorder(1) )
VEN005->( dbgotop() )

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
while .t.


   CONTINUA := .T.

   W_TEL21 := savescreen(,,,,)

   do while CONTINUA .and. ( (TEC:=tabmov(TABELA)) != K_ESC )

      X_CODCLI   := VEN005->CODCLI
      setcursor(1)

      setcolor( W_CORGET )
      do case

         case lastkey() = K_F1
            mensboxv( { " <F3> Incluir ",;
                        " <F4> Alterar ",;
                        " <F5> Excluir "})

         case lastkey() = K_F3
            
            P32_inclui()
            tabela:refreshall()

         case lastkey() = K_F4
            P32_altera()
            tabela:refreshall()

         case lastkey() = K_F5
            P32_exclui()
            tabela:refreshall()

      endcase

      setcolor( W_COREDIT )
      select VEN005
 enddo

   restscreen(,,,,W_TELA)

   dbcloseall()
   exit
end

return

/*
-------------------------------------------------------------------------------
                           P32_INCLUI
-------------------------------------------------------------------------------
*/
Function P32_inclui()
local W_OLDSCR := savescreen()

P32_zera()
P32_tedit()

VEN005->( dbsetorder(1) )
X_PEDVEN := VEN005->( gera_consulta( "VEN005->PEDVEN" ) )
@ 03,16 get X_PEDVEN picture "@!" valid ! v_acha_pedido( X_PEDVEN )
read

if lastkey() # K_ESC
   VEN005->( dbsetorder(1))
   VEN005->( dbseek( X_PEDVEN ))

   if VEN005->( ! found() )
      if P32_get()
         P32_grava("I") // inclui header
         P33_edit("Altera")
      end
   else
      message('Pedido Ja Cadastrado. <ENTER>')
   end
end
restscreen(,,,,w_oldscr)
return

/*
-------------------------------------------------------------------------------
                           P32_ALTERA
-------------------------------------------------------------------------------
*/
Function P32_altera()
local W_OLDSCR := savescreen()

P32_atrib()
P32_tedit()
P32_show()

X_PEDVEN := VEN005->PEDVEN
if P32_get()
   P32_grava("A")
   P33_edit("Altera")
end
restscreen(,,,,w_oldscr)
return

/*
-------------------------------------------------------------------------------
                           P32_CONSULTA
-------------------------------------------------------------------------------
*/
Function P32_consulta()
local W_OLDSCR := savescreen()

P32_atrib()
P32_tedit()
P33_edit("Consulta")
restscreen(,,,,w_oldscr)
return

/*
-------------------------------------------------------------------------------
                           P32_EXCLUI
-------------------------------------------------------------------------------
*/
Function P32_exclui()
local W_OLDSCR := savescreen()

if conf(' Confirma Exclusao ')
   P33_zap( VEN005->PEDVEN )
   while VEN005->( ! rlock() ); end
   VEN005->( dbdelete() )
   VEN005->( dbgotop())
end

select VEN005
restscreen(,,,,w_oldscr)
return

/*
-------------------------------------------------------------------------------
                           P32_ZERA
-------------------------------------------------------------------------------
*/
procedure P32_zera()

 X_CODCLI     := space(05)
 X_COMPRADOR  := space(20)
 X_DT_PEDIDO  := ctod( '  /  /  ' )

return

/*
-------------------------------------------------------------------------------
                           P32_GRAVA
-------------------------------------------------------------------------------
*/
procedure P32_grava( P_MODO )

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
                           P32_ATRIB
-------------------------------------------------------------------------------
*/
procedure P32_atrib()

X_CODCLI     :=  VEN005->CODCLI
X_COMPRADOR  :=  VEN005->COMPRADOR
X_DT_PEDIDO  :=  VEN005->DT_PEDIDO

return

/*
-------------------------------------------------------------------------------
                           P32_SHOW
-------------------------------------------------------------------------------
*/
procedure P32_show()

@ 03,16 say VEN005->PEDVEN
@ 03,42 say VEN005->CODCLI
@ 05,42 say VEN005->DT_PEDIDO

return

/*
-------------------------------------------------------------------------------
                           P32_GET
-------------------------------------------------------------------------------
*/
function P32_get()
local WRET := .T.

@ 03,42 get X_CODCLI valid tes_codcli( X_CODCLI, 03, 42, 26)
@ 05,42 get X_DT_PEDIDO
read

if lastkey()=K_ESC; WRET := .F.; end

return  WRET

/*
-------------------------------------------------------------------------------
                           P32_TEDIT
-------------------------------------------------------------------------------
*/
procedure P32_tedit()

   @ 02,02 say 'ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿'
   @ 03,02 say '³  N£mero ..:                Cliente  :                                    ³'
   @ 04,02 say '³                                                                          ³'
   @ 05,02 say '³                            Data     :                                    ³'
   @ 06,02 say 'ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ'
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
   @ 19,02 say '                                                                            '
   @ 20,02 say '                                                                            '
   @ 21,02 say '                                                                            '
   @ 22,02 say '                                                                            '

return

/*
-------------------------------------------------------------------------------
                           P32_TELA
-------------------------------------------------------------------------------
*/
procedure P32_tela()

   @ 02,02 say 'ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿'
   @ 03,02 say '³                                                                          ³'
   @ 04,02 say '³                                                                          ³'
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



