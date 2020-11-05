/*

   CONTAS A RECEBER
   CRR1000.PRG - Relatorio de Duplicata Pendentes

*/

#include "inkey.ch"

telanum('CRR1000','CRR1000')

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

private linha80  := replicate('-',80)


private W_TITULO := 'Duplicatas Pendentes'
WRESP_IMP := 'I'
W_IMPARQ  := space(12)


//
// Variaveis
//

X_DT_INI     := ctod('  /  /  ')
X_DT_FIM     := ctod('  /  /  ')
W_DT_ATUAL   := ctod('  /  /  ')
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

if pa_periodo()
   if dh_imprime()
      if WRESP_IMP = 'A'
         ESTREPO->( grava( WIMP_ARQ, date(), time(), W_TITULO, 80) )
      end
      crr1000proc()
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
function crr1000proc()

local WRET := .T.

mensimp("Gerando Relatorio. Aguarde...")

CR1000->(dbsetorder(3))
Set Softseek on
if !(CR1000-> (dbseek("P" + dtos(X_DT_INI)),.T.) )
    @ prow()+2,20 say '---Nao existe Duplicatas para o periodo--'
    WRET := .F.
    return WRET
end

do while ( CR1000->(!eof())            ) .and. ;
         ( CR1000->STATUS   = "P"      ) .and. ;
         ( CR1000->DT_VENC <= X_DT_FIM )

         W_DT_ATUAL := CR1000->DT_VENC
         W_QT_DIA   := 0.00
         W_VL_DIA   := 0.00
         W_PAG      := W_PAG + 1

         crr1000c1(W_TITULO,W_PAG)
         crr1000C2()

         do while ( CR1000->(!eof())              ) .and. ;
                  ( CR1000->STATUS   = "P"        ) .and. ;
                  ( CR1000->DT_VENC <= X_DT_FIM   ) .and. ;
                  ( CR1000->DT_VENC  = W_DT_ATUAL )
                  crr1000det()
                  CR1000->(dbskip())
         enddo

         crr1000R1()

enddo

crr1000R2()

return

/*
-----------------------------------------------------------------------------
                      Parametro de Data Inicial / Final
-----------------------------------------------------------------------------
*/
function pa_periodo()

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

do while .T.

   @ 12,27 get X_DT_INI picture '99/99/99'
   @ 12,38 get X_DT_FIM picture '99/99/99'
   read
   if lastkey() = K_ESC
      WRET := .F.
      exit
   end

   if X_DT_INI > X_DT_FIM
      mensbeep (' Parametro de Data Invalido !')
      WRET := .F.
      loop
   end

   if empty(X_DT_INI)
      X_DT_INI :=  ctod('01/01/01')
   end
   if empty(X_DT_FIM)
      X_DT_FIM :=  ctod('31/12/99')
   end

   @ 12,16 say X_DT_INI picture '99/99/99'
   @ 12,38 say X_DT_FIM picture '99/99/99'

   exit

enddo

restscreen(,,,,WSCRDUP )

setcursor(0)

return WRET

/*
-----------------------------------------------------------------------------
                      Procedimento CABECALHO GERAL
-----------------------------------------------------------------------------
*/
procedure crr1000C1(P_TITPROC,P_PAG)

    
    @ 00      , 00 say linha80
    @ prow()+1, 00 say '   TENAX ACOS ESPECIAIS'
    @ prow()+1, 35 say 'Data: ' + dtoc(date())
    @ prow()  , 53 say 'Hora: '
    @ prow()  , 59 say (Time())
    @ prow()  , 69 say 'Pag.: ' + strzero(P_PAG,2)
    @ prow()+1, 00 say linha80

    @ prow()+1, int ((( 80-len(alltrim(P_TITPROC)) )/2)) say P_TITPROC
    @ prow()  , 51 say 'Periodo.:' +  dtoc( X_DT_INI )
    @ prow()  , 68 say ' a '
    @ prow()  , 71 say dtoc( X_DT_FIM )

return

/*
-----------------------------------------------------------------------------
                      Procedimento CRR1000DET - Linha Detalhe
-----------------------------------------------------------------------------
*/
procedure CRR1000DET()

    X_CODCLI := replicate ('*',05)
    X_GUERRA := replicate ('*',40)

    VEN012->(dbsetorder(1))
    if VEN012->(dbseek(CR1000->DUPLICATA))
       X_CODCLI := VEN001->CODCLI
       VEN001->(dbsetorder(1))
       if VEN001->(dbseek(VEN012->CODCLI))
          X_GUERRA := VEN001->GUERRA
       end
    end

    if prow() > 55
       W_PAG := W_PAG + 1
       crr1000C1(W_TITULO,W_PAG)
       crr1000C2()
    end

    @ prow()+1, 01 say CR1000->DT_VENC

    @ prow()  , 10 say CR1000->DUPLICATA

    if CR1000->SEQUENCIA = " "
       @ prow()  , 18 say CR1000->SEQUENCIA
    else
       @ prow()  , 18 say "/" + CR1000->SEQUENCIA
    end

    @ prow()  , 22 say VEN001->GUERRA
    @ prow()  , 39 say VEN012->FORMAPAG
    @ prow()  , 43 say VEN012->TIPOVENDA
    @ prow()  , 47 say CR1000->QTD_CH
    @ prow()  , 54 say CR1000->JUROS     picture "@E 999,999.99"
    @ prow()  , 66 say CR1000->VALOR     picture "@E 999,999,999.99"

    W_QT_DIA     := W_QT_DIA + 1
    W_QT_PER     := W_QT_PER + 1

    W_VL_JUR_DIA := W_VL_JUR_DIA + CR1000->JUROS
    W_VL_JUR_PER := W_VL_JUR_PER + CR1000->JUROS

    W_VL_DIA     := W_VL_DIA + CR1000->VALOR
    W_VL_PER     := W_VL_PER + CR1000->VALOR

    inkey()
    if lastkey()=K_ESC
       @ prow()+2,20 say '---Impressao interrompida pelo usuario---'
       return
    end

return


/*
-----------------------------------------------------------------------------
                      Procedimento  crr1000Cab2 - Cabecalho 2
-----------------------------------------------------------------------------
*/
procedure crr1000C2()

    @ prow()+1, 01 say 'Data: ' + dtoc(CR1000->DT_VENC)

    @ prow()+2, 01 say 'Dt.Vec.'
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


    W_LIN := 10


return

/*
-----------------------------------------------------------------------------
                      Procedimento  crr1000R1 - Rodape    1
-----------------------------------------------------------------------------
*/
procedure crr1000R1()

    @ prow()+2, 00 say linha80
    @ prow()+1, 00 say ' Total do Dia.....: '
    @ prow()  , 23 say W_QT_DIA  picture "999"
    @ prow()  , 27 say 'Duplicata(s) '
    @ prow()  , 52 say W_VL_JUR_DIA  picture "@E 99999,999.99"
    @ prow()  , 66 say W_VL_DIA      picture "@E 999,999,999.99"
    @ prow()+1, 00 say linha80

return

/*
-----------------------------------------------------------------------------
                      Procedimento  crr1000R2 - Rodape    2
-----------------------------------------------------------------------------
*/
procedure crr1000R2()

    @ prow()+1, 00 say linha80
    @ prow()+1, 00 say ' Total do Periodo.: '
    @ prow()  , 23 say W_QT_PER  picture "999"
    @ prow()  , 27 say 'Duplicata(s) '
    @ prow()  , 52 say W_VL_JUR_PER  picture "@E 99999,999.99"
    @ prow()  , 66 say W_VL_PER      picture "@E 999,999,999.99"
    @ prow()+1, 00 say linha80

return

