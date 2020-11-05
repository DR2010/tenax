/*
   VENDAS
   VEN0361.PRG - Item de Separacao (pedido)
*/

#include "inkey.ch"

/*
-------------------------------------------------------------------------------
                           P361_EDIT
-------------------------------------------------------------------------------
*/
function P361_EDIT()
local WRET := .T.
// Tbrowse

private  W_FILE      := {}
private  CAMPO       := {}
private  MASCARA     := {}
private  CABECALHO   := {}
private  TAMANHO     := {}
private  BESCAPE     := {|| VEN006->PEDVEN = X_PEDVEN}
private  COR         := W_COREDIT
private  TITULO      := " Itens de Separacao ( Pedido )"
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

aadd( MASCARA   , "999"         )
aadd( MASCARA   , "99999"       )
aadd( MASCARA   , "9999.999"    )
aadd( MASCARA   , "9999.999"    )
aadd( MASCARA   , "9999.999"    )
aadd( MASCARA   , "9999"        )
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
         P361_marca()
         tabela:refreshall()

   endcase

   setcolor( W_COREDIT )
   select VEN003
enddo

restscreen(,,,,W_TEL21)

return WRET


/*
-------------------------------------------------------------------------------
                           P361_MARCA
-------------------------------------------------------------------------------
*/
procedure P361_marca( P_MODO )

   while VEN006->( ! rlock() ); end

   if empty( VEN006->USUARIO )
      if VEN006Z->SEPARADO = 'S'
         mensbeep( "Item ja separado. ENTER" )
      else
         VEN006->USUARIO := P_ACESSO
      end
   else
      VEN006->USUARIO := space(30)
   end
   VEN006->( dbunlock() )

return


/*
-------------------------------------------------------------------------------
                           P361_ALTERA
-------------------------------------------------------------------------------
*/
function P361_altera()

local W_OLDSCR := savescreen()

P361_atrib()
P361_tela()
P361_show()

get_mainkey(2)
clear gets

tes_formato( 09, 16, 20 )
tes_tipo(2)
tes_estado(2)

W_CHAVE_ITEM := ( X_FORMA+ X_TIPO+ ;
             str( X_BIT_MM, 8, 3 ) + str( X_ESP_MM, 8, 3 ) + X_ESTADO )

posic_est_consulta( W_CHAVE_ITEM )

if P361_get()
   P361_grava("A")
end

return

/*
-------------------------------------------------------------------------------
                           P361_ZERA
-------------------------------------------------------------------------------
*/
procedure P361_zera()

   X_FORMA      := space(03)
   X_TIPO       := space(05)
   X_ESTADO     := space(01)
   X_BIT_MM     := 0.00
   X_ESP_MM     := 0.00
   X_BIT_INT    := space(02)
   X_BIT_FN     := space(02)
   X_BIT_FD     := space(02)
   X_ESP_INT    := space(02)
   X_ESP_FN     := space(02)
   X_ESP_FD     := space(02)

   X_COMPRIM    := 0.00
   X_LARGURA    := 0.00
   X_QTD_PECAS  := 0
   X_PESO_TEO   := 0.00
   X_COM_VEND   := 0.00
   X_COM_COMP   := 0.00
   X_PER_ACRES  := 0.00
   X_TIPO_SEP   := space(01)
   X_PESO_BALAN := 0.0
   X_DT_PEDIDO  := date()
   X_DT_VALID   := ctod( '  /  /  ' )
   X_DT_EMISSAO := ctod( '  /  /  ' )
   X_DT_SEPARA  := ctod( '  /  /  ' )
   X_SEQ_SEPARA := 0
   X_PESO_COBRA := 0.00
   X_PRECO      := 0
   X_NOTAFISCAL := space(10)
   X_CONSULTA   := space(06)
   X_UNIDADE    := 'K'

return

/*
-------------------------------------------------------------------------------
                           P361_GRAVA
-------------------------------------------------------------------------------
*/
procedure P361_grava( P_MODO )

   VEN005->( dbsetorder(1) )
   VEN005->( dbseek(X_PEDVEN) )
   if VEN005->( ! found() )
      message('Erro grave - Header Inexistente ')
      return := .F.
   end

   if P_MODO = "I"
      W_VALOR := VEN005->VALOR + X_PRECO
      W_QTD   := VEN005->QTD_ITENS + 1
   else
      W_VALOR := VEN005->VALOR - VEN006->PRECO + X_PRECO
   end


   if P_MODO = "I"  // Inclusao
      X_SEQUENC := 1
      VEN006->( dbappend())
   else
      X_SEQUENC := v_nova_sequencia( X_PEDVEN )
      while VEN006->( ! rlock() ); end
   end

   VEN006->PEDVEN     := X_PEDVEN
   VEN006->SEQUENC    := X_SEQUENC
   VEN006->FORMA      := X_FORMA
   VEN006->TIPO       := X_TIPO
   VEN006->ESTADO     := X_ESTADO
   VEN006->BIT_MM     := X_BIT_MM
   VEN006->ESP_MM     := X_ESP_MM
   VEN006->BIT_INT    := X_BIT_INT
   VEN006->BIT_FN     := X_BIT_FN
   VEN006->BIT_FD     := X_BIT_FD
   VEN006->ESP_INT    := X_ESP_INT
   VEN006->ESP_FN     := X_ESP_FN
   VEN006->ESP_FD     := X_ESP_FD

   VEN006->COMPRIM    := X_COMPRIM
   VEN006->LARGURA    := X_LARGURA
   VEN006->QTD_PECAS  := X_QTD_PECAS
   VEN006->PESO_TEO   := X_PESO_TEO
   VEN006->COM_VEND   := X_COM_VEND
   VEN006->COM_COMP   := X_COM_COMP
   VEN006->PER_ACRES  := X_PER_ACRES
   VEN006->TIPO_SEP   := X_TIPO_SEP
   VEN006->PESO_BALAN := X_PESO_BALAN
   VEN006->DT_PEDIDO  := date()
   VEN006->DT_VALID   := X_DT_VALID
   VEN006->DT_EMISSAO := X_DT_EMISSAO
   VEN006->DT_SEPARA  := X_DT_SEPARA
   VEN006->SEQ_SEPARA := X_SEQ_SEPARA
   VEN006->PESO_COBRA := X_PESO_COBRA
   VEN006->PRECO      := X_PRECO
   VEN006->NOTAFISCAL := X_NOTAFISCAL
   VEN006->CONSULTA   := X_CONSULTA
   VEN006->UNIDADE    := X_UNIDADE

   VEN005->VALOR    := W_VALOR
   VEN005->QTD_ITENS:= W_QTD

return

/*
-------------------------------------------------------------------------------
                           P361_ATRIB
-------------------------------------------------------------------------------
*/
procedure P361_atrib()

   X_PEDVEN     := VEN006->PEDVEN
   X_SEQUENC    := VEN006->SEQUENC
   X_FORMA      := VEN006->FORMA
   X_TIPO       := VEN006->TIPO
   X_ESTADO     := VEN006->ESTADO
   X_BIT_MM     := VEN006->BIT_MM
   X_ESP_MM     := VEN006->ESP_MM
   X_BIT_INT    := VEN006->BIT_INT
   X_BIT_FN     := VEN006->BIT_FN
   X_BIT_FD     := VEN006->BIT_FD
   X_ESP_INT    := VEN006->ESP_INT
   X_ESP_FN     := VEN006->ESP_FN
   X_ESP_FD     := VEN006->ESP_FD

   X_COMPRIM    := VEN006->COMPRIM
   X_LARGURA    := VEN006->LARGURA
   X_QTD_PECAS  := VEN006->QTD_PECAS
   X_PESO_TEO   := VEN006->PESO_TEO
   X_COM_VEND   := VEN006->COM_VEND
   X_COM_COMP   := VEN006->COM_COMP
   X_PER_ACRES  := VEN006->PER_ACRES
   X_TIPO_SEP   := VEN006->TIPO_SEP
   X_PESO_BALAN := VEN006->PESO_BALAN
   X_DT_PEDIDO  := VEN006->DT_PEDIDO
   X_DT_VALID   := VEN006->DT_VALID
   X_DT_EMISSAO := VEN006->DT_EMISSAO
   X_DT_SEPARA  := VEN006->DT_SEPARA
   X_SEQ_SEPARA := VEN006->SEQ_SEPARA
   X_PESO_COBRA := VEN006->PESO_COBRA
   X_PRECO      := VEN006->PRECO
   X_NOTAFISCAL := VEN006->NOTAFISCAL
   X_CONSULTA   := VEN006->CONSULTA
   X_UNIDADE    := VEN006->UNIDADE

return

/*
-------------------------------------------------------------------------------
                           P361_SHOW
-------------------------------------------------------------------------------
*/
procedure P361_show()

get_mainkey(2)
clear gets

W_CHAVE_ITEM := ( X_FORMA+ X_TIPO+ ;
             str( X_BIT_MM, 8, 3 ) + str( X_ESP_MM, 8, 3 ) + X_ESTADO )

posic_est_consulta( W_CHAVE_ITEM )

@ 15,27 say VEN006->UNIDADE
@ 16,27 say VEN006->LARGURA    picture "999999.99"
@ 17,27 say VEN006->COMPRIM    picture "999999.99"
@ 18,27 say VEN006->PESO_TEO   picture "@E 999,999.99"
@ 19,27 say VEN006->QTD_PECAS  picture "@E 99"
@ 20,27 say VEN006->DT_PEDIDO

@ 16,62 say VEN006->DT_VALID
@ 18,62 say VEN006->COM_VEND   picture "999999.99"
@ 19,62 say VEN006->COM_COMP   picture "999999.99"
@ 21,62 say VEN006->PRECO      picture "@E 999,999,999.99"

return

/*
-------------------------------------------------------------------------------
                           P361_GET
-------------------------------------------------------------------------------
*/
procedure P361_get

local WRET := .F.

set key K_F1 to help
set key K_F7 to tela_peca_cort
set key K_F8 to tela_ped_compra

begin sequence

   @ 15,27 get X_UNIDADE picture "!" valid X_UNIDADE $ "KMP"
   read

   if lastkey()=K_ESC
      WRET := .F.
      break
   end

   do case
      case X_UNIDADE = "K" // Kg
         X_QTD_PECAS := 0
         X_COMPRIM   := 0
         X_LARGURA   := 0
         @ 18,27 get X_PESO_TEO   picture "@E 999,999.99"     valid X_PESO_TEO  > 0
         @ 16,27 say X_LARGURA    picture "999999.99"
         @ 17,27 say X_COMPRIM    picture "999999.99"
         @ 19,27 say X_QTD_PECAS  picture "@E 99"

      case X_UNIDADE = "M" // Metro
         X_QTD_PECAS := 0
         @ 16,27 get X_LARGURA    picture "999999.99"       valid X_LARGURA   > 0
         @ 17,27 get X_COMPRIM    picture "999999.99"
         @ 19,27 say X_QTD_PECAS  picture "@E 99"

      case X_UNIDADE = "P" // Pecas
         X_COMPRIM   := 0
         X_LARGURA   := 0
         @ 19,27 get X_QTD_PECAS  picture "@E 99"             valid X_QTD_PECAS > 0
         @ 16,27 say X_LARGURA    picture "999999.99"
         @ 17,27 say X_COMPRIM    picture "999999.99"

   endcase

   read

   if lastkey() = K_ESC
      WRET := .F.
      break
   end

   if ! ( EST007->( dbseek( W_CHAVE_ITEM ) ))
      message('Material Inexistente em Estoque')
      WRET := .F.
      break
   end

   do case
      case X_UNIDADE = "K"
           X_PESO_TEO  := X_PESO_TEO

      case X_UNIDADE = "M"
           X_PESO_TEO  := X_COMPRIM * EST007->PES_MTR

      case X_UNIDADE = "P"
           X_PESO_TEO  := X_QTD_PECAS * EST007->TAM_INT * EST007->PES_MTR

   endcase

   VEN013->(dbsetorder(1))

   if ! (VEN013->( dbseek( W_CHAVE_ITEM ) ))
      message('Tabela de Precos Inexistente p/ Material')
      WRET := .F.
      break
   end

   while VEN013->FORMA           +;
         VEN013->TIPO            +;
         str(VEN013->BIT_MM,8,3) +;
         str(VEN013->ESP_MM,8,3) +;
         VEN013->ESTADO          = W_CHAVE_ITEM

      if X_PESO_TEO >= VEN013->MINIMO .AND. X_PESO_TEO < VEN013->MAXIMO
         W_PRECO_TAB := VEN013->VALOR
         exit
      end

      VEN013->( dbskip() )
   end

   // Calcula comissao do vendedor
   // -------------------------------

   X_COM_VEND := W_PRECO_TAB * 0.03

   X_DT_PEDIDO := date()

   @ 20,27 say X_DT_PEDIDO
   @ 16,62 get X_DT_VALID    picture "  /   /  "
   @ 17,62 get W_PRECO_TAB   picture "@E 999,999,999.99" valid W_PRECO_TAB > 0
   @ 18,27 say X_PESO_TEO    picture "@E 999,999.99"
   @ 18,62 get X_COM_COMP    picture "999999.99"
   @ 19,62 get X_COM_VEND    picture "999999.99"
   read

   if lastkey() = K_ESC
      WRET := .F.
      break
   end

   // Calcula e sugere preco de venda
   // -------------------------------

   X_PRECO := W_PRECO_TAB * X_PESO_TEO

   @ 21,62 SAY X_PRECO       picture "@E 99999,999.99"
   @ 21,62 get X_PRECO       picture "@E 999,999,999.99"  valid X_PRECO > 0
   read

   if lastkey()=K_ESC
       WRET := .F.
       break
   end
   if pergunta('Confirma Operacao ?')
      WRET := .T.
      break
   end

end sequence

set key K_F1 to
set key K_F7 to
set key K_F8 to


return WRET

/*
-------------------------------------------------------------------------------
                           P361_BROW()
-------------------------------------------------------------------------------
*/
procedure P361_brow()

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
   @ 19,02 say 'ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄ´'
   @ 20,02 say '³  <F3> Inclui  ³  <F4> Altera  ³ <F5> Exclui   ³  <ESC> Retorna  ³        ³'
   @ 21,02 say '³               ³               ³               ³                 ³        ³'
   @ 22,02 say 'ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÙ'

return

/*
-------------------------------------------------------------------------------
                           P361_TELA
-------------------------------------------------------------------------------
*/
procedure P361_tela()


   @ 07,02 say 'ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´'
   @ 08,02 say '³                                                                          ³'
   @ 09,02 say '³  Forma    :       -                                                      ³'
   @ 10,02 say '³  Tipo     :       -                                                      ³'
   @ 11,02 say '³  Estado   :       -                                                      ³'
   @ 12,02 say '³  Bit./Esp.:      /                                                       ³'
   @ 13,02 say '³  Bit./Larg:      /                                                       ³'
   @ 14,02 say 'ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´'
   @ 15,02 say '³  Unidade : K-M-P ... :             ³                                     ³'
   @ 16,02 say '³  Largura (mm)....... :             ³ Data Validade.......:               ³'
   @ 17,02 say '³  Comprimento (mm)... :             ³ Pre‡o de Tabela ....:               ³'
   @ 18,02 say '³  Peso Te¢rico(Kg)... :             ³ Comiss„o Comprador .:               ³'
   @ 19,02 say '³  Qtde de Pe‡as ..... :             ³ Comiss„o Vendedor ..:               ³'
   @ 20,02 say '³  Data Pedido ....... :             ³                                     ³'
   @ 21,02 say '³                                    ³ Valor Total do Item :               ³'
   @ 22,02 say 'ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ'

return

