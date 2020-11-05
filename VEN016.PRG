/*
-------------------------------------------------------------------------------
   Vendas
   VEN016.prg - Separacao
-------------------------------------------------------------------------------
*/
#include "inkey.ch"
Local Tela

abrir("EST001")
abrir("EST002")
abrir("EST003")
abrir("EST004")
abrir("EST005")
abrir("EST006")
abrir("EST007")
abrir("EST008")
abrir("EST009")
abrir("EST010")
abrir("EST011")
abrir("EST031")
abrir("EST040") // Caixote
abrir("VEN001")
abrir("VEN002")
abrir("VEN005")
abrir("VEN006")
abrir("VEN008")
abrir("VEN016") // Header Separacao
abrir("VEN025") // Item de Separacao
abrir("VEN099")

setcolor(W_COREDIT)
status(' S e p a r a c a o ')

// VARIAVEIS

private W_SEQ_PED  := 0, X_PEDVEN   := SPACE(05)
private P_HDSEP := "ËÍ",P_COLSEP := "-",W_TEL21 := savescreen(,,,,)
private W_OLDSCR,X_TEL21 := savescreen(,,,,)
private X_EXTRAIDA  := SPACE(20)
private X_CONFERIDA := SPACE(20)
private X_SEPARADA  := SPACE(20)
private X_PESO_RET  := 0.00

private X_FORMA    := space(03),;
        X_TIPO     := space(05),;
        X_ESTADO   := space(01),;
        X_BIT_MM   := 0.00,;
        X_ESP_MM   := 0.00,;
        X_BIT_INT  := space(02),;
        X_BIT_FN   := space(02),;
        X_BIT_FD   := space(02),;
        X_ESP_INT  := space(02),;
        X_ESP_FN   := space(02),;
        X_ESP_FD   := space(02),;
        X_SUBFORMA := space(01),;
        X_LARGMOV  := 0,;
        X_COMPMOV  := 0,;
        X_LARGSOB  := 0,;
        X_COMPSOB  := 0,;
        X_QTDPECAS := 0,;
        X_N_BLOQ   := 0,;
        X_QSOBCOR  := 0,;
        X_QSOBBLO  := 0,;
        X_OPERACAO := space(01) ,;
        X_ALMOXARI := space(03)

private X_FLG_CR_NF:= space(01)

private X_TIPOMOVI := space(03)
private X_DATAMOVI := date()
private X_QTD_KG   := 0.00
private X_QTD_INT  := 0
private X_VAL_KG   := 0.00000
private X_SUCATA   := 0.00000
private X_CUS_ITEM := 0.00000
private X_ORIGEM   := space(30)
private X_LOTE     := space(05)
private T_BIT      := .F.
private T_LARG     := .F.
private W_TAM_I    := 0.00
 
//
//  Tbrowse
//

private  W_FILE      := {}
private  CAMPO       := {}
private  MASCARA     := {}
private  CABECALHO   := {}
private  TAMANHO     := {}
private  BESCAPE     := {|| .t. }
private  COR         := W_COREDIT
private  TITULO      := " Separacao "
private  LININI      := 02
private  LINFIM      := 22
private  COLINI      := 01
private  COLFIM      := 78
private  BLOCK_DISP  := {|| .T. }
private  CAB_TITULO  := nil
private  BORDA       := 1

private  TECLA       := nil
private  TABELA      := nil

aadd( CAMPO     , "SEPARACAO" )
aadd( CAMPO     , "EXTRAIDA"  )
aadd( CAMPO     , "CONFERIDA" )
aadd( CAMPO     , "SEPARADA"  )
aadd( CAMPO     , "DATA"      )
aadd( CAMPO     , "PEDVEN"    )
aadd( CAMPO     , "STATUS"    )


aadd( MASCARA   , "@!" )
aadd( MASCARA   , "@!" )
aadd( MASCARA   , "@!" )
aadd( MASCARA   , "@!" )
aadd( MASCARA   , "99/99/99"   )
aadd( MASCARA   , "@!" )
aadd( MASCARA   , "X" )

aadd( CABECALHO , "Numero"    )
aadd( CABECALHO , "Extraida"  )
aadd( CABECALHO , "Conferida" )
aadd( CABECALHO , "Separada"  )
aadd( CABECALHO , "Data"      )
aadd( CABECALHO , "Pedido")
aadd( CABECALHO , "S")

aadd( TAMANHO   , 08 )
aadd( TAMANHO   , 16 )
aadd( TAMANHO   , 15 )
aadd( TAMANHO   , 15 )
aadd( TAMANHO   , 08 )
aadd( TAMANHO   , 06 )
aadd( TAMANHO   , 01 )

aadd( W_FILE , "VEN016" )
aadd( W_FILE , "VEN016" )
aadd( W_FILE , "VEN016" )
aadd( W_FILE , "VEN016" )
aadd( W_FILE , "VEN016" )
aadd( W_FILE , "VEN016" )
aadd( W_FILE , "VEN016" )

select VEN016
VEN016->( dbsetorder(1) )
VEN016->( dbgotop() )

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

X_TEL21 := savescreen(,,,,)

do while CONTINUA .and. ( (TEC:=tabmov(TABELA)) != K_ESC )
   mensagem('<ENTER> - Escolhe separacao                 ')
   setcursor(1)
   setcolor( W_CORGET )
   
   do case

      case lastkey() = K_ENTER

           P16_itemshow(VEN016->PEDVEN)
           restscreen(,,,,X_TEL21)

           tabela:refreshall()

      case lastkey() = K_ESC
         f_separa    := .f.
         return 0

   endcase

   setcolor( W_COREDIT )
   select VEN016
enddo

restscreen(,,,,W_TEL21)


Function P16_itemshow( P_PEDVEN )
  local WRET := .t.
  mensagem('<F7> - Escolhe item                ')

  private  W_FILE      := {}
  private  CAMPO       := {}
  private  MASCARA     := {}
  private  CABECALHO   := {}
  private  TAMANHO     := {}
  private  BESCAPE     := {|| (VEN025->SEPARACAO = VEN016->SEPARACAO) }
  private  COR         := W_COREDIT
  private  TITULO      := " Itens de Pedido "
  private  LININI      := 07
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
 
  aadd( W_FILE   , "VEN025")
  aadd( W_FILE   , "VEN025")
  aadd( W_FILE   , "VEN025")
  aadd( W_FILE   , "VEN025")
  aadd( W_FILE   , "VEN025")
  aadd( W_FILE   , "VEN025")
  aadd( W_FILE   , "VEN025")
  aadd( W_FILE   , "VEN025")
  aadd( W_FILE   , "VEN025")
  aadd( W_FILE   , "VEN025")
  aadd( W_FILE   , "VEN025")
  aadd( W_FILE   , "VEN025")
  aadd( W_FILE   , "VEN025")

  select VEN025
  VEN025->( dbsetorder(5) )
  VEN025->( dbseek( P_PEDVEN + VEN016->SEPARACAO) )
  t16_volta()
  t16_say()
  if !t16_get(); return ; end

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
 
 keyboard ' '

 do while CONTINUA .and. ( (TEC:=tabmov(TABELA)) != K_ESC )
   setcursor(1)
   W_OLDSCR := savescreen(,,,,)

   do case
      case lastkey() = K_ESC; return 0
      case lastkey() = K_F7
          atribui_16()
          if VEN025->RETORNADO = 'S'
            cons_sep()
            tabela:refreshall()
            
          else
           f_separa    := .t.
           ret_sep()
           tabela:refreshall()
         end
         restscreen(,,,,W_OLDSCR )
          
   endcase
 end
 select VEN025
 VEN025->( dbsetorder(1) )

return 


procedure cons_sep()
 private X_FORMA  := VEN025->FORMA,;
         X_TIPO   := VEN025->TIPO,;
         X_ESTADO := VEN025->ESTADO,;
         X_BIT_MM := VEN025->BIT_MM,;
         X_ESP_MM := VEN025->ESP_MM

 t16_ret()
 t16_show()
 t16_get2(.t.)
 inkey(0)
return

procedure ret_sep()
 local X_OLDSCR := savescreen(,,,,)
 t16_ret()
 t16_show()
 while .t.
  t16_get2(.F.)
  if lastkey()= 27; exit ; end
  if grava_sep() 
    restscreen(,,,,X_OLDSCR )
    do est19
    f_separa := .f.
    setcolor(W_COREDIT)
    exit
  end
 end
SELE VEN025
return  

procedure t16_show()
   
    SELECT EST004
    EST004->(DBSETORDER(3))
    EST004->(DBSEEK(VEN025->FORMA+VEN025->TIPO+VEN025->ESTADO))
    SELECT VEN025

    @ 09, 15 say STR(VEN025->SEQUENC,3)     // NUMERO DO ITEM
    @ 09, 32 say EST004->DESCRICAO          //DESCRICAO DO MATERIAL
    @ 12, 19 say STR(VEN025->QTD_PECAS,3)    // QUANTIDADE DE PECAS
    @ 13, 19 say VEN025->BIT_INT+' '+VEN025->BIT_FN+'/'+''+VEN025->BIT_FD+' '+STR(VEN025->BIT_MM,8,3)
    @ 14, 19 say VEN025->ESP_INT+' '+VEN025->ESP_FN+'/'+''+VEN025->ESP_FD+' '+STR(VEN025->ESP_MM,8,3)
    @ 15, 21 say STR(VEN025->COMPRIM,10,2)
    @ 16, 21 say str(VEN025->peso_teo,6,2)
    @ 17, 21 say EST004->COR

return    




procedure t16_ret()

   @ 08,05 say 'ÚÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿'
   @ 09,05 say '³ Item:      ³ Material:                                            ³'
   @ 10,05 say 'ÆÍÍÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍµ'
   @ 11,05 say '³                                                                   ³'
   @ 12,05 say '³ Qtd.Pcs.:                                                         ³'
   @ 13,05 say '³ Bit/Esp.:                                                         ³'
   @ 14,05 say '³ Bit/Larg:                                                         ³'
   @ 15,05 say '³ Comprimento:                    ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿  ³'
   @ 16,05 say '³ Peso pedido:                    ³ Peso pesado:                 ³  ³'
   @ 17,05 say '³ Cor........:                    ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ  ³'
   @ 18,05 say '³                                                                   ³'
   @ 19,05 say 'ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ'

   sombra(08,05,19,73)

return

procedure t16_volta()

@ 02,00 say 'ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ Retorna Separacao ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿'
@ 03,00 say '³ Numero:                  Data:                                               ³'
@ 04,00 say '³ Pedido:                  Data:                                               ³'
@ 05,00 say '³ Extraida por:                          Conferida por:                        ³'
@ 06,00 say '³ Separado:                                                                    ³'
@ 07,00 say 'ÆÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍµ'
@ 08,00 say '³                                                                              ³'
@ 09,00 say '³                                                                              ³'
@ 10,00 say '³                                                                              ³'
@ 11,00 say '³                                                                              ³'
@ 12,00 say '³                                                                              ³'
@ 13,00 say '³                                                                              ³'
@ 14,00 say '³                                                                              ³'
@ 15,00 say '³                                                                              ³'
@ 16,00 say '³                                                                              ³'
@ 17,00 say '³                                                                              ³'
@ 18,00 say '³                                                                              ³'
@ 19,00 say '³                                                                              ³'
@ 20,00 say '³                                                                              ³'
@ 21,00 say '³                                                                              ³'
@ 22,00 say 'ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ'
return

procedure t16_say()
 @ 03,11 say VEN016->SEPARACAO
 @ 03,34 say VEN016->DATA
 @ 04,11 say VEN006->PEDVEN
 @ 04,34 say VEN006->DT_EMISSAO
RETURN

procedure t16_get()
 X_EXTRAIDA := VEN016->EXTRAIDA
 X_CONFERIDA := VEN016->CONFERIDA
 X_SEPARADA := VEN016->SEPARADA
 while .t.
  @ 05,17 get X_EXTRAIDA PICT "@!"
  @ 05,57 get X_CONFERIDA
  @ 06,13 get X_SEPARADA
  if VEN016->STATUS='R'
   clear gets
 else
  read
 end
  if lastkey()<>27 
    return .t. 
  else  
    return .f.
  end
 end

return

procedure t16_get2(T)
X_PESO_RET := VEN025->PESO_COBRA

@ 16,57 get X_PESO_RET PICT "99999.99" valid tes_peso_b(X_PESO_RET)
IF T
  CLEAR GETS
ELSE
 READ
END

RETURN


procedure grava_sep()
 local WRET := .F.
 if conf('Confirma ?')
   while VEN016->(!RLOCK()); loop; end
   VEN016->EXTRAIDA  := X_EXTRAIDA
   VEN016->CONFERIDA := X_CONFERIDA
   VEN016->SEPARADA  := X_SEPARADA
   VEN016->STATUS     := 'R'
   VEN016->(DBUNLOCK())
   estoque(.f.)
   while VEN025->(!RLOCK()); loop; end
   VEN025->PESO_COBRA := X_PESO_RET
   
   VEN025->RETORNADO  := 'S'
   VEN025->(DBUNLOCK())
   WRET := .t.
 end

 *  comis_vend()
return WRET


function tes_peso_b(teste)
 local WRET := .t.
 IF teste < VEN025->PESO_TEO
   mensboxv({'Peso retornado menor que peso pedido !!'})
   WRET := .F.
 END
RETURN WRET



procedure t16_consu()

   @ 08,05 say 'ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ  Consulta  ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿'
   @ 09,05 say '³ Item:        Material:                                            ³'
   @ 10,05 say 'ÃÄ Ida ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄ Volta ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´'
   @ 11,05 say '³                                 ³                                 ³'
   @ 12,05 say '³ Qtd.Pcs.:                       ³ Cortado de:                     ³'
   @ 13,05 say '³ Bit/Esp.:                       ³ Sobra mm..:                     ³'
   @ 14,05 say '³ Bit/Larg:                       ³ N.Pcs.....:                     ³'
   @ 15,05 say '³ Comprimento:                    ³ Lote......:                     ³'
   @ 16,05 say '³ Peso pedido:                    ³ Peso......:                     ³'
   @ 17,05 say '³ Cor........:                    ³                                 ³'
   @ 18,05 say '³ Preco......:                    ³ Preco.....:                     ³'
   @ 19,05 say 'ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ'

   sombra(08,05,19,73)

return


procedure atribui_16()

   X_FORMA    := VEN025->FORMA
   X_TIPO     := VEN025->TIPO
   X_ESTADO   := VEN025->ESTADO
   X_BIT_MM   := VEN025->BIT_MM
   X_ESP_MM   := VEN025->ESP_MM
   X_BIT_INT  := VEN025->BIT_INT
   X_BIT_FN   := VEN025->BIT_FN
   X_BIT_FD   := VEN025->BIT_FD
   X_ESP_INT  := VEN025->ESP_INT
   X_ESP_FN   := VEN025->ESP_FN
   X_ESP_FD   := VEN025->ESP_FD
   X_OPERACAO := 'S'
   X_ALMOXARI := '001'
   X_TIPOMOVI := '002'
   X_DATAMOVI := DATE()
   X_QTD_KG   := EST010->QTD_KG
   X_QTD_INT  := EST010->QTD_INT
   X_VAL_KG   := EST010->VAL_KG
   X_ORIGEM   := EST010->ORIGEM
   X_SUBFORMA := VEN025->SUBFORMA

return

procedure comis_vend()
  local W_TOTAL := 0.00
  sele VEN006
  if VEN006->(dbseek(VEN016->PEDVEN))
    while VEN006->PEDVEN=VEN016->PEDVEN .and. VEN006->(!EOF())
         IF VEN006->SEPARADO # ' '
           W_TOTAL += (VEN006->PRECO * VEN006->COM_VEND /100)
         END
         VEN006->(dbskip())
    end
    VEN008->(dbsetorder(2))
    if VEN008->(dbseek(VEN006->PEDVEN))
      while VEN008->(!rlock()); loop ; end
    else
      VEN008->( dbappend())
    end
    VEN005->(dbseek(VEN006->PEDVEN))
    SELE VEN008
    VEN008->PEDVEN := VEN006->PEDVEN
    VEN008->CODVEN := VEN005->CODVEN
    VEN008->VALOR  := W_TOTAL
    VEN008->DATA   := DATE()
 end
return
