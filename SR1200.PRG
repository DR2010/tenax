/*

   CONTAS A RECEBER
   SR1200.PRG - Consulta Duplicatas Pedentes
   * DC = FLG_TXADM
     
*/
#include "inkey.ch"
altd(1)

telanum('SCE1200','SR1200')

abrir("SR0300")
abrir("SR0400")
abrir("SR0600")
abrir("SR1000")
abrir("SR1100")
abrir("VEN001")
abrir("VEN030")
abrir("SR9991")

X_CODCLI       := space(5)
S_DUPLICATA    := space(8)
S_SEQUENCIA    := space(1)
S_DT_EMISSAO   := ctod("  /  /  ")
S_DT_VENC      := ctod("  /  /  ")
S_DT_PAG       := ctod("  /  /  ")
S_STATUS       := " "
S_TIPOVENDA    := space(2)
S_FORMAPAG     := space(2)
S_VALOR        := 0.00
S_VALOR_NF     := 0.00
S_TOTAL        := 0.00
S_ABATI        := 0.00
S_TXADM        := 0.00
S_QTD_CH       := 0
S_ACORDO       := ' '
S_DT_INI       := ctod(' /  /  ')
S_DT_FIM       := ctod(' /  /  ')

set Softseek on

do while .T.

   setcolor(W_COR_002)

   t1_SR1200()

   W_T1_SR1200 := savescreen(,,,,)

   if !(t1_getS1200())
       exit
   end

   private  W_FILE      := {}
   private  CAMPO       := {}
   private  MASCARA     := {}
   private  CABECALHO   := {}
   private  TAMANHO     := {}
   private  BESCAPE     := {|| SR1000->STATUS   = "P"      .and. ;
                               SR1000->DT_VENC >= S_DT_INI .and. ;
                               SR1000->DT_VENC <= S_DT_FIM        }
   private  COR         := W_COR_002
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
   aadd( CABECALHO , "Pedido"          )
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

   aadd( W_FILE , "SR1000" )
   aadd( W_FILE , "SR1000" )
   aadd( W_FILE , "SR1000" )
   aadd( W_FILE , "VEN001" )
   aadd( W_FILE , "VEN030" )
   aadd( W_FILE , "SR1000" )
   aadd( W_FILE , "SR1000" )
   aadd( W_FILE , "SR1000" )
   aadd( W_FILE , "SR1000" )
   aadd( W_FILE , "SR1000" )
   aadd( W_FILE , "SR1000" )

   SR1000->(dbsetorder(3))
   SET SOFTSEEK ON
   SR1000->(dbseek("P" + dtos(S_DT_INI)),.T.)

   SR1000->( dbsetrelation( "VEN030", {|| SR1000->DUPLICATA},"SR1000->DUPLICATA" ) )
   VEN030->( dbsetrelation( "VEN001", {|| VEN030->CODCLI},"VEN030->CODCLI" ) )

   setcolor(W_COR_002)

   select SR1000

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

   SR1000_pendente()

   SR1000->(dbsetorder(3))
   Set Softseek on
   SR1000->(dbseek("P" + dtos(S_DT_INI)),.T.)

   CONTINUA := .T.

   do while CONTINUA .and. ( (TEC:=tabmov(TABELA)) != K_ESC )

     W_TEL1200 := savescreen(,,,,)

      do case

         case TEC == 28 ; help("SR1200")

         case TEC == 27 ; return 0

         case TEC = K_ENTER   && Consulta
              if SR1000->(!eof())
                 editS1200()
                 restscreen(,,,,W_TEL1200)
                 SR1000_pendente()
              end
              SELECT SR1000
              SR1000->(dbsetorder(3))
              Set Softseek on
              SR1000->(dbseek("P" + dtos(S_DT_INI) ),.F.)
              TABELA:refreshall()

         case TEC = K_ESC
              CONTINUA := .F.

      end

      select SR1000
      SR1000->(dbsetorder(3))

   enddo

enddo

close data

return

/*
-------------------------------------------------------------------------------
                       Get da Tela Inicial
-------------------------------------------------------------------------------
*/
function t1_getS1200()
local WRET := .T.

  do while .T.
     @ 03,16 get S_DT_INI picture '99/99/99'
     @ 03,27 get S_DT_FIM picture '99/99/99'
     read
     if lastkey() = K_ESC
        WRET := .F.
        exit
     end
     if S_DT_INI > S_DT_FIM
        mensbeep (' Parƒmetro de Data Invalido !')
        loop
     end

     if empty(S_DT_INI)
        S_DT_INI :=  ctod('01/01/01')
     end
     if empty(S_DT_FIM)
        S_DT_FIM :=  ctod('31/12/99')
     end

     @ 03,16 say S_DT_INI picture '99/99/99'
     @ 03,27 say S_DT_FIM picture '99/99/99'

     exit

  enddo

return WRET

************************************
function editS1200()
************************************
setcursor(1)

tlS1200()

S_DUPLICATA     := SR1000->DUPLICATA
S_SEQUENCIA     := SR1000->SEQUENCIA
S_DT_VENC       := SR1000->DT_VENC
S_FORMAPAG      := SR1000->FORMAPAG
S_QTD_CH        := SR1000->QTD_CH
S_VALOR         := SR1000->VALOR
S_VALOR         := SR1000->VALOR
S_JUROS         := SR1000->JUROS
S_VALOR_NF      := 0.00
W_TOT_PG        := 0.00
S_ABATI         := SR1000->ABATIMENTO
S_TXADM         := SR1000->TXADM
S_ACORDO        := SR1000->ACORDO

tes_Sduplicata(04,25)

VEN030->(dbsetorder(1))
if VEN030->(dbseek(S_DUPLICATA))
   S_CODCLI     := VEN030->CODCLI
   S_DT_EMISSAO := VEN030->DT_EMISSAO
   S_VALOR_NF   := VEN030->VALOR
   S_TIPOVENDA  := VEN030->TIPOVENDA
else
   mensbeep(" Nota Fiscal Inexistente !")
   return
end

tes_codcli   (X_CODCLI,06,26,30)
tes_Stipovenda(12,26)
tes_Sformapag (13,26)

if S_JUROS > 0
   @ 09,45 say 'Juros.........:'
   @ 09,62 say S_JUROS           pict "@E 999,999,999.99"
   @ 10,45 say 'Total a Pagar.:'
   W_TOT_PG := S_VALOR + S_JUROS + S_TXADM - S_ABATI
   @ 10,62 say W_TOT_PG          pict "@E 999,999,999.99"
end

@ 06,26 say X_CODCLI      pict "@!"
@ 07,26 say S_DT_EMISSAO  pict "  /  /  "
@ 09,26 say S_DT_VENC     pict "  /  /  "
@ 10,26 say S_VALOR       pict "@E 999,999,999.99"
@ 16,26 say S_VALOR_NF    pict "@E 999,999,999.99"
@ 16,59 say S_ABATI       pict "@E 999,999.99"
@ 17,59 say S_TXADM       pict "@E 999,999.99"

if S_QTD_CH > 0
   select SR0600
   SR0600->(dbsetorder(3))
   if SR0600->(dbseek("P"+S_CODCLI+S_DUPLICATA+S_SEQUENCIA))
      @ 14,26 say SR0600->DT_PREDATA
      @ 14,38 say SR0600->NOME
      @ 15,39 say VEN001->DDD01
      @ 15,45 say VEN001->TEL01 pict  "@R 999-9999"
   else
      mensbeep('N„o existe o Cheque para a Duplicata !')
      return
   end
end
IF S_ACORDO = 'X'
  SHOW_SACORDO()
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
procedure tlS1200()

   setcolor( W_COR_002 )
   @ 05,02 say '³'
   @ 05,77 say '³'
   setcolor( W_COR_002 )
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
procedure T1_SR1200()

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
function SR1000_pendente()
   local WRET   := .T., OLDREC := SR1000->( recno() ) , ;
         W_VL_T := W_VL_P := W_VL_J := 0.00

   SR1000->(dbsetorder(3))
   Set Softseek on
   SR1000->(dbseek("P" + dtos(S_DT_INI)),.T.)

   do while SR1000->(! eof() )          .and. ;
            SR1000->STATUS   = "P"      .and. ;
            SR1000->DT_VENC >= S_DT_INI .and. ;
            SR1000->DT_VENC <= S_DT_FIM
            W_VL_P = W_VL_P + SR1000->VALOR + SR1000->TXADM - SR1000->ABATIMENTO
            W_VL_J = W_VL_J + SR1000->JUROS
            SR1000->( dbskip() )
   enddo

   W_VL_T := W_VL_P + W_VL_J 

   @ 21,02 say 'ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´'
   @ 22,02 say '³ Pendente.:                Juros.:               Total...:                ³'
   @ 23,02 say 'ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ'
   @ 22,13 say W_VL_P picture "@E 99,999,999.99"
   @ 22,37 say W_VL_J picture "@E 99,999,999.99"
   @ 22,62 say W_VL_T picture "@E 999,999,999.99"

   SR1000->( dbgoto( OLDREC ) )

return WRET

procedure show_Sacordo()

local  WRET        := .T.
local  CAMPO       := {}
local  MASCARA     := {}
local  CABECALHO   := {}
local  TAMANHO     := {}
local  BESCAPE     := {|| SR1100->DUPLICATA = S_DUPLICATA .and.;
                          SR1100->SEQUENCIA = S_SEQUENCIA }
local  COR         := W_COR_002
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

if S_ACORDO != "X" .and. S_ACORDO != " "
   mensbeep('Acordo deve ser X ou Branco !')
   WRET := .F.
   return WRET
end

if S_ACORDO = " "
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

setcolor(W_COR_002)

select SR1100

SR1100->( dbsetorder(1) )
SR1100->( dbseek( S_DUPLICATA + S_SEQUENCIA ))

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

    *  case TEC == 28 ; help("SR1200")
      case TEC == 27 .or. TEC == 13; return 0
   end
end

return

