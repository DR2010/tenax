/*
   TENAX
   EST038.PRG - Listagem de Areas ( TODOS OS CLIENTES )
*/

#include "inkey.ch"
telanum('REL037','REL037')

private linha134 := replicate('-',134)

private W_TITULO := ' '
WRESP_IMP := 'I'
W_IMPARQ  := space(12)


abrir("ESTREPO")
abrir("EST037")
abrir("VEN001")

X_CODAREA  := space(2)

VEN001->( dbgotop() )


      W_TITULO :=  'Clientes de Area <todos os clientes> '

      if dh_imprime(1)
         if WRESP_IMP = 'A'
            ESTREPO->( grava( WIMP_ARQ, date(), time(), W_TITULO, 80) )
         end

         VEN001->( dbsetorder(3) )
         VEN001->( dbgotop() )
         
         W_PAG :=  0
         W_LIN :=  66

         while VEN001->( ! eof() )
            X_CODAREA := VEN001->CODAREA
            if lastkey()=K_ESC
               @ prow()+2,20 say '---Impressao interrompida pelo usuario---'
               exit
            end

            if W_LIN  > 55
               W_PAG++
               R037_CAB(W_PAG)
               R037_TIT(W_TITULO)
               W_LIN := 10
            end

            
            WHILE  VEN001->CODAREA = X_CODAREA
              R037_DET()
              VEN001->( dbskip() )
              W_LIN++
            END
            R037_CAB(W_PAG)
            R037_TIT(W_TITULO)
            end
         end

         dh_impoff()
      end
end


// fim do programa

