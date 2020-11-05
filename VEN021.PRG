/*
   Vendas
   VEN021.PRG - Consulta de Compra
*/
#include "inkey.ch"

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
abrir("VEN023")
abrir("VEN024")
abrir("CR0300")
abrir("CR0400")   
abrir("CR0500")   
abrir("SR0300")
abrir("SR0400")   
abrir("SR0500")   
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
private  TITULO      := " Consulta "
private  LININI      := 04
private  LINFIM      := 20
private  COLINI      := 00
private  COLFIM      := 79
private  BLOCK_DISP  := {|| .T. }
private  CAB_TITULO  := nil
private  BORDA       := 1
private  FLAG        := .T.
private  TECLA       := nil
private  TABELA      := nil

private  W_COMISVEN  := 0
private  W_DESCMAX   := 0

aadd( CAMPO     , "CONSULTA" )
aadd( CAMPO     , "DT_CONS" )
aadd( CAMPO     , "GUERRA" )
aadd( CAMPO     , "CLIENTE" )
aadd( CAMPO     , "COMPRADOR" )
aadd( CAMPO     , "CODVEN" )
aadd( CAMPO     , "STATUS" )
aadd( CAMPO     , "QTD_ITENS" )
aadd( CAMPO     , "VALOR" )

aadd( MASCARA   , "XXXXXX"         )
aadd( MASCARA   , "99/99/99"       )
aadd( MASCARA   , "XXXXXXXXXXXXXX" )
aadd( MASCARA   , "XXXXXXXXXXXXXX" )
aadd( MASCARA   , "XXXXXXXXXXXXXX" )
aadd( MASCARA   , "XX"             )
aadd( MASCARA   , "XX"             )
aadd( MASCARA   , "9999"           )
aadd( MASCARA   , "@E 9,999,999.99"   )

aadd( CABECALHO , "Consulta"  )
aadd( CABECALHO , "Data"      )
aadd( CABECALHO , "Cliente"   )
aadd( CABECALHO , "Cliente D" )
aadd( CABECALHO , "Comprador" )
aadd( CABECALHO , "Vendedor"  )
aadd( CABECALHO , "St"        )
aadd( CABECALHO , "Itens"     )
aadd( CABECALHO , "Valor"     )

aadd( TAMANHO   , 06 )
aadd( TAMANHO   , 08 )
aadd( TAMANHO   , 10 )
aadd( TAMANHO   , 10 )
aadd( TAMANHO   , 10 )
aadd( TAMANHO   , 02 )
aadd( TAMANHO   , 02 )
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
aadd( W_FILE , "VEN003" )

// VARIAVEIS
PRIVATE FLG_TV:='N',X_CODVENC := S_CODVENC:= S_FORMAPAG:=X_FORMAPAG:='  '
private X_TEL := SPACE(17)
PRIVATE W_SEQ_CONS  := 0,;
	W_UNIDADE   := space(1),;
	W_VALOR     := 0.00,;
	X_T_ITEM    := X_TOT := 0.00,;
	W_QTD       := 0,;
        X_QTD_KGT   := 0.00,;
	W_LIBERACAO := .F.,;
	X,;
	X_CONSULTA   := SPACE(06)

// --> VEN003 -> CONSULTA
private  X_CONSULTA   := space(06)          ,;
	 X_CODCLI     := space(5)           ,;
	 X_CLIENTE    := space(20)          ,;
	 X_DT_CONS    := Date()             ,;
	 X_COMPRADOR  := space(20)          ,;
	 X_CODVEN     := space(02)          ,;
	 X_QTD_ITENS  := 1                  ,;
	 X_VALOR      := 0.00               ,;
         X_OBS        := space(40)          ,;
         X_OBSERVACAO := space(65)


// --> VEN004 -> ITEM_CONSULTA
private  X_CONSULTA := Space(06)         ,;
	 X_SEQUENC  := Space(03)         ,;
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
	 X_ESPESSURA:= 0                 ,;
	 X_COMPRIM  := 0                 ,;
	 X_LARGURA  := 0                 ,;
	 X_QTD_PECAS:= 0.0               ,;
	 X_PESO_TEO := 0.0               ,;
	 X_PESO_COBRA :=0.0              ,;
	 X_PESO_BALAN :=0.0              ,;
	 X_PESO_ITEM  :=0.0              ,;
	 X_PRECO    := 0.0               ,;
	 X_DT_VALID := ctod( '  /  /  ' ),;
	 X_PEDVEN   := space(06)         ,;
	 X_STATUS   := space(01)         ,;
	 X_UNIDADE  := 'K'               ,;
	 X_SUBFORMA := ' '               ,;
	 W_DIGITACAO:= ' '               ,;
	 W_PRCBASKG := 0.00              ,;
	 F_PRECOEXTERNO := .F.            ,;
	 F_MATNOTFOUND  := .T.            ,;
         X_TIPO_SEP := 'E'
	 

private  W_COMISCOM := 0.00,;
	 W_DESCONTO := 0.00,;
	 W_COMISVEN := 0.00,;
	 W_PRECOTAB := 0.00,;
	 W_PRECO_ORIGINAL := 0.00,;
	 W_PESOPECA := 0.00,;
	 W_PESOMTR  := 0.00,;
	 W_CUSTO    := 0.00

private  X_GRUPO      := space(2),;
	 X_SUBGRUPO   := space(2),;
	 X_COLUNA     := space(2),;
	 X_SUBFATOR   := space(2),;
	 X_P_MATERIAL := 0       ,;
	 X_P_CORTE    := 0       ,;
	 WCOR         := ' '     ,;
         X_PMEDCORTE  := ' '     ,;
	 P_BASECCOMP  := 0.00


private W_CHAVE_ITEM, X_SEQUENC, W_TOT_ITEM, W_PRECOKG,X_ITENS := 0


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
	 X_PESO_TEO := 0.0       ,;
	 X_PESO_COBRA :=  0.0       ,;
	 X_PESO_BALAN :=  0.0       ,;
	 X_PRECO    := 0.0       ,;
	 X_DT_VALID := ctod( '  /  /  ' ),;
	 X_PEDVEN   := space(06)         ,;
	 X_SEPARA   := space(01)         ,;
	 X_STATUS   := space(01)


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

do while CONTINUA .and. ( (TEC:=tabmov(TABELA)) != K_ESC )

	X_CODCLI   := VEN003->CODCLI
	X_CONSULTA := VEN003->CONSULTA
	setcursor(1)

	setcolor( W_CORGET )
	do case
		case TEC == 28 ; help("VEN021")               
		case TEC == 27 ; return 0

		case lastkey() = K_F3
		   cons_inclui21()
		   restscreen(,,,,W_TEL21)
		   ven021_itens()
		   tabela:refreshall()

		case lastkey() = K_F4
		    if VEN003->( ! eof() )
		      cons_altera21()
		      restscreen(,,,,W_TEL21)
		      tabela:refreshall()
		    end 
		case lastkey() = K_F6
		   if VEN003->( ! eof() )
		     p321_busca( .F. )
		     restscreen(,,,,W_TEL21)
		     tabela:refreshall()
		   end  


		case lastkey() = K_F5

	 if VEN003->( ! eof() )
		 cons_exclui21()
		 restscreen(,,,,W_TEL21)
		 tabela:refreshall()
	 end

		case lastkey() = K_ENTER
	 
	 if VEN003->( ! eof() )
		 cons_consulta21()
		 restscreen(,,,,W_TEL21)
		 tabela:refreshall()
		 VEN003->(DBSETORDER(1))
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
VEN003->( dbsetorder(1) )
return

/*
-------------------------------------------------------------------------------
				CONS_ALTERA21
-------------------------------------------------------------------------------
*/
Function cons_altera21()

 local W_OLDSCR := savescreen()
 OLDORD := VEN003->( dbsetorder() )
 cons_atrib21()
 cons_tedit21()
 cons_show21()
 
 X_CONSULTA := VEN003->CONSULTA
 X_DT_CONS  := VEN003->DT_CONS
 
 if cons_get21("ALTERAR")
	cons_grava21( X_CONSULTA )
	item_c_edit21("Altera")
 end
 VEN003->( DBSETORDER(OLDORD))

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
 VEN003->( dbsetorder( 1 ) )
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
X_QTD_ITENS  := 1
X_VALOR      := 0.00
X_OBS        := space(40)

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
X_OBS       := VEN003->OBS

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
	 
while .t.
  @ 02,43 get X_CODCLI       picture "@!"   VALID tes_codcli( X_CODCLI,02,43,20 )
  read
  if LASTKEY()=27;EXIT;end

  W_COMISCOM := VEN001->COMISSAO

  IF P_ACAO='INCLUIR'
	 X_CODVEN    := VEN001->CODVEN
	 X_COMPRADOR := VEN001->COMPRADOR
  END
  IF X_CODCLI #'00000'
    TES_CODVEN(X_CODVEN,05,43,20)
  END
  @ 03,43 get X_CLIENTE      picture "@!"   when X_CODCLI ='00000'
  @ 04,43 get X_COMPRADOR    picture "@!"
  @ 05,43 get X_CODVEN       picture "@!" valid tes_codven(X_CODVEN,05,43,20) when X_CODCLI = '00000'
  @ 05,09 get X_OBS          picture "@S18"
  read
  if LASTKEY()= 27 ;LOOP;end

  EXIT
end

return  WRET

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
                 if VEN004->TIPOEST = 'R'
                   VEN023->(dbsetorder(1))
                   if VEN023->(dbseek(VEN004->CONSULTA+STR(VEN004->SEQUENC)))

                     while VEN023->( ! rlock() ); end
                     VEN023->( dbdelete() )
                     VEN023->(dbunlock())
                   end
                 end
                  VEN004->( dbdelete() )
                  VEN004->(dbunlock())
                  VEN004->( dbskip()   )
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


 //
// -------------------------  FIM DO PROGRAMA PRINCIPAL -----------------------
//
//

/*
 -------------------------------------------------------------------------------
				P31_MARCAITEM
-------------------------------------------------------------------------------
*/
Procedure P31_MARCAITEM
 if empty(VEN004->USUARIO) 
   if VEN004->TIPOEST = 'R'
     fornece023()
   end
     SELE VEN004
     while VEN004->( ! rlock() ); end
     VEN004->USUARIO := C_ACESSO
 else  
     while VEN004->( ! rlock() ); end
     VEN004->USUARIO := space(30)
 end
 VEN004->( dbunlock() )
return

/*
-------------------------------------------------------------------------------
                                P31_FECHAPEDIDO
-------------------------------------------------------------------------------
*/
Procedure P31_FECHAPEDIDO

   local W_OLDREC := VEN004->( recno() ),flag := .f.
   private X_TIPOVENDA:= S_TIPOVENDA := '  '

   VEN004->( dbseek( X_CONSULTA ))
   while VEN004->CONSULTA=X_CONSULTA .and. VEN004->( ! eof() )

      while VEN004->( ! rlock() ); end
      IF VEN004->STATUS #'G'
        IF VEN004->USUARIO = C_ACESSO
          flag := .t.
        END
      END
      VEN004->( dbunlock() )
      VEN004->( dbskip() )
   end
   VEN004->( dbgoto(W_OLDREC))

   if ! FLAG
     mensbeep('Por favor, marque  o item ! <ENTER>')
     return
   end

   X_PEDVEN    := space(5)
   X_CODVEN    := VEN001->CODVEN
   // X_COMPRADOR := VEN001->COMPRADOR
   X_ORDCOMPRA := space(10)

   @ 08,03 say 'ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ Fechamento de Pedido ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿'
   @ 09,03 say '³                                                                         ³'
   @ 10,03 say '³ N§ Pedido......:                           Tel.:                        ³'
   @ 11,03 say '³ Cliente  ......:                                                        ³'
   @ 12,03 say '³ Comprador......:                                                        ³'
   @ 13,03 say '³ Tipo de Venda..:                                                        ³'
   @ 14,03 say '³ Conds.Pag......:                                                        ³'
   @ 15,03 say '³ Form.Pagamento.:                                                        ³'
   @ 16,03 say '³ Ordem de compra:                                                        ³'
   @ 17,03 say 'ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ'
   sombra( 08, 03, 17, 77 )

   while .t.

      while VEN004->( ! rlock() ); end
      VEN004->( dbsetorder(1) )

      if VEN004->( dbseek( X_CONSULTA ) )
         if ! empty( VEN004->PEDVEN )
            if pergresp( "Incluir no mesmo pedido <S/N>?","SN") ='N'
               FLAG:=.T.
            else
               X_PEDVEN    := VEN004->PEDVEN
               VEN005->(dbseek( strzero(val(X_PEDVEN))))
               FLG_TV      := VEN005->FLG_TV
               if FLG_TV = 'N'
                  X_TIPOVENDA := VEN005->TIPOVENDA
                  X_CODVENC   := VEN005->CODVENC
                  X_FORMAPAG  := VEN005->FORMAPAG
               else
                  S_TIPOVENDA := VEN005->TIPOVENDA
                  S_CODVENC   := VEN005->CODVENC
                  S_FORMAPAG  := VEN005->FORMAPAG
               end
               X_COMPRADOR := VEN005->COMPRADOR
               X_CODVEN    := VEN005->CODVEN
               X_ORDCOMPRA := VEN005->ORDCOMPRA
               FLAG:=.F.
            end
         end
      end

      VEN004->(DBUNLOCK())

      if ! FLAG
         @ 10,23 say 'Item do pedido : '+X_PEDVEN
      else
         @ 10,23 say X_PEDVEN
      endif

      @ 11,23 get X_CODCLI    picture "@!" valid tes_codcli( X_CODCLI,11,23 )
      @ 10,55 get X_TEL       picture "(9999)9999-9999"
      @ 12,23 get X_COMPRADOR picture "@!"
      read

      if FLAG
         FLG_TV := pergresp( "(N)ormal  (C)ontra retirada (N/C) ?","NC")
         FLG_TV := if(FLG_TV $ 'NC',FLG_TV,'N')
      end

      if FLG_TV = 'N'
         if flag = .f.
            tes_tipovenda(13,23,45)
            tes_codvecm(14,23,30)
            tes_formapag(15,23,30)
         else
            @ 13,23 get X_TIPOVENDA picture "99" valid tes_tipovenda(13,23,45)
            @ 14,23 get X_CODVENC   picture "99" valid tes_codvecm(14,23,30);
                                    when CR0300->PARCELA = 'X'

            @ 15,23 get X_FORMAPAG   picture "99" valid tes_formapag(15,23,30)
         end
      else
         if flag = .f.
            tes_Stipovenda(13,23,45)
            tes_Scodvecm(14,23,30)
            tes_Sformapag(15,23,30)
         else
            @ 13,23 get S_TIPOVENDA picture "99" valid tes_Stipovenda(13,23,45)
            @ 14,23 get S_CODVENC   picture "99" valid tes_Scodvecm(14,23,30);
                                    when SR0300->PARCELA = 'X'
            @ 15,23 get S_FORMAPAG   picture "99" valid tes_Sformapag(15,23,30)
         end
      end

      @ 16,23 get X_ORDCOMPRA picture "@!"
      read
      if lastkey() = K_ESC; exit; end

      VEN004->( dbsetorder(2) )
      VEN004->( dbseek( X_CONSULTA+space(29)+C_ACESSO ,.t.))
      VEN023->( dbsetorder(1) )
      if ! FLAG
         @ 10,23 say 'Item do pedido : '+X_PEDVEN
      else
         X_PEDVEN := VEN005->( gera_pedido( "VEN005->PEDVEN" ) )
         @ 10,23 say X_PEDVEN
      endif

      while (VEN004->USUARIO = C_ACESSO .and. VEN004->CONSULTA = X_CONSULTA)
         X_ITENS++
         X_T_ITEM += VEN004->PRECO
         while VEN004->( ! rlock() ); end

         VEN004->USUARIO := space(30)
         VEN004->PEDVEN  := X_PEDVEN
         VEN004->STATUS  := 'G'
         VEN004->( dbunlock() )

         VEN006->( dbappend() )

         VEN006->PEDVEN     := X_PEDVEN
         VEN006->SEQUENC    := X_QTD_ITENS
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
         VEN006->ESPESSURA  := VEN004->ESPESSURA
         VEN006->PESO_ITEM  := VEN004->PESO_ITEM
         VEN006->PESO_TEO   := VEN004->PESO_ITEM
         VEN006->PRECO      := VEN004->PRECO
         VEN006->PRECO_UNI  := VEN004->PRECOTAB
         VEN006->QTD_PECAS  := VEN004->QTD_PECAS
         VEN006->DIGITACAO  := VEN004->DIGITACAO

         // ----------------------------------- //
         VEN006->COM_Vend    := VEN004->COM_Vend
         VEN006->COM_COMP    := VEN004->COM_COMP
         VEN006->PER_ACRES   := VEN006->PER_ACRES
         VEN006->TIPO_SEP    := VEN006->TIPO_SEP
         VEN006->PESO_BALAN  := VEN004->PESO_BALAN
         VEN006->DT_PEDVEN   := VEN006->DT_PEDVEN
         VEN006->DT_EMISSAO  := date()
         VEN006->DT_SEPARA   := VEN006->DT_SEPARA
         VEN006->SEPARADO    := ' '
         VEN006->SEQ_SEPARA  := VEN006->SEQ_SEPARA
         VEN006->PESO_COBRA  := VEN004->PESO_COBRA
         VEN006->NOTAFISCAL  := VEN006->NOTAFISCAL
         VEN006->CONSULTA    := VEN004->CONSULTA
         VEN006->ESTOQUE     := VEN004->TIPOEST
         VEN006->SUBFORMA    := VEN004->SUBFORMA
         VEN006->UNIDADE     := VEN004->UNIDADE
         VEN006->PES_MATNOT  := VEN004->PES_MATNOT
         VEN006->OBSERVACAO  := VEN004->OBSERVACAO
         estoque(.T.)
         VEN023->(dbseek( VEN004->CONSULTA+STR(VEN004->SEQUENC,3)))

         while VEN023->( ! rlock() ); end

         VEN023->PEDVEN := VEN006->PEDVEN
         VEN023->ITEM   := VEN006->SEQUENC
         VEN023->( dbunlock() )
         VEN006->( dbunlock() )
         VEN004->( dbskip())
         X_QTD_ITENS++
         if VEN004->(eof()) ; exit ; end
      end

      if FLAG
         VEN005->( dbsetorder(1) )
         VEN005->CODCLI    := X_CODCLI
         VEN005->DT_PEDIDO := date()
         VEN005->COMPRADOR := X_COMPRADOR
         VEN005->ORDCOMPRA := X_ORDCOMPRA
         VEN005->CODVEN    := X_CODVEN
         VEN005->FLG_SEP   := 'N'
         VEN005->VALOR     := X_T_ITEM
         VEN005->QTD_ITENS := X_ITENS
      else
         while VEN005->(!RLOCK()); loop ; end
         VEN005->QTD_ITENS += X_ITENS
         VEN005->VALOR     += X_T_ITEM
      end

      if FLG_TV = 'N'
         VEN005->TIPOVENDA   := X_TIPOVENDA
         VEN005->CODVENC     := X_CODVENC
         VEN005->FORMAPAG    := X_FORMAPAG
      else
         VEN005->TIPOVENDA   := S_TIPOVENDA
         VEN005->CODVENC     := S_CODVENC
         VEN005->FORMAPAG    := S_FORMAPAG

      end

      VEN005->FLG_TV    := M->FLG_TV
      VEN005->TELEFONE  := X_TEL
      VEN005->( dbunlock() )
      exit
   end

   if lastkey() != K_ESC
      mensbeep("Pedido Criado. <ENTER>")
   end

   VEN003->( dbseek( X_CONSULTA ))
   while VEN003->( ! rlock() ); end

   if VEN003->QTD_ITENS = VEN005->QTD_ITENS
      VEN003->STATUS := 'T'
   else
      VEN003->STATUS := 'P'
   end

   X_ITENS  := 0
   VEN003->(DBUNLOCK())
   VEN004->( dbsetorder(1) )

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


procedure ven021_itens()

select VEN004
VEN004->( dbgotop())
VEN004->( dbseek( X_CONSULTA ) )

// Atualiza qtde de itens

W_QTDITEM := 0
while VEN004->CONSULTA = X_CONSULTA .and. VEN004->( ! eof() )
	++W_QTDITEM
	VEN004->( dbskip() )
end


VEN003->( dbseek( X_CONSULTA ))
while VEN003->( ! rlock() );end
VEN003->QTD_ITENS := W_QTDITEM
VEN003->( dbunlock() )

return

function p321_busca( flag )
@ 14,24 say "ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿"
if flag
  @ 15,24 say '³ Pedido  :              ³'
else
  @ 15,24 say '³ Consulta:              ³'
end
@ 16,24 say "ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ"

sombra(14,24,16,49)

while .t.
   
   B_PEDVEN     := if(flag,SPACE(5),SPACE(6))

   @ 15,36 get B_PEDVEN     picture "@!" 
   read

   if lastkey()=K_ESC .or. empty(B_PEDVEN) ; exit; end
   if flag
     if VEN005->( dbseek((zerofill(B_PEDVEN)),.t.))
       exit
     end
   else
     if VEN003->( dbseek(( zerofill( B_PEDVEN )) ))
       exit
     end
   end

   setcursor(0)
end
keyboard(chr(32))
return


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
        @ 23,00 say '                                                        Total :                 '
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
	@ 21,00 say 'ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿'
	@ 22,00 say '³ <F3> Incluir   ³ <F5> Excluir    ³ <F8> Recontar Itens    ³                  ³'
	@ 23,00 say '³ <F4> Alterar   ³ <F6> Busca      ³ <ENTER> Consulta       ³                  ³'
	@ 24,00 say 'ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ'

return

