/*

   CONTAS A RECEBER
   CR1200.PRG - Consulta Duplicatas Pedentes
   * DC = FLG_TXADM
     
*/
#include "inkey.ch"
altd(1)

telanum('SCE1200','CR1200')

abrir("CR0300")
abrir("CR0400")
abrir("CR0600")
abrir("CR1000")
abrir("CR1100")
abrir("VEN001")
abrir("VEN012")
abrir("CR9991")

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
X_ABATI        := 0.00
X_TXADM        := 0.00
X_QTD_CH       := 0
X_ACORDO       := ' '
X_DT_INI       := ctod(' /  /  ')
X_DT_FIM       := ctod(' /  /  ')

set Softseek on

do while .T.

   setcolor(W_COREDIT)

   t1_cr1200()

   W_T1_cr1200 := savescreen(,,,,)

   if !(t1_get1200())
       exit
   end

   private  W_FILE      := {}
   private  CAMPO       := {}
   private  MASCARA     := {}
   private  CABECALHO   := {}
   private  TAMANHO     := {}
   private  BESCAPE     := {|| CR1000->STATUS   = "P"      .and. ;
                               CR1000->DT_VENC >= X_DT_INI .and. ;
                               CR1000->DT_VENC <= X_DT_FIM        }
   private  COR         := W_COREDIT
   private  TITULO      := "Duplicatas Pendentes"
   private  LININI      := 04
   private  LINFIM      := 21
   private  COLINI      := 04
   private  COLFIM      := 75
   private  BLOCK_DISP  := {|| .T. }
   private  CAB_TITULO  := nil
   private  BORDA       := 1

   private  TECLA       := nil
   private  TABELA      := nil

   aadd( CAMPO     , "DT_VENC"          )
   aadd( CAMPO     , "DUPLICATA"        )
   aadd( CAMPO     , "SEQUENCIA"        )
   aadd( CAMPO     , "GUERRA"           )
   aadd( CAMPO     , "TIPOVENDA"        )
   aadd( CAMPO     , "FORMAPAG"         )
   aadd( CAMPO     , "ACORDO"           )
   aadd( CAMPO     , "FLG_ABATI"        )
   aadd( CAMPO     , "FLG_TXADM"        )
   aadd( CAMPO     , "VALOR"            )
   aadd( CAMPO     , "JUROS"            )

   aadd( MASCARA   , "  /  /  "         )
   aadd( MASCARA   , "@!"               )
   aadd( MASCARA   , "@!"               )
   aadd( MASCARA   , "@!"               )
   aadd( MASCARA   , "@!"               )
   aadd( MASCARA   , "@!"               )
   aadd( MASCARA   , "!"                )
   aadd( MASCARA   , "!"                )
   aadd( MASCARA   , "!"                )
   aadd( MASCARA   , "99999,999.99"     )
   aadd( MASCARA   , "999,999.99"       )

   aadd( CABECALHO , "Dt.Venct"         )
   aadd( CABECALHO , "  Dupl."          )
   aadd( CABECALHO , "Sq"               )
   aadd( CABECALHO , " Cliente"         )
   aadd( CABECALHO , "Tv"               )
   aadd( CABECALHO , "Fp"               )
   aadd( CABECALHO , "Ac"               )
   aadd( CABECALHO , "Ab"               )
   aadd( CABECALHO , "Dc"               )
   aadd( CABECALHO , "Valor"            )
   aadd( CABECALHO , "Juros"            )
   
   aadd( TAMANHO   , 08                 )
   aadd( TAMANHO   , 09                 )
   aadd( TAMANHO   , 01                 )
   aadd( TAMANHO   , 10                 )
   aadd( TAMANHO   , 02                 )
   aadd( TAMANHO   , 02                 )
   aadd( TAMANHO   , 02                 )
   aadd( TAMANHO   , 02                 )
   aadd( TAMANHO   , 02                 )
   aadd( TAMANHO   , 12                 )
   aadd( TAMANHO   , 10                 )

   aadd( W_FILE , "CR1000" )
   aadd( W_FILE , "CR1000" )
   aadd( W_FILE , "CR1000" )
   aadd( W_FILE , "VEN001" )
   aadd( W_FILE , "VEN012" )
   aadd( W_FILE , "CR1000" )
   aadd( W_FILE , "CR1000" )
   aadd( W_FILE , "CR1000" )
   aadd( W_FILE , "CR1000" )
   aadd( W_FILE , "CR1000" )
   aadd( W_FILE , "CR1000" )

   CR1000->(dbsetorder(3))
   SET SOFTSEEK ON
   CR1000->(dbseek("P" + dtos(X_DT_INI)),.T.)

   CR1000->( dbsetrelation( "VEN012", {|| CR1000->DUPLICATA},"CR1000->DUPLICATA" ) )
   VEN012->( dbsetrelation( "VEN001", {|| VEN012->CODCLI},"VEN012->CODCLI" ) )

   setcolor(W_COREDIT)

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

   cr1000_pendente()

   cr1000->(dbsetorder(3))
   Set Softseek on
   cr1000->(dbseek("P" + dtos(X_DT_INI)),.T.)

   CONTINUA := .T.

   do while CONTINUA .and. ( (TEC:=tabmov(TABELA)) != K_ESC )

     W_TEL1200 := savescreen(,,,,)

      do case

         case TEC == 28 ; help("CR1200")

         case TEC == 27 ; return 0

         case TEC = K_ENTER   && Consulta
              if CR1000->(!eof())
                 edit1200()
                 restscreen(,,,,W_TEL1200)
                 cr1000_pendente()
              end
              SELECT CR1000
              CR1000->(dbsetorder(3))
              Set Softseek on
              CR1000->(dbseek("P" + dtos(X_DT_INI) ),.F.)
              TABELA:refreshall()

         case TEC = K_ESC
              CONTINUA := .F.

      end

      select CR1000
      cr1000->(dbsetorder(3))

   enddo

enddo

close data

return

/*
-------------------------------------------------------------------------------
                       Get da Tela Inicial
-------------------------------------------------------------------------------
*/
function t1_get1200()
local WRET := .T.

  do while .T.
     @ 03,16 get X_DT_INI picture '99/99/99'
     @ 03,27 get X_DT_FIM picture '99/99/99'
     read
     if lastkey() = K_ESC
        WRET := .F.
        exit
     end
     if X_DT_INI > X_DT_FIM
        mensbeep (' Parƒmetro de Data Invalido !')
        loop
     end

     if empty(X_DT_INI)
        X_DT_INI :=  ctod('01/01/01')
     end
     if empty(X_DT_FIM)
        X_DT_FIM :=  ctod('31/12/99')
     end

     @ 03,16 say X_DT_INI picture '99/99/99'
     @ 03,27 say X_DT_FIM picture '99/99/99'

     exit

  enddo

return WRET

************************************
function edit1200()
************************************
setcursor(1)

tl1200()

X_DUPLICATA     := CR1000->DUPLICATA
X_SEQUENCIA     := CR1000->SEQUENCIA
X_DT_VENC       := CR1000->DT_VENC
X_FORMAPAG      := CR1000->FORMAPAG
X_QTD_CH        := CR1000->QTD_CH
X_VALOR         := CR1000->VALOR
X_VALOR         := CR1000->VALOR
X_JUROS         := CR1000->JUROS
X_VALOR_NF      := 0.00
W_TOT_PG        := 0.00
X_ABATI         := CR1000->ABATIMENTO
X_TXADM         := CR1000->TXADM
X_ACORDO        := CR1000->ACORDO

tes_duplicata(04,25)

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

tes_codcli   (X_CODCLI,06,26,30)
tes_tipovenda(12,26)
tes_formapag (13,26)

if X_JUROS > 0
   @ 09,45 say 'Juros.........:'
   @ 09,62 say X_JUROS           pict "@E 999,999,999.99"
   @ 10,45 say 'Total a Pagar.:'
   W_TOT_PG := X_VALOR + X_JUROS + X_TXADM - X_ABATI
   @ 10,62 say W_TOT_PG          pict "@E 999,999,999.99"
end

@ 06,26 say X_CODCLI      pict "@!"
@ 07,26 say X_DT_EMISSAO  pict "  /  /  "
@ 09,26 say X_DT_VENC     pict "  /  /  "
@ 10,26 say X_VALOR       pict "@E 999,999,999.99"
@ 16,26 say X_VALOR_NF    pict "@E 999,999,999.99"
@ 16,59 say X_ABATI       pict "@E 999,999.99"
@ 17,59 say X_TXADM       pict "@E 999,999.99"

if X_QTD_CH > 0
   select CR0600
   CR0600->(dbsetorder(3))
   if CR0600->(dbseek("P"+X_CODCLI+X_DUPLICATA+X_SEQUENCIA))
      @ 14,26 say CR0600->DT_PREDATA
      @ 14,38 say CR0600->NOME
      @ 15,39 say VEN001->DDD01
      @ 15,45 say VEN001->TEL01 pict  "@R 999-9999"
   else
      mensbeep('N„o existe o Cheque para a Duplicata !')
      return
   end
end
IF X_ACORDO = 'X'
  SHOW_ACORDO()
ELSE
  INKEY (0)
END

setcursor(0)

return nil

/*
-------------------------------------------------------------------------------
Procedimento .: TL1200
Objetivo .....: Menu rapido
-------------------------------------------------------------------------------
*/
procedure tl1200()

   setcolor( W_COREDIT )
   @ 05,02 say '³'
   @ 05,77 say '³'
   setcolor( W_CORGET )
   @ 02,02 say 'ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ Duplicata Pendente ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿'
   @ 03,02 say '³                                                                          ³'
   @ 04,02 say '³ Duplicata...........:         -                                          ³'
   @ 05,02 say '³                                                                          ³'
   @ 06,02 say '³ Cliente.............:                                                    ³'
   @ 07,02 say '³ Data de emiss„o.....:                                                    ³'
   @ 08,02 say '³                                                                          ³'
   @ 09,02 say '³ Data de vencimento..:                                                    ³'
   @ 10,02 say '³ Valor...............:                                                    ³'
   @ 11,02 say '³                                                                          ³'
   @ 12,02 say '³ Tipo de Venda.......:                                                    ³'
   @ 13,02 say '³ Forma de Pagamento..:                                                    ³'
   @ 14,02 say '³ Cheque Datado para..:          -                                         ³'
   @ 15,02 say '³                                - (    )                                  ³'
   @ 16,02 say '³ Valor Total da Nota.:                   Abatimento...:                   ³'
   @ 17,02 say '³                                         Desp.Cobr....:                   ³'
   @ 18,02 say '³                                                                          ³'
   @ 19,02 say '³                                                                          ³'
   @ 20,02 say '³                                                                          ³'
   @ 21,02 say '³                                                                          ³'
   @ 22,02 say '³                                                                          ³'

return

/*
-----------------------------------------------------------------------------
                             Procedimento Inicial
-----------------------------------------------------------------------------
*/
procedure T1_CR1200()

   @ 02,02 say 'ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿'
   @ 03,02 say '³  Periodo..: 99/99/99 a 99/99/99                                          ³'
   @ 04,02 say '³ ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄDuplicatas PendentesÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿ ³'
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
                       CALCULA TOTAL DE DUPLICATAS PENDENTES
-------------------------------------------------------------------------------
*/
function cr1000_pendente()
   local WRET   := .T., OLDREC := CR1000->( recno() ) , ;
         W_VL_T := W_VL_P := W_VL_J := 0.00

   CR1000->(dbsetorder(3))
   Set Softseek on
   CR1000->(dbseek("P" + dtos(X_DT_INI)),.T.)

   do while CR1000->(! eof() )          .and. ;
            CR1000->STATUS   = "P"      .and. ;
            CR1000->DT_VENC >= X_DT_INI .and. ;
            CR1000->DT_VENC <= X_DT_FIM
            W_VL_P = W_VL_P + CR1000->VALOR + CR1000->TXADM - CR1000->ABATIMENTO
            W_VL_J = W_VL_J + CR1000->JUROS 
            CR1000->( dbskip() )
   enddo

   W_VL_T := W_VL_P + W_VL_J 

   @ 21,02 say 'ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´'
   @ 22,02 say '³ Pendente.:                Juros.:               Total...:                ³'
   @ 23,02 say 'ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ'
   @ 22,13 say W_VL_P picture "@E 99,999,999.99"
   @ 22,37 say W_VL_J picture "@E 99,999,999.99"
   @ 22,62 say W_VL_T picture "@E 999,999,999.99"

   CR1000->( dbgoto( OLDREC ) )

return WRET

procedure show_acordo()

local  WRET        := .T.
local  CAMPO       := {}
local  MASCARA     := {}
local  CABECALHO   := {}
local  TAMANHO     := {}
local  BESCAPE     := {|| CR1100->DUPLICATA = X_DUPLICATA .and.;
			  CR1100->SEQUENCIA = X_SEQUENCIA }
local  COR         := W_COREDIT
local  TITULO      := " Acordos "
local  LININI      := 18
local  LINFIM      := 23
local  COLINI      := 02
local  COLFIM      := 77
local  BLOCK_DISP  := {|| .T. }
local  CAB_TITULO  := nil
local  BORDA       := 1

local  TECLA       := nil
local  TABELA      := nil

if X_ACORDO != "X" .and. X_ACORDO != " "
   mensbeep('Acordo deve ser X ou Branco !')
   WRET := .F.
   return WRET
end

if X_ACORDO = " "
   return WRET
end

aadd( CAMPO , "DTACORDO"            )
aadd( CAMPO , "JRACORDO"            )
aadd( CAMPO , "VLACORDO"            )
aadd( CAMPO , "VLACPAGAR"           )

aadd( MASCARA , "99/99/99"          )
aadd( MASCARA , "@E 999,999.99"     )
aadd( MASCARA , "@E 999,999,999.99" )
aadd( MASCARA , "@E 999,999,999.99" )

aadd( CABECALHO , "Dt.Pag."         )
aadd( CABECALHO , "Juros (%)"       )
aadd( CABECALHO , "Vl.Acordo"       )
aadd( CABECALHO , "Saldo"         )

aadd( TAMANHO , 08                  )
aadd( TAMANHO , 12                  )
aadd( TAMANHO , 15                  )
aadd( TAMANHO , 15                  )

setcolor(W_COREDIT)

select CR1100

CR1100->( dbsetorder(1) )
CR1100->( dbseek( X_DUPLICATA + X_SEQUENCIA ))

TABELA := tabelanew( CAMPO     , ;
     MASCARA       , ;
     CABECALHO     , ;
     TAMANHO       , ;
     BESCAPE       , ;
     COR           , ;
     TITULO        , ;
     LININI        , ;
     LINFIM        , ;
     COLINI        , ;
     BLOCK_DISP    , ;
     CAB_TITULO    , ;
     BORDA         , ;
     COLFIM          ;
   )

CONTINUA := .T.

TABELA:refreshall()
do while CONTINUA .and. ( (TEC:=tabmov(TABELA)) != K_ESC )

   do case

    *  case TEC == 28 ; help("CR1200")
      case TEC == 27 .or. TEC == 13; return 0
   end
end

return

