/*
   TENAX
   EST038.PRG - Listagem de Clientes por Vendedor
*/

#include "inkey.ch"
telanum('REL0381','REL0381')

private linha134 := replicate('-',134),escolha

private W_TITULO := 'Clientes por Vendedor'
WRESP_IMP := 'I'
W_IMPARQ  := space(12)
private X_TIPOCLI := ' '
private S_TIPOCLI := ' '

abrir("ESTREPO")
abrir("VEN001")
abrir("VEN002")

X_CODCLI  := space(05)
X_CODVEN  := space(02)

VEN001->( dbgotop() )
if par_038()

       VEN001->(dbsetfilter({|| VEN001->CODVEN = X_CODVEN .AND. VEN001->CODCLI# '00000'}))
       W_TITULO := 'Clientes por Vend.c/ Tipo..: '+ X_CODVEN + ' - '+VEN002->GUERRA
       if dh_imprime(1)
         if WRESP_IMP = 'A'
            ESTREPO->( grava( WIMP_ARQ, date(), time(), W_TITULO, 80) )
         end
         VEN001->( dbsetorder(4) )
         VEN001->( dbseek( X_CODVEN ) )
         X_TIPOCLI := VEN001->TIPO_CLI
         S_TIPOCLI := VEN001->TIPO_CLI

         VEN001->( dbsetorder(5) )
       *  VEN001->( dbseek( X_CODCLI+X_TIPOCLI ) )
         W_PAG :=  0
         W_LIN :=  10

         while VEN001->( ! eof() ) .AND. VEN001->CODVEN = X_CODVEN
           X_TIPOCLI := VEN001->TIPO_CLI
           S_TIPOCLI := VEN001->TIPO_CLI
           W_PAG++
           R038_CAB(W_PAG)
           R038_TIT(W_TITULO+X_TIPOCLI,X_TIPOCLI)
           while X_TIPOCLI = S_TIPOCLI
              
              VEN002->( dbsetorder(1) )
              VEN002->( dbseek( X_CODVEN ) )
              if lastkey()=K_ESC
                 @ prow()+2,20 say '---Impressao interrompida pelo usuario---'
                 exit
              end
    
                
                 R038_DET()
                 W_LIN+=3
                 VEN001->( dbskip() )
                 S_TIPOCLI := VEN001->TIPO_CLI
                 IF W_LIN >55
                   W_LIN := 10
                   EXIT
                END

            end
          end
         dh_impoff()
      end
end


// fim do programa
