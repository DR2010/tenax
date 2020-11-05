/*

   SCM - Sistema de Controle Metalurgico

   REL001.PRG - Listagem do Cadastro de Almoxarifado

*/
#include "inkey.ch"
telanum('SCR91 ','EST91 ')

//
// Arquivos
//
abrir("ESTREPO")
abrir("EST001")


//
// variaveis para controle de impressoes geradas para arquivo
//
private W_TITULO := 'Listagem Cadastro Almoxarifado '
WRESP_IMP := 'I'
W_IMPARQ  := space(12)

//
// condicoes do sistema
//
private condicao := {|| EST001->( ! eof()) }
private detalhe  := {|| det_91() }

//
// corpo do programa
//
if dh_imprime()
   if WRESP_IMP = 'A'
      ESTREPO->( grava( WIMP_ARQ, date(), time(), W_TITULO, 80) )
   end
   cab_91()
   dbeval( detalhe, condicao )
   @ 00,00 say '' // saltar pagina
   dh_impoff()
end
return

// fim do programa

//
// Cabecalho
//
procedure cab_91()
   @ 01      , 00 say PADC( "Listagem do Cadastro de Almoxarifado",78 )
   @ prow()+1, 00 say Replicate('-',78)
   @ prow()+1, 04 say 'Almoxarifado'
   @ prow(), 19 say 'Descricao'
   @ prow()+1, 00 say Replicate('-',78)
return
//
// Linha detalhe
//
procedure det_91()

   if prow() > 60
      cab_91()
   end

   // linha detalhe
   @ prow()+1, 04 say EST001->ALMOXARI
   @ prow()  , 19 say EST001->DESCRICAO

   if lastkey() = K_ESC
      @ prow()+1, 04 say '---Impressao interrompida pelo usuario---'
      EST001->( dbgobottom())
   end
   EST001->( dbskip())
return
/*

		   Listagem do Cadastro de Almoxarifado
 ------------------------------------------------------------------------------
   Almoxarifado   Descricao
 ------------------------------------------------------------------------------

  */




