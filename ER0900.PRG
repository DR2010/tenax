/*
   Esquema

   ER0900.PRG - Geracao de Esquema

*/
#include "inkey.ch"
altd(1)

telanum('SCE0900','CR0900')

abrir("VEN001")
abrir("VEN002")
abrir("VEN012")
abrir("VEN030")
abrir("VEN050")

abrir("CR0300")
abrir("CR0400")
abrir("CR0500")
abrir("CR0600")
abrir("CR1000")
abrir("CR1100")

abrir("SR1000")
abrir("SR0600")
abrir("SR1100")

abrir("ER1000")
abrir("ER0600")
abrir("ER1100")

abrir("CR9991")

X_NUMERO := space(5)

private  X_NOTAFISCAL,X_DUPLICATA,X_SEQUENCIA,X_CODCLI,X_QTDPARC, ;
	 X_DT_EMISSAO,X_TIPOVENDA,X_FORMAPAG,W_FORMAPAG,X_VALOR,  ;
	 X_VALORNF,X_DT_VENC,X_ICMS,X_VL,W_DT_1,X_CODVENC,W_DT_2, ;
	 W_DT_3,W_DT_4,W_DT_5,X_DIAS_1,X_DIAS_2,X_DIAS_3,X_DIAS_4,;
	 X_DIAS_5,X_TIPO_DOC,X_B_CALC

private  W_FILE      := {}
private  CAMPO       := {}
private  MASCARA     := {}
private  CABECALHO   := {}
private  TAMANHO     := {}
private  BESCAPE     := {|| STATUS = "P"  }
private  COR         := W_COR_001
private  TITULO      := " Nota Fiscal "
private  LININI      := 03
private  LINFIM      := 20
private  COLINI      := 02
private  COLFIM      := 77
private  BLOCK_DISP  := {|| .T. }
private  CAB_TITULO  := nil
private  BORDA       := 1

private  TECLA       := nil
private  TABELA      := nil

aadd( CAMPO , "NOTAFISCAL"       )
aadd( CAMPO , "GUERRA"           )
aadd( CAMPO , "DT_EMISSAO"       )
aadd( CAMPO , "CODVENC"          )
aadd( CAMPO , "TIPOVENDA"        )
aadd( CAMPO , "FORMAPAG"         )
aadd( CAMPO , "QTDPARC"          )
aadd( CAMPO , "QTDREC"           )
aadd( CAMPO , "VALOR"            )

aadd( MASCARA , "@!"                    )
aadd( MASCARA , "@!"                    )
aadd( MASCARA , "@!"                    )
aadd( MASCARA , "@!"                    )
aadd( MASCARA , "@!"                    )
aadd( MASCARA , "@!"                    )
aadd( MASCARA , "@!"                    )
aadd( MASCARA , "@!"                    )
aadd( MASCARA , "@E 999,999,999.99"     )

aadd( CABECALHO , "Nota Fiscal"           )
aadd( CABECALHO , "Cliente"               )
aadd( CABECALHO , "Emiss„o"               )
aadd( CABECALHO , "Venc."                 )
aadd( CABECALHO , "TV"                    )
aadd( CABECALHO , "FP"                    )
aadd( CABECALHO , "Emit."                 )
aadd( CABECALHO , "Receb"                 )
aadd( CABECALHO , "Valor"                 )

aadd( TAMANHO , 12     )
aadd( TAMANHO , 10     )
aadd( TAMANHO , 09     )
aadd( TAMANHO , 05     )
aadd( TAMANHO , 02     )
aadd( TAMANHO , 02     )
aadd( TAMANHO , 05     )
aadd( TAMANHO , 05     )
aadd( TAMANHO , 15     )

aadd( W_FILE , "VEN012" )
aadd( W_FILE , "VEN001" )
aadd( W_FILE , "VEN012" )
aadd( W_FILE , "VEN012" )
aadd( W_FILE , "VEN012" )
aadd( W_FILE , "VEN012" )
aadd( W_FILE , "VEN012" )
aadd( W_FILE , "VEN012" )
aadd( W_FILE , "VEN012" )

select VEN012
VEN012->( dbsetorder(2) )
VEN012->( dbseek("P") )

VEN012->( dbsetrelation( "VEN001", {|| VEN012->CODCLI }, "VEN012->CODCLI" ) )
setcolor( W_COR_001 )

ted_E0900()

TABELA := tabelanew( CAMPO          , ;
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
		     COLFIM        , ;
		     W_FILE          ;
		   )

CONTINUA := .T.

cr1100_pendente()
keyboard(chr(32))
do while CONTINUA .and. ( (TEC:=tabmov(TABELA)) != K_ESC )

   W_TEL0012 := savescreen(,,,,)

   do case
      case TEC == 28 ; help("ER0900")
      case TEC == 27 ; return 0

      case TEC == 13   && Consulta
	   if VEN012->(!eof())
              ed_e0900()
	      restscreen(,,,,W_TEL0012)
	   end
	   select VEN012
	   VEN012->( dbsetorder(2) )
	   VEN012->( dbseek("P") )
	   TABELA:refreshall()

      case TEC == -5   // BUSCA DIRETA = F6
           if VEN012->( ! eof() )
              busca_nf()
           end
           restscreen(,,,,W_TEL0012)
           select VEN012
           VEN012->( dbsetorder(2) )
           VEN012->( dbseek("P" + X_NOTAFISCAL)  )
           TABELA:refreshall()

      case TEC = K_F12
           ins_esquema()
	   cr1100_pendente()
	   select VEN012
	   VEN012->( dbsetorder(2) )
	   VEN012->( dbseek("P") )
	   TABELA:refreshall()

      case TEC = K_ESC
	   CONTINUA := .F.

   end

enddo

close data

return

************************************
function ed_e0900( flag )
************************************
local dt_sai , getlist := {}

setcursor(1)

t_E0900()

@ 04,26 say    VEN012->NOTAFISCAL

X_NOTAFISCAL := VEN012->NOTAFISCAL
X_CODCLI     := VEN012->CODCLI
X_TIPOVENDA  := VEN012->TIPOVENDA
X_FORMAPAG   := VEN012->FORMAPAG
X_CODVENC    := VEN012->CODVENC
X_QTDPARC    := VEN012->QTDPARC
X_DT_EMISSAO := VEN012->DT_EMISSAO
X_VALORNF    := VEN012->VALOR
X_ICMS       := VEN012->ICMS
X_B_CALC     := VEN012->B_CALC
X_COMPRANF   := VEN012->COMPRANF
X_COMPRADT   := VEN012->COMPRADT

tes_codcli   (X_CODCLI,06,26,30)
tes_tipovenda(08,26,30)
tes_formapago(09,26,30)
tes_codvecm  (12,26,30)

@ 06,26 say X_CODCLI      picture "@!"
@ 11,26 say X_DT_EMISSAO
@ 12,26 say X_CODVENC     picture "99"
@ 14,26 say X_VALORNF     picture "@E 999,999,999.99"
@ 16,26 say X_ICMS        picture "@E 999,999,999.99"
@ 18,26 say X_B_CALC      picture "@E 999,999,999.99"

inkey(0)

Edita_Duplicatas ( X_NOTAFISCAL,"C" )

setcursor(0)

return nil

/*
-----------------------------------------------------------------------------
                          Funcao INS_ESQUEMA
-----------------------------------------------------------------------------
*/
function INS_ESQUEMA()

local WRET := .T.

   @ 10,14 say 'ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿'
   @ 11,14 say '³                                  ³'
   @ 12,14 say '³ Numero......:                    ³'
   @ 13,14 say '³                                  ³'
   @ 14,14 say 'ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ'
   sombra(10,14,14,49)

   E_NUMERO  := space(05)
   @ 12,31 get X_NUMERO picture "@!" valid tes_enumero(12,31)
   read

   if lastkey() = K_ESC
      WRET := .F.
      return WRET
   end
   if empty(X_NUMERO) .or. X_NUMERO = "00000"
      mensbeep ("A Geracao de Controle Exige um Pedido de Contra Retirada !")
      WRET := .F.
      return WRET
   end

   if !pergunta('Confirma Geracao de Esquema (S/N) ?')
      WRET := .F.
      return WRET
   end

   if !gera_esquema(VEN012->NOTAFISCAL)
      mensbeep (" Geracao Esquema com Erro !")
      WRET := .F.
      return WRET
   end

   if !gera_receber(X_NUMERO)
      mensbeep (" Geracao Contas Receber com Erro !")
      WRET := .F.
      return WRET
   end

return WRET

/*
-------------------------------------------------------------------------------
                           GERA_ESQUEMA
-------------------------------------------------------------------------------
*/
Function gera_esquema(P_NOTAFISCAL)
local W_OLDSCR := savescreen() , WRET := .T.

   if !item_esquema ( P_NOTAFISCAL )
      WRET := .F.
      return WRET
   end

   while VEN012->( ! rlock() ); end

   VEN050->( dbappend() )
   VEN050->NOTAFISCAL  := VEN012->NOTAFISCAL
   VEN050->CODCLI      := VEN012->CODCLI
   VEN050->TIPOVENDA   := VEN012->TIPOVENDA
   VEN050->FORMAPAG    := VEN012->FORMAPAG
   VEN050->QTDPARC     := VEN012->QTDPARC
   VEN050->DT_EMISSAO  := date()
   VEN050->CODVENC     := VEN012->CODVENC
   VEN050->VALOR       := VEN012->VALOR
   VEN050->STATUS      := "P"

return WRET

/*
-------------------------------------------------------------------------------
                           ITEM_ESQUEMA
-------------------------------------------------------------------------------
*/
function item_esquema( P_NOTAFISCAL )
local WRET := .T.

select CR1000
CR1000->( dbsetorder(1) )
CR1000->( dbgotop() )
CR1000->( dbseek( P_NOTAFISCAL ))

if CR1000->( found() )

   while CR1000->( ! eof() ) .and. CR1000->DUPLICATA=P_NOTAFISCAL

      while CR1000->( ! rlock() ); end

      if CR1000->QTD_CH > 0
         if ! cheque_esquema(CR1000->DUPLICATA,CR1000->SEQUENCIA)
            WRET := .F.
            return WRET
         end
      end
      if CR1000->ACORDO = "X"
         if ! acordo_esquema(CR1000->DUPLICATA,CR1000->SEQUENCIA)
            WRET := .F.
            return WRET
         end
      end

      ER1000->( dbappend())
      ER1000->DUPLICATA   := CR1000->DUPLICATA
      ER1000->SEQUENCIA   := CR1000->SEQUENCIA
      ER1000->CODCLI      := CR1000->CODCLI
      ER1000->DT_VENC     := CR1000->DT_VENC
      ER1000->FORMAPAG    := CR1000->FORMAPAG
      ER1000->VALOR       := CR1000->VALOR
      ER1000->TIPO_DOC    := CR1000->TIPO_DOC
      ER1000->QTD_CH      := CR1000->QTD_CH
      ER1000->BOLETA      := CR1000->BOLETA
      ER1000->DT_CREDITO  := CR1000->DT_CREDITO
      ER1000->DT_PAG      := CR1000->DT_PAG
      ER1000->JUROS       := CR1000->JUROS
      ER1000->ACORDO      := CR1000->ACORDO
      ER1000->STATUS      := "P"

      CR1000->( dbdelete())
      CR1000->( dbunlock())
      CR1000->( dbskip())

   end
end

return WRET


/*
-------------------------------------------------------------------------------
                           CHEQUE_ESQUEMA
-------------------------------------------------------------------------------
*/
function cheque_esquema( P_DUPLICATA,P_SEQUENCIA )
local WRET := .T.

  CR0600->(dbsetorder(2))
  if ! CR0600->(dbseek(P_DUPLICATA+P_SEQUENCIA))
       mensbeep('N„o existe Cheque em Contas A Rebecer P/ Duplicata !')
       WRET := .F.
       return WRET
   end

  while CR0600->(! eof() )              .and. ;
        CR0600->DUPLICATA = P_DUPLICATA .and. ;
        CR0600->SEQUENCIA = P_SEQUENCIA

        while CR0600->(!rlock());loop; end

        ER0600->(dbappend())
        ER0600->DUPLICATA  :=  CR0600->DUPLICATA
        ER0600->SEQUENCIA  :=  CR0600->SEQUENCIA
        ER0600->CODBANCO   :=  CR0600->CODBANCO
        ER0600->CODAGENCIA :=  CR0600->CODAGENCIA
        ER0600->NR_CONTA   :=  CR0600->NR_CONTA
        ER0600->NR_CHEQUE  :=  CR0600->NR_CHEQUE
        ER0600->CGC        :=  CR0600->CGC
        ER0600->CPF        :=  CR0600->CPF
        ER0600->NOME       :=  CR0600->NOME
        ER0600->CODCLI     :=  CR0600->CODCLI
        ER0600->DT_PREDATA :=  CR0600->DT_PREDATA
        ER0600->VALOR      :=  CR0600->VALOR
        ER0600->DESTINO    :=  CR0600->DESTINO
        ER0600->STATUS     :=  "P"

        CR0600->( dbdelete())
        CR0600->( dbunlock())
        CR0600->( dbskip())
  enddo

return WRET

/*
-------------------------------------------------------------------------------
                           ACORDO_ESQUEMA
-------------------------------------------------------------------------------
*/
function acordo_esquema( P_DUPLICATA,P_SEQUENCIA )
local WRET := .T.

  CR1100->(dbsetorder(1))
  if ! CR1100->(dbseek(P_DUPLICATA+P_SEQUENCIA))
       mensbeep('N„o existe Acordo em Contas Receber P/ Duplicata !')
       WRET := .F.
       return WRET
   end

  while CR1100->(! eof() )              .and. ;
        CR1100->DUPLICATA = P_DUPLICATA .and. ;
        CR1100->SEQUENCIA = P_SEQUENCIA

        while CR1100->(!rlock()); end

        ER1100->(dbappend())

        ER1100->DUPLICATA := CR1100->DUPLICATA
        ER1100->SEQUENCIA := CR1100->SEQUENCIA
        ER1100->DTACORDO  := CR1100->DTACORDO
        ER1100->JRACORDO  := CR1100->JRACORDO
        ER1100->VLACORDO  := CR1100->VLACORDO
        ER1100->VLACPAGO  := CR1100->VLACPAGO
        ER1100->VLACPAGAR := CR1100->VLACPAGAR

        CR1100->(dbdelete())
        CR1100->(dbunlock())
        CR1100->(dbskip())
  enddo

return WRET

/*
-------------------------------------------------------------------------------
                           GERA_RECEBER
-------------------------------------------------------------------------------
*/
Function gera_receber(P_NUMERO)
local W_OLDSCR := savescreen() , WRET := .T.

   if !item_receber ( P_NUMERO )
      WRET := .F.
      return WRET
   end

   while VEN030->( ! rlock() ); end

   VEN012->CODCLI      := VEN030->CODCLI
   VEN012->TIPOVENDA   := VEN030->TIPOVENDA
   VEN012->FORMAPAG    := VEN030->FORMAPAG
   VEN012->QTDPARC     := VEN030->QTDPARC
   VEN012->DT_EMISSAO  := date()
   VEN012->CODVENC     := VEN030->CODVENC
   VEN012->VALOR       := VEN030->VALOR
   VEN012->STATUS      := "P"

   VEN030->( dbdelete() )
   VEN030->( dbunlock() )
   VEN030->( dbgotop())

return WRET

/*
-------------------------------------------------------------------------------
                           ITEM_RECEBER
-------------------------------------------------------------------------------
*/
function item_receber( P_NUMERO )
local WRET := .T.

select SR1000
SR1000->( dbsetorder(1) )
SR1000->( dbgotop() )
SR1000->( dbseek( P_NUMERO ))

if SR1000->( found() )

   while SR1000->( ! eof() ) .and. (SR1000->DUPLICATA = P_NUMERO)

      while SR1000->( ! rlock() ); end
      if SR1000->QTD_CH > 0
         if ! cheque_receber(SR1000->DUPLICATA,SR1000->SEQUENCIA)
            WRET := .F.
            return WRET
         end
      end
      if SR1000->ACORDO = "X"
         if ! acordo_receber(SR1000->DUPLICATA,SR1000->SEQUENCIA)
            WRET := .F.
            return WRET
         end
      end

      CR1000->(dbappend())
      CR1000->DUPLICATA   := VEN012->NOTAFISCAL
      CR1000->SEQUENCIA   := SR1000->SEQUENCIA
      CR1000->CODCLI      := SR1000->CODCLI
      CR1000->DT_VENC     := SR1000->DT_VENC
      CR1000->FORMAPAG    := SR1000->FORMAPAG
      CR1000->VALOR       := SR1000->VALOR
      CR1000->TIPO_DOC    := SR1000->TIPO_DOC
      CR1000->STATUS      := "P"

      SR1000->( dbdelete() )
      SR1000->( dbunlock() )
      SR1000->( dbskip()   )

   end
end

return WRET

/*
-------------------------------------------------------------------------------
                           CHEQUE_RECEBER
-------------------------------------------------------------------------------
*/
function cheque_receber( P_NUMERO,P_SEQUENCIA )
local WRET := .T.

  SR0600->(dbsetorder(2))
  if ! SR0600->(dbseek(P_NUMERO+P_SEQUENCIA))
       mensbeep('N„o existe Cheque em Contra Retirada p/ Duplicata !')
       WRET := .F.
       return WRET
   end

  while SR0600->(! eof() )            .and.;
        SR0600->DUPLICATA = P_NUMERO  .and.;
        SR0600->SEQUENCIA = P_SEQUENCIA

        while SR0600->(!rlock()); end

        CR0600->(dbappend())
        CR0600->DUPLICATA  :=  SR0600->DUPLICATA
        CR0600->SEQUENCIA  :=  SR0600->SEQUENCIA
        CR0600->CODBANCO   :=  SR0600->CODBANCO
        CR0600->CODAGENCIA :=  SR0600->CODAGENCIA
        CR0600->NR_CONTA   :=  SR0600->NR_CONTA
        CR0600->NR_CHEQUE  :=  SR0600->NR_CHEQUE
        CR0600->CGC        :=  SR0600->CGC
        CR0600->CPF        :=  SR0600->CPF
        CR0600->NOME       :=  SR0600->NOME
        CR0600->CODCLI     :=  SR0600->CODCLI
        CR0600->DT_PREDATA :=  SR0600->DT_PREDATA
        CR0600->VALOR      :=  SR0600->VALOR
        CR0600->STATUS     :=  "P"

        SR0600->( dbdelete())
        SR0600->( dbunlock())
        SR0600->( dbskip())
  enddo

return WRET

/*
-------------------------------------------------------------------------------
                           ACORDO_RECEBER
-------------------------------------------------------------------------------
*/
function acordo_receber( P_DUPLICATA,P_SEQUENCIA )
local WRET := .T.

  SR1100->(dbsetorder(1))
  if SR1100->(dbseek(P_DUPLICATA+P_SEQUENCIA))
     mensbeep('N„o existe Acordo em Contra Retirada P/ Duplicata !')
     WRET := .F.
     return WRET
   end

  while SR1100->(! eof() )              .and.;
        SR1100->DUPLICATA = P_DUPLICATA .and.;
        SR1100->SEQUENCIA = P_SEQUENCIA

        while SR1100->(!rlock()); end

        CR1100->(dbappend())
        CR1100->DUPLICATA := SR1100->DUPLICATA
        CR1100->SEQUENCIA := SR1100->SEQUENCIA
        CR1100->DTACORDO  := SR1100->DTACORDO
        CR1100->JRACORDO  := SR1100->JRACORDO
        CR1100->VLACORDO  := SR1100->VLACORDO
        CR1100->VLACPAGO  := SR1100->VLACPAGO
        CR1100->VLACPAGAR := SR1100->VLACPAGAR

        SR1100->(dbdelete())
        SR1100->(dbunlock())
        SR1100->(dbskip())
  enddo

return WRET

/*
-------------------------------------------------------------------------------
Procedimento .: TED_E0900
Objetivo .....: Menu rapido
-------------------------------------------------------------------------------
*/
procedure ted_E0900()
   local W_OLDCOR := setcolor()

   setcolor(W_COR_001)
   quadro(03,02,20,77,"")
   @ 05,02 say 'Æ'
   @ 05,77 say 'µ'
   @ 16,03 to 16,76 double
   @ 16,02 say 'Æ'
   @ 16,77 say 'µ'

   sombra(02,02,21,77)

   setcolor( W_OLDCOR )
return

/*
-------------------------------------------------------------------------------
Procedimento .: TELAe1000
Objetivo .....: Menu rapido
-------------------------------------------------------------------------------
*/
procedure t_E0900()

   setcolor( W_COR_001 )
   @ 05,02 say '³'
   @ 05,77 say '³'
   setcolor( W_COR_001 )
   @ 04,03 say ' Nr. Nota Fiscal.....:                                                    '
   @ 05,03 say '                                                                          '
   @ 06,03 say ' C¢d. Cliente........:                                                    '
   @ 07,03 say '                                                                          '
   @ 08,03 say ' Tipo de Venda.......:                                                    '
   @ 09,03 say ' Forma de Pagamento..:                                                    '
   @ 10,03 say '                                                                          '
   @ 11,03 say ' Data de Emiss„o.....:                                                    '
   @ 12,03 say ' Vencimento..........:                                                    '
   @ 13,03 say '                                                                          '
   @ 14,03 say ' Valor Total.........:                                                    '
   @ 15,03 say '                                                                          '
   @ 16,03 say ' Valor do ICMS.......:                                                    '
   @ 17,03 say '                                                                          '
   @ 18,03 say ' Base de Calculo.....:                                                    '
   @ 19,03 say '                                                                          '
   @ 20,03 say '                                                                          '
   @ 21,03 say '                                                                          '

