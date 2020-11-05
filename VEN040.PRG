/*
-------------------------------------------------------------------------------
   EST - Controle de Estoque
   VEN21.PRG - CONSULTA de Compra
-------------------------------------------------------------------------------
*/
#include "inkey.ch"

Local Tela

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
abrir("EST008")
abrir("VEN001")
abrir("VEN002")
abrir("VEN003")
abrir("VEN004")
abrir("VEN005")
abrir("VEN006")
abrir("VEN014")
abrir("VEN017")
abrir("VEN018")
abrir("VEN019")
abrir("VEN020")
abrir("DIREITO")

setcolor(W_COREDIT)
status('C o n s u l t a')

// TBROWSE

private  W_FILE      := {}
private  CAMPO       := {}
private  MASCARA     := {}
private  CABECALHO   := {}
private  TAMANHO     := {}
private  BESCAPE     := {|| .T. }
private  COR         := W_COREDIT
private  TITULO      := " Consultas "
private  LININI      := 04
private  LINFIM      := 20
private  COLINI      := 00
private  COLFIM      := 79
private  BLOCK_DISP  := {|| .T. }
private  CAB_TITULO  := nil
private  BORDA       := 1

private  TECLA       := nil
private  TABELA      := nil

aadd( CAMPO     , "CONSULTA" )
aadd( CAMPO     , "DT_CONS" )
aadd( CAMPO     , "RAZAO" )
aadd( CAMPO     , "CLIENTE" )
aadd( CAMPO     , "COMPRADOR" )
aadd( CAMPO     , "CODVEN" )
aadd( CAMPO     , "QTD_ITENS" )
aadd( CAMPO     , "VALOR" )

aadd( MASCARA   , "XXXXXX"                )
aadd( MASCARA   , "99/99/99"           )
aadd( MASCARA   , "XXXXXXXXXXXXXX"  )
aadd( MASCARA   , "XXXXXXXXXXXXXX"  )
aadd( MASCARA   , "XXXXXXXXXXXXXX"  )
aadd( MASCARA   , "XXXX"                    )
aadd( MASCARA   , "9999"                    )
aadd( MASCARA   , "999999999.99"          )

aadd( CABECALHO , "Consulta"  )
aadd( CABECALHO , "Data"      )
aadd( CABECALHO , "Cliente"   )
aadd( CABECALHO , "Cliente D" )
aadd( CABECALHO , "Comprador" )
aadd( CABECALHO , "Vendedor"  )
aadd( CABECALHO , "Itens"     )
aadd( CABECALHO , "Valor"     )

aadd( TAMANHO   , 06 )
aadd( TAMANHO   , 08 )
aadd( TAMANHO   , 10 )
aadd( TAMANHO   , 10 )
aadd( TAMANHO   , 10 )
aadd( TAMANHO   , 04 )
aadd( TAMANHO   , 05 )
aadd( TAMANHO   , 14 )

aadd( W_FILE , "VEN003" )
aadd( W_FILE , "VEN003" )
aadd( W_FILE , "VEN001" )
aadd( W_FILE , "VEN003" )
aadd( W_FILE , "VEN003" )
aadd( W_FILE , "VEN003" )
aadd( W_FILE , "VEN003" )
aadd( W_FILE , "VEN003" )

// VARIAVEIS

W_SEQ_CONS  := 0
W_UNIDADE   := space(1)
W_VALOR     := 0.00
W_QTD       := 0
W_LIBERACAO := .F.

X_CONSULTA   := SPACE(05)

// --> VEN003 -> CONSULTA
private  X_CONSULTA   := space(06)          ,;
         X_CODCLI     := space(5)           ,;
         X_CLIENTE    := space(20)          ,;
         X_DT_CONS    := Date()             ,;
	 X_COMPRADOR  := space(20)	    ,;
         X_CODVEN     := space(02)          ,;
         X_QTD_ITENS  := 0                  ,;
         X_VALOR      := 0.00               ,;
	 X_OBS	      := space(40)

// --> VEN004 -> ITEM_CONSULTA
private  X_CONSULTA := Space(06)         ,;
	 X_SEQUENC  := Space(03)	 ,;
	 X_FORMA    := space(03)	 ,;
	 X_TIPO     := space(05)	 ,;
	 X_ESTADO   := space(01)	 ,;
	 X_BIT_MM   := 0.00		 ,;
	 X_ESP_MM   := 0.00		 ,;
	 X_BIT_INT  := space(02)	 ,;
	 X_BIT_FN   := space(02)	 ,;
         X_BIT_FD   := space(02)         ,;
	 X_ESP_INT  := space(02)	 ,;
	 X_ESP_FN   := space(02)	 ,;
         X_ESPESSURA:= 0                 ,;
         X_COMPRIM  := 0                 ,;
	 X_LARGURA  := 0		 ,;
         X_QTD_PECAS:= 0.0               ,;
	 X_PESO_TEO := 0.0		 ,;
         X_PESO_COBRA :=0.0              ,;
         X_PESO_BALAN :=0.0              ,;
         X_PESO_ITEM  :=0.0              ,;
	 X_PRECO    := 0.0		 ,;
	 X_DT_VALID := ctod( '  /  /  ' ),;
	 X_PEDVEN   := space(06)	 ,;
         X_STATUS   := space(01)         ,;
         X_UNIDADE  := 'K'               ,;
         X_SUBFORMA := ' '               ,;
         W_DIGITACAO:= ' '               ,;
         W_PRCBASKG := 0.00              ,;
         F_PRECOEXTERNO:= .F.            ,;
         F_MATNOTFOUND := .T.            ,;
         X_TIPOVENDA:= ' '

private  W_COMISCOM := 0.00,;
         W_DESCONTO := 0.00,;
         W_COMISVEN := 0.00,;
         W_PRECOTAB := 0.00,;
         W_PRECO_ORIGINAL := 0.00,;
         W_PESOPECA := 0.00

private  X_GRUPO      := space(2),;
         X_SUBGRUPO   := space(2),;
         X_COLUNA     := space(2),;
         X_SUBFATOR   := space(2),;
         X_P_MATERIAL := 0       ,;
         X_P_CORTE    := 0       ,;
         WCOR         := ' '


private W_CHAVE_ITEM, X_SEQUENC, W_TOT_ITEM, W_PRECOKG

TELA := wsave(01,02,19,68)

private  X_SEQUENC  := 0	 ,;
	 X_FORMA    := space(03) ,;
	 X_TIPO     := space(05) ,;
	 X_ESTADO   := space(01) ,;
	 X_BIT_MM   := 0.00	 ,;
	 X_ESP_MM   := 0.00	 ,;
	 X_BIT_INT  := space(02) ,;
	 X_BIT_FN   := space(02) ,;
	 X_BIT_FD   := space(02) ,;
	 X_ESP_INT  := space(02) ,;
	 X_ESP_FN   := space(02) ,;
	 X_ESP_FD   := space(02) ,;
	 X_COMPRIM  := 0	 ,;
	 X_LARGURA  := 0	 ,;
	 X_PESO_TEO := 0.0	 ,;
         X_PESO_COBRA :=  0.0       ,;
         X_PESO_BALAN :=  0.0       ,;
	 X_PRECO    := 0.0	 ,;
	 X_DT_VALID := ctod( '  /  /  ' ),;
	 X_PEDVEN   := space(06)	 ,;
         X_SEPARA   := space(01)         ,;
	 X_STATUS   := space(01)

W_TELA := savescreen(,,,,)

cons_tela21()

select VEN001
VEN001->( dbsetorder(1) )

select VEN003
VEN003->( dbsetorder(1) )
VEN003->( dbsetrelation( "VEN001", {|| VEN003->CODCLI }, "VEN003->CODCLI") )

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

/*
cria_but( 17,13,' <F3> Incluir '   ,17,15,"F3")
cria_but( 17,31,' <F4> Alterar '   ,17,33,"F4")
cria_but( 17,51,' <F5> Excluir '   ,17,53,"F5")
*/

do while CONTINUA .and. ( (TEC:=tabmov(TABELA)) != K_ESC )

   X_CODCLI   := VEN003->CODCLI
   X_CONSULTA := VEN003->CONSULTA
   setcursor(1)

   setcolor( W_CORGET )
   do case
      case TEC == 28 ; help() ; return 1
      case TEC == 27 ; return 0

      case lastkey() = K_F3
         cons_inclui21()
         restscreen(,,,,W_TEL21)
         tabela:refreshall()

      case lastkey() = K_F4

         if VEN003->( ! eof() )
            cons_altera21()
            restscreen(,,,,W_TEL21)
            tabela:refreshall()
         end

      case lastkey() = K_F5

         if VEN003->( ! eof() )
            cons_exclui21()
            restscreen(,,,,W_TEL21)
            tabela:refreshall()
         end

      case lastkey() = K_F6

         if VEN003->( ! eof() )
            cons_consulta21()
            restscreen(,,,,W_TEL21)
            tabela:refreshall()
         end

      case lastkey() = K_F7

         if VEN003->( ! eof() )
            f7_pedcon21()
            restscreen(,,,,W_TEL21)
            tabela:refreshall()
         end

      case lastkey() = K_F8

         // Atualiza qtde de itens

         W_QTDITEM := 0

         if VEN003->( ! eof() )
            VEN004->( dbseek( X_CONSULTA ) )
            while VEN004->CONSULTA = X_CONSULTA .and. VEN004->( ! eof() )
               ++W_QTDITEM
               VEN004->( dbskip() )
            end

            VEN003->( dbseek( X_CONSULTA ))
            while VEN003->( ! rlock() );end
            VEN003->QTD_ITENS := W_QTDITEM
            VEN003->( dbunlock() )
         end

   endcase

   setcolor( W_COREDIT )
   select VEN003
enddo

restscreen(,,,,W_TEL21)

dbcloseall()
return

//
//
// -------------------------  FIM DO PROGRAMA PRINCIPAL -----------------------
//
//

/*
-------------------------------------------------------------------------------
			   CONS_INCLUI21
-------------------------------------------------------------------------------
*/
Function cons_inclui21()

local W_OLDSCR := savescreen()

cons_zera21()
cons_tedit21()
VEN003->( dbsetorder(1) )
X_CONSULTA := VEN003->( gera_consulta( "VEN003->CONSULTA" ) )

grava_consulta( X_CONSULTA )

@ 02,09 say X_CONSULTA
@ 03,09 say X_DT_CONS

if cons_get21("INCLUIR")

   cons_grava21( X_CONSULTA ) // inclui header
   item_c_edit21("Altera")
end

return

/*
-------------------------------------------------------------------------------
			   CONS_ALTERA21
-------------------------------------------------------------------------------
*/
Function cons_altera21()

local W_OLDSCR := savescreen()

cons_atrib21()
cons_tedit21()
cons_show21()

X_CONSULTA := VEN003->CONSULTA
X_DT_CONS  := VEN003->DT_CONS

if cons_get21("ALTERAR")

   cons_grava21( X_CONSULTA )
   item_c_edit21("Altera")
end

return

/*
-------------------------------------------------------------------------------
                           CONS_CONSULTA21
-------------------------------------------------------------------------------
*/
Function cons_consulta21()
local W_OLDSCR := savescreen()

X_CONSULTA := VEN003->CONSULTA
X_DT_CONS  := VEN003->DT_CONS

cons_atrib21()
cons_tedit21()
cons_show21()
item_c_edit21("Consulta")

return

/*
-------------------------------------------------------------------------------
			   CONS_EXCLUI21
-------------------------------------------------------------------------------
*/
Function cons_exclui21()
local W_OLDSCR := savescreen()

if conf(' Confirma Exclusao ')
   if item_zap21( VEN003->CONSULTA )
       while VEN003->( ! rlock() ); end
       VEN003->( dbdelete() )
       VEN003->( dbgotop())
    end
end
select VEN003

return

/*
-------------------------------------------------------------------------------
			   CONS_ZERA21
-------------------------------------------------------------------------------
*/
procedure cons_zera21()

X_CODCLI     := space(5)
X_CLIENTE    := space(20)
X_COMPRADOR  := space(20)
X_CODVEN     := space(02)
X_QTD_ITENS  := 0
X_VALOR      := 0.00
X_OBS	     := space(40)

return

/*
-------------------------------------------------------------------------------
                           GRAVA_CONSULTA
-------------------------------------------------------------------------------
*/
procedure grava_consulta()

VEN003->( dbappend() )
VEN003->CONSULTA := X_CONSULTA

return

/*
-------------------------------------------------------------------------------
			   CONS_GRAVA21
-------------------------------------------------------------------------------
*/
procedure cons_grava21( P_CONSULTA )

VEN003->( dbsetorder(1) )
VEN003->( dbseek( P_CONSULTA ) )

if VEN003->( found() )
   while VEN003->( ! rlock() ); end

   VEN003->CLIENTE      := X_CLIENTE
   VEN003->CODCLI       := X_CODCLI
   VEN003->DT_CONS      := Date()
   VEN003->COMPRADOR    := X_COMPRADOR
   VEN003->CODVEN       := X_CODVEN
   VEN003->QTD_ITENS    := X_QTD_ITENS
   VEN003->VALOR        := X_VALOR
   VEN003->OBS          := X_OBS
else
   mensbeep("Erro Grave : Consulta N„o Criada.")
end

return

/*
-------------------------------------------------------------------------------
			    CONS_ATRIB21
-------------------------------------------------------------------------------
*/
procedure cons_atrib21()

X_CODCLI    := VEN003->CODCLI
X_CLIENTE   := VEN003->CLIENTE
X_COMPRADOR := VEN003->COMPRADOR
X_CODVEN    := VEN003->CODVEN
X_QTD_ITENS := VEN003->QTD_ITENS
X_VALOR     := VEN003->VALOR
X_OBS	    := VEN003->OBS

return

/*
-------------------------------------------------------------------------------
			   CONS_SHOW21
-------------------------------------------------------------------------------
*/
procedure cons_show21()

@ 02,09 say VEN003->CONSULTA
@ 03,09 say VEN003->DT_CONS
@ 05,09 say left( VEN003->OBS, 18 )

@ 02,43 say VEN003->CODCLI
tes_codcli( VEN003->CODCLI,02,43,20 )
@ 03,43 say VEN003->CLIENTE
@ 04,43 say VEN003->COMPRADOR
@ 05,43 say VEN003->CODVEN

return

/*
-------------------------------------------------------------------------------
			   CONS_GET21
-------------------------------------------------------------------------------
*/
function cons_get21( P_ACAO )
local WRET := .T.

if P_ACAO = "ALTERAR" .or. P_ACAO = "INCLUIR"
   @ 05,09 get X_OBS          picture "@S18"
end

if P_ACAO = "INCLUIR"
   @ 02,43 get X_CODCLI       picture "@!" valid tes_codcli( X_CODCLI,02,43,20 )
   @ 03,43 get X_CLIENTE      picture "@!" when empty( X_CODCLI )
   @ 04,43 get X_COMPRADOR    picture "@!"
   @ 05,43 get X_CODVEN       picture "@!" valid tes_codven(X_CODVEN,05,43,20)
end

read

if lastkey()=K_ESC; WRET := .F.; end

return	WRET

/*
-------------------------------------------------------------------------------
			   CONS_TEDIT21
-------------------------------------------------------------------------------
*/
procedure cons_tedit21()

   @ 01,00 say 'ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿'
   @ 02,00 say '³ N£m .:                     C¢d Cliente :                                     ³'
   @ 03,00 say '³ Data :                     Cliente ....:                                     ³'
   @ 04,00 say '³                            Comprador ..:                                     ³'
   @ 05,00 say '³ Obs .:                     Vendedor ...:                                     ³'
   @ 06,00 say 'ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ'
   @ 07,00 say '                                                                                '
   @ 08,00 say '                                                                                '
   @ 09,00 say '                                                                                '
   @ 10,00 say '                                                                                '
   @ 11,00 say '                                                                                '
   @ 12,00 say '                                                                                '
   @ 13,00 say '                                                                                '
   @ 14,00 say '                                                                                '
   @ 15,00 say '                                                                                '
   @ 16,00 say '                                                                                '
   @ 17,00 say '                                                                                '
   @ 18,00 say '                                                                                '
   @ 19,00 say '                                                                                '
   @ 20,00 say '                                                                                '
   @ 21,00 say '                                                                                '
   @ 22,00 say '                                                                                '
   @ 23,00 say '                                                                                '
   @ 24,00 say '                                                                                '

return
/*
-------------------------------------------------------------------------------
			   CONS_TELA21
-------------------------------------------------------------------------------
*/
procedure cons_tela21()

   @ 01,00 say 'ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿'
   @ 02,00 say '³                                CONSULTA                                      ³'
   @ 03,00 say 'ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ'
   @ 04,00 say '                                                                                '
   @ 05,00 say '                                                                                '
   @ 06,00 say '                                                                                '
   @ 07,00 say '                                                                                '
   @ 08,00 say '                                                                                '
   @ 09,00 say '                                                                                '
   @ 10,00 say '                                                                                '
   @ 11,00 say '                                                                                '
   @ 12,00 say '                                                                                '
   @ 13,00 say '                                                                                '
   @ 14,00 say '                                                                                '
   @ 15,00 say '                                                                                '
   @ 16,00 say '                                                                                '
   @ 17,00 say '                                                                                '
   @ 18,00 say '                                                                                '
   @ 19,00 say '                                                                                '
   @ 20,00 say '                                                                                '
   @ 21,00 say 'ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄ¿'
   @ 22,00 say '³ <F3> Incluir   ³ <F5> Excluir          ³ <F6> Consultar         ³            ³'
   @ 23,00 say '³ <F4> Alterar   ³ <F8> Recontar Itens   ³ <F7> Gerar Pedido      ³            ³'
   @ 24,00 say 'ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÙ'

return

/*
-------------------------------------------------------------------------------
			   item_zap21
-------------------------------------------------------------------------------
*/
function item_zap21( P_CONSULTA )
private WRET := .F.

   if Conf('Confirma Exclus„o Total da Consulta ?')
      WRET := .T.

      select VEN004
      VEN004->( dbsetorder(1) )
      VEN004->( dbseek( P_CONSULTA ))

      if VEN004->( found() )
	 while VEN004->( ! eof() ) .and. VEN004->CONSULTA=P_CONSULTA
            while VEN004->( ! rlock() ); end
            VEN004->( dbdelete() )
	    VEN004->( dbskip()	 )
	 end
      end
   end

return WRET

/*
-------------------------------------------------------------------------------
			   ACHAR_CONSULTA
-------------------------------------------------------------------------------
*/
function achar_CONSULTA( VAR )

local WRET := .F.

if empty( VAR )
   m_tabelas()
   if lastkey() # K_ESC
      WRET := .T.
   end
else
   VEN003->( dbseek(var) )
   VEN003->( dbsetorder(1) )
   if VEN003->( found() )
      message('CONSULTA Existente. <ENTER>')
      WRET := .T.
   else
      WRET := .F.
   end
end

return WRET

/*
-------------------------------------------------------------------------------
			   GERA_CONSULTA
-------------------------------------------------------------------------------
*/
function GERA_CONSULTA( P_CAMPO )
local WRET

dbgobottom()      //

VAR := &P_CAMPO   // retorna o conteudo do campo
TAM := len( VAR ) // retorna o tamanho

WRET := strzero( val( VAR )+1, TAM) // retorna +1

return WRET


/*
-------------------------------------------------------------------------------
-------------------------------------------------------------------------------
-------------------------------------------------------------------------------
-------------------------------------------------------------------------------
-------------------------------------------------------------------------------
-------------------------------------------------------------------------------
-------------------------------------------------------------------------------
   VEN - Transformacao de Consulta em Pedido
   VEN31.PRG -
-------------------------------------------------------------------------------
-------------------------------------------------------------------------------
-------------------------------------------------------------------------------
-------------------------------------------------------------------------------
-------------------------------------------------------------------------------
-------------------------------------------------------------------------------
*/


/*
-------------------------------------------------------------------------------
                           PEDCON21
-------------------------------------------------------------------------------
*/
function f7_pedcon21()

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

   @ 06,05 say VEN001->RAZAO

   keyboard chr(13)
   while .t.
      W_TELA := savescreen(,,,,)

      // -----------------------------
      //
      // Busca consultas de um cliente
      //
      // -----------------------------

      VEN004->( dbsetorder(1) )
      VEN003->( dbsetorder(3) ) // CODCLI + CONSULTA
      VEN003->( dbseek( X_CODCLI+X_CONSULTA ))

      if VEN003->( found() )

         X:=0
         VEN004->( dbseek(  VEN003->CONSULTA ) )

         // ------------------
         //
         // Seleciona os itens
         //
         // ------------------

         while VEN004->CONSULTA = VEN003->CONSULTA .and. VEN004->(! eof() )

            // ---------------------------------------------------
            // So permite a selecao dos itens nao utilizados por
            // um outro pedido.
            // Caso o campo usuario esteja preenchido, ja pertence
            // a um pedido.
            // ---------------------------------------------------

            if empty( VEN004->PEDVEN )
               ++X
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
               aadd( VET31AUX, VEN003->CODCLI + space(7) + VEN003->COMPRADOR +;
                               space(11) + DTOC( VEN003->DT_CONS ) )
            end
            VEN004->( dbskip() )
         end

         VEN003->( dbsetorder(1) )

         if X > 0
            achoice(09,03,18,76,VET31PRI,,"TRAN_FUNC31")
         else
            mensbeep("Nao existem ¡tens dispon¡veis. <ENTER>")
         end
      end
      restscreen(,,,,W_TELA)
      EXIT
   end
return .T.
VEN005->( dbunlock() )

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
   VET31PRI[WKEYVET] := "*"+substr(VET31PRI[WKEYVET],2,len(VET31PRI[WKEYVET])-1)

   while VEN004->( ! rlock() ); end
   VEN004->USUARIO := M->USUARIO
   VEN004->( dbunlock() )
else
   VET31USU[WKEYVET]   := space(30)
   VET31PRI[WKEYVET] := " "+substr(VET31PRI[WKEYVET],2,len(VET31PRI[WKEYVET])-1)

   while VEN004->( ! rlock() ); end
   VEN004->USUARIO := space(30)
   VEN004->USUARIO := M->USUARIO
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
X_COMPRADOR := space(20)
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

   VEN005->PEDVEN    := X_PEDVEN
   VEN005->CODCLI    := X_CODCLI
   VEN005->DT_PEDIDO := date()
   VEN005->COMPRADOR := X_COMPRADOR
   VEN005->ORDCOMPRA := X_ORDCOMPRA

   VEN005->( dbunlock() )

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

   @ 01,02 say 'ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿'
   @ 02,02 say '³                           ITEM DE CONSULTA                                   ³'
   @ 03,02 say 'ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´'
   @ 04,02 say '³  Cliente                    Comprador                   Data da Consulta     ³'
   @ 05,02 say '³                                                                              ³'
   @ 06,02 say 'ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ'
   @ 07,02 say ' Consulta For Tipo  Bit/Esp  Bit/Larg    Largura Comprimento Pe‡as  Pre‡o U     '
   @ 08,02 say '                                                                                '
   @ 09,02 say '                                                                                '
   @ 10,02 say '                                                                                '
   @ 11,02 say '                                                                                '
   @ 12,02 say '                                                                                '
   @ 13,02 say '                                                                                '
   @ 14,02 say '                                                                                '
   @ 15,02 say '                                                                                '
   @ 16,02 say '                                                                                '
   @ 17,02 say '                                                                                '
   @ 18,02 say '                                                                                '
   @ 19,02 say '                                                                                '
   @ 20,02 say '                                                                                '
   @ 21,02 say 'ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄ¿'
   @ 22,02 say '³               ³  <F4> Marcar  ³               ³ <F6> Fechar     ³            ³'
   @ 23,02 say '³               ³       Item    ³               ³      Pedido     ³            ³'
   @ 24,02 say 'ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÙ'

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
            while VEN004->( ! rlock() ); end
            VEN004->( dbdelete() )
            VEN004->( dbskip()   )
         end
      end
   end

return WRET


