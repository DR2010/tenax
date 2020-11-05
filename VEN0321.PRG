/*
-------------------------------------------------------------------------------
   Vendas
   VEN0321.prg - Manutencao de Pedido dos Clientes / Separacao
-------------------------------------------------------------------------------
*/
#include "inkey.ch"
Local Tela

abrir("EST002")
abrir("EST003")
abrir("EST004")
abrir("EST005")
abrir("EST007")
abrir("EST006")
abrir("EST008")
abrir("VEN001")
abrir("VEN002")
abrir("VEN005")
abrir("VEN006")
abrir("VEN014")
abrir("VEN017")
abrir("VEN016")
abrir("VEN019")
abrir("VEN020")
abrir("VEN023")
abrir("VEN025")
abrir("VEN099")
abrir("CR0300")
abrir("CR0400")
abrir("CR0500")
abrir("SR0300")
abrir("SR0400")
abrir("SR0500")
abrir("ESTREPO")


setcolor(W_CORWD)
status(' P e d i d o ')

// VARIAVEIS

W_SEQ_PED  := 0

X_PEDVEN   := SPACE(05)
private X_TIPOVENDA, S_TIPOVENDA ,W_TIPOEST :=' '
private  X_FORMAPAG, S_FORMAPAG  ,X_FRETE := 0.00
private X_CODVENC,   S_CODVENC   ,X_TELEFONE , X_FLG_TV ,FLG_REVE :=.F.,FLG_EST := .F.,FLG_CHEGAR := .F.

private X_PRAZODT   := ctod(' ')
private X_PRAZOHR   := "10:00"

private  X_GRUPO      := space(2),;
         X_SUBGRUPO   := space(2),;
         X_COLUNA     := space(2),;
         X_SUBFATOR   := space(2)

// --> VEN005 -> Header do Pedido
private  X_CODCLI     := space(05)          ,;
         X_COMPRADOR  := space(20)          ,;
         X_DT_PEDIDO  := ctod( '  /  /  ' )
         X_QTD        := 0

private W_TIPO := ' '

// --> VEN006 -> detalhe do Pedido
private     X_SEQUENC    := 0                  ,;
            X_COMPRIM    := 0.00               ,;
            X_LARGURA    := 0.00               ,;
            X_ESPESSURA  := 0.00               ,; 
            X_PESO_TEO   := 0.00               ,;
            X_QTD_PECAS  := 0                  ,;
            X_COM_VEND   := 0.00               ,;
            X_COM_COMP   := 0.00               ,;
            X_PER_ACRES  := 0.00               ,;
            X_TIPO_SEP   := space(01)          ,;
            X_PESO_BALAN := 0.0                ,;
            X_PESO_ITEM  := 0.0                ,;
            X_DT_PEDIDO  := ctod( '  /  /  ' ) ,;
            X_DT_EMISSAO := ctod( '  /  /  ' ) ,;
            X_DT_SEPARA  := ctod( '  /  /  ' ) ,;
            X_SEQ_SEPARA := 0                  ,;
            X_PESO_COBRA := 0.00               ,;
            X_PRECO      := 0                  ,;
            X_NOTAFISCAL := space(10)          ,;
            X_CONSULTA   := space(08)          ,;
            X_OBS        := space(66)          ,;
            X_CODVEN     := space(02)          ,;
            X_COMPRADOR  := space(20)          ,;
            X_UNIDADE    := 'K'                ,;
            X_PMEDCORTE  := SPACE(1)           ,;
            X_P_CORTE

private  W_COMISVEN  := 0
private  W_DESCMAX   := 0

private W_CHAVE_ITEM,W_LIBERACAO := .F.
private X_CSUB := SPACE(12)

private  W_COMISCOM := 0.00             ,;
         W_DESCONTO := 0.00             ,;
         W_COMISVEN := 0.00             ,;
         W_TOT_ITEM   := 0.0            ,;
         W_PRECOTAB := 0.00             ,;
         W_PRECOKG  := 0.00             ,;
         W_PESOMTR  := 0.00             ,;
         W_PRECO_ORIGINAL := 0.00       ,;
         W_PESOPECA := 0.00             ,;
         X_SUBFORMA := ' '              ,;
         W_DIGITACAO:= ' '              ,;
         W_PRCBASKG := 0.00             ,;
         F_PRECOEXTERNO := .F.           ,;
         F_MATNOTFOUND  := .T.           ,;
         X_TIPOVENDA:= ' ',;
         W_TOT := tot_ped()

VEN001->( dbsetorder(1) )
VEN005->( dbsetorder(1) )
select VEN006
VEN006->( dbsetorder(1) )

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
private  COR         := W_CORWD
private  TITULO      := " Manutencao de Pedido de Venda "
private  LININI      := 02
private  LINFIM      := 19
private  COLINI      := 00
private  COLFIM      := 79
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
aadd( CAMPO     , "QTD_ITENS" )
aadd( CAMPO     , "VALOR"     )

aadd( MASCARA   , "XXXXXX"               )
aadd( MASCARA   , "99/99/99"          )
aadd( MASCARA   , "XXXXX"                )
aadd( MASCARA   , "XXXXXXXXXXXXXXXXXXXX" )
aadd( MASCARA   , "XXXXXXXXXXXX"         )
aadd( MASCARA   , "99"          )
aadd( MASCARA   , "@E 999,999.99"   )

aadd( CABECALHO , "Pedido"       )
aadd( CABECALHO , "Data"         )
aadd( CABECALHO , "Cliente"      )
aadd( CABECALHO , "Razao Social" )
aadd( CABECALHO , "Comprador"    )
aadd( CABECALHO , "It"           )
aadd( CABECALHO , "Valor Teo."        )

aadd( TAMANHO   , 06 )
aadd( TAMANHO   , 08 )
aadd( TAMANHO   , 06 )
aadd( TAMANHO   , 20 )
aadd( TAMANHO   , 12 )
aadd( TAMANHO   , 03 )
aadd( TAMANHO   , 11 )

aadd( W_FILE , "VEN005" )
aadd( W_FILE , "VEN005" )
aadd( W_FILE , "VEN005" )
aadd( W_FILE , "VEN001" )
aadd( W_FILE , "VEN005" )
aadd( W_FILE , "VEN005" )
aadd( W_FILE , "VEN005" )

W_TELA := savescreen(,,,,)

P321_TELA()
telanum('SCR000','VEN0321')

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


   VEN001->( dbsetorder(1) )
   VEN005->( dbsetorder(1) )
   VEN006->( dbsetorder(1) )

   CONTINUA := .T.

   W_TEL21 := savescreen(,,,,)

   @ 21,47 SAY 'Total do pedido :'
   @ 21,65 SAY W_TOT picture "@E 9,999,999.99"

   do while CONTINUA .and. ( (TEC:=tabmov(TABELA)) != K_ESC )
      
      X_CODCLI   := VEN005->CODCLI
      setcursor(1)

      setcolor( W_CORWD )
      do case

         case lastkey() = K_F1
            mensboxv( { " <F4> Alterar ",;
                        " <F5> Excluir ",;
                        " <F6> Buscar  "})

         case lastkey() = K_F4
            P321_altera()

            VEN001->( dbsetorder(1) )
            VEN005->( dbsetorder(1) )
            tabela:refreshall()

         case lastkey() = K_F5
            P321_exclui()

            VEN001->( dbsetorder(1) )
            VEN005->( dbsetorder(1) )
            tabela:refreshall()

         case lastkey() = K_F6
            P321_Busca(.T.)

            VEN001->( dbsetorder(1) )
            VEN005->( dbsetorder(1) )
            tabela:refreshall()
         
         case lastkey() = K_ENTER
            P321_consulta()

            VEN001->( dbsetorder(1) )
            VEN005->( dbsetorder(1) )
            tabela:refreshall()


      endcase

      setcolor( W_CORWD )
      select VEN005
 enddo

   restscreen(,,,,W_TELA)
   tabela:refreshall()
   dbcloseall()
   exit
end

return

/*
-------------------------------------------------------------------------------
                           P321_INCLUI
-------------------------------------------------------------------------------
*/
Function P321_inclui()
local W_OLDSCR := savescreen()

P321_zera()
P321_tedit()

VEN005->( dbsetorder(1) )
X_PEDVEN := VEN005->( gera_consulta( "VEN005->PEDVEN" ) )
@ 03,16 get X_PEDVEN picture "@!" valid ! v_acha_pedido( X_PEDVEN )
read

if lastkey() # K_ESC
   VEN005->( dbsetorder(1))
   VEN005->( dbseek( X_PEDVEN ))

   if VEN005->( ! found() )
      if P321_get()
         P321_grava("I") // inclui header
         P331_edit("Altera")
      end
   else
      message('Pedido Ja Cadastrado. <ENTER>')
   end
end
restscreen(,,,,w_oldscr)
return

/*
-------------------------------------------------------------------------------
                           P321_ALTERA
-------------------------------------------------------------------------------
*/
Function P321_altera()
local W_OLDSCR := savescreen()

P321_atrib()
P321_tedit()
P321_show()

X_PEDVEN := VEN005->PEDVEN
if P321_get()
   P321_grava("A")
   P331_edit("Altera")
end
restscreen(,,,,w_oldscr)
return

/*
-------------------------------------------------------------------------------
                           P321_CONSULTA
-------------------------------------------------------------------------------
*/
Function P321_consulta()
local W_OLDSCR := savescreen()

X_PEDVEN := VEN005->PEDVEN
P321_atrib()
P321_tedit()
P321_show()
// P321_get(.T.)
P331_edit("Consulta")
restscreen(,,,,w_oldscr)
return

/*
-------------------------------------------------------------------------------
                           P321_EXCLUI
-------------------------------------------------------------------------------
*/
Function P321_exclui()
local W_OLDSCR := savescreen()

if conf(' Confirma Exclusao ')
   P331_zap( VEN005->PEDVEN )
   while VEN005->( ! rlock() ); end
   VEN005->( dbdelete() )
   VEN005->( dbgotop())
end

select VEN005
restscreen(,,,,w_oldscr)
return

/*
-------------------------------------------------------------------------------
                           P321_ZERA
-------------------------------------------------------------------------------
*/
procedure P321_zera()

 X_CODCLI     := space(05)
 X_COMPRADOR  := space(20)
 X_DT_PEDIDO  := ctod( '  /  /  ' )

return

/*
-------------------------------------------------------------------------------
                           P321_GRAVA
-------------------------------------------------------------------------------
*/
procedure P321_grava( P_MODO )

if P_MODO = "I"
   VEN005->( dbappend() )
else
   while VEN005->( ! rlock() ); end
end

VEN005->CODCLI         := X_CODCLI
VEN005->CODVENC        := X_CODVENC
VEN005->COMPRADOR      := X_COMPRADOR
VEN005->DT_PEDIDO      := X_DT_PEDIDO
VEN005->FLG_TV         := X_FLG_TV
VEN005->FORMAPAG       := X_FORMAPAG
VEN005->FRETE          := X_FRETE
VEN005->PEDVEN         := X_PEDVEN
VEN005->TELEFONE       := X_TELEFONE
VEN005->TIPOVENDA      := X_TIPOVENDA

return

/*
-------------------------------------------------------------------------------
                           P321_ATRIB
-------------------------------------------------------------------------------
*/
procedure P321_atrib()

X_CODCLI        := VEN005->CODCLI
X_COMPRADOR     := VEN005->COMPRADOR
X_DT_PEDIDO     := VEN005->DT_PEDIDO
X_FLG_TV        := VEN005->FLG_TV

X_FRETE         := VEN005->FRETE
X_PEDVEN        := VEN005->PEDVEN
X_TELEFONE      := VEN005->TELEFONE

S_TIPOVENDA := X_TIPOVENDA  := VEN005->TIPOVENDA
S_FORMAPAG  := X_FORMAPAG   := VEN005->FORMAPAG
S_CODVENC   := X_CODVENC    := VEN005->CODVENC

return

/*
-------------------------------------------------------------------------------
                           P321_SHOW
-------------------------------------------------------------------------------
*/
procedure P321_show()

@ 03,12 say VEN005->PEDVEN
@ 03,34 say VEN005->CODCLI
@ 04,63 say VEN005->DT_PEDIDO
@ 03,63 say VEN005->TELEFONE  picture "(9999)9999-9999"
@ 06,63 say VEN005->FRETE     picture '@E 999,999.99'

IF VEN005->FLG_TV = 'N'
   tes_tipovenda(04,12,45)
   tes_codvecm(05,12,30)
   tes_formapag(06,12,30)

else
   tes_Stipovenda(04,12,45)
   tes_Scodvecm(05,12,30)
   tes_Sformapag(06,12,30)
end

return

/*
-------------------------------------------------------------------------------
                           P321_GET
-------------------------------------------------------------------------------
*/
function P321_get(T)
local WRET := .T.
@ 03,34 get X_CODCLI    valid tes_codcli( X_CODCLI, 03, 34, 12)
@ 03,63 get X_TELEFONE  picture "(9999)9999-9999"
read

O_FLG_TV := X_FLG_TV
X_FLG_TV := pergresp( "(N)ormal  (C)ontra retirada (N/C) ?","XNC")

// Verifica se o usuario pressionou ENTER
X_FLG_TV := if( X_FLG_TV = 'X', O_FLG_TV, X_FLG_TV )

if VEN005->FLG_TV <> X_FLG_TV

   S_TIPOVENDA :=  X_TIPOVENDA := space(02)
   S_CODVENC   :=  X_CODVENC   := space(02)
   S_FORMAPAG  :=  X_FORMAPAG  := space(02)

   @ 04,12 say space(40)
   @ 05,12 say space(66)
   @ 06,12 say space(40)

end

IF X_FLG_TV = 'N' // Normal

  @ 04,12 get X_TIPOVENDA picture "99" valid tes_tipovenda(04,12,45)

  @ 05,12 get X_CODVENC   picture "99" valid tes_codvecm(05,12,30);
			       when CR0300->PARCELA = 'X'

  @ 06,12 get X_FORMAPAG  picture "99" valid tes_formapag(06,12,30)

else

  @ 04,12 get S_TIPOVENDA picture "99" valid tes_stipovenda(04,12,45)

  @ 05,12 get S_CODVENC   picture "99" valid tes_scodvecm(05,12,30);
                               when SR0300->PARCELA = 'X'

  @ 06,12 get S_FORMAPAG  picture "99" valid tes_sformapag(06,12,30)

end

@ 06,63 get X_FRETE  picture "@E 9999,999.99"
IF T#NIL
  CLEAR GETS
ELSE
  read
END
if lastkey()=K_ESC; WRET := .F.; end

X_TIPOVENDA := if( X_FLG_TV = 'N', X_TIPOVENDA, S_TIPOVENDA )
X_CODVENC   := if( X_FLG_TV = 'N', X_CODVENC,   S_CODVENC   )
X_FORMAPAG  := if( X_FLG_TV = 'N', X_FORMAPAG,  S_FORMAPAG  )

return  WRET

/*
-------------------------------------------------------------------------------
                           P321_TEDIT
-------------------------------------------------------------------------------
*/
procedure P321_tedit()

   @ 02,00 say 'ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿'
   @ 03,00 say '³ N£mero..:            Cliente..:                         Tel:                 ³'
   @ 04,00 say '³ Tipo Ven:                                         Data.....:                 ³'
   @ 05,00 say '³ Cond Pag:                                                                    ³'
   @ 06,00 say '³ Form Pag:                                           Frete.:                  ³'
   @ 07,00 say 'ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ'
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
                                                                                   
return

/*
-------------------------------------------------------------------------------
                           P321_TELA
-------------------------------------------------------------------------------
*/
procedure P321_TELA()

   @ 20,00 say 'ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿'
   @ 21,00 say '³                                                                              ³'
   @ 22,00 say 'ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ'

return


function tot_ped()
   local tot := 0.00
   VEN006->(dbgotop())
   while VEN006->(!eof())
      TOT += VEN006->PRECO
      VEN006->(DBSKIP())
   end
return (tot)

function test(t)

if T=NIL 


  X_FLG_TV := pergresp( "(N)ormal  (C)ontra retirada (N/C) ?","NC")

end
return .t.

