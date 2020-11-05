/*
   SR1100.PRG - Baixa de Duplicatas
*/
#include "inkey.ch"
altd(1)

telanum('SCE1100','SR1100')

abrir("VEN001")
abrir("VEN030")
abrir("SR0300")
abrir("SR0400")
abrir("SR0600")
abrir("SR1000")
abrir("SR1100")
abrir("SR9991")

X_CODCLI       := space(5)
S_DUPLICATA    := space(8)
S_SEQUENCIA    := space(1)
S_BOLETA       := space(10)
S_DT_EMISSAO   := ctod("  /  /  ")
S_DT_VENC      := ctod("  /  /  ")
S_DT_PAG       := ctod("  /  /  ")
S_STATUS       := "R"
S_JUROS        := 0.00
S_VALOR        := 0.00
S_ABATIMENTO   := 0.00
S_TXADM        := 0.00
S_TOTAL        := 0.00
S_VL_PAGO      := 0.00
S_VL_PAGAR     := 0.00
S_TIPOVENDA    := space(2)
S_FORMAPAG     := space(2)

W_VL_PAGO      := 0.00
W_VL_PAGAR     := 0.00

S_ACORDO       := space(1)
S_VLACPAGO     := 0.00
S_JRACPAGO     := 0.00
S_VLACPAGAR    := 0.00
S_JRACPAGAR    := 0.00
S_DTACORDO     := ctod("  /  /  ")
S_JRACORDO     := 0.00
S_VLACORDO     := 0.00
S_VLJUROS      := 0.00
S_DEST_NOME    := space(20)
S_DEST_DATA    := space(08)

private  W_FILE      := {}
private  CAMPO       := {}
private  MASCARA     := {}
private  CABECALHO   := {}
private  TAMANHO     := {}
private  BESCAPE     := {|| STATUS = "P"  }
private  COR         := W_COR_002
private  TITULO      := " Baixa de Duplicatas "
private  LININI      := 03
private  LINFIM      := 20
private  COLINI      := 02
private  COLFIM      := 77
private  BLOCK_DISP  := {|| .T. }
private  CAB_TITULO  := nil
private  BORDA       := 1

private  TECLA       := nil
private  TABELA      := nil

aadd( CAMPO     , "DUPLICATA"        )
aadd( CAMPO     , "SEQUENCIA"        )
aadd( CAMPO     , "GUERRA"           )
aadd( CAMPO     , "DT_VENC"          )
aadd( CAMPO     , "TIPOVENDA"        )
aadd( CAMPO     , "FORMAPAG"         )
aadd( CAMPO     , "QTD_CH"           )
aadd( CAMPO     , "ACORDO"           )
aadd( CAMPO     , "FLG_ABATI"        )
aadd( CAMPO     , "FLG_TXADM"        )
aadd( CAMPO     , "VALOR"            )

aadd( MASCARA   , "@!"               )
aadd( MASCARA   , "@!"               )
aadd( MASCARA   , "@!"               )
aadd( MASCARA   , "  /  /  "         )
aadd( MASCARA   , "@!"               )
aadd( MASCARA   , "@!"               )
aadd( MASCARA   , "@!"               )
aadd( MASCARA   , "@!"               )
aadd( MASCARA   , "@!"               )
aadd( MASCARA   , "@!"               )
aadd( MASCARA   , "999,999,999.99"   )

aadd( CABECALHO , "Pedido"        )
aadd( CABECALHO , "Sq"               )
aadd( CABECALHO , "Cliente"          )
aadd( CABECALHO , "Vencimt."         )
aadd( CABECALHO , "Tv"               )
aadd( CABECALHO , "Fp"               )
aadd( CABECALHO , "Ch"               )
aadd( CABECALHO , "Ac"               )
aadd( CABECALHO , "Ab"               )
aadd( CABECALHO , "Dc"               )
aadd( CABECALHO , "Valor"            )

aadd( TAMANHO   , 09                 )
aadd( TAMANHO   , 02                 )
aadd( TAMANHO   , 07                 )
aadd( TAMANHO   , 10                 )
aadd( TAMANHO   , 02                 )
aadd( TAMANHO   , 02                 )
aadd( TAMANHO   , 02                 )
aadd( TAMANHO   , 02                 )
aadd( TAMANHO   , 02                 )
aadd( TAMANHO   , 02                 )
aadd( TAMANHO   , 15                 )

aadd( W_FILE , "SR1000" )
aadd( W_FILE , "SR1000" )
aadd( W_FILE , "VEN001" )
aadd( W_FILE , "SR1000" )
aadd( W_FILE , "VEN030" )
aadd( W_FILE , "SR1000" )
aadd( W_FILE , "SR1000" )
aadd( W_FILE , "SR1000" )
aadd( W_FILE , "SR1000" )
aadd( W_FILE , "SR1000" )
aadd( W_FILE , "SR1000" )

select SR1000
SR1000->( dbsetorder(2) )
SR1000->( dbseek("P") )

SR1000->( dbsetrelation( "VEN001", {|| SR1000->CODCLI},"SR1000->CODCLI" ) )

SR1000->( dbsetrelation( "VEN030", {|| SR1000->DUPLICATA},"SR1000->DUPLICATA" ) )

setcolor(W_COR_002)

teS1100()

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

CONTINUA := .T.

SR1100_pendente()

select SR1000
SR1000->( dbsetorder(2) )
SR1000->( dbseek("P"),.T. )

do while CONTINUA .and. ( (TEC:=tabmov(TABELA)) != K_ESC )

   W_TEL1100 := savescreen(,,,,)

   do case
      case TEC == 28 ; help("SR1100")
      case TEC == 27 ; return 0

      case TEC == -3   && alteracao f4
          if SR1000->(!eof())
             editS1100()
             restscreen(,,,,W_TEL1100)
             SR1100_pendente()
	  end
          select SR1000
          SR1000->( dbsetorder(2) )
          SR1000->( dbseek("P") )
	  TABELA:refreshall()

      case TEC == -5   // BUSCA DIRETA = F6
         if SR1000->( ! eof() )
            busca_Sduplicata("P")
	 end
         restscreen(,,,,W_TEL1100)
         select SR1000
         SR1000->( dbsetorder(2) )
         SR1000->( dbseek("P" + S_DUPLICATA )  )
	 TABELA:refreshall()

      case TEC = K_F7  // Lancamento de Taxa
         if SR1000->( ! eof() )
            taxaS1100()
	 end
         restscreen(,,,,W_TEL1100)
         select SR1000
         SR1000->( dbsetorder(2) )
         SR1000->( dbseek("P" + S_DUPLICATA )  )
	 TABELA:refreshall()

      case TEC = K_ESC
	 CONTINUA := .F.
   end

enddo

close data

return

************************************
function editS1100()
************************************
local getlist:= {}
 
setcursor(1)

tlS1100()

SR9991->( dbgotop() )

S_DT_CREDITO   := CTOD('  /  /  ')
X_CODCLI       := SR1000->CODCLI
S_DUPLICATA    := SR1000->DUPLICATA
S_SEQUENCIA    := SR1000->SEQUENCIA
S_BOLETA       := SR1000->BOLETA
S_FORMAPAG     := SR1000->FORMAPAG
S_DT_PAG       := datant(2)
S_DT_VENC      := SR1000->DT_VENC
S_VALOR        := SR1000->VALOR
S_ABATIMENTO   := SR1000->ABATIMENTO
S_TXADM        := SR1000->TXADM
S_VALOR        := SR1000->VALOR
S_JUROS        := calc_Sjuros(S_VALOR,S_DT_VENC,SR9991->JUROS, S_DT_PAG)
S_TOTAL        := 0.0
S_VL_PAGAR     := SR1000->VLACPAGAR + SR1000->JRACPAGAR
S_VL_PAGO      := SR1000->VLACPAGO  + SR1000->JRACPAGO
S_ACORDO       := SR1000->ACORDO

if acessa_Snf(S_DUPLICATA)
   S_TIPOVENDA  := VEN030->TIPOVENDA
   S_DT_EMISSAO := VEN030->DT_EMISSAO
   S_TIPOVENDA  := VEN030->TIPOVENDA
end

select SR0600
SR0600->( dbsetorder(2) )
SR0600->( dbseek(S_DUPLICATA+S_SEQUENCIA) )
S_DEST_NOME := SR0600->DEST_NOME
S_DEST_DATA := SR0600->DEST_DATA

tes_CODCLI     (X_CODCLI,04,20)
tes_Sduplicata (05,20)
tes_Stipovenda (7,45,25)
tes_Sformapag  (8,45,25)

@ 04,18 say X_CODCLI  PICT "@!"
show_Ssaldo()

@ 07,20 say S_DT_EMISSAO  pict "  /  /  "
@ 08,20 say S_DT_VENC     pict "  /  /  "
@ 09,20 say S_VALOR       pict "@E 999999,999.99"

@ 10,20 say S_DEST_NOME   pict "@!"
@ 10,59 say S_DEST_DATA   pict "99/99/99"

@ 11,60 say S_VL_PAGO     pict "@E 999,999,999.99"
@ 12,60 say S_VL_PAGAR    pict "@E 999,999,999.99"

@ 13,20 say S_TXADM       pict "@E 999,999.99"
@ 13,60 say S_ABATIMENTO  pict "@E 999,999.99"

if SR0400->BOLETA = "X"
  S_DT_CREDITO   := DATANT(1)
end

@ 11,45 get S_ACORDO      pict "!"               valid tes_Sacordo()
@ 09,51 get S_DT_CREDITO  pict "99/99/99"        valid tes_Sdtpag() ;
                                                 when SR0400->BOLETA = "X"
@ 10,20 get S_DEST_NOME   pict "@!"
@ 10,59 get S_DEST_DATA   pict "99/99/99"

@ 11,20 get S_DT_PAG      pict "  /  /  "        valid tes_Sdtpag()
@ 12,20 get S_JUROS       pict "@E 999,999.99"
read
if lastkey() = K_ESC
   return nil
end

if SR0400->BOLETA # 'X'
  S_DT_CREDITO := S_DT_PAG
  @ 09,51 SAY S_DT_CREDITO  pict "99/99/99"
end

S_TOTAL  := (S_VALOR + S_JUROS + S_TXADM) - S_ABATIMENTO

@ 15,20 say S_TOTAL       pict "@E 9999,999,999.99"

SR0400->(Dbsetorder(1))
SR0400->(Dbseek(S_TIPOVENDA+S_FORMAPAG))

if SR0400->CHEQUE = "X"
   if ! Scheque_valido()
      return nil
   end
end

INKEY()

if Pergunta('Confirma Pagamento da Duplicata (S/N) ?')
    if SR1000->QTD_CH > 0
       if ! baixa_Scheque()
	  return nil
       end
    end
    while SR1000->( ! rlock() ); end
    SR1000->BOLETA     := S_BOLETA
    SR1000->DT_CREDITO := S_DT_CREDITO
    SR1000->DT_PAG     := S_DT_PAG
    SR1000->JUROS      := S_JUROS
    SR1000->STATUS     := S_STATUS
    SR1000->ACORDO     := S_ACORDO
    SR1000->DEST_NOME  := S_DEST_NOME
    SR1000->DEST_DATA  := S_DEST_DATA
    SR1000->( dbunlock() )
    if S_STATUS = "R"
       baixa_Snf(S_DUPLICATA)
    end
end

setcursor(0)

return nil

/*
-------------------------------------------------------------------------------
Procedimento .: TES1100
Objetivo .....: Menu rapido
-------------------------------------------------------------------------------
*/
procedure teS1100()
   local W_OLDCOR := setcolor()

   setcolor(W_COR_002)
   quadro(03,02,21,77,"")
   @ 05,02 say 'Æ'
   @ 05,77 say 'µ'
   @ 16,03 to 16,76 double
   @ 16,02 say 'Æ'
   @ 16,77 say 'µ'

   sombra(02,02,20,77)

   setcolor( W_OLDCOR )
return


/*
-------------------------------------------------------------------------------
Procedimento .: TLS1100
Objetivo .....: Menu rapido
-------------------------------------------------------------------------------
*/
procedure tlS1100()

   setcolor( W_COR_002 )
   @ 05,02 say '³'
   @ 05,77 say '³'
   setcolor( W_COR_002 )
   @ 04,03 say ' Cliente......:                                                           '
   @ 05,03 say ' Duplicata....:                                                           '
   @ 06,03 say '                                                                          '
   @ 07,03 say ' Dt.Emiss„o...:                  Venda..:                                 '
   @ 08,03 say ' Dt.vencimento:                  F.Pag..:                                 '
   @ 09,03 say ' Valor........:                  Data Credito:                            '
   @ 10,03 say ' Dest/Nome....:                              Dest/data:                   '
   @ 11,03 say ' Dt.Pagamento.:                  Acordo.:    Vl.Pago..:                   '
   @ 12,03 say ' Juros........:                              A Pagar..:                   '
   @ 13,03 say ' Taxas Adm....:                  Abatimento...........:                   '
   @ 14,03 say '                                                                          '
   @ 15,03 say ' Total........:                                                           '
   @ 16,03 say '                                                                          '
   @ 17,03 say '                                                                          '
   @ 18,03 say '                                                                          '
   @ 19,03 say '                                                                          '
   @ 20,03 say '                                                                          '
   @ 21,03 say '                                                                          '

return ' '

/*
-------------------------------------------------------------------------------
				  BAIXA DO CHEQUE
-------------------------------------------------------------------------------
*/
function baixa_SCheque()
local WRET := .T.

   SR0600->(dbsetorder(3))
   if ! SR0600->(dbseek("P"+X_CODCLI+S_DUPLICATA+S_SEQUENCIA))
	mensbeep('N„o existe Cheque em Aberto para Devida Baixa')
	WRET := .F.
	return WRET
    end

   while SR0600->(! eof() )              .and. ;
         SR0600->CODCLI    = X_CODCLI    .and. ;
         SR0600->DUPLICATA = S_DUPLICATA .and. ;
         SR0600->SEQUENCIA = S_SEQUENCIA
         while SR0600->(!rlock()); end
         SR0600->STATUS := "R"
         SR0600->DT_PAG := date()
         SR0600->(dbunlock())
         SR0600->(dbskip())
   enddo

return WRET

/*
-------------------------------------------------------------------------------
		       CALCULA TOTAL DE DUPLICATAS PENDENTES
-------------------------------------------------------------------------------
*/
function SR1100_pendente()
   local WRET := 0, OLDREC := SR1000->( recno() )

   SR1000->(dbsetorder(3))
   SR1000->(dbseek("P"))

   do while SR1000->(! eof() ) .and. SR1000->STATUS  = "P"
      WRET = WRET + SR1000->VALOR
      SR1000->( dbskip() )
   enddo

   SR1000->( dbgoto( OLDREC ) )

   @ 20,02 say 'ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´'
   @ 21,02 say '³                                        Total Pendente...:                ³'
   @ 22,02 say 'ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ'
   @ 21,62 say WRET picture "@E 999,999,999.99"

return WRET

/*
-------------------------------------------------------------------------------

-------------------------------------------------------------------------------
*/
function tes_Sdtpag()
local WRET := .T.
local oget := GETACTIVE()
  if oget:NAME = 'S_DT_CREDITO'
    if S_DT_CREDITO > DATE()
      mensbeep(" Data de SRedito superior a data atual !   <ENTER>")
      WRET := .F.
    end
  else    
    if S_DT_PAG < S_DT_EMISSAO
      mensbeep(" Data de Pagamento inferior a Emissao ! ")
      WRET := .F.
    end
    S_JUROS := calc_Sjuros(S_VALOR,S_DT_VENC,SR9991->JUROS, S_DT_PAG)
  end

return WRET

/*
-------------------------------------------------------------------------------
                                      tes_Sacordo
-------------------------------------------------------------------------------
*/
function tes_Sacordo()

local  WRET        := .T.
local  CAMPO       := {}
local  MASCARA     := {}
local  CABECALHO   := {}
local  TAMANHO     := {}
local  BESCAPE     := {|| SR1100->DUPLICATA = S_DUPLICATA .and.;
                          SR1100->SEQUENCIA = S_SEQUENCIA }
local  COR         := W_COR_002
local  TITULO      := " Acordos "
local  LININI      := 16
local  LINFIM      := 22
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

      case TEC == 28 ; help("SR1101")
      case TEC == 27 ; return 0

      case TEC == K_F3
           ins_Sacordo()
           show_Ssaldo()
           if S_STATUS = 'R'
	     exit
	   end
	   TABELA:refreshall()

      case TEC = K_F5
           if SR1100->(!eof())
	       if pergunta("Confirma exclus„o do Acordo (S/N) ?")
                  del_Sacordo()
                  show_Ssaldo()
	       end
	   end
	   TABELA:refreshall()

      case TEC = K_ENTER
	   EXIT

   end
   Select SR1100

enddo

return WRET
//----------------------------------------------------------------------
function ins_Sacordo()
//----------------------------------------------------------------------
local getlist:= {}
WSSRDUP := savescreen(,,,,)

setcursor(1)
@ 05,10 say 'ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´    Duplicata    ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿'
@ 06,10 say '³                                                     ³'
@ 07,10 say '³ Valor...:                     Dt.Venc.:             ³'
@ 08,10 say '³ Juros...:                   Abat.....:              ³'
@ 09,10 say '³ Total...:                   Desp.....:              ³'
@ 10,10 say '³                                                     ³'
@ 11,10 say '³ Vl.Pago.:                   Dt.Acordo:              ³'
@ 12,10 say 'ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´   A c o r d o   ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´'
@ 13,10 say '³                                                     ³'
@ 14,10 say '³ Data....:   /  /            Juros :        %        ³'
@ 15,10 say '³ Valor...:                                           ³'
@ 16,10 say '³                                                     ³'
@ 17,10 say 'ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´ P e n d e n t e ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´'
@ 18,10 say '³                                                     ³'
@ 19,10 say '³ Valor...:                                           ³'
@ 20,10 say '³                                                     ³'
@ 21,10 say 'ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ'
sombra(05,10,21,64)

while .T.

    if SR1000->ACORDO # "X"
       S_DTACORDO := DATE()
    else
       S_DTACORDO := SR1100->DTACORDO
    end

    S_VLACORDO   := 0.00
    S_VLJUROS    := 0.00
    S_VLACPAGO   := SR1000->VLACPAGO
    S_JRACORDO   := SR1000->JRACORDO
    S_VLACPAGAR  := SR1000->VLACPAGAR

    @ 07,23 say SR1000->VALOR       picture "@E 999,999,999.99"
    @ 07,53 say SR1000->DT_VENC     picture "99/99/99"
    @ 08,27 SAY SR1000->JUROS       picture "@E 999,999.99"
    @ 09,24 SAY (SR1000->VALOR+ SR1000->JUROS + S_TXADM) - S_ABATIMENTO picture "@E 999,999,999.99"

    @ 08,53 say SR1000->ABATIMENTO  picture "@E 999,999.99"
    @ 09,53 say SR1000->TXADM       picture "@E 999,999.99"
    @ 11,23 say SR1000->VLACPAGO    picture "@E 999,999,999.99"
    @ 11,53 say SR1000->DTACORDO    picture "99/99/99"

    if SR1000->ACORDO # "X"
       @ 19,23 say SR1000->VALOR     picture "@E 999,999,999.99"
    else
       @ 19,23 say SR1000->VLACPAGAR picture "@E 999,999,999.99"
    end

    @ 14,23 get S_DTACORDO          picture "99/99/99"          valid !empty(S_DTACORDO)
    @ 14,50 get S_JRACORDO          picture "@E 999.99"         valid tes_Sjracordo()
    @ 15,32 get S_VLACORDO          picture "@E 999,999,999.99" valid tes_Svlacordo()

    @ 19,23 get S_VLACPAGAR         picture "@E 999,999,999.99" valid tes_Svlacpagar()
    read

    if lastkey() = K_ESC .or. S_STATUS = 'R'
       restscreen(,,,,WSSRDUP )
       setcursor(0)
       return nil
    end

    if pergunta("Confirma Inclusao do Acordo (S/N) ?")
       grava_Sac()
       exit
    else
       S_STATUS := "P"
    end

enddo

restscreen(,,,,WSSRDUP )

setcursor(0)

return nil

/*
-------------------------------------------------------------------------------
                                      tes_Sjracordo
-------------------------------------------------------------------------------
*/
function tes_Sjracordo()
local WRET := .T.

S_VLACORDO := 0.00
S_VLJUROS  := 0.00

if SR1000->ACORDO # "X"
   S_VLJUROS  := calc_Sjuros(SR1000->VALOR,SR1000->DT_VENC,S_JRACORDO,S_DTACORDO)
   S_VLACORDO := (SR1000->VALOR     + S_VLJUROS + S_TXADM) - S_ABATIMENTO
else
   S_VLJUROS  := calc_Sjuros(SR1000->VLACPAGAR,SR1000->DTACORDO,S_JRACORDO,S_DTACORDO)   //
   S_VLACORDO := SR1000->VLACPAGAR + S_VLJUROS
end

return WRET

/*
-------------------------------------------------------------------------------
                                      tes_Svlacordo
-------------------------------------------------------------------------------
*/
function tes_Svlacordo()

local   WRET := .T.

if S_VLACORDO = 0.00
   WRET := .F.
   return WRET
end

if SR1000->ACORDO # "X"
   S_VLACPAGAR  := ((SR1000->VALOR     + S_VLJUROS+ S_TXADM) - S_ABATIMENTO) - S_VLACORDO
else
   S_VLACPAGAR  := (SR1000->VLACPAGAR + S_VLJUROS)- S_VLACORDO
end

@ 19,23 say S_VLACPAGAR  picture "@E 999,999,999.99"

return WRET

/*
-------------------------------------------------------------------------------
                                      tes_Svlacpagar
-------------------------------------------------------------------------------
*/
function tes_Svlacpagar()
local WRET := .T.

   S_STATUS := "P"

   if S_VLACPAGAR = 0.00
      if pergunta ("Confirma Liquidacao do Acordo (S/N) ?")
         S_STATUS := "R"
         grava_Sac()
      else
	 WRET := .F.
      end
   end

return WRET

/*
-------------------------------------------------------------------------------
                                      show_Ssaldo
-------------------------------------------------------------------------------
*/
function show_Ssaldo()
local WRET := .T.

@ 11,60 say SR1000->VLACPAGO     pict "@E 999,999,999.99"
@ 12,60 say SR1000->VLACPAGAR    pict "@E 999,999,999.99"

return WRET

/*
-------------------------------------------------------------------------------
                                      del_Sacordo
-------------------------------------------------------------------------------
*/
function del_Sacordo()
local WRET

  S_STATUS  := "P"

  while SR1000->( ! rlock() ); end
  SR1000->VLACPAGO  := SR1000->VLACPAGO  - SR1100->VLACPAGO
  SR1000->VLACPAGAR := SR1000->VLACPAGAR + SR1100->VLACPAGO
  SR1000->( dbunlock() )

  while SR1100->( ! rlock() ); end
  SR1100->( dbdelete() )
  SR1100->( dbunlock() )
  SR1100->( dbskip()   )

return WRET

/*
-------------------------------------------------------------------------------
                                      taxaS1100
-------------------------------------------------------------------------------
*/
function taxaS1100()
local WRET := 0

   WSSRDUP := savescreen(,,,,)

   setcursor(1)

   @ 10,15 say 'ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿'
   @ 11,15 say '³                                   ³'
   @ 12,15 say '³ Desp. de Cobranca :               ³'
   @ 13,15 say '³                                   ³'
   @ 14,15 say 'ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ'

   S_TXADM := 0.00

   while .T.
       @ 12,37 get S_TXADM     picture "@E 999,999.99"
       read
       if lastkey() = K_ESC
          restscreen(,,,,WSSRDUP )
	  setcursor(0)
	  return nil
       end
       if pergunta("Confirma Inclusao da Despesa (S/N) ?")
          while SR1000->( ! rlock() ); end
          SR1000->TXADM     := S_TXADM
          SR1000->FLG_TXADM := 'X'    // ABNER
          SR1000->( dbunlock() )
	  exit
       end
   enddo

   S_DUPLICATA := SR1000->DUPLICATA

   restscreen(,,,,WSSRDUP )

   setcursor(0)

return WRET


procedure grava_Sac()
  SR1100->(dbappend())
  SR1100->DUPLICATA := S_DUPLICATA
  SR1100->SEQUENCIA := S_SEQUENCIA
  SR1100->DTACORDO  := S_DTACORDO
  SR1100->JRACORDO  := S_JRACORDO
  SR1100->VLACORDO  := S_VLACORDO
  SR1100->VLACPAGO  := S_VLACORDO
  SR1100->VLACPAGAR := S_VLACPAGAR
  while SR1000->( ! rlock() ); end
  SR1000->ACORDO    := S_ACORDO
  SR1000->JRACORDO  := S_JRACORDO
  SR1000->DTACORDO  := S_DTACORDO
  SR1000->VLACPAGO  := SR1000->VLACPAGO + S_VLACORDO
  SR1000->VLACPAGAR := S_VLACPAGAR
  SR1000->( dbunlock() )
  show_Ssaldo()
return
