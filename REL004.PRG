/*

   SCM - Sistema de Controle Metalurgico
   EST94.PRG - Listagem do Cadastro do Tipo de Materiais

   REL004.PRG - Listagem do Cadastro do Tipo de Materiais

*/
#include "inkey.ch"
telanum('SCR94 ','EST94 ')

//
// Arquivos
//
abrir("ESTREPO")
abrir("EST004")

//
// variaveis para controle de impressoes geradas para arquivo
//
private W_TITULO := 'Listagem Cadastro Tipo de Materiais '
WRESP_IMP := 'I'
W_IMPARQ  := space(12)

//
// condicoes do sistema
//
private condicao := {|| EST004->( ! eof()) }
private detalhe  := {|| det_94() }

//
// corpo do programa
//
if dh_imprime()
   if WRESP_IMP = 'A'
      ESTREPO->( grava( WIMP_ARQ, date(), time(), W_TITULO, 80) )
   end
   cab_94()
   dbeval( detalhe, condicao )
   @ 00,00 say '' // saltar pagina
   dh_impoff()
end
return

// fim do programa

//
// Cabecalho
//
procedure cab_94()
   @ 01      , 00 say padc( 'Listagem do Cadastro de Tipo de Materiais',78 )
   @ prow()+1, 00 say Replicate('-',78)
   @ prow()+1, 04 say 'Forma'
   @ prow()  , 10 say 'Tipo'
   @ prow()  , 16 say 'Estado'
   @ prow()  , 26 say 'Descricao'
   @ prow()  , 68 say 'Cor'
   @ prow()+1, 00 say Replicate('-',78)
return
//
// Linha detalhe
//
procedure det_94()

   if prow() > 60
      cab_94()
   end

   // linha detalhe
   @ prow()+1, 04 say EST004->FORMA
   @ prow()  , 10 say EST004->TIPO
   @ prow()  , 16 say EST004->ESTADO
   @ prow()  , 26 say EST004->DESCRICAO
   @ prow()  , 68 say EST004->COR

   if lastkey() = K_ESC
      @ prow()+1, 04 say '---Impressao interrompida pelo usuario---'
      EST004->( dbgobottom())
   end
return

/*

   Forma Tipo  Estado    Descricao                                 Cor
   123   12345 1         xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx  123456789012
   4     10    16        26                                        68

*/
