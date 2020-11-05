/*
   CONTAS A RECEBER
   ESTR570.PRG - Emissao de etiquetas de cliente

*/
setcancel(.t.)
altd(1)

telanum('SCE570','EST570')

#include "inkey.ch"

abrir("EST002")
abrir("ESTREPO")

private linha134 := replicate('-',134)
private W_TITULO := 'Etiquetas de Fornecedores'

WRESP_IMP  := 'I'
W_IMPARQ   := space(12)

OLD_STATUS   := savescreen(24,00,24,79)
X_FORNECEDOR := space(3)
X_CODFIM     := space(3)
W_CONT       := 0

X_RAZ_01   := ''
X_END_01   := ''
X_BAI_01   := ''
X_CEP_01   := ''
X_CID_01   := ''
X_EST_01   := ''

X_RAZ_02   := ''
X_END_02   := ''
X_BAI_02   := ''
X_CEP_02   := ''
X_CID_02   := ''
X_EST_02   := ''

X_RAZ_03   := ''
X_END_03   := ''
X_BAI_03   := ''
X_CEP_03   := ''
X_CID_03   := ''
X_EST_03   := ''

if par_for()
   if dh_imprime()
      if WRESP_IMP = 'A'
         ESTREPO->( grava( WIMP_ARQ, date(), time(), W_TITULO, 80) )
      end
      ESTR570proc()
      dh_impoff()
   end
end


/*
-----------------------------------------------------------------------------
                      Parametro de Nota Fiscal
-----------------------------------------------------------------------------
*/
function par_for()

local WRET:= .T.

WSCRDUP := savescreen(,,,,)

setcursor(1)

@ 10,14 say 'ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿'
@ 11,14 say '³                                  ³'
@ 12,14 say '³ Fornecedor Ini/Fim :     /       ³'
@ 13,14 say '³                                  ³'
@ 14,14 say 'ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ'

X_FORNECEDOR := space(3)
X_CODFIM     := "999"

@ 12,37 get X_FORNECEDOR  picture '@!' valid tes_forn(X_FORNECEDOR,5)
@ 12,43 get X_CODFIM      picture '@!'
read

if lastkey()=27
   WRET := .F.
   return WRET
end

@ 12,37 say X_FORNECEDOR
@ 12,43 say X_CODFIM
read

if !pergunta("Confirma Impressao de Etiquetas (S/N) ?")
   WRET := .F.
   return WRET
end

restscreen(,,,,WSCRDUP )

setcursor(0)

return WRET

/*
--------------------------------------------------------------------------
                  Procedimento principal
--------------------------------------------------------------------------
*/
function ESTR570proc()

local WRET := .T.

   mensimp("Gerando Etiquetas. Aguarde...")

   @ prow()+4, 00 say ' '

   EST002->(dbgotop())
   EST002->(dbsetorder(1))
   EST002->(dbseek(X_FORNECEDOR))

   do while ( EST002->(!eof())              ) .and. ;
            ( EST002->FORNECEDOR < X_CODFIM )
              ESTR570det()
   enddo

return

/*
--------------------------------------------------------------------------
                  Impressao do Detalhe
--------------------------------------------------------------------------
*/
procedure ESTR570det()

local WRET  := .T.

   W_COL  := 0
   W_CONT := 1

// DESCRICAO SOCIAL
// ENDERECO
// BAIRRO
// CIDADE / ESTADO
// CEP: 99999-999    AO SETOR COMERCIAL

   X_RAZ_01 := ''
   X_END_01 := ''
   X_BAI_01 := ''
   X_CEP_01 := ''
   X_CID_01 := ''
   X_EST_01 := ''

   X_RAZ_02 := ''
   X_END_02 := ''
   X_BAI_02 := ''
   X_CEP_02 := ''
   X_CID_02 := ''
   X_EST_02 := ''

   X_RAZ_03 := ''
   X_END_03 := ''
   X_BAI_03 := ''
   X_CEP_03 := ''
   X_CID_03 := ''
   X_EST_03 := ''

   do while ( EST002->(!eof())              ) .and. ;
            ( EST002->FORNECEDOR < X_CODFIM ) .and. ;
            ( W_CONT  < 4                   )

      do case

         case W_CONT = 1
              X_RAZ_01 := left (EST002->DESCRICAO,38)
              X_END_01 := left (EST002->ENDERECO,38)
              X_BAI_01 := left (EST002->BAIRRO,38)
              X_CEP_01 := EST002->CEP
              X_CID_01 := left(EST002->CIDADE,30)
              X_EST_01 := EST002->ESTADO

         case W_CONT = 2
              X_RAZ_02 := left (EST002->DESCRICAO,38)
              X_END_02 := left (EST002->ENDERECO,38)
              X_BAI_02 := left (EST002->BAIRRO,38)
              X_CEP_02 := EST002->CEP
              X_CID_02 := left(EST002->CIDADE,30)
              X_EST_02 := EST002->ESTADO

         case W_CONT = 3
              X_RAZ_03 := left (EST002->DESCRICAO,38)
              X_END_03 := left (EST002->ENDERECO,38)
              X_BAI_03 := left (EST002->BAIRRO,38)
              X_CEP_03 := EST002->CEP
              X_CID_03 := left(EST002->CIDADE,30)
              X_EST_03 := EST002->ESTADO

      endcase

      W_CONT := W_CONT + 1

      EST002->(dbskip())

   enddo

   @ prow()+1, 2   say X_RAZ_01
   @ prow()  , 45  say X_RAZ_02
   @ prow()  , 88  say X_RAZ_03
   @ prow()+1, 2   say X_END_01
   @ prow()  , 45  say X_END_02
   @ prow()  , 88  say X_END_03
   @ prow()+1, 2   say X_BAI_01
   @ prow()  , 45  say X_BAI_02
   @ prow()  , 88  say X_BAI_03
   @ prow()+1, 2   say X_CID_01 + ' - '+ X_EST_01
   @ prow()  , 45  say X_CID_02 + ' - '+ X_EST_02
   @ prow()  , 88  say X_CID_03 + ' - '+ X_EST_03
   @ prow()+1, 2   say 'CEP: '+ transform(X_CEP_01,'@R 99999-999') + '     ' +'A/C Setor Comercial'
   @ prow()  , 45  say 'CEP: '+ transform(X_CEP_02,'@R 99999-999') + '     ' +'A/C Setor Comercial'
   @ prow()  , 88  say 'CEP: '+ transform(X_CEP_03,'@R 99999-999') + '     ' +'A/C Setor Comercial'
   @ prow()+1, 2   say ''

return WRET
      

