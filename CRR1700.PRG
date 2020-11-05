
/*

   CONTAS A RECEBER
   CRR1700.PRG - Relatorio de Duplicata Recebidas

*/

#include "inkey.ch"

telanum('CRR1700','CRR1700')

//
// Arquivos
//

abrir("ESTREPO")
abrir("CR1000")
abrir("VEN001")
abrir("VEN011")
abrir("VEN012")

//
// variaveis para controle de impressoes geradas para arquivo
//

private linha80 := replicate('-',80)


private W_TITULO := 'Rel.Extr. de Cliente :'
WRESP_IMP := 'I'
W_IMPARQ  := space(12)


//
// Variaveis
//

W_QT_DIA     := 0
W_QT_PER     := 0
W_VL_PER     := 0.00
W_VL_TOT     := 0.00
W_VL_JUR_PER := 0.00
W_PAG        := 0
W_LIN        := 0

W_RAZAO      := space(40)
X_CODCLI     := space(05)

W_TELA := savescreen(,,,,)

if par_cliente()
   if dh_imprime()
      if WRESP_IMP = 'A'
         ESTREPO->( grava( WIMP_ARQ, date(), time(), W_TITULO, 80) )
      end
      crr1700proc()
      @ 00,00 say ''
      dh_impoff()
   end
end

return

/*
--------------------------------------------------------------------------
                  Procedimento principal
--------------------------------------------------------------------------
*/
function crr1700proc()

local WRET := .T.

   mensimp("Gerando Relatorio. Aguarde...")

   CR1000->(dbsetorder(5))
   CR1000->(dbgotop())
do while ( CR1000->(!eof())            )

         if prow() > 55
            @ prow()+1, 01 say ' '
            crr1700c(W_TITULO,W_PAG)
            crr1000C2()
         end

         W_QT_DIA   := 0.00
         W_PAG      := W_PAG + 1

         crr1700c(W_TITULO,W_PAG)
         crr1100C2()

         do while ( CR1000->(!eof())             )
                if cr1000->codcli = x_codcli
                  crr1100det()
                end
                  CR1000->(dbskip())

         enddo

         crr1100R1()
enddo

crr1100R2()

return

/*
-----------------------------------------------------------------------------
                      Parametro de Data Inicial / Final
-----------------------------------------------------------------------------
*/
function par_cliente()

local WRET:= .T.

WSCRDUP := savescreen(,,,,)

setcursor(1)

X_CODCLI := SPACE(5)

@ 10,14 say 'ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿'
@ 11,14 say '³                                   ³'
@ 12,14 say '³ Cliente..:                        ³'
@ 13,14 say '³                                   ³'
@ 14,14 say 'ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ'

@ 12,27 get X_CODCLI picture '@!' VALID TES_CODCLI(X_CODCLI,12,27,12)
read

if lastkey() = K_ESC
   WRET := .F.
end
restscreen(,,,,WSCRDUP )

setcursor(0)

return WRET

/*
-----------------------------------------------------------------------------
                      Procedimento CABECALHO GERAL
-----------------------------------------------------------------------------
*/
procedure crr1700c(P_TITPROC,P_PAG)

    
    @ 00      , 00 say LINHA80
    @ prow()+1, 00 say '   TENAX ACOS ESPECIAIS'
    @ prow()+1, 35 say 'Data: ' + dtoc(date())
    @ prow()  , 53 say 'Hora: '
    @ prow()  , 59 say (Time())
    @ prow()  , 69 say 'Pag.: ' + strzero(P_PAG,2)
    @ prow()+1, 00 say LINHA80

    @ prow()+1, int ((( 80-len(alltrim(P_TITPROC)) )/2)) say P_TITPROC
    @ prow()  , 51 say 'Cliente.:' +  X_CODCLI

return

