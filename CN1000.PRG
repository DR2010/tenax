/*
   Contas a Receber

   CR1000.PRG - Cadastro de Nota Fiscal

*/
#include "inkey.ch"
altd(1)

telanum('SCE1000','CR1000')

abrir("VEN001")
abrir("VEN002")
abrir("VEN012")
abrir("CR0300")
abrir("CR0400")
abrir("CR0500")
abrir("CR0600")
abrir("CR1000")
abrir("CR9991")

private  X_NOTAFISCAL,X_DUPLICATA,X_SEQUENCIA,X_CODCLI,X_QTDPARC, ;
         X_DT_EMISSAO,X_TIPOVENDA,X_FORMAPAG,W_FORMAPAG,X_VALOR,  ;
         X_VALORNF,X_DT_VENC,X_ICMS,X_VL,W_DT_1,X_CODVENC,W_DT_2, ;
         W_DT_3,W_DT_4,W_DT_5,X_DIAS_1,X_DIAS_2,X_DIAS_3,X_DIAS_4,;
         X_DIAS_5,X_TIPO_DOC

private  W_FILE      := {}
private  CAMPO	     := {}
private  MASCARA     := {}
private  CABECALHO   := {}
private  TAMANHO     := {}
private  BESCAPE     := {|| STATUS = "P"  }
private  COR		:= W_COREDIT
private  TITULO      := " Nota Fiscal "
private  LININI      := 03
private  LINFIM      := 20
private  COLINI      := 02
private  COLFIM      := 77
private  BLOCK_DISP  := {|| .T. }
private  CAB_TITULO  := nil
private  BORDA	     := 1

private  TECLA	     := nil
private  TABELA      := nil

aadd( CAMPO , "NOTAFISCAL"            )
aadd( CAMPO , "GUERRA"                )
aadd( CAMPO , "DT_EMISSAO"            )
aadd( CAMPO , "CODVENC"               )
aadd( CAMPO , "TIPOVENDA"             )
aadd( CAMPO , "QTDPARC"               )
aadd( CAMPO , "QTDREC"                )
aadd( CAMPO , "VALOR"                 )

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
aadd( CABECALHO , "Venda"                 )
aadd( CABECALHO , "Emit."                 )
aadd( CABECALHO , "Receb"                 )
aadd( CABECALHO , "Valor"                 )

aadd( TAMANHO , 12     )
aadd( TAMANHO , 10     )
aadd( TAMANHO , 09     )
aadd( TAMANHO , 05     )
aadd( TAMANHO , 05     )
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

select VEN012
VEN012->( dbsetorder(2) )
VEN012->( dbseek("P") )

VEN012->( dbsetrelation( "VEN001", {|| VEN012->CODCLI }, "VEN012->CODCLI" ) )
setcolor(W_COREDIT)

tedite1000()

TABELA := tabelanew( CAMPO	    , ;
		     MASCARA	   , ;
		     CABECALHO	   , ;
		     TAMANHO	   , ;
		     BESCAPE	   , ;
		     COR	   , ;
		     TITULO	   , ;
		     LININI	   , ;
		     LINFIM	   , ;
		     COLINI	   , ;
		     BLOCK_DISP    , ;
		     CAB_TITULO    , ;
		     BORDA	   , ;
		     COLFIM	   , ;
		     W_FILE	     ;
		   )

CONTINUA := .T.

cr1100_pendente()

do while CONTINUA .and. ( (TEC:=tabmov(TABELA)) != K_ESC )

   mensagem('<F3> - Inclui <F4> - Altera <F6> - Busca R pida <F12> - Cancela NF ')

   W_TEL0012 := savescreen(,,,,)

   do case
      case TEC == 28 ; help() ; return 1
      case TEC == 27 ; return 0

      case TEC == -3   && alteracao f4
	   if VEN012->(!eof())
	      editae1000()
	      restscreen(,,,,W_TEL0012)
	   end
	   cr1100_pendente()
	   select VEN012
	   VEN012->( dbsetorder(2) )
	   VEN012->( dbseek("P") )
	   TABELA:refreshall()

      case TEC = -2   && inclusao f3
	   insere1000()
	   restscreen(,,,,W_TEL0012)
	   cr1100_pendente()
	   select VEN012
	   VEN012->( dbsetorder(2) )
	   VEN012->( dbseek("P") )
	   TABELA:refreshall()

      case TEC = K_F12
	   if VEN012->(!eof())
               if pergunta("Confirma Cancelamento da Nota Fiscal (S/N) ?")
                  if canc_duplicata(VEN012->NOTAFISCAL)
                     while VEN012->( ! rlock() ); end
                     VEN012->STATUS := "C"
		     VEN012->( dbunlock() )
		     VEN012->( dbskip()   )
                     VEN012->( dbsetorder(2) )
                     VEN012->( dbseek("P") )
                     TABELA:refreshall()
		  end
	       end
           end

      case TEC == -5   // BUSCA DIRETA = F6
         if VEN012->( ! eof() )
            busca_nf()
	 end
          restscreen(,,,,W_TEL0012)
          select VEN012
          VEN012->( dbsetorder(2) )
          VEN012->( dbseek("P" + X_NOTAFISCAL)  )
	  TABELA:refreshall()

      case TEC = K_ESC
	   CONTINUA := .F.

   end


enddo

close data

return

************************************
function insere1000()
************************************

setcursor(1)

while .t.

   telae1000()

   X_NOTAFISCAL  := nova_nota()
   X_DUPLICATA	 := space(8)
   X_SEQUENCIA	 := space(2)
   X_CODCLI	 := space(5)
   X_TIPOVENDA	 := space(2)
   X_FORMAPAG	 := space(2)
   X_CODVENC	 := space(2)
   X_QTDPARC	 := 0
   X_DT_EMISSAO  := date()
   X_DT_VENC	 := ctod("  /  /  " )
   X_VALOR	 := 0.00
   X_VALORNF     := 0.00
   X_VL 	 := 0.00
   X_BANCO	 := space(3)
   X_AGENCIA	 := space(8)
   X_CHEQUENO	 := space(10)
   X_DIAS_1	 := 0
   X_DIAS_2	 := 0
   X_DIAS_3	 := 0
   X_DIAS_4	 := 0
   X_DIAS_5	 := 0
   X_TIPO_DOC	 := space(01)
   X_ICMS        := 0.00

   @ 04,26 get X_NOTAFISCAL    picture "@!"
   read

   if lastkey()=27; exit ; end

   X_NOTAFISCAL  := zerofill( X_NOTAFISCAL  )

   @ 04,26 say X_NOTAFISCAL

   VEN012->(dbsetorder(1))
   if VEN012->(dbseek(X_NOTAFISCAL))
      mensbeep(" Nota Fiscal j  Cadastrada ! ")
      loop
   end

   @ 06,26 get X_CODCLI        picture "@!" valid tes_codcli(X_CODCLI,06,26,30)
   @ 08,26 get X_TIPOVENDA     picture "99" valid tes_tipovenda(08,26,30)
   @ 09,26 get X_FORMAPAG      picture "99" valid tes_formapag(09,26,30)
   @ 11,26 get X_DT_EMISSAO
   @ 12,26 get X_CODVENC       picture "99" valid tes_codvecm(12,26,30) ;
			       when CR0300->PARCELA = 'X'

   @ 14,26 get X_VALORNF       picture "@E 999,999,999.99"
   @ 16,26 get X_ICMS          picture "@E 999,999,999.99"
   read

   if lastkey()=27; exit; end

   if pergunta('Confirma inclusao da Nota Fiscal (S/N) ?')
      if Gera_Duplicatas( X_QTDPARC, X_VALORNF )
	 VEN012->( dbappend() )
	 VEN012->NOTAFISCAL  := X_NOTAFISCAL
	 VEN012->CODCLI      := X_CODCLI
	 VEN012->TIPOVENDA   := X_TIPOVENDA
	 VEN012->FORMAPAG    := X_FORMAPAG
	 VEN012->QTDPARC     := CR0500->QTDVENC
	 VEN012->DT_EMISSAO  := X_DT_EMISSAO
	 VEN012->CODVENC     := X_CODVENC
         VEN012->VALOR       := X_VALORNF
         VEN012->ICMS        := X_ICMS
	 VEN012->STATUS      := "P"
	 VEN012->( dbunlock() )
	 Edita_Duplicatas( X_NOTAFISCAL )
      end
   end

end

************************************
function editae1000()
************************************
local dt_sai

setcursor(1)

telae1000()

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

tes_codcli(X_CODCLI,06,26,30)
tes_tipovenda(08,26,30)
tes_formapag (09,26,30)

@ 06,26 get X_CODCLI	  picture "@!" valid tes_codcli(X_CODCLI,06,26,30)
@ 08,26 get X_TIPOVENDA   picture "99" valid tes_tipovenda(08,26,30)
@ 09,26 get X_FORMAPAG	  picture "99" valid tes_formapag (09,26,30)
@ 11,26 get X_DT_EMISSAO
@ 12,26 get X_CODVENC	  picture "99" valid tes_codvecm(12,26,30) ;
			  when CR0300->PARCELA = 'X'

@ 14,26 get X_VALORNF     picture "@E 999,999,999.99"
@ 16,26 get X_ICMS        picture "@E 999,999,999.99"
read

W_FORMAPAG := X_FORMAPAG

Edita_Duplicatas( X_NOTAFISCAL )

while VEN012->( ! rlock() ); end
VEN012->NOTAFISCAL  := X_NOTAFISCAL
VEN012->CODCLI      := X_CODCLI
VEN012->TIPOVENDA   := X_TIPOVENDA
VEN012->FORMAPAG    := W_FORMAPAG
VEN012->CODVENC     := X_CODVENC
VEN012->QTDPARC     := X_QTDPARC
VEN012->DT_EMISSAO  := X_DT_EMISSAO
VEN012->VALOR       := X_VALORNF
VEN012->ICMS        := X_ICMS
VEN012->( dbunlock() )

setcursor(0)

return nil

/*
-------------------------------------------------------------------------------
Procedimento .: TEDITe1000
Objetivo .....: Menu rapido
-------------------------------------------------------------------------------
*/
procedure tedite1000()
   local W_OLDCOR := setcolor()

   setcolor(W_COREDIT)
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
procedure telae1000()

   setcolor( W_COREDIT )
   @ 05,02 say '³'
   @ 05,77 say '³'
   setcolor( W_CORGET )
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
   @ 18,03 say '                                                                          '
   @ 19,03 say '                                                                          '
   @ 20,03 say '                                                                          '
   @ 21,03 say '                                                                          '


/*
-------------------------------------------------------------------------------
Procedimento .: GERA_DUPLICATAS
Objetivo .....:
-------------------------------------------------------------------------------
*/
Function Gera_Duplicatas( P_QTDPARC, P_TOTAL )
local WRET := .T.

if CR0400->CHEQUE = 'X'
   X_TIPO_DOC := 'C'
else
   if CR0400->BOLETA = 'X'
      X_TIPO_DOC := 'B'
   else
      if CR0400->DUPLIC = 'X'
	 X_TIPO_DOC := 'D'
      end
   end
end

CR9991->(dbgotop())

if CR0300->PARCELA = " "
  while CR1000->( ! rlock() ); end
   CR1000->( dbappend() )
   CR1000->DUPLICATA   := X_NOTAFISCAL
   CR1000->SEQUENCIA   := " "
   CR1000->CODCLI      := X_CODCLI
   CR1000->DT_VENC     := X_DT_EMISSAO
   CR1000->FORMAPAG    := X_FORMAPAG
   CR1000->VALOR       := P_TOTAL
   CR1000->TIPO_DOC    := X_TIPO_DOC
   CR1000->STATUS      := "P"
   CR1000->( dbunlock()  )
   return WRET
end

if CR0300->PARCELA = "X" .and. ;
   CR0500->DIAS_2  = 0
   while CR1000->( ! rlock() ); end
   CR1000->( dbappend() )
   CR1000->DUPLICATA   := X_NOTAFISCAL
   CR1000->SEQUENCIA   := " "
   CR1000->CODCLI      := X_CODCLI
   CR1000->DT_VENC     := (X_DT_EMISS + CR0500->DIAS_1)
   CR1000->FORMAPAG    := X_FORMAPAG
   CR1000->VALOR       := P_TOTAL
   CR1000->TIPO_DOC    := X_TIPO_DOC
   CR1000->STATUS      := "P"
   CR1000->( dbunlock()  )
   return WRET
end

W_DT_1	 := X_DT_EMISS + CR0500->DIAS_1
W_DT_2	 := X_DT_EMISS + CR0500->DIAS_2
W_DT_3	 := X_DT_EMISS + CR0500->DIAS_3
W_DT_4	 := X_DT_EMISS + CR0500->DIAS_4
W_DT_5	 := X_DT_EMISS + CR0500->DIAS_5

W_CONT	 := 0
W_VL	 := 0.00
W_VL_CLC := 0.00
W_RATEIO := 0.00
W_VALOR  := P_TOTAL / CR0500->QTDVENC

While W_CONT < CR0500->QTDVENC

      W_CONT := W_CONT + 1
      W_VL   := W_VALOR

      do case
	 case W_CONT = 1
	      X_DT_VENC  := W_DT_1
	 case W_CONT = 2
	      X_DT_VENC  := W_DT_2
	 case W_CONT = 3
	      X_DT_VENC  := W_DT_3
	 case W_CONT = 4
	      X_DT_VENC  := W_DT_4
	 case W_CONT = 5
	      X_DT_VENC  := W_DT_5
      endcase

      if W_CONT   #  CR0500->QTDVENC
	 W_VL	  := W_VALOR  - ( CR9991->VALOR * W_CONT )
	 W_VL	  := INT ( (W_VL * 100) ) / 100
	 W_RATEIO := W_RATEIO + ( CR9991->VALOR * W_CONT )
	 W_VL_CLC := W_VL_CLC + W_VL
      else
	 W_VL	  := W_VALOR  + W_RATEIO
	 W_VL	  := INT ( (W_VL * 100) ) / 100
	 W_VL_CLC := W_VL_CLC + W_VL
	 If W_VL_CLC > P_TOTAL
	    W_VL := W_VL - (W_VL_CLC - P_TOTAL)
	 else
	    If W_VL_CLC < P_TOTAL
	       W_VL := W_VL + ( P_TOTAL - W_VL_CLC )
	    end
	 end
      end

      while CR1000->( ! rlock() ); end
      CR1000->( dbappend() )
      CR1000->DUPLICATA   := X_NOTAFISCAL
      CR1000->SEQUENCIA   := CHR(64+W_CONT)
      CR1000->CODCLI	  := X_CODCLI
      CR1000->DT_VENC	  := X_DT_VENC
      CR1000->FORMAPAG	  := X_FORMAPAG
      CR1000->VALOR	  := W_VL
      CR1000->QTD_CH	  := 0
      CR1000->TIPO_DOC	  := X_TIPO_DOC
      CR1000->STATUS	  := "P"
      CR1000->( dbunlock()  )

enddo

return WRET

/*
-------------------------------------------------------------------------------
Procedimento .: EDITA DUPLICATAS
Objetivo .....:
-------------------------------------------------------------------------------
*/
Function Edita_Duplicatas( P_NOTAFISCAL )

local  W_FILE      := {}
local  CAMPO       := {}
local  MASCARA	   := {}
local  CABECALHO   := {}
local  TAMANHO	   := {}
local  BESCAPE	   := {|| CR1000->DUPLICATA = P_NOTAFISCAL }
local  COR	   := W_COREDIT
local  TITULO	   := " Duplicatas "
local  LININI	   := 15
local  LINFIM	   := 22
local  COLINI	   := 02
local  COLFIM	   := 77
local  BLOCK_DISP  := {|| .T. }
local  CAB_TITULO  := nil
local  BORDA	   := 1

local  TECLA	   := nil
local  TABELA	   := nil

WRET := .T.

aadd( CAMPO , "DUPLICATA"  )
aadd( CAMPO , "SEQUENCIA"  )
aadd( CAMPO , "DT_VENC"    )
aadd( CAMPO , "FORMAPAG"   )
aadd( CAMPO , "VALOR"      )

aadd( MASCARA , "99999999"    )
aadd( MASCARA , "999"         )
aadd( MASCARA , "99/99/99"    )
aadd( MASCARA , "99"          )
aadd( MASCARA , "@E 999,999,999.99" )

aadd( CABECALHO , "N§ Duplic"  )
aadd( CABECALHO , "Seq"        )
aadd( CABECALHO , "Vencto"     )
aadd( CABECALHO , "Forma Pg"   )
aadd( CABECALHO , "Valor"      )

aadd( TAMANHO , 08 )
aadd( TAMANHO , 03 )
aadd( TAMANHO ,  8 )
aadd( TAMANHO ,  8 )
aadd( TAMANHO , 15 )

aadd( W_FILE , "CR1000" )
aadd( W_FILE , "CR1000" )
aadd( W_FILE , "CR1000" )
aadd( W_FILE , "CR1000" )
aadd( W_FILE , "CR1000" )

setcolor(W_COREDIT)

select CR1000

CR1000->( dbsetorder(1) )
CR1000->( dbseek( P_NOTAFISCAL ))

TABELA := tabelanew( CAMPO     , ;
     MASCARA	   , ;
     CABECALHO	   , ;
     TAMANHO	   , ;
     BESCAPE	   , ;
     COR	   , ;
     TITULO	   , ;
     LININI	   , ;
     LINFIM	   , ;
     COLINI	   , ;
     BLOCK_DISP    , ;
     CAB_TITULO    , ;
     BORDA	   , ;
     COLFIM        , ;
     W_FILE          ;
   )

CONTINUA := .T.

TABELA:refreshall()
do while CONTINUA .and. ( (TEC:=tabmov(TABELA)) != K_ESC )

   mensagem('<ENTER> - Confirma Duplicatas  <F4> - Altera   ')

   do case
      case TEC == 28 ; help() ; return 1
      case TEC == 27 ; return 0
      case TEC == -3   && alteracao f4
	   altdup1000()
           TABELA:refreshall()
           SELECT CR1000
           CR1000->( dbsetorder(1) )
           TABELA:refreshall()
      case TEC = -5  && busca direta f6
      case TEC = K_ESC
	   CONTINUA := .F.
   end
   SELECT CR1000
enddo

return WRET
//----------------------------------------------------------------------
function altdup1000()
//----------------------------------------------------------------------
WSCRDUP := savescreen(,,,,)

setcursor(1)

@ 10,10 say 'ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿'
@ 11,10 say '³ Duplicata ........:         /                          ³'
@ 12,10 say '³ Data Vencimento ..:                                    ³'
@ 13,10 say '³ Forma de Pagamento:                                    ³'
@ 14,10 say '³ Valor ............:                                    ³'
@ 15,10 say 'ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ'

X_DUPLICATA  := CR1000->DUPLICATA
X_SEQUENCIA  := CR1000->SEQUENCIA
X_DT_VENC    := CR1000->DT_VENC
X_FORMAPAG   := CR1000->FORMAPAG
X_VALOR      := CR1000->VALOR

tes_formapag(13,32,20)

if CR0400->CHEQUE = 'X'
   X_TIPO_DOC := 'C'
else
   if CR0400->BOLETA = 'X'
      X_TIPO_DOC := 'B'
   else
      if CR0400->DUPLIC = 'X'
	 X_TIPO_DOC := 'D'
      end
   end
end

while .T.
    @ 11,32 say X_DUPLICATA
    @ 11,42 say X_SEQUENCIA
    @ 12,32 say X_DT_VENC
    @ 13,32 get X_FORMAPAG  valid tes_formapag(13,32,25)
    @ 14,32 get X_VALOR     picture "@E 999,999,999.99"
    read

    if lastkey() = K_ESC
       restscreen(,,,,WSCRDUP )
       setcursor(0)
       return nil
    end

    if (soma_nf(X_NOTAFISCAL,X_SEQUENCIA) + X_VALOR) # VEN012->VALOR
       mensbeep('Soma da(s) duplicata(s) maior(es) que a Nota Fiscal !')
       loop
    else
       exit
    end

end

if pergunta("Confirma Altera‡„o da Duplicata (S/N) ?")
   while CR1000->( ! rlock() ); end
   CR1000->FORMAPAG  := X_FORMAPAG
   CR1000->TIPO_DOC  := X_TIPO_DOC
   CR1000->VALOR     := X_VALOR
   CR1000->( dbunlock() )
end

restscreen(,,,,WSCRDUP )

setcursor(0)

return nil

/*
-------------------------------------------------------------------------------
Procedimento .: DEL_DUPLICATAS
Objetivo .....:
-------------------------------------------------------------------------------
*/
Function Del_Duplicatas( P_NOTAFISCAL )
local WRET := .T.

CR1000->(dbsetorder(2))
if !(CR1000->(dbseek ("P"+P_NOTAFISCAL) ))
   mensbeep (" Duplicata Inexistente !")
   WRET := .F.
   return WRET
end

While CR1000->DUPLICATA = P_NOTAFISCAL .and. CR1000->(!eof())
      while CR1000->( ! rlock() ); end
      CR1000->( dbdelete() )
      CR1000->( dbunlock() )
      CR1000->( dbskip()   )
enddo

return WRET


/*
-------------------------------------------------------------------------------
Procedimento .: busca_nf
Objetivo .....: BUSCA DIRETA
-------------------------------------------------------------------------------
*/
procedure busca_nf()
local TB := savescreen(14,14,17,67)

setcursor(1)

@ 14,14 say 'ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿'
@ 15,14 say '³                                                   ³'
@ 16,14 say '³ Nota Fiscal.:                                     ³'
@ 17,14 say '³                                                   ³'
@ 18,14 say 'ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ'
sombra(14,14,18,66)

X_NOTAFISCAL := space(08)
@ 16,31 get X_NOTAFISCAL picture "@!"
read

X_NOTAFISCAL := zerofill( X_NOTAFISCAL)

VEN012->( dbsetorder(2) )

Set Softseek on

VEN012->( dbseek("P" + X_NOTAFISCAL), .T. )

X_NOTAFISCAL := VEN012->NOTAFISCAL

restscreen(14,29,17,46,TB)

setcursor(0)

return

/*
-------------------------------------------------------------------------------
			      CALCULAR SOMA DE VALORES
-------------------------------------------------------------------------------
*/

function soma_nf(P_NOTAFISCAL,P_SEQUENCIA)
local WRET := 0.00,OLDREC := CR1000->( recno() )

CR1000->(dbsetorder(1))
CR1000->(dbseek(P_NOTAFISCAL))

WHILE CR1000->(!EOF()) .AND. CR1000->DUPLICATA = P_NOTAFISCAL

      if CR1000->SEQUENCIA # P_SEQUENCIA
	 WRET := WRET + CR1000->VALOR
      end
      CR1000->(dbskip())

enddo

WRET := INT ( (WRET * 100) ) / 100

CR1000->( dbgoto( OLDREC ) )

return WRET

/*
-------------------------------------------------------------------------------
Procedimento .: CANC_DUPLICATAS
Objetivo .....:
-------------------------------------------------------------------------------
*/
Function canc_Duplicatas( P_NOTAFISCAL )
local WRET := .T.

CR1000->(dbsetorder(2))
if !(CR1000->(dbseek ("P"+P_NOTAFISCAL) ))
   mensbeep (" Duplicata Inexistente !")
   WRET := .F.
   return WRET
end

While CR1000->DUPLICATA = P_NOTAFISCAL .and. CR1000->(!eof())

      if CR1000->QTD_CH > 0
        if ! canc_cheque(CR1000->DUPLICATA,CR1000->SEQUENCIA)
           WRET := .F.
           exit
        end
      end

      while CR1000->( ! rlock() ); end
      CR1000->STATUS := "C"
      CR1000->( dbunlock() )
      CR1000->( dbskip()   )
enddo

return WRET

/*
-------------------------------------------------------------------------------
Procedimento .: CANC_CHEQUE
Objetivo .....:
-------------------------------------------------------------------------------
*/
Function canc_cheque( P_DUPLICATA,P_SEQUENCIA )
local WRET := .T.

CR0600->(dbsetorder(2))
if !(CR0600->(dbseek (P_DUPLICATA+P_SEQUENCIA) ))
   mensbeep (" Cheque Inexistente !")
   WRET := .F.
   return WRET
end

WHILE CR0600->DUPLICATA = P_DUPLICATA .and. ;
      CR0600->SEQUENCIA = P_SEQUENCIA .and. ;
      CR0600->( ! EOF() )
      while CR0600->( ! rlock() ); end
      CR0600->( dbdelete() )
      CR0600->( dbunlock() )
      CR0600->( dbskip()   )
enddo

return WRET

