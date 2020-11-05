/*
-------------------------------------------------------------------------------
   VEN - Transformacao de Consulta em Pedido
   VEN31.PRG -
-------------------------------------------------------------------------------
*/
#include "inkey.ch"
Local Tela

abrir("EST002")
abrir("EST003")
abrir("EST004")
abrir("VEN001")
abrir("VEN003")
abrir("VEN004")
abrir("VEN005")
abrir("VEN006")

setcolor(W_COREDIT)
status('C o n s u l t a  =>  P e d i d o')

// VARIAVEIS

W_SEQ_CONS  := 0

X_CONSULTA   := SPACE(06)

// --> VEN003 -> CONSULTA
private  X_CONSULTA   := space(06)          ,;
         X_CLIENTE    := space(20)          ,;
         X_DT_CONS    := ctod( '  /  /  ' ) ,;
         X_COMPRADOR  := space(20)          ,;
         X_ORDCOMPRA  := space(10)          ,;
         X_OBS        := space(40)

// --> VEN004 -> CONSULTA
private  X_CONSULTA := Space(06)         ,;
         X_SEQUENC  := 0                 ,;
         X_FORMA    := space(03)         ,;
         X_TIPO     := space(05)         ,;
         X_ESTADO   := space(01)         ,;
         X_BIT_MM   := 0.00              ,;
         X_ESP_MM   := 0.00              ,;
         X_BIT_INT  := space(02)         ,;
         X_BIT_FN   := space(02)         ,;
         X_BIT_FD   := space(02)         ,;
         X_ESP_INT  := space(02)         ,;
         X_ESP_FN   := space(02)         ,;
         X_COMPRIM  := 0                ,;
         X_LARGURA  := 0                 ,;
         X_QTD_PECAS:= 0                 ,;
         X_PESO_TEO := 0.0               ,;
         X_PRECO    := 0.0               ,;
         X_DT_VALID := ctod( '  /  /  ' ),;
         X_PEDVEN   := space(05)         ,;
         X_STATUS   := space(01)

private W_CHAVE_ITEM, X_SEQUENC

TELA := wsave(01,02,19,68)

//
// variaveis DBEDIT
//

P_HDSEP := "ËÍ"
P_COLSEP := "-"
P_HEADER := {"Consulta For Tipo  Bit/Esp  Bit/Larg    Largura Comprimento Pecas   Preco M"}
//              xxxxxx xxx xxxxx 9999,999 9999,999 9999999,99  9999999,99  99  9999999,99 x


private  X_SEQUENC  := 0         ,;
         X_FORMA    := space(03) ,;
         X_TIPO     := space(05) ,;
         X_ESTADO   := space(01) ,;
         X_BIT_MM   := 0.00      ,;
         X_ESP_MM   := 0.00      ,;
         X_BIT_INT  := space(02) ,;
         X_BIT_FN   := space(02) ,;
         X_BIT_FD   := space(02) ,;
         X_ESP_INT  := space(02) ,;
         X_ESP_FN   := space(02) ,;
         X_ESP_FD   := space(02) ,;
         X_COMPRIM  := 0         ,;
         X_LARGURA  := 0         ,;
         X_QTD_PECAS:= 0         ,;
         X_PESO_TEO := 0.0       ,;
         X_PRECO    := 0.0       ,;
         X_DT_VALID := ctod( '  /  /  ' ),;
         X_PEDVEN   := space(05)         ,;
         X_STATUS   := space(01)

P_HEADER := {"Consulta For Tipo  Bit/Esp  Bit/Larg    Largura Comprimento Pecas    Preco M"}
//              xxxxxx xxx xxxxx 9999,999 9999,999 9999999,99  9999999,99  99 9999999,99 x

P_CAMPOS := {"'  '+VEN004->CONSULTA +' ' +                                       " +;
             "   +VEN004->FORMA    +' ' + VEN004->TIPO+' '                      " +;
             "                          + no_zero( VEN004->BIT_MM, 8, 3 ) +' ' " +;
             "   +no_zero( VEN004->ESP_MM,8,3)+' '+no_zero( VEN004->LARGURA,10,2 )+'  ' " +;
             "   +no_zero( VEN004->COMPRIM,10,2)+'  '+str(VEN004->QTD_PECAS,2,0)+' '" +;
             "   +str(  VEN004->PRECO,10,2)+' '                                 " +;
             "   +left( VEN004->USUARIO, 1 )                                    " }


// Declara variaveis auxiliares com o tamanho do banco de dados

declare VET31PRI := {}, VET31USU := {}, VET31REC := {}, VET31AUX := {}

   tran_tela31()
   @ 10,10 say ' ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿'
   @ 11,10 say ' ³                                                 ³'
   @ 12,10 say ' ³ Cliente :                                       ³'
   @ 13,10 say ' ³                                                 ³'
   @ 14,10 say ' ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ'

   WNOMECLI := space(20)
   @ 12,23 get WNOMECLI picture "@!"
   read

   if lastkey() = K_ESC
      return
   end

   WNOMECLI := alltrim(WNOMECLI)

   if lastkey() != K_ESC
      @ 06,05 say VEN001->RAZAO

      keyboard chr(13)
      while .t.
         W_TELA := savescreen(,,,,)

         tran_tela31()

         VEN003->( dbsetorder(3) )
         VEN004->( dbsetorder(1) )
         VEN003->( dbseek( WNOMECLI ))
         X:=0
         while VEN003->CLIENTE = WNOMECLI .and. VEN003->( ! eof() )

            VEN004->( dbseek(  VEN003->CONSULTA ) )

            while VEN004->CONSULTA = VEN003->CONSULTA .and. VEN004->(! eof() )

               // So permite a selecao dos itens nao utilizados por
               // um outro pedido.
               // Caso o campo usuario esteja preenchido, ja pertence
               // a um pedido.

               if empty( VEN004->PEDVEN )
                  aadd(VET31PRI, ( ' ' + VEN004->CONSULTA +' '              +;
                                    VEN004->FORMA    +' ' + VEN004->TIPO+' ' +;
                                    no_zero( VEN004->BIT_MM, 8, 3 ) +' '     +;
                                    no_zero( VEN004->ESP_MM,8,3)    +' '     +;
                                    no_zero( VEN004->LARGURA,10,2 ) +' '     +;
                                    no_zero( VEN004->COMPRIM,10,2)  +' '     +;
                                    str(VEN004->QTD_PECAS,2,0)      +' '     +;
                                    str( VEN004->PRECO,10,2)        +' '     +;
                                    left( VEN004->USUARIO, 2 )      +' '     +;
                                    VEN004->UNIDADE                 +' ' ) )

                  aadd( VET31USU, VEN004->USUARIO )
                  aadd( VET31REC, VEN004->( recno() ) )
                  aadd( VET31AUX, VEN003->CLIENTE + space(7) + VEN003->COMPRADOR +;
                                  space(11) + DTOC( VEN003->DT_CONS ) )
               end
               VEN004->( dbskip() )
            end
            VEN003->( dbskip() )
         end

         VEN003->( dbsetorder(1) )
         achoice(09,03,18,76,VET31PRI,,"TRAN_FUNC31")

         restscreen(,,,,W_TELA)

         EXIT

      end

   end


dbcloseall()
return

//
//
// -------------------------  FIM DO PROGRAMA PRINCIPAL -----------------------
//
//

/*
-------------------------------------------------------------------------------
                           tran_FUNC31
-------------------------------------------------------------------------------
*/
function tran_func31( modo, tupla )

private WRET := 2, W_OLDSCR := savescreen(,,,,)
private WKEYVET

WKEYVET := TUPLA

setcursor(1)
do case

   case lastkey() = K_F4
      P31_MARCAITEM()
      WRET := 2

   case lastkey() = K_F6
      P31_FECHAPEDIDO()
      WRET := 0

   case lastkey() = K_ESC
      WRET := 0
endcase

restscreen(,,,,W_OLDSCR )

@ 06,05 say VET31AUX[TUPLA]


return WRET

/*
-------------------------------------------------------------------------------
                           P31_MARCAITEM
-------------------------------------------------------------------------------
*/
Procedure P31_MARCAITEM

VEN004->( dbgoto(VET31REC[WKEYVET]))
if empty( VET31USU[WKEYVET] )
   VET31USU[WKEYVET] := M->USUARIO
   VET31PRI[WKEYVET] := "*" + substr(VET31PRI[WKEYVET], 2, len( VET31PRI[WKEYVET])-1 )
   VEN004->USUARIO := C_ACESSO
else
   VET31USU[WKEYVET]   := space(30)
   VET31PRI[WKEYVET] := " "+substr(VET31PRI[WKEYVET],2,len(VET31PRI[WKEYVET])-1)
   VEN004->USUARIO := space(30)
end

return

/*
-------------------------------------------------------------------------------
                           P31_FECHAPEDIDO
-------------------------------------------------------------------------------
*/
Procedure P31_FECHAPEDIDO

@ 08,03 say 'ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ Fechamento de Pedido ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿'
@ 09,03 say '³                                                                    ³'
@ 10,03 say '³ N§ Pedido......:                                                   ³'
@ 11,03 say '³ Cliente  ......:                                                   ³'
@ 12,03 say '³ Comprador......:                                                   ³'
@ 13,03 say '³                                                                    ³'
@ 14,03 say '³ Ordem de Compra:                                                   ³'
@ 15,03 say '³                                                                    ³'
@ 16,03 say 'ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ'
sombra( 08, 03, 16, 75 )

X_PEDVEN    := space(5)
X_CODCLI    := space(5)
X_ORDCOMPRA := space(10)
X_ORDEM     := space(05)

while .t.
   X_PEDVEN := VEN005->( gera_pedido( "VEN005->PEDVEN" ) )

   @ 10,23 say X_PEDVEN

   @ 11,23 get X_CODCLI    picture "@!" valid tes_codcli( X_CODCLI,11,23 )
   @ 12,23 get X_COMPRADOR picture "@!"
   @ 14,23 get X_ORDCOMPRA picture "@!"

   read
   if lastkey() = K_ESC; exit; end
   VEN005->( dbsetorder(1) )
   VEN005->( dbseek( X_PEDVEN ))
   if VEN005->( found() )
      message('Pedido ja Cadastrado. <ENTER>')
      loop
   end

   VEN004->( dbsetorder(2) )
   VEN004->( dbseek( M->USUARIO ))

   while VEN004->USUARIO = M->USUARIO .and. VEN004->( ! eof() )

      while VEN004->( ! rlock()); end
      VEN004->USUARIO := space(30)
      VEN004->PEDVEN  := X_PEDVEN
      VEN004->( dbunlock() )

      VEN006->( dbappend() )

      VEN006->PEDVEN     := X_PEDVEN
      VEN006->SEQUENC    := VEN004->SEQUENC
      VEN006->FORMA      := VEN004->FORMA
      VEN006->TIPO       := VEN004->TIPO
      VEN006->ESTADO     := VEN004->ESTADO
      VEN006->BIT_MM     := VEN004->BIT_MM
      VEN006->ESP_MM     := VEN004->ESP_MM
      VEN006->BIT_INT    := VEN004->BIT_INT
      VEN006->BIT_FN     := VEN004->BIT_FN
      VEN006->BIT_FD     := VEN004->BIT_FD
      VEN006->ESP_INT    := VEN004->ESP_INT
      VEN006->ESP_FN     := VEN004->ESP_FN
      VEN006->ESP_FD     := VEN004->ESP_FD

      VEN006->TIPO_SEP   := VEN004->TIPOEST
      VEN006->ESTOQUE    := VEN004->TIPOEST

      VEN006->COMPRIM    := VEN004->COMPRIM
      VEN006->LARGURA    := VEN004->LARGURA
      VEN006->PESO_TEO   := VEN004->PESO_TEO
      VEN006->PRECO      := VEN004->PRECO
      VEN006->QTD_PECAS  := VEN004->QTD_PECAS

      // ----------------------------------- //
      VEN006->COM_VEND    := VEN006->COM_VEND
      VEN006->COM_COMP    := VEN006->COM_COMP
      VEN006->PER_ACRES   := VEN006->PER_ACRES
      VEN006->TIPO_SEP    := VEN006->TIPO_SEP
      VEN006->PESO_BALAN  := VEN006->PESO_BALAN
      VEN006->DT_PEDVEN   := VEN006->DT_PEDVEN
      VEN006->DT_EMISSAO  := VEN006->DT_EMISSAO
      VEN006->DT_SEPARA   := VEN006->DT_SEPARA
      VEN006->SEQ_SEPARA  := VEN006->SEQ_SEPARA
      VEN006->PESO_COBRA  := VEN006->PESO_COBRA
      VEN006->NOTAFISCAL  := VEN006->NOTAFISCAL
      VEN006->CONSULTA    := VEN004->CONSULTA
      VEN006->( dbunlock() )
      VEN004->( dbskip())
   end

   VEN005->( dbsetorder(1) )
   VEN005->( dbappend())
   while VEN005->( ! rlock() ); end

   VEN005->PEDVEN    := X_PEDVEN
   VEN005->CODCLI    := X_CODCLI
   VEN005->DT_PEDIDO := date()
   VEN005->COMPRADOR := X_COMPRADOR
   VEN005->ORDCOMPRA := X_ORDCOMPRA
   exit
end

VEN004->( dbsetorder(1) )

if lastkey() != K_ESC
   mensbeep("Pedido Criado. <ENTER>")
end

return

/*
-------------------------------------------------------------------------------
                           tran_TELA31
-------------------------------------------------------------------------------
*/
procedure tran_tela31()

   @ 02,02 say 'ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿'
   @ 03,02 say '³                                CONSULTA                                  ³'
   @ 04,02 say 'ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´'
   @ 05,02 say '³  Cliente                    Comprador                   Data da Consulta ³'
   @ 06,02 say '³                                                                          ³'
   @ 07,02 say 'ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´'
   @ 08,02 say '³Consulta For Tipo  Bit/Esp  Bit/Larg    Largura Comprimento Pecas  Preco U³'
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
   @ 20,02 say '³               ³  <F4> Marcar  ³               ³ <F6> Fechar     ³        ³'
   @ 21,02 say '³               ³       Item    ³               ³      Pedido     ³        ³'
   @ 22,02 say 'ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÙ'

return

/*
-------------------------------------------------------------------------------
                           item_zap31
-------------------------------------------------------------------------------
*/
function item_zap31( P_CONSULTA )

   if Conf('Confirma Exclusao Total da Consulta ?')
      select VEN004
      VEN004->( dbsetorder(1) )
      VEN004->( dbgotop() )
      VEN004->( dbseek( P_CONSULTA ))
      if VEN004->( found() )
         while VEN004->( ! eof() ) .and. VEN004->CONSULTA=P_CONSULTA
            VEN004->( dbdelete() )
            VEN004->( dbskip()   )
         end
      end
   end

return WRET

