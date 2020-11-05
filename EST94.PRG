/*

   SCM - Sistema de Controle Metalurgico
   EST94.PRG - Listagem do Cadastro do Tipo de Materiais

*/
setcancel(.t.)
altd(1)
#include "inkey.ch"
abrir("EST004")
telanum('SCR94 ','EST94 ')

// condicoes do sistema
private condicao := {|| EST004->( ! eof()) }
private detalhe  := {|| det_94() }

//
// corpo do programa
//
if dh_imprime()
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
   @ prow()  , 13 say 'Tipo'
   @ prow()  , 21 say 'Estado'
   @ prow()  , 31 say 'Descricao'
   @ prow()  , 60 say 'Cor'
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
   @ prow()  , 13 say EST004->TIPO
   @ prow()  , 21 say EST004->ESTADO
   @ prow()  , 31 say EST004->DESCRICAO
   @ prow()  , 60 say EST004->COR

   if lastkey() = K_ESC
      @ prow()+1, 04 say '---Impressao interrompida pelo usuario---'
      EST004->( dbgobottom())
   end
   EST004->( dbskip())
return

/*
   4        13      21        31                           60
   Forma    Tipo    Estado    Descricao                    Cor
   123      12345   1         1234567890123456789012345    123456789012
*/

