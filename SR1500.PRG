/*
   Contas a Receber/CONTRA RETIRADA
   SR1500.PRG - Cadastro de Numero Cancelada
*/
#include "inkey.ch"
altd(1)

telanum('SCE1500','SR1500')

abrir("VEN001")
abrir("VEN002")
abrir("VEN030")
abrir("SR0300")
abrir("SR0400")
abrir("SR0500")
abrir("SR1000")
abrir("SR9991")

private  S_NUMERO,S_DUPLICATA,S_SEQUENCIA,X_CODCLI,S_QTDPARC,              ;
         S_DT_EMISSAO,S_TIPOVENDA,S_FORMAPAG,S_VALOR,S_VALORNF,S_DT_VENC,  ;
         S_ICMS,S_VL,W_DT_1,S_CODVENC,W_DT_2,W_DT_3,W_DT_4,W_DT_5,         ;
         S_DIAS_1,S_DIAS_2,S_DIAS_3,S_DIAS_4,S_DIAS_5,S_TIPO_DOC

private  W_FILE      := {}
private  CAMPO	     := {}
private  MASCARA     := {}
private  CABECALHO   := {}
private  TAMANHO     := {}
private  BESCAPE     := {|| STATUS = "C"  }
private  COR            := W_COR_002
private  TITULO      := " Pedidos Canceladas "
private  LININI      := 03
private  LINFIM      := 20
private  COLINI      := 02
private  COLFIM      := 77
private  BLOCK_DISP  := {|| .T. }
private  CAB_TITULO  := nil
private  BORDA	     := 1

private  TECLA	     := nil
private  TABELA      := nil

aadd( CAMPO , "NUMERO"                  )
aadd( CAMPO , "GUERRA"                  )
aadd( CAMPO , "DT_EMISSAO"              )
aadd( CAMPO , "CODVENC"                 )
aadd( CAMPO , "TIPOVENDA"               )
aadd( CAMPO , "QTDPARC"                 )
aadd( CAMPO , "QTDREC"                  )
aadd( CAMPO , "VALOR"                   )

aadd( MASCARA , "@!"                    )
aadd( MASCARA , "@!"                    )
aadd( MASCARA , "@!"                    )
aadd( MASCARA , "@!"                    )
aadd( MASCARA , "@!"                    )
aadd( MASCARA , "@!"                    )
aadd( MASCARA , "@!"                    )
aadd( MASCARA , "@E 999,999,999.99"     )

aadd( CABECALHO , "Pedido"              )
aadd( CABECALHO , "Cliente"             )
aadd( CABECALHO , "Emiss„o"             )
aadd( CABECALHO , "Venc."               )
aadd( CABECALHO , "Venda"               )
aadd( CABECALHO , "Emit."               )
aadd( CABECALHO , "Receb"               )
aadd( CABECALHO , "Valor"               )

aadd( TAMANHO , 12     )
aadd( TAMANHO , 10     )
aadd( TAMANHO , 09     )
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

select VEN030
VEN030->( dbsetorder(2) )
VEN030->( dbseek("C") )

VEN030->( dbsetrelation( "VEN001", {|| VEN030->CODCLI }, "VEN030->CODCLI" ) )
setcolor(W_COR_002)

Stedite1500()

select VEN030
VEN030->( dbsetorder(2) )

TABELA := tabelanew( CAMPO         , ;
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

   W_TEL0012 := savescreen(,,,,)

   do case
      case TEC == 28 ; help('SR1500')
      case TEC == 27 ; return 0

      case TEC == 13   && consulta - enter
           if VEN030->(!eof())
              Seditae1500('a')
              restscreen(,,,,W_TEL0012)
           end
           keyboard chr(1)
           select VEN030
           VEN030->( dbsetorder(2) )
           VEN030->( dbseek("C") )
           TABELA:refreshall()

      case TEC = -4   &&  exclusao f5
           if VEN030->(!eof())
               if pergunta("Confirma exclus„o da Pedido (S/N) ?")
                  if SDel_CDuplicata(VEN030->NUMERO)
                     while VEN030->( ! rlock() ); end
                     VEN030->( dbdelete() )
                     VEN030->( dbunlock() )
                     VEN030->( dbskip()   )
                     select VEN030
                     VEN030->( dbsetorder(2) )
                     VEN030->( dbseek("C") )
                     TABELA:refreshall()
		  end
	       end
           end

      case TEC == -5
         if VEN030->( ! eof() )
            Sbusca_Cnf()
	 end
          restscreen(,,,,W_TEL0012)
          select VEN030
          VEN030->( dbsetorder(2) )
          VEN030->( dbseek("C" + S_NUMERO)  )
	  TABELA:refreshall()

      case TEC = K_ESC
	   CONTINUA := .F.

   end

   select VEN030
   VEN030->( dbsetorder(2) )

enddo

close data

return

************************************
function Seditae1500(FLAG)
************************************
local dt_sai

setcursor(1)

Stelae1500()

@ 04,26 say    VEN030->NUMERO

S_NUMERO     := VEN030->NUMERO
X_CODCLI     := VEN030->CODCLI
S_TIPOVENDA  := VEN030->TIPOVENDA
S_FORMAPAG   := VEN030->FORMAPAG
S_CODVENC    := VEN030->CODVENC
S_QTDPARC    := VEN030->QTDPARC
S_DT_EMISSAO := VEN030->DT_EMISSAO
S_VALORNF    := VEN030->VALOR
S_ICMS       := VEN030->ICMS

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
@ 16,26 say S_ICMS        picture "@E 999,999,999.99"

read
SEdita_Duplicatas( S_NUMERO )

setcursor(0)

return nil

/*
-------------------------------------------------------------------------------
Procedimento .: STEDITe1500
Objetivo .....: Menu rapido
-------------------------------------------------------------------------------
*/
procedure Stedite1500()
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
Procedimento .: STELAe1500
Objetivo .....: Menu rapido
-------------------------------------------------------------------------------
*/
procedure Stelae1500()

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
Function SEdita_Duplicatas( P_NUMERO )

local  CAMPO	   := {}
local  MASCARA	   := {}
local  CABECALHO   := {}
local  TAMANHO	   := {}
local  BESCAPE     := {|| SR1000->DUPLICATA = P_NUMERO }
local  COR         := W_COR_002
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

setcolor(W_COR_002)

select SR1000

SR1000->( dbsetorder(1) )
SR1000->( dbseek( P_NUMERO ))

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
      case TEC = -5  && busca direta f6
      case TEC = K_ESC
	   CONTINUA := .F.
   end
   SELECT SR1000
enddo

return WRET
/*
-------------------------------------------------------------------------------
Procedimento .: SDEL_CDUPLICATAS
Objetivo .....:
-------------------------------------------------------------------------------
*/
Function SDel_CDuplicatas( P_NUMERO )
local WRET := .T.

SR1000->(dbsetorder(2))
if !(SR1000->(dbseek ("C"+P_NUMERO) ))
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
Procedimento .: busca_Cnf
Objetivo .....: BUSCA DIRETA
-------------------------------------------------------------------------------
*/
procedure Sbusca_Cnf()
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

VEN030->( dbseek("C" + S_NUMERO), .T. )

S_NUMERO := VEN030->NUMERO

restscreen(14,29,17,46,TB)

setcursor(0)

return

