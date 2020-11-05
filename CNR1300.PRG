/*

   CONTAS A RECEBER
   CRR1300.PRG - Relatorio de Cheques Recebidos

*/

#include "inkey.ch"

telanum('CRR1300','CRR1300')

//
// Arquivos
//

abrir("ESTREPO")
abrir("CR0600")
abrir("VEN001")
abrir("VEN011")
abrir("VEN012")

//
// variaveis para controle de impressoes geradas para arquivo
//

private linha134 := replicate('-',134)


private W_TITULO := 'Cheques Recebidos'
WRESP_IMP := 'I'
W_IMPARQ  := space(12)


//
// Variaveis
//

X_DT_INI   := ctod('  /  /  ')
X_DT_FIM   := ctod('  /  /  ')
X_DT_ATUAL := ctod('  /  /  ')
W_QT_DIA   := 0
W_QT_PER   := 0
W_VL_DIA   := 0.00
W_VL_PER   := 0.00
W_PAG      := 0
W_LIN      := 0

W_RAZAO    := space(40)
W_CODCLI   := space(05)

W_TELA := savescreen(,,,,)

if pr_periodo()
   if dh_imprime(1)
      if WRESP_IMP = 'A'
         ESTREPO->( grava( WIMP_ARQ, date(), time(), W_TITULO, 80) )
      end
      CRR1300proc()
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
function CRR1300proc()

local WRET := .T.

mensimp("Gerando Relatorio. Aguarde...")

CR0600->(dbsetorder(4))
Set Softseek on
if !(CR0600-> (dbseek("R"+dtos(X_DT_INI)),.T.) )
   @ prow()+2,20 say '---Nao existe Cheques para o periodo--'
   WRET := .F.
   return WRET
end

do while ( CR0600->(!eof())                ) .and. ;
         ( CR0600->STATUS      = "R"       ) .and. ;
         ( CR0600->DT_PREDATA <= X_DT_FIM  )

         X_DT_ATUAL := CR0600->DT_PREDATA
         W_QT_DIA   := 0.00
         W_VL_DIA   := 0.00
         W_PAG      := W_PAG + 1

         CRR1300c1(W_TITULO,W_PAG)
         CRR1300C2()

         do while ( CR0600->(!eof())                 ) .and. ;
                  ( CR0600->STATUS      = "R"        ) .and. ;
                  ( CR0600->DT_PREDATA <= X_DT_FIM   ) .and. ;
                  ( CR0600->DT_PREDATA  = X_DT_ATUAL )
                  CRR1300det()
                  CR0600->(dbskip())
         enddo

         CRR1300R1()
enddo

CRR1300R2()

return

/*
-----------------------------------------------------------------------------
                      Parametro de Data Inicial / Final
-----------------------------------------------------------------------------
*/

function pr_periodo()

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
procedure CRR1300C1(P_TITPROC,P_PAG)

    
    @ 00      , 00 say linha134
    @ prow()+1, 00 say '   TENAX ACOS ESPECIAIS'
    @ prow()  , 82 say 'Data: ' + dtoc(date())
    @ prow()  ,102 say 'Hora: '
    @ prow()  ,108 say (Time())
    @ prow()  ,125 say 'Pag.: ' + strzero(P_PAG,2)
    @ prow()+1, 00 say linha134

    @ prow()+1, int ((( 136-len(alltrim(P_TITPROC)) )/2)) say P_TITPROC
    @ prow()  ,102 say 'Periodo.:' +  dtoc( X_DT_INI )
    @ prow()  ,119 say ' a '
    @ prow()  ,123 say dtoc( X_DT_FIM )

return

/*
-----------------------------------------------------------------------------
                      Procedimento  CRR1300Cab2 - Cabecalho 2
-----------------------------------------------------------------------------
*/
procedure CRR1300C2()


    @ prow()+1, 01  say 'Data: ' + dtoc(CR0600->DT_PREDATA)

    @ prow()+2, 07  say 'Nr.Cheque'
    @ prow()  , 27  say 'Duplicata'
    @ prow()  , 40  say 'Cliente'
    @ prow()  , 70  say 'Valor'
    @ prow()  , 88  say 'Dt.Pag'

    @ prow()+1, 07  say '---------'
    @ prow()  , 27  say '---------'
    @ prow()  , 40  say replicate('-',20)
    @ prow()  , 70  say replicate('-',15)
    @ prow()  , 88  say replicate('-',08)


return

/*
-----------------------------------------------------------------------------
                      Procedimento CRR1300DET - Linha Detalhe
-----------------------------------------------------------------------------
*/
procedure CRR1300DET()

    X_CODCLI := replicate ('*',05)
    X_GUERRA := replicate ('*',40)

    VEN012->(dbsetorder(1))
    if VEN012->(dbseek(CR0600->DUPLICATA))
       X_CODCLI := VEN001->CODCLI
       VEN001->(dbsetorder(1))
       if VEN001->(dbseek(VEN012->CODCLI))
          X_GUERRA := VEN001->GUERRA
       end
    end

    if prow() > 55
       W_PAG := W_PAG + 1
       CRR1300C1(W_TITULO,W_PAG)
       CRR1300C2()
    end

    @ prow()+1, 07 say CR0600->NR_CHEQUE

    @ prow(), 27 say CR0600->DUPLICATA

    if CR0600->SEQUENCIA = " "
       @ prow()  , 36 say CR0600->SEQUENCIA
    else
       @ prow()  , 36 say "/" + CR0600->SEQUENCIA
    end

    @ prow()  , 40 say VEN001->CODCLI + ' - '

    @ prow()  , 47 say VEN001->GUERRA

    @ prow()  , 70 say CR0600->VALOR picture "@E 9999,999,999.99"

    @ prow()  , 88 say CR0600->DT_PAG picture "99/99/99"

    W_QT_DIA := W_QT_DIA + 1
    W_QT_PER := W_QT_PER + 1
    W_VL_DIA := W_VL_DIA + CR0600->VALOR
    W_VL_PER := W_VL_PER + CR0600->VALOR


    inkey()
    if lastkey()=K_ESC
       @ prow()+2,20 say '---Impressao interrompida pelo usuario---'
       return
    end

return

/*
-----------------------------------------------------------------------------
                      Procedimento  CRR1300R1 - Rodape    1
-----------------------------------------------------------------------------
*/
procedure CRR1300R1()

    @ prow()+2, 00 say linha134
    @ prow()+1, 00 say ' Total do Dia     : '
    @ prow()  , 24 say W_QT_DIA  picture "999"
    @ prow()  , 28 say 'Cheque(s):'
    @ prow()  , 95 say W_VL_DIA  picture "@E 9999,999,999.99"
    @ prow()+1, 00 say linha134

return

/*
-----------------------------------------------------------------------------
                      Procedimento  CRR1300R2 - Rodape    2
-----------------------------------------------------------------------------
*/
procedure CRR1300R2()

    @ prow()+1, 00 say linha134
    @ prow()+1, 00 say ' Total do Periodo : '
    @ prow()  , 24 say W_QT_PER  picture "999"
    @ prow()  , 28 say 'Cheque(s):'
    @ prow()  , 95 say W_VL_PER  picture "@E 9999,999,999.99"
    @ prow()+1, 00 say linha134

return




