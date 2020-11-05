/*

   CONTAS A RECEBER
   CRR1500.PRG - Relatorio de Nota Fiscal

*/

#include "inkey.ch"

telanum('CRR1500','CRR1500')

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

private linha78 := replicate('-',78)
private W_TITULO := 'Nota Fiscal'

WRESP_IMP    := 'I'
W_IMPARQ     := space(12)
X_DT_INI     := ctod('  /  /  ')
X_DT_FIM     := ctod('  /  /  ')
W_DT_ATUAL   := ctod('  /  /  ')
W_QT_DIA     := 0.00
W_QT_TOT     := 0.00
W_VL_DIA     := 0.00
W_VL_TOT     := 0.00
W_PAG        := 0.00
W_LIN        := 0.00
X_NOTAFISCAL := space(10)
X_CODCLI     := space(15)

W_TELA := savescreen(,,,,)

if p_periodo()
   if dh_imprime()
      if WRESP_IMP = 'A'
         ESTREPO->( grava( WIMP_ARQ, date(), time(), W_TITULO, 80) )
      end
      crr1500proc()
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
function crr1500proc()

local WRET := .T.

   mensimp("Gerando Relatorio. Aguarde...")

   VEN012->(dbsetorder(3))
   Set Softseek on
   VEN012->( dbseek(dtos(X_DT_INI)+X_NOTAFISCAL),.T.)

   W_VL_TOT := 0.00

   do while ( VEN012->(!eof()) ) .and. ;
            ( VEN012->DT_EMISSAO <= X_DT_FIM )

      W_DT_ATUAL := VEN012->DT_EMISSAO
      W_QT_DIA   := 0.00
      W_VL_DIA   := 0.00
      W_PAG      := W_PAG + 1

      crr1500C1(W_TITULO,W_PAG)
      crr1500C2()

      do While VEN012->( ! eof() ) .and. ;
         VEN012->DT_EMISSAO = W_DT_ATUAL
         crr1500det()
         VEN012->(dbskip())
      enddo

      crr1500R1()
      W_VL_TOT := W_VL_TOT

   enddo

   crr1500R2()

return


/*
-----------------------------------------------------------------------------
                      Parametro de Data Inicial / Final
-----------------------------------------------------------------------------
*/
function p_periodo()

local WRET:= .T.

WSCRDUP := savescreen(,,,,)

setcursor(1)

X_DT_INI := ctod(' /  /  ')
X_DT_FIM := ctod(' /  /  ')

@ 10,14 say 'ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿'
@ 11,14 say '³                                   ³'
@ 12,14 say '³ Periodo..:   /  /   a   /  /      ³'
@ 13,14 say '³                                   ³'
@ 14,14 say 'ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ'

@ 12,27 get X_DT_INI picture '99/99/99'
@ 12,38 get X_DT_FIM picture '99/99/99'
read
if lastkey() = K_ESC
   WRET := .F.
end
if X_DT_INI > X_DT_FIM
   mensbeep (' Parametro de Data Invalido !')
   WRET := .F.
end

if empty(X_DT_INI)
   X_DT_INI :=  ctod('01/01/01')
end
if empty(X_DT_FIM)
   X_DT_FIM :=  ctod('31/12/99')
end

@ 03,16 say X_DT_INI picture '99/99/99'
@ 03,27 say X_DT_FIM picture '99/99/99'

restscreen(,,,,WSCRDUP )

setcursor(0)

return WRET


/*
-----------------------------------------------------------------------------
                      Procedimento CABECALHO GERAL
-----------------------------------------------------------------------------
*/
procedure crr1500C1(P_TITPROC,P_PAG)
    
    @ 00      , 00 say linha78
    @ prow()+1, 00 say '   TENAX ACOS ESPECIAIS'
    @ prow()+1, 35 say 'Data: ' + dtoc(date())
    @ prow()  , 53 say 'Hora: '
    @ prow()  , 59 say (Time())
    @ prow()  , 69 say 'Pag.: ' + strzero(P_PAG,2)
    @ prow()+1, 00 say linha78

    @ prow()+1, int ((( 80-len(alltrim(P_TITPROC)) )/2)) say P_TITPROC
    @ prow()  , 49 say 'Periodo.:' +  dtoc( X_DT_INI )
    @ prow()  , 66 say ' a '
    @ prow()  , 69 say dtoc( X_DT_FIM )

return


/*
-----------------------------------------------------------------------------
                      Procedimento CRR1500DET - Linha Detalhe
-----------------------------------------------------------------------------
*/
procedure CRR1500DET()

    X_NOTAFISCAL := replicate ('*',40)
    X_CODCLI     := space(15)

    if VEN001->(dbseek(VEN012->CODCLI))
       X_CODCLI := VEN001->CODCLI
    end

    if prow() > 55
       W_PAG := W_PAG + 1
    end

    @ prow()+1, 04 say VEN012->NOTAFISCAL

    @ prow()  , 16 say VEN012->CODCLI

    @ prow()  , 22 say VEN001->GUERRA

    @ prow()  , 38 say VEN012->DT_EMISSAO

    @ prow()  , 48 say VEN012->VALOR       picture "@E 999,999,999.99"

    @ prow()  , 66 say VEN012->TIPOVENDA

    @ prow()  , 74 say VEN012->STATUS

//    @ prow()+1, 04 say VEN012->ICMS


     if ( VEN012->STATUS != "C" )
        W_QT_DIA := W_QT_DIA + 1
        W_QT_TOT := W_QT_TOT + 1
        W_VL_DIA := W_VL_DIA + VEN012->VALOR
        W_VL_TOT := W_VL_TOT + VEN012->VALOR
     end

    inkey()
    if lastkey()=K_ESC
       @ prow()+2,20 say '---Impressao interrompida pelo usuario---'
       return
    end

return

/*
-----------------------------------------------------------------------------
                      Procedimento  CRR1500Cab2 - Cabecalho 2
-----------------------------------------------------------------------------
*/
procedure CRR1500C2()


    @ prow()+1, 01  say 'Data: ' + dtoc(VEN012->DT_EMISSAO)

    @ prow()+2, 04  say 'Nota Fiscal'
    @ prow()  , 16  say 'Cliente'
    @ prow()  , 38  say 'Emissao'
    @ prow()  , 48  say 'Valor'
    @ prow()  , 65  say 'T.Ven'
    @ prow()  , 72  say 'Status'
//    @ prow()+2, 04  say 'ICMS'

    @ prow()+1, 04  say '-----------'
    @ prow()  , 16  say replicate('-',15)
    @ prow()  , 38  say replicate('-',08)
    @ prow()  , 48  say replicate('-',15)
    @ prow()  , 65  say replicate('-',05)
    @ prow()  , 72  say replicate('-',06)
//    @ prow()+1, 04  say replicate('-',14)


return

/*
-----------------------------------------------------------------------------
                      Procedimento  crr1500R1 - Rodape    1
-----------------------------------------------------------------------------
*/
procedure crr1500R1()

    @ prow()+2, 00 say linha78
    @ prow()+1, 00 say ' Total do Dia     : '
    @ prow()  , 23 say W_QT_DIA  picture "999"
    @ prow()  , 27 say 'Nota(s) Fiscal(is):'
    @ prow()  , 47 say W_VL_DIA  picture "@E 9999,999,999.99"
    @ prow()+1, 00 say linha78

return

/*
-----------------------------------------------------------------------------
                      Procedimento  crr1500R2 - Rodape    2
-----------------------------------------------------------------------------
*/
procedure crr1500R2()

    @ prow()+1, 00 say linha78
    @ prow()+1, 00 say ' Total do Periodo : '
    @ prow()  , 23 say W_QT_TOT  picture "999"
    @ prow()  , 27 say 'Nota(s) Fiscal(is): '
    @ prow()  , 47 say W_VL_TOT  picture "9999,999,999.99"
    @ prow()+1, 00 say linha78

return

