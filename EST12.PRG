/*

   SCM - Sistema de Controle Metalurgico
   EST12.PRG - Cadastro de Fornecedores

*/

#include "inkey.ch"

abrir("EST002")
telanum('SCR012','EST012')

X_FORNECEDOR  := space(03)
X_FGUERRA     := space(12)
X_DESCRICAO   := space(55)
X_INSC_EST    := space(16)
X_CGC	      := space(14)
X_ENDERECO    := space(57)
X_DDD1	      := space(04)
X_DDD2	      := space(04)
X_DDD3	      := space(04)
X_DDD4	      := space(04)
X_TEL01       := space(10)
X_TEL02       := space(10)
X_TEL03       := space(10)
X_TEL04       := space(10)
X_CONTATO     := space(21)
X_BAIRRO      := space(20)
X_CIDADE      := space(20)
X_CEP	      := space(08)
X_ESTADO      := space(02)
X_OBS1	      := space(57)
X_OBS2	      := space(71)
X_OBS3	      := space(71)

// --> Inicio

setcolor(W_COREDIT)

While .T.

   status(' F o r n e c e d o r ')

   tela_12()
   zera_12()
   @ 04,21 get X_FORNECEDOR picture "@!" valid tes_forn( zerofill( X_FORNECEDOR ), 400 )
   read

   if lastkey()=K_ESC; exit; end

   if empty( X_FORNECEDOR )
      m_tabelas("X_FORNECEDOR")
      if lastkey()=K_ESC; loop; end
   end

   EST002->( dbseek(X_FORNECEDOR))

   if EST002->( found() )
      show_12()
      W_RESP := esp_alt()
      do case
      case W_RESP = "*"
	 exit
      case W_RESP = "A"
	 atribui_12()
	 while .t.
	    if get_12()
	       if pergunta('Confirma Dados ? ')
		  grava_12('A')
		  exit
	       end
	    else
	       exit
	    end

	 end
      case W_RESP = "E"
         if pergunta( 'Confirma Exclus„o ? ')
	    while EST002->( ! rlock() ); end
	    EST002->( dbdelete() )
	    EST002->( dbunlock() )
	 end
      end
   else
      while .t.
	 if ! get_12()
	    exit
	 end
	 if pergunta('Confirma Dados (S/N) ? ')
	    grava_12('I')
	    exit
	 end
      end
   end

end

dbcloseall()

// --> Fim

/*
-----------------------------------------------------------------------------
			     Procedimento Tela
-----------------------------------------------------------------------------
*/
procedure TELA_12()
telanum('SCR012','EST012')
   @ 02,02 say 'ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿'
   @ 03,02 say '³                                                                          ³'
   @ 04,02 say '³  Fornecedor....:                                                         ³'
   @ 05,02 say '³  Nome de Guerra:                          Contato:                       ³'
   @ 06,02 say '³                                                                          ³'
   @ 07,02 say '³  Raz„o Social:                                                           ³'
   @ 08,02 say '³                                                                          ³'
   @ 09,02 say '³  C.G.C.      :                        Inscric. Estadual:                 ³'
   @ 10,02 say '³                                                                          ³'
   @ 11,02 say '³  Endere‡o    :                                                           ³'
   @ 12,02 say '³                                                                          ³'
   @ 13,02 say '³  Bairro      :                        Cidade  :                          ³'
   @ 14,02 say '³                                                                          ³'
   @ 15,02 say '³  Estado      :                        C.E.P.  :                          ³'
   @ 16,02 say '³                                                                          ³'
   @ 17,02 say '³  Telefone   1 (    )               3 (    )                              ³'
   @ 18,02 say '³             2 (    )             FAX (    )                              ³'
   @ 19,02 say '³  Observa‡”es :                                                           ³'
   @ 20,02 say '³                                                                          ³'
   @ 21,02 say '³                                                                          ³'
   @ 22,02 say 'ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ'

return

/*
-----------------------------------------------------------------------------
		      Funcao GET_12
-----------------------------------------------------------------------------
*/
function get_12()
   local WRET := .T.

   status(' F o r n e c e d o r ')

   @ 05,21 get X_FGUERRA   picture "@!"
   @ 05,55 get X_CONTATO   picture "@!"
   @ 07,19 get X_DESCRICAO picture "@!"
   @ 09,19 get X_CGC	   picture "@R 99.999.999/9999-99" valid testa_cgc( X_CGC )
   @ 09,61 get X_INSC_EST  picture "@9"
   @ 11,19 get X_ENDERECO  picture "@!"
   @ 13,19 get X_BAIRRO    picture "@!"
   @ 13,52 get X_CIDADE    picture "@!"
   @ 15,19 get X_ESTADO    picture "@!"
   @ 15,52 get X_CEP	   picture "@R 99999-999"
   @ 17,19 get X_DDD1      picture "@!"
   @ 17,25 get X_TEL01     picture "@!"
   @ 17,42 get X_DDD2      picture "@!"
   @ 17,48 get X_TEL02     picture "@!"
   @ 18,19 get X_DDD3      picture "@!"
   @ 18,25 get X_TEL03     picture "@!"
   @ 18,42 get X_DDD4      picture "@!"
   @ 18,48 get X_TEL04     picture "@!"
   @ 19,19 get X_OBS1	   picture "@!"
   @ 20,05 get X_OBS2	   picture "@!"
   @ 21,05 get X_OBS3	   picture "@!"
   read

   if lastkey() = K_ESC
      if pergunta('Abandona Altera‡”es ? ')
	 WRET := .F.
      else
	 WRET := .T.
      end
   end

return WRET

/*
-----------------------------------------------------------------------------
		      Funcao SHOW_12
-----------------------------------------------------------------------------
*/
procedure SHOW_12()

   @ 05,21 say EST002->FGUERRA	 picture "@!"
   @ 05,55 say EST002->CONTATO   picture "@!"
   @ 07,19 say EST002->DESCRICAO picture "@!"
   @ 09,19 say EST002->CGC	 picture "@R 99.999.999/9999-99"
   @ 09,61 say EST002->INSC_EST  picture "@9"
   @ 11,19 say EST002->ENDERECO  picture "@!"
   @ 13,19 say EST002->BAIRRO	 picture "@!"
   @ 13,52 say EST002->CIDADE	 picture "@!"
   @ 15,19 say EST002->ESTADO	 picture "@!"
   @ 15,52 say EST002->CEP	 picture "@R 99999-999"
   @ 17,19 say EST002->DDD1      picture "@!"
   @ 17,25 say EST002->TEL01     picture "@!"
   @ 17,42 say EST002->DDD2      picture "@!"
   @ 17,48 say EST002->TEL02     picture "@!"
   @ 18,19 say EST002->DDD3      picture "@!"
   @ 18,25 say EST002->TEL03     picture "@!"
   @ 18,42 say EST002->DDD4      picture "@!"
   @ 18,48 say EST002->TEL04     picture "@!"
   @ 19,19 say EST002->OBS1	 picture "@!"
   @ 20,05 say EST002->OBS2	 picture "@!"
   @ 21,05 say EST002->OBS3	 picture "@!"

return

/*
-----------------------------------------------------------------------------
		      Funcao ZERA_12
-----------------------------------------------------------------------------
*/
procedure zera_12()

   X_FORNECEDOR  := space(03)
   X_FGUERRA	 := space(12)
   X_DESCRICAO	 := space(55)
   X_CGC	 := space(14)
   X_INSC_EST	 := space(16)
   X_ENDERECO	 := space(57)
   X_DDD1	 := space(04)
   X_DDD2	 := space(04)
   X_DDD3	 := space(04)
   X_DDD4	 := space(04)
   X_TEL01       := space(10)
   X_TEL02       := space(10)
   X_TEL03       := space(10)
   X_TEL04       := space(10)
   X_CONTATO     := space(21)
   X_BAIRRO	 := space(20)
   X_CIDADE	 := space(20)
   X_CEP	 := space(08)
   X_ESTADO	 := space(02)
   X_OBS1	 := space(57)
   X_OBS2	 := space(71)
   X_OBS3	 := space(71)

return

/*
-----------------------------------------------------------------------------
		      Funcao ATRIBUI_12
-----------------------------------------------------------------------------
*/
procedure atribui_12()

   X_FORNECEDOR   := EST002->FORNECEDOR
   X_FGUERRA	  := EST002->FGUERRA
   X_DESCRICAO	  := EST002->DESCRICAO
   X_CGC	  := EST002->CGC
   X_INSC_EST	  := EST002->INSC_EST
   X_ENDERECO	  := EST002->ENDERECO
   X_DDD1	  := EST002->DDD1
   X_DDD2	  := EST002->DDD2
   X_DDD3	  := EST002->DDD3
   X_DDD4	  := EST002->DDD4
   X_TEL01	  := EST002->TEL01
   X_TEL02	  := EST002->TEL02
   X_TEL03	  := EST002->TEL03
   X_TEL04	  := EST002->TEL04
   X_CONTATO	  := EST002->CONTATO
   X_BAIRRO	  := EST002->BAIRRO
   X_CIDADE	  := EST002->CIDADE
   X_CEP	  := EST002->CEP
   X_ESTADO	  := EST002->ESTADO
   X_OBS1	  := EST002->OBS1
   X_OBS2	  := EST002->OBS2
   X_OBS3	  := EST002->OBS3

return

/*
-----------------------------------------------------------------------------
		      Funcao GRAVA_12()
-----------------------------------------------------------------------------
*/
procedure GRAVA_12( MODO )

   if MODO = "I"
      EST002->( dbappend() )
   else
      EST002->( loc(0) )
   end

   EST002->FORNECEDOR := X_FORNECEDOR
   EST002->FGUERRA    := X_FGUERRA
   EST002->DESCRICAO  := X_DESCRICAO
   EST002->CGC	      := X_CGC
   EST002->INSC_EST   := X_INSC_EST
   EST002->ENDERECO   := X_ENDERECO
   EST002->DDD1       := X_DDD1
   EST002->DDD2       := X_DDD2
   EST002->DDD3       := X_DDD3
   EST002->DDD4       := X_DDD4
   EST002->TEL01      := X_TEL01
   EST002->TEL02      := X_TEL02
   EST002->TEL03      := X_TEL03
   EST002->TEL04      := X_TEL04
   EST002->CONTATO    := X_CONTATO
   EST002->BAIRRO     := X_BAIRRO
   EST002->CIDADE     := X_CIDADE
   EST002->CEP	      := X_CEP
   EST002->ESTADO     := X_ESTADO
   EST002->OBS1       := X_OBS1
   EST002->OBS2       := X_OBS2
   EST002->OBS3       := X_OBS3

   EST002->( dbunlock() )

return

* ----------> Fim do meu programa

