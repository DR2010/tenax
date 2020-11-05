/*
   Contas a Receber/CONTRA RETIRADA
   SR1000.PRG - Cadastro de Numero
*/
#include "inkey.ch"
altd(1)

telanum('SCE1000','SR1000')

abrir("VEN001")
abrir("VEN002")
abrir("VEN030")
abrir("SR0300")
abrir("SR0400")
abrir("SR0500")
abrir("SR0600")
abrir("SR1000")
abrir("SR9991")

private  S_NUMERO,S_DUPLICATA,S_SEQUENCIA,X_CODCLI,S_QTDPARC,     ;
	 S_DT_EMISSAO,S_TIPOVENDA,S_FORMAPAG,W_FORMAPAG,S_VALOR,  ;
	 S_VALORNF,S_DT_VENC,S_VL,W_DT_1,S_CODVENC,W_DT_2,        ;
	 W_DT_3,W_DT_4,W_DT_5,S_DIAS_1,S_DIAS_2,S_DIAS_3,S_DIAS_4,;
	 S_DIAS_5,S_TIPO_DOC

private  W_FILE      := {}
private  CAMPO       := {}
private  MASCARA     := {}
private  CABECALHO   := {}
private  TAMANHO     := {}
private  BESCAPE     := {|| STATUS = "P"  }
private  COR         := W_COR_002
private  TITULO      := " Pedido "
private  LININI      := 03
private  LINFIM      := 20
private  COLINI      := 02
private  COLFIM      := 77
private  BLOCK_DISP  := {|| .T. }
private  CAB_TITULO  := nil
private  BORDA       := 1

private  TECLA       := nil
private  TABELA      := nil

aadd( CAMPO , "NUMERO"                )
aadd( CAMPO , "GUERRA"                )
aadd( CAMPO , "DT_EMISSAO"            )
aadd( CAMPO , "CODVENC"               )
aadd( CAMPO , "TIPOVENDA"             )
aadd( CAMPO , "FORMAPAG"              )
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
aadd( MASCARA , "@!"                    )
aadd( MASCARA , "@E 999,999,999.99"     )

aadd( CABECALHO , "Pedido"                )
aadd( CABECALHO , "Cliente"               )
aadd( CABECALHO , "Emiss„o"               )
aadd( CABECALHO , "Venc."                 )
aadd( CABECALHO , "TV"                    )
aadd( CABECALHO , "FP"                    )
aadd( CABECALHO , "Emit."                 )
aadd( CABECALHO , "Receb"                 )
aadd( CABECALHO , "Valor"                 )

aadd( TAMANHO , 07     )
aadd( TAMANHO , 10     )
aadd( TAMANHO , 09     )
aadd( TAMANHO , 05     )
aadd( TAMANHO , 05     )
aadd( TAMANHO , 05     )
aadd( TAMANHO , 05     )
aadd( TAMANHO , 05     )
aadd( TAMANHO , 15     )

aadd( W_FILE , "VEN030" )
aadd( W_FILE , "VEN001" )
aadd( W_FILE , "VEN030" )
aadd( W_FILE , "VEN030" )
aadd( W_FILE , "VEN030" )
aadd( W_FILE , "VEN030" )
aadd( W_FILE , "VEN030" )
aadd( W_FILE , "VEN030" )
aadd( W_FILE , "VEN030" )

select VEN030
VEN030->( dbsetorder(2) )
VEN030->( dbseek("P") )

VEN030->( dbsetrelation( "VEN001", {|| VEN030->CODCLI }, "VEN030->CODCLI" ) )
setcolor(W_COR_002)

Stedite1000()

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

SR1100_pendente()

select VEN030

do while CONTINUA .and. ( (TEC:=tabmov(TABELA)) != K_ESC )

   W_TEL0012 := savescreen(,,,,)

   do case
      case TEC == 28 ; help('SR1000')
      case TEC == 27 ; return 0

      case TEC == -3   && alteracao f4
	   if VEN030->(!eof())
              Seditae1000()
	      restscreen(,,,,W_TEL0012)
	   end
	   SR1100_pendente()
	   select VEN030
	   VEN030->( dbsetorder(2) )
	   VEN030->( dbseek("P") )
	   TABELA:refreshall()

      case TEC == 13   && Consulta - enter
           if VEN030->(!eof())
              Seditae1000('a')
	      restscreen(,,,,W_TEL0012)
	   end
           select VEN030
           VEN030->( dbsetorder(2) )
           VEN030->( dbseek("P") )
	   TABELA:refreshall()

      case TEC = -2   && inclusao f3
	   Sinsere1000()
	   restscreen(,,,,W_TEL0012)
	   SR1100_pendente()
	   select VEN030
	   VEN030->( dbsetorder(2) )
	   VEN030->( dbseek("P") )
	   TABELA:refreshall()

      case TEC = K_F12
	   if VEN030->(!eof())
	       if pergunta("Confirma Cancelamento do Pedido (S/N) ?")
		  if Scanc_duplicata(VEN030->NUMERO)
		     while VEN030->( ! rlock() ); end
		     VEN030->STATUS := "C"
		     VEN030->( dbunlock() )
		     VEN030->( dbskip()   )
		     VEN030->( dbsetorder(2) )
		     VEN030->( dbseek("P") )
		     TABELA:refreshall()
		  end
	       end
	   end

      case TEC == -5   // BUSCA DIRETA = F6
	 if VEN030->( ! eof() )
	    Sbusca_nf()
	 end
	  restscreen(,,,,W_TEL0012)
	  select VEN030
	  VEN030->( dbsetorder(2) )
	  VEN030->( dbseek("P" + S_NUMERO)  )
	  TABELA:refreshall()

      case TEC = K_ESC
	   CONTINUA := .F.

   end
   select VEN030

enddo

select VEN030

close data

return

************************************
function Sinsere1000()
************************************

setcursor(1)

while .t.

   Stelae1000()

   S_NUMERO      := nova_Snota()
   S_DUPLICATA   := space(5)
   S_SEQUENCIA   := space(2)
   X_CODCLI      := space(5)
   S_TIPOVENDA   := space(2)
   S_FORMAPAG    := space(2)
   S_CODVENC     := space(2)
   S_QTDPARC     := 0
   S_DT_EMISSAO  := date()
   S_DT_VENC     := ctod("  /  /  " )
   S_VALOR       := 0.00
   S_VALORNF     := 0.00
   S_VL          := 0.00
   S_BANCO       := space(3)
   S_AGENCIA     := space(8)
   S_CHEQUENO    := space(10)
   S_DIAS_1      := 0
   S_DIAS_2      := 0
   S_DIAS_3      := 0
   S_DIAS_4      := 0
   S_DIAS_5      := 0
   S_TIPO_DOC    := space(01)

   @ 04,26 get S_NUMERO    picture "@!"
   read

   if lastkey()=27; exit ; end

   S_NUMERO  := zerofill( S_NUMERO  )

   @ 04,26 say S_NUMERO

   VEN030->(dbsetorder(1))
   if VEN030->(dbseek(S_NUMERO))
      mensbeep(" Pedido j  Cadastrado ! ")
      loop
   end

   @ 06,26 get X_CODCLI        picture "@!" valid TES_CODCLI(X_CODCLI,06,26,30)
   @ 08,26 get S_TIPOVENDA     picture "99" valid TES_Stipovenda(08,26,30)
   @ 09,26 get S_FORMAPAG      picture "99" valid TES_Sformapag(09,26,30)
   @ 11,26 get S_DT_EMISSAO
   @ 12,26 get S_CODVENC       picture "99" valid TES_Scodvecm(12,26,30) ;
			       when SR0300->PARCELA = 'X'

   @ 14,26 get S_VALORNF       picture "@E 999,999,999.99" valid S_VALORNF > 0
   read

   if lastkey()=27; exit; end

   if pergunta('Confirma inclusao do Pedido (S/N) ?')
      if SGera_Duplicatas( S_QTDPARC, S_VALORNF )
	 VEN030->( dbappend() )
	 VEN030->NUMERO      := S_NUMERO
	 VEN030->CODCLI      := X_CODCLI
	 VEN030->TIPOVENDA   := S_TIPOVENDA
	 VEN030->FORMAPAG    := S_FORMAPAG
	 VEN030->QTDPARC     := SR0500->QTDVENC
	 VEN030->DT_EMISSAO  := S_DT_EMISSAO
	 VEN030->CODVENC     := S_CODVENC
	 VEN030->VALOR       := S_VALORNF
	 VEN030->STATUS      := "P"
	 VEN030->( dbunlock() )
	 SEdit_Duplicatas( S_NUMERO )
      end
   end

end

************************************
function Seditae1000(flag)
************************************
local dt_sai

setcursor(1)

Stelae1000()

@ 04,26 say    VEN030->NUMERO

S_NUMERO     := VEN030->NUMERO
X_CODCLI     := VEN030->CODCLI
S_TIPOVENDA  := VEN030->TIPOVENDA
S_FORMAPAG   := VEN030->FORMAPAG
S_CODVENC    := VEN030->CODVENC
S_QTDPARC    := VEN030->QTDPARC
S_DT_EMISSAO := VEN030->DT_EMISSAO
S_VALORNF    := VEN030->VALOR

TES_CODCLI(X_CODCLI,06,26,30)
TES_Stipovenda(08,26,30)
TES_Sformapag (09,26,30)
TES_Scodvecm  (12,26,30)

@ 06,26 say X_CODCLI      picture "@!"
@ 08,26 say S_TIPOVENDA   picture "99"
@ 09,26 say S_FORMAPAG    picture "99"
@ 11,26 say S_DT_EMISSAO
@ 12,26 say S_CODVENC     picture "99"
@ 14,26 say S_VALORNF     picture "@E 999,999,999.99"

if flag # nil
  inkey(0)
  SEdita_Duplicatas ( S_NUMERO,"C" )
  return nil
end

@ 06,26 get X_CODCLI      picture "@!" valid TES_CODCLI(X_CODCLI,06,26,30)
@ 08,26 get S_TIPOVENDA   picture "99" valid TES_Stipovenda(08,26,30)
@ 09,26 get S_FORMAPAG    picture "99" valid TES_Sformapag (09,26,30)
@ 11,26 get S_DT_EMISSAO
@ 12,26 get S_CODVENC     picture "99" valid TES_Scodvecm(12,26,30) ;
			  when SR0300->PARCELA = 'X'

@ 14,26 get S_VALORNF     picture "@E 999,999,999.99"  valid S_VALORNF > 0
read

W_FORMAPAG := S_FORMAPAG

SEdit_Duplicatas( S_NUMERO )

while VEN030->( ! rlock() ); end
VEN030->NUMERO      := S_NUMERO
VEN030->CODCLI      := X_CODCLI
VEN030->TIPOVENDA   := S_TIPOVENDA
VEN030->FORMAPAG    := W_FORMAPAG
VEN030->CODVENC     := S_CODVENC
VEN030->QTDPARC     := S_QTDPARC
VEN030->DT_EMISSAO  := S_DT_EMISSAO
VEN030->VALOR       := S_VALORNF
VEN030->( dbunlock() )

setcursor(0)

return nil

/*
-------------------------------------------------------------------------------
Procedimento .: TEDITe1000
Objetivo .....: Menu rapido
-------------------------------------------------------------------------------
*/
procedure Stedite1000()
   local W_OLDCOR := setcolor()

   setcolor(W_COR_002)
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
procedure Stelae1000()

   setcolor( W_COR_002 )
   @ 05,02 say '³'
   @ 05,77 say '³'
   setcolor( W_COR_002 )
   @ 04,03 say ' Nr. Pedido..........:                                                    '
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
   @ 16,03 say '                                                                          '
   @ 17,03 say '                                                                          '
   @ 18,03 say '                                                                          '
   @ 19,03 say '                                                                          '
   @ 20,03 say '                                                                          '
   @ 21,03 say '                                                                          '


/*
-------------------------------------------------------------------------------
Procedimento .: SGERA_DUPLICATAS
Objetivo .....:
-------------------------------------------------------------------------------
*/
Function SGera_Duplicatas( P_QTDPARC, P_TOTAL )
local WRET := .T.

if SR0400->CHEQUE = 'X'
   S_TIPO_DOC := 'C'
else
   if SR0400->BOLETA = 'X'
      S_TIPO_DOC := 'B'
   else
      if SR0400->DUPLIC = 'X'
	 S_TIPO_DOC := 'D'
      end
   end
end

SR9991->(dbgotop())

if SR0300->PARCELA = " "
  while SR1000->( ! rlock() ); end
   SR1000->( dbappend() )
   SR1000->DUPLICATA   := S_NUMERO
   SR1000->SEQUENCIA   := " "
   SR1000->CODCLI      := X_CODCLI
   SR1000->DT_VENC     := S_DT_EMISSAO
   SR1000->FORMAPAG    := S_FORMAPAG
   SR1000->VALOR       := P_TOTAL
   SR1000->TIPO_DOC    := S_TIPO_DOC
   SR1000->STATUS      := "P"
   SR1000->( dbunlock()  )
   return WRET
end

if SR0300->PARCELA = "X" .and. ;
   SR0500->DIAS_2  = 0
   while SR1000->( ! rlock() ); end
   SR1000->( dbappend() )
   SR1000->DUPLICATA   := S_NUMERO
   SR1000->SEQUENCIA   := " "
   SR1000->CODCLI      := X_CODCLI
   SR1000->DT_VENC     := (S_DT_EMISS + SR0500->DIAS_1)
   SR1000->FORMAPAG    := S_FORMAPAG
   SR1000->VALOR       := P_TOTAL
   SR1000->TIPO_DOC    := S_TIPO_DOC
   SR1000->STATUS      := "P"
   SR1000->( dbunlock()  )
   return WRET
end

W_DT_1   := S_DT_EMISS + SR0500->DIAS_1
W_DT_2   := S_DT_EMISS + SR0500->DIAS_2
W_DT_3   := S_DT_EMISS + SR0500->DIAS_3
W_DT_4   := S_DT_EMISS + SR0500->DIAS_4
W_DT_5   := S_DT_EMISS + SR0500->DIAS_5

W_CONT   := 0
W_VL     := 0.00
W_VL_CLC := 0.00
W_RATEIO := 0.00
W_VALOR  := P_TOTAL / SR0500->QTDVENC

While W_CONT < SR0500->QTDVENC

      W_CONT := W_CONT + 1
      W_VL   := W_VALOR

      do case
	 case W_CONT = 1
	      S_DT_VENC  := W_DT_1
	 case W_CONT = 2
	      S_DT_VENC  := W_DT_2
	 case W_CONT = 3
	      S_DT_VENC  := W_DT_3
	 case W_CONT = 4
	      S_DT_VENC  := W_DT_4
	 case W_CONT = 5
	      S_DT_VENC  := W_DT_5
      endcase

      if W_CONT   #  SR0500->QTDVENC
	 W_VL     := W_VALOR  - ( SR9991->VALOR * W_CONT )
	 W_VL     := INT ( (W_VL * 100) ) / 100
	 W_RATEIO := W_RATEIO + ( SR9991->VALOR * W_CONT )
	 W_VL_CLC := W_VL_CLC + W_VL
      else
	 W_VL     := W_VALOR  + W_RATEIO
	 W_VL     := INT ( (W_VL * 100) ) / 100
	 W_VL_CLC := W_VL_CLC + W_VL
	 If W_VL_CLC > P_TOTAL
	    W_VL := W_VL - (W_VL_CLC - P_TOTAL)
	 else
	    If W_VL_CLC < P_TOTAL
	       W_VL := W_VL + ( P_TOTAL - W_VL_CLC )
	    end
	 end
      end

      while SR1000->( ! rlock() ); end
      SR1000->( dbappend() )
      SR1000->DUPLICATA   := S_NUMERO
      SR1000->SEQUENCIA   := CHR(64+W_CONT)
      SR1000->CODCLI      := X_CODCLI
      SR1000->DT_VENC     := S_DT_VENC
      SR1000->FORMAPAG    := S_FORMAPAG
      SR1000->VALOR       := W_VL
      SR1000->QTD_CH      := 0
      SR1000->TIPO_DOC    := S_TIPO_DOC
      SR1000->STATUS      := "P"
      SR1000->( dbunlock()  )

enddo

return WRET

/*
-------------------------------------------------------------------------------
Procedimento .: EDITA DUPLICATAS
Objetivo .....:
-------------------------------------------------------------------------------
*/
Function SEdit_Duplicatas( P_NUMERO , P_MODO )

local  W_FILE      := {}
local  CAMPO       := {}
local  MASCARA     := {}
local  CABECALHO   := {}
local  TAMANHO     := {}
local  BESCAPE     := {|| SR1000->DUPLICATA = P_NUMERO }
local  COR         := W_COR_002
local  TITULO      := " Duplicatas "
local  LININI      := 15
local  LINFIM      := 22
local  COLINI      := 02
local  COLFIM      := 77
local  BLOCK_DISP  := {|| .T. }
local  CAB_TITULO  := nil
local  BORDA       := 1

local  TECLA       := nil
local  TABELA      := nil

WRET := .T.

aadd( CAMPO , "DUPLICATA"  )
aadd( CAMPO , "SEQUENCIA"  )
aadd( CAMPO , "DT_VENC"    )
aadd( CAMPO , "FORMAPAG"   )
aadd( CAMPO , "VALOR"      )

aadd( MASCARA , "99999"       )
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

aadd( W_FILE , "SR1000" )
aadd( W_FILE , "SR1000" )
aadd( W_FILE , "SR1000" )
aadd( W_FILE , "SR1000" )
aadd( W_FILE , "SR1000" )

setcolor(W_COR_002)

select SR1000

SR1000->( dbsetorder(1) )
SR1000->( dbseek( P_NUMERO ))

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
      case TEC == -3 .and. P_MODO # "I" .and. P_MODO # "C" && alteracao f4
	   Saltdup1000()
	   TABELA:refreshall()
	   SELECT SR1000
	   SR1000->( dbsetorder(1) )
	   TABELA:refreshall()
      case TEC = -5  && busca direta f6
      case TEC = K_ESC
	   CONTINUA := .F.
   end
   SELECT SR1000
enddo

return WRET
//----------------------------------------------------------------------
function Saltdup1000()
//----------------------------------------------------------------------
WSSRDUP := savescreen(,,,,)

setcursor(1)

@ 10,10 say 'ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿'
@ 11,10 say '³ Duplicata ........:         /                          ³'
@ 12,10 say '³ Data Vencimento ..:                                    ³'
@ 13,10 say '³ Forma de Pagamento:                                    ³'
@ 14,10 say '³ Valor ............:                                    ³'
@ 15,10 say 'ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ'

S_DUPLICATA  := SR1000->DUPLICATA
S_SEQUENCIA  := SR1000->SEQUENCIA
S_DT_VENC    := SR1000->DT_VENC
S_FORMAPAG   := SR1000->FORMAPAG
S_VALOR      := SR1000->VALOR

TES_Sformapag(13,32,20)

if SR0400->CHEQUE = 'X'
   S_TIPO_DOC := 'C'
else
   if SR0400->BOLETA = 'X'
      S_TIPO_DOC := 'B'
   else
      if SR0400->DUPLIC = 'X'
	 S_TIPO_DOC := 'D'
      end
   end
end

while .T.
    @ 11,32 say S_DUPLICATA
    @ 11,42 say S_SEQUENCIA
    @ 12,32 say S_DT_VENC
    @ 13,32 get S_FORMAPAG  valid TES_Sformapag(13,32,25)
    @ 14,32 get S_VALOR     picture "@E 999,999,999.99"
    read

    if lastkey() = K_ESC
       restscreen(,,,,WSSRDUP )
       setcursor(0)
       return nil
    end

    X_DT_EMISSAO := VEN030->DT_EMISSAO
    if ( (date() - X_DT_EMISSAO) >= 1 )
       mensbeep(' ATENCAO! : Alteracao nao Permitida !!! ')
       loop
    else
       exit
    end

end

if pergunta("Confirma Altera‡„o da Duplicata (S/N) ?")
   while SR1000->( ! rlock() ); end
   SR1000->FORMAPAG  := S_FORMAPAG
   SR1000->TIPO_DOC  := S_TIPO_DOC
   SR1000->VALOR     := S_VALOR
   SR1000->( dbunlock() )
end

restscreen(,,,,WSSRDUP )

setcursor(0)

return nil

/*
-------------------------------------------------------------------------------
Procedimento .: SDEL_DUPLICATAS
Objetivo .....:
-------------------------------------------------------------------------------
*/
Function SDel_Duplicatas( P_NUMERO )
local WRET := .T.

SR1000->(dbsetorder(2))
if !(SR1000->(dbseek ("P"+P_NUMERO) ))
   mensbeep (" Duplicata Inexistente !")
   WRET := .F.
   return WRET
end

While SR1000->DUPLICATA = P_NUMERO .and. SR1000->(!eof())
      while SR1000->( ! rlock() ); end
      SR1000->( dbdelete() )
      SR1000->( dbunlock() )
      SR1000->( dbskip()   )
enddo

return WRET


/*
-------------------------------------------------------------------------------
Procedimento .: Sbusca_nf
Objetivo .....: BUSCA DIRETA
-------------------------------------------------------------------------------
*/
procedure Sbusca_nf()
local TB := savescreen(14,14,17,67)

setcursor(1)

@ 14,14 say 'ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿'
@ 15,14 say '³                                                   ³'
@ 16,14 say '³ Pedido.:                                          ³'
@ 17,14 say '³                                                   ³'
@ 18,14 say 'ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ'
sombra(14,14,18,66)

S_NUMERO := space(05)
@ 16,31 get S_NUMERO picture "@!"
read

S_NUMERO := zerofill( S_NUMERO)

VEN030->( dbsetorder(2) )

Set Softseek on

VEN030->( dbseek("P" + S_NUMERO), .T. )

S_NUMERO := VEN030->NUMERO

restscreen(14,29,17,46,TB)

setcursor(0)

return

/*
-------------------------------------------------------------------------------
			      CALCULAR SOMA DE VALORES
-------------------------------------------------------------------------------
*/

function Ssoma_nf(P_NUMERO,P_SEQUENCIA)
local WRET := 0.00,OLDREC := SR1000->( recno() )

SR1000->(dbsetorder(1))
SR1000->(dbseek(P_NUMERO))

WHILE SR1000->(!EOF()) .AND. SR1000->DUPLICATA = P_NUMERO

      if SR1000->SEQUENCIA # P_SEQUENCIA
	 WRET := WRET + SR1000->VALOR
      end
      SR1000->(dbskip())

enddo

WRET := INT ( (WRET * 100) ) / 100

SR1000->( dbgoto( OLDREC ) )

return WRET

/*
-------------------------------------------------------------------------------
Procedimento .: SCANC_DUPLICATAS
Objetivo .....:
-------------------------------------------------------------------------------
*/
Function Scanc_Duplicatas( P_NUMERO )
local WRET := .T.

SR1000->(dbsetorder(1))
if !(SR1000->(dbseek (P_NUMERO) ))
   mensbeep (" Duplicata Inexistente !")
   WRET := .F.
   return WRET
end

While SR1000->DUPLICATA = P_NUMERO .and. SR1000->(!eof())

      if SR1000->QTD_CH > 0
	if ! Scanc_cheque(SR1000->DUPLICATA,SR1000->SEQUENCIA)
	   WRET := .F.
	   exit
	end
      end

      while SR1000->( ! rlock() ); end
      SR1000->STATUS := "C"
      SR1000->( dbunlock() )
      SR1000->( dbskip()   )
enddo

return WRET

/*
-------------------------------------------------------------------------------
Procedimento .: SCANC_CHEQUE
Objetivo .....:
-------------------------------------------------------------------------------
*/
Function Scanc_cheque( P_DUPLICATA,P_SEQUENCIA )
local WRET := .T.

SR0600->(dbsetorder(2))
if !(SR0600->(dbseek (P_DUPLICATA+P_SEQUENCIA) ))
   mensbeep (" Cheque Inexistente !")
   WRET := .F.
   return WRET
end

WHILE SR0600->DUPLICATA = P_DUPLICATA .and. ;
      SR0600->SEQUENCIA = P_SEQUENCIA .and. ;
      SR0600->( ! EOF() )
      while SR0600->( ! rlock() ); end
      SR0600->( dbdelete() )
      SR0600->( dbunlock() )
      SR0600->( dbskip()   )
enddo

return WRET

