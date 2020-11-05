
/*

   CONTAS A RECEBER
   ERR1700.PRG - Relatorio de Duplicata Recebidas

*/

#include "inkey.ch"

telanum('ERR1700','ERR1700')

//
// Arquivos
//

abrir("ESTREPO")
abrir("ER1000")
abrir("VEN001")
abrir("VEN011")
abrir("VEN050")

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
      ERR1700proc()
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
function ERR1700proc()

local WRET := .T.

   mensimp("Gerando Relatorio. Aguarde...")

   ER1000->(dbsetorder(5))
   ER1000->(dbgotop())
do while ( ER1000->(!eof())            )

         if prow() > 55
            @ prow()+1, 01 say ' '
            ERR1700c(W_TITULO,W_PAG)
            ERR1000C2()
         end

         W_QT_DIA   := 0.00
         W_PAG      := W_PAG + 1

         ERR1700c(W_TITULO,W_PAG)
         ERR1100C2()

         do while ( ER1000->(!eof())             )
                if ER1000->codcli = x_codcli
                  ERR1100det()
                end
                  ER1000->(dbskip())

         enddo

         ERR1100R1()
enddo

ERR1100R2()

return

/*
-----------------------------------------------------------------------------
                      Procedimento CABECALHO GERAL
-----------------------------------------------------------------------------
*/
procedure ERR1700c(P_TITPROC,P_PAG)

    
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

