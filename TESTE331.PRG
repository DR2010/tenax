/*
   VENDAS
   VEN0331.PRG - Item de Pedido
*/

#include "inkey.ch"

/*
-------------------------------------------------------------------------------
                           P331_EDIT
-------------------------------------------------------------------------------
*/
function P331_EDIT()
local WRET := .T.

// Tbrowse

private  W_FILE      := {}
private  CAMPO       := {}
private  MASCARA     := {}
private  CABECALHO   := {}
private  TAMANHO     := {}
private  BESCAPE     := {|| VEN006->PEDVEN = X_PEDVEN }
private  COR         := W_COREDIT
private  TITULO      := " Itens de Pedido "
private  LININI      := 07
private  LINFIM      := 22
private  COLINI      := 01
private  COLFIM      := 78
private  BLOCK_DISP  := {|| .T. }
private  CAB_TITULO  := nil
private  BORDA       := 1

private  TECLA       := nil
private  TABELA      := nil

aadd( CAMPO     , "FORMA" )
aadd( CAMPO     , "TIPO" )
aadd( CAMPO     , "BIT_MM" )
aadd( CAMPO     , "ESP_MM" )
aadd( CAMPO     , "ESPESSURA" )
aadd( CAMPO     , "SUBFORMA" )
aadd( CAMPO     , "LARGURA" )
aadd( CAMPO     , "COMPRIM" )
aadd( CAMPO     , "PESO_ITEM" )
aadd( CAMPO     , "QTD_PECAS" )
aadd( CAMPO     , "PRECO_UNI" )
aadd( CAMPO     , "UNIDADE" )
aadd( CAMPO     , "SEPARADO" )

aadd( MASCARA   , "XXX"          )
aadd( MASCARA   , "XXXXX"        )
aadd( MASCARA   , "9999.999"      )
aadd( MASCARA   , "9999.999"      )
aadd( MASCARA   , "999"          )
aadd( MASCARA   , "X"            )
aadd( MASCARA   , "9999"         ) // largura
aadd( MASCARA   , "99999999"     ) // comprimento
aadd( MASCARA   , "999999.9"     )
aadd( MASCARA   , "99999"        )
aadd( MASCARA   , "99999999.99" )
aadd( MASCARA   , "X"            )
aadd( MASCARA   , "X"            )


aadd( CABECALHO , "FOR" )
aadd( CABECALHO , "TIPO" )
aadd( CABECALHO , "BIT/ESP" )
aadd( CABECALHO , "BIT/LARG" )
aadd( CABECALHO , "ESPESSURA" )
aadd( CABECALHO , "S" )
aadd( CABECALHO , "LARGURA" )
aadd( CABECALHO , "COMPRIMENTO" )
aadd( CABECALHO , "PESO" )
aadd( CABECALHO , "PE€AS" )
aadd( CABECALHO , "PRE€O" )
aadd( CABECALHO , "U" )
aadd( CABECALHO , "S" )

aadd( TAMANHO   ,  3 )
aadd( TAMANHO   ,  5 )
aadd( TAMANHO   ,  8 )
aadd( TAMANHO   ,  8 ) 
aadd( TAMANHO   ,  3 )
aadd( TAMANHO   ,  1 )
aadd( TAMANHO   ,  4 ) // largura
aadd( TAMANHO   ,  8 ) // comprimento
aadd( TAMANHO   ,  8 )
aadd( TAMANHO   ,  5 )
aadd( TAMANHO   , 11 )
aadd( TAMANHO   ,  1 )
aadd( TAMANHO   ,  1 )

aadd( W_FILE   , "VEN006")
aadd( W_FILE   , "VEN006")
aadd( W_FILE   , "VEN006")
aadd( W_FILE   , "VEN006")
aadd( W_FILE   , "VEN006")
aadd( W_FILE   , "VEN006")
aadd( W_FILE   , "VEN006")
aadd( W_FILE   , "VEN006")
aadd( W_FILE   , "VEN006")
aadd( W_FILE   , "VEN006")
aadd( W_FILE   , "VEN006")
aadd( W_FILE   , "VEN006")
aadd( W_FILE   , "VEN006")

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

   setcursor(1)
   setcolor( W_CORGET )
   do case
      case lastkey() = K_F1
          mensboxv( { " <F4> Alterar ",;
                      " <F5> Excluir "})

      case lastkey() = K_F4
         P331_altera()
         tabela:refreshall()

      case lastkey() = K_F5
         P331_exclui()
         tabela:refreshall()

   endcase

   setcolor( W_COREDIT )
   select VEN006
enddo

restscreen(,,,,W_TEL21)

return WRET
/*
-------------------------------------------------------------------------------
                           ITEM_C_ALTERA21
-------------------------------------------------------------------------------
*/
function item_c_altera21()
 local W_OLDSCR := savescreen()
 item_c_atrib21()
 item_c_tela21()
 item_c_show21('A')

 get_mainkey(2)
 clear gets
 @ 15,67 say X_UNIDADE   picture "!"           

 telachapa( X_FORMA, "ALTERAR" )
 
 W_CHAVE_ITEM := ( X_FORMA+X_TIPO+ ;
             str( X_BIT_MM, 8, 3 ) + str( X_ESP_MM, 8, 3 ) + X_ESTADO )

 EST007->( dbsetorder(1) )
 EST007->( dbseek( W_CHAVE_ITEM ))
 if EST007->( found() )
   F_MATNOTFOUND := .F.
 else
    F_MATNOTFOUND := .T.
 end

 posic_est_consulta( W_CHAVE_ITEM )

 EST003->( dbseek( X_FORMA ) )
 X_PMEDCORTE := STR( EST003->P_CORTE, 1 )

 if item_c_get21("A",'t')
   item_c_grava21("A")
 end

 @ 21,00 say '³                             ³'

return

/*
-------------------------------------------------------------------------------
                           ITEM_C_CONSULTA21
-------------------------------------------------------------------------------
*/
Function item_c_consulta21()
 F_MATNOTFOUND := .f.
 item_c_atrib21()
 item_c_tela21()
 calc_peso_rel('C')
 item_c_show21('C')
 INKEY(0)
return

/*
-------------------------------------------------------------------------------
                           ITEM_C_EXCLUI21
-------------------------------------------------------------------------------
*/
Function item_c_exclui21()

local W_OLDSCR := savescreen()
 F_MATNOTFOUND := .f.
 item_c_atrib21()
 item_c_tela21()
 calc_peso_rel('C')
 item_c_show21('C')

if conf(' Confirma Exclusao ')

   VEN003->( dbsetorder(1) )
   VEN003->( dbseek(X_CONSULTA) )
   if VEN003->( ! found() )
      message('Erro grave - Header Inexistente ')
      return := .F.
   end
   W_VALOR := VEN003->VALOR - VEN004->PRECO
   W_QTD   := VEN003->QTD_ITENS - 1

   while VEN003->( ! rlock() ); end
   VEN003->VALOR    := W_VALOR
   VEN003->QTD_ITENS:= W_QTD
   VEN003->( dbunlock() )

   while VEN004->( ! rlock() ); end
   VEN004->( dbdelete() )

end
return

/*
-------------------------------------------------------------------------------
                           ITEM_C_ZERA21
-------------------------------------------------------------------------------
*/
procedure item_c_zera21()

   X_SEQUENC    := 0
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
   X_SUBFORMA   := space(01)
   X_COMPRIM    := 0.0
   X_LARGURA    := 0.0
   X_ESPESSURA  := 0.0
   X_QTD_PECAS  := 0.0
   X_PESO_TEO   := 0.0
   X_PESO_COBRA := 0.0
   X_PESO_BALAN := 0.0
   W_TOT_ITEM   := 0.0
   X_DT_VALID   := ctod('  /  /  ')
   X_UNIDADE    := 'K'
   W_PRECOTAB   := 0.0
   W_DESCONTO   := 0.00
return

/*
----------------------------------------------------------------------------------------
                           ITEM_C_GRAVA21
-------------------------------------------------------------------------------
*/
procedure item_c_grava21( P_MODO )

   VEN003->( dbsetorder(1) )
   VEN003->( dbseek( X_CONSULTA ) )

   if VEN003->( ! found() )
      message('Erro grave - Header Inexistente ')
      return := .F.
   end

   if P_MODO = "I"
      W_VALOR := VEN003->VALOR + W_TOT_ITEM
      W_QTD   := VEN003->QTD_ITENS + 1
   else
      W_VALOR := VEN003->VALOR - VEN004->PRECO + W_TOT_ITEM
   end

   if P_MODO = "I"
     X_SEQUENC := cons_nova_seq( X_CONSULTA )
     IF VEN003->STATUS = 'T'
       while VEN003->( ! rlock() ); end
       VEN003->STATUS  = 'P'
       VEN003->(DBUNLOCK())
     END
     VEN004->( dbappend())
   else
     X_SEQUENC := cons_nova_seq( X_CONSULTA )
     while VEN004->( ! rlock() ); end
   end
   VEN004->CONSULTA   := X_CONSULTA
   VEN004->SEQUENC    := X_SEQUENC
   VEN004->FORMA      := X_FORMA
   VEN004->TIPO       := X_TIPO
   VEN004->ESTADO     := X_ESTADO
   VEN004->BIT_MM     := X_BIT_MM
   VEN004->ESP_MM     := X_ESP_MM
   VEN004->BIT_INT    := X_BIT_INT
   VEN004->BIT_FN     := X_BIT_FN
   VEN004->BIT_FD     := X_BIT_FD
   VEN004->ESP_INT    := X_ESP_INT
   VEN004->ESP_FN     := X_ESP_FN
   VEN004->ESP_FD     := X_ESP_FD
   VEN004->LARGURA    := X_LARGURA
   VEN004->COMPRIM    := X_COMPRIM
   VEN004->ESPESSURA  := X_ESPESSURA
   VEN004->QTD_PECAS  := X_QTD_PECAS
   VEN004->PESO_TEO   := IF(X_PESO_TEO=0,X_PESO_ITEM,X_PESO_TEO)
   VEN004->PESO_COBRA := X_PESO_COBRA
   VEN004->PESO_BALAN := X_PESO_BALAN
   VEN004->PESO_ITEM  := X_PESO_ITEM
   VEN004->DT_VALID   := X_DT_VALID
   VEN004->UNIDADE    := X_UNIDADE
   VEN004->SEPARA     := X_SEPARA
   VEN004->SUBFORMA   := X_SUBFORMA
   VEN004->TIPOVENDA  := W_TIPOVENDA
   VEN004->DIGITACAO  := W_DIGITACAO
   VEN004->PES_MATNOT := W_PESOMTR
   VEN004->PRECOTAB   := W_PRECOTAB
   VEN004->PRECO      := W_TOT_ITEM

   VEN003->( dbsetorder(1) )
   VEN003->( dbseek( X_CONSULTA ) )
   
   while VEN003->( ! rlock() ); end
   VEN003->VALOR    := W_VALOR
   VEN003->QTD_ITENS:= W_QTD

return

/*
-------------------------------------------------------------------------------
                           ITEM_C_ATRIB21
-------------------------------------------------------------------------------
*/
procedure item_c_atrib21()

   X_CONSULTA   :=  VEN004->CONSULTA
   X_SEQUENC    :=  VEN004->SEQUENC
   X_FORMA      :=  VEN004->FORMA
   X_TIPO       :=  VEN004->TIPO
   X_ESTADO     :=  VEN004->ESTADO
   X_BIT_MM     :=  VEN004->BIT_MM
   X_ESP_MM     :=  VEN004->ESP_MM
   X_BIT_INT    :=  VEN004->BIT_INT
   X_BIT_FN     :=  VEN004->BIT_FN
   X_BIT_FD     :=  VEN004->BIT_FD
   X_ESP_INT    :=  VEN004->ESP_INT
   X_ESP_FN     :=  VEN004->ESP_FN
   X_ESP_FD     :=  VEN004->ESP_FD
   X_COMPRIM    :=  VEN004->COMPRIM
   X_LARGURA    :=  VEN004->LARGURA
   X_ESPESSURA  :=  VEN004->ESPESSURA
   X_QTD_PECAS  :=  VEN004->QTD_PECAS
   X_PESO_TEO   :=  VEN004->PESO_TEO
   X_PESO_COBRA :=  VEN004->PESO_COBRA
   X_PESO_BALAN :=  VEN004->PESO_BALAN
   X_PESO_ITEM  :=  VEN004->PESO_ITEM
   X_DT_VALID   :=  VEN004->DT_VALID
   X_UNIDADE    :=  VEN004->UNIDADE
   X_SEPARA     :=  VEN004->SEPARA
   X_SUBFORMA   :=  VEN004->SUBFORMA
   W_TIPOVENDA  :=  VEN004->TIPOVENDA
   W_DIGITACAO  :=  VEN004->DIGITACAO

   W_PRECOTAB   :=  VEN004->PRECOTAB
   W_TOT_ITEM   :=  VEN004->PRECO

return

/*
-------------------------------------------------------------------------------
                           ITEM_C_SHOW21
-------------------------------------------------------------------------------
*/
procedure item_c_show21(CONS)
   private con := if(cons=nil,'',cons)
   W_CHAVE_ITEM := ( X_FORMA+ X_TIPO+ ;
                str( X_BIT_MM, 8, 3 ) + str( X_ESP_MM, 8, 3 ) + X_ESTADO )
   get_mainkey(2)
   clear gets
   tes_formato(09,16,20)
   tes_tipo(2)
   tes_estado(2)

   
   posic_est_consulta( W_CHAVE_ITEM )

   @ 15,20 say VEN004->ESPESSURA  picture "999.99"
   @ 16,20 say VEN004->LARGURA    picture "99999999.9"
   @ 17,20 say VEN004->COMPRIM    picture "99999999.9"
   @ 18,20 say VEN004->PESO_TEO   picture "@E 999,999.99"
   @ 19,20 say VEN004->QTD_PECAS  picture "@E 99999"

   @ 21,66 say VEN004->PRECO      picture "99999.99"
   @ 21,40 say W_TOT_ITEM/X_QTD_PECAS  picture "99999.99"  // preco por peca
   
   busca_comissao('A')
return

/*
-------------------------------------------------------------------------------
                           ITEM_C_GET21
-------------------------------------------------------------------------------
*/
procedure item_c_get21( P_MODO, alt )

local WRET        := .F.
local W_PRECO_TAB := 0.00
local getlist:={}

set key K_F1 to help
set key K_F7 to tela_peca_cort
set key K_F8 to tela_ped_compra

// X_PMEDCORTE


begin sequence
   if P_MODO = 'I'
      W_DIGITACAO := 'K'
      W_PESOMTR := 0
   end

   if X_P_CORTE = 5 // medida de corte = 5- especial

      //
      //
      //

      @ 16,20 get X_LARGURA    picture "99999999.9"   when X_SUBFORMA $ "RDA"
      @ 17,20 get X_COMPRIM    picture "99999999.9"   when X_SUBFORMA $ "RA"
      @ 18,20 get X_PESO_TEO   picture "@E 999,999.99" when X_ESPESSURA = 0 ;
                                                      .AND. X_COMPRIM   = 0 ;
                                                      .AND. X_LARGURA   = 0
      @ 19,20 get X_QTD_PECAS  picture "@E 99999"      valid tes_qtdpecas()
        read
   else
      @ 15,20 get X_ESPESSURA  picture "999.99"   when X_PMEDCORTE $ "4"
      @ 16,20 get X_LARGURA    picture "99999999.9"   when X_PMEDCORTE $ "24"
      @ 17,20 get X_COMPRIM    picture "99999999.9"   when X_PMEDCORTE $ "124"
      @ 18,20 get X_PESO_TEO   picture "@E 999,999.99" when X_ESPESSURA = 0 ;
                                                      .AND. X_COMPRIM   = 0 ;
                                                      .AND. X_LARGURA   = 0
      @ 19,20 get X_QTD_PECAS  picture "@E 99999"      valid tes_qtdpecas()
      read
   end

   if lastkey()=K_ESC; break; end


   if P_MODO = 'I'
      do case
         case X_PESO_TEO > 0

            W_DIGITACAO := 'K'
            // X_LARGURA   := 0
            // X_COMPRIM   := 0
            // X_QTD_PECAS := 0

         case X_LARGURA > 0 .or. X_COMPRIM > 0

            W_DIGITACAO := 'M'
            // X_PESO_TEO  := 0

      end
   end

   EST007->( dbseek( W_CHAVE_ITEM ) )

   do case
      case W_DIGITACAO = "K"
           X_PESO_TEO  := X_PESO_TEO
           X_PESO_ITEM := X_PESO_TEO

      case W_DIGITACAO = "M"
           X_PESO_TEO  := W_PESOMTR* X_QTD_PECAS * X_COMPRIM/1000
           X_PESO_ITEM := X_PESO_TEO
   endcase


   if W_DIGITACAO = 'M'
     if P_MODO = 'I'
       calc_peso_rel('I')
     else
       calc_peso_rel()
     end
   end
   // ------------------------------------------------
   // Questao para seguir ou nao na digitacao do preco
   //------------------------------------------------

   if alt=nil
    if ! pergunta("Preco na hora (S/N) ?")
       WRET := .T.
       break
    end
  end
   
   //
   // Busca preco de venda
   //
   VEN019->( dbseek( EST007->GRUPO+EST007->SUBGRUPO+EST007->COLUNA ))

   W_PRCBASKG := VEN004->PRECOTAB
   if VEN019->( found() )
      F_PRECOEXTERNO := .F.
      W_PRECO_ORIGINAL := VEN019->PRECO
      W_PRCBASKG       := VEN019->PRECO
   else
      F_PRECOEXTERNO := .T.

      //
      // Local ideal para pedirmos o preco.
      //
      @ 19,67 get W_PRCBASKG  picture "@E 99999.99" valid W_PRCBASKG > 0
      read
      W_PRECOTAB := W_PRECO_ORIGINAL := W_PRCBASKG

      f_preco_tab( W_PRECOTAB, W_TIPOVENDA )
   end


   while .T.
      while .T.

         @ 15,67 get X_UNIDADE   picture "!"           valid f_preco_unidade( X_UNIDADE, W_COMISCOM, W_DESCONTO ) .AND. X_UNIDADE $ "KPM"
         @ 16,67 get W_COMISVEN  picture "@E 99999.99" when W_LIBERACAO
         @ 17,67 get W_COMISCOM  picture "@E 99999.99" valid f_comp_comis( X_CODCLI, W_COMISCOM, X_UNIDADE, W_DESCONTO )
         @ 18,67 get W_DESCONTO  picture "@E 99999.99" valid f_desconto()
         @ 19,67 get W_PRECOTAB  picture "@E 99999.99" valid f_preco_tab( W_PRECOTAB, W_TIPOVENDA )
         read


         // -----------------------------------
         //               Revenda
         // -----------------------------------
         // if W_TIPOVENDA = 'R'

         if F_MATNOTFOUND

            W_TOT_ITEM  := W_PRECOTAB * X_PESO_ITEM

         else

            // -----------------------------------
            //
            // Material encontrado
            //
            // -----------------------------------

            f_preco_unidade( X_UNIDADE, W_COMISCOM, W_DESCONTO )

            //-------------------------
            //  Calcula Total do Item
            //-------------------------

            do case
               case W_DIGITACAO = 'K'
                  W_TOT_ITEM := X_PESO_TEO * W_PRECOKG

               case W_DIGITACAO = 'M'

                  if X_UNIDADE = "P"
                     // Caso unidade seja pecas, multiplica-se a qtde
                     // pelo preco

                     VEN017->( dbseek( X_GRUPO ))
                     if X_COMPRIM < VEN017->COMPMINIMO
                        // Verifica se e peca curta
                        // ------------------------
                        VEN020->( dbseek( X_GRUPO + X_SUBFATOR ))
                        W_TOT_ITEM := W_PESOPECA*( VEN020->FATOR * W_PRECOKG )*X_QTD_PECAS
                     else
                        W_TOT_ITEM := W_PRECOTAB*X_QTD_PECAS
                     end
                  else
                     // ------------------------
                     // Verifica se e peca curta
                     // ------------------------

                     VEN017->( dbseek( X_GRUPO ))

                     if X_COMPRIM < VEN017->COMPMINIMO
                        VEN020->( dbseek( X_GRUPO + X_SUBFATOR ))
                        W_TOT_ITEM := W_PESOPECA*( VEN020->FATOR * W_PRECOKG )*X_QTD_PECAS
                     else
                        W_TOT_ITEM := W_PESOPECA*W_PRECOKG*X_QTD_PECAS
                     end
                  end

            endcase

            @ 21,66 say W_TOT_ITEM  picture "999999999.99"
            @ 21,40 say W_TOT_ITEM/X_QTD_PECAS  picture "99999.99"  // preco por peca
         end

         if lastkey()=K_ESC;exit;end

      end

      @ 21,66 say W_TOT_ITEM  picture "999999999.99"

      if X_QTD_PECAS > 0
         @ 21,40 say W_TOT_ITEM/X_QTD_PECAS  picture "99999.99"  // preco por peca
      end

      // read

      if conf(' Confirma Opera‡„o ')
         WRET := .T.
         exit
      else
         if conf(' Abandona Item ')
            WRET := .F.
            exit
         end
      end

   end

end sequence


set key K_F7 to
set key K_F8 to

return WRET

/*
-------------------------------------------------------------------------------
                           CONS_NOVA_SEQ
-------------------------------------------------------------------------------
*/
procedure cons_nova_seq( P_CONSULTA )
local W_ULTSEQ:=0, W_ANTREG := VEN004->( recno())

VEN004->( dbsetorder(1))
VEN004->( dbseek( P_CONSULTA,.t. ) )

while VEN004->CONSULTA = P_CONSULTA .and. VEN004->( ! eof())
   W_ULTSEQ := VEN004->SEQUENC
   VEN004->( dbskip())
end


VEN004->( dbgoto( W_ANTREG ))

return (W_ULTSEQ+1)

/*
-------------------------------------------------------------------------------
                     PRECO UNIDADE
-------------------------------------------------------------------------------
*/
function F_PRECO_UNIDADE( P_UNIDADE, P_COMISCOM, P_DESCONTO )

// -----------------------------
// Preco por Quilo com comissoes
// -----------------------------
// W_PRECOKG  := W_PRECOTAB * (1-(P_DESCONTO/100)) * (1+((P_COMISCOM*2)/100))

W_PRECOKG  := W_PRCBASKG * (1-(P_DESCONTO/100)) * (1+((P_COMISCOM*2)/100))

do case
   case P_UNIDADE = 'K'
      W_PRECOTAB := W_PRCBASKG

   case P_UNIDADE = 'P'
      W_PRECOTAB := W_PRCBASKG * W_PESOPECA

   case P_UNIDADE = 'M'
      W_PRECOTAB := W_PRCBASKG * W_PESOMTR

endcase

W_PRECO_ORIGINAL := W_PRECOTAB
W_PRECOTAB := W_PRECO_ORIGINAL * (1-(P_DESCONTO/100)) * (1+((P_COMISCOM*2)/100))

F_REFRESH()

return .T.

/*
-------------------------------------------------------------------------------
                     DESCONTO
-------------------------------------------------------------------------------
*/
function F_DESCONTO()
// Verifica se desconto e viavel

VEN014->( dbsetorder(1) )
VEN014->( dbseek( X_GRUPO ) )

W_GRUPO := VEN014->GRUPO

if ! W_LIBERACAO
   W_DESCONTO := if( W_DESCONTO = 999.99, 999.99, W_DESCONTO )
   W_DESCMAX  := 999.99

   while  VEN014->GRUPO = W_GRUPO .and. VEN014->( ! eof() )

      if W_DESCONTO <= VEN014->DESCMAX
         W_COMISVEN := VEN014->COMISSAO
         W_DESCMAX  := VEN014->DESCMAX
         exit
      else
         VEN014->( dbskip() )
      end

   end

   if W_DESCMAX = 999.99 .AND. W_DESCONTO > 0 .AND. ! F_PRECOEXTERNO
      mensbeep("Desconto Acima da Tabela. Necessita Senha.")

      if verdireito( C_ACESSO, 'VEN021' ) = 'S'
         W_LIBERACAO := .T.
         W_DESCONTO  := W_DESCONTO
         W_COMISCOM  := W_COMISCOM
         W_PRECOTAB  := W_PRECO_ORIGINAL * ( 1+( (W_COMISCOM*2)/100 ) ) * (1-( W_DESCONTO/100 ))
      else
         W_DESCONTO := 0
         W_COMISCOM := P_BASECCOMP
         W_COMISVEN := F_VEND_COMIS( X_GRUPO, 0 )
         F_PRECO_UNIDADE( X_UNIDADE, W_COMISCOM, W_DESCONTO )
      end
   else
      // W_COMISVEN := F_VEND_COMIS( X_GRUPO, W_DESCONTO )
      W_DESCONTO := W_DESCONTO
      W_COMISCOM := W_COMISCOM
      W_PRECOTAB := W_PRECO_ORIGINAL * ( 1+( (W_COMISCOM*2)/100 ) ) * (1-( W_DESCONTO/100 ))
   end
else
   W_LIBERACAO := .T.
   W_DESCONTO  := W_DESCONTO
   W_COMISCOM  := W_COMISCOM
   W_PRECOTAB  := W_PRECO_ORIGINAL * ( 1+( (W_COMISCOM*2)/100 ) ) * (1-( W_DESCONTO/100 ))

end

F_REFRESH()

return .T.


/*
-------------------------------------------------------------------------------
                     PRECO TABELA ALTERADO
-------------------------------------------------------------------------------
*/
function F_PRECO_TAB( P_PRECOTAB, P_TIPOVENDA )

// if P_TIPOVENDA = 'R'

   if P_PRECOTAB > 0

      X := W_PRECO_ORIGINAL
      Y := 1+( (W_COMISCOM*2)/100 )
      Z := 1-( W_DESCONTO/100 )

      // T := W_PRECO_ORIGINAL * (1+( (P_COMISCOM*2)/100 )) * (1-( W_DESCONTO/100 ))

      F := P_PRECOTAB
      Z := F / ( X * Y )
      Y := F / ( X * Z )
      X := F / ( Z * Y )

      W_PRECO_ORIGINAL := X
      W_COMISCOM := (INT( ((Y-1)*100)/2 )*100 )/100
      W_DESCONTO := ( INT( (1-Z)*100*100 ) )/100
      W_COMISVEN := F_VEND_COMIS( X_GRUPO, W_DESCONTO )

      F_REFRESH()
   else
    //   mensbeep("Nao e permitido preco menor ou igual a ZERO. <ENTER>")
   end

return .T.


/*
-------------------------------------------------------------------------------
                     COMISSAO DO COMPRADOR
-------------------------------------------------------------------------------
*/
function F_COMP_COMIS( P_CODCLI, P_COMISCOM, P_UNIDADE, P_DESCONTO )

VEN001->( dbsetorder(1) )
VEN001->( dbseek( P_CODCLI ) )

W_COMISCOM := VEN001->COMISSAO

if P_COMISCOM <= W_COMISCOM
   W_COMISCOM := P_COMISCOM
   W_PRECOTAB := W_PRECO_ORIGINAL * (1+( (P_COMISCOM*2)/100 )) * (1-( W_DESCONTO/100 ))
else
   W_PRECOTAB := W_PRECO_ORIGINAL * (1+( (W_COMISCOM*2)/100 )) * (1-( W_DESCONTO/100 ))
end

F_REFRESH()

return .T.


/*
-------------------------------------------------------------------------------
                     COMISSAO DO VENDEDOR
-------------------------------------------------------------------------------
*/
function F_VEND_COMIS( P_GRUPO, P_DESCONTO )

VEN014->( dbsetorder(1) )
VEN014->( dbseek( X_GRUPO ) )

W_GRUPO := VEN014->GRUPO

if ! W_LIBERACAO
   W_DESCONTO := if( W_DESCONTO = 999.99, 900, W_DESCONTO )
   W_DESCMAX  := 999.99

   while  VEN014->GRUPO = W_GRUPO .and. VEN014->( ! eof() )

      if W_DESCONTO <= VEN014->DESCMAX
         W_COMISVEN := VEN014->COMISSAO
         W_DESCMAX  := VEN014->DESCMAX
         exit
      else
         VEN014->( dbskip() )
      end

   end
end

return W_COMISVEN

/*
-------------------------------------------------------------------------------
                     MOSTRAR PRECO E COMISSAO
-------------------------------------------------------------------------------
*/
function F_REFRESH()

   @ 16,67 say W_COMISVEN  picture "@E   999.99"
   @ 17,67 say W_COMISCOM  picture "@E   999.99"
   @ 18,67 say W_DESCONTO  picture "@E   999.99"
   @ 19,67 say W_PRECOTAB  picture "@E 99999.99"

return .T.

function GETSENHA()
   local getlist:={}
   WRET := space(6)
   P_SCR := savescreen(10,17,16,41)
   P_COROLD := setcolor()

   setcolor(W_CORWIND )
   @ 10,17 say 'ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿'
   @ 11,17 say '³                       ³'
   @ 12,17 say '³                       ³'
   @ 13,17 say '³ SENHA :               ³'
   @ 14,17 say '³                       ³'
   @ 15,17 say '³                       ³'
   @ 16,17 say 'ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ'

   @ 13,28 get WRET picture "@!" color "B/B,R/R,B,N,N"
   read

   setcolor(P_COROLD)
   restscreen(10,17,16,41,P_SCR)

return WRET

procedure telachapa( P_FORMA, P_MODO )
   local X_CSUB := ' '

   EST003->( dbseek( P_FORMA ) )
   X_P_MATERIAL := EST003->P_MATERIAL
   X_P_CORTE    := EST003->P_CORTE

   X_PMEDCORTE := STR(EST003->P_CORTE,1)

   if X_P_CORTE = 5 // Especial

      if P_MODO = 'INCLUIR'
         X_SUBFORMA := pergresp( "Retangulo/ Disco/ Anel/ M-desenho ? (RDAM) ","RDAM")
      end
      do case
         case X_SUBFORMA = 'R'
            X_CSUB := 'Retangulo'
            @ 16,00 say '³   Largura   (mm): '
            @ 17,00 say '³   Comprim.  (mm): '

         case X_SUBFORMA = 'D'
            X_CSUB := 'Disco    '

            @ 16,00 say '³   Diametro  (mm): '

         case X_SUBFORMA = 'A'
            X_CSUB := 'Anel     '

            @ 16,00 say '³   Diam.Ext  (mm): '
            @ 17,00 say '³   Diam.Int  (mm): '

         case X_SUBFORMA = 'M'
            X_CSUB := 'Modelo   '

      endcase

      @ 21,00 say '³ SubForma : '+X_CSUB

   end

return

/*
-------------------------------------------------------------------------------
                           P331_TELA
-------------------------------------------------------------------------------
*/
procedure P331_TELA()

   @ 07,00 say 'ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿'
   @ 08,00 say '³                                                                              ³'
   @ 09,00 say '³    Forma    :       -                                                        ³'
   @ 10,00 say '³    Tipo     :       -                                                        ³'
   @ 11,00 say '³    Estado   :       -                                                        ³'
   @ 12,00 say '³    Bit./Esp.:      /                                                         ³'
   @ 13,00 say '³    Bit./Larg:      /                                                         ³'
   @ 14,00 say 'ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´'
   @ 15,00 say '³   Espessura (mm):             ³PM=            ³ Unidade K-M-P .:             ³'
   @ 16,00 say '³   Largura   (mm):             ³               ³ Cm. Vended  (%):             ³'
   @ 17,00 say '³   Comprim.  (mm):             ³PP‡=           ³ Cm. Comprad (%):             ³'
   @ 18,00 say '³   Peso Teor (Kg):             ³PT=            ³ Desconto ...(%):             ³'
   @ 19,00 say '³   N£m.de Pe‡as .:             ³               ³ Pre‡o Tabela ..:             ³'
   @ 20,00 say '³   Data Pedido ..:             ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´'
   @ 21,00 say '³   Data Validade :             ³TotP‡:         ³ Total do Item  :             ³'
   @ 22,00 say 'ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ'
  
return

// --------------  FIM DE PROGRAMA  --------------------------------- //

/* 
procedure P331_tela()


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
   @ 20,02 say '³  Data Pedido ....... :             ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´
   @ 21,02 say '³                                    ³ Valor Total do Item :               ³'
   @ 22,02 say 'ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ'

return
*/
 
