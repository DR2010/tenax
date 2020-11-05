/*
   Contas a Receber

   CRM1000.PRG - Cadastro de Nota Fiscal

*/
#include "inkey.ch"
altd(1)

telanum('SCE1000','CRM1000')

abrir("VEN001")
abrir("VEN002")
abrir("VENM012")
abrir("CR0300")
abrir("CR0400")
abrir("CR0500")
abrir("CRM1000")

private  X_NOTAFISCAL,X_DUPLICATA,X_SEQUENCIA,X_CODCLI,X_QTDPARC,;
         X_DT_EMISSAO,X_TIPOVENDA,X_FORMAPAG,X_VALOR,X_VALORNF,X_DT_VENC,  ;
         X_ICMS,X_VL,W_DT_1,X_CODVENC,W_DT_2,W_DT_3,W_DT_4,W_DT_5,      ;
	 X_DIAS_1,X_DIAS_2,X_DIAS_3,X_DIAS_4,X_DIAS_5,X_TIPO_DOC

private  W_FILE      := {}
private  CAMPO	     := {}
private  MASCARA     := {}
private  CABECALHO   := {}
private  TAMANHO     := {}
private  BESCAPE     := {||.T.}
private  COR         := W_COREDIT
private  TITULO      := " Nota Fiscais Canceladas "
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

aadd( W_FILE , "VENM012" )
aadd( W_FILE , "VEN001" )
aadd( W_FILE , "VENM012" )
aadd( W_FILE , "VENM012" )
aadd( W_FILE , "VENM012" )
aadd( W_FILE , "VENM012" )
aadd( W_FILE , "VENM012" )
aadd( W_FILE , "VENM012" )

select VENM012
VENM012->( dbsetorder(1) )

VENM012->( dbsetrelation( "VEN001", {|| VENM012->CODCLI }, "VENM012->CODCLI" ) )
setcolor(W_COREDIT)

teditc1000()

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

do while CONTINUA .and. ( (TEC:=tabmov(TABELA)) != K_ESC )

   mensagem(' <F5> - Exclui / <F6> - Busca R pida                               ')

   W_TEL0012 := savescreen(,,,,)

   do case
      case TEC == 28 ; help() ; return 1
      case TEC == 27 ; return 0

      case TEC == -3   && alteracao f4
           if VENM012->(!eof())
              editac1000()
	      restscreen(,,,,W_TEL0012)
	   end
	   keyboard chr(1)
           select VENM012
           VENM012->( dbsetorder(2) )
           VENM012->( dbgotop() )
           TABELA:refreshall()

      case TEC = -4   &&  exclusao f5
           if VENM012->(!eof())
               if pergunta("Confirma exclus„o da Nota Fiscal (S/N) ?")
                  if Del_cduplicata(VENM012->NOTAFISCAL)
                     while VENM012->( ! rlock() ); end
                     VENM012->( dbdelete() )
                     VENM012->( dbunlock() )
                     VENM012->( dbskip()   )
		  end
	       end
           end

      case TEC == -5
         if VENM012->( ! eof() )
            busca_cnf()
	 end
          restscreen(,,,,W_TEL0012)
          select VENM012
          VENM012->( dbsetorder(1) )
          VENM012->( dbseek(X_NOTAFISCAL)  )
	  TABELA:refreshall()

      case TEC = K_ESC
	   CONTINUA := .F.

   end


enddo

close data

return

************************************
function editac1000()
************************************
local dt_sai

setcursor(1)

telac1000()

@ 04,26 say    VENM012->NOTAFISCAL

X_NOTAFISCAL := VENM012->NOTAFISCAL
X_CODCLI     := VENM012->CODCLI
X_TIPOVENDA  := VENM012->TIPOVENDA
X_FORMAPAG   := VENM012->FORMAPAG
X_CODVENC    := VENM012->CODVENC
X_QTDPARC    := VENM012->QTDPARC
X_DT_EMISSAO := VENM012->DT_EMISSAO
X_VALORNF    := VENM012->VALOR
X_ICMS       := VENM012->ICMS

tes_codcli(X_CODCLI,06,26,30)
tes_tipovenda(08,26,30)
tes_formapag (09,26,30)

@ 06,26 get X_CODCLI      picture "@!" valid tes_codcli(X_CODCLI,06,26,30)
@ 08,26 get X_TIPOVENDA   picture "99" valid tes_tipovenda(08,26,30)
@ 09,26 get X_FORMAPAG	  picture "99" valid tes_formapag (09,26,30)
@ 11,26 get X_DT_EMISSAO
@ 12,26 get X_CODVENC	  picture "99" valid tes_codvecm(12,26,30) ;
			  when CR0300->PARCELA = 'X'

@ 14,26 get X_VALORNF     picture "@E 999,999,999.99"
@ 16,26 get X_ICMS        picture "@E 999,999,999.99"
read

Edita_cDuplicatas( X_NOTAFISCAL )

setcursor(0)

return nil

/*
-------------------------------------------------------------------------------
Procedimento .: TEDitc1000
Objetivo .....: Menu rapido
-------------------------------------------------------------------------------
*/
procedure teditc1000()
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
procedure telac1000()

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
Procedimento .: EDITA DUPLICATAS
Objetivo .....:
-------------------------------------------------------------------------------
*/
Function Edita_cDuplicatas( P_NOTAFISCAL )

local  CAMPO	   := {}
local  MASCARA	   := {}
local  CABECALHO   := {}
local  TAMANHO	   := {}
local  BESCAPE     := {|| CRM1000->DUPLICATA = P_NOTAFISCAL }
local  COR	   := W_COREDIT
local  TITULO      := " Duplicatas  Canceladas "
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
aadd( MASCARA , "@!"          )
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

setcolor(W_COREDIT)

select CRM1000

CRM1000->( dbsetorder(1) )
CRM1000->( dbseek( P_NOTAFISCAL ))

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
     COLFIM	     ;
   )

CONTINUA := .T.

TABELA:refreshall()
do while CONTINUA .and. ( (TEC:=tabmov(TABELA)) != K_ESC )

   mensagem('<ENTER> - Confirma Duplicatas  <F4> - Altera   ')

   do case
      case TEC == 28 ; help() ; return 1
      case TEC == 27 ; return 0
      case TEC == -3   && alteracao f4
           altdupc1000()
	   TABELA:refreshall()
      case TEC = -5  && busca direta f6
      case TEC = K_ESC
	   CONTINUA := .F.
   end
   SELECT CRM1000
enddo

return WRET
//----------------------------------------------------------------------
function altdupc1000()
//----------------------------------------------------------------------
WSCRDUP := savescreen(,,,,)

setcursor(1)

@ 10,10 say 'ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿'
@ 11,10 say '³ Duplicata ........:         /                          ³'
@ 12,10 say '³ Data Vencimento ..:                                    ³'
@ 13,10 say '³ Forma de Pagamento:                                    ³'
@ 14,10 say '³ Valor ............:                                    ³'
@ 15,10 say 'ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ'

X_DUPLICATA  := CRM1000->DUPLICATA
X_SEQUENCIA  := CRM1000->SEQUENCIA
X_DT_VENC    := CRM1000->DT_VENC
X_FORMAPAG   := CRM1000->FORMAPAG
X_VALOR      := CRM1000->VALOR

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

    exit
end

restscreen(,,,,WSCRDUP )

setcursor(0)

return nil

/*
-------------------------------------------------------------------------------
Procedimento .: DEL_cDUPLICATAS
Objetivo .....:
-------------------------------------------------------------------------------
*/
Function Del_cDuplicatas( P_NOTAFISCAL )
local WRET := .T.

CRM1000->(dbsetorder(1))
if !(CRM1000->(dbseek ("C"+P_NOTAFISCAL) ))
   mensbeep (" Duplicata Inexistente !")
   WRET := .F.
   return WRET
end

While CRM1000->DUPLICATA = P_NOTAFISCAL .and. CRM1000->(!eof())
      while CRM1000->( ! rlock() ); end
      CRM1000->( dbdelete() )
      CRM1000->( dbunlock() )
      CRM1000->( dbskip()   )
enddo

return WRET


/*
-------------------------------------------------------------------------------
Procedimento .: busca_cnf
Objetivo .....: BUSCA DIRETA
-------------------------------------------------------------------------------
*/
procedure busca_cnf()
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

VENM012->( dbsetorder(1) )

Set Softseek on

VENM012->( dbseek(X_NOTAFISCAL), .T. )

X_NOTAFISCAL := VENM012->NOTAFISCAL

restscreen(14,29,17,46,TB)

setcursor(0)

return
