/*

   ER1400.PRG - Extrato de Cliente
*/
#include "inkey.ch"
altd(1)

telanum('SCE1400','ER1400')

abrir("CR0300")
abrir("CR0400")
abrir("ER0600")
abrir("ER1000")
abrir("ER1100")
abrir("VEN001")
abrir("VEN050")

PRIVATE X_CODCLI       := space(5),;
        X_DUPLICATA    := space(8),;
        X_SEQUENCIA    := space(1),;
        X_DT_EMISSAO   := ctod("  /  /  "),;
        X_DT_VENC      := ctod("  /  /  "),;
        X_DT_PAG       := ctod("  /  /  "),;
        X_STATUS       := " ",;
        X_TIPOVENDA    := space(2),;
        X_FORMAPAG     := space(2),;
        X_VALOR        := 0.00,;
        X_VALOR_NF     := 0.00,;
        X_TOTAL        := 0.00,;
        X_ABATI        := 0.00,;
        X_TXADM        := 0.00,;
        X_QTD_CH       := 0
        
X_ACORDO := ' '
W_VL_JU         := 0.00
W_VL_DUP        := 0.00
W_VL_TX         := 0.00
W_VL_PEND       := 0.00
W_TXADM         := 0.00
W_VL_CALC       := 0.00
W_JU_CLI        := 0.00
W_TOT_JU        := 0.00
W_TOT_VL        := 0.00
W_TOT_TOT       := 0.00

do while .T.

   setcolor( W_COR_003 )

   X_CODCLI := space(05)

   t1_E1400()

   W_T1_cr1400 := savescreen(,,,,)

   @ 03,27 get X_CODCLI picture "@!" valid tes_codcli(X_CODCLI,03,27)
   read

   if lastkey()=K_ESC; exit; end

   private  W_FILE      := {}
   private  CAMPO       := {}
   private  MASCARA     := {}
   private  CABECALHO   := {}
   private  TAMANHO     := {}
   private  BESCAPE     := {|| ER1000->CODCLI = X_CODCLI }
   private  COR         := W_COR_003
   private  TITULO      := " Movimento "
   private  LININI      := 04
   private  LINFIM      := 21
   private  COLINI      := 03
   private  COLFIM      := 76
   private  BLOCK_DISP  := {|| .T. }
   private  CAB_TITULO  := nil
   private  BORDA       := 1
   private  exib        := .f.

   private  TECLA       := nil
   private  TABELA      := nil

   aadd( CAMPO     , "DUPLICATA"        )
   aadd( CAMPO     , "SEQUENCIA"        )
   aadd( CAMPO     , "DT_VENC"          )
   aadd( CAMPO     , "DT_PAG"           )
   aadd( CAMPO     , "TIPOVENDA"        )
   aadd( CAMPO     , "FORMAPAG"         )
   aadd( CAMPO     , "ACORDO"           )   
   aadd( CAMPO     , "FLG_ABATI"        )
   aadd( CAMPO     , "FLG_TXADM"        )
   aadd( CAMPO     , "VALOR"            )
   aadd( CAMPO     , "JUROS"            )
   aadd( CAMPO     , "STATUS"           )

   aadd( MASCARA   , "@!"               )
   aadd( MASCARA   , "@!"               )
   aadd( MASCARA   , "  /  /  "         )
   aadd( MASCARA   , "  /  /  "         )
   aadd( MASCARA   , "@!"               )
   aadd( MASCARA   , "@!"               )
   aadd( MASCARA   , "!"                )
   aadd( MASCARA   , "!"                )
   aadd( MASCARA   , "!"                )
   aadd( MASCARA   , "99,999,999.99"    )
   aadd( MASCARA   , "99,999.99"        )
   aadd( MASCARA   , "!"                )

   aadd( CABECALHO , "Duplicata"        )
   aadd( CABECALHO , "Sq"               )
   aadd( CABECALHO , "Dt.Venc"          )
   aadd( CABECALHO , "Dt.Pag."          )
   aadd( CABECALHO , "Tv"               )
   aadd( CABECALHO , "Fp"               )
   aadd( CABECALHO , "Ac"               )
   aadd( CABECALHO , "Ab"               )
   aadd( CABECALHO , "Dc"               )
   aadd( CABECALHO , "Valor"            )
   aadd( CABECALHO , "Juros"            )
   aadd( CABECALHO , "St"               )

   aadd( TAMANHO   , 09                 )
   aadd( TAMANHO   , 01                 )
   aadd( TAMANHO   , 08                 )
   aadd( TAMANHO   , 08                 )
   aadd( TAMANHO   , 02                 )
   aadd( TAMANHO   , 02                 )
   aadd( TAMANHO   , 02                 )
   aadd( TAMANHO   , 02                 )
   aadd( TAMANHO   , 02                 )
   aadd( TAMANHO   , 14                 )
   aadd( TAMANHO   , 10                 )
   aadd( TAMANHO   , 02                 )

   aadd( W_FILE    , "ER1000"           )
   aadd( W_FILE    , "ER1000"           )
   aadd( W_FILE    , "ER1000"           )
   aadd( W_FILE    , "ER1000"           )
   aadd( W_FILE    , "VEN050"           )
   aadd( W_FILE    , "ER1000"           )
   aadd( W_FILE    , "ER1000"           )
   aadd( W_FILE    , "ER1000"           )
   aadd( W_FILE    , "ER1000"           )
   aadd( W_FILE    , "ER1000"           )
   aadd( W_FILE    , "ER1000"           )
   aadd( W_FILE    , "ER1000"           )

   select ER1000

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
                        W_FILE           ;
                      )

   E1400_pendente()

   VEN050->( dbsetorder(1) )

   ER1000->( dbsetorder(5))
   ER1000->( dbseek(X_CODCLI) )

   ER1000->( dbsetrelation( "VEN050", {|| ER1000->DUPLICATA }, "ER1000->DUPLICATA" ) )

   CONTINUA := .T.

   do while CONTINUA .and. ( (TEC:=tabmov(TABELA)) != K_ESC )
     AREG := ER1000->(RECNO())
     W_TEL1400 := savescreen(,,,,)

      do case

         case TEC == 28 ; help("CR1400")

         case TEC == 27 ; return 0

         case TEC = K_ENTER  && Consulta f6
              if ER1000->(!eof())
                 ed_E1400()
                 restscreen(,,,,W_TEL1400)
                 E1400_pendente()
              end
              select ER1000
              ER1000->(dbsetorder(5))
              ER1000->(dbseek("X_CODCLI"))
              TABELA:refreshall()

         case TEC = K_F11 && Juros Duplicata
              if ER1000->STATUS ='R'
                mensboxv({"Duplicata ja foi recebida !!"})
              else
                if ER1000->(!eof())
                   E1400_j_duplicata()
                   restscreen(,,,,W_TEL1400)
                   cr1400_pendente()
                end
              end
              select ER1000
              ER1000->(dbsetorder(5))
              ER1000->(dbseek("X_CODCLI"))
              TABELA:refreshall()

         case TEC = K_F12  && Juros Cliente
              if ER1000->(!eof())
                 cr1400_j_cliente()
                 restscreen(,,,,W_TEL1400)
                 cr1400_pendente()
              end
              select ER1000
              ER1000->(dbsetorder(5))
              ER1000->(dbseek("X_CODCLI"))
              TABELA:refreshall()

         case TEC = K_ESC
              CONTINUA := .F.

      end

      select ER1000
      ER1000->(dbsetorder(5))
      ER1000->(DBGOTO(AREG))
   enddo

   restscreen(,,,,W_T1_cr1400)

enddo

close data

return

/*
-------------------------------------------------------------------------------
Procedimento .: ed_E1400
Objetivo .....: Edita Duplicata
-------------------------------------------------------------------------------
*/
function ed_E1400()

setcursor(1)

OLDREC := ER1000->( recno() )

X_DUPLICATA     := ER1000->DUPLICATA
X_SEQUENCIA     := ER1000->SEQUENCIA
X_DT_VENC       := ER1000->DT_VENC
X_DT_PAG        := ER1000->DT_PAG
X_FORMAPAG      := ER1000->FORMAPAG
X_QTD_CH        := ER1000->QTD_CH
X_VALOR         := ER1000->VALOR
X_JUROS         := ER1000->JUROS
X_ABATI         := ER1000->ABATIMENTO
X_TXADM         := ER1000->TXADM
X_STATUS        := ER1000->STATUS
X_ACORDO        := ER1000->ACORDO
X_VALOR_NF      := 0.00

TL_E1400()

tes_Eduplicata(04,26)

VEN050->(dbsetorder(1))
if VEN050->(dbseek(X_DUPLICATA))
   X_CODCLI     := VEN050->CODCLI
   X_DT_EMISSAO := VEN050->DT_EMISSAO
   X_VALOR_NF   := VEN050->VALOR
   X_TIPOVENDA  := VEN050->TIPOVENDA
else
   mensbeep(" Nota Fiscal Inexistente !")
   return
end

tes_tipovenda(12,27)
tes_formapag (13,27)

if ER1000->FLG_ABATI = 'X' .OR. ER1000->FLG_ABATI ='X' .OR. X_JUROS > 0
   @ 09,45 say 'Juros.........:'
   @ 09,62 say X_JUROS           pict "@E 999,999,999.99"
   if ER1000->STATUS = "P"
      @ 10,45 say 'Total a Pagar.:'
   else
      @ 10,45 say 'Total Pago....:'
   end
   W_TOT_PG := X_VALOR + X_JUROS + X_TXADM - X_ABATI
   @ 10,62 say W_TOT_PG          pict "@E 999,999,999.99"
end

@ 07,27 say X_DT_EMISSAO  pict "  /  /  "
@ 09,27 say X_DT_VENC     pict "  /  /  "
@ 10,27 say X_VALOR       pict "@E 999,999,999.99"
@ 16,27 say X_VALOR_NF    pict "@E 999,999,999.99"
@ 16,67 say X_ABATI       pict "@E 999,999.99"
@ 17,67 say X_TXADM       pict "@E 999,999.99"

if X_QTD_CH > 0
   select ER0600
   ER0600->(dbsetorder(2))
   if ER0600->(dbseek(X_DUPLICATA+X_SEQUENCIA))
      @ 14,27 say ER0600->DT_PREDATA
      @ 14,39 say ER0600->NOME
      @ 15,40 say VEN001->DDD01
      @ 15,47 say VEN001->TEL01 pict  "@R 999-9999"
   else
      mensbeep('Nao existe o Cheque para a Duplicata !')
      return
   end
end

ER1000->( dbgoto( OLDREC ) )
IF X_ACORDO = "X"
  SHOW_EACORDO()
ELSE
  INKEY (0)
END

setcursor(0)

return nil

/*
-----------------------------------------------------------------------------
                             Procedimento Tela
-----------------------------------------------------------------------------
*/
procedure T1_E1400()

   @ 02,02 say '旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴커'
   @ 03,02 say '? Cliente.............:                                                   ?
   @ 04,02 say '?旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴커 ?
   @ 05,02 say '??                                                                     ??
   @ 06,02 say '??                                                                     ??
   @ 07,02 say '??                                                                     ??
   @ 08,02 say '??                                                                     ??
   @ 09,02 say '??                                                                     ??
   @ 10,02 say '??                                                                     ??
   @ 11,02 say '??                                                                     ??
   @ 12,02 say '??                                                                     ??
   @ 13,02 say '??                                                                     ??
   @ 14,02 say '??                                                                     ??
   @ 15,02 say '??                                                                     ??
   @ 16,02 say '??                                                                     ??
   @ 17,02 say '??                                                                     ??
   @ 18,02 say '??                                                                     ??
   @ 19,02 say '??                                                                     ??
   @ 20,02 say '??                                                                     ??
   @ 21,02 say '?읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴켸 ?
   @ 22,02 say '?                                                                         ?
   @ 23,02 say '읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴켸'
return

/*
-------------------------------------------------------------------------------
-------------------------------------------------------------------------------
*/
procedure tL_E1400()

setcolor( W_COR_003 )
   @ 05,02 say '?
   @ 05,77 say '?
setcolor( W_COR_003 )
   @ 04,03 say '  Duplicata...........:         -                                         '
   @ 05,03 say '                                                                          '
   @ 06,03 say '                                                                          '
   @ 07,03 say '  Data de emisso.....:                                                   '
   @ 08,03 say '                                                                          '
   @ 09,03 say '  Data de vencimento..:                                                   '
   
   if ER1000->STATUS = "P"
     @ 10,03 say '  Valor a receber.....:                                                   '
   else
     @ 10,03 say '  Valor pago..........:                                                   '
   end

   @ 11,03 say '                                                                          '
   @ 12,03 say '  Tipo de Venda.......:                                                   '
   @ 13,03 say '  Forma de Pagamento..:                                                   '
   @ 14,03 say '  Cheque Datado para..:          -                                        '
   @ 15,03 say '                                 - (     )                                '
   @ 16,03 say '  Valor Total da Nota.:                   Abatimento...:                  '
   @ 17,03 say '                                          Desp.Cobr....:                  '
   @ 18,03 say '                                                                          '
   @ 19,03 say '                                                                          '
   @ 20,03 say '                                                                          '
   @ 21,03 say '                                                                          '
   @ 22,03 say '                                                                          '

return

/*
-------------------------------------------------------------------------------
                       CALCULA TOTAL DE DUPLICATAS PENDENTES
-------------------------------------------------------------------------------
*/
function E1400_pendente()
   local WRET := .T., OLDREC := ER1000->( recno() )
         W_VL_T := W_VL_P := W_VL_J := W_VL_AB := W_VL_TX := 0.00

   ER1000->( dbsetorder(6))
   ER1000->( dbseek("P"+X_CODCLI) )

   while ER1000->( ! eof() )
      if ER1000->STATUS = "P" .and. ;
         ER1000->CODCLI = X_CODCLI
         W_VL_P  := W_VL_P  + ER1000->VALOR
         W_VL_AB := W_VL_AB + ER1000->ABATIMENTO
         W_VL_TX := W_VL_TX + ER1000->TXADM

         W_VL_J = W_VL_J + ER1000->JUROS
      end
      if ER1000->STATUS <> "P" .or. ER1000->CODCLI != X_CODCLI
         exit
      end
      ER1000->( dbskip() )
   end

   W_VL_T := W_VL_P + W_VL_J + W_VL_TX -  W_VL_AB

   @ 21,02 say '쳐컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴캑'
   @ 22,02 say '?Pendente.:                Juros.:               Total...:                ?
   @ 23,02 say '읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴켸'
   @ 22,13 say W_VL_P picture "@E 99,999,999.99"
   @ 22,37 say W_VL_J picture "@E 99,999,999.99"
   @ 22,62 say W_VL_T picture "@E 999,999,999.99"

   ER1000->( dbgoto( OLDREC ) )

return WRET

/*
-------------------------------------------------------------------------------
Procedimento .: E1400_j_duplicata
Objetivo .....: Calcula Juros p/ duplicata
-------------------------------------------------------------------------------
*/
function E1400_j_duplicata()
local OLDREC := ER1000->( recno() )
setcursor(1)

W_VL_TOT        := 0.00
W_VL_DUP        := 0.00
W_VL_CALC       := 0.00
W_JU_DUP        := 0.00
W_DT_VENC       := ctod('')
W_DT_PAG        := ctod('')

@ 10,14 say '旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴?
@ 11,14 say '?Duplicata..:         /  Dt.Venc:   /  /   ?
@ 12,14 say '?         Valor Devido s/Juros             ?
@ 13,14 say '?                                          ?
@ 14,14 say '?Dt.Pagto...:   /  /     Juros..:       %  ?
@ 15,14 say '?   Vl.Juros        Valor a Pagar          ?
@ 16,14 say '?                                          ?
@ 17,14 say '읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴?
sombra(10,14,17,58)

W_VL_DUP := ER1000->VALOR
W_VL_TOT := W_VL_DUP + ER1000->TXADM - ER1000->ABATIMENTO

@ 11,29 say ER1000->DUPLICATA picture "@!"
@ 11,38 say ER1000->SEQUENCIA picture "@!"
@ 11,49 say ER1000->DT_VENC   picture "99/99/99"
@ 13,37 say W_VL_TOT          picture "@E 999,999,999.99"

do while .T.

   W_VL_CALC := 0.00

   @ 14,29 get W_DT_PAG          picture "99/99/99"
   @ 14,49 get W_JU_DUP          picture "@E 999.99"
   read
   if lastkey() = K_ESC; exit;end

   W_VL_JU   := calc_juros (W_VL_DUP,ER1000->DT_VENC,W_JU_DUP,W_DT_PAG)
   W_VL_CALC := W_VL_DUP + W_VL_JU + ER1000->TXADM - ER1000->ABATIMENTO
   @ 16,27 say W_VL_CALC         picture "@E 999,999,999.99"
   @ 16,18 say W_VL_JU           picture "@E 999,999.99"

end

setcursor(0)

return nil

/*
-------------------------------------------------------------------------------
Procedimento .: E1400_j_cliente
Objetivo .....: Calcula Juros p/ cliente
-------------------------------------------------------------------------------
*/
function E1400_j_cliente()
local OLDREC   := ER1000->( recno() )
local WVET_RET := {}
setcursor(1)
W_TXADM   := 0.00
W_ABAT    := 0.00

W_VL_JU   := 0.00
W_VL_DUP  := 0.00
W_VL_TX   := 0.00
W_VL_PEND := 0.00
W_TXADM   := 0.00
W_VL_CALC := 0.00
W_JU_CLI  := 0.00
W_TOT_JU  := 0.00
W_TOT_VL  := 0.00
W_TOT_TOT := 0.00
W_DT_VENC := ctod('')
W_DT_PAG  := ctod('')

@ 05,10 say '旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴커'
@ 06,10 say '?Dt.Pagto...:   /  /     Juros..:       %                     ?
@ 07,10 say '쳐컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴캑'
@ 08,10 say '?Duplicata   Dt.Venc.        Valor      Juros           Total ?
@ 09,10 say '?                                                             ?
@ 10,10 say '?                                                             ?
@ 11,10 say '?                                                             ?
@ 12,10 say '?                                                             ?
@ 13,10 say '?                                                             ?
@ 14,10 say '?                                                             ?
@ 15,10 say '?                                                             ?
@ 16,10 say '?                                                             ?
@ 17,10 say '?                                                             ?
@ 18,10 say '?                                                             ?
@ 19,10 say '쳐컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴캑'
@ 20,10 say '?Jr.:             Vl.:                 Total.:                ?
@ 21,10 say '읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴켸'
sombra(05,10,21,73)

do while .T.

   WVET_RET := {}

   @ 06,25 get W_DT_PAG          picture "99/99/99"
   @ 06,45 get W_JU_CLI          picture "@E 999.99"
   read
   W_TOT_JU  := 0.00
   W_TOT_VL  := 0.00
   W_TOT_TOT := 0.00
   W_TXADM   := 0.00
   W_ABAT    := 0.00
   if lastkey() = K_ESC; exit;end

   ER1000->( dbsetorder(6))
   ER1000->( dbseek("P" + X_CODCLI) )
   while ER1000->( ! eof() )       .and. ;
         ER1000->CODCLI = X_CODCLI .and. ;
         ER1000->STATUS = "P"

         VEN050->(dbsetorder(1))
         VEN050->(dbseek(X_DUPLICATA))

         W_VL_DUP  := ER1000->VALOR
         W_VL_JU   := calc_juros (W_VL_DUP,ER1000->DT_VENC,W_JU_CLI,W_DT_PAG)
         W_TOT_JU  := W_TOT_JU + W_VL_JU
         W_TOT_VL  := W_TOT_VL + W_VL_DUP

         aadd( WVET_RET, ' '+ ER1000->DUPLICATA     + '/' + ER1000->SEQUENCIA               + ' ' + ;
                            + dtoc(ER1000->DT_VENC) + ' ' + str(W_VL_DUP,13,2)              + ' ' + ;
                            + str (W_VL_JU,10,2 )   + ' ' + str(W_VL_JU + W_VL_DUP,13,2)  +' ' )
         W_TXADM += ER1000->TXADM
         W_ABAT  += ER1000->ABATIMENTO
         ER1000->( dbskip() )
   end

   W_ESC := achoice(09,12,18,70,WVET_RET)

   W_TOT_TOT := W_TOT_JU + W_TOT_VL+W_TXADM - W_ABAT

   @ 20,16 say W_TOT_JU          picture "@E 999,999.99"
   @ 20,33 say W_TOT_VL          picture "@E 999,999,999.99"
   @ 20,57 say W_TOT_TOT         picture "@E 999,999,999.99"

end

setcursor(0)

return nil


