/*

   CONTAS A RECEBER
   SRR1700.PRG - Relatorio de Cheques Detalhado

*/

#include "inkey.ch"

telanum('SRR1700','SRR1700')

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

private linha134 := replicate('-',133)


private W_TITULO := 'Cheques C/R'
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

if SPARA_periodo()
   if dh_imprime(1)
      if WRESP_IMP = 'A'
         ESTREPO->( grava( WIMP_ARQ, date(), time(), W_TITULO, 80) )
      end
      SRR1700proc()
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
function SRR1700proc()

local WRET := .T.

mensimp("Gerando Relatorio. Aguarde...")

SR0600->(dbsetorder(3))
Set Softseek on
if !(SR0600-> (dbseek("P"+dtos(S_DT_INI)),.T.) )
    @ prow()+2,20 say '---Nao existe Cheques para o periodo--'
    WRET := .F.
    return WRET
end

do while ( SR0600->(!eof())               ) .and. ;
         ( SR0600->DT_PREDATA <= S_DT_FIM )
         
     //    ( SR0600->STATUS      = "P"      ) .and. ;

         W_QT_DIA   := 0.00
         W_VL_DIA   := 0.00
         W_PAG      := W_PAG + 1

         SRR1700c1(W_TITULO,W_PAG)
         SRR1700C2(.t.)         
         do while ( SR0600->(!eof())                 ) .and. ;
                  ( SR0600->DT_PREDATA <= S_DT_FIM   )
             //   ( SR0600->STATUS      = "P"        ) .and. ;
                  SRR1700det()

                  if prow() > 55
                     W_PAG := W_PAG + 1
                     SRR1700C1(W_TITULO,W_PAG)
                     
                  end

                  SR0600->(dbskip())
                 IF SR0600->(!EOF() )
                   SRR1700C2(.f.)
                 end
         enddo

         SRR1700R1()
enddo

SRR1700R2()

return

/*
-----------------------------------------------------------------------------
                      Procedimento CABECALHO GERAL
-----------------------------------------------------------------------------
*/
procedure SRR1700C1(P_TITPROC,P_PAG)

    
    @ 00      , 00 say linha134
    @ prow()+1, 102 say 'Data: ' + dtoc(date())
    @ prow()+1, 00 say '   TENAX ACOS ESPECIAIS'
    @ prow()  ,102 say 'Hora: '
    @ prow()  ,108 say (Time())
    @ prow()  ,124 say 'Pag.: ' + strzero(P_PAG,2)
    @ prow()+1, int ((( 136-len(alltrim(P_TITPROC)) )/2)) say P_TITPROC
    @ prow()  ,102 say 'Periodo.:' +  dtoc( S_DT_INI )
    @ prow()  ,119 say ' a '
    @ prow()  ,123 say dtoc( S_DT_FIM )
    @ prow()+1, 00 say linha134
return

/*
-----------------------------------------------------------------------------
                      Procedimento  SRR1700Cab2 - Cabecalho 2
-----------------------------------------------------------------------------
*/
procedure SRR1700C2(d)

    if d
      @ prow()+1, 01  say 'Data: ' + dtoc(SR0600->DT_PREDATA)
    end

    @ prow()+2, 01        say 'Banco'
    @ prow()  , pcol()+01 say 'Agencia'
    @ prow()  , pcol()+01 say 'Conta'
    @ prow()  , pcol()+08 say 'Nome/'+;
                               IF(LEN(ALLTRIM(SR0600->CGC))<14,'CPF','CGC')
    @ prow()  , pcol()+42 say 'Dupl.'
    @ prow()  , pcol()+05 say 'Cliente'
    @ prow()  , pcol()+18 say 'Bom para'

    @ prow()+1, 01        say replicate('-',05)
    @ prow()  , pcol()+01 say replicate('-',07)
    @ prow()  , pcol()+01 say replicate('-',05)
    @ prow()  , pcol()+08 say replicate('-',49)
    @ prow()  , pcol()+01 say replicate('-',08)
    @ prow()  , pcol()+02 say replicate('-',18)
    @ prow()  , pcol()+07 say replicate('-',08)

return

/*
-----------------------------------------------------------------------------
                      Procedimento SRR1700DET - Linha Detalhe
-----------------------------------------------------------------------------
*/
procedure SRR1700DET()

    X_CODCLI := replicate ('*',05)
    S_GUERRA := replicate ('*',15)

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
       SRR1700C1(W_TITULO,W_PAG)
       SRR1700C2()
    end

    @ prow()+1,      02 say SR0600->CODBANCO
    @ prow(), pcol()+02 say SR0600->CODAGENCIA
    @ prow(), pcol()+02 say SR0600->NR_CONTA
    @ prow(), PCOL()+02 say SR0600->NOME+'-' 
    if LEN(ALLTRIM(SR0600->CGC))<14
      @ prow(), pcol() say TRANSFORM(SR0600->CPF,"@R 999.999.999-99")+'    '
    ELSE
      @ prow(), pcol() say TRANSFORM(SR0600->CGC,"@R 99.999.999/9999-99")
    END
    
    @ prow(), pcol()+02 say SR0600->DUPLICATA
    if SR0600->SEQUENCIA = " "
       @ prow(), pcol()+02 say SR0600->SEQUENCIA
    else
       @ prow(), pcol()+01 say "/" + SR0600->SEQUENCIA
    end
    
    @ prow()  , pcol()+02 say VEN001->CODCLI + ' - '
    @ prow()  , PCOL()    say VEN001->GUERRA
    @ prow()  , pcol()+02 say SR0600->DT_PREDATA
    @ prow()+1, 00        say linha134

    SRR1700C3()
    SRR1700DE2()
    
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
                      Procedimento  SRR1700R1 - Rodape    1
-----------------------------------------------------------------------------
*/
procedure SRR1700R1()

    @ prow()+2, 00 say linha134
    @ prow()+1, 00 say ' Total do Dia     : '
    @ prow()  , 24 say W_QT_DIA  picture "999"
    @ prow()  , 28 say 'Cheque(s) '
    @ prow()  , 40 say W_VL_DIA  picture "@E 9999,999,999.99"
    @ prow()+1, 00 say linha134

return

/*
-----------------------------------------------------------------------------
                      Procedimento  SRR1700R2 - Rodape    2
-----------------------------------------------------------------------------
*/
procedure SRR1700R2()

    @ prow()+1, 00 say linha134
    @ prow()+1, 00 say ' Total do Periodo : '
    @ prow()  , 24 say W_QT_PER  picture "999"
    @ prow()  , 28 say 'Cheque(s) '
    @ prow()  , 40 say W_VL_PER  picture "@E 9999,999,999.99"
    @ prow()+1, 00 say linha134

return

procedure SRR1700C3()    
    @ prow()+1, 01        say 'Valor'
    @ prow()  , pcol()+12 say 'Dest/nome'
    @ prow()  , pcol()+15 say 'Dest/data'
    
    @ prow()+1, 01        say replicate('-',15)
    @ prow()  , pcol()+02 say replicate('-',21)
    @ prow()  , pcol()+02 say replicate('-',09)
return
    


procedure SRR1700DE2()    
    @ prow()+1, 00        say SR0600->VALOR       picture "@E 9999,999,999.99"
    @ prow()  , pcol()+03 say SR0600->DEST_NOME
    @ prow()  , pcol()+03 say SR0600->DEST_DATA   picture "99/99/99"
    @ prow()+1, 00 say repl('=',133)
return
