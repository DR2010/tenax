/*

   SCM - Sistema de Controle Metalurgico

   REL045.PRG - Listagem do Cadastro de Areas
*/
#include "inkey.ch"
telanum('SCE037','EST037')

abrir("EST037")
abrir("ESTREPO")


//
// variaveis para controle de impressoes geradas para arquivo
//
private W_TITULO := 'Listagem Cadastro de Areas'
WRESP_IMP := 'I'
W_IMPARQ  := space(12)

//
// condicoes do sistema
//
private condicao := {|| EST037->( ! eof()) }
private detalhe  := {|| det_37() }

//
// corpo do programa
//
if dh_imprime(1)
   if WRESP_IMP = 'A'
      ESTREPO->( grava( WIMP_ARQ, date(), time(), W_TITULO, 80) )
   end
   cab_37()
   dbeval( detalhe, condicao )
   @ 00,00 say '' // saltar pagina
   dh_impoff()
end
return

// fim do programa

//
// Cabecalho
//
procedure cab_37()
   @ 01      , 00 say PADC( "Listagem do Cadastro de Areas",78 )
   @ prow()+1, 00 say Replicate('-',130)
   @ prow()+1, 02 say 'Area'
   @ prow(), 08 say 'Descricao'
   @ prow()+1, 00 say Replicate('-',130)
return
//
// Linha detalhe
//
procedure det_37()

   if prow() > 60
      cab_37()
   end

   // linha detalhe
   @ prow()+1, 04 say EST037->CODAREA
   @ prow()  , 08 say strtran(EST037->DESCRICAO,chr(13),'')

   if lastkey() = K_ESC
      @ prow()+1, 04 say '---Impressao interrompida pelo usuario---'
      EST037->( dbgobottom())
   end
   EST037->( dbskip())
return

