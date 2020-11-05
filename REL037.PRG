/*
   TENAX
   EST037.PRG - Listagem de Areas
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

PRIVATE X_CODAREA  := space(2)

VEN001->( dbgotop() )
a := pergresp( "(A)reas/Areas com (T)odos os clientes (A/T) ?","AT")
if a = 'A'
 if par_037()

      W_TITULO :=  'Clientes da Area '+X_CODAREA

      if dh_imprime(1)
         if WRESP_IMP = 'A'
            ESTREPO->( grava( WIMP_ARQ, date(), time(), W_TITULO, 80) )
         end

         VEN001->( dbsetorder(3) )

           VEN001->( dbseek( X_CODAREA ),.T.)


         W_PAG :=  0
         W_LIN :=  66

         while VEN001->( ! eof() )

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

            W_LIN++

            R037_DET()

            VEN001->( dbskip() )

            if X_CODAREA # '99'
               if VEN001->CODAREA # X_CODAREA
                  exit
               end
            end
         end

         dh_impoff()
      end
  end
else
 VEN001->( dbsetorder(3) )
 VEN001->( dbgotop() )
 W_TITULO :=  'Clientes de Area <todos os clientes> '
 relt37()
end

// fim do programa


//-----------------------------------------------------------------------------
                             function par_037()
//-----------------------------------------------------------------------------

local WRET := .T.

@ 10,15 say 'ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄ Parametro de Impressao ÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿'
@ 11,15 say '³                                                    ³'
@ 12,15 say '³ Area...........:                                   ³'
@ 13,15 say '³                                                    ³'
@ 14,15 say '³                                                    ³'
@ 15,15 say 'ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ'

@ 12,34 get X_CODAREA    picture '99' valid tes_codarea(12,34,20)
read
if lastkey() = K_ESC
   WRET := .F.
end

if X_CODAREA = "99"
   X_CODAREA := ""
end

return WRET

/*
-----------------------------------------------------------------------------
                      Procedimento R037_CAB
-----------------------------------------------------------------------------
*/
procedure R037_CAB( P_PAG )

    @ 01      , 00 say linha134
    @ prow()+1, 00 say '   TENAX ACO E FERRO '
    @ prow()+1, 27 say 'Data: ' + dtoc(date())
    @ prow()  , 45 say 'Pag.: ' + strzero(P_PAG,3)
    @ prow()  , 60 say 'Hora: '
    @ prow()  , 66 say (Time())
    @ prow()+1, 00 say linha134

return

/*
-----------------------------------------------------------------------------
                      Procedimento R037_TIT
-----------------------------------------------------------------------------
*/
procedure R037_TIT( P_TITPROC )

    @ prow()+1, int ((( 136-len(alltrim(P_TITPROC)) )/2)) say P_TITPROC
    @ prow()+1, 00 say linha134

    @ prow()+2, 00  say 'Cliente'
    @ prow()  , 10  say 'Nome de Guerra'
    @ prow()  , 30  say 'DDD.'
    @ prow()  , 36  say 'Telefone'
    @ prow()  , 46  say 'Contato'
    @ prow()  , 67  say 'Bairro'
    @ prow()  , 83  say 'Municipio'
    @ prow()  , 99  say 'Es'
    @ prow()  , 103 say 'Vendedor'
    @ prow()+1, 00  say linha134
return

/*
-----------------------------------------------------------------------------
                      Procedimento R037_DET
-----------------------------------------------------------------------------
*/
procedure R037_DET()
  IF VEN001->CODCLI # '00000'
    @ prow()+1,00  say VEN001->CODCLI
    @ prow()  ,10  say VEN001->GUERRA
    @ prow()  ,30  say VEN001->DDD01     picture '9999'
    @ prow()  ,36  say VEN001->TEL01     picture '999999999'
    @ prow()  ,46  say left(VEN001->CONTATO01,20)
    @ prow()  ,67  say left(VEN001->BAIRRO,15)
    @ prow()  ,83  say left(VEN001->MUNICIPIO,15)
    @ prow()  ,99  say VEN001->ESTADO
    @ prow()  ,103 say VEN001->CODVEN
    @ prow()+1,67  say left(VEN001->ENDERECO,40)
  END
return



procedure relt37()

  X_CODAREA := VEN001->CODAREA
  W_TITULO  := 'Clientes da Area '+X_CODAREA
  if dh_imprime(1)
    if WRESP_IMP = 'A'
      ESTREPO->( grava( WIMP_ARQ, date(), time(), W_TITULO, 80) )
    end

    W_PAG := 0
    W_LIN := 66

    while VEN001->( ! eof() )
       WHILE X_CODAREA = VEN001->CODAREA
         if W_LIN  > 55
           W_PAG++
           R037_CAB(W_PAG)
           R037_TIT(W_TITULO)
           W_LIN := 10
         end

         R037_DET()
         W_LIN++
         VEN001->( dbskip() )
         IF X_CODAREA # VEN001->CODAREA .AND. VEN001->(!EOF())
           X_CODAREA := VEN001->CODAREA
           W_TITULO  := 'Clientes da Area '+X_CODAREA
           R037_CAB(W_PAG)
           R037_TIT(W_TITULO)
           EXIT
         END
     END
   END
 end
 dh_impoff()
return
// fim do programa
