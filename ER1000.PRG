/*
   Controle Gerecial - Manutencao

   ER1000.PRG - Cadastro de Nota Fiscal

*/
#include "inkey.ch"
altd(1)

telanum('SCE1000','ER1000')

abrir("VEN001")
abrir("VEN002")
abrir("VEN050")
abrir("CR0300")
abrir("CR0400")
abrir("CR0500")
abrir("CR0600")
abrir("ER1000")
abrir("CR9991")

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
private  COR         := W_COR_003
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

aadd( W_FILE , "VEN050" )
aadd( W_FILE , "VEN001" )
aadd( W_FILE , "VEN050" )
aadd( W_FILE , "VEN050" )
aadd( W_FILE , "VEN050" )
aadd( W_FILE , "VEN050" )
aadd( W_FILE , "VEN050" )
aadd( W_FILE , "VEN050" )
aadd( W_FILE , "VEN050" )

select VEN050
VEN050->( dbsetorder(2) )
VEN050->( dbseek("P") )

VEN050->( dbsetrelation( "VEN001", {|| VEN050->CODCLI }, "VEN050->CODCLI" ) )
setcolor( W_COR_003 )

t_e1000()

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

E1100_pendente()
keyboard(chr(32))
do while CONTINUA .and. ( (TEC:=tabmov(TABELA)) != K_ESC )

   W_TEL0012 := savescreen(,,,,)

   do case
      case TEC == 28 ; help("ER1000")
      case TEC == 27 ; return 0

      case TEC == -3   && alteracao f4
           if VEN050->(!eof())
              ed_e1000()
	      restscreen(,,,,W_TEL0012)
	   end
           E1100_pendente()
           select VEN050
           VEN050->( dbsetorder(2) )
           VEN050->( dbseek("P") )
           TABELA:refreshall()

      case TEC == 13   && alteracao enter
           if VEN050->(!eof())
              ed_e1000('a')
	      restscreen(,,,,W_TEL0012)
	   end
           select VEN050
           VEN050->( dbsetorder(2) )
           VEN050->( dbseek("P") )
	   TABELA:refreshall()

      case TEC = -2   && inclusao f3
           ins_e1000()
	   restscreen(,,,,W_TEL0012)
           E1100_pendente()
           select VEN050
           VEN050->( dbsetorder(2) )
           VEN050->( dbseek("P") )
	   TABELA:refreshall()

      case TEC = K_F12
           if VEN050->(!eof())
	       if pergunta("Confirma Cancelamento da Nota Fiscal (S/N) ?")
                  if canc_Eduplicata(VEN050->NOTAFISCAL)
                     while VEN050->( ! rlock() ); end
                     VEN050->STATUS := "C"
                     VEN050->( dbunlock() )
                     VEN050->( dbskip()   )
                     VEN050->( dbsetorder(2) )
                     VEN050->( dbseek("P") )
		     TABELA:refreshall()
		  end
	       end
	   end

      case TEC == -5   // BUSCA DIRETA = F6
           if VEN050->( ! eof() )
              busca_Enf()
           end
           restscreen(,,,,W_TEL0012)
           select VEN050
           VEN050->( dbsetorder(2) )
           VEN050->( dbseek("P" + X_NOTAFISCAL)  )
           TABELA:refreshall()

      case TEC = K_ESC
	   CONTINUA := .F.

   end

enddo

close data

return

************************************
function ins_e1000()
************************************
local getlist:={}

setcursor(1)

while .t.

   tela_e1000()

   X_NOTAFISCAL  := nova_enota()
   X_DUPLICATA   := space(8)
   X_SEQUENCIA   := space(2)
   X_CODCLI      := space(5)
   X_TIPOVENDA   := space(2)
   X_FORMAPAG    := space(2)
   X_FORMAPG     := space(2)
   X_CODVENC     := space(2)
   X_QTDPARC     := 0
   X_DT_EMISSAO  := date()
   X_DT_VENC     := ctod("  /  /  " )
   X_VALOR       := 0.00
   X_VALORNF     := 0.00
   X_VL          := 0.00
   X_BANCO       := space(3)
   X_AGENCIA     := space(8)
   X_CHEQUENO    := space(10)
   X_DIAS_1      := 0
   X_DIAS_2      := 0
   X_DIAS_3      := 0
   X_DIAS_4      := 0
   X_DIAS_5      := 0
   X_TIPO_DOC    := space(01)
   X_ICMS        := 0.00
   X_B_CALC      := 0.00
   X_COMPRANF    := space(8)
   X_COMPRADT    := ctod('')

   @ 04,26 get X_NOTAFISCAL    picture "@!"
   read

   if lastkey()=27; exit ; end
   X_NOTAFISCAL  := zerofill( X_NOTAFISCAL  )

   @ 04,26 say X_NOTAFISCAL

   VEN050->(dbsetorder(1))
   if VEN050->(dbseek(X_NOTAFISCAL))
      mensbeep(" Nota Fiscal j  Cadastrada ! ")
      loop
   end

   
   @ 06,26 get X_CODCLI        picture "@!"  VALID tes_codcli(X_CODCLI,06,26,30)
    
   @ 08,26 get X_TIPOVENDA     picture "99" valid tes_tipovenda(08,26,30)
   @ 09,26 get X_FORMAPAG      picture "99" valid tes_devolucao()
   @ 11,26 get X_DT_EMISSAO
   @ 12,26 get X_CODVENC       picture "99" valid tes_codvecm(12,26,30) ;
			       when CR0300->PARCELA = 'X'

   @ 14,26 get X_VALORNF       picture "@E 99999,999.99" valid X_VALORNF > 0
   read
   if lastkey()=27; loop; end
   
   X_B_CALC := X_VALORNF

   @ 16,26 get X_ICMS          picture "@E 99999,999.99"
   @ 18,26 get X_B_CALC        picture "@E 99999,999.99"

   read
   if lastkey()=27; exit; end

   if pergunta('Confirma inclusao da Nota Fiscal (S/N) ?')
      if Gera_EDuplicatas( X_QTDPARC, X_VALORNF,CR0400->DEVOLUC )
         VEN050->( dbappend() )
         VEN050->NOTAFISCAL  := X_NOTAFISCAL
         VEN050->CODCLI      := X_CODCLI
         VEN050->TIPOVENDA   := X_TIPOVENDA
         VEN050->FORMAPAG    := X_FORMAPAG
         VEN050->QTDPARC     := CR0500->QTDVENC
         VEN050->DT_EMISSAO  := X_DT_EMISSAO
         VEN050->CODVENC     := X_CODVENC
         VEN050->VALOR       := X_VALORNF
         VEN050->ICMS        := X_ICMS
         VEN050->B_CALC      := X_B_CALC
	 if CR0400->DEVOLUC = "X"
            VEN050->STATUS   := "D"
	 else
            VEN050->STATUS   := "P"
	 end
         VEN050->COMPRANF    := X_COMPRANF
         VEN050->COMPRADT    := X_COMPRADT
         VEN050->( dbunlock() )
         Edita_EDuplicatas( X_NOTAFISCAL,"I")
      end
      
   end

end

************************************
function ed_e1000( flag )
************************************
local dt_sai , getlist := {}

setcursor(1)

tela_e1000()

@ 04,26 say    VEN050->NOTAFISCAL

X_NOTAFISCAL := VEN050->NOTAFISCAL
X_CODCLI     := VEN050->CODCLI
X_TIPOVENDA  := VEN050->TIPOVENDA
X_FORMAPAG   := VEN050->FORMAPAG
X_CODVENC    := VEN050->CODVENC
X_QTDPARC    := VEN050->QTDPARC
X_DT_EMISSAO := VEN050->DT_EMISSAO
X_VALORNF    := VEN050->VALOR
X_ICMS       := VEN050->ICMS
X_B_CALC     := VEN050->B_CALC
X_COMPRANF   := VEN050->COMPRANF
X_COMPRADT   := VEN050->COMPRADT

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

if flag # nil
  inkey(0)
  Edita_EDuplicatas ( X_NOTAFISCAL,"C" )
  return nil
end

X_DT_EMISSAO := VEN050->DT_EMISSAO
if ( (date() - X_DT_EMISSAO) >= 1 )
   mensbeep(' ATENCAO! : Alteracao nao Permitida !!! ')
   return nil
end

@ 08,26 get X_TIPOVENDA   picture "99"                valid tes_tipovenda(08,26,50)
@ 09,26 get X_FORMAPAG    picture "99"                valid tes_devolucao()

@ 14,26 get X_VALORNF     picture "@E 999,999,999.99" valid X_VALORNF > 0
@ 16,26 get X_ICMS        picture "@E 999,999,999.99"
@ 18,26 get X_B_CALC      picture "@E 999,999,999.99"
read

if lastkey()=27; return nil ; end

X_FORMAPG := X_FORMAPAG

while .T.
 Edita_EDuplicatas ( X_NOTAFISCAL )
 if valida_Enf(X_NOTAFISCAL)
    exit
 end
end

while VEN050->( ! rlock() ); end
VEN050->NOTAFISCAL  := X_NOTAFISCAL
VEN050->CODCLI      := X_CODCLI
VEN050->TIPOVENDA   := X_TIPOVENDA
VEN050->FORMAPAG    := X_FORMAPG
VEN050->CODVENC     := X_CODVENC
VEN050->QTDPARC     := X_QTDPARC
VEN050->DT_EMISSAO  := X_DT_EMISSAO
VEN050->VALOR       := X_VALORNF
VEN050->ICMS        := X_ICMS
VEN050->B_CALC      := X_B_CALC
VEN050->COMPRANF    := X_COMPRANF
VEN050->COMPRADT    := X_COMPRADT
VEN050->( dbunlock() )

setcursor(0)

return nil

/*
-------------------------------------------------------------------------------
Procedimento .: T_E1000
Objetivo .....: Menu rapido
-------------------------------------------------------------------------------
*/
procedure t_e1000()
   local W_OLDCOR := setcolor()

setcolor( W_COR_003 )
// setcolor(W_COREDIT)
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
procedure tela_e1000()

// setcolor( W_COREDIT )
setcolor( W_COR_003 )
   @ 05,02 say '³'
   @ 05,77 say '³'
// setcolor( W_CORGET )
setcolor( W_COR_003 )
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

/*
-------------------------------------------------------------------------------
Procedimento .: GERA_EDUPLICATAS
Objetivo .....:
-------------------------------------------------------------------------------
*/
Function Gera_EDuplicatas( P_QTDPARC, P_TOTAL , P_DEVOLUC )
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
  while ER1000->( ! rlock() ); end
   ER1000->( dbappend() )
   ER1000->DUPLICATA   := X_NOTAFISCAL
   ER1000->SEQUENCIA   := " "
   ER1000->CODCLI      := X_CODCLI
   ER1000->DT_VENC     := X_DT_EMISSAO
   ER1000->FORMAPAG    := X_FORMAPAG
   ER1000->VALOR       := P_TOTAL
   ER1000->TIPO_DOC    := X_TIPO_DOC
   if P_DEVOLUC = "X"
      ER1000->STATUS   := "D"
   else
      ER1000->STATUS   := "P"
   end
   ER1000->( dbunlock()  )
   return WRET
end

if CR0300->PARCELA = "X" .and. ;
   CR0500->DIAS_2  = 0
   while ER1000->( ! rlock() ); end
   ER1000->( dbappend() )
   ER1000->DUPLICATA   := X_NOTAFISCAL
   ER1000->SEQUENCIA   := " "
   ER1000->CODCLI      := X_CODCLI
   ER1000->DT_VENC     := (X_DT_EMISS + CR0500->DIAS_1)
   ER1000->FORMAPAG    := X_FORMAPAG
   ER1000->VALOR       := P_TOTAL
   ER1000->TIPO_DOC    := X_TIPO_DOC
   ER1000->STATUS      := "P"
   ER1000->( dbunlock()  )
   return WRET
end

W_DT_1   := X_DT_EMISS + CR0500->DIAS_1
W_DT_2   := X_DT_EMISS + CR0500->DIAS_2
W_DT_3   := X_DT_EMISS + CR0500->DIAS_3
W_DT_4   := X_DT_EMISS + CR0500->DIAS_4
W_DT_5   := X_DT_EMISS + CR0500->DIAS_5

W_CONT   := 0
W_VL     := 0.00
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
	 W_VL     := W_VALOR  - ( CR9991->VALOR * W_CONT )
	 W_VL     := INT ( (W_VL * 100) ) / 100
	 W_RATEIO := W_RATEIO + ( CR9991->VALOR * W_CONT )
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

      while ER1000->( ! rlock() ); end
      ER1000->( dbappend() )
      ER1000->DUPLICATA   := X_NOTAFISCAL
      ER1000->SEQUENCIA   := CHR(64+W_CONT)
      ER1000->CODCLI      := X_CODCLI
      ER1000->DT_VENC     := X_DT_VENC
      ER1000->FORMAPAG    := X_FORMAPAG
      ER1000->VALOR       := W_VL
      ER1000->QTD_CH      := 0
      ER1000->TIPO_DOC    := X_TIPO_DOC
      ER1000->STATUS      := "P"
      ER1000->( dbunlock()  )

enddo

return WRET

/*
-------------------------------------------------------------------------------
Procedimento .: EDITA EDUPLICATAS
Objetivo .....:
-------------------------------------------------------------------------------
*/
Function Edita_EDuplicatas( P_NOTAFISCAL , P_MODO )

local  W_FILE      := {}
local  CAMPO       := {}
local  MASCARA     := {}
local  CABECALHO   := {}
local  TAMANHO     := {}
local  BESCAPE     := {|| ER1000->DUPLICATA = P_NOTAFISCAL }
local  COR         := W_COR_003
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

aadd( W_FILE , "ER1000" )
aadd( W_FILE , "ER1000" )
aadd( W_FILE , "ER1000" )
aadd( W_FILE , "ER1000" )
aadd( W_FILE , "ER1000" )

//setcolor(W_COREDIT)
setcolor( W_COR_003 )

select ER1000

ER1000->( dbsetorder(1) )
ER1000->( dbseek( P_NOTAFISCAL ))

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

   do case
      case TEC == 28 ; help() ; return 1
      case TEC == 27 ; return 0
      case TEC == -3 .and. P_MODO # "I" .and. P_MODO # "C" && alteracao f4
           altdup_E1000()
	   TABELA:refreshall()
           SELECT ER1000
           ER1000->( dbsetorder(1) )
	   TABELA:refreshall()
      case TEC = -5  && busca direta f6
      case TEC = K_ESC
	   CONTINUA := .F.
   end
   SELECT ER1000
enddo

return WRET
//----------------------------------------------------------------------
function altdup_E1000()
//----------------------------------------------------------------------
WSCRDUP := savescreen(,,,,)

setcursor(1)

@ 10,10 say 'ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿'
@ 11,10 say '³ Duplicata ........:         /                          ³'
@ 12,10 say '³ Data Vencimento ..:                                    ³'
@ 13,10 say '³ Forma de Pagamento:                                    ³'
@ 14,10 say '³ Valor ............:                                    ³'
@ 15,10 say 'ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ'

X_DUPLICATA  := ER1000->DUPLICATA
X_SEQUENCIA  := ER1000->SEQUENCIA
X_FORMAPAG   := ER1000->FORMAPAG
X_DT_VENC    := ER1000->DT_VENC
X_VALOR      := ER1000->VALOR

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
    @ 13,32 get X_FORMAPAG  valid   tes_formapag(13,32,20)
    @ 14,32 get X_VALOR     picture "@E 999,999,999.99"
    read

    if lastkey() = K_ESC
       restscreen(,,,,WSCRDUP )
       setcursor(0)
       return nil
    end

    exit

enddo

if pergunta("Confirma Altera‡„o da Duplicata (S/N) ?")
   while ER1000->( ! rlock() ); end
   ER1000->FORMAPAG  := X_FORMAPAG
   ER1000->VALOR     := X_VALOR
   ER1000->( dbunlock() )
end

restscreen(,,,,WSCRDUP )

setcursor(0)

return nil

/*
-------------------------------------------------------------------------------
Procedimento .: DEL_EDUPLICATAS
Objetivo .....:
-------------------------------------------------------------------------------
*/
Function Del_EDuplicatas( P_NOTAFISCAL )
local WRET := .T.

ER1000->(dbsetorder(2))
if !(ER1000->(dbseek ("P"+P_NOTAFISCAL) ))
   mensbeep (" Duplicata Inexistente !")
   WRET := .F.
   return WRET
end

While ER1000->DUPLICATA = P_NOTAFISCAL .and. ER1000->(!eof())
      while ER1000->( ! rlock() ); end
      ER1000->( dbdelete() )
      ER1000->( dbunlock() )
      ER1000->( dbskip()   )
enddo

return WRET

/*
-------------------------------------------------------------------------------
Procedimento .: busca_Enf
Objetivo .....: BUSCA DIRETA
-------------------------------------------------------------------------------
*/
procedure busca_Enf()
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

VEN050->( dbsetorder(2) )

Set Softseek on

VEN050->( dbseek("P" + X_NOTAFISCAL), .T. )

X_NOTAFISCAL := VEN050->NOTAFISCAL

restscreen(14,29,17,46,TB)

setcursor(0)

return

/*
-------------------------------------------------------------------------------
			      VERIFICA VALORES DE DUPLICATAS PARA NF
-------------------------------------------------------------------------------
*/

function valida_Enf(P_NOTAFISCAL)
local WRET    := .T.
local W_VLDUP := 0.00

ER1000->(dbsetorder(1))
ER1000->(dbseek(P_NOTAFISCAL))

WHILE ER1000->(!EOF()) .AND. ER1000->DUPLICATA = P_NOTAFISCAL

      W_VLDUP := W_VLDUP + ER1000->VALOR
      ER1000->(dbskip())

enddo

W_VLDUP := INT ( (W_VLDUP * 100) ) / 100

if W_VLDUP # X_VALORNF
   mensbeep ('Duplicatas Nao Batem com Valor Total da Nota !')
   WRET := .F.
end

return WRET

/*
-------------------------------------------------------------------------------
Procedimento .: CANC_EDUPLICATAS
Objetivo .....:
-------------------------------------------------------------------------------
*/
Function canc_EDuplicatas( P_NOTAFISCAL )
local WRET := .T.

ER1000->(dbsetorder(1))
if !(ER1000->(dbseek (P_NOTAFISCAL) ))
   mensbeep (" Duplicata Inexistente !")
   WRET := .F.
   return WRET
end

While ER1000->DUPLICATA = P_NOTAFISCAL .and. ER1000->(!eof())

      if ER1000->QTD_CH > 0
        if ! canc_cheque(ER1000->DUPLICATA,ER1000->SEQUENCIA)
	   WRET := .F.
	   exit
	end
      end

      while ER1000->( ! rlock() ) ; end
      ER1000->STATUS := "C"
      ER1000->( dbunlock() )

      ER1000->( dbskip()   )

end

return WRET

/*
-------------------------------------------------------------------------------
Procedimento .: CANC_ECHEQUE
Objetivo .....:
-------------------------------------------------------------------------------
*/
Function canc_Echeque( P_DUPLICATA,P_SEQUENCIA )
local WRET := .T.

ER0600->(dbsetorder(2))
if !(ER0600->(dbseek (P_DUPLICATA+P_SEQUENCIA) ))
   mensbeep (" Cheque Inexistente !")
   WRET := .F.
   return WRET
end

WHILE ER0600->DUPLICATA = P_DUPLICATA .and. ;
      ER0600->SEQUENCIA = P_SEQUENCIA .and. ;
      ER0600->( ! EOF() )
      while ER0600->( ! rlock() ); end
      ER0600->( dbdelete() )
      ER0600->( dbunlock() )
      ER0600->( dbskip()   )
enddo

return WRET



