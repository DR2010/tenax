/*

   CONTAS A RECEBER
   ERR1200.PRG - Relatorio de Cheques Pendentes

*/

#include "inkey.ch"

telanum('ERR1200','ERR1200')

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


private W_TITULO := 'Cheques Pendentes'
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

if para_periodo()
   if dh_imprime(1)
      if WRESP_IMP = 'A'
         ESTREPO->( grava( WIMP_ARQ, date(), time(), W_TITULO, 80) )
      end
      ERR1200proc()
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
function ERR1200proc()

local WRET := .T.

mensimp("Gerando Relatorio. Aguarde...")

ER0600->(dbsetorder(4))
Set Softseek on
if !(ER0600-> (dbseek("P"+dtos(X_DT_INI)),.T.) )
    @ prow()+2,20 say '---Nao existe Cheques para o periodo--'
    WRET := .F.
    return WRET
end

do while ( ER0600->(!eof())               ) .and. ;
         ( ER0600->STATUS      = "P"      ) .and. ;
         ( ER0600->DT_PREDATA <= X_DT_FIM )

         W_QT_DIA   := 0.00
         W_VL_DIA   := 0.00
         W_PAG      := W_PAG + 1

         ERR1200c1(W_TITULO,W_PAG)
         ERR1200C2()

         do while ( ER0600->(!eof())                 ) .and. ;
                  ( ER0600->STATUS      = "P"        ) .and. ;
                  ( ER0600->DT_PREDATA <= X_DT_FIM   )
                  ERR1200det()
                  ER0600->(dbskip())
         enddo

         ERR1200R1()
enddo

ERR1200R2()

return


/*
-----------------------------------------------------------------------------
                      Procedimento CABECALHO GERAL
-----------------------------------------------------------------------------
*/
procedure ERR1200C1(P_TITPROC,P_PAG)

    
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
                      Procedimento  ERR1200Cab2 - Cabecalho 2
-----------------------------------------------------------------------------
*/
procedure ERR1200C2()


    @ prow()+1, 01  say 'Data: ' + dtoc(ER0600->DT_PREDATA)

    @ prow()+2, 07  say 'Nr.Cheque'
    @ prow()  , 20  say 'Duplicata'
    @ prow()  , 34  say 'Cliente'
    @ prow()  , 63  say 'Valor'
    @ prow()  , 83  say 'Bom Para'

    @ prow()+1, 07  say '-----------'
    @ prow()  , 20  say '------------'
    @ prow()  , 34  say replicate('-',20)
    @ prow()  , 63  say replicate('-',15)
    @ prow()  , 83  say replicate('-',08)

return

/*
-----------------------------------------------------------------------------
                      Procedimento ERR1200DET - Linha Detalhe
-----------------------------------------------------------------------------
*/
procedure ERR1200DET()

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
       ERR1200C1(W_TITULO,W_PAG)
       ERR1200C2()
    end

    @ prow()+1, 07 say ER0600->NR_CHEQUE

    @ prow(), 20 say ER0600->DUPLICATA

    if ER0600->SEQUENCIA = " "
       @ prow()  , 29 say ER0600->SEQUENCIA
    else
       @ prow()  , 29 say "/" + ER0600->SEQUENCIA
    end

    @ prow()  , 34 say VEN001->CODCLI + ' - '

    @ prow()  , 43 say VEN001->GUERRA

    @ prow()  , 63 say ER0600->VALOR        picture "@E 9999,999,999.99"

    @ prow()  , 83 say ER0600->DT_PREDATA   picture "99/99/99"

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
                      Procedimento  ERR1200R1 - Rodape    1
-----------------------------------------------------------------------------
*/
procedure ERR1200R1()

    @ prow()+2, 00 say linha134
    @ prow()+1, 00 say ' Total do Dia     : '
    @ prow()  , 24 say W_QT_DIA  picture "999"
    @ prow()  , 28 say 'Cheque(s) '
    @ prow()  , 40 say W_VL_DIA  picture "@E 9999,999,999.99"
    @ prow()+1, 00 say linha134

return

/*
-----------------------------------------------------------------------------
                      Procedimento  ERR1200R2 - Rodape    2
-----------------------------------------------------------------------------
*/
procedure ERR1200R2()

    @ prow()+1, 00 say linha134
    @ prow()+1, 00 say ' Total do Periodo : '
    @ prow()  , 24 say W_QT_PER  picture "999"
    @ prow()  , 28 say 'Cheque(s) '
    @ prow()  , 40 say W_VL_PER  picture "@E 9999,999,999.99"
    @ prow()+1, 00 say linha134

return



