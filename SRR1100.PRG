/*

   CONTAS A RECEBER
   SRR1100.PRG - Relatorio de Duplicata Recebidas

*/

#include "inkey.ch"

telanum('SRR1100','SRR1100')

//
// Arquivos
//

abrir("ESTREPO")
abrir("SR1000")
abrir("VEN001")
abrir("VEN011")
abrir("VEN012")
abrir("VEN030")

//
// variaveis para controle de impressoes geradas para arquivo
//

private linha80 := replicate('-',80)


private W_TITULO := 'Duplicatas Recebidas C/R'
WRESP_IMP := 'I'
W_IMPARQ  := space(12)


//
// Variaveis
//

S_DT_INI     := ctod('  /  /  ')
S_DT_FIM     := ctod('  /  /  ')
W_QT_DIA     := 0
W_QT_PER     := 0
W_VL_DIA     := 0.00
W_VL_PER     := 0.00
W_VL_JUR_DIA := 0.00
W_VL_JUR_PER := 0.00
W_PAG        := 0
W_LIN        := 0

W_RAZAO      := space(40)
W_CODCLI     := space(05)

W_TELA := savescreen(,,,,)

if SPAR_periodo()
   if dh_imprime()
      if WRESP_IMP = 'A'
         ESTREPO->( grava( WIMP_ARQ, date(), time(), W_TITULO, 80) )
      end
      SRr1100proc()
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
function SRr1100proc()

local WRET := .T.

   mensimp("Gerando Relatorio. Aguarde...")

   SR1000->(dbsetorder(4))
   Set Softseek on
   if !(SR1000-> (dbseek("R"+dtos(S_DT_INI)),.T.) )
       @ prow()+2,20 say '---Nao existe Duplicatas para o periodo--'
       WRET := .F.
       return WRET
   end

do while ( SR1000->(!eof())            ) .and. ;
         ( SR1000->STATUS   = "R"      ) .and. ;
         ( SR1000->DT_PAG <= S_DT_FIM )

         W_QT_DIA   := 0.00
         W_VL_DIA   := 0.00
         W_PAG      := W_PAG + 1

         SRr1100c1(W_TITULO,W_PAG)
         SRr1100C2()

         do while ( SR1000->(!eof())             ) .and. ;
                  ( SR1000->STATUS  = "R"        ) .and. ;
                  ( SR1000->DT_PAG <= S_DT_FIM   )
                  SRr1100det()
                  SR1000->(dbskip())
         enddo

         SRr1100R1()
enddo

SRr1100R2()

return

/*
-----------------------------------------------------------------------------
                      Parametro de Data Inicial / Final
-----------------------------------------------------------------------------
*/
function SPAR_periodo()

local WRET:= .T.

WSCRDUP := savescreen(,,,,)

setcursor(1)

S_DT_INI := ctod(' /  /  ')
S_DT_FIM := ctod(' /  /  ')

@ 10,14 say 'ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿'
@ 11,14 say '³                                   ³'
@ 12,14 say '³ Periodo..:   /  /   a   /  /      ³'
@ 13,14 say '³                                   ³'
@ 14,14 say 'ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ'

@ 12,27 get S_DT_INI picture '99/99/99'
@ 12,38 get S_DT_FIM picture '99/99/99'
read

if lastkey() = K_ESC
   WRET := .F.
end
if S_DT_INI > S_DT_FIM
   mensbeep (' Parametro de Data Invalido !')
   WRET := .F.
end

if empty(S_DT_INI)
   S_DT_INI :=  ctod('01/01/01')
end
if empty(S_DT_FIM)
   S_DT_FIM :=  ctod('31/12/99')
end

@ 03,16 say S_DT_INI picture '99/99/99'
@ 03,27 say S_DT_FIM picture '99/99/99'

restscreen(,,,,WSCRDUP )

setcursor(0)

return WRET

/*
-----------------------------------------------------------------------------
                      Procedimento CABECALHO GERAL
-----------------------------------------------------------------------------
*/
procedure SRr1100C1(P_TITPROC,P_PAG)

    
    @ 00      , 00 say LINHA80
    @ prow()+1, 00 say '   TENAX ACOS ESPECIAIS'
    @ prow()+1, 35 say 'Data: ' + dtoc(date())
    @ prow()  , 53 say 'Hora: '
    @ prow()  , 59 say (Time())
    @ prow()  , 69 say 'Pag.: ' + strzero(P_PAG,2)
    @ prow()+1, 00 say LINHA80

    @ prow()+1, int ((( 80-len(alltrim(P_TITPROC)) )/2)) say P_TITPROC
    @ prow()  , 51 say 'Periodo.:' +  dtoc( S_DT_INI )
    @ prow()  , 68 say ' a '
    @ prow()  , 71 say dtoc( S_DT_FIM )

return

/*
-----------------------------------------------------------------------------
                      Procedimento SRR1100DET - Linha Detalhe
-----------------------------------------------------------------------------
*/
procedure SRR1100DET()

    X_CODCLI := replicate ('*',05)
    S_GUERRA := replicate ('*',40)

    VEN030->(dbsetorder(1))
    if VEN030->(dbseek(SR1000->DUPLICATA))
       X_CODCLI := VEN001->CODCLI
       VEN001->(dbsetorder(1))
       if VEN001->(dbseek(VEN030->CODCLI))
          S_GUERRA := VEN001->GUERRA
       end
    end

    if prow() > 55
       W_PAG := W_PAG + 1
       SRr1100C1(W_TITULO,W_PAG)
       SRr1100C2()
    end

    @ prow()+1, 01 say SR1000->DT_PAG

    @ prow()  , 10 say SR1000->DUPLICATA

    if SR1000->SEQUENCIA = " "
       @ prow()  , 18 say SR1000->SEQUENCIA
    else
       @ prow()  , 18 say "/" + SR1000->SEQUENCIA
    end

    @ prow()  , 22 say VEN001->GUERRA
    @ prow()  , 39 say VEN030->FORMAPAG
    @ prow()  , 43 say VEN030->TIPOVENDA
    @ prow()  , 47 say SR1000->QTD_CH
    @ prow()  , 54 say SR1000->JUROS     picture "@E 999,999.99"
    @ prow()  , 66 say SR1000->VALOR     picture "@E 999,999,999.99"

    W_QT_DIA     := W_QT_DIA + 1
    W_QT_PER     := W_QT_PER + 1

    W_VL_JUR_DIA := W_VL_JUR_DIA + SR1000->JUROS
    W_VL_JUR_PER := W_VL_JUR_PER + SR1000->JUROS

    W_VL_DIA     := W_VL_DIA + SR1000->VALOR
    W_VL_PER     := W_VL_PER + SR1000->VALOR

    inkey()
    if lastkey()=K_ESC
       @ prow()+2,20 say '---Impressao interrompida pelo usuario---'
       return
    end

return


/*
-----------------------------------------------------------------------------
                      Procedimento  SRr1100Cab2 - Cabecalho 2
-----------------------------------------------------------------------------
*/
procedure SRr1100C2()


    @ prow()+1, 01 say 'Data: ' + dtoc(SR1000->DT_PAG)

    @ prow()+2, 01 say 'Dt.Pag.'

    @ prow()  , 10 say 'Duplicata'
    @ prow()  , 22 say 'Cliente'
    @ prow()  , 39 say 'F.P'
    @ prow()  , 43 say 'T.V'
    @ prow()  , 47 say 'Q.Ch'
    @ prow()  , 54 say 'Juros'
    @ prow()  , 66 say 'Valor'

    @ prow()+1, 01 say replicate('-',08)
    @ prow()  , 10 say replicate('-',10)
    @ prow()  , 22 say replicate('-',15)
    @ prow()  , 39 say replicate('-',03)
    @ prow()  , 43 say replicate('-',03)
    @ prow()  , 47 say replicate('-',04)
    @ prow()  , 54 say replicate('-',10)
    @ prow()  , 66 say replicate('-',15)

return


/*
-----------------------------------------------------------------------------
                      Procedimento  SRr1100R1 - Rodape    1
-----------------------------------------------------------------------------
*/
procedure SRr1100R1()

    @ prow()+2, 00 say LINHA80
    @ prow()+1, 00 say ' Total do Dia.....: '
    @ prow()  , 23 say W_QT_DIA  picture "999"
    @ prow()  , 27 say 'Duplicata(s) '
    @ prow()  , 52 say W_VL_JUR_DIA  picture "@E 99999,999.99"
    @ prow()  , 66 say W_VL_DIA      picture "@E 999,999,999.99"
    @ prow()+1, 00 say LINHA80
return

/*
-----------------------------------------------------------------------------
                      Procedimento  SRr1100R2 - Rodape    2
-----------------------------------------------------------------------------
*/
procedure SRr1100R2()

    @ prow()+1, 00 say LINHA80
    @ prow()+1, 00 say ' Total do Periodo.: '

    @ prow()  , 23 say W_QT_PER  picture "999"
    @ prow()  , 27 say 'Duplicata(s) '
    @ prow()  , 52 say W_VL_JUR_PER  picture "@E 99999,999.99"
    @ prow()  , 66 say W_VL_PER      picture "@E 999,999,999.99"
    @ prow()+1, 00 say LINHA80

return


