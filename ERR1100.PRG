/*

   CONTAS A RECEBER
   ERR1100.PRG - Relatorio de Duplicata Recebidas

*/

#include "inkey.ch"

telanum('ERR1100','ERR1100')

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


private W_TITULO := 'Duplicatas Recebidas'
WRESP_IMP := 'I'
W_IMPARQ  := space(12)


//
// Variaveis
//

X_DT_INI     := ctod('  /  /  ')
X_DT_FIM     := ctod('  /  /  ')
W_QT_DIA     := 0
W_QT_PER     := 0
W_VL_PER     := 0.00
W_VL_TOT     := 0.00
W_VL_JUR_PER := 0.00
W_PAG        := 0
W_LIN        := 0

W_RAZAO      := space(40)
W_CODCLI     := space(05)

W_TELA := savescreen(,,,,)

if par_periodo()
   if dh_imprime()
      if WRESP_IMP = 'A'
         ESTREPO->( grava( WIMP_ARQ, date(), time(), W_TITULO, 80) )
      end
      ERR1100proc()
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
function ERR1100proc()

local WRET := .T.

   mensimp("Gerando Relatorio. Aguarde...")

   ER1000->(dbsetorder(4))
   Set Softseek on
   if !(ER1000-> (dbseek("R"+dtos(X_DT_INI)),.T.) )
       @ prow()+2,20 say '---Nao existe Duplicatas para o periodo--'
       WRET := .F.
       return WRET
   end

do while ( ER1000->(!eof())            ) .and. ;
         ( ER1000->STATUS   = "R"      ) .and. ;
         ( ER1000->DT_PAG <= X_DT_FIM )

         if prow() > 55
            @ prow()+1, 01 say ' '
            ERR1000C1(W_TITULO,W_PAG)
            ERR1000C2()
         end

         W_QT_DIA   := 0.00
         W_PAG      := W_PAG + 1

         ERR1100c1(W_TITULO,W_PAG)
         ERR1100C2()

         do while ( ER1000->(!eof())             ) .and. ;
                  ( ER1000->STATUS  = "R"        ) .and. ;
                  ( ER1000->DT_PAG <= X_DT_FIM   )
                  ERR1100det()
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
procedure ERR1100C1(P_TITPROC,P_PAG)

    
    @ 00      , 00 say LINHA80
    @ prow()+1, 00 say '   TENAX ACOS ESPECIAIS'
    @ prow()+1, 35 say 'Data: ' + dtoc(date())
    @ prow()  , 53 say 'Hora: '
    @ prow()  , 59 say (Time())
    @ prow()  , 69 say 'Pag.: ' + strzero(P_PAG,2)
    @ prow()+1, 00 say LINHA80

    @ prow()+1, int ((( 80-len(alltrim(P_TITPROC)) )/2)) say P_TITPROC
    @ prow()  , 51 say 'Periodo.:' +  dtoc( X_DT_INI )
    @ prow()  , 68 say ' a '
    @ prow()  , 71 say dtoc( X_DT_FIM )

return

/*
-----------------------------------------------------------------------------
                      Procedimento ERR1100DET - Linha Detalhe
-----------------------------------------------------------------------------
*/
procedure ERR1100DET()

    X_CODCLI := replicate ('*',05)
    X_GUERRA := replicate ('*',40)

    VEN050->(dbsetorder(1))
    if VEN050->(dbseek(ER1000->DUPLICATA))
       X_CODCLI := VEN001->CODCLI
       VEN001->(dbsetorder(1))
       if VEN001->(dbseek(VEN050->CODCLI))
          X_GUERRA := VEN001->GUERRA
       end
    end

    if prow() > 55
       @ prow()+1, 01 say ' '
       ERR1100C1(W_TITULO,W_PAG)
       ERR1100C2()
    end

    @ prow()+1, 00 say ER1000->DT_PAG

    @ prow()  , 09 say ER1000->DUPLICATA

    if ER1000->SEQUENCIA = " "
       @ prow()  , 17 say ER1000->SEQUENCIA
    else
       @ prow()  , 17 say "/" + ER1000->SEQUENCIA
    end

    @ prow()  , 20 say VEN001->GUERRA
    @ prow()  , PCOL()+1 say VEN050->TIPOVENDA
    @ prow()  , PCOL()+1 say VEN050->FORMAPAG
    @ prow()  , PCOL()+1 say ER1000->ACORDO
    @ prow()  , PCOL()+2 say ER1000->FLG_ABATI PICT '@!'
    @ prow()  , PCOL()+2 say ER1000->FLG_TXADM
    @ prow()  , PCOL()+4 say ER1000->JUROS     picture "@E 999,999.99"
    @ prow()  , PCOL()+3 say ER1000->VALOR     picture "@E 999,999,999.99"

    W_QT_PER     := W_QT_PER + 1
    W_QT_DIA     := W_QT_DIA + 1

    W_VL_JUR_PER := W_VL_JUR_PER + ER1000->JUROS
    W_VL_PER     := W_VL_PER + ER1000->VALOR

    W_VL_TOT     := W_VL_TOT + ER1000->VALOR + ER1000->JUROS +ER1000->TXADM - ER1000->ABATIMENTO

    inkey()
    if lastkey()=K_ESC
       @ prow()+2,20 say '---Impressao interrompida pelo usuario---'
       return
    end

return


/*
-----------------------------------------------------------------------------
                      Procedimento  ERR1100Cab2 - Cabecalho 2
-----------------------------------------------------------------------------
*/
procedure ERR1100C2()


    @ prow()+2, 00 say 'Dt.Vec.'
    @ prow()  , 09 say 'Duplicata'
    @ prow()  , 20 say 'Cliente'
    @ prow()  , 36 say 'TV'
    @ prow()  , 39 say 'FP'
    @ prow()  , PCOL()+1 say 'AC'
    @ prow()  , PCOL()+1 say 'Ab'
    @ prow()  , PCOL()+1 say 'DC'
    @ prow()  , PCOL()+7 say 'Juros'
    @ prow()  , PCOL()+9 say 'Valor'

    @ prow()+1, 00 say replicate('-',08)
    @ prow()  , 09 say replicate('-',10)
    @ prow()  , 20 say replicate('-',15)
    @ prow()  , 36 say replicate('-',02)
    @ prow()  , 39 say replicate('-',02)
    @ prow()  , PCOL()+1 say replicate('-',02)
    @ prow()  , PCOL()+1 say replicate('-',02)
    @ prow()  , PCOL()+1 say replicate('-',02)
    @ prow()  , PCOL()+3 say replicate('-',10)
    @ prow()  , PCOL()+2 say replicate('-',15)

return


/*
-----------------------------------------------------------------------------
                      Procedimento  ERR1100R1 - Rodape    1
-----------------------------------------------------------------------------
*/
procedure ERR1100R1()

    @ prow()+1, 00 say linha80
    @ prow()+2, 00 say linha80
    @ prow()+1, 00 say ' Total do Periodo.: '
    @ prow()  , 23 say W_QT_PER  picture "999"
    @ prow()  , 27 say 'Duplicata(s) '
    @ prow()  , 52 say W_VL_JUR_PER  picture "@E 99999,999.99"
    @ prow()  , 66 say W_VL_PER      picture "@E 999,999,999.99"
    @ prow()+1, 00 say linha80

return

/*
-----------------------------------------------------------------------------
                      Procedimento  ERR1100R2 - Rodape    2
-----------------------------------------------------------------------------
*/
procedure ERR1100R2()

    @ prow()+2, 00 say linha80
    @ prow()+1, 00 say ' Total Juros+Valor: '
    @ prow()  , 23 say W_QT_DIA  picture "999"
    @ prow()  , 27 say 'Duplicata(s) '
    @ prow()  , 57 say W_VL_TOT      picture "@E 99999,999.99"
    @ prow()+1, 00 say linha80

return
