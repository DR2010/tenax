/*

   CR1400.PRG - Extrato de Cliente
*/
#include "inkey.ch"
altd(1)

telanum('SCE1400','CR1400')

abrir("CR0300")
abrir("CR0400")
abrir("CR0600")
abrir("CR1000")
abrir("VEN001")
abrir("VEN012")

X_CODCLI       := space(5)
X_DUPLICATA    := space(8)
X_SEQUENCIA    := space(1)
X_DT_EMISSAO   := ctod("  /  /  ")
X_DT_VENC      := ctod("  /  /  ")
X_DT_PAG       := ctod("  /  /  ")
X_STATUS       := " "
X_TIPOVENDA    := space(2)
X_FORMAPAG     := space(2)
X_VALOR        := 0.00
X_VALOR_NF     := 0.00
X_TOTAL        := 0.00
X_QTD_CH       := 0

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
   private  COLINI      := 04
   private  COLFIM      := 75
   private  BLOCK_DISP  := {|| .T. }
   private  CAB_TITULO  := nil
   private  BORDA       := 1

   private  TECLA       := nil
   private  TABELA      := nil

   aadd( CAMPO     , "DUPLICATA"        )
   aadd( CAMPO     , "SEQUENCIA"        )
   aadd( CAMPO     , "DT_VENC"          )
   aadd( CAMPO     , "DT_PAG"           )
   aadd( CAMPO     , "TIPOVENDA"        )
   aadd( CAMPO     , "FORMAPAG"         )
   aadd( CAMPO     , "VALOR"            )
   aadd( CAMPO     , "JUROS"            )
   aadd( CAMPO     , "STATUS"           )

   aadd( MASCARA   , "@!"               )
   aadd( MASCARA   , "@!"               )
   aadd( MASCARA   , "  /  /  "         )
   aadd( MASCARA   , "  /  /  "         )
   aadd( MASCARA   , "@!"               )
   aadd( MASCARA   , "@!"               )
   aadd( MASCARA   , "999,999,999.99"   )
   aadd( MASCARA   , "9,999,999.99"     )
   aadd( MASCARA   , "!"                )

   aadd( CABECALHO , "Duplicata"        )
   aadd( CABECALHO , "Sq"               )
   aadd( CABECALHO , "Dt.Venc"          )
   aadd( CABECALHO , "Dt.Pag."          )
   aadd( CABECALHO , "TV"               )
   aadd( CABECALHO , "FP"               )
   aadd( CABECALHO , "Valor"            )
   aadd( CABECALHO , "Juros"            )
   aadd( CABECALHO , "St"               )

   aadd( TAMANHO   , 09                 )
   aadd( TAMANHO   , 02                 )
   aadd( TAMANHO   , 08                 )
   aadd( TAMANHO   , 08                 )
   aadd( TAMANHO   , 02                 )
   aadd( TAMANHO   , 02                 )
   aadd( TAMANHO   , 14                 )
   aadd( TAMANHO   , 12                 )
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

     W_TEL1400 := savescreen(,,,,)

      do case

         case TEC == 28 ; help() ; return 1

         case TEC == 27 ; return 0

         case TEC == -3   && Consulta f4
              if CR1000->(!eof())
                 ed_cr1400()
                 restscreen(,,,,W_TEL1400)
                 cr1400_pendente()
              end
              SELECT CR1000
              CR1000->(dbsetorder(5))
              CR1000->(dbseek("X_CODCLI"))
              TABELA:refreshall()

         case TEC = K_ESC
              CONTINUA := .F.

      end

      select CR1000
      CR1000->(dbsetorder(5))

   enddo

   restscreen(,,,,W_T1_cr1400)

enddo

close data

return

************************************
function ed_cr1400()
************************************
setcursor(1)

OLDREC := CR1000->( recno() )

t2_cr1400()

X_DUPLICATA     := CR1000->DUPLICATA
X_SEQUENCIA     := CR1000->SEQUENCIA
X_DT_VENC       := CR1000->DT_VENC
X_DT_PAG        := CR1000->DT_PAG
X_FORMAPAG      := CR1000->FORMAPAG
X_QTD_CH        := CR1000->QTD_CH
X_VALOR         := CR1000->VALOR
X_JUROS         := CR1000->JUROS
X_VALOR_NF      := 0.00

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

tes_tipovenda(12,26)
tes_formapag (13,26)

if X_JUROS > 0
   @ 09,45 say 'Juros.........:'
   @ 09,62 say X_JUROS           pict "@E 999,999,999.99"
   if CR1000->STATUS = 'P'
      @ 10,45 say 'Total a Pagar.:'
   else
      @ 10,45 say 'Total Pago....:'
   end
   W_TOT_PG := X_VALOR + X_JUROS
   @ 10,62 say W_TOT_PG          pict "@E 999,999,999.99"
end

@ 07,27 say X_DT_EMISSAO  pict "  /  /  "
@ 09,27 say X_DT_VENC     pict "  /  /  "
@ 10,27 say X_VALOR       pict "@E 999,999,999.99"
@ 18,27 say X_VALOR_NF    pict "@E 999,999,999.99"

if X_QTD_CH > 0
   select CR0600
   CR0600->(dbsetorder(2))
   if CR0600->(dbseek(X_DUPLICATA+X_SEQUENCIA))
      @ 15,27 say CR0600->DT_PREDATA
      @ 15,39 say CR0600->NOME
      @ 16,40 say VEN001->DDD01
      @ 16,47 say VEN001->TEL01 pict  "@R 999-9999"
   else
      mensbeep('Nao existe o Cheque para a Duplicata !')
      return
   end
end

CR1000->( dbgoto( OLDREC ) )

INKEY (0)

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
   @ 10,03 say '  Valor...............:                                                   '
   @ 11,03 say '                                                                          '
   @ 12,03 say '  Tipo de Venda.......:                                                   '
   @ 13,03 say '  Forma de Pagamento..:                                                   '
   @ 14,03 say '                                                                          '
   @ 15,03 say '  Cheque Datado para..:          -                                        '
   @ 16,03 say '                                 - (     )                                '
   @ 17,03 say '                                                                          '
   @ 18,03 say '  Valor Total da Nota.:                                                   '
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
         W_VL_T := W_VL_P := W_VL_J := 0.00

   CR1000->( dbsetorder(2))
   CR1000->( dbseek("P") )

   while CR1000->( ! eof() )
      if CR1000->STATUS = "P" .and. ;
         CR1000->CODCLI = X_CODCLI
         W_VL_P = W_VL_P + CR1000->VALOR
         W_VL_J = W_VL_J + CR1000->JUROS
      end
      if CR1000->STATUS <> "P"
         exit
      end
      CR1000->( dbskip() )
   end

   W_VL_T := W_VL_P + W_VL_J

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

