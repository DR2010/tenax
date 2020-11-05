/*

   SCM - Sistema de Controle Metalurgico
   EST92.PRG - Listagem do Cadastro de Fornecedor

*/
setcancel(.t.)
altd(1)
abrir("EST002")
#include "inkey.ch"
telanum('SCR92 ','EST92 ')

// condicoes do sistema
private condicao := {|| EST002->( ! eof() ) }
private detalhe  := {|| det_92() }

//
// corpo do programa
//
if dh_imprime()
   cab_92()
   dbeval( detalhe, condicao )
   @ 00,00 say '' // saltar pagina
   dh_impoff()
end
return

// fim do programa

//
// Cabecalho
//
procedure cab_92()
   @ 01      , 00 say PADC( "Listagem do Cadastro de Fornecedor",78 )
return

//
// Linha detalhe
//
procedure det_92()

   if prow() > 62
      cab_92()
   end

   // linha detalhe
   @ prow()+2,        00 say Replicate('=',78)
   @ prow()+1,        00 say "Fornecedor:"
   @ prow()  , pcol()+01 say EST002->FORNECEDOR
   @ prow()+1,        00 say "Descricao_:"
   @ prow()  , pcol()+01 say EST002->DESCRICAO
   @ prow()+2,        00 say "Endereco__:"
   @ prow()  , pcol()+01 say alltrim( EST002->ENDERECO )
   @ prow()  , pcol()+01 say EST002->BAIRRO
   @ prow()+1,        00 say "Cidade____:"
   @ prow()  ,        12 say EST002->CIDADE
   @ prow()  ,        35 say "UF:"
   @ prow()  , pcol()+01 say EST002->ESTADO
   @ prow()  , pcol()+03 say "CEP:"
   @ prow()  , pcol()+01 say EST002->CEP picture "@R 99999-999"
   @ prow()+1,        00 say "Telefone__:"
   @ prow()  , pcol()+01 say "("
   @ prow()  , pcol()+01 say alltrim( EST002->DDD1 )
   @ prow()  , pcol()+01 say ")"
   @ prow()  , pcol()+01 say EST002->TEL01 picture "@R 999-9999"
   @ prow()  ,        35 say "Contato:"
   @ prow()  , pcol()+01 say EST002->CONTATO
   @ prow()+2,        00 say "Obs_______:"
   @ prow()  , pcol()+01 say EST002->OBS1

   if lastkey() == K_ESC
      @ prow()+1, 04 say '---Impressao interrompida pelo usuario---'
      EST002->( dbgobottom() )
   endif
   EST002->( dbskip() )

return

/*


                        Listagem do Cadastro de Fornecedor
==============================================================================
Fornecedor: 123
Descricao_: 1234567890123456789012345   C.G.C.: 12.345.678/9012-34

Endereco__: 1234567890123456789012345678901234567890 12345678901234567890
Cidade____: 12345678901234567890  U.F.: 12  CEP: 12345-123
Telefone__: (1234) 123-1234       Contato: 12345678901234567890

Obs_______: 12345678901234567890123456789012345678901234567890

==============================================================================
Fornecedor: 123
Descricao_: 1234567890123456789012345   C.G.C.: 12.345.678/9012-34

Endereco__: 1234567890123456789012345678901234567890 123456'8901234%67890
Cidade__O_: !234567890123456'890  U.F.: 12  CEP: 12345-123
Telefone__: (1234) 123-1234       Contato: 12345678901234567890

Obs_______: 12345678901234567890123456789012345678901234567890

==============================================================================
Fornecedor: 123
Descricao_: 1234567890123456789012345   C.G.C.: 12.345.678/9012-34

Endereco__: 1234567890123456789012345678901234567890 12345678901234567890
Cidade____: 12345678901234567890  U.F.: 12  CEP: 12345-123
Telefone__: (1234) 123-1234       Contato: 12345678901234567890

Obs_______: 12345678901234567890123456789012345678901234567890

==============================================================================
Fornecedor: 123
Descricao_: 1234567890123456789012345   C.G.C.: 12.345.678/9012-34

Endereco__: 1234567890123456789012345678901234567890 12345678901234567890
Cidade____: 12345678901234567890  U.F.: 12  CEP: 12345-123
Telefone__: (1234) 123-1234       Contato: 12345678901234567890

Obs_______: 12345678901234567890123456789012345678901234567890

==============================================================================
Fornecedor: 123
Descricao_: 1234567890123456789012345   C.G.C.: 12.345.678/9012-34

Endereco__: 1234567890123456789012345678901234567890 12345678901234567890
Cidade____: 12345678901234567890  U.F.: 12  CEP: 12345-123
Telefone__: (1234) 123-1234       Contato: 12345678901234567890

Obs_______: 12345678901234567890123456789012345678901234567890

==============================================================================
Fornecedor: 123
Descricao_: 1234567890123456789012345   C.G.C.: 12.345.678/9012-34

Endereco__: 1234567890123456789012345678901234567890 12345678901234567890
Cidade____: 12345678901234567890  U.F.: 12  CEP: 12345-123
Telefone__: (1234) 123-1234       Contato: 12345678901234567890

Obs_______: 12345678901234567890123456789012345678901234567890

 */
