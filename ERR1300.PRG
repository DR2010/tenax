/*

   CONTAS A RECEBER
   ERR1300.PRG - Relatorio de Cheques Recebidos

*/

#include "inkey.ch"

telanum('ERR1300','ERR1300')

//
// Arquivos
//

abrir("ESTREPO")
abrir("ER0600")
abrir("VEN001")
abrir("VEN011")
abrir("VEN050")

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
      ERR1300proc()
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
function ERR1300proc()

local WRET := .T.

mensimp("Gerando Relatorio. Aguarde...")

ER0600->(dbsetorder(4))
Set Softseek on
if !(ER0600-> (dbseek("R"+dtos(X_DT_INI)),.T.) )
   @ prow()+2,20 say '---Nao existe Cheques para o periodo--'
   WRET := .F.
   return WRET
end

do while ( ER0600->(!eof())                ) .and. ;
         ( ER0600->STATUS      = "R"       ) .and. ;
         ( ER0600->DT_PREDATA <= X_DT_FIM  )

         W_QT_DIA   := 0.00
         W_VL_DIA   := 0.00
         W_PAG      := W_PAG + 1

         ERR1300c1(W_TITULO,W_PAG)
         ERR1300C2()

         do while ( ER0600->(!eof())                 ) .and. ;
                  ( ER0600->STATUS      = "R"        ) .and. ;
                  ( ER0600->DT_PREDATA <= X_DT_FIM   )
                  ERR1300det()
                  ER0600->(dbskip())
         enddo

         ERR1300R1()
enddo

ERR1300R2()

return

/*
-----------------------------------------------------------------------------
                      Procedimento CABECALHO GERAL
-----------------------------------------------------------------------------
*/
procedure ERR1300C1(P_TITPROC,P_PAG)

    
    @ 00      , 00 say linha134
    @ prow()+1, 00 say '   TENAX ACOS ESPECIAIS'
    @ prow()  , 82 say 'Data: ' + dtoc(date())
    @ prow()  ,102 say 'Hora: '
    @ prow()  ,108 say (Time())
    @ prow()  ,124 say 'Pag.: ' + strzero(P_PAG,2)
    @ prow()+1, 00 say linha134

    @ prow()+1, int ((( 136-len(alltrim(P_TITPROC)) )/2)) say P_TITPROC
    @ prow()  ,102 say 'Periodo.:' +  dtoc( X_DT_INI )
    @ prow()  ,119 say ' a '
    @ prow()  ,123 say dtoc( X_DT_FIM )

return

/*
-----------------------------------------------------------------------------
                      Procedimento  ERR1300Cab2 - Cabecalho 2
-----------------------------------------------------------------------------
*/
procedure ERR1300C2()


    @ prow()+1, 01  say 'Data: ' + dtoc(ER0600->DT_PREDATA)

    @ prow()+2, 07  say 'Nr.Cheque'
    @ prow()  , 23  say 'Duplicata'
    @ prow()  , 40  say 'Cliente'
    @ prow()  , 70  say 'Valor'
    @ prow()  , 88  say 'Dt.Pag'

    @ prow()+1, 07  say '-----------'
    @ prow()  , 23  say '------------'
    @ prow()  , 40  say replicate('-',20)
    @ prow()  , 70  say replicate('-',15)
    @ prow()  , 88  say replicate('-',08)


return

/*
-----------------------------------------------------------------------------
                      Procedimento ERR1300DET - Linha Detalhe
-----------------------------------------------------------------------------
*/
procedure ERR1300DET()

    X_CODCLI := replicate ('*',05)
    X_GUERRA := replicate ('*',40)

    VEN050->(dbsetorder(1))
    if VEN050->(dbseek(ER0600->DUPLICATA))
       X_CODCLI := VEN001->CODCLI
       VEN001->(dbsetorder(1))
       if VEN001->(dbseek(VEN050->CODCLI))
          X_GUERRA := VEN001->GUERRA
       end
    end

    if prow() > 55
       W_PAG := W_PAG + 1
       ERR1300C1(W_TITULO,W_PAG)
       ERR1300C2()
    end

    @ prow()+1, 07 say ER0600->NR_CHEQUE

    @ prow(), 23 say ER0600->DUPLICATA

    if ER0600->SEQUENCIA = " "
       @ prow()  , 36 say ER0600->SEQUENCIA
    else
       @ prow()  , 36 say "/" + ER0600->SEQUENCIA
    end

    @ prow()  , 40 say VEN001->CODCLI + ' - '

    @ prow()  , 49 say VEN001->GUERRA

    @ prow()  , 70 say ER0600->VALOR picture "@E 9999,999,999.99"

    @ prow()  , 88 say ER0600->DT_PAG picture "99/99/99"

    W_QT_DIA := W_QT_DIA + 1
    W_QT_PER := W_QT_PER + 1
    W_VL_DIA := W_VL_DIA + ER0600->VALOR
    W_VL_PER := W_VL_PER + ER0600->VALOR


    inkey()
    if lastkey()=K_ESC
       @ prow()+2,20 say '---Impressao interrompida pelo usuario---'
       return
    end

return

/*
-----------------------------------------------------------------------------
                      Procedimento  ERR1300R1 - Rodape    1
-----------------------------------------------------------------------------
*/
procedure ERR1300R1()

    @ prow()+2, 00 say linha134
    @ prow()+1, 00 say ' Total do Dia     : '
    @ prow()  , 24 say W_QT_DIA  picture "999"
    @ prow()  , 28 say 'Cheque(s):'
    @ prow()  , 40 say W_VL_DIA  picture "@E 9999,999,999.99"
    @ prow()+1, 00 say linha134

return

/*
-----------------------------------------------------------------------------
                      Procedimento  ERR1300R2 - Rodape    2
-----------------------------------------------------------------------------
*/
procedure ERR1300R2()

    @ prow()+1, 00 say linha134
    @ prow()+1, 00 say ' Total do Periodo : '
    @ prow()  , 24 say W_QT_PER  picture "999"
    @ prow()  , 28 say 'Cheque(s):'
    @ prow()  , 40 say W_VL_PER  picture "@E 9999,999,999.99"
    @ prow()+1, 00 say linha134

return




