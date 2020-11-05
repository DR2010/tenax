/*
   Vendas
   VEN034.PRG - Cadastro de Nota Fiscal
*/
#include "inkey.ch"

abrir("EST002")
abrir("EST003")
abrir("EST004")
abrir("VEN001")
abrir("VEN003")
abrir("VEN005")
abrir("VEN006")
abrir("VEN012")
abrir("VEN023")



setcolor(W_COREDIT)
status('N o t a   F i s c a l')

// TBROWSE

private  W_FILE      := {}
private  CAMPO       := {}
private  MASCARA     := {}
private  CABECALHO   := {}
private  TAMANHO     := {}
private  BESCAPE     := {|| .T. }
private  COR         := W_COREDIT
private  TITULO      := " Nota Fiscal "
private  LININI      := 04
private  LINFIM      := 23
private  COLINI      := 00
private  COLFIM      := 79
private  BLOCK_DISP  := {|| .T. }
private  CAB_TITULO  := nil
private  BORDA       := 1
private  FLAG        := .T.
private  TECLA       := nil
private  TABELA      := nil

aadd( CAMPO     , "NOTAFISCAL")
aadd( CAMPO     , "SERIE" )
aadd( CAMPO     , "CODCLI" )
aadd( CAMPO     , "DT_EMISSAO")
aadd( CAMPO     , "VAL_TOTAL" )

aadd( MASCARA   , "XXXXXXXX"         )
aadd( MASCARA   , "XXXXXX"           )
aadd( MASCARA   , "XXXXX"            )
aadd( MASCARA   , "99/99/99"         )
aadd( MASCARA   , "99,999,999,999.99")

aadd( CABECALHO , "Nota Fiscal" )
aadd( CABECALHO , "Serie"       )
aadd( CABECALHO , "Cliente"     )
aadd( CABECALHO , "Emissao"     )
aadd( CABECALHO , "Valor"       )

aadd( TAMANHO   , 10 )
aadd( TAMANHO   , 08 )
aadd( TAMANHO   , 08 )
aadd( TAMANHO   , 10 )
aadd( TAMANHO   , 20 )

aadd( W_FILE , "VEN012" )
aadd( W_FILE , "VEN012" )
aadd( W_FILE , "VEN012" )
aadd( W_FILE , "VEN012" )
aadd( W_FILE , "VEN012" )


private W_CHAVE_ITEM, W_SEQ_CONS := 0, W_FILTRO
private P_HDSEP  := "км", P_COLSEP := "-"
private W_TOT_PRECO := 0.00
// --> VEN012 -> NOTAFISCAL

private  X_NOTAFISCAL  :=  space( 8)  ,;
	 X_SERIE       :=  space( 6) ,;
	 X_VALOR       :=  0.00      ,;
	 X_ICMS        :=  0.00      ,;
	 X_FRETE       :=  0.00      ,;
	 X_SEGURO      :=  0.00      ,;
	 X_VAL_TOTAL   :=  0.00      ,;
	 X_TRANSPORT   :=  space(25) ,;
	 X_DT_EMISSAO  :=  date()    ,;
	 X_TIPO_NOTA   :=  space( 1) ,;
	 X_CODCLI      :=  space( 5) ,;
	 X_EMITIDO     :=  space( 1)

// --> VEN006 -> ITEM DE PEDIDO

private  X_SEQUENC    := 0         ,;
	 X_BIT_FD     := space(02) ,;
	 X_BIT_FN     := space(02) ,;
	 X_BIT_INT    := space(02) ,;
	 X_BIT_MM     := 0.00      ,;
	 X_ESP_FD     := space(02) ,;
	 X_ESP_FN     := space(02) ,;
	 X_ESP_INT    := space(02) ,;
	 X_ESP_MM     := 0.00      ,;
	 X_CONSULTA   := space(08) ,;
	 X_DT_EMISSAO := date()    ,;
	 X_DT_PEDIDO  := ctod(' ') ,;
	 X_DT_SEPARA  := ctod(' ') ,;
	 X_DT_VALID   := ctod( '  /  /  ' ),;
	 X_COMPRIM    := 0         ,;
	 X_COM_COMP   := 0.00      ,;
	 X_COM_VEND   := 0.00      ,;
	 X_ESTADO     := space(01) ,;
	 X_FORMA      := space(03) ,;
	 X_LARGURA    := 0         ,;
	 X_PEDVEN     := space(05) ,;
	 X_PER_ACRES  := 0.00      ,;
	 X_PESO_BALAN := 0.0       ,;
	 X_PESO_COBRA := 0.00      ,;
	 X_PESO_TEO   := 0.00      ,;
	 X_PRECO      := 0         ,;
	 X_SEQ_SEPARA := 0         ,;
	 X_STATUS     := space(01) ,;
	 X_TIPO       := space(05) ,;
	 X_TIPO_SEP   := space(01)


p34_tela34()

select VEN012
VEN012->( dbsetorder(1) )

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

   X_NOTAFISCAL   := VEN012->NOTAFISCAL
   setcursor(1)

   setcolor( W_CORGET )
   do case
      case TEC == 28
           help("VEN034")

      case lastkey() = K_ENTER

           if VEN003->( ! eof() )
              p34_consulta()
              restscreen(,,,,W_TEL21)
              tabela:refreshall()
           end

      case lastkey() = K_F3
           p34_nf_incluir()
           restscreen(,,,,W_TEL21)
           tabela:refreshall()

      case lastkey() = K_F5
           p34_nf_excluir()
           restscreen(,,,,W_TEL21)
           tabela:refreshall()

      case lastkey() = K_F6
           p34_busca()
           restscreen(,,,,W_TEL21)
           tabela:refreshall()

      case lastkey() = K_F8
           p34_nf_imprimir()
           restscreen(,,,,W_TEL21)
           tabela:refreshall()

   endcase
   setcolor( W_COREDIT )
   select VEN012

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
		      P34_NF_INCLUIR()
-------------------------------------------------------------------------------
*/
procedure P34_NF_INCLUIR

begin sequence

   @ 08,25 say 'здддддддддддддддддддддддддддддддд©'
   @ 09,25 say 'Ё Pedido .....:                  Ё'
   @ 10,25 say 'юдддддддддддддддддддддддддддддддды'
   sombra( 08, 25, 10, 58 )

   X_NOTAFISCAL := SPACE(8) //nova_nota()
   X_PEDVEN     := space(5)
   @ 09,41 get X_PEDVEN     picture "@!" VALID  TES_PEDVEN( X_PEDVEN)
   read
   X_PEDVEN := zerofill(X_PEDVEN)
   @ 12,41 SAY X_PEDVEN     picture "@!"
   if lastkey() = K_ESC; break; end

*   VEN012->( dbsetorder(1) )
*   VEN012->( dbseek( X_NOTAFISCAL ))
*   if VEN012->( found() )
*      message(' Nota Fiscal j═ cadastrada. <ENTER>')
*      break
*   end
   
   p34_telaitem('Incluir Nota Fiscal      Pedido : ' +X_PEDVEN)
   P34_peditem_show( "SEM NOTA", "INCLUIR", X_NOTAFISCAL, X_PEDVEN )

end sequence

return

/*
-------------------------------------------------------------------------------
		      P34_CONSULTA()
-------------------------------------------------------------------------------
*/
procedure P34_CONSULTA
   local W_VET := {}

   p34_telitemNF( '- Consulta')

   // preenche vetor com itens de nota fiscal
   W_VET := p34_vetitem( X_NOTAFISCAL := VEN012->NOTAFISCAL )

   @ 04,01 TO 24,78
   W_ESC := achoice(07,03,18,76,W_VET)

return

/*
-------------------------------------------------------------------------------
		      P34_NF_EXCLUIR()
-------------------------------------------------------------------------------
*/
procedure P34_NF_EXCLUIR

if pergunta('Confirma exclusao (S/N) ? ')

   VEN006->( dbsetorder(2) )
   while .t.
      VEN006->( dbseek( VEN012->NOTAFISCAL ))
      if VEN006->( ! found() )
	 exit
      end
      while VEN006->( ! rlock() ); end
      VEN006->NOTAFISCAL := space( 8)
   end

   VEN006->( dbunlock() )
   while VEN012->( ! rlock() ); end
   VEN012->( dbdelete() )
   VEN012->( dbunlock() )
   VEN006->( dbsetorder(1) )
end
return


/*
-------------------------------------------------------------------------------
                      P34_NFALTERA()
-------------------------------------------------------------------------------
*/
procedure P34_NFALTERA

p34_telaitem("Item de Nota Fiscal")
VEN006->(DBSETORDER(2))
VEN006->(DBSEEK( VEN012->NOTAFISCAL))
X_PEDVEN := VEN006->PEDVEN

P34_peditem_show( "SEM NOTA", "ALTERAR", X_NOTAFISCAL := VEN012->NOTAFISCAL, X_PEDVEN  )

return

/*
-------------------------------------------------------------------------------
		      P34_BUSCA
-------------------------------------------------------------------------------
*/
Procedure P34_BUSCA

begin sequence

   @ 08,25 say 'зддддддддд Busca Rapida ддддддддд©'
   @ 09,25 say 'Ё                                Ё'
   @ 10,25 say 'Ё N.Fiscal :                     Ё'
   @ 11,25 say 'Ё                                Ё'
   @ 12,25 say 'юдддддддддддддддддддддддддддддддды'
   sombra( 08, 25, 12, 58 )

   W_ORDEM := 1 ; X_NOTAFISCAL := space(8)
   @ 10,38 get X_NOTAFISCAL picture "@!"
   read
   X_NOTAFISCAL := STRZERO(VAL(X_NOTAFISCAL),8)
   @ 10,38 say X_NOTAFISCAL picture "@!"
   if lastkey() = K_ESC; break; end

   VEN012->( dbsetorder(1) )
   VEN012->( dbseek( X_NOTAFISCAL, .T. ))

end sequence

return

/*
-------------------------------------------------------------------------------
			   P34_PEDITEM_SHOW
-------------------------------------------------------------------------------
*/
function P34_peditem_show( P_FILTRO, P_MODO, P_NOTA, P_PEDIDO )
/*
  Valores para P_FILTRO
    = SEM NOTA - Mostra itens sem nota fiscal
    = COM NOTA - Mostra itens com nota fiscal
  P_MODO
    = INCLUIR
    = ALTERAR
    = EXCLUIR
  P_NOTA -> O numero da nota fiscal a ser mostrada
  P_PEDIDO -> O numero do pedido indicado
*/

   local WRET := .t.
   private PIT_MODO := P_MODO, PIT_FILTRO := P_FILTRO

  // P_FILTRO controla quais itens de nota serao mostrados.

  if P_FILTRO="SEM NOTA"
    W_FILTRO := {|| EMPTY(VEN006->NOTAFISCAL) .AND. VEN006->PEDVEN = P_PEDIDO}
  else
    W_FILTRO := {|| VEN006->NOTAFISCAL = P_NOTA }
  end

  X_NOTAFISCAL := P_NOTA

 // Tbrowse

private  W_FILE      := {}
private  CAMPO       := {}
private  MASCARA     := {}
private  CABECALHO   := {}
private  TAMANHO     := {}
private  BESCAPE     := W_FILTRO
private  COR         := W_COREDIT
private  TITULO      := " Itens de Pedido "
private  LININI      := 05
private  LINFIM      := 18
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
aadd( CABECALHO , "PE─AS" )
aadd( CABECALHO , "PRE─O" )
aadd( CABECALHO , "U" )
aadd( CABECALHO , "" )

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
VEN006->( dbseek( X_PEDVEN,.T. ) )

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
  setcursor(1)
    do case
       case lastkey() = K_F3; p34_buscaitem() ; TABELA:REFRESHALL()
       case lastkey() = K_F4; p34_marcaitem() ; TABELA:REFRESHALL()
       case lastkey() = K_F5; p34_marcapedido( VEN006->PEDVEN ) ; TABELA:REFRESHALL()
       case lastkey() = K_F6
	  if P34_FECHANOTA( X_NOTAFISCAL, PIT_MODO )
	    return 0
	  else
	     
	  end

      case lastkey() = K_F9
         if VEN006->ESTOQUE='R'
           W_RTEL := savescreen(,,,,)
           fornece023(VEN006->PEDVEN)
           tabela:refreshall()
           restscreen(,,,,W_RTEL)
         end
       case lastkey() = K_ESC; return 0
   endcase
   SELE VEN006

   VEN006->( dbclearfilter() )
end

// limpa ocorrencias marcadas com o nome do usuario
//
VEN006->( dbsetorder(3) )
while .T.
  VEN006->( dbseek(M->USUARIO) )
  if VEN006->( ! found() )
    exit
  end

  while VEN006->( ! rlock()); end
  VEN006->USUARIO := space(30)
  VEN006->( dbunlock() )
end
select VEN012
VEN012->( dbsetorder(1) )
restscreen(,,,,W_TEL21 )
RETURN

/*
-------------------------------------------------------------------------------
			   P34_ITEM
-------------------------------------------------------------------------------
*/


/*
-------------------------------------------------------------------------------
			   P34_MARCAITEM
-------------------------------------------------------------------------------
*/
Procedure P34_MARCAITEM

while VEN006->( ! rlock()); end

VEN006->USUARIO := if( empty(VEN006->USUARIO), M->USUARIO, space(8) )

VEN006->( dbunlock() )
return

/*
-------------------------------------------------------------------------------
		      P34_BUSCAITEM
-------------------------------------------------------------------------------
*/
Procedure P34_BUSCAITEM

begin sequence

   @ 08,25 say 'зддддддддд Busca R═pida ддддддддд©'
   @ 09,25 say 'Ё                                Ё'
   @ 10,25 say 'Ё Pedido ..:                     Ё'
   @ 11,25 say 'Ё                                Ё'
   @ 12,25 say 'юдддддддддддддддддддддддддддддддды'
   sombra( 08, 25, 12, 58 )

   W_ORDEM := 1
   @ 10,38 get X_PEDVEN picture "@!"
   read
   if lastkey() = K_ESC; break; end

   VEN006->( dbsetorder(1) )
   VEN006->( dbseek( X_PEDVEN, .T. ))

end sequence
return

/*
-------------------------------------------------------------------------------
			   P34_MARCAPEDIDO
-------------------------------------------------------------------------------
*/
Procedure P34_MARCAPEDIDO( W_PEDVEN )

VEN006->( dbseek( W_PEDVEN ))
while VEN006->PEDVEN=X_PEDVEN .and. VEN006->( ! eof() )

   while VEN006->( ! rlock() ); end
   VEN006->USUARIO := if( empty( VEN006->USUARIO ), M->USUARIO, space(30) )
   VEN006->( dbunlock() )
   VEN006->( dbskip() )
end


return

/*
-------------------------------------------------------------------------------
				P34_FECHANOTA
-------------------------------------------------------------------------------
*/
Procedure P34_FECHANOTA( P_NOTA, P_FMODO )
local W_VET    := {}, WRET := .T.
local W_OLDREC := VEN006->( recno() )
local W_FTELA  := savescreen(,,,,,)

begin sequence

   // preenche vetor com itens da nota
   if P_FMODO = "EXCLUIR"

      W_VET := p34_vetexcitem( P_NOTA )
      W_ESC := achoice(07,03,18,76,W_VET)

      if W_ESC > 0
	 VEN006->( dbsetorder(2) )
	 VEN006->( dbseek( P_NOTA ))

	 while VEN006->NOTAFISCAL=X_NOTAFISCAL .and. VEN006->( ! eof() )
	    X_SEQNF := 0

	    while VEN006->( ! rlock() ); end
	    if empty( VEN006->USUARIO )
	       X_SEQNF++
	       VEN006->NOTAFISCAL := X_NOTAFISCAL
	       VEN006->SEQNF      := X_SEQNF
	    else
	       VEN006->NOTAFISCAL := space(8)
	       VEN006->SEQNF      := 0
	    end
	    VEN006->USUARIO    := space(30)
	    VEN006->( dbunlock() )
	    VEN006->( dbskip() )
	    
	 end
      else
	 WRET := .F.
      end

   else
      W_VET := p34_vetitem( P_NOTA )
      @ 03,07 say 'Fechar Nota'

      p34_itselec()

      W_ESC := achoice(07,03,18,76,W_VET)
      if W_ESC > 0
	 
	 p34_telaheaderNF()
	 while .t.
	 
	    p34_atribheaderNF( P_FMODO )

	    if p34_getheaderNF()
	       VEN006->( dbsetorder(3) )
	       VEN006->( dbseek( M->USUARIO ))
	       X_NOTAFISCAL := P_NOTA :=  nova_nota()
	       @ 06,33 say  P_NOTA
	       while VEN006->USUARIO=M->USUARIO .and. VEN006->( ! eof() )
		  X_SEQNF := 0
		  while VEN006->( ! rlock() ); end
		  X_SEQNF++
		  VEN006->NOTAFISCAL := X_NOTAFISCAL
		  VEN006->SEQNF      := X_SEQNF
		  VEN006->USUARIO    := space(30)
		  VEN006->( dbunlock() )
		  VEN006->( dbskip() )
	       end

	       if P_FMODO = "ALTERAR"
		  while VEN012->( ! rlock()); end
	       else
		  VEN012->( dbappend() )
		  VEN012->NOTAFISCAL := X_NOTAFISCAL
	       end

	       VEN012->SERIE      := X_SERIE
	       VEN012->VALOR      := X_VALOR
	       VEN012->ICMS       := X_ICMS
	       VEN012->FRETE      := X_FRETE
	       VEN012->SEGURO     := X_SEGURO
	       VEN012->VAL_TOTAL  := X_VAL_TOTAL
	       VEN012->TRANSPORT  := X_TRANSPORT
	       VEN012->DT_EMISSAO := X_DT_EMISSAO
	       VEN012->TIPO_NOTA  := X_TIPO_NOTA
	       VEN012->CODCLI     := X_CODCLI
	       VEN012->EMITIDO    := 'N'

	       VEN012->( dbunlock() )
	    end
	    exit
	 end
      else
	 WRET := .F.
      end
   end
  mensbeep("Nota Fiscal Criada. <ENTER>")
end sequence
VEN006->(dbsetorder(1))
VEN006->( dbgoto( W_OLDREC ))
restscreen(,,,,W_FTELA)
return WRET

/*
-------------------------------------------------------------------------------
			   p34_getheadernf()
-------------------------------------------------------------------------------
*/
function p34_getheaderNF()
local WRET := .T.
@ 08,33 get  X_SERIE        picture "@!"
@ 09,37 get  X_VALOR        picture "9,999,999.99"
@ 10,37 get  X_ICMS         picture "9,999,999.99"
@ 11,37 get  X_FRETE        picture "9,999,999.99"
@ 12,37 get  X_SEGURO       picture "9,999,999.99"
@ 13,33 get  X_VAL_TOTAL    picture "9,999,999,999.99"
@ 14,33 get  X_TRANSPORT    picture "@!"
@ 15,33 get  X_DT_EMISSAO
@ 16,33 get  X_TIPO_NOTA    picture "!"
@ 17,33 get  X_CODCLI       picture "@!"   VALID TES_CODCLI(17,33,20)
@ 18,33 get  X_EMITIDO      picture "!"
read
WRET := if(lastkey() = K_ESC, .F., .T. )
return WRET

/*
-------------------------------------------------------------------------------
			   p34_showheaderNF
-------------------------------------------------------------------------------
*/
function p34_showheaderNF()

@ 06,33 say VEN012->NOTAFISCAL
@ 08,33 say VEN012->SERIE        picture "@!"
@ 09,37 say VEN012->VALOR        picture "9,999,999.99"
@ 10,37 say VEN012->ICMS         picture "9,999,999.99"
@ 11,37 say VEN012->FRETE        picture "9,999,999.99"
@ 12,37 say VEN012->SEGURO       picture "9,999,999.99"
@ 13,33 say VEN012->VAL_TOTAL    picture "9,999,999,999.99"
@ 14,33 say VEN012->TRANSPORT    picture "@!"
@ 15,33 say VEN012->DT_EMISSAO
@ 16,33 say VEN012->TIPO_NOTA    picture "!"
@ 17,33 say VEN012->CODCLI       picture "@!"
@ 18,33 say VEN012->EMITIDO      picture "!"

return WRET


/*
-------------------------------------------------------------------------------
			   p34_atribheaderNF
-------------------------------------------------------------------------------
*/
procedure p34_atribheaderNF( PAT_MODO )

if PAT_MODO = "ALTERAR"
   X_NOTAFISCAL := VEN012->NOTAFISCAL
   X_SERIE      := VEN012->SERIE
   X_VALOR      := VEN012->VALOR
   X_ICMS       := VEN012->ICMS
   X_FRETE      := VEN012->FRETE
   X_SEGURO     := VEN012->SEGURO
   X_VAL_TOTAL  := VEN012->VAL_TOTAL
   X_TRANSPORT  := VEN012->TRANSPORT
   X_DT_EMISSAO := VEN012->DT_EMISSAO
   X_TIPO_NOTA  := VEN012->TIPO_NOTA
   X_CODCLI     := VEN012->CODCLI
   X_EMITIDO    := VEN012->EMITIDO
else
 X_VALOR := W_TOT_PRECO
 X_CODCLI := VEN005->CODCLI
end

return

/*
-------------------------------------------------------------------------------
			   p34_vetitem
-------------------------------------------------------------------------------
*/
function p34_vetitem( P_NOTA )
local WVET_RET := {}

// Cria vetor com itens da nota fiscal

if ! empty( P_NOTA )
   sele VEN006
   VEN006->( dbsetorder(2) )
   VEN006->( dbseek( P_NOTA ))

   while VEN006->NOTAFISCAL=P_NOTA .and. VEN006->( ! eof() )
      aadd( WVET_RET,  ' '+ VEN006->PEDVEN+' '                                                +;
		       +VEN006->FORMA                +' '  + VEN006->TIPO+' '              +;
		       +VEN006->ESTADO               +'  ' + no_zero(VEN006->BIT_MM,8,3) +' '  +;
		       +no_zero(  VEN006->ESP_MM,8,3)    +'  ' + no_zero(VEN006->COMPRIM,10,2)+' ' +;
		       +no_zero(  VEN006->LARGURA,10,2 ) + ' '                                 +;
		       +str(  VEN006->PRECO,10,2)    +' '                                  +;
		       +left( VEN006->USUARIO, 2 )                                         )
      VEN006->( dbunlock() )
      W_TOT_PRECO := W_TOT_PRECO+ VEN006->PRECO
      VEN006->( dbskip() )

   end
end

//
// Pensar novamente !!!
//

VEN006->( dbsetorder(3) )
VEN006->( dbseek( M->USUARIO ))

while VEN006->USUARIO=M->USUARIO .and. VEN006->( ! eof() )
   aadd( WVET_RET,  ' '+ VEN006->PEDVEN+' '                                                +;
		    +VEN006->FORMA                +' '  + VEN006->TIPO+' '              +;
		    +VEN006->ESTADO               +'  ' + str(VEN006->BIT_MM,8,3) +' '  +;
		    +str(  VEN006->ESP_MM,8,3)    +'  ' + str(VEN006->COMPRIM,10,2)+' ' +;
		    +str(  VEN006->LARGURA,10,2 ) + ' '                                 +;
		    +str(  VEN006->PRECO,10,2)    +' '                                  +;
		    +left( VEN006->USUARIO, 2 )                                         )
   VEN006->( dbunlock() )
   W_TOT_PRECO := W_TOT_PRECO+ VEN006->PRECO
   VEN006->( dbskip() )
end

if len( WVET_RET ) = 0
   mensbeep("Nota Fiscal nao possui itens.")
end

return WVET_RET

/*
-------------------------------------------------------------------------------
			   p34_vetexcitem

Objetivo : Mostra nota sem itens excluidos
-------------------------------------------------------------------------------
*/
function p34_vetexcitem( P_NOTA )
local WVET_RET := {}

// Cria vetor com itens da nota fiscal

p34_itselect()
VEN006->( dbsetorder(2) )
VEN006->( dbseek( P_NOTA ))

while VEN006->NOTAFISCAL=P_NOTA .and. VEN006->( ! eof() )
   if empty( VEN006->USUARIO )
      aadd( WVET_RET,  ' '+ VEN006->PEDVEN+' '                                                +;
           +VEN006->FORMA                +' '  + VEN006->TIPO+' '              +;
           +VEN006->ESTADO               +'  ' + no_zero(VEN006->BIT_MM,8,3) +' '  +;
           +no_zero(  VEN006->ESP_MM,8,3)    +'  ' + no_zero(VEN006->COMPRIM,10,2)+' ' +;
           +no_zero(  VEN006->LARGURA,10,2 ) + ' '                                 +;
           +str(  VEN006->PRECO,10,2)    +' '                                  +;
           +left( VEN006->USUARIO, 2 )                                         )
      VEN006->( dbunlock() )
      W_TOT_PRECO := W_TOT_PRECO+ VEN006->PRECO
   end
   VEN006->( dbskip() )
   
end


return WVET_RET



/*
-------------------------------------------------------------------------------
			   p34_telaitem
-------------------------------------------------------------------------------
*/
procedure p34_telaitem( P_TITULO )

   @ 01,00 say 'здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©'
   @ 02,00 say 'Ё  ' +P_TITULO
   @ 02,79 say 'Ё'
   @ 03,00 say 'юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды'

   @ 19,00 say 'здддддддддддддддбдддддддддддддддбдддддддддддддддбдддддддддддддддддбдддддддддддд©'
   @ 20,00 say 'Ё  <f3> busca   Ё  <f4> marcar  Ё <f5> marcar   Ё <f6> fechar     Ё            Ё'
   @ 21,00 say 'Ё               Ё       item    Ё      pedido   Ё nota fiscal     Ё            Ё'
   @ 22,00 say 'юдддддддддддддддадддддддддддддддадддддддддддддддадддддддддддддддддадддддддддддды'
return
/*
-------------------------------------------------------------------------------
			   p34_telaheaderNF
-------------------------------------------------------------------------------
*/
procedure p34_telaheaderNF()

   @ 05,15 say  'зддддддддддддддддддддддддддддддддддддддддддддддддд©'
   @ 06,15 say  'Ё Nota Fiscal N╖                                  Ё'
   @ 07,15 say  'Ё                                                 Ё'
   @ 08,15 say  'Ё S┌rie ........:                                 Ё'
   @ 09,15 say  'Ё Valor ........:                                 Ё'
   @ 10,15 say  'Ё ICMS .........:                                 Ё'
   @ 11,15 say  'Ё Frete ........:                                 Ё'
   @ 12,15 say  'Ё Seguro .......:                                 Ё'
   @ 13,15 say  'Ё Valor Total ..:                                 Ё'
   @ 14,15 say  'Ё Transporte ...:                                 Ё'
   @ 15,15 say  'Ё Data Emiss└o .:                                 Ё'
   @ 16,15 say  'Ё Tipo .........:                                 Ё'
   @ 17,15 say  'Ё Cliente ......:                                 Ё'
   @ 18,15 say  'Ё Emitido ......:                                 Ё'
   @ 19,15 say  'юддддддддддддддддддддддддддддддддддддддддддддддддды'
   sombra(05,15,19,65)

return


/*
-------------------------------------------------------------------------------
			   p34_nf_imprimir
-------------------------------------------------------------------------------
*/
function p34_nf_imprimir()

local arq := alltrim( "T"+M->USUARIO )+".PRN"

set printer to &arq
set device to printer
VEN006->(dbgotop())
// Posiciona nos dados do cliente

VEN001->( dbsetorder(1) )
VEN001->( dbseek( VEN012->CODCLI ))

@ 00,      00 say 'зддддддддддддддддддддддддддддд© зддддддддддддддддд© здддддддддддддддддддддддд©'
@ prow()+1,00 say 'Ё NOTA FISCAL - TENAX         Ё цддддддддддддддддд╢ Ё N╖ '+ VEN012->NOTAFISCAL
@ prow(),  77 say 'Ё'
@ prow()+1,00 say 'юддддддддддддддддддддддддддддды юддддддддддддддддды юдддддддддддддддддддддддды'

@ prow()+1,00 say 'зддддддддддддддддддддддддддддд© здддддддддддддддддддддддддддддддддддддддддддд©'
@ prow()+1,00 say 'Ё                             Ё Ё  Natureza da Operacao    :                 Ё'
@ prow()+1,00 say 'Ё                             Ё Ё  Via de Transporte       : ' + left(VEN012->TRANSPORT,15)
@ prow(),  77 say 'Ё'
@ prow()+1,00 say 'Ё                             Ё Ё  Data da Emissao da Nota : ' + DTOC(VEN012->DT_EMISSAO)
@ prow(),  77 say 'Ё'
@ prow()+1,00 say 'юддддддддддддддддддддддддддддды юдддддддддддддддддддддддддддддддддддддддддддды'
@ prow()+1,00 say ''
@ prow()+1,00 say 'Nome da Firma ...: '+ VEN001->RAZAO
@ prow()+1,00 say 'Endere┤o ........: '+ VEN001->ENDERECO
@ prow()+1,00 say 'Municipio .......: '+ VEN001->CIDADE
@ prow()  ,41 say 'Estado : ' + VEN001->ESTADO
@ prow()+1,00 say 'Pra┤a Pagto .....:'
@ prow()  ,65 say 'CEP : '+ VEN001->CEP
@ prow()+1,00 say 'C.G.C. (M.F.) N╖ : '+VEN001->CGC
@ prow()  ,41 say 'Inscricao Estadual : '+VEN001->INSC_EST
@ prow()+1,00 say '------------------------------------------------------------------------------'
@ prow()+1,00 say 'Condicoes de pgto:                       Seu pedido n╖ :'+' ? '
@ prow()+1,00 say ''
@ prow()+1,00 say 'зддддддбдддддддддбдддддддбдддддддддддддддддддддддддддбдддддддддддддддддддддддд©'
@ prow()+1,00 say 'Ё      Ё         Ё       Ё                           Ё     PRECO - R$         Ё'
@ prow()+1,00 say 'Ё      Ё         Ё Peso  Ё                           цддддддддддддбддддддддддд╢'
@ prow()+1,00 say 'ЁUnid. Ё  Quant. Ё (Kg)  Ё  DESCRICAO DOS PRODUTOS   Ё  Unitario  Ё     TOTAL Ё'
@ prow()+1,00 say 'цддддддедддддддддедддддддедддддддддддддддддддддддддддеддддддддддддеддддддддддд╢'

// produtos
SELE VEN006
VEN006->( dbsetorder(2) )
VEN006->( dbseek( X_NOTAFISCAL ))

WTOTALNOTA := 0
while VEN006->NOTAFISCAL = X_NOTAFISCAL .AND. VEN006->( ! eof() )
   WTOTALNOTA := WTOTALNOTA + VEN006->PRECO

   EST004->( dbsetorder(1) )
   EST004->( dbseek( VEN006->FORMA+VEN006->TIPO ) )

   @ prow()+1,00 say 'Ё'
   @ prow()  ,02 say VEN006->UNIDADE
   @ prow()  ,07 say 'Ё'
   @ prow()  ,09 say VEN006->QTD_PECAS  picture '9999999'
   @ prow()  ,17 say 'Ё'
   if VEN006->RETORNADO # 'S'
      @ prow()  ,18 say VEN006->PESO_ITEM   picture '9999.99'
   else
      @ prow()  ,18 say VEN006->PESO_COBRA   picture '9999.99'
  end
   @ prow()  ,25 say 'Ё'
   @ prow()  ,26 say left(EST004->DESCRICAO,27)
   @ prow()  ,53 say 'Ё'
   @ prow()  ,55 say VEN006->PRECO_UNI picture '999,999.99'
   @ prow()  ,66 say 'Ё'
   if VEN006->RETORNADO # 'S'
     @ prow()  ,68 say VEN006->PRECO_UNI * VEN006->PESO_ITEM picture '999,999.99'
   else
     @ prow()  ,68 say VEN006->PRECO_UNI * VEN006->PESO_COBRA picture '999,999.99'
   end
   @ prow()  ,78 say 'Ё'

   VEN006->( dbskip() )
end

@ prow()+1,00 say 'юддддддадддддддддадддддддадддддддддддддддддддддддддддаддддддддддддаддддддддддды'
//

@ prow()+1,00 say ''
@ prow()+1,00 say 'зддддддддддддддддддддддддддддддддддддддддддддддддддддд© зддддддддддддддддддддд©'
@ prow()+1,00 say 'Ё           DESPESAS ACESSORIAS                       Ё Ё VALOR TOTAL DA NOTA Ё'
@ prow()+1,00 say 'цдддддддддддддбддддддддддддддддддддбдддддддддддддддддд╢ Ё                     Ё'
@ prow()+1,00 say 'Ё Frete       Ё      Seguro        Ё      Total       Ё Ё                     Ё'
@ prow()+1,00 say 'цдддддддддддддеддддддддддддддддддддедддддддддддддддддд╢ цддддддддддддддддддддд╢'
@ prow()+1,00 say 'Ё'
@ prow()  ,02 say VEN012->FRETE                picture '999,999.99'
@ prow()  ,14 say 'Ё'
@ prow()  ,16 say VEN012->SEGURO               picture '999,999,999.99'
@ prow()  ,35 say 'Ё'
@ prow()  ,37 say VEN012->SEGURO+VEN012->FRETE picture '999,999,999.99'
@ prow()  ,54 say 'Ё'
@ prow()  ,56 say 'Ё'
@ prow()  ,58 say WTOTALNOTA picture '999,999,999.99'
@ prow()  ,78 say 'Ё'
@ prow()+1,00 say 'юдддддддддддддаддддддддддддддддддддадддддддддддддддддды юддддддддддддддддддддды'
@ prow()+1,00 say ''
@ prow()+1,00 say '                                    зддддддддддддддддддддддбдддддддддддддддддд©'
@ prow()+1,00 say '                                    Ё ICMS                 Ё                  Ё'
@ prow()+1,00 say '                                    Ё Ja incluido no Preco Ё '+transform(WTOTALNOTA*0.18,"999,999.99")
@ prow()  ,78 say 'Ё'
@ prow()+1,00 say '                                    юддддддддддддддддддддддадддддддддддддддддды'
@ prow()+1,00 say ''
@ prow()+1,00 say 'зддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©'
@ prow()+1,00 say 'Ё Transportador                                                 Data de Saida Ё'
@ prow()+1,00 say 'Ё Endereco                                                                    Ё'
@ prow()+1,00 say 'Ё Placa do Veiculo                   Estado       Municipio                   Ё'
@ prow()+1,00 say 'юддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды'
@ prow()+1,00 say 'зддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©'
@ prow()+1,00 say 'Ё Local de Entrega                                                            Ё'
@ prow()+1,00 say 'юддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды'
@ prow()+1,00 say ''
@ prow()+1,00 say 'здддддддбддддддддбддддбдддддддддддддддддддддддддддддддбдддддддддддбддддддддддд©'
@ prow()+1,00 say 'Ё Marca Ё Numero ЁQtdeЁ                Especie        ЁPeso Bruto Ё Peso Liq. Ё'
@ prow()+1,00 say 'цдддддддеддддддддеддддедддддддддддддддддддддддддддддддедддддддддддеддддддддддд╢'
@ prow()+1,00 say 'Ё       Ё        Ё    Ё                               Ё           Ё           Ё'
@ prow()+1,00 say 'юдддддддаддддддддаддддадддддддддддддддддддддддддддддддадддддддддддаддддддддддды'
@ prow()+1,00 say ''
@ prow()+1,00 say ''
@ prow()+1,00 say '   Recebi(emos) de TENAX A─O E FERRO LTDA., os produtos contantes desta,'
@ prow()+1,00 say ''
@ prow()+1,00 say ''
@ prow()+1,00 say 'Rio de janeiro,     de                  de        .'

set printer to
set device to screen

W_SCNF := savescreen(,,,,)
cls

LARQ := memoread( ARQ )
memoedit( LARQ,0,0,24,79,.F.,,132 )

restscreen(,,,,W_SCNF)

return WRET


/*
-------------------------------------------------------------------------------

-------------------------------------------------------------------------------
*/
procedure p34_telitemNF( WTIT )

        WTIT = if( WTIT=NIL, ' ', WTIT )
	@ 01,00 say 'здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©'
        @ 02,00 say 'Ё                              NOTA FISCAL                                     Ё'
        @ 02,43 say WTIT
	@ 03,00 say 'юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды'
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
        @ 21,00 say '                                                                                '
        @ 22,00 say '                                                                                '
        @ 23,00 say '                                                                                '
        @ 24,00 say '                                                                                '

return

/*
-------------------------------------------------------------------------------
			   p34_tela34
-------------------------------------------------------------------------------
*/
procedure p34_tela34()

   @ 01,00 say 'здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©'
   @ 02,00 say 'Ё                              NOTA FISCAL                                     Ё'
   @ 03,00 say 'юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды'
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
   @ 21,00 say '                                                                                '
   @ 22,00 say '                                                                                '
   @ 23,00 say '                                                                                '
   @ 23,00 say '                                                                                '
   @ 24,00 say '                                                                                '

/*
   @ 19,00 say 'здддддддддбддддддддддддддбддддддддддбддддддддбддддддддддддбдддддддддддддддддддд©'
   @ 20,00 say 'Ё <F3>    Ё <F4>         Ё <F5>     Ё <F6>   Ё <F7>       Ё <F8> Imprimir      Ё'
   @ 21,00 say 'Ё Incluir Ё Incluir Item Ё Excluir  Ё Buscar Ё Excluir Nf Ё                    Ё'
   @ 22,00 say 'юдддддддддаддддддддддддддаддддддддддаддддддддаддддддддддддадддддддддддддддддддды'
*/

return


/*
-------------------------------------------------------------------------------
			   p34_itselec
-------------------------------------------------------------------------------
*/
procedure p34_itselec()

   @ 01,00 say 'здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©'
   @ 02,00 say 'Ё                              NOTA FISCAL - ITENS SELECIONADOS                Ё'
   @ 03,00 say 'юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды'
   @ 04,00 say '  Pedido For Tipo  E   Bitola Espessura Comprimento    Largura      Preco       '
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
   @ 21,00 say '                                                                                '
   @ 22,00 say '                                                                                '
   @ 23,00 say '                                                                                '
   @ 23,00 say '                                                                                '
   @ 24,00 say '                                                                                '

/*
   @ 19,00 say 'здддддддддддддддддддддддддбддддддддддддддддддддддддддддддбддддддддддддддддддддд©'
   @ 20,00 say 'Ё  <ENTER> Confirma Itens Ё <ESC> Retorna Escolha Itens  Ё                     Ё'
   @ 21,00 say 'Ё                         Ё                              Ё                     Ё'
   @ 22,00 say 'юдддддддддддддддддддддддддаддддддддддддддддддддддддддддддаддддддддддддддддддддды'
*/

return

