/*

   CR1400.PRG - Extrato de Cliente
   * DC = FLG_TXADM
*/
#include "inkey.ch"
altd(1)

telanum('SCE1400','CR1400')

abrir("CR0300")
abrir("CR0400")
abrir("CR0600")
abrir("CR1000")
abrir("CR1100")
abrir("VEN001")
abrir("VEN012")

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

   setcolor(W_COREDIT)

   X_CODCLI := space(05)

   t1_cr1400()

   W_T1_cr1400 := savescreen(,,,,)

   @ 03,27 get X_CODCLI picture "@!" valid tes_codcli(X_CODCLI,03,27)
   read

   if lastkey()=K_ESC; exit; end

   private  W_FILE      := {}
   private  CAMPO       := {}
   private  MASCARA     := {}
   private  CABECALHO   := {}
   private  TAMANHO     := {}
   private  BESCAPE     := {|| CR1000->CODCLI = X_CODCLI }
   private  COR         := W_COREDIT
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
   aadd( MASCARA   , "99,999,999.99"   )
   aadd( MASCARA   , "99,999.99"           )
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

   aadd( W_FILE    , "CR1000"           )
   aadd( W_FILE    , "CR1000"           )
   aadd( W_FILE    , "CR1000"           )
   aadd( W_FILE    , "CR1000"           )
   aadd( W_FILE    , "VEN012"           )
   aadd( W_FILE    , "CR1000"           )
   aadd( W_FILE    , "CR1000"           )
   aadd( W_FILE    , "CR1000"           )
   aadd( W_FILE    , "CR1000"           )
   aadd( W_FILE    , "CR1000"           )
   aadd( W_FILE    , "CR1000"           )
   aadd( W_FILE    , "CR1000"           )

   select CR1000

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

   cr1400_pendente()

   VEN012->( dbsetorder(1) )

   CR1000->( dbsetorder(5))
   CR1000->( dbseek(X_CODCLI) )

   CR1000->( dbsetrelation( "VEN012", {|| CR1000->DUPLICATA }, "CR1000->DUPLICATA" ) )

   CONTINUA := .T.

   do while CONTINUA .and. ( (TEC:=tabmov(TABELA)) != K_ESC )
     AREG := CR1000->(RECNO())
     W_TEL1400 := savescreen(,,,,)

      do case

         case TEC == 28 ; help("CR1400")

         case TEC == 27 ; return 0

         case TEC = K_ENTER  && Consulta f6
              if CR1000->(!eof())
                 ed_cr1400()
                 restscreen(,,,,W_TEL1400)
                 cr1400_pendente()
              end
              select CR1000
              CR1000->(dbsetorder(5))
              CR1000->(dbseek("X_CODCLI"))
              TABELA:refreshall()

         case TEC = K_F11 && Juros Duplicata
              if CR1000->STATUS ='R'
                mensboxv({"Duplicata ja foi recebida !!"})
              else
                if CR1000->(!eof())
                   cr1400_j_duplicata()
                   restscreen(,,,,W_TEL1400)
                   cr1400_pendente()
                end
              end
              select CR1000
              CR1000->(dbsetorder(5))
              CR1000->(dbseek("X_CODCLI"))
              TABELA:refreshall()

         case TEC = K_F12  && Juros Cliente
              if CR1000->(!eof())
                 cr1400_j_cliente()
                 restscreen(,,,,W_TEL1400)
                 cr1400_pendente()
              end
              select CR1000
              CR1000->(dbsetorder(5))
              CR1000->(dbseek("X_CODCLI"))
              TABELA:refreshall()

         case TEC = K_ESC
              CONTINUA := .F.

      end

      select CR1000
      CR1000->(dbsetorder(5))
      CR1000->(DBGOTO(AREG))
   enddo

   restscreen(,,,,W_T1_cr1400)

enddo

close data

return

/*
-------------------------------------------------------------------------------
Procedimento .: ed_cr1400
Objetivo .....: Edita Duplicata
-------------------------------------------------------------------------------
*/
function ed_cr1400()

setcursor(1)

OLDREC := CR1000->( recno() )


X_DUPLICATA     := CR1000->DUPLICATA
X_SEQUENCIA     := CR1000->SEQUENCIA
X_DT_VENC       := CR1000->DT_VENC
X_DT_PAG        := CR1000->DT_PAG
X_FORMAPAG      := CR1000->FORMAPAG
X_QTD_CH        := CR1000->QTD_CH
X_VALOR         := CR1000->VALOR
X_JUROS         := CR1000->JUROS
X_ABATI         := CR1000->ABATIMENTO
X_TXADM         := CR1000->TXADM
X_STATUS        := CR1000->STATUS
X_ACORDO        := CR1000->ACORDO
X_VALOR_NF      := 0.00

t2_cr1400()

tes_duplicata(04,26)

VEN012->(dbsetorder(1))
if VEN012->(dbseek(X_DUPLICATA))
   X_CODCLI     := VEN012->CODCLI
   X_DT_EMISSAO := VEN012->DT_EMISSAO
   X_VALOR_NF   := VEN012->VALOR
   X_TIPOVENDA  := VEN012->TIPOVENDA
else
   mensbeep(" Nota Fiscal Inexistente !")
   return
end

tes_tipovenda(12,27)
tes_formapag (13,27)
if CR1000->FLG_ABATI = 'X' .OR. CR1000->FLG_ABATI ='X' .OR. X_JUROS > 0 
   @ 09,45 say 'Juros.........:'
   @ 09,62 say X_JUROS           pict "@E 999,999,999.99"
   if CR1000->STATUS = "P"
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

if X_QTD_CH > 0 .and. CR1000->STATUS # "C"
   select CR0600
   CR0600->(dbsetorder(2))
   if CR0600->(dbseek(X_DUPLICATA+X_SEQUENCIA))
      @ 14,27 say CR0600->DT_PREDATA
      @ 14,39 say CR0600->NOME
      @ 15,40 say VEN001->DDD01
      @ 15,47 say VEN001->TEL01 pict  "@R 999-9999"
   else
      mensbeep('Nao existe o Cheque para a Duplicata !')
      return
   end
end

CR1000->( dbgoto( OLDREC ) )
IF X_ACORDO = "X"
  SHOW_ACORDO()
ELSE
  INKEY (0)
END

setcursor(0)

return nil

/*
-------------------------------------------------------------------------------
Procedimento .: T2_cr1400
Objetivo .....: Menu rapido
-------------------------------------------------------------------------------
*/
procedure t2_cr1400()

   setcolor( W_COREDIT )
   @ 05,02 say '³'
   @ 05,77 say '³'
   setcolor( W_CORGET )
   @ 04,03 say '  Duplicata...........:         -                                         '
   @ 05,03 say '                                                                          '
   @ 06,03 say '                                                                          '
   @ 07,03 say '  Data de emiss„o.....:                                                   '
   @ 08,03 say '                                                                          '
   @ 09,03 say '  Data de vencimento..:                                                   '
   
   IF CR1000->STATUS = "P"
     @ 10,03 say '  Valor a receber.....:                                                   '
   ELSE
     @ 10,03 say '  Valor pago..........:                                                   '
   END

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
function cr1400_pendente()
   local WRET := .T., OLDREC := CR1000->( recno() )
         W_VL_T := W_VL_P := W_VL_J := W_VL_AB := W_VL_TX := 0.00

   CR1000->( dbsetorder(6))
   CR1000->( dbseek("P"+X_CODCLI) )

   while CR1000->( ! eof() )
      if CR1000->STATUS = "P" .and. ;
         CR1000->CODCLI = X_CODCLI
         W_VL_P  := W_VL_P  + CR1000->VALOR
         W_VL_AB := W_VL_AB + CR1000->ABATIMENTO 
         W_VL_TX := W_VL_TX + CR1000->TXADM

         W_VL_J = W_VL_J + CR1000->JUROS
      end
      if CR1000->STATUS <> "P" .or. CR1000->CODCLI != X_CODCLI
         exit
      end
      CR1000->( dbskip() )
   end

   W_VL_T := W_VL_P + W_VL_J + W_VL_TX -  W_VL_AB

   @ 21,02 say 'ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´'
   @ 22,02 say '³ Pendente.:                Juros.:               Total...:                ³'
   @ 23,02 say 'ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ'
   @ 22,13 say W_VL_P picture "@E 99,999,999.99"
   @ 22,37 say W_VL_J picture "@E 99,999,999.99"
   @ 22,62 say W_VL_T picture "@E 999,999,999.99"

   CR1000->( dbgoto( OLDREC ) )

return WRET

/*
-----------------------------------------------------------------------------
                             Procedimento Tela
-----------------------------------------------------------------------------
*/
procedure T1_CR1400()

   @ 02,02 say 'ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿'
   @ 03,02 say '³  Cliente.............:                                                   ³'
   @ 04,02 say '³ ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿ ³'
   @ 05,02 say '³ ³                                                                      ³ ³'
   @ 06,02 say '³ ³                                                                      ³ ³'
   @ 07,02 say '³ ³                                                                      ³ ³'
   @ 08,02 say '³ ³                                                                      ³ ³'
   @ 09,02 say '³ ³                                                                      ³ ³'
   @ 10,02 say '³ ³                                                                      ³ ³'
   @ 11,02 say '³ ³                                                                      ³ ³'
   @ 12,02 say '³ ³                                                                      ³ ³'
   @ 13,02 say '³ ³                                                                      ³ ³'
   @ 14,02 say '³ ³                                                                      ³ ³'
   @ 15,02 say '³ ³                                                                      ³ ³'
   @ 16,02 say '³ ³                                                                      ³ ³'
   @ 17,02 say '³ ³                                                                      ³ ³'
   @ 18,02 say '³ ³                                                                      ³ ³'
   @ 19,02 say '³ ³                                                                      ³ ³'
   @ 20,02 say '³ ³                                                                      ³ ³'
   @ 21,02 say '³ ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ ³'
   @ 22,02 say '³                                                                          ³'
   @ 23,02 say 'ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ'
return


/*
-------------------------------------------------------------------------------
Procedimento .: cr1400_j_duplicata
Objetivo .....: Calcula Juros p/ duplicata
-------------------------------------------------------------------------------
*/
function cr1400_j_duplicata()
local OLDREC := CR1000->( recno() )
setcursor(1)

W_VL_TOT        := 0.00
W_VL_DUP        := 0.00
W_VL_CALC       := 0.00
W_JU_DUP        := 0.00
W_DT_VENC       := ctod('')
W_DT_PAG        := ctod('')

@ 10,14 say 'ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿'
@ 11,14 say '³ Duplicata..:         /  Dt.Venc:   /  /   ³'
@ 12,14 say '³          Valor Devido s/Juros             ³'
@ 13,14 say '³                                           ³'
@ 14,14 say '³ Dt.Pagto...:   /  /     Juros..:       %  ³'
@ 15,14 say '³    Vl.Juros        Valor a Pagar          ³'
@ 16,14 say '³                                           ³'
@ 17,14 say 'ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ'
sombra(10,14,17,58)

W_VL_DUP := CR1000->VALOR
W_VL_TOT := W_VL_DUP + CR1000->TXADM - CR1000->ABATIMENTO

@ 11,29 say CR1000->DUPLICATA picture "@!"
@ 11,38 say CR1000->SEQUENCIA picture "@!"
@ 11,49 say CR1000->DT_VENC   picture "99/99/99"
@ 13,37 say W_VL_TOT          picture "@E 999,999,999.99"

do while .T.

   W_VL_CALC := 0.00

   @ 14,29 get W_DT_PAG          picture "99/99/99"
   @ 14,49 get W_JU_DUP          picture "@E 999.99"
   read
   if lastkey() = K_ESC; exit;end

   W_VL_JU   := calc_juros (W_VL_DUP,CR1000->DT_VENC,W_JU_DUP,W_DT_PAG)
   W_VL_CALC := W_VL_DUP + W_VL_JU + CR1000->TXADM - CR1000->ABATIMENTO
   @ 16,27 say W_VL_CALC         picture "@E 999,999,999.99"
   @ 16,18 say W_VL_JU           picture "@E 999,999.99"

end

setcursor(0)

return nil

/*
-------------------------------------------------------------------------------
Procedimento .: cr1400_j_cliente
Objetivo .....: Calcula Juros p/ cliente
-------------------------------------------------------------------------------
*/
function cr1400_j_cliente()
local OLDREC   := CR1000->( recno() )
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

@ 05,10 say 'ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿'
@ 06,10 say '³ Dt.Pagto...:   /  /     Juros..:       %                     ³'
@ 07,10 say 'ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´'
@ 08,10 say '³ Duplicata   Dt.Venc.        Valor      Juros           Total ³'
@ 09,10 say '³                                                              ³'
@ 10,10 say '³                                                              ³'
@ 11,10 say '³                                                              ³'
@ 12,10 say '³                                                              ³'
@ 13,10 say '³                                                              ³'
@ 14,10 say '³                                                              ³'
@ 15,10 say '³                                                              ³'
@ 16,10 say '³                                                              ³'
@ 17,10 say '³                                                              ³'
@ 18,10 say '³                                                              ³'
@ 19,10 say 'ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´'
@ 20,10 say '³ Jr.:             Vl.:                 Total.:                ³'
@ 21,10 say 'ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ'
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

   CR1000->( dbsetorder(6))
   CR1000->( dbseek("P" + X_CODCLI) )
   while CR1000->( ! eof() )       .and. ;
         CR1000->CODCLI = X_CODCLI .and. ;
         CR1000->STATUS = "P"

         VEN012->(dbsetorder(1))
         VEN012->(dbseek(X_DUPLICATA))

         W_VL_DUP  := CR1000->VALOR
         W_VL_JU   := calc_juros (W_VL_DUP,CR1000->DT_VENC,W_JU_CLI,W_DT_PAG)
         W_TOT_JU  := W_TOT_JU + W_VL_JU
         W_TOT_VL  := W_TOT_VL + W_VL_DUP

         aadd( WVET_RET, ' '+ CR1000->DUPLICATA     + '/' + CR1000->SEQUENCIA               + ' ' + ;
                            + dtoc(CR1000->DT_VENC) + ' ' + str(W_VL_DUP,13,2)              + ' ' + ;
                            + str (W_VL_JU,10,2 )   + ' ' + str(W_VL_JU + W_VL_DUP,13,2)  +' ' )
         W_TXADM += CR1000->TXADM
         W_ABAT  += CR1000->ABATIMENTO
         CR1000->( dbskip() )
   end

   W_ESC := achoice(09,12,18,70,WVET_RET)

   W_TOT_TOT := W_TOT_JU + W_TOT_VL+W_TXADM - W_ABAT

   @ 20,16 say W_TOT_JU          picture "@E 999,999.99"
   @ 20,33 say W_TOT_VL          picture "@E 999,999,999.99"
   @ 20,57 say W_TOT_TOT         picture "@E 999,999,999.99"

end

setcursor(0)

return nil

