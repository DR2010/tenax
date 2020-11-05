/*

   CONTAS A RECEBER
   SRR1500.PRG - Relatorio de Nota Fiscal

*/

#include "inkey.ch"

telanum('SRR1500','SRR1500')

//
// Arquivos
//

abrir("ESTREPO")
abrir("SR1000")
abrir("VEN012")
abrir("VEN001")
abrir("VEN030")

//
// variaveis para controle de impressoes geradas para arquivo
//

private linha78 := replicate('-',78)
private W_TITULO := 'Pedido C/R'

WRESP_IMP     := 'I'
W_IMPARQ      := space(12)
S_DT_INI      := ctod('  /  /  ')
S_DT_FIM      := ctod('  /  /  ')
W_DT_ATUAL    := ctod('  /  /  ')
W_QT_DIA      := 0.00
W_QT_TOT      := 0.00
W_VL_DIA      := 0.00
W_VL_TOT      := 0.00
* W_ICMS_DIA := 0.00
W_ICMS_TOT := 0.00
W_PAG         := 0.00
W_LIN         := 0.00
S_NUMERO      := space(05)
X_CODCLI      := space(15)

W_TELA := savescreen(,,,,)

if SP_periodo()
   if dh_imprime()
      if WRESP_IMP = 'A'
         ESTREPO->( grava( WIMP_ARQ, date(), time(), W_TITULO, 80) )
      end
      SRr1500proc()
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
function SRr1500proc()

local WRET := .T.

   mensimp("Gerando Relatorio. Aguarde...")

   VEN030->(dbsetorder(3))
   Set Softseek on
   VEN030->( dbseek(dtos(S_DT_INI)+S_NUMERO),.T.)

   W_VL_TOT := 0.00

   do while ( VEN030->(!eof()) ) .and. ;
            ( VEN030->DT_EMISSAO <= S_DT_FIM )

      W_DT_ATUAL    := VEN030->DT_EMISSAO
      W_QT_DIA      := 0.00
      W_VL_DIA      := 0.00
    *  W_ICMS_DIA := 0.00
      W_ICMS_TOT := 0.00
      W_PAG         := W_PAG + 1

      SRr1500C1(W_TITULO,W_PAG)
      SRr1500C2()

      do While VEN030->( ! eof() ) .and. ;
         VEN030->DT_EMISSAO = W_DT_ATUAL
         SRr1500det()
         VEN030->(dbskip())
      enddo

      SRr1500R1()
      W_VL_TOT := W_VL_TOT

   enddo

   SRr1500R2()

return


/*
-----------------------------------------------------------------------------
                      Parametro de Data Inicial / Final
-----------------------------------------------------------------------------
*/
function SP_periodo()

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
procedure SRr1500C1(P_TITPROC,P_PAG)
    
    @ 00      , 00 say linha78
    @ prow()+1, 00 say '   TENAX ACOS ESPECIAIS'
    @ prow()+1, 35 say 'Data: ' + dtoc(date())
    @ prow()  , 53 say 'Hora: '
    @ prow()  , 59 say (Time())
    @ prow()  , 69 say 'Pag.: ' + strzero(P_PAG,2)
    @ prow()+1, 00 say linha78

    @ prow()+1, int ((( 80-len(alltrim(P_TITPROC)) )/2)) say P_TITPROC
    @ prow()  , 49 say 'Periodo.:' +  dtoc( S_DT_INI )
    @ prow()  , 66 say ' a '
    @ prow()  , 69 say dtoc( S_DT_FIM )

return


/*
-----------------------------------------------------------------------------
                      Procedimento SRR1500DET - Linha Detalhe
-----------------------------------------------------------------------------
*/
procedure SRR1500DET()

    S_NUMERO := replicate ('*',40)
    X_CODCLI     := space(15)

    if VEN001->(dbseek(VEN030->CODCLI))
       X_CODCLI := VEN001->CODCLI
    end

    if prow() > 55
       W_PAG := W_PAG + 1
    end

    @ prow()+1, 04       say VEN030->NUMERO
    @ prow()  , 14       say VEN030->CODCLI
    @ prow()  , 21       say VEN001->GUERRA
    @ prow()  , PCOL()+3 say VEN030->DT_EMISSAO
    @ prow()  , PCOL()+2 say VEN030->TIPOVENDA
    @ prow()  , PCOL()+2 say VEN030->FORMAPAG
    @ prow()  , PCOL()+3 say VEN030->VALOR       picture "@E 999,999,999.99"
    @ prow()  , PCOL()+3 say VEN030->STATUS

    if ( VEN030->STATUS != "C" )
       W_QT_DIA      := W_QT_DIA      + 1
       W_QT_TOT      := W_QT_TOT      + 1
       W_VL_DIA      := W_VL_DIA      + VEN030->VALOR
       W_VL_TOT      := W_VL_TOT      + VEN030->VALOR
*       W_ICMS_DIA := W_ICMS_DIA + VEN012->ICMS
*       W_ICMS_TOT := W_ICMS_TOT + VEN012->ICMS
    end

    inkey()
    if lastkey()=K_ESC
       @ prow()+2,20 say '---Impressao interrompida pelo usuario---'
       return
    end

return

/*
-----------------------------------------------------------------------------
                      Procedimento  SRR1500Cab2 - Cabecalho 2
-----------------------------------------------------------------------------
*/
procedure SRR1500C2()


    @ prow()+1, 01  say 'Data: ' + dtoc(VEN030->DT_EMISSAO)

    @ prow()+2, 04  say 'Pedido'
    @ prow()  , PCOL()+2  say 'Cliente'
    @ prow()  , PCOL()+19  say 'Emissao'
    @ prow()  , PCOL()+4  say 'TV'
    @ prow()  , PCOL()+2  say 'FP'
    @ prow()  , PCOL()+2  say 'Valor'
    @ prow()  , PCOL()+12  say 'St'

    @ prow()+1, 04  say '------'
    @ prow()  , PCOL()+2  say replicate('-',15)
    @ prow()  , PCOL()+12 say replicate('-',08)
    @ prow()  , PCOL()+2  say replicate('-',02)
    @ prow()  , PCOL()+2  say replicate('-',02)
    @ prow()  , PCOL()+2  say replicate('-',15)
    @ prow()  , PCOL()+2  say replicate('-',02)


return

/*
-----------------------------------------------------------------------------
                      Procedimento  SRr1500R1 - Rodape    1
-----------------------------------------------------------------------------
*/
procedure SRr1500R1()

    @ prow()+2, 00 say linha78
    @ prow()+1, 00 say ' Total do Dia     : '
    @ prow()  , 23 say W_QT_DIA  picture "999"
    @ prow()  , 27 say 'Pedido(s)         : '
    @ prow()  , 47 say W_VL_DIA  picture "@E 9999,999,999.99"
*    @ prow()+2, 27 say 'Tot. ICMS.(DIA)...: '
*    @ prow()  , 47 say W_ICMS_DIA          picture "@E 9999,999,999.99"
    @ prow()+1, 00 say linha78

return

/*
-----------------------------------------------------------------------------
                      Procedimento  SRr1500R2 - Rodape    2
-----------------------------------------------------------------------------
*/
procedure SRr1500R2()

    @ prow()+1, 00 say linha78
    @ prow()+1, 00 say ' Total do Periodo : '
    @ prow()  , 23 say W_QT_TOT  picture "999"
    @ prow()  , 27 say 'Pedido(s)         : '
    @ prow()  , 47 say W_VL_TOT  picture "9999,999,999.99"
*    @ prow()+2, 27 say 'Tot. ICMS.(GERAL).: '
*    @ prow()  , 47 say W_ICMS_TOT         picture "9999,999,999.99"
    @ prow()+1, 00 say linha78

return

