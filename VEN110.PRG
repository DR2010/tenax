/*
   TENAX
   VEN110.PRG - Listagem de Clientes POR RAZAO
*/

#include "inkey.ch"
telanum('VEN110','VEN110')

private linha134 := replicate('-',80)

abrir("VEN001")
abrir("ESTREPO")

X_RAZAO := space(50)

VEN001->( dbgotop() )

if dh_imprime(1)

   W_PAG :=  0
   W_LIN :=  66

   VEN001->( Dbsetorder(2) )

   while VEN001->( ! eof() )

      if lastkey()=K_ESC
	 @ prow()+2,20 say '---Impressao interrompida pelo usuario---'
	 exit
      end

      if W_LIN  > 55
	 W_PAG++
	 R110_CAB (W_PAG)
	 R110_TIT (' Clientes por Razao ')
	 W_LIN := 10
      end

      W_LIN++

      R110_DET()

      VEN001->( dbskip() )
   end

   dh_impoff()
end

// fim do programa


/*
-----------------------------------------------------------------------------
		      Procedimento R110_CAB
-----------------------------------------------------------------------------
*/
procedure R110_CAB( P_PAG )

    @ 01      , 00 say linha134
    @ prow()+1, 00 say 'TENAX ACOS ESPECIAIS '
    @ prow()+1, 40 say 'Data: ' + dtoc(date())
    @ prow()  , 55 say 'Pag.: ' + strzero(P_PAG,3)
    @ prow()  , 66 say 'Hora: '
    @ prow()  , 72 say (Time())
    @ prow()+1, 00 say linha134


return

/*
-----------------------------------------------------------------------------
		      Procedimento R110_TIT
-----------------------------------------------------------------------------
*/
procedure R110_TIT( P_TITPROC )

    @ prow()+1, int ((( 80 - len(alltrim(P_TITPROC)) )/2)) say P_TITPROC
    @ prow()+1, 00 say linha134

    @ prow()+2, 00 say 'Cod.'
    @ prow()  , 07 say 'Razao'
    @ prow()  , 59 say 'Tp.Cli'
    @ prow()  , 66 say 'Cep'
    @ prow()  , 70 say 'Vendedor'
    @ prow()+1, 00 say linha134
return

/*
-----------------------------------------------------------------------------
		      Procedimento R110_DET
-----------------------------------------------------------------------------
*/
procedure R110_DET()
    IF VEN001->CODCLI <> '00000'
      @ prow()+1, 00 say VEN001->CODCLI
      @ prow()  , 07 say VEN001->RAZAO
      @ prow()  , 64 say VEN001->TIPO_CLI
      @ prow()  , 66 say VEN001->CEP      picture "@R 99999-999"
      @ prow()  , 76 say VEN001->CODVEN
    END

return

