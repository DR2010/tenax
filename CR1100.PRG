/*
   CR1100.PRG - Baixa de Duplicatas
*/
#include "inkey.ch"
altd(1)

telanum('SCE1100','CR1100')

abrir("VEN001")
abrir("VEN012")
abrir("CR0300")
abrir("CR0400")
abrir("CR0600")
abrir("CR1000")
abrir("CR1100")
abrir("CR9991")

X_CODCLI       := space(5)
X_DUPLICATA    := space(8)
X_SEQUENCIA    := space(1)
X_BOLETA       := space(10)
X_DT_EMISSAO   := ctod("  /  /  ")
X_DT_VENC      := ctod("  /  /  ")
X_DT_PAG       := ctod("  /  /  ")
X_STATUS       := "R"
X_JUROS        := 0.00
X_VALOR        := 0.00
X_ABATIMENTO   := 0.00
X_TXADM        := 0.00
X_TOTAL        := 0.00
X_VL_PAGO      := 0.00
X_VL_PAGAR     := 0.00
X_TIPOVENDA    := space(2)
X_FORMAPAG     := space(2)

W_VL_PAGO      := 0.00
W_VL_PAGAR     := 0.00

X_ACORDO       := space(1)
X_VLACPAGO     := 0.00
X_JRACPAGO     := 0.00
X_VLACPAGAR    := 0.00
X_JRACPAGAR    := 0.00
X_DTACORDO     := ctod("  /  /  ")
X_JRACORDO     := 0.00
X_VLACORDO     := 0.00
X_VLJUROS      := 0.00

private  W_FILE      := {}
private  CAMPO       := {}
private  MASCARA     := {}
private  CABECALHO   := {}
private  TAMANHO     := {}
private  BESCAPE     := {|| STATUS = "P"  }
private  COR         := W_COREDIT
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

aadd( CABECALHO , "Duplicata"        )
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

aadd( W_FILE , "CR1000" )
aadd( W_FILE , "CR1000" )
aadd( W_FILE , "VEN001" )
aadd( W_FILE , "CR1000" )
aadd( W_FILE , "VEN012" )
aadd( W_FILE , "CR1000" )
aadd( W_FILE , "CR1000" )
aadd( W_FILE , "CR1000" )
aadd( W_FILE , "CR1000" )
aadd( W_FILE , "CR1000" )
aadd( W_FILE , "CR1000" )

select CR1000
CR1000->( dbsetorder(2) )
CR1000->( dbseek("P") )

CR1000->( dbsetrelation( "VEN001", {|| CR1000->CODCLI},"CR1000->CODCLI" ) )

setcolor(W_COREDIT)

te1100()

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

CR1100_pendente()

do while CONTINUA .and. ( (TEC:=tabmov(TABELA)) != K_ESC )

   W_TEL1100 := savescreen(,,,,)

   do case
      case TEC == 28 ; help("CR1100")
      case TEC == 27 ; return 0

      case TEC == -3   && alteracao f4
	  if CR1000->(!eof())
	     edit1100()
	     restscreen(,,,,W_TEL1100)
	     cr1100_pendente()
	  end
	  select CR1000
	  CR1000->( dbsetorder(2) )
	  CR1000->( dbseek("P") )
	  TABELA:refreshall()

      case TEC == -5   // BUSCA DIRETA = F6
	 if CR1000->( ! eof() )
	    busca_duplicata("P")
	 end
	 restscreen(,,,,W_TEL1100)
	 select CR1000
	 CR1000->( dbsetorder(2) )
	 CR1000->( dbseek("P" + X_DUPLICATA )  )
	 TABELA:refreshall()

      case TEC = K_F7  // Lancamento de Taxa
	 if CR1000->( ! eof() )
	    taxa1100()
	 end
	 restscreen(,,,,W_TEL1100)
	 select CR1000
	 CR1000->( dbsetorder(2) )
	 CR1000->( dbseek("P" + X_DUPLICATA )  )
	 TABELA:refreshall()

      case TEC = K_ESC
	 CONTINUA := .F.
   end

enddo

close data

return

************************************
function edit1100()
************************************
local getlist:= {}
 

setcursor(1)

tl1100()

X_DT_CREDITO   := CTOD('  /  /  ')
X_CODCLI       := CR1000->CODCLI
X_DUPLICATA    := CR1000->DUPLICATA
X_SEQUENCIA    := CR1000->SEQUENCIA
X_BOLETA       := CR1000->BOLETA
X_FORMAPAG     := CR1000->FORMAPAG
X_DT_PAG       := datant(2)
X_DT_VENC      := CR1000->DT_VENC
X_VALOR        := CR1000->VALOR
X_ABATIMENTO   := CR1000->ABATIMENTO
X_TXADM        := CR1000->TXADM
X_VALOR        := CR1000->VALOR
X_JUROS        := calc_juros(X_VALOR,X_DT_VENC,CR9991->JUROS, X_DT_PAG)
X_TOTAL        := 0.0
X_VL_PAGAR     := CR1000->VLACPAGAR + CR1000->JRACPAGAR
X_VL_PAGO      := CR1000->VLACPAGO  + CR1000->JRACPAGO
X_ACORDO       := CR1000->ACORDO

if acessa_nf(X_DUPLICATA)
   X_TIPOVENDA  := VEN012->TIPOVENDA
   X_DT_EMISSAO := VEN012->DT_EMISSAO
   X_TIPOVENDA  := VEN012->TIPOVENDA
end

tes_codcli    (X_CODCLI,04,20)
tes_duplicata (05,20)
tes_tipovenda (7,45,25)
tes_formapag  (8,45,25)
@ 04,18 say X_CODCLI  PICT "@!"
show_saldo()

@ 07,20 say X_DT_EMISSAO  pict "  /  /  "
@ 08,20 say X_DT_VENC     pict "  /  /  "
@ 09,20 say X_VALOR       pict "@E 999999,999.99"

@ 11,60 say X_VL_PAGO     pict "@E 999,999,999.99"
@ 12,60 say X_VL_PAGAR    pict "@E 999,999,999.99"

@ 13,20 say X_TXADM       pict "@E 999,999.99"
@ 13,60 say X_ABATIMENTO  pict "@E 999,999.99"

if CR0400->BOLETA = "X"
  X_DT_CREDITO   := DATANT(1)
end

@ 11,45 get X_ACORDO      pict "!"               valid tes_acordo()
@ 09,51 get X_DT_CREDITO  pict "99/99/99"        valid tes_dtpag() ;
						 when CR0400->BOLETA = "X"

@ 11,20 get X_DT_PAG      pict "  /  /  "        valid tes_dtpag()
@ 12,20 get X_JUROS       pict "@E 999,999.99"
read
if lastkey() = K_ESC
   return nil
end

if CR0400->BOLETA # 'X'
  X_DT_CREDITO := X_DT_PAG
  @ 09,51 SAY X_DT_CREDITO  pict "99/99/99" 
end

X_TOTAL  := (X_VALOR + X_JUROS + X_TXADM) - X_ABATIMENTO

@ 15,20 say X_TOTAL       pict "@E 9999,999,999.99"

CR0400->(Dbsetorder(1))
CR0400->(Dbseek(X_TIPOVENDA+X_FORMAPAG))

if CR0400->CHEQUE = "X"
   if ! cheque_valido()
      return nil
   end
end

INKEY()

if Pergunta('Confirma Pagamento da Duplicata (S/N) ?')
    if CR1000->QTD_CH > 0
       if ! baixa_cheque()
	  return nil
       end
    end
    while CR1000->( ! rlock() ); end
    CR1000->BOLETA     := X_BOLETA
    CR1000->DT_CREDITO := X_DT_CREDITO
    CR1000->DT_PAG     := X_DT_PAG
    CR1000->JUROS      := X_JUROS
    CR1000->STATUS     := X_STATUS
    CR1000->ACORDO     := X_ACORDO
    CR1000->( dbunlock() )
    if X_STATUS = "R"
       baixa_nf(X_DUPLICATA)
    end
end

setcursor(0)

return nil

/*
-------------------------------------------------------------------------------
Procedimento .: TE1100
Objetivo .....: Menu rapido
-------------------------------------------------------------------------------
*/
procedure te1100()
   local W_OLDCOR := setcolor()

   setcolor(W_COREDIT)
   quadro(03,02,21,77,"")
   @ 05,02 say '�'
   @ 05,77 say '�'
   @ 16,03 to 16,76 double
   @ 16,02 say '�'
   @ 16,77 say '�'

   sombra(02,02,20,77)

   setcolor( W_OLDCOR )
return


/*
-------------------------------------------------------------------------------
Procedimento .: TL1100
Objetivo .....: Menu rapido
-------------------------------------------------------------------------------
*/
procedure tl1100()

   setcolor( W_COREDIT )
   @ 05,02 say '�'
   @ 05,77 say '�'
   setcolor( W_CORGET )
   @ 04,03 say ' Cliente......:                                                           '
   @ 05,03 say ' Duplicata....:         /                                                 '
   @ 06,03 say '                                                                          '
   @ 07,03 say ' Dt.Emiss�o...:                  Venda..:                                 '
   @ 08,03 say ' Dt.vencimento:                  F.Pag..:                                 '
   @ 09,03 say ' Valor........:                  Data credito:                            '
   @ 10,03 say '                                                                          '
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
function baixa_Cheque()
local WRET := .T.

   CR0600->(dbsetorder(3))
   if ! CR0600->(dbseek("P"+X_CODCLI+X_DUPLICATA+X_SEQUENCIA))
	mensbeep('N�o existe Cheque em Aberto para Devida Baixa')
	WRET := .F.
	return WRET
    end

   while CR0600->(! eof() )              .and. ;
	 CR0600->CODCLI    = X_CODCLI    .and. ;
	 CR0600->DUPLICATA = X_DUPLICATA .and. ;
	 CR0600->SEQUENCIA = X_SEQUENCIA
	 while CR0600->(!rlock()); end
	 CR0600->STATUS := "R"
	 CR0600->DT_PAG := date()
	 CR0600->(dbunlock())
	 CR0600->(dbskip())
   enddo

return WRET

/*
-------------------------------------------------------------------------------
		       CALCULA TOTAL DE DUPLICATAS PENDENTES
-------------------------------------------------------------------------------
*/
function cr1100_pendente()
   local WRET := 0, OLDREC := CR1000->( recno() )

   CR1000->(dbsetorder(3))
   CR1000->(dbseek("P"))

   do while CR1000->(! eof() ) .and. CR1000->STATUS  = "P"
      WRET = WRET + CR1000->VALOR
      CR1000->( dbskip() )
   enddo

   CR1000->( dbgoto( OLDREC ) )

   @ 20,02 say '��������������������������������������������������������������������������Ĵ'
   @ 21,02 say '�                                        Total Pendente...:                �'
   @ 22,02 say '����������������������������������������������������������������������������'
   @ 21,62 say WRET picture "@E 999,999,999.99"

return WRET

/*
-------------------------------------------------------------------------------

-------------------------------------------------------------------------------
*/
function tes_dtpag()
local WRET := .T.
local oget := GETACTIVE()
  if oget:NAME = 'X_DT_CREDITO'
    if X_DT_CREDITO > DATE()
      mensbeep(" Data de credito superior a data atual !   <ENTER>")
      WRET := .F.
    end
  else    
    if X_DT_PAG < X_DT_EMISSAO
      mensbeep(" Data de Pagamento inferior a Emissao ! ")
      WRET := .F.
    end
    X_JUROS := calc_juros(X_VALOR,X_DT_VENC,CR9991->JUROS, X_DT_PAG)
  end

return WRET

/*
-------------------------------------------------------------------------------
				      tes_acordo
-------------------------------------------------------------------------------
*/
function tes_acordo()

local  WRET        := .T.
local  CAMPO       := {}
local  MASCARA     := {}
local  CABECALHO   := {}
local  TAMANHO     := {}
local  BESCAPE     := {|| CR1100->DUPLICATA = X_DUPLICATA .and.;
			  CR1100->SEQUENCIA = X_SEQUENCIA }
local  COR         := W_COREDIT
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

      case TEC == 28 ; help("CR1101")
      case TEC == 27 ; return 0

      case TEC == K_F3
	   ins_acordo()
	   show_saldo()
	   if X_STATUS = 'R'
	     exit
	   end
	   TABELA:refreshall()

      case TEC = K_F5
	   if CR1100->(!eof())
	       if pergunta("Confirma exclus�o do Acordo (S/N) ?")
		  del_acordo()
		  show_saldo()
	       end
	   end
	   TABELA:refreshall()

      case TEC = K_ENTER
	   EXIT

   end
   Select CR1100

enddo

return WRET
//----------------------------------------------------------------------
function ins_acordo()
//----------------------------------------------------------------------
local getlist:= {}
WSCRDUP := savescreen(,,,,)

setcursor(1)
@ 05,10 say '�����������������Ĵ    Duplicata    �����������������Ŀ'
@ 06,10 say '�                                                     �'
@ 07,10 say '� Valor...:                     Dt.Venc.:             �'
@ 08,10 say '� Juros...:                   Abat.....:              �'
@ 09,10 say '� Total...:                   Desp.....:              �'
@ 10,10 say '�                                                     �'
@ 11,10 say '� Vl.Pago.:                   Dt.Acordo:              �'
@ 12,10 say '�����������������Ĵ   A c o r d o   �����������������Ĵ'
@ 13,10 say '�                                                     �'
@ 14,10 say '� Data....:   /  /            Juros :        %        �'
@ 15,10 say '� Valor...:                                           �'
@ 16,10 say '�                                                     �'
@ 17,10 say '�����������������Ĵ P e n d e n t e �����������������Ĵ'
@ 18,10 say '�                                                     �'
@ 19,10 say '� Valor...:                                           �'
@ 20,10 say '�                                                     �'
@ 21,10 say '�������������������������������������������������������'
sombra(05,10,21,64)

while .T.

    if CR1000->ACORDO # "X"
       X_DTACORDO := DATE()
    else
       X_DTACORDO := CR1100->DTACORDO
    end

    X_VLACORDO   := 0.00
    X_VLJUROS    := 0.00
    X_VLACPAGO   := CR1000->VLACPAGO
    X_JRACORDO   := CR1000->JRACORDO
    X_VLACPAGAR  := CR1000->VLACPAGAR

    @ 07,23 say CR1000->VALOR       picture "@E 999,999,999.99"
    @ 07,53 say CR1000->DT_VENC     picture "99/99/99"
    @ 08,27 SAY CR1000->JUROS       picture "@E 999,999.99"
    @ 09,24 SAY (CR1000->VALOR+ CR1000->JUROS + X_TXADM) - X_ABATIMENTO picture "@E 999,999,999.99"

    @ 08,53 say CR1000->ABATIMENTO  picture "@E 999,999.99"
    @ 09,53 say CR1000->TXADM       picture "@E 999,999.99"
    @ 11,23 say CR1000->VLACPAGO    picture "@E 999,999,999.99"
    @ 11,53 say CR1000->DTACORDO    picture "99/99/99"

    if CR1000->ACORDO # "X"
       @ 19,23 say CR1000->VALOR     picture "@E 999,999,999.99"
    else
       @ 19,23 say CR1000->VLACPAGAR picture "@E 999,999,999.99"
    end

    @ 14,23 get X_DTACORDO          picture "99/99/99"          valid !empty(X_DTACORDO)
    @ 14,50 get X_JRACORDO          picture "@E 999.99"         valid tes_jracordo()
    @ 15,32 get X_VLACORDO          picture "@E 999,999,999.99" valid tes_vlacordo()

    @ 19,23 get X_VLACPAGAR         picture "@E 999,999,999.99" valid tes_vlacpagar()
    read

    if lastkey() = K_ESC .or. X_STATUS = 'R'
       restscreen(,,,,WSCRDUP )
       setcursor(0)
       return nil
    end

    if pergunta("Confirma Inclusao do Acordo (S/N) ?")
       grava_ac()
       exit
    else
       X_STATUS := "P"
    end

enddo

restscreen(,,,,WSCRDUP )

setcursor(0)

return nil

/*
-------------------------------------------------------------------------------
				      tes_jracordo
-------------------------------------------------------------------------------
*/
function tes_jracordo()
local WRET := .T.

X_VLACORDO := 0.00
X_VLJUROS  := 0.00

if CR1000->ACORDO # "X"
   X_VLJUROS  := calc_juros(CR1000->VALOR,CR1000->DT_VENC,X_JRACORDO,X_DTACORDO)
   X_VLACORDO := (CR1000->VALOR     + X_VLJUROS + X_TXADM) - X_ABATIMENTO
else
   X_VLJUROS  := calc_juros(CR1000->VLACPAGAR,CR1000->DTACORDO,X_JRACORDO,X_DTACORDO)   //
   X_VLACORDO := CR1000->VLACPAGAR + X_VLJUROS 
end

return WRET

/*
-------------------------------------------------------------------------------
				      tes_vlacordo
-------------------------------------------------------------------------------
*/
function tes_vlacordo()

local   WRET := .T.

if X_VLACORDO = 0.00
   WRET := .F.
   return WRET
end

if CR1000->ACORDO # "X"
   X_VLACPAGAR  := ((CR1000->VALOR     + X_VLJUROS+ X_TXADM) - X_ABATIMENTO) - X_VLACORDO
else
   X_VLACPAGAR  := (CR1000->VLACPAGAR + X_VLJUROS)- X_VLACORDO
end

@ 19,23 say X_VLACPAGAR  picture "@E 999,999,999.99"

return WRET

/*
-------------------------------------------------------------------------------
				      tes_vlacpagar
-------------------------------------------------------------------------------
*/
function tes_vlacpagar()
local WRET := .T.

   X_STATUS := "P"

   if X_VLACPAGAR = 0.00
      if pergunta ("Confirma Liquidacao do Acordo (S/N) ?")
	 X_STATUS := "R"
	 grava_ac()
      else
	 WRET := .F.
      end
   end

return WRET

/*
-------------------------------------------------------------------------------
				      show_saldo
-------------------------------------------------------------------------------
*/
function show_saldo()
local WRET := .T.

@ 11,60 say CR1000->VLACPAGO     pict "@E 999,999,999.99"
@ 12,60 say CR1000->VLACPAGAR    pict "@E 999,999,999.99"

return WRET

/*
-------------------------------------------------------------------------------
				      del_acordo
-------------------------------------------------------------------------------
*/
function del_acordo()
local WRET

  X_STATUS  := "P"

  while CR1000->( ! rlock() ); end
  CR1000->VLACPAGO  := CR1000->VLACPAGO  - CR1100->VLACPAGO
  CR1000->VLACPAGAR := CR1000->VLACPAGAR + CR1100->VLACPAGO
  CR1000->( dbunlock() )

  while CR1100->( ! rlock() ); end
  CR1100->( dbdelete() )
  CR1100->( dbunlock() )
  CR1100->( dbskip()   )

return WRET

/*
-------------------------------------------------------------------------------
				      taxa1100
-------------------------------------------------------------------------------
*/
function taxa1100()
local WRET := 0

   WSCRDUP := savescreen(,,,,)

   setcursor(1)

   @ 10,15 say '�����������������������������������Ŀ'
   @ 11,15 say '�                                   �'
   @ 12,15 say '� Desp. de Cobranca :               �'
   @ 13,15 say '�                                   �'
   @ 14,15 say '�������������������������������������'

   X_TXADM := 0.00

   while .T.
       @ 12,37 get X_TXADM     picture "@E 999,999.99"
       read
       if lastkey() = K_ESC
	  restscreen(,,,,WSCRDUP )
	  setcursor(0)
	  return nil
       end
       if pergunta("Confirma Inclusao da Despesa (S/N) ?")
	  while CR1000->( ! rlock() ); end
	  CR1000->TXADM     := X_TXADM
	  CR1000->FLG_TXADM := 'X'    // ABNER
	  CR1000->( dbunlock() )
	  exit
       end
   enddo

   X_DUPLICATA := CR1000->DUPLICATA

   restscreen(,,,,WSCRDUP )

   setcursor(0)

return WRET

FUNCTION DATANT(decre)
 local dt  := date()
 local dia := dow(dt)
 local dec := decre
 if dia = 2
        dec := DEC +2
 end
return(date()-dec)

procedure grava_ac()
  while CR1100->( ! rlock() ); end
  CR1100->(dbappend())
  CR1100->DUPLICATA := X_DUPLICATA
  CR1100->SEQUENCIA := X_SEQUENCIA
  CR1100->DTACORDO  := X_DTACORDO
  CR1100->JRACORDO  := X_JRACORDO
  CR1100->VLACORDO  := X_VLACORDO
  CR1100->VLACPAGO  := X_VLACORDO
  CR1100->VLACPAGAR := X_VLACPAGAR
  CR1100->( dbunlock() )
  while CR1000->( ! rlock() ); end
  CR1000->ACORDO    := X_ACORDO
  CR1000->JRACORDO  := X_JRACORDO
  CR1000->DTACORDO  := X_DTACORDO
  CR1000->VLACPAGO  := CR1000->VLACPAGO + X_VLACORDO
  CR1000->VLACPAGAR := X_VLACPAGAR
  CR1000->( dbunlock() )
  show_saldo()
return
