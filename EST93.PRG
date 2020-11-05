/*

   SCM - Sistema de Controle Metalurgico
   EST93.PRG - Listagem do Cadastro de Formas dos Materiais

*/
setcancel(.t.)
altd(1)
abrir("EST003")
#include "inkey.ch"
telanum('SCR93 ','EST93 ')

// condicoes do sistema
private condicao := {|| EST003->( ! eof()) }
private detalhe  := {|| det_93() }

//
// corpo do programa
//
if dh_imprime()
   cab_93()
   dbeval( detalhe, condicao )
   @ 00,00 say '' // saltar pagina
   dh_impoff()
end
return

// fim do programa

//
// Cabecalho
//
procedure cab_93()
   @ 01      , 00 say padc( 'Listagem do Cadastro de Formas dos Materiais',78 )
   @ prow()+1, 00 say Replicate('-',78)
   @ prow()+1, 04 say 'Forma'
   @ prow()  , 10 say 'Descricao'
   @ prow()  , 33 say 'Medida do Material'
   @ prow()  , 54 say 'Medida do Corte'
   @ prow()+1, 00 say Replicate('-',78)
return
//
// Linha detalhe
//
procedure det_93()

   if prow() > 60
      cab_93()
   end

   // linha detalhe
   @ prow()+1, 04 say EST003->FORMA
   @ prow()  , 10 say EST003->DESCRICAO
   @ prow()  , 33 say EST003->P_MATERIAL
   @ prow()  , 54 say EST003->P_CORTE

   if lastkey() = K_ESC
      @ prow()+1, 04 say '---Impressao interrompida pelo usuario---'
      EST003->( dbgobottom())
   end
   EST003->( dbskip())
return

/*
                 Listagem do Cadastro de Formas dos Materiais
 ------------------------------------------------------------------------------
 Forma   Descricao              Medida do Material   Medida do Corte
 ------------------------------------------------------------------------------
 123     12345678901234567890   1                    1
 2       10                     33                   54

*/

