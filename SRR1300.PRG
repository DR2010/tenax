/*

   CONTAS A RECEBER
   SRR1300.PRG - Relatorio de Cheques Recebidos

*/

#include "inkey.ch"

telanum('SRR1300','SRR1300')

//
// Arquivos
//

abrir("ESTREPO")
abrir("SR0600")
abrir("VEN001")
abrir("VEN011")
abrir("VEN030")

//
// variaveis para controle de impressoes geradas para arquivo
//

private linha134 := replicate('-',134)


private W_TITULO := 'Cheques Recebidos C/R'
WRESP_IMP := 'I'
W_IMPARQ  := space(12)


//
// Variaveis
//

S_DT_INI   := ctod('  /  /  ')
S_DT_FIM   := ctod('  /  /  ')
W_QT_DIA   := 0
W_QT_PER   := 0
W_VL_DIA   := 0.00
W_VL_PER   := 0.00
W_PAG      := 0
W_LIN      := 0

W_RAZAO    := space(40)
W_CODCLI   := space(05)

W_TELA := savescreen(,,,,)

if SPR_periodo()
   if dh_imprime(1)
      if WRESP_IMP = 'A'
         ESTREPO->( grava( WIMP_ARQ, date(), time(), W_TITULO, 80) )
      end
      SRR1300proc()
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
function SRR1300proc()

local WRET := .T.

mensimp("Gerando Relatorio. Aguarde...")

SR0600->(dbsetorder(3))
Set Softseek on
if !(SR0600-> (dbseek("R"+dtos(S_DT_INI)),.T.) )
   @ prow()+2,20 say '---Nao existe Cheques para o periodo--'
   WRET := .F.
   return WRET
end

do while ( SR0600->(!eof())                ) .and. ;
         ( SR0600->STATUS      = "R"       ) .and. ;
         ( SR0600->DT_PREDATA <= S_DT_FIM  )

         W_QT_DIA   := 0.00
         W_VL_DIA   := 0.00
         W_PAG      := W_PAG + 1

         SRR1300c1(W_TITULO,W_PAG)
         SRR1300C2()

         do while ( SR0600->(!eof())                 ) .and. ;
                  ( SR0600->STATUS      = "R"        ) .and. ;
                  ( SR0600->DT_PREDATA <= S_DT_FIM   )
                  SRR1300det()
                  if prow() > 55
                     W_PAG := W_PAG + 1
                     SRR1300C1(W_TITULO,W_PAG)
                     SRR1300C2()
                  end

                  SR0600->(dbskip())

         enddo

         SRR1300R1()
enddo

SRR1300R2()

return

/*
-----------------------------------------------------------------------------
                      Parametro de Data Inicial / Final
-----------------------------------------------------------------------------
*/

function SPR_periodo()

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
procedure SRR1300C1(P_TITPROC,P_PAG)

    
    @ 00      , 00 say linha134
    @ prow()+1, 00 say '   TENAX ACOS ESPECIAIS'
    @ prow()  , 82 say 'Data: ' + dtoc(date())
    @ prow()  ,102 say 'Hora: '
    @ prow()  ,108 say (Time())
    @ prow()  ,124 say 'Pag.: ' + strzero(P_PAG,2)
    @ prow()+1, 00 say linha134

    @ prow()+1, int ((( 136-len(alltrim(P_TITPROC)) )/2)) say P_TITPROC
    @ prow()  ,102 say 'Periodo.:' +  dtoc( S_DT_INI )
    @ prow()  ,119 say ' a '
    @ prow()  ,123 say dtoc( S_DT_FIM )

return

/*
-----------------------------------------------------------------------------
                      Procedimento  SRR1300Cab2 - Cabecalho 2
-----------------------------------------------------------------------------
*/

procedure SRR1300C2()


    @ prow()+1, 01  say 'Data: ' + dtoc(SR0600->DT_PREDATA)

    @ prow()+2, 01        say 'Nr.Cheque'
    @ prow()  , pcol()+04 say 'Duplicata'
    @ prow()  , pcol()+02 say 'Cliente'
    @ prow()  , pcol()+18 say 'Bom para'
    @ prow()  , pcol()+03 say 'Valor'
    @ prow()  , pcol()+12 say 'Dest/Nome'
    @ prow()  , pcol()+13 say 'Dest/Data'

    @ prow()+1, 01        say '-----------'
    @ prow()  , pcol()+02 say '---------'
    @ prow()  , pcol()+02 say replicate('-',23)
    @ prow()  , pcol()+02 say replicate('-',08)
    @ prow()  , pcol()+03 say replicate('-',15)
    @ prow()  , pcol()+02 say replicate('-',20)
    @ prow()  , pcol()+02 say replicate('-',08)

return

/*
-----------------------------------------------------------------------------
                      Procedimento SRR1300DET - Linha Detalhe
-----------------------------------------------------------------------------
*/
procedure SRR1300DET()

    X_CODCLI := replicate ('*',05)
    S_GUERRA := replicate ('*',40)

    VEN030->(dbsetorder(1))
    if VEN030->(dbseek(SR0600->DUPLICATA))
       X_CODCLI := VEN001->CODCLI
       VEN001->(dbsetorder(1))
       if VEN001->(dbseek(VEN030->CODCLI))
          S_GUERRA := VEN001->GUERRA
       end
    end

    if prow() > 55
       W_PAG := W_PAG + 1
       SRR1300C1(W_TITULO,W_PAG)
       SRR1300C2()
    end


    @ prow()+1, 02 say SR0600->NR_CHEQUE

    @ prow(), pcol()+2 say SR0600->DUPLICATA

    if SR0600->SEQUENCIA = " "
       @ prow()  , pcol()+2 say SR0600->SEQUENCIA
    else
       @ prow()  , pcol()+1 say "/" + SR0600->SEQUENCIA
    end

    @ prow()  , pcol()+02 say VEN001->CODCLI + ' - '
    @ prow()  , PCOL()    say VEN001->GUERRA
    @ prow()  , pcol()+02 say SR0600->DT_PREDATA
    @ prow()  , pcol()+02 say SR0600->VALOR       picture "@E 9999,999,999.99"
    @ prow()  , pcol()+03 say SR0600->DEST_NOME
    @ prow()  , pcol()+03 say SR0600->DEST_DATA   picture "99/99/99"
    W_QT_DIA := W_QT_DIA + 1
    W_QT_PER := W_QT_PER + 1
    W_VL_DIA := W_VL_DIA + SR0600->VALOR
    W_VL_PER := W_VL_PER + SR0600->VALOR


    inkey()
    if lastkey()=K_ESC
       @ prow()+2,20 say '---Impressao interrompida pelo usuario---'
       return
    end

return

/*
-----------------------------------------------------------------------------
                      Procedimento  SRR1300R1 - Rodape    1
-----------------------------------------------------------------------------
*/
procedure SRR1300R1()

    @ prow()+2, 00 say linha134
    @ prow()+1, 00 say ' Total do Dia     : '
    @ prow()  , 24 say W_QT_DIA  picture "999"
    @ prow()  , 28 say 'Cheque(s):'
    @ prow()  , 40 say W_VL_DIA  picture "@E 9999,999,999.99"
    @ prow()+1, 00 say linha134

return

/*
-----------------------------------------------------------------------------
                      Procedimento  SRR1300R2 - Rodape    2
-----------------------------------------------------------------------------
*/
procedure SRR1300R2()

    @ prow()+1, 00 say linha134
    @ prow()+1, 00 say ' Total do Periodo : '
    @ prow()  , 24 say W_QT_PER  picture "999"
    @ prow()  , 28 say 'Cheque(s):'
    @ prow()  , 40 say W_VL_PER  picture "@E 9999,999,999.99"
    @ prow()+1, 00 say linha134

return




