/*
   TENAX
   VEN100.PRG - Listagem de Clientes POR ENDERECO
*/

#include "inkey.ch"
telanum('VEN100','VEN100')

private linha134 := replicate('-',80)

abrir("VEN001")
abrir("ESTREPO")

VEN001->( dbgotop() )

if dh_imprime(1)

   W_PAG :=  0
   W_LIN :=  66

   while VEN001->( ! eof() )

      if lastkey()=K_ESC
	 @ prow()+2,20 say '---Impressao interrompida pelo usuario---'
	 exit
      end

      if W_LIN  > 55
	 W_PAG++
	 R100_CAB (W_PAG)
	 R100_TIT (' Clientes por Endereco ')
	 W_LIN := 10
      end

      W_LIN++

      R100_DET()

      VEN001->( dbskip() )
   end

   dh_impoff()
end

// fim do programa


/*
-----------------------------------------------------------------------------
		      Procedimento R100_CAB
-----------------------------------------------------------------------------
*/
procedure R100_CAB( P_PAG )

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
		      Procedimento R100_TIT
-----------------------------------------------------------------------------
*/
procedure R100_TIT( P_TITPROC )

    @ prow()+1, int ((( 80 - len(alltrim(P_TITPROC)) )/2)) say P_TITPROC
    @ prow()+1, 00 say linha134

    @ prow()+2, 00 say 'Cod.'
    @ prow()  , 07 say 'Nome de Guerra'
    @ prow()  , 23 say 'Endereco'
    @ prow()  , 59 say 'Tp.Cli'
    @ prow()  , 66 say 'Cep'
    @ prow()  , 70 say 'Vendedor'
    @ prow()+1, 00 say linha134
return

/*
-----------------------------------------------------------------------------
		      Procedimento R100_DET
-----------------------------------------------------------------------------
*/
procedure R100_DET()
    IF VEN001->CODCLI <>'00000'
      @ prow()+1, 00 say VEN001->CODCLI
      @ prow()  , 07 say VEN001->GUERRA
      @ prow()  , 23 say VEN001->ENDERECO
      @ prow()  , 64 say VEN001->TIPO_CLI
      @ prow()  , 66 say VEN001->CEP      picture "@R 99999-999"
      @ prow()  , 76 say VEN001->CODVEN
    END

return
