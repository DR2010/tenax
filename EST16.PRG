/*

   SCM - Sistema de Controle Metalurgico
   EST16.PRG - Pedido de Compra

   Dt UltAtu : 11/05/96
   Autor ....: Daniel
   Motivo ...: Estava aceitando a compra de material nao cadastrado

*/
#include "inkey.ch"

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
abrir("ESTM05")
abrir("ESTM06")

setcolor(W_COREDIT)
status('C o m p r a')
telanum('SCR016','EST016')

// TBROWSE

private  W_FILE      := {}
private  CAMPO       := {}
private  MASCARA     := {}
private  CABECALHO   := {}
private  TAMANHO     := {}
private  BESCAPE     := {|| .T. }
private  COR         := W_COREDIT
private  TITULO      := " Compras "
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

aadd( W_FILE , "EST005" )
aadd( W_FILE , "EST005" )
aadd( W_FILE , "EST005" )
aadd( W_FILE , "EST002" )
aadd( W_FILE , "EST005" )
aadd( W_FILE , "EST005" )
aadd( W_FILE , "EST005" )
aadd( W_FILE , "EST005" )

// VARIAVEIS

W_SEQ_PED  := 0

X_PEDIDO   := SPACE(05)

// --> EST005 -> PEDIDO
private  X_FORNECEDOR := space(03)          ,;
	 X_DTPEDIDO   := ctod( '  /  /  ' ) ,;
	 X_DTPED_R    := ctod( '  /  /  ' ) ,;
	 X_STATUS     := space(1)           ,;
	 X_QTD_ITENS  := 0.00,;
	 X_COND_PGTO  := space(20),;
	 X_CONTATO    := space(58)

// --> EST006 -> PEDIDO
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

EST005->( dbsetorder(1) ) // pedido + fornecedor
EST005->( dbgotop() ) // pedido + fornecedor

EST005->( dbsetrelation( "EST006", {|| EST005->PEDIDO },"EST005->PEDIDO" ) )
EST005->( dbsetrelation( "EST002", {|| EST005->FORNECEDOR }, "EST005->FORNECEDOR" ) )

W_TELA := savescreen(,,,,)
ped_tela16()

WTPEDIDOS  := totpedidos()
WTPENDENTE := totpendente()

// EST005->( dbedit(05,03,18,76,P_CAMPOS,"PED_FUNC16",, P_HEADER, P_HDSEP, P_COLSEP))

select EST005

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
      case lastkey() = K_F3
	 ped_inclui16()

	 WTPEDIDOS  := totpedidos()
	 WTPENDENTE := totpendente()

	 restscreen(,,,,W_TEL16)
	 tabela:refreshall()

      case lastkey() = K_F4
	 if EST005->( ! eof() )
	    if empty( EST005->R_DTPED )
	       ped_altera16()
	       WTPEDIDOS  := totpedidos()
	       WTPENDENTE := totpendente()
	       restscreen(,,,,W_TEL16)
	       tabela:refreshall()
	    else
	       mensbeep("Pedido Ja Recebido !")
	    end
	 end

      case lastkey() = K_F5
	 if ! empty( EST005->PEDIDO )
	    ped_exclui16()
	    WTPEDIDOS  := totpedidos()
	    WTPENDENTE := totpendente()
	    restscreen(,,,,W_TEL16)
	    tabela:refreshall()
	 end

      case lastkey() = K_ENTER
	 if ! empty( EST005->PEDIDO )
	    ped_consulta16()
	    tabela:refreshall()
	 end

      case lastkey() = K_F8
	 if ! empty( EST005->PEDIDO )
	    ped_recalc16()
	    tabela:refreshall()
	 end

      case lastkey() = K_F12
	 if EST005->( ! eof() )
	    if empty( EST005->R_DTPED )
	       mensbeep("Pedido Ainda Nao Recebido !")
	    else
	       ped_arqmorto()
	    end
	 end
	 tabela:refreshall()
   endcase
   @ 21,61 say WTPENDENTE picture '999,999,999.99'

   setcolor( W_COREDIT )
   select EST005
enddo

restscreen(,,,,W_TEL16)
dbcloseall()

return

/*
-------------------------------------------------------------------------------
			   PED_INCLUI16
-------------------------------------------------------------------------------
*/
Function ped_inclui16()
local W_OLDSCR := savescreen()

ped_zera16()
ped_tedit16()

X_PEDIDO := novo_pedido()

@ 03,16 say X_PEDIDO
//read

EST005->( dbsetorder(1))
EST005->( dbseek( X_PEDIDO ))

if EST005->( found() )
   EST005->( dbseek(X_PEDIDO) )
   if ped_get16()
      ped_grava16()
      if item_edit16("ALTERA")
	 item_grava16()
      end
   end
else
   mensagem('Pedido N„o Cadastrado. <ENTER>')
end

return

/*
-------------------------------------------------------------------------------
			   PED_ALTERA16
-------------------------------------------------------------------------------
*/
Function ped_altera16()

local W_OLDSCR := savescreen()

ped_atrib16()
ped_tedit16()
ped_show16()

X_PEDIDO := EST005->PEDIDO
if ped_get16()
   ped_grava16()
   if item_edit16("ALTERA")
      item_grava16()
   end
end

return

/*
-------------------------------------------------------------------------------
			   PED_CONSULTA16
-------------------------------------------------------------------------------
*/
Function ped_consulta16()
local W_OLDSCR := savescreen()

ped_atrib16()
ped_tedit16()
ped_show16()
X_PEDIDO := EST005->PEDIDO
item_edit16("CONSULTA")

return

/*
-------------------------------------------------------------------------------
			   PED_EXCLUI16
-------------------------------------------------------------------------------
*/
Function ped_exclui16()
local W_OLDSCR := savescreen()
if pergunta('Confirma Exclusao (S/N) ?')
   if pergunta('Confirma Exclus„o Total do Pedido (S/N) ?')
      item_zap16( EST005->PEDIDO )
      while EST005->( ! rlock() ); end
      EST005->( dbdelete() )
      EST005->( dbunlock() )
      EST005->( dbgotop())
   end
end
select EST005
return

/*
-------------------------------------------------------------------------------
			   PED_ZERA16
-------------------------------------------------------------------------------
*/
procedure ped_zera16()

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
			   PED_GRAVA16
-------------------------------------------------------------------------------
*/
procedure ped_grava16()

while EST005->( ! rlock() ); end

EST005->PEDIDO     := X_PEDIDO
EST005->FORNECEDOR := X_FORNECEDOR
EST005->DTPEDIDO   := X_DTPEDIDO
EST005->R_DTPED    := X_DTPED_R
EST005->STATUS     := X_STATUS
EST005->QTD_ITENS  := X_QTD_ITENS
EST005->COND_PGTO  := X_COND_PGTO
EST005->CONTATO    := X_CONTATO
EST005->TOTAL_PEDI := calc_total( X_PEDIDO, 1 )

EST005->(dbunlock() )

return

/*
-------------------------------------------------------------------------------
			   PED_ATRIB16
-------------------------------------------------------------------------------
*/
procedure ped_atrib16()

X_FORNECEDOR  := EST005->FORNECEDOR
X_DTPEDIDO    := EST005->DTPEDIDO
X_DTPED_R     := EST005->R_DTPED
X_STATUS      := EST005->STATUS
X_QTD_ITENS   := EST005->QTD_ITENS
X_COND_PGTO   := EST005->COND_PGTO
X_CONTATO     := EST005->CONTATO
return

/*
-------------------------------------------------------------------------------
			   PED_SHOW16
-------------------------------------------------------------------------------
*/
procedure ped_show16()

@ 03,16 say EST005->PEDIDO
@ 03,45 say EST005->FORNECEDOR
@ 04,16 say EST005->DTPEDIDO
@ 04,68 say EST005->QTDITPEND picture '999'
@ 05,68 say EST005->R_DTPED
@ 05,21 say EST005->COND_PGTO
@ 06,18 say EST005->CONTATO
return

/*
-------------------------------------------------------------------------------
			   PED_GET16
-------------------------------------------------------------------------------
*/
function ped_get16()
local WRET := .T.

@ 03,45 get X_FORNECEDOR pict"@!" valid tes_forn( X_FORNECEDOR, 3 )

@ 04,16 get X_DTPEDIDO
@ 05,21 get X_COND_PGTO
@ 06,18 get X_CONTATO
read

if lastkey()=K_ESC; WRET := .F.; end

return  WRET

/*
-------------------------------------------------------------------------------
			   PED_TEDIT16
-------------------------------------------------------------------------------
*/
procedure ped_tedit16()

   @ 02,02 say 'ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿'
   @ 03,02 say '³  N£mero ..:                Fornecedor .:     -                           ³'
   @ 04,02 say '³  Data ....:                                Qtde Itens Pendent.:          ³'
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
			   PED_TELA16
-------------------------------------------------------------------------------
*/
procedure ped_tela16()

   @ 02,02 say 'ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿'
   @ 03,02 say '³                         Pedidos de Compra                                ³'
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
   @ 19,02 say 'ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿'
   @ 20,02 say '³ <F3> Inclui     ³ <F4> Altera ³ <F5> Exclui   ³                          ³'
   @ 21,02 say '³ <ENTER> Consulta³ <F8> Recalc ³<F12> Arq.Morto³ Pendente                 ³'
   @ 22,02 say 'ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ'

return

/*
-------------------------------------------------------------------------------
			   item_zap16
-------------------------------------------------------------------------------
*/
function item_zap16( P_PEDIDO )
local WRET := .T.
      select EST006
      EST006->( dbsetorder(1) )
      EST006->( dbgotop() )
      EST006->( dbseek( P_PEDIDO ))
      if EST006->( found() )

	 while EST006->( ! eof() ) .and. EST006->PEDIDO=P_PEDIDO

	    // ---------------------------------------
	    // Atualiza qtde pedida no item de estoque
	    // somente quando o PEDIDO ja tiver sido
	    // RECEBIDO. ( Nota: Nao importa a situacao
	    // do item quando o pedido tiver data de
	    // recebimento )
	    // ---------------------------------------
	    if empty( EST005->R_DTPED )
	       if empty( EST006->R_DTPED )
		  EST007->( dbseek( EST006->FORMA +;
				    EST006->TIPO  +;
			       str( EST006->BIT_MM, 8, 3 ) + ;
			       str( EST006->ESP_MM, 8, 3 ) + ;
				    EST006->ESTADO ) )
		  while EST007->( ! rlock() ); end
		  EST007->QTD_PED := EST007->QTD_PED - EST006->QTD_KG
		  EST007->( dbunlock() )
	       end
	    end

	    while EST006->( ! rlock() ); end
	    EST006->( dbdelete() )
	    EST006->( dbskip()   )
	    EST006->( dbunlock() )
	 end
      end

return WRET

/*
-------------------------------------------------------------------------------
			   ACHAR_PEDIDO
-------------------------------------------------------------------------------
*/
function achar_pedido( VAR )

local WRET := .F.

X_PEDIDO := zerofill( X_PEDIDO )
if empty( VAR )
   m_tabelas()
   if lastkey() # K_ESC
      WRET := .T.
   end
else
   EST005->( dbseek(var) )
   EST005->( dbsetorder(1) )
   if EST005->( found() )
      mensagem('Pedido Existente. <ENTER>')
      WRET := .T.
   else
      WRET := .F.
   end
end

return WRET


/*
-------------------------------------------------------------------------------
			   NOVO_PEDIDO
-------------------------------------------------------------------------------
*/
function novo_pedido()
local WRET := '00001',W_PED1,W_PED2

   EST005->( dbgobottom() )
   ESTM05->( dbgobottom() )
   W_PED1 := EST005->PEDIDO
   W_PED2 := ESTM05->PEDIDO
   IF W_PED2 >W_PED1
     WRET := VAL(ESTM05->PEDIDO)
     WRET := STRZERO( ++WRET,5)
   ELSE
    if EST005->( !eof() )
       WRET := val( EST005->PEDIDO )
       WRET := strzero( ++WRET , 5 )
    end
  ENDIF

   EST005->( dbappend() )
   EST005->PEDIDO := WRET

return WRET

/*
-------------------------------------------------------------------------------
		       CALCULA TOTAL DOS PEDIDOS
-------------------------------------------------------------------------------
*/
function totpedidos()
   local WRET := 0, OLDREC := EST005->( recno() )


   EST005->( dbgotop() )
   while EST005->( ! eof() )
      WRET = wret + EST005->TOTAL_PEDI
      EST005->( dbskip() )
   end

   EST005->( dbgoto( OLDREC ) )

return WRET

/*
-------------------------------------------------------------------------------
		       CALCULA TOTAL PENDENTE
-------------------------------------------------------------------------------
*/
function totpendente()
   local WRET := 0, OLDREC := EST005->( recno() )


   EST005->( dbgotop() )
   while EST005->( ! eof() )
      WRET = WRET + EST005->TOTAL_PEND
      EST005->( dbskip() )
   end

   EST005->( dbgoto( OLDREC ) )

return WRET





/*
-------------------------------------------------------------------------------
		   RECALCULA TOTAL PENDENTE E DO PEDIDO
-------------------------------------------------------------------------------
*/
function ped_recalc16()
   local W_TOTPEND := W_TOTPEDI := 0, OLDREC := EST005->( recno() )
   local W_QTDITPEND := 0, W_QTD_ITENS := 0

   EST006->( dbsetorder(1) )
   EST006->( dbseek(EST005->PEDIDO) )

   if EST006->( found() )

      while EST006->( ! eof() ) .and. EST006->PEDIDO = EST005->PEDIDO

	 if empty( EST006->R_DTPED )  // Calcula apenas o total pendente

	    W_TOTPEND += EST006->CUS_ITOT

	    W_QTDITPEND++
	 end

	 W_QTD_ITENS++
	 W_TOTPEDI += EST006->CUS_ITOT

	 EST006->( dbskip() )
      end

      while EST005->( ! rlock()); end
      EST005->TOTAL_PEDI := W_TOTPEDI
      EST005->TOTAL_PEND := W_TOTPEND
      EST005->QTDITPEND  := W_QTDITPEND
      EST005->QTD_ITENS  := W_QTD_ITENS
      EST005->( dbunlock() )

   end

return .T.

/*
-------------------------------------------------------------------------------
			   PED_ARQMORTO
-------------------------------------------------------------------------------
*/
Function ped_arqmorto()
local W_OLDSCR := savescreen()

if pergunta('Confirma Arquivamento do Pedido (S/N) ?')
   if pergunta('Confirma Arquivamento Total do Pedido (S/N) ?')
      item_arqmorto( EST005->PEDIDO )
      while EST005->( ! rlock() ); end

      ESTM05->( dbappend() )
      ESTM05->PEDIDO     := EST005->PEDIDO
      ESTM05->FORNECEDOR := EST005->FORNECEDOR
      ESTM05->DTPEDIDO   := EST005->DTPEDIDO
      ESTM05->R_DTPED    := EST005->R_DTPED
      ESTM05->STATUS     := EST005->STATUS
      ESTM05->QTD_ITENS  := EST005->QTD_ITENS
      ESTM05->COND_PGTO  := EST005->COND_PGTO
      ESTM05->CONTATO    := EST005->CONTATO
      ESTM05->TOTAL_PEDI := EST005->TOTAL_PEDI

      EST005->( dbdelete() )
      EST005->( dbunlock() )
      EST005->( dbgotop())

   end
end

select EST005

return


/*
-------------------------------------------------------------------------------
			   item_arqmorto
-------------------------------------------------------------------------------
*/
function item_arqmorto( P_PEDIDO )
local WRET := .T.

select EST006
EST006->( dbsetorder(1) )
EST006->( dbgotop() )
EST006->( dbseek( P_PEDIDO ))

if EST006->( found() )

   while EST006->( ! eof() ) .and. EST006->PEDIDO=P_PEDIDO

      while EST006->( ! rlock() ); end

      ESTM06->( dbappend())
      ESTM06->PEDIDO   := EST006->PEDIDO
      ESTM06->SEQUENC  := EST006->SEQUENC
      ESTM06->FORMA    := EST006->FORMA
      ESTM06->TIPO     := EST006->TIPO
      ESTM06->ESTADO   := EST006->ESTADO
      ESTM06->BIT_MM   := EST006->BIT_MM
      ESTM06->ESP_MM   := EST006->ESP_MM
      ESTM06->BIT_INT  := EST006->BIT_INT
      ESTM06->BIT_FN   := EST006->BIT_FN
      ESTM06->BIT_FD   := EST006->BIT_FD
      ESTM06->ESP_INT  := EST006->ESP_INT
      ESTM06->ESP_FN   := EST006->ESP_FN
      ESTM06->ESP_FD   := EST006->ESP_FD
      ESTM06->CUS_ITOT := EST006->CUS_ITOT
      ESTM06->CUSTO_KG := EST006->CUSTO_KG
      ESTM06->DT_PREV  := EST006->DT_PREV
      ESTM06->R_DTPED  := EST006->R_DTPED
      ESTM06->QTD_KG   := EST006->QTD_KG
      ESTM06->QTD_PEC  := EST006->QTD_PEC
      ESTM06->VAL_KG   := EST006->VAL_KG
      ESTM06->IPI      := EST006->IPI
      ESTM06->ICMS     := EST006->ICMS
      ESTM06->FRETE    := EST006->FRETE
      ESTM06->OUTRATX  := EST006->OUTRATX

      EST006->( dbdelete() )
      EST006->( dbskip()   )
      EST006->( dbunlock() )

   end
end

return WRET

