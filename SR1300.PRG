/*

   CONTAS A RECEBER
   SR1300.PRG - Consulta Duplicatas Recebidas
  * DC = FLG_TXADM
*/
#include "inkey.ch"
altd(1)

telanum('SCE1300','SR1300')

abrir("SR0300")
abrir("SR0400")
abrir("SR0600")
abrir("SR1000")
abrir("SR1100")
abrir("VEN001")
abrir("VEN030")

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
S_JUROS        := 0.00
S_VALOR_NF     := 0.00
S_VALOR_PG     := 0.00
S_TOTAL        := 0.00
S_ABATI        := 0.00
S_TXADM        := 0.00
S_QTD_CH       := 0
S_ACORDO       := ' '
S_DT_INI       := ctod(' /  /  ')
S_DT_FIM       := ctod(' /  /  ')

SET SOFTSEEK ON

do while .T.

   setcolor(W_COR_002)

   t1_SR1300()

   W_T1_SR1300 := savescreen(,,,,)

   if !(t1_getS1300())
       exit
   end

   private  W_FILE      := {}
   private  CAMPO       := {}
   private  MASCARA     := {}
   private  CABECALHO   := {}
   private  TAMANHO     := {}
   private  BESCAPE     := {|| SR1000->STATUS   = "R"      .and. ;
                               SR1000->DT_PAG  >= S_DT_INI .and. ;
                               SR1000->DT_PAG  <= S_DT_FIM        }
   private  COR         := W_COR_002
   private  TITULO      := "Duplicatas Recebidas"
   private  LININI      := 04
   private  LINFIM      := 21
   private  COLINI      := 04
   private  COLFIM      := 75
   private  BLOCK_DISP  := {|| .T. }
   private  CAB_TITULO  := nil
   private  BORDA       := 1

   private  TECLA       := nil
   private  TABELA      := nil

   aadd( CAMPO     , "DT_PAG"           )
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

   aadd( CABECALHO , "Dt.Pagt."         )
   aadd( CABECALHO , "Pedido"          )
   aadd( CABECALHO , "Sq"               )
   aadd( CABECALHO , "Cliente"          )
   aadd( CABECALHO , "Tv"               )
   aadd( CABECALHO , "Fp"               )
   aadd( CABECALHO , "Ac"               )
   aadd( CABECALHO , "Ab"               )
   aadd( CABECALHO , "Dc"               )
   aadd( CABECALHO , "Valor"            )
   aadd( CABECALHO , "Juros"            )

   aadd( TAMANHO   , 09                 )
   aadd( TAMANHO   , 08                 )
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

   SR1000->(dbsetorder(4))
   SET SOFTSEEK ON
   SR1000->(dbseek("R" + dtos(S_DT_INI)),.T.)

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

   SR1000_Rebebido()

   SR1000->(dbsetorder(4))
   Set Softseek on
   SR1000->(dbseek("R" + dtos(S_DT_INI)),.T.)

   CONTINUA := .T.

   do while CONTINUA .and. ( (TEC:=tabmov(TABELA)) != K_ESC )

     W_TEL1300 := savescreen(,,,,)

      do case

         case TEC == 28 ; help("SR1300")

         case TEC == 27 ; return 0

         case TEC = K_ENTER  && Consulta
              if SR1000->(!eof())
                 editS1300()
                 restscreen(,,,,W_TEL1300)
                 SR1000_Rebebido()
              end
              SELECT SR1000
              SR1000->(dbsetorder(4))
              SET SOFTSEEK ON
              SR1000->(dbseek("R" + dtos(S_DT_INI) ),.F.)
              TABELA:refreshall()

         case TEC = K_F12  && Volta Duplicata
              if SR1000->(!eof())
                 ret_SDuplicata()
                 restscreen(,,,,W_TEL1300)
              end
              SELECT SR1000
              SR1000->(dbsetorder(4))
              Set Softseek on
              SR1000->(dbseek("R" + dtos(S_DT_INI) ),.F.)
              TABELA:refreshall()

         case TEC = K_ESC
              CONTINUA := .F.

      end

      select SR1000
      SR1000->(dbsetorder(4))

   enddo

enddo

close data

return

/*
-------------------------------------------------------------------------------
                       Get da Tela Inicial
-------------------------------------------------------------------------------
*/
function t1_getS1300()
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
        S_DT_FIM := date()
     end

     @ 03,16 say S_DT_INI picture '99/99/99'
     @ 03,27 say S_DT_FIM picture '99/99/99'

     exit
  enddo

return WRET

************************************
function editS1300()
************************************
setcursor(1)

tlS1300()

S_DUPLICATA     := SR1000->DUPLICATA
S_SEQUENCIA     := SR1000->SEQUENCIA
S_DT_VENC       := SR1000->DT_VENC
S_DT_PAG        := SR1000->DT_PAG
S_FORMAPAG      := SR1000->FORMAPAG
S_QTD_CH        := SR1000->QTD_CH
S_VALOR         := SR1000->VALOR
S_JUROS         := SR1000->JUROS
S_ABATI         := SR1000->ABATIMENTO
S_TXADM         := SR1000->TXADM
S_VALOR_NF      := 0.00
S_VALOR_PG      := 0.00
S_ACORDO        := SR1000->ACORDO
tes_Sduplicata(04,26)

VEN030->(dbsetorder(1))
if VEN030->(dbseek(S_DUPLICATA))
   X_CODCLI     := VEN030->CODCLI
   S_DT_EMISSAO := VEN030->DT_EMISSAO
   S_VALOR_NF   := VEN030->VALOR
   S_TIPOVENDA  := VEN030->TIPOVENDA
else
   mensbeep(" Nota Fiscal Inexistente !")
   return
end

tes_CODCLI   (X_CODCLI,06,26,30)
tes_Stipovenda(12,26)
tes_Sformapag (13,26)

S_VALOR_PG := S_VALOR + S_JUROS + S_TXADM - S_ABATI

@ 06,26 say X_CODCLI      pict "@!"
@ 07,26 say S_DT_EMISSAO  pict "  /  /  "
@ 09,26 say S_DT_VENC     pict "  /  /  "
@ 09,60 say S_DT_PAG      pict "  /  /  "
@ 10,26 say S_VALOR       pict "@E 999,999,999.99"
@ 10,60 say S_JUROS       pict "@E 999,999,999.99"
@ 11,60 say S_VALOR_PG    pict "@E 999,999,999.99"
@ 16,26 say S_VALOR_NF    pict "@E 999,999,999.99"
@ 16,59 say S_ABATI       pict "@E 999,999,999.99"
@ 17,59 say S_TXADM       pict "@E 999,999,999.99"

if S_QTD_CH > 0
   select SR0600
   SR0600->(dbsetorder(3))
   if SR0600->(dbseek("R"+X_CODCLI+S_DUPLICATA+S_SEQUENCIA))
      @ 14,25 say SR0600->DT_PREDATA
      @ 14,37 say SR0600->NOME
      @ 15,38 say VEN001->DDD01
      @ 15,44 say VEN001->TEL01 pict  "@R 999-9999"
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
Procedimento .: TL1300
Objetivo .....: Menu rapido
-------------------------------------------------------------------------------
*/
procedure tlS1300()

   setcolor( W_COR_002 )
   @ 05,02 say '³'
   @ 05,77 say '³'
   setcolor( W_COR_002 )
   @ 02,02 say 'ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ Duplicata Recebida ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿'
   @ 03,02 say '³                                                                          ³'
   @ 04,02 say '³ Duplicata...........:         -                                          ³'
   @ 05,02 say '³                                                                          ³'
   @ 06,02 say '³ Cliente.............:                                                    ³'
   @ 07,02 say '³ Data de emiss„o.....:                                                    ³'
   @ 08,02 say '³                                                                          ³'
   @ 09,02 say '³ Data de vencimento..:                    Dt.Pagamento.:                  ³'
   @ 10,02 say '³ Valor Cobrado.......:                    Juros........:                  ³'
   @ 11,02 say '³                                          Valor Pago...:                  ³'
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
procedure T1_SR1300()

   @ 02,02 say 'ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿'
   @ 03,02 say '³  Periodo..: 99/99/99 a 99/99/99                                          ³'
   @ 04,02 say '³ ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄDuplicatas RecebidasÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿ ³'
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
                       CALCULA TOTAL DE DUPLICATAS RebebidoS
-------------------------------------------------------------------------------
*/
function SR1000_Rebebido()
   local WRET   := .T., OLDREC := SR1000->( recno() ),;
         W_VL_T := W_VL_R := W_VL_J := 0.00

   SR1000->(dbsetorder(4))
   Set Softseek on
   SR1000->(dbseek("R" + dtos(S_DT_INI)),.T.)

   do while SR1000->(! eof() )          .and. ;
            SR1000->STATUS   = "R"      .and. ;
            SR1000->DT_PAG >= S_DT_INI .and. ;
            SR1000->DT_PAG <= S_DT_FIM
            W_VL_R = W_VL_R + SR1000->VALOR - SR1000->ABATIMENTO + SR1000->TXADM
            W_VL_J = W_VL_J + SR1000->JUROS
            SR1000->( dbskip() )
   enddo

   W_VL_T := W_VL_R + W_VL_J 

   @ 21,02 say 'ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´'
   @ 22,02 say '³ Nominal.:                 Juros.:               Total...:                ³'
   @ 23,02 say 'ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ'
   @ 22,13 say W_VL_R picture "@E 99,999,999.99"
   @ 22,37 say W_VL_J picture "@E 99,999,999.99"
   @ 22,62 say W_VL_T picture "@E 999,999,999.99"

   SR1000->( dbgoto( OLDREC ) )

return WRET


/*
-------------------------------------------------------------------------------
                       Volta Situacao da Duplicata
-------------------------------------------------------------------------------
*/
function ret_Sduplicata()

   local WRET   := .T.

   if ! Pergunta('Confirma Volta da Duplicata (S/N) ?')
        WRET := .F.
        return WRET
   end

   VEN030->(dbsetorder(1))
   if !( VEN030-> (dbseek(SR1000->DUPLICATA)) )
       mensbeep("Nota Fiscal Inexistente !")
       WRET := .F.
       return WRET
   end

   // Volta Cheque
   //---------------

   SR0600->(dbsetorder(2))
   if SR0600->(dbseek(SR1000->DUPLICATA+SR1000->SEQUENCIA))
      while SR0600->( ! rlock() ); end
      SR0600->STATUS := "P"
      SR0600->DT_PAG := ctod('')
      SR0600->( dbunlock() )
   end

   // Volta Duplicata
   //----------------

   while SR1000->( ! rlock() ); end
   SR1000->DT_PAG     := ctod ('')
   SR1000->STATUS     := 'P'
   SR1000->VLPAGO     := 0.00
   SR1000->( dbunlock() )

   // Volta Nota Fiscal
   //------------------

   while VEN030->( ! rlock() ); end
   VEN030->QTDREC := VEN030->QTDREC - 1
   VEN030->STATUS := "P"
   VEN030->( dbunlock() )

return WRET


