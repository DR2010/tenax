/*
   CONTAS A RECEBER
   crr1800.PRG - Relatorio de Boletas Pendentes
*/

#include "inkey.ch"

telanum('crr1800','crr1800')

//
// Arquivos
//

abrir("ESTREPO")
abrir("CR1000")
abrir("CR0400")
abrir("VEN001")
abrir("VEN011")
abrir("VEN012")

//
// variaveis para controle de impressoes geradas para arquivo
//

private linha80  := replicate('-',80)


private W_TITULO := 'Boletas Pendentes'
WRESP_IMP := 'I'
W_IMPARQ  := space(12)


//
// Variaveis
//

X_DT_INI     := ctod('  /  /  ')
X_DT_FIM     := ctod('  /  /  ')
X_DUPL_INI   := SPACE(5)
X_DUPL_FIM   := SPACE(5)

W_QT_DIA     := 0
W_QT_PER     := 0
W_VL_PER     := 0.00
W_VL_TOT     := 0.00
W_PAG        := 0
W_LIN        := 0

W_RAZAO      := space(40)
W_CODCLI     := space(05)
private X_T_REL := 0,ok := .f.

W_TELA := savescreen(,,,,)
 
if par_periodo()
   if dh_imprime()
      if WRESP_IMP = 'A'
         ESTREPO->( grava( WIMP_ARQ, date(), time(), W_TITULO, 80) )
      end
      crr1800proc()
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
function crr1800proc()

local WRET := .T.

mensimp("Gerando Relatorio. Aguarde...")

CR1000->(dbgotop())
CR1000->(dbsetorder(3))
Set Softseek on
CR1000-> (dbseek("P" + dtos(X_DT_INI)),.T.)

W_TITULO := "Boletas Pendentes"

do while ( CR1000->(!eof())            ) .and. ;
         ( CR1000->STATUS   = "P"      )
   do while ( CR1000->(!eof())            ) .and. ;
            ( CR1000->DT_VENC <= X_DT_FIM ) .and. ;
            ( CR1000->STATUS   = "P"      )
            if prow() > 55 .or. W_PAG = 0
               W_PAG  := W_PAG + 1
               @ prow()+1, 01 say ' '
               crr1800C1(W_TITULO,W_PAG)
               crr1800C2()
            end
            VEN012->(dbsetorder(1))
            VEN012->(dbseek(CR1000->DUPLICATA))
            CR0400->(dbsetorder(1))
            CR0400->(dbseek(VEN012->TIPOVENDA+VEN012->FORMAPAG))
            if CR0400->BOLETA = "X"
               crr1800det()
            end
            inkey()
            if lastkey()=K_ESC
               @ prow()+2,20 say '---Impressao interrompida pelo usuario---'
               return
            end
            CR1000->(dbskip())
   enddo
   crr1800R2()
enddo

W_QT_DIA     := 0
W_QT_PER     := 0
W_VL_PER     := 0.00
W_VL_TOT     := 0.00
W_PAG        := 0
W_LIN        := 0

W_TITULO := "Boletas Recebidas"

CR1000->(dbgotop())
CR1000->(dbsetorder(3))
Set Softseek on
CR1000-> (dbseek("R" + dtos(X_DT_INI)),.T.)

do while ( CR1000->(!eof())            ) .and. ;
         ( CR1000->STATUS   = "R"      )
   do while ( CR1000->(!eof())            ) .and. ;
            ( CR1000->DT_VENC <= X_DT_FIM ) .and. ;
            ( CR1000->STATUS   = "R"      )
            if prow() > 55 .or. W_PAG = 0
               W_PAG  := W_PAG + 1
               @ prow()+1, 01 say ' '
               crr1800C1(W_TITULO,W_PAG)
               crr1800C2()
            end
            VEN012->(dbsetorder(1))
            VEN012->(dbseek(CR1000->DUPLICATA))
            CR0400->(dbsetorder(1))
            CR0400->(dbseek(VEN012->TIPOVENDA+VEN012->FORMAPAG))
            if CR0400->BOLETA = "X"
               crr1800det()
            end
            inkey()
            if lastkey()=K_ESC
               @ prow()+2,20 say '---Impressao interrompida pelo usuario---'
               return
            end
            CR1000->(dbskip())
   enddo
   crr1800R2()
enddo


return

/*
-----------------------------------------------------------------------------
                      Procedimento CABECALHO GERAL
-----------------------------------------------------------------------------
*/
procedure crr1800C1(P_TITPROC,P_PAG)

    @ 00      , 00 say linha80
    @ prow()+1, 00 say '   TENAX ACOS ESPECIAIS'
    @ prow()+1, 35 say 'Data: ' + dtoc(date())
    @ prow()  , 53 say 'Hora: '
    @ prow()  , 59 say (Time())
    @ prow()  , 69 say 'Pag.: ' + strzero(P_PAG,2)
    @ prow()+1, 00 say linha80

    @ prow()+1, int ((( 80-len(alltrim(P_TITPROC)) )/2)) say P_TITPROC

return

/*
-----------------------------------------------------------------------------
                      Procedimento crr1800DET - Linha Detalhe
-----------------------------------------------------------------------------
*/
procedure crr1800DET()

    X_CODCLI := replicate ('*',05)
    X_GUERRA := replicate ('*',40)

    VEN001->(dbsetorder(1))
    if VEN001->(dbseek(VEN012->CODCLI))
       X_GUERRA := VEN001->GUERRA
       X_CODCLI := VEN001->CODCLI
    end

    @ prow()+1, 00       say CR1000->DT_VENC
    @ prow()  , 09       say CR1000->DUPLICATA
    if CR1000->SEQUENCIA = " "
       @ prow()  , 17    say CR1000->SEQUENCIA
    else
       @ prow()  , 17    say "/" + CR1000->SEQUENCIA
    end
    @ prow()  , 20       say VEN001->GUERRA
    @ prow()  , PCOL()+1 say CR1000->BOLETA
    @ prow()  , PCOL()+3 say CR1000->VALOR     picture "@E 999,999,999.99"
    @ prow()  , PCOL()+2 say CR1000->DT_PAG

    W_QT_DIA     := W_QT_DIA + 1
    W_VL_TOT     := W_VL_TOT + CR1000->VALOR

return


/*
-----------------------------------------------------------------------------
                      Procedimento  crr1800Cab2 - Cabecalho 2
-----------------------------------------------------------------------------
*/
procedure crr1800C2()

    @ prow()+2, 00 say 'Dt.Venc'
    @ prow()  , 09 say 'Duplicata'
    @ prow()  , 20 say 'Cliente'
    @ prow()  , 36 say 'Boleta'
    @ prow()  , 59 say 'Valor'
    @ prow()  , 67 say 'Dt.Pag.'

    @ prow()+1, 00 say replicate('-',08)
    @ prow()  , 09 say replicate('-',10)
    @ prow()  , 20 say replicate('-',15)
    @ prow()  , 36 say replicate('-',10)
    @ prow()  , 49 say replicate('-',15)
    @ prow()  , 66 say replicate('-',08)

    W_LIN := 10


return

/*
-----------------------------------------------------------------------------
                      Procedimento  crr1800R2 - Rodape    2
-----------------------------------------------------------------------------
*/
procedure crr1800R2()

    @ prow()+2, 00 say linha80
    @ prow()+1, 00 say ' Total Valor :      '
    @ prow()  , 23 say W_QT_DIA  picture "999"
    @ prow()  , 27 say 'Duplicata(s) '
    @ prow()  , 51 say W_VL_TOT      picture "@E 99999,999.99"
    @ prow()+1, 00 say linha80

return

