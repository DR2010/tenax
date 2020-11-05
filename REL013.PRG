/*

   SCM - Listagem da tabela de precos
   REL012.PRG

*/

#include "inkey.ch"
telanum('SCR011','REL011')

//
// Arquivos
//
abrir("ESTREPO")
abrir("VEN018")
abrir("VEN019")

//
// variaveis para controle de impressoes geradas para arquivo
//
private W_TITULO := 'Tabela de Precos'
WRESP_IMP := 'I'
W_IMPARQ  := space(12)

//
// condicoes do sistema
//

private linha78 := replicate('-',78)

VEN018->( dbsetorder(1) )
VEN019->( dbsetorder(1) )

while .t.

   @ 10,14 say 'ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿'
   @ 11,14 say '³                                    ³'
   @ 12,14 say '³  Grupo :                           ³'
   @ 13,14 say '³                                    ³'
   @ 14,14 say 'ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ'
   X_GRUPO := '01'
   @ 12,25 get X_GRUPO
   read
   if lastkey()=K_ESC; exit; end

   VEN019->( dbseek( X_GRUPO ))
   if VEN019->( ! found() )
      mensbeep("Grupo nao cadastrado. <ENTER>")
      loop
   end

   if dh_imprime()
      if WRESP_IMP = 'A'
	 ESTREPO->( grava( WIMP_ARQ, date(), time(), W_TITULO, 80) )
      end

      W_PAG :=	0
      W_LIN :=	66

      @ 01,00 say LINHA78
      @ 02,30 say 'Tabela de Precos'
      @ 02,68 say 'Grupo : '+X_GRUPO
      @ 03,00 say LINHA78

      // Imprime COLUNA->DESCRICAO

      X_SUBGRUPO := VEN019->SUBGRUPO

      W_DESC := alltrim(VEN019->DESCRICAO)
      W_TAM := len( W_DESC )
      if 10-W_TAM > 0
	 @ prow()+1,24 say space( 10-W_TAM )+W_DESC
      else
	 @ prow()+1,24 say left(W_DESC,10)
      end

      VEN019->( dbskip() )

      while X_SUBGRUPO = VEN019->SUBGRUPO .and. VEN019->( ! eof() )

	 W_DESC := alltrim(VEN019->DESCRICAO)
	 W_TAM := len( W_DESC )
	 if 10-W_TAM > 0
	    @ prow(),pcol()+1 say space( 10-W_TAM )+W_DESC
	 else
	    @ prow(),pcol()+1 say left(W_DESC,10)
	 end
	 VEN019->( dbskip() )
      end

      VEN019->( dbseek( X_GRUPO ))

      while X_GRUPO = VEN019->GRUPO .and. VEN019->( ! eof() )

	 inkey()
	 if lastkey()=K_ESC
	    @ prow()+2,20 say '---Impressao interrompida pelo usuario---'
	    exit
	 end
	 @ prow()+1,00 say LINHA78

	 VEN018->( dbseek( VEN019->GRUPO+VEN019->SUBGRUPO ) )
	 @ prow()+1, 01 say left( VEN018->DESCRICAO, 20 )

	 @ prow(),   28 say VEN019->PRECO picture '999.99'

	 VEN019->( dbskip() )
	 X_SUBGRUPO := VEN019->SUBGRUPO

	 while X_GRUPO+X_SUBGRUPO = VEN019->GRUPO+VEN019->SUBGRUPO .and. ;
	       VEN019->( ! eof() )
	    @ prow(),pcol()+ 5 say VEN019->PRECO picture '999.99'
	    VEN019->( dbskip() )
	 end

      end

      @ 01,01 say ''

      dh_impoff()
      exit
   end
end
return

