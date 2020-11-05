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

VEN012->( dbsetrelation( "VEN001", {|| VEN012->CODCLI } ) )
//
// variaveis para controle de impressoes geradas para arquivo
//

private linha78 := replicate('-',78)
private W_TITULO := 'Nota Fiscal p/ periodo'

WRESP_IMP     := 'I'
W_IMPARQ      := space(12)
X_DT_INI      := ctod('  /  /  ')
X_DT_FIM      := ctod('  /  /  ')
W_DT_ATUAL    := ctod('  /  /  ')
W_QT_DIA      := 0.00
W_QT_TOT      := 0.00
W_VL_DIA      := 0.00
W_VL_TOT      := 0.00
W_ICMS_DIA    := 0.00
W_ICMS_TOT    := 0.00
W_B_CALC_DIA  := 0.00
W_B_CALC_TOT  := 0.00
W_PAG         := 0.00
W_LIN         := 0.00
X_NOTAFISCAL  := space(10)
X_CODCLI      := space(5)
oldcolor      := ''
cli_flg       := .f.
compri        := ''
W_TELA := savescreen(,,,,)
oldcolor:=setcolor()
setcolor("w/b,w+/n")
escolha := Alert("Relatorio por:",{"Periodo","Cliente/Periodo"})
setcolor(oldcolor)
do case
  case escolha = 1 
     if p_periodo()
       if Alert("Inclui codigo do cliente ?",{"Sim","Nao"}) = 1
         cli_flg := .t.
         compri := 'I'
         linha78 := repl('-',132)
       endif
       if dh_imprime(compri)
         if WRESP_IMP = 'A'
           ESTREPO->( grava( WIMP_ARQ, date(), time(), W_TITULO, 80) )
         end
         crr1500proc()
         @ 00,00 say ''
       end
     end
  case escolha = 2
      W_TITULO := 'Nota Fiscal por Cliente/Periodo'
      X_CODCLI  := space(5)
      X_RAZAO   := SPACE(55)
     
     if p_periodo2()
       if dh_imprime()
         if WRESP_IMP = 'A'
           ESTREPO->( grava( WIMP_ARQ, date(), time(), W_TITULO, 80) )
         end
         ab_proc3()
         @ 00,00 say ''
       end
     end
endcase
     dh_impoff()
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


   W_VL_TOT     := 0.00
   W_ICMS_TOT   := 0.00
   W_B_CALC_TOT := 0.00
   
   do while ( VEN012->(!eof()) ) .and. ;
            ( VEN012->DT_EMISSAO <= X_DT_FIM )

      W_DT_ATUAL    := VEN012->DT_EMISSAO
      W_QT_DIA      := 0.00
      W_VL_DIA      := 0.00
      W_ICMS_DIA    := 0.00
      W_B_CALC_DIA  := 0.00
      W_PAG         := W_PAG + 1

      crr1500C1(W_TITULO,W_PAG)
      crr1500C2()
      do While VEN012->( ! eof() ) .and. ;
         VEN012->DT_EMISSAO = W_DT_ATUAL
           crr1500det()
         VEN012->(dbskip())
      enddo

      crr1500R1()

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
    @ prow()+1, 01 say 'TENAX ACOS ESPECIAIS'
    @ prow(),   if(cli_flg,115,63) say 'Data: ' + dtoc(date())
    @ prow()+1, 01 say 'Pag.: ' + strzero(P_PAG,2)
    @ prow(),   int ((( (if(cli_flg,132,80))-len(alltrim(P_TITPROC)) )/2)) say P_TITPROC
    @ prow()  , pcol()+if(cli_flg,38,12) say 'Hora: '+ (Time())
    @ prow()+1 ,01 say 'Periodo.:' +  dtoc( X_DT_INI ) +' a '+dtoc( X_DT_FIM )
    @ prow()+1, 00 say linha78
    

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
   
    @ prow()+1, 04  say VEN012->NOTAFISCAL
    if !cli_flg
      @ prow()  , 15  say VEN012->DT_EMISSAO
      @ prow()  , 26  say VEN012->TIPOVENDA
      @ prow()  , 31  say VEN012->FORMAPAG
      @ prow()  , 36  say VEN012->QTDPARC
      @ prow()  , 46  say VEN012->CODVENC
      @ prow()  , 50  say VEN012->VALOR       picture "@E 999,999,999.99"
      @ prow()  , 70  say VEN012->STATUS
    else
       
      @ prow()  , 15  say VEN012->CODCLI
      @ prow()  , 25  say VEN001->GUERRA
      @ prow()  , PCOL()+3 say VEN012->DT_EMISSAO
      @ prow()  , PCOL()+5 say VEN012->TIPOVENDA
      @ prow()  , PCOL()+4 say VEN012->FORMAPAG
      @ prow()  , PCOL()+7 say VEN012->QTDPARC
      @ prow()  , PCOL()+8 say VEN012->CODVENC
      @ prow()  , PCOL()+3 say VEN012->VALOR       picture "@E 999,999,999.99"
      @ prow()  , PCOL()+4 say VEN012->STATUS

    end

    if ( VEN012->STATUS != "C" )
       W_QT_DIA     := W_QT_DIA      + 1
       W_QT_TOT     := W_QT_TOT      + 1
       if ( VEN012->STATUS != "D" )       
         W_VL_DIA     := W_VL_DIA      + VEN012->VALOR
         W_VL_TOT     := W_VL_TOT      + VEN012->VALOR
       end
       W_ICMS_DIA   := W_ICMS_DIA + VEN012->ICMS
       W_ICMS_TOT   := W_ICMS_TOT + VEN012->ICMS
       W_B_CALC_DIA := W_B_CALC_DIA + VEN012->B_CALC
       W_B_CALC_TOT := W_B_CALC_TOT + VEN012->B_CALC
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

    @ prow()+2, 04  say 'N. Fiscal'
    if !cli_flg
      @ prow()  , 15  say 'Emissao'
      @ prow()  , 24  say 'T.Ven'
      @ prow()  , 30  say 'F.P.'
      @ prow()  , 35  say 'N.D.Em.'
      @ prow()  , 44  say 'Venc.'
      @ prow()  , 56  say 'Valor.'
      @ prow()  , 67  say 'Status'
      
      @ prow()+1, 04  say '---------'
      @ prow()  , 15  say replicate('-',07)
      @ prow()  , 24  say replicate('-',05)
      @ prow()  , 30  say replicate('-',04)
      @ prow()  , 35  say replicate('-',07)
      @ prow()  , 44  say replicate('-',05)
      @ prow()  , 56  say replicate('-',05)
      @ prow()  , 67  say replicate('-',05)
    else
      @ prow()  , 15  say 'Cod.Cli.'
      @ prow()  , PCOL()+2  say 'Guerra'
      @ prow()  , PCOL()+12 say 'Emissao'
      @ prow()  , PCOL()+5  say 'T.Ven'
      @ prow()  , PCOL()+3  say 'F.P.'
      @ prow()  , PCOL()+2  say 'N.D.Em.'
      @ prow()  , PCOL()+4  say 'Venc.'
      @ prow()  , PCOL()+7  say 'Valor.'
      @ prow()  , PCOL()+4  say 'Status'
       
       @ prow()+1, 04  say '---------'
       @ prow()  , PCOL()+2 say repl('-',7)
       @ prow()  , PCOL()+4  say repl('-',5)
       @ prow()  , PCOL()+12  say repl('-',6)
       @ prow()  , PCOL()+6  say repl('-',5)
       @ prow()  , PCOL()+2  say repl('-',5)
       @ prow()  , PCOL()+2  say repl('-',7)
       @ prow()  , PCOL()+4  say repl('-',5)
       @ prow()  , PCOL()+8  say repl('-',6)
       @ prow()  , PCOL()+4  say repl('-',5)
    endif

return

/*
-----------------------------------------------------------------------------
                      Procedimento  crr1500R1 - Rodape    1
-----------------------------------------------------------------------------
*/
procedure crr1500R1()

    @ prow()+2, 00 say linha78
    @ prow()+1, 00 say ' Total do Dia     : '
    @ prow()  , 23 say W_QT_DIA               picture "999"
    @ prow()  , 27 say 'Nota(s) Fiscal(is): '
    @ prow()  , 47 say W_VL_DIA               picture "@E 9999,999,999.99"
    @ prow()+2, 27 say 'Tot. ICMS.(DIA)...: '
    @ prow()  , 47 say W_ICMS_DIA          picture "@E 9999,999,999.99"
    @ prow()+2, 20 say 'Tot. Base Calculo(DIA)...: '
    @ prow()  , 47 say W_B_CALC_DIA          picture "@E 9999,999,999.99"
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
    @ prow()  , 23 say W_QT_TOT              picture "999"
    @ prow()  , 27 say 'Nota(s) Fiscal(is): '
    @ prow()  , 47 say W_VL_TOT              picture "9999,999,999.99"
    @ prow()+2, 27 say 'Tot.ICMS.(Periodo):'
    @ prow()  , 47 say W_ICMS_TOT         picture "9999,999,999.99"
    @ prow()+2, 16 say 'Tot. Base Calculo(Periodo)...: '
    @ prow()  , 47 say W_B_CALC_TOT          picture "@E 9999,999,999.99"
    @ prow()+1, 00 say linha78

return


/*
 Relatorio por cliente e periodo( CHAVE  )
--------------------------------------------------------------------------
                  Procedimento principal
--------------------------------------------------------------------------
*/
function ab_proc3()
   
   local WRET := .T.
   mensimp("Gerando Relatorio. Aguarde...")
   VEN012->(dbsetorder(3))
   Set Softseek on
   VEN012->( dbseek(dtos(X_DT_INI)+X_NOTAFISCAL),.T.)
   W_VL_TOT      := 0.00
   W_ICMS_TOT := 0.00

   do while ( VEN012->(!eof()) ) .AND. ( VEN012->DT_EMISSAO <= X_DT_FIM ) 
     
     W_DT_ATUAL    := VEN012->DT_EMISSAO
     W_QT_DIA      := 0.00
     W_VL_DIA      := 0.00
     W_ICMS_DIA    := 0.00
     W_PAG         := W_PAG + 1

     crr1500B1(W_TITULO,W_PAG)
     crr1500B2()
      
     do While VEN012->( ! eof() ) 
       if (ven012->dt_emissao <= x_dt_fim)
         ab_det3()
       endif
       VEN012->(dbskip())
    enddo

*   crr1500r1()
   enddo
   crr1500r2()
return

/*
-----------------------------------------------------------------------------
                      Procedimento CABECALHO GERAL
-----------------------------------------------------------------------------
*/
procedure crr1500B1(P_TITPROC,P_PAG)
    
    @ 00      , 00 say linha78
    @ prow()+1, 01 say 'TENAX ACOS ESPECIAIS'
    @ prow()  , 45 say 'Hora: '
    @ prow()  , 51 say (Time())
    @ prow(),   63 say 'Data: ' + dtoc(date())
    @ prow()+1 ,01 say 'Cliente : '+X_CODCLI+'-'+(TRIM(X_RAZAO ))
    @ prow()+1, 01 say 'Pag.: ' + strzero(P_PAG,2)
    
    @ prow(),   int ((( 80-len(alltrim(P_TITPROC)) )/2)) say P_TITPROC
    @ PROW()+1,01 SAY 'Periodo.: ' +  dtoc( X_DT_INI ) + ' a '+ dtoc( X_DT_FIM )
    @ prow()+1, 00 say linha78

return


/*
-----------------------------------------------------------------------------
                      Procedimento CRR1500DET - Linha Detalhe
-----------------------------------------------------------------------------
*/
procedure ab_det3()
    
    X_NOTAFISCAL := replicate ('*',40)
    
    if prow() > 55
       W_PAG := W_PAG + 1
       crr1500B1(W_TITULO,W_PAG)
       crr1500B2()
    end
   
    @ prow()+1, 04  say VEN012->NOTAFISCAL
    @ prow()  , 15  say VEN012->DT_EMISSAO
    @ prow()  , 26  say VEN012->TIPOVENDA
    @ prow()  , 31  say VEN012->FORMAPAG
    @ prow()  , 36  say VEN012->QTDPARC
    @ prow()  , 46  say VEN012->CODVENC
    @ prow()  , 50  say VEN012->VALOR       picture "@E 999,999,999.99"
    @ prow()  , 70  say VEN012->STATUS
 
    if ( VEN012->STATUS != "C" )
       W_QT_DIA   := W_QT_DIA      + 1
       W_QT_TOT   := W_QT_TOT      + 1
       if ( VEN012->STATUS != "D" )
         W_VL_DIA   := W_VL_DIA      + VEN012->VALOR
         W_VL_TOT   := W_VL_TOT      + VEN012->VALOR
       end
       W_ICMS_DIA := W_ICMS_DIA + VEN012->ICMS
       W_ICMS_TOT := W_ICMS_TOT + VEN012->ICMS
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
procedure CRR1500b2()

    @ prow()+2, 04  say 'N. Fiscal'
    @ prow()  , 15  say 'Emissao'
    @ prow()  , 24  say 'T.Ven'
    @ prow()  , 30  say 'F.P.'
    @ prow()  , 35  say 'N.D.Em.'
    @ prow()  , 44  say 'Venc.'
    @ prow()  , 56  say 'Valor.'
    @ prow()  , 67  say 'Status'

    @ prow()+1, 04  say '---------'
    @ prow()  , 15  say replicate('-',07)
    @ prow()  , 24  say replicate('-',05)
    @ prow()  , 30  say replicate('-',04)
    @ prow()  , 35  say replicate('-',07)
    @ prow()  , 44  say replicate('-',05)
    @ prow()  , 56  say replicate('-',05)
    @ prow()  , 67  say replicate('-',05)

return

/*
-----------------------------------------------------------------------------
                      Parametro de Data Inicial / Final
-----------------------------------------------------------------------------
*/
function p_periodo2()
 local WRET:= .T.
  WSCRDUP := savescreen(,,,,)
  setcursor(1)
  X_DT_INI := ctod(' /  /  ')
  X_DT_FIM := ctod(' /  /  ')
  @ 10,14 say 'ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿'
  @ 11,14 say '³                                   ³'
  @ 12,14 say '³ Periodo..:   /  /   a   /  /      ³'
  @ 13,14 say '³                                   ³'
  @ 14,14 say '³ Cliente..:                        ³'
  @ 15,14 say 'ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ'

  @ 12,27 get X_DT_INI picture '99/99/99'
  @ 12,38 get X_DT_FIM picture '99/99/99'
  @ 14,27 get X_CODCLI picture '@!'  
  read
  if lastkey() = K_ESC
    WRET := .F.
  end

  IF !VEN001->( dbseek(X_CODCLI) ) 
    m_tabelas( "X_CODCLI" )
    if lastkey()=K_ESC; WRET:=.F.; end
  END

  IF VEN001->(DBSEEK(X_CODCLI))
    X_RAZAO := VEN001->RAZAO
  END 


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
  SET FILTER TO (CODCLI=X_CODCLI) 

  restscreen(,,,,WSCRDUP )
  setcursor(0)
return WRET

