/*
-------------------------------------------------------------------------------
   Separacao
   VEN035.prg - Separacao
-------------------------------------------------------------------------------
*/
#include "inkey.ch"
Local Tela

abrir("EST002")
abrir("EST003")
abrir("EST004")
abrir("EST006")
abrir("EST007")
abrir("VEN001")
abrir("VEN005")  // header do pedido
abrir("VEN006")  // itens do pedido
abrir("VEN016")  // header da separacao

setcolor(W_COREDIT)
status(' P e d i d o ')

// VARIAVEIS

private W_SEQ_PED  := 0, X_PEDVEN   := SPACE(05)
PRIVATE P_HDSEP := "ËÍ",P_COLSEP := "-"
private W_FILTRO,W_OLDSCR,S_OLDSCR,V_FILTRO,W_CHAVE_ITEM,X_OBS
private FLG_EST  := .F., FLG_REVE := .F.

private X_FORMA    := space(03)   ,;
	X_TIPO     := space(05)   ,;
	X_ESTADO   := space(01)   ,;
	X_BIT_MM   := 0.00        ,;
	X_ESP_MM   := 0.00        ,;
	X_BIT_INT  := space(02)   ,;
	X_BIT_FN   := space(02)   ,;
	X_BIT_FD   := space(02)   ,;
	X_ESP_INT  := space(02)   ,;
	X_ESP_FN   := space(02)   ,;
	X_ESP_FD   := space(02)   

// --> VEN005 -> Header do Pedido
private  X_CODCLI     := X_PEDVEN := space(05)          ,;
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
	    X_SEPARACAO  := space(10)

private W_CHAVE_ITEM, X_TV := SPACE(1)

//  Tbrowse
//

private  W_FILE      := {}
private  CAMPO       := {}
private  MASCARA     := {}
private  CABECALHO   := {}
private  TAMANHO     := {}
private  BESCAPE     := {|| .T.}
private  COR         := W_COREDIT
private  TITULO      := ""
private  LININI      := 04
private  LINFIM      := 19
private  COLINI      := 02
private  COLFIM      := 77
private  BLOCK_DISP  := {|| .T. }
private  CAB_TITULO  := nil
private  BORDA       := 0

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
aadd( MASCARA   , "@E 99/99/99"          )
aadd( MASCARA   , "XXXXX"                )
aadd( MASCARA   , "XXXXXXXXXXXXXXXXXXXX" )
aadd( MASCARA   , "XXXXXXXXXXXX"         )
aadd( MASCARA   , "99"          )
aadd( MASCARA   , "999,999.99"   )

aadd( CABECALHO , "Pedido"       )
aadd( CABECALHO , "Data"         )
aadd( CABECALHO , "Cliente"      )
aadd( CABECALHO , "Razao Social" )
aadd( CABECALHO , "Comprador"    )
aadd( CABECALHO , "It"           )
aadd( CABECALHO , "Valor"        )

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

select ven005
ven005->( dbgotop() )
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

P35_tela()
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

 do while CONTINUA .and. ( (TEC:=tabmov(TABELA)) != K_ESC )

   VEN005->( dbsetorder(1) )
   W_OLDSCR := savescreen(,,,,)
   setcursor(1)
   X_PEDVEN := VEN005->PEDVEN
    setcolor( W_CORGET )
    do case
       case TEC == 28 ; help("VEN035") 
       case TEC == 27 ; return 0
       case lastkey() = K_F6  
	  p35_buscaitem() 

          VEN005->( dbsetorder(1) )
	  tabela:refreshall()

       case lastkey() = K_ENTER  
	  S_OLDSCR := savescreen(,,,,)         
	  p35_itemsep()    
	  ven005->(dbunlock())
	  restscreen(,,,,S_OLDSCR )

          VEN005->( dbsetorder(1) )
          tabela:refreshall()
      
       case lastkey() = K_F3
	  S_OLDSCR := savescreen(,,,,)         
	  P35_itemshow( X_PEDVEN )
	  ven005->(dbunlock())
	  restscreen(,,,,S_OLDSCR )
	  
          VEN005->( dbsetorder(1) )
	  tabela:refreshall()

    endcase
    setcolor( W_COREDIT )
    select VEN005
 enddo
 restscreen(,,,,W_OLDSCR )
return

//
// ----------------------------------------------------------------------------
//

/*
-------------------------------------------------------------------------------
			   P35_ITEMSEP

Objetivo : Mostra itens de separacao.
-------------------------------------------------------------------------------
*/
Procedure P35_ITEMSEP

 local W_VET := p35_vetsepitem( VEN005->PEDVEN )

 p35_telitemNF()
 W_ESC := achoice(07,03,18,76,W_VET)

return


// ---------------------------------------------------------------------
//
//
//
//
//                        Controla itens
//
//
//
//
// ---------------------------------------------------------------------

/*
-------------------------------------------------------------------------------
			   P35_ITEMSHOW
-------------------------------------------------------------------------------
*/
Function P35_itemshow( P_PEDVEN )

   local WRET := .t.
   private  P_FILTRO

   P_HEADER := {" For Tipo  E   Bitola Espessura Comprimento    Largura      Preco   Sep "}
   P_CAMPOS := {" left( VEN006->USUARIO, 1 ) +''                      " +;
		"   +VEN006->FORMA                +' '  + VEN006->TIPO+' '             " +;
		"   +VEN006->ESTADO               +'  ' + str(VEN006->BIT_MM,8,3) +' ' " +;
		"   +str(  VEN006->ESP_MM,8,3)    +'  ' + str(VEN006->COMPRIM,10,2)+' '" +;
		"   +str(  VEN006->LARGURA,10,2 ) + ' '                                " +;
		"   +str(  VEN006->PRECO,11,2)    +'   '                                 "+;
		"   +str(  VEN006->QTD_SEP,2) "}

   // P_FILTRO controla quais itens de nota serao mostrados.

   P_FILTRO := {|| (VEN006->PEDVEN = P_PEDVEN)  }
   p35_telaitem( "Separacao - Itens de Pedido" )

   select VEN006

   VEN006->( dbsetorder(1) )
   VEN006->( dbsetfilter( P_FILTRO ))
   VEN006->( dbgotop() )
   
   keyboard(chr(32))
   VEN006->( dbedit(05,03,18,76,P_CAMPOS,"P35_ITEM",, P_HEADER, P_HDSEP, P_COLSEP))
   VEN006->( dbclearfilter() )
   
   
   //
   // limpa ocorrencias marcadas com o nome do usuario
   //
   while .T.
      VEN006->( dbseek(M->USUARIO) )
      if VEN006->( ! found() )
	 exit
      end
      while VEN006->( ! rlock()); end
      VEN006->USUARIO := space(30)
      ven006->(dbunlock())
   end
   
return WRET

/*
-------------------------------------------------------------------------------
			   P35_ITEM

Objetivo : Controla itens.
-------------------------------------------------------------------------------
*/
function P35_ITEM( modo, coluna )
 
 setcursor(1)
 private WRET := 1, W_OLDSCR := savescreen(,,,,)

 if modo = 4
   do case
      case lastkey() = K_F4    ; p35_marcaitem() ; WRET := 2
      case lastkey() = K_F5    ; p35_marcapedido( VEN006->PEDVEN ) ; WRET := 2
      case lastkey() = K_F6
	 if P35_FECHASEPARACAO( X_NOTAFISCAL )
	    WRET := 0
	 else
	    WRET := 2
	 end
	 VEN006->( dbsetfilter( P_FILTRO ))
      case lastkey() = K_ESC; WRET := 0
   endcase
 end

 VEN006->( dbsetorder(1) )

 restscreen(,,,,W_OLDSCR )

return WRET


/*
-------------------------------------------------------------------------------
			   P35_MARCAITEM

Objetivo : Marca itens para separacao.
-------------------------------------------------------------------------------
*/
Procedure P35_MARCAITEM
 
 while VEN006->( ! rlock()); end
 VEN006->USUARIO := if( empty(VEN006->USUARIO), '*', space(8) )
 VEN006->( dbunlock() )

return

/*
-------------------------------------------------------------------------------
		      P35_BUSCAITEM
-------------------------------------------------------------------------------
*/
Procedure P35_BUSCAITEM
@ 14,24 say "ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿"
@ 15,24 say '³ Pedido  :              ³'
@ 16,24 say "ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ"

sombra(14,24,16,49)

while .t.
   
   X_PEDVEN     := space(05)

   @ 15,36 get X_PEDVEN     picture "@!" 
   read

   if lastkey()=K_ESC .or. empty(X_PEDVEN) ; exit; end

   if VEN005->( dbseek((zerofill(X_PEDVEN)),.t.))
     exit
   else
     message('Pedido nao cadastrado.')
     inkey(.5)
     loop
   end

   setcursor(0)
end
keyboard(chr(32))
return

/*
-------------------------------------------------------------------------------
			   P35_MARCAPEDIDO
-------------------------------------------------------------------------------
*/
Procedure P35_MARCAPEDIDO( W_PEDVEN )

 local W_OLDREC := VEN006->( recno() )

 VEN006->( dbseek( W_PEDVEN ))
 while  VEN006->( ! eof() )   // VEN006->NOTAFISCAL=X_NOTAFISCAL .and.

   while VEN006->( ! rlock() ); end
   VEN006->USUARIO := if( empty( VEN006->USUARIO ), '*', space(30) )
   VEN006->( dbunlock() )
   VEN006->( dbskip() )
 end

 VEN006->( dbgoto( W_OLDREC ))
return

/*
-------------------------------------------------------------------------------
				P35_SEPARACAO
-------------------------------------------------------------------------------
*/
Procedure P35_FECHASEPARACAO( P_NOTA )

   local W_VET    := {}, WRET := .T.
   local W_OLDREC := VEN006->( recno() )

   begin sequence

      W_VET := p35_vetitem( P_NOTA )
      W_COD := 00

      p35_itselec()

      W_ESC := achoice(07,03,18,76,W_VET)
      if W_ESC > 0

         while .t.
            p35_telaheaderNF()

              VEN006->( dbsetorder(3) )
              VEN006->( dbseek( '*' ))
              X_SEPARACAO := NOVA_SEPARA()

            if p35_getheaderNF()

               SELECT VEN016
               VEN016->(DBAPPEND())
               VEN016->SEPARACAO := X_SEPARACAO
               VEN016->DATA      := X_DT_SEPARA
               VEN016->PEDVEN    := VEN006->PEDVEN
               VEN016->OBSERVACAO:= X_OBS

               select VEN006

               while VEN006->USUARIO='*' .and. VEN006->( ! eof() )

                  X_SEQNF := 0
                  while VEN006->( ! rlock() ); end
                  X_SEQNF++
                  VEN006->SEPARACAO := X_SEPARACAO
                  VEN006->DT_SEPARA := X_DT_SEPARA
                  VEN006->TIPO_SEP  := X_TIPO_SEP
                  VEN006->USUARIO   := space(30)
                  VEN006->SEPARADO  := 'S'
                  VEN006->QTD_SEP   := VEN006->QTD_SEP +1

                  do case
                    case VEN006->ESTOQUE = 'C'
                        FLG_EST  := .T.
                        FLG_REVE := .F.
                    case VEN006->ESTOQUE = 'E'
                        FLG_EST  := .T.
                        FLG_REVE := .F.
                    case VEN006->ESTOQUE = 'R'
                        FLG_EST  := .F.
                        FLG_REVE := .T.
                  endcase

                  estoque(.T.)
                  VEN006->( dbunlock() )
                  VEN006->( dbskip() )
               end

            end
            exit
         end
      else
         WRET := .F.
      end

   end sequence

   sep35rel( FLG_EST, VEN006->PEDVEN )

   if FLG_REVE
      REL_SEP2()
   end

   VEN006->( dbgoto( W_OLDREC ))

return WRET


/*
-------------------------------------------------------------------------------
			   p35_vetitem
-------------------------------------------------------------------------------
*/
function p35_vetitem( P_NOTA )
 local WVET_RET := {}

// Cria vetor com itens da nota fiscal

 if ! empty( P_NOTA )
   VEN006->( dbclearfilter() )
   VEN006->( dbsetorder(2) )
   VEN006->( dbseek( P_NOTA ))

   while VEN006->NOTAFISCAL=P_NOTA .and. VEN006->( ! eof() )
      aadd( WVET_RET,  left( VEN006->USUARIO, 1 )+''+;
		       +VEN006->FORMA                +' '  + VEN006->TIPO+' '              +;
		       +VEN006->ESTADO               +'  ' + str(VEN006->BIT_MM,8,3) +' '  +;
		       +str(  VEN006->ESP_MM,8,3)    +'  ' + str(VEN006->COMPRIM,10,2)+' ' +;
		       +str(  VEN006->LARGURA,10,2 ) + ' '                                 +;
		       +str(  VEN006->PRECO,11,2)    +' '                                  +;
		       +str(  VEN006->QTD_SEP,2)                                            )
		       
      VEN006->( dbunlock() )
      VEN006->( dbskip() )
   end
 end
 VEN006->( dbsetorder(3) )
 VEN006->( dbseek( '*' ))

 while VEN006->USUARIO='*' .and. VEN006->( ! eof() )
      aadd( WVET_RET,  left( VEN006->USUARIO, 1 )+''+;
		       +VEN006->FORMA                +' '  + VEN006->TIPO+' '              +;
		       +VEN006->ESTADO               +'  ' + str(VEN006->BIT_MM,8,3) +' '  +;
		       +str(  VEN006->ESP_MM,8,3)    +'  ' + str(VEN006->COMPRIM,10,2)+' ' +;
		       +str(  VEN006->LARGURA,10,2 ) + ' '                                 +;
		       +str(  VEN006->PRECO,11,2)    +' '                                  +;
		       +str(  VEN006->QTD_SEP,2)                                            )
   VEN006->( dbunlock() )
   VEN006->( dbskip() )
 end

 VEN006->( dbsetfilter( W_FILTRO ))

return WVET_RET

/*
-------------------------------------------------------------------------------
			   p35_vetsepitem

Objetivo : Cria vetor com itens de pedido com separacao
-------------------------------------------------------------------------------
*/
function p35_vetsepitem( P_PEDVEN )
 local WVET_RET := {}

 VEN006->( dbclearfilter() )
 VEN006->( dbsetorder(1) )
 VEN006->( dbseek( P_PEDVEN ))

 while VEN006->PEDVEN=P_PEDVEN .and. VEN006->( ! eof() )
  if ! empty( VEN006->SEPARACAO )
      aadd( WVET_RET,  left( VEN006->USUARIO, 1 )+''+;
		       +VEN006->FORMA                +' '  + VEN006->TIPO+' '              +;
		       +VEN006->ESTADO               +'  ' + str(VEN006->BIT_MM,8,3) +' '  +;
		       +str(  VEN006->ESP_MM,8,3)    +'  ' + str(VEN006->COMPRIM,10,2)+' ' +;
		       +str(  VEN006->LARGURA,10,2 ) + ' '                                 +;
		       +str(  VEN006->PRECO,11,2)    +'  '                                  +;
		       +str(  VEN006->QTD_SEP,2)                                            )
*      VEN006->( dbunlock() )
  end
  VEN006->( dbskip() )
 end

 VEN006->( dbsetfilter( W_FILTRO ))
return WVET_RET

/*
-------------------------------------------------------------------------------
			   p35_tela
-------------------------------------------------------------------------------
*/
procedure p35_tela()
 
 @ 02,02 say 'ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿'
 @ 03,02 say '³                           Separacao - Pedido                             ³'
 @ 04,02 say 'ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´'
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
 @ 19,02 say 'ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´'
 @ 20,02 say '³ <F6> Busca    ³ <F3> Escolher    ³ <ENTER> Mostrar     ³ <ESC> Retorna   ³'
 @ 21,02 say '³               ³ Pedido           ³ Itens com Separa‡„o ³                 ³'
 @ 22,02 say 'ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ'

return

/*
-------------------------------------------------------------------------------
			   p35_telaitem
-------------------------------------------------------------------------------
*/
procedure p35_telaitem( P_TITULO )
 
 @ 02,02 say 'ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿'
 @ 03,02 say '³                                                                          ³'
 @ 03,05 say P_TITULO
 @ 04,02 say 'ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´'
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
 @ 19,02 say 'ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄ´'
 @ 20,02 say '³               ³  <f4> marcar  ³ <f5> marcar   ³ <f6> emitir     ³        ³'
 @ 21,02 say '³               ³       item    ³      pedido   ³      separacao  ³        ³'
 @ 22,02 say 'ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÙ'
return

/*
-------------------------------------------------------------------------------
			   p35_telaheaderNF
-------------------------------------------------------------------------------
*/
procedure p35_telaheaderNF()

 @ 05,15 say  'ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿'
 @ 06,15 say  '³                                                 ³'
 @ 07,15 say  '³ Separa‡„o ...:                                  ³'
 @ 08,15 say  '³ Data ........:                                  ³'
 @ 09,15 say  '³ Tipo E/C/R ..:                                  ³'
 @ 10,15 say  '³ Obs..........:                                  ³'
 @ 11,15 say  'ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ'
 sombra(05,15,11,65)

return

/*
-------------------------------------------------------------------------------
			   p35_getheaderNF
-------------------------------------------------------------------------------
*/
function p35_getheaderNF(B)

 X_DT_SEPARA := date()
 X_TIPO_SEP  := ' '
 X_OBS       := SPACE(66)
 @ 07,32 say X_SEPARACAO
 @ 08,32 get X_DT_SEPARA
 @ 09,32 get X_TIPO_SEP picture "!" valid X_TIPO_SEP $ "ECR"
 @ 10,32 get X_OBS      PICTURE "@S25"
 read

 WRET := if( lastkey()=K_ESC, .F., .T. )

return WRET

/*
-------------------------------------------------------------------------------
			   p35_itselec
-------------------------------------------------------------------------------
*/
procedure p35_itselec()

 @ 02,02 say 'ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿'
 @ 03,02 say '³               Separacao -  Pedido  - Itens Selecionados                  ³'
 @ 04,02 say 'ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´'
 @ 05,02 say '³  For Tipo  E   Bitola Espessura Comprimento    Largura      Preco    Sep ³'
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
 @ 19,02 say 'ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´'
 @ 20,02 say '³  <ENTER> Confirma Itens ³ <ESC> Retorna Escolha Itens  ³                 ³'
 @ 21,02 say '³                         ³                              ³                 ³'
 @ 22,02 say 'ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ'

return

/*
-------------------------------------------------------------------------------
			   p35_telitemNF
-------------------------------------------------------------------------------
*/
procedure p35_telitemNF()

 @ 02,02 say 'ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿'
 @ 03,02 say '³                    Separacao - Pedido - Itens                            ³'
 @ 04,02 say 'ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´'
 @ 05,02 say '³ For Tipo  E   Bitola Espessura Comprimento    Largura      Preco     Sep ³'
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
 @ 19,02 say 'ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄ´'
 @ 20,02 say '³  <ESC> Retorna ³              ³               ³                 ³        ³'
 @ 21,02 say '³                ³              ³               ³                 ³        ³'
 @ 22,02 say 'ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÙ'

return



/*

   function nova_separa()
    
       WSEQ := 01
       select VEN016
       VEN016->( dbsetorder( 2 ) )
       VEN016->( dbseek( VEN006->( PEDVEN ) ) )
       while VEN016->PEDVEN = VEN006->PEDVEN .and. VEN016->(!EOF())
        WSEQ++
        VEN016->(DBSKIP())
       end
       select VEN006
       RESP := VEN006->PEDVEN + strzero(WSEQ,2)

     RETURN(RESP)
 
*/
