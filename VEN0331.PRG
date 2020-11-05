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
private  COR         := W_CORWD
private  TITULO      := " Itens de Pedido "
private  LININI      := 08
private  LINFIM      := 20
private  COLINI      := 00
private  COLFIM      := 79
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
*aadd( CAMPO     , "SEPARADO" )
aadd( CAMPO     , "USUARIO" )

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
aadd( MASCARA   , "@E 999,999.99" )
aadd( MASCARA   , "X"            )
*aadd( MASCARA   , "X"            )
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
*aadd( CABECALHO , "S" )
aadd( CABECALHO , " " )

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
*aadd( TAMANHO   ,  1 )
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
*aadd( W_FILE   , "VEN006")

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
keyboard ' '

do while CONTINUA .and. ( (TEC:=tabmov(TABELA)) != K_ESC )
   
   private  W_RTEL := savescreen(,,,,)
   setcursor(1)
   setcolor( W_CORWD )
   do case
      case TEC==K_UP .OR. TEC==K_DOWN
        keyboard(CHR(32))
      
      case lastkey() = K_F1
          mensboxv( { " <F4> Alterar ",;
                      " <F5> Excluir ",;
                      " <F6> Marca item   ",;
                      " <F7> Gera separacao ",;
                      " <F9> Tela de fornecedor",;
                      " <F12> Observacao do Item"})

      
      case lastkey() = K_F4
         W_RTEL := savescreen(,,,,)
         P331_altera()
         tabela:refreshall()

      case lastkey() = K_F5
         W_RTEL := savescreen(,,,,)
         P331_exclui()
         tabela:refreshall()
      restscreen(,,,,W_RTEL)
      
      case lastkey() = K_F6
         P33_marcaitem()
         tabela:refreshall()
      restscreen(,,,,W_RTEL)
      
      case lastkey() = K_F7
         W_RTEL := savescreen(,,,,)
         p33_fecha_sep()
         tabela:refreshall()
      restscreen(,,,,W_RTEL)
      
      case lastkey() = K_F9
         if VEN006->ESTOQUE='R'
            W_RTEL := savescreen(,,,,)
            fornece023(VEN006->PEDVEN)
            tabela:refreshall()
            restscreen(,,,,W_RTEL)
         end
      
      case lastkey() = K_F12
          W_RTEL := savescreen(,,,,)
          inc_obs()
          restscreen(,,,,W_RTEL)

      case lastkey() = K_ENTER
         W_RTEL := savescreen(,,,,)
         P331_consulta()
         tabela:refreshall()
         restscreen(,,,,W_RTEL)
      other
         tela_status()

   endcase
   setcolor( W_CORWD)
   select VEN006
enddo

restscreen(,,,,W_TEL21)

return WRET


/*
-------------------------------------------------------------------------------
                           P331_ALTERA
-------------------------------------------------------------------------------
*/
function P331_altera()

local W_OLDSCR := savescreen()

P331_atrib()
P331_tela()
P331_show()
telachapa( X_FORMA, "ALTERAR" )

if P331_get()
   P331_grava("A")
end

return

/*
-------------------------------------------------------------------------------
                           P331_CONSULTA
-------------------------------------------------------------------------------
*/
Function P331_consulta()
local tecla
local W_OLDSCR := savescreen()
F_MATNOTFOUND := .F.
P331_atrib()
P331_tela()
P331_show()
telachapa( X_FORMA, "CONSULTA" )

// P331_GET("CONSULTA")

WHILE .T.
   tecla := inkey(0)
   if tecla = K_F7 ; tela_peca_cort() ; end
   if tecla = K_F8 ; tela_ped_compra() ; end
   if tecla = K_ESC .or. tecla = K_ENTER ; EXIT ; END
   LOOP
END
return

/*
-------------------------------------------------------------------------------
                           P331_EXCLUI
-------------------------------------------------------------------------------
*/
Function P331_exclui()

local W_OLDSCR := savescreen()

P331_atrib()
P331_tela()
P331_show()

if pergunta(' Confirma Exclusao ? ')

   VEN005->( dbsetorder(1) )
   VEN005->( dbseek(X_PEDVEN) )
   if VEN005->( ! found() )
      message('Erro grave - Header Inexistente ')
      return := .F.
   end
   X_VALOR := VEN005->VALOR - VEN006->PRECO
   if VEN005->QTD_ITENS >0
     X_QTD   := VEN005->QTD_ITENS - 1
   END
   while VEN005->( ! rlock() ); end
   VEN005->VALOR    := X_VALOR
   VEN005->QTD_ITENS:= X_QTD
   while VEN006->( ! rlock() ); end
   VEN006->( dbdelete() )
   VEN006->( dbunlock() )
   VEN005->( dbunlock() )
end
return

/*
-------------------------------------------------------------------------------
                           P331_zap
-------------------------------------------------------------------------------
*/
function P331_zap( P_PEDVEN )
 
   if conf('Confirma Exclusao Total do Pedido ? ')
      select VEN006
      VEN006->( dbsetorder(1) )
      VEN006->( dbgotop() )
      VEN006->( dbseek( P_PEDVEN ))
      if VEN006->( found() )
         while VEN006->( ! eof() ) .and. VEN006->PEDVEN=P_PEDVEN
            while VEN006->( ! rlock() ); end
            while VEN023->( ! rlock() ); end
            if VEN006->ESTOQUE = 'R'
              VEN023->(dbsetorder(2))
              if VEN023->( dbseek(VEN006->PEDVEN) )
                VEN023->( dbdelete() )
               end
            end
            VEN006->( dbdelete() )
            VEN006->( dbskip()   )
         end
      end
   end

return 

/*
-------------------------------------------------------------------------------
                           P331_ZERA
-------------------------------------------------------------------------------
*/
procedure P331_zera()

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
   X_ESPESSURA  := 0.00
   X_QTD_PECAS  := 0
   X_PESO_TEO   := 0.00
   X_PESO_ITEM  := 0.00
   X_COM_VEND   := 0.00
   X_COM_COMP   := 0.00
   X_PER_ACRES  := 0.00
   X_TIPO_SEP   := space(01)
   X_PESO_BALAN := 0.0
   X_DT_PEDIDO  := date()
   X_DT_EMISSAO := ctod( '  /  /  ' )
   X_DT_SEPARA  := ctod( '  /  /  ' )
   X_PRAZODT    := ctod( '  /  /  ' )
   X_PRAZOHR    := "00:00"
   X_SEQ_SEPARA := 0
   X_PESO_COBRA := 0.00
   X_PRECO      := 0
   X_NOTAFISCAL := space(10)
   X_CONSULTA   := space(06)
   X_UNIDADE    := 'K'

return

/*
-------------------------------------------------------------------------------
                           P331_GRAVA
-------------------------------------------------------------------------------
*/
procedure P331_grava( P_MODO )

   VEN005->( dbsetorder(1) )
   VEN005->( dbseek(X_PEDVEN) )
   if VEN005->( ! found() )
      message('Erro grave - Header Inexistente ')
      return := .F.
   end

   if P_MODO = "I"
      X_VALOR := VEN005->VALOR + X_PRECO
      X_QTD   := VEN005->QTD_ITENS + 1
   else
      X_VALOR := VEN005->VALOR - VEN006->PRECO + X_PRECO
   end


   if P_MODO = "I"  // Inclusao
      X_SEQUENC := 1
      VEN006->( dbappend())
   else
      X_SEQUENC := v_nova_sequencia( X_PEDVEN )
      while VEN006->( ! rlock() ); end
      while VEN005->( ! rlock() ); end
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
   VEN006->ESPESSURA  := X_ESPESSURA
   VEN006->QTD_PECAS  := X_QTD_PECAS
   VEN006->PESO_TEO   := X_PESO_TEO
   VEN006->COM_VEND   := X_COM_VEND
   VEN006->COM_COMP   := X_COM_COMP
   VEN006->PER_ACRES  := X_PER_ACRES
   VEN006->TIPO_SEP   := X_TIPO_SEP
   VEN006->PESO_BALAN := X_PESO_BALAN
   VEN006->DT_EMISSAO := X_DT_EMISSAO
   VEN006->DT_SEPARA  := X_DT_SEPARA
   VEN006->PRAZODT    := X_PRAZODT
   VEN006->PRAZOHR    := X_PRAZOHR

   VEN006->SEQ_SEPARA := X_SEQ_SEPARA
   VEN006->PESO_COBRA := X_PESO_COBRA
   VEN006->PRECO      := X_PRECO
   VEN006->NOTAFISCAL := X_NOTAFISCAL
   VEN006->CONSULTA   := X_CONSULTA
   VEN006->UNIDADE    := X_UNIDADE

   VEN006->OBSERVACAO := X_OBS
   
   VEN005->VALOR      := X_VALOR
   VEN006->( dbunlock() )
   VEN005->( dbunlock() )


return

/*
-------------------------------------------------------------------------------
                           P331_ATRIB
-------------------------------------------------------------------------------
*/
procedure P331_atrib()

   W_DIGITACAO  := VEN006->DIGITACAO
   X_PEDVEN     := VEN006->PEDVEN
   X_SEQUENC    := VEN006->SEQUENC
   X_FORMA      := VEN006->FORMA
   X_TIPO       := VEN006->TIPO
   X_ESTADO     := VEN006->ESTADO
   X_BIT_MM     := VEN006->BIT_MM
   X_PRECO      := VEN006->PRECO
   X_ESP_MM     := VEN006->ESP_MM
   X_BIT_INT    := VEN006->BIT_INT
   X_BIT_FN     := VEN006->BIT_FN
   X_BIT_FD     := VEN006->BIT_FD
   X_ESP_INT    := VEN006->ESP_INT
   X_ESP_FN     := VEN006->ESP_FN
   X_ESP_FD     := VEN006->ESP_FD

   X_COMPRIM    := VEN006->COMPRIM
   X_LARGURA    := VEN006->LARGURA
   X_ESPESSURA  := VEN006->ESPESSURA
   X_QTD_PECAS  := VEN006->QTD_PECAS

   X_PESO_TEO   := if(VEN006->PESO_TEO=0,VEN006->PESO_ITEM,VEN006->PESO_TEO)
   X_PESO_ITEM  := VEN006->PESO_ITEM

   X_COM_VEND   := VEN006->COM_VEND
   X_COM_COMP   := VEN006->COM_COMP
   X_PER_ACRES  := VEN006->PER_ACRES
   X_TIPO_SEP   := VEN006->TIPO_SEP
   X_PESO_BALAN := VEN006->PESO_BALAN
   X_DT_PEDIDO  := VEN006->DT_PEDIDO
   X_DT_EMISSAO := VEN006->DT_EMISSAO
   X_DT_SEPARA  := VEN006->DT_SEPARA
   X_SEQ_SEPARA := VEN006->SEQ_SEPARA
   X_PESO_COBRA := VEN006->PESO_COBRA
   X_PRECO      := VEN006->PRECO
   X_NOTAFISCAL := VEN006->NOTAFISCAL
   X_CONSULTA   := VEN006->CONSULTA
   X_UNIDADE    := VEN006->UNIDADE
   X_SUBFORMA   := VEN006->SUBFORMA
   X_OBS        := VEN006->OBSERVACAO

return

/*
-------------------------------------------------------------------------------
                           P331_SHOW
-------------------------------------------------------------------------------
*/
procedure P331_show()

get_mainkey(2)
clear gets

tes_formato( 09, 16, 20 )
tes_tipo(2)
tes_estado(2)

W_CHAVE_ITEM := ( X_FORMA+ X_TIPO+ ;
             str( X_BIT_MM, 8, 3 ) + str( X_ESP_MM, 8, 3 ) + X_ESTADO )

posic_est_consulta( W_CHAVE_ITEM )

@ 15,67 say VEN006->UNIDADE
@ 16,19 say VEN006->LARGURA    picture "999999.99"
@ 17,19 say VEN006->COMPRIM    picture "999999.99"
@ 18,19 say VEN006->PESO_TEO   picture "@E 999,999.99"
@ 19,20 say VEN006->QTD_PECAS  picture "@E 99999"

// @ 20,19 say VEN005->DT_PEDIDO
// @ 21,19 say VEN006->DT_VALID
// @ 18,62 say VEN006->COM_VEND   picture "999999.99"
// @ 19,62 say VEN006->COM_COMP   picture "999999.99"

@ 21,00 say '³ Obs : '+left( X_OBS, 22 )
@ 22,00 say '³ ' + substr( X_OBS, 23, 28 )

@ 21,62 say VEN006->PRECO      picture "@E 999,999,999.99"

busca_comissao('A','ven0331')
return

/*
-------------------------------------------------------------------------------
                           P331_GET
-------------------------------------------------------------------------------
*/
procedure P331_GET( P_MODO )

local WRET        := .F.
* local W_PRECO_TAB := 0.00
local getlist:={}

set key K_F1 to help
set key K_F7 to tela_peca_cort
set key K_F8 to tela_ped_compra

begin sequence

   if X_P_CORTE = 5 // medida de corte = 5- especial

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

      // @ 21,00 say '³ SubForma : '+X_CSUB

      //
      //
      //

      @ 16,20 get X_LARGURA    picture "99999999.99"   when X_SUBFORMA $ "RDA"
      @ 17,20 get X_COMPRIM    picture "99999999.99"   valid tes_comp() when X_SUBFORMA $ "RA"
      @ 18,20 get X_PESO_TEO   picture "@E 999,999.99" when X_ESPESSURA = 0 ;
                                                      .AND. X_COMPRIM   = 0 ;
                                                      .AND. X_LARGURA   = 0
      @ 19,20 get X_QTD_PECAS  picture "@E 99999"      valid tes_qtdpecas() ;
                                                       when  X_PESO_TEO = 0
      @ 21,08 get X_OBS picture "@S20"

      if P_MODO #NIL
        CLEAR GETS
      ELSE
        read 
      end

   else
      @ 15,20 get X_ESPESSURA  picture "999.99"   when X_PMEDCORTE $ "4"
      @ 16,20 get X_LARGURA    picture "99999999.9"   when X_PMEDCORTE $ "24"
      @ 17,20 get X_COMPRIM    picture "99999999.9"   valid tes_comp() when X_PMEDCORTE $ "124"
      @ 18,20 get X_PESO_TEO   picture "@E 999,999.99" when X_ESPESSURA = 0 ;
                                                      .AND. X_COMPRIM   = 0 ;
                                                      .AND. X_LARGURA   = 0
      @ 19,20 get X_QTD_PECAS  picture "@E 99999"      valid tes_qtdpecas() ;
                                                       when  X_PESO_TEO = 0
      @ 21,08 get X_OBS picture "@S18"

      if P_MODO ='CONSULTA' 
        CLEAR GETS
      ELSE
        read 
      end
      
      read
   end
   
   if X_COMPRIM >0 .OR. X_ESPESSURA >0 .OR. X_LARGURA >0 ; X_PESO_TEO := 0 ; end
   @ 18,20 say X_PESO_TEO   picture "@E 999,999.99" 
   if lastkey()=K_ESC; break; end



   EST007->( dbseek( W_CHAVE_ITEM ) )

   if P_MODO # NIL
     calcpesorel2('C')
   ELSE
     calcpesorel2('I')
   end
   while .T.
      while .T.

         @ 15,67 get X_UNIDADE   picture "!"           valid f_preco_unidade( X_UNIDADE, W_COMISCOM, W_DESCONTO ) .AND. X_UNIDADE $ "KPM"
         @ 16,67 get W_COMISVEN  picture "@E 99999.99" when W_LIBERACAO
         @ 17,67 get W_COMISCOM  picture "@E 99999.99" valid f_comp_comis( X_CODCLI, W_COMISCOM, X_UNIDADE, W_DESCONTO )
         @ 18,67 get W_DESCONTO  picture "@E 99999.99" valid f_desconto()
         @ 19,67 get W_PRECOTAB  picture "@E 99999.99" valid f_preco_tab( W_PRECOTAB, X_TIPOVENDA )
         if P_MODO#NIL
           CLEAR GETS
         else
          read
         end

         // -----------------------------------
         //               Revenda
         // -----------------------------------
         // if X_TIPOVENDA = 'R'

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

         end

         if X_QTD_PECAS > 0
            @ 21,40 say W_TOT_ITEM/X_QTD_PECAS  picture "@E 9,999.99"  // preco por peca
         else
            @ 21,40 say W_TOT_ITEM              picture "@E 9,999.99"  // preco por peca
         end

         @ 21,66 say W_TOT_ITEM  picture "@E 9,999,999.99"

         if lastkey() = K_ESC .or. P_MODO#NIL 
           exit
         end

      end
     // read
      if P_MODO ='CONSULTA'
        WRET := .T.      
        EXIT
      else
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
   end
end sequence


set key K_F7 to
set key K_F8 to
X_PRECO := W_TOT_ITEM
return WRET

/*
-------------------------------------------------------------------------------
                           P331_BROW()
-------------------------------------------------------------------------------
*/
procedure P331_brow()

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
   @ 20,00 say '³                               ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´'
   @ 21,00 say '³                               ³TotP‡:         ³ Total Item :                 ³'
   @ 22,00 say '³                                                                              ³'
   @ 23,00 say 'ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ'
  
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
   @ 22,02 say '³                                                                          ³'
   @ 23,02 say 'ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ'

return
*/
 
procedure calcpesorel2( consulta)
      // Calcula peso relativo
      consulta := if( consulta=nil,'',consulta)
      W_PESOMTR := VEN006->PES_MATNOT
       if X_P_CORTE = 5 // Chapa

         do case
            case X_SUBFORMA = 'R'
               W_PESOPECA := ( ( (X_COMPRIM+5)*(X_LARGURA+5))/1000000 ) * W_PESOMTR

            case X_SUBFORMA = 'D'
               W_PESOPECA := (( (X_LARGURA+5)^2)/1000000 ) * W_PESOMTR

            case X_SUBFORMA = 'A'
               W_PESOPECA := (( (X_LARGURA+5)^2)/1000000 ) * W_PESOMTR

            case X_SUBFORMA = 'M'
               W_PESOPECA := 1

         endcase
      else
         if X_P_CORTE = 4 // COM/LAR/ESP
            W_PESOPECA := ( (X_COMPRIM*X_ESPESSURA*X_LARGURA*8)/1000000 )

         else
            W_PESOPECA := ( (X_COMPRIM/1000) * W_PESOMTR) + EST007->PER_COR
         end
      end

      if W_PESOPECA >= 10
         if W_PESOPECA <> int(W_PESOPECA)
            W_PESOPECA := int(W_PESOPECA) + 1
         end
      else
         L_FRACAO := W_PESOPECA - int( W_PESOPECA )
         if L_FRACAO < 0.5
            W_PESOPECA := int( W_PESOPECA )+ 0.5
         else
            if L_FRACAO > 0.5
               W_PESOPECA := int( W_PESOPECA )+ 1
            end
         end
      end
      X_PESO_ITEM := W_PESOPECA * X_QTD_PECAS

   // Imprime peso relativo
   
   @ 15,37 say W_PESOMTR  picture "@E 999999999.9"
   @ 17,38 say W_PESOPECA        picture "@E 99999999.9"
   @ 18,37 say X_PESO_ITEM       picture "@E 999999999.9"
return




Procedure P33_MARCAITEM
 
   while VEN006->( ! rlock()); end
   VEN006->USUARIO := if( empty(VEN006->USUARIO), C_ACESSO, space(8) )
   VEN006->( dbunlock() )
return



procedure p33_telaheaderNF()
   @ 08,15 say  'ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿'
   @ 09,15 say  '³ Separa‡„o ...:                                  ³'
   @ 10,15 say  '³ Data ........:                                  ³'
   @ 11,15 say  '³ Entrega Data :                                  ³'
   @ 12,15 say  '³         Hora :                                  ³'
   @ 13,15 say  'ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ'
   sombra(08,15,13,65)
return


function p33_getheaderNF(B)

   X_DT_SEPARA := date()
   X_PRAZODT   := ctod(' ')
   X_PRAZOHR   := "00:00"

   @ 09,32 say X_SEPARACAO
   @ 10,32 get X_DT_SEPARA
   @ 11,32 get X_PRAZODT
   @ 12,32 get X_PRAZOHR
   read

   WRET := if( lastkey()=K_ESC, .F., .T. )

return WRET


function p33_gravaheader()

   while VEN006->( ! rlock() ); end
   VEN006->PRAZODT := X_PRAZODT
   VEN006->PRAZOHR := X_PRAZOHR
   VEN006->( dbunlock() )

return


function nova_separa()
  
  WSEQ := 01
  select VEN016
  VEN016->( dbsetorder( 2 ) )
  VEN016->( dbseek( X_PEDVEN ) )

  while VEN016->PEDVEN = X_PEDVEN .and. VEN016->(!EOF())
     WSEQ++
     VEN016->(DBSKIP())
  end

  select VEN006
  RESP := X_PEDVEN + strzero(WSEQ,2)
  VEN016->(dbappend())
  VEN016->SEPARACAO := RESP

RETURN(RESP) 

procedure tela_status()

@ 21,00 say 'ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿'
@ 22,00 say '³                                                       Total :                ³'
@ 23,00 say 'ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ'
@ 22,65 SAY STR(VEN005->VALOR,12,2)
@ 22,15 say if(!EMPTY(VEN006->SEPARADO),'Sep.Gerada','          ')
do case
 case VEN006->ESTOQUE ='R'
     @ 22,40 say 'Reven.        '
 case VEN006->ESTOQUE ='C'
     @ 22,40 say 'Est. a Chegar '
 case VEN006->ESTOQUE ='E'
     @ 22,40 say 'Estoque        '
end

function estoque(SOMA)
LOCAL X_FORMA      := VEN006->FORMA
LOCAL X_TIPO       := VEN006->TIPO
LOCAL X_ESTADO     := VEN006->ESTADO
LOCAL X_BIT_MM     := VEN006->BIT_MM
LOCAL X_ESP_MM     := VEN006->ESP_MM
LOCAL X_UNI        := VEN006->UNIDADE
local W_CHAVE_ITEM := X_FORMA+X_TIPO+X_ESTADO+str(X_BIT_MM,8,3)+str(X_ESP_MM,8,3)
select EST007
EST007->( dbsetorder(3) ) // forma+tipo+estado+str(bit_mm,8,3)+str(esp_mm,8,3)
EST007->( dbseek( W_CHAVE_ITEM ))

if EST007->(FOUND())
 while EST007->( ! rlock() ); end
 IF SOMA
     EST007->RESERVADO := EST007->RESERVADO + VEN006->PESO_TEO
   * EST007->QTD_KGT   := EST007->QTD_KGT   - VEN006->PESO_TEO
 ELSE
   * EST007->QTD_KGT   := (EST007->QTD_KGT  + EST007->RESERVADO) - X_PESO_RET
    EST007->RESERVADO := EST007->RESERVADO - VEN006->PESO_TEO
    while VEN006->(!rlock()) ; loop ; end
    VEN006->PESO_COBRA := X_PESO_RET
    VEN006->RETORNADO  := 'S'

        
 ENDIF
 EST007->(DBUNLOCK())
end
RETURN (.T.)

procedure inc_obs()

 X_OBSSEPARA := VEN006->OBSSEPARA

 @ 10,15 say  'ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿'
 @ 11,15 say  '³ Observacao...:                                  ³'
 @ 12,15 say  'ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ'
 sombra(10,15,12,65)
 @ 11,32 get X_OBSSEPARA   PICTURE "@S30"
 read
 if lastkey()#27
   while VEN006->(!rlock()); loop ; end
   VEN006->OBSSEPARA := X_OBSSEPARA
   VEN006->(dbunlock())
 end
return

/*
-------------------------------------------------------------------------------
                           P33_FECHA_SEP
-------------------------------------------------------------------------------
*/
procedure p33_fecha_sep()

   local W_OLDREC := VEN006->(recno() )

   WPG := 0

   while .t.

      p33_telaheaderNF()

      X_SEPARACAO := NOVA_SEPARA()

      W_TITULO      := 'Separacao N. :'+X_SEPARACAO
      WRESP_IMP     := 'I'
      W_IMPARQ      := space(12)
      WSEPSEQ       := 0

      if p33_getheaderNF()

         p33_gravaheader()

         SELECT VEN016
         VEN016->DATA      := X_DT_SEPARA
         VEN016->PEDVEN    := VEN006->PEDVEN
         VEN016->FLG_CR_NF := VEN005->FLG_TV

         SELECT VEN006
         VEN006->( dbsetorder(5) )
         VEN006->( dbseek( X_PEDVEN,.T. ))


         if dh_imprime("G")
            ESTREPO->( grava( WIMP_ARQ, date(), time(), W_TITULO, 83) )


            WTIPOSEP := VEN006->ESTOQUE
            ven035cab(.T.)

            while VEN006->PEDVEN = X_PEDVEN .and. VEN006->( ! eof() )

               if VEN006->USUARIO = C_ACESSO

                  if WTIPOSEP <> VEN006->ESTOQUE
                     // Cabecalho do novo tipo de separacao
                     //
                     WPG     := 0
                     WSEPSEQ := 0
                     ven035cab(.T.)
                  end
                  WTIPOSEP := VEN006->ESTOQUE

                  //
                  // Inclusao de item na separacao
                  //
                  VEN025->( dbappend() )

                  VEN025->SEPARACAO  := X_SEPARACAO
                  VEN025->DT_SEPARA  := X_DT_SEPARA
                  VEN025->RETORNADO  := ' '
                  VEN025->TIPO_SEP   := X_TIPO_SEP
                  VEN025->SEPARADO   := 'S'
                  VEN025->QTD_SEP    := VEN025->QTD_SEP +1
                  VEN025->PEDVEN     := VEN006->PEDVEN
                  VEN025->SEQUENC    := VEN006->SEQUENC
                  VEN025->FORMA      := VEN006->FORMA
                  VEN025->TIPO       := VEN006->TIPO
                  VEN025->ESTADO     := VEN006->ESTADO
                  VEN025->BIT_MM     := VEN006->BIT_MM
                  VEN025->ESP_MM     := VEN006->ESP_MM
                  VEN025->BIT_INT    := VEN006->BIT_INT
                  VEN025->BIT_FN     := VEN006->BIT_FN
                  VEN025->BIT_FD     := VEN006->BIT_FD
                  VEN025->ESP_INT    := VEN006->ESP_INT
                  VEN025->ESP_FN     := VEN006->ESP_FN
                  VEN025->ESP_FD     := VEN006->ESP_FD
                  VEN025->COMPRIM    := VEN006->COMPRIM
                  VEN025->LARGURA    := VEN006->LARGURA
                  VEN025->ESPESSURA  := VEN006->ESPESSURA
                  VEN025->PESO_ITEM  := VEN006->PESO_ITEM
                  VEN025->PESO_TEO   := VEN006->PESO_TEO
                  VEN025->PRECO      := VEN006->PRECO
                  VEN025->PRECO_UNI  := VEN006->PRECO_UNI
                  VEN025->QTD_PECAS  := VEN006->QTD_PECAS
                  VEN025->DIGITACAO  := VEN006->DIGITACAO

                   // ----------------------------------- //
                  VEN025->COM_Vend    := VEN006->COM_VEND
                  VEN025->COM_COMP    := VEN006->COM_COMP
                  VEN025->PER_ACRES   := VEN006->PER_ACRES
                  VEN025->TIPO_SEP    := VEN006->TIPO_SEP
                  VEN025->PESO_BALAN  := VEN006->PESO_BALAN
                  VEN025->DT_PEDVEN   := VEN006->DT_PEDVEN
                  VEN025->DT_EMISSAO  := date()
                  VEN025->DT_SEPARA   := VEN006->DT_SEPARA
                  VEN025->SEQ_SEPARA  := VEN006->SEQ_SEPARA
                  VEN025->PESO_COBRA  := VEN006->PESO_COBRA
                  VEN025->NOTAFISCAL  := VEN006->NOTAFISCAL
                  VEN025->CONSULTA    := VEN006->CONSULTA
                  VEN025->ESTOQUE     := VEN006->ESTOQUE
                  VEN025->SUBFORMA    := VEN006->SUBFORMA
                  VEN025->UNIDADE     := VEN006->UNIDADE
                  VEN025->PES_MATNOT  := VEN006->PES_MATNOT
                  VEN025->( dbunlock() )


                  SELECT VEN006

                  while VEN006->( ! rlock() ); end
                  VEN006->SEPARADO   := 'N'
                  VEN006->( dbunlock() )


                  do case
                     case VEN006->ESTOQUE = 'C'

                          ++WSEPSEQ
                          sep35rel( 'C' )

                     case VEN006->ESTOQUE = 'E'

                          ++WSEPSEQ
                          sep35rel( 'E' )

                     case VEN006->ESTOQUE = 'R'

                          ++WSEPSEQ
                          sep35rel( 'R' )

                  end

                  while VEN006->( ! rlock() ); end
                  VEN006->USUARIO    := space(30)
                  VEN006->QTD_SEP    := VEN006->QTD_SEP +1
                  VEN006->( dbunlock() )
               end

               VEN006->( dbskip() )
            end

            dh_impoff()

         end
      end
      exit
   end


   VEN006->( dbsetorder(1) )
   VEN006->( dbseek( X_PEDVEN,.T. ))

return 

