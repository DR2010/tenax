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
X_DUPL_INI   := SPACE(5)
X_DUPL_FIM   := SPACE(5)

W_QT_DIA     := 0
W_QT_PER     := 0
W_VL_PER     := 0.00
W_VL_TOT     := 0.00
W_VL_JUR_PER := 0.00
W_PAG        := 0
W_LIN        := 0

W_RAZAO      := space(40)
W_CODCLI     := space(05)
private X_T_REL := 0,ok := .f.

W_TELA := savescreen(,,,,)
 
X_T_REL := alert('Relatorio por',{'Periodo','Duplicata'})
do case 
  case X_T_REL = 1
      ok := if(pa_periodo(),.t.,.f.)
  case X_T_REL = 2
      ok := if(pa_dupl() ,.t.,.f.)
      X_DT_INI     := ctod('01/01/01')
      X_DT_FIM     := ctod('31/12/99')
endcase      
  if ok
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

IF X_T_REL = 2
 if !(CR1000-> (dbseek("P"),.T.) )
     WRET := .F.
     return WRET
 end
ELSE
 if !(CR1000-> (dbseek("P" + dtos(X_DT_INI)),.T.) )
    @ prow()+2,20 say '---Nao existe Duplicatas para o periodo--'
    WRET := .F.
    return WRET
  end
END

do while ( CR1000->(!eof())            ) .and. ;
         ( CR1000->STATUS   = "P"      ) .and. ;
         ( CR1000->DT_VENC <= X_DT_FIM )

         if prow() > 55
            @ prow()+1, 01 say ' '
            crr1000C1(W_TITULO,W_PAG)
            crr1000C2()
         end

         W_QT_DIA   := 0.00
         W_PAG      := W_PAG + 1

         crr1000c1(W_TITULO,W_PAG)
         crr1000C2()

         do while ( CR1000->(!eof())              ) .and. ;
                  ( CR1000->STATUS   = "P"        ) .and. ;
                  ( CR1000->DT_VENC <= X_DT_FIM   )
                      
            IF X_T_REL = 2
              IF VAL(CR1000->DUPLICATA)>=X_DUPL_INI ; 
                   .AND. VAL(CR1000->DUPLICATA)<=X_DUPL_FIM 
                crr1000det()
               END     
            ELSE
              crr1000det()
            END
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


function pa_dupl()

local WRET:= .T.

WSCRDUP := savescreen(,,,,)

setcursor(1)

X_DUPL_INI := SPACE(5)
X_DUPL_FIM := SPACE(5)

@ 10,14 say 'ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿'
@ 11,14 say '³                                   ³'
@ 12,14 say '³ Duplicata.:         a             ³'
@ 13,14 say '³                                   ³'
@ 14,14 say 'ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ'

do while .T.

   @ 12,27 get X_DUPL_INI  picture '99999'
   @ 12,38 get X_DUPL_FIM  picture '99999'
   read
   if lastkey() = K_ESC
      WRET := .F.
      exit
   end

   if X_DUPL_INI > X_DUPL_FIM
      mensbeep (' Parametro de Duplicata Invalido !')
      WRET := .F.
      loop
   end

   if empty(X_DUPL_INI)
      X_DUPL_INI :=  '00001'
   end
   if empty(X_DUPL_FIM)
      X_DUPL_FIM :=  '99999'
   end

   @ 12,16 say X_DUPL_INI picture '99999'
   @ 12,38 say X_DUPL_FIM picture '99999'
   
   X_DUPL_INI := VAL(X_DUPL_INI)
   X_DUPL_FIM := VAL(X_DUPL_FIM)

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
    if X_T_REL = 2
      @ prow()  , 51 say 'de ' +  STR( X_DUPL_INI,5 )
      @ prow()  , 59 say ' a '
      @ prow()  , 63 say STR( X_DUPL_FIM,5 )
    ELSE
      @ prow()  , 51 say 'Periodo.:' +  DTOC( X_DT_INI )
      @ prow()  , 68 say ' a '
      @ prow()  , 71 say DTOC( X_DT_FIM )
    END

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
       @ prow()+1, 01 say ' '
       crr1000C1(W_TITULO,W_PAG)
       crr1000C2()
    end

    @ prow()+1, 00 say CR1000->DT_VENC

    @ prow()  , 09 say CR1000->DUPLICATA

    if CR1000->SEQUENCIA = " "
       @ prow()  , 17 say CR1000->SEQUENCIA
    else
       @ prow()  , 17 say "/" + CR1000->SEQUENCIA
    end

    @ prow()  , 20 say VEN001->GUERRA
    @ prow()  , PCOL()+1 say VEN012->TIPOVENDA
    @ prow()  , PCOL()+1 say VEN012->FORMAPAG
    @ prow()  , PCOL()+1 say CR1000->ACORDO
    @ prow()  , PCOL()+2 say CR1000->FLG_ABATI PICT '@!'
    @ prow()  , PCOL()+2 say CR1000->FLG_TXADM
    @ prow()  , PCOL()+4 say CR1000->JUROS     picture "@E 999,999.99"
    @ prow()  , PCOL()+3 say CR1000->VALOR     picture "@E 999,999,999.99"

    W_QT_PER     := W_QT_PER + 1
    W_QT_DIA     := W_QT_DIA + 1

    W_VL_JUR_PER := W_VL_JUR_PER + CR1000->JUROS
    W_VL_PER     := W_VL_PER + CR1000->VALOR

    W_VL_TOT     := W_VL_TOT + CR1000->VALOR + CR1000->JUROS +CR1000->TXADM - CR1000->ABATIMENTO

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

    W_LIN := 10


return

/*
-----------------------------------------------------------------------------
                      Procedimento  crr1000R1 - Rodape    1
-----------------------------------------------------------------------------
*/
procedure crr1000R1()

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
                      Procedimento  crr1000R2 - Rodape    2
-----------------------------------------------------------------------------
*/
procedure crr1000R2()

    @ prow()+2, 00 say linha80
    @ prow()+1, 00 say ' Total Juros+Valor: '
    @ prow()  , 23 say W_QT_DIA  picture "999"
    @ prow()  , 27 say 'Duplicata(s) '
    @ prow()  , 57 say W_VL_TOT      picture "@E 99999,999.99"
    @ prow()+1, 00 say linha80

return
