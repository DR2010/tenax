

/*
   CONTAS A RECEBER
   VENR570.PRG - Emissao de etiquetas de cliente

*/
setcancel(.t.)
altd(1)

telanum('SCE1400','VEN570')

#include "inkey.ch"

abrir("VEN001")
abrir("ESTREPO")

private linha134 := replicate('-',134)
private W_TITULO := 'Etiquetas de Clientes'

WRESP_IMP  := 'I'
W_IMPARQ   := space(12)

OLD_STATUS := savescreen(24,00,24,79)
X_CODCLI   := space(5)
X_CODFIM   := space(5)
W_CONT     := 0

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

if par_cli()
   if dh_imprime()
      if WRESP_IMP = 'A'
         ESTREPO->( grava( WIMP_ARQ, date(), time(), W_TITULO, 80) )
      end
      VENR570proc()
      dh_impoff()
   end
end


/*
-----------------------------------------------------------------------------
                      Parametro de Nota Fiscal
-----------------------------------------------------------------------------
*/
function par_cli()

local WRET:= .T.

WSCRDUP := savescreen(,,,,)

setcursor(1)

@ 10,14 say 'ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿'
@ 11,14 say '³                                    ³'
@ 12,14 say '³ Cliente Ini/Fim ..:       /        ³'
@ 13,14 say '³                                    ³'
@ 14,14 say 'ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ'

X_CODCLI   := space(5)
X_CODFIM   := '99999'

@ 12,36 get X_CODCLI  picture '@!' valid tes_codcli(X_CODCLI)
@ 12,44 get X_CODFIM  picture '@!'
read

if lastkey()=27
   WRET := .F.
   return WRET
end

@ 12,36 say X_CODCLI
@ 12,44 say X_CODFIM
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
function VENR570proc()

local WRET := .T.

   mensimp("Gerando Etiquetas. Aguarde...")

   @ prow()+4, 00 say ' '

   VEN001->(dbgotop())
   VEN001->(dbsetorder(1))
   VEN001->(dbseek(X_CODCLI))

   do while ( VEN001->(!eof())          ) .and. ;
            ( VEN001->CODCLI < X_CODFIM )
              VENR570det()
   enddo

return

/*
--------------------------------------------------------------------------
                  Impressao do Detalhe
--------------------------------------------------------------------------
*/
procedure VENR570det()

local WRET  := .T.

   W_COL  := 0
   W_CONT := 1

// RAZAO SOCIAL
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

   do while ( VEN001->(!eof())          ) .and. ;
            ( VEN001->CODCLI < X_CODFIM ) .and. ;
            ( W_CONT  < 4               )

      do case

         case W_CONT = 1
              X_RAZ_01 := left (VEN001->RAZAO,36)
              X_END_01 := left (VEN001->END_PAG,36)
              X_BAI_01 := left (VEN001->BAIR_PAG,36)
              X_CEP_01 := VEN001->CEP_PAG
              X_CID_01 := left(VEN001->CIDA_PAG,30)
              X_EST_01 := VEN001->ESTA_PAG

         case W_CONT = 2
              X_RAZ_02 := left (VEN001->RAZAO,36)
              X_END_02 := left (VEN001->END_PAG,36)
              X_BAI_02 := left (VEN001->BAIR_PAG,36)
              X_CEP_02 := VEN001->CEP_PAG
              X_CID_02 := left(VEN001->CIDA_PAG,30)
              X_EST_02 := VEN001->ESTA_PAG

         case W_CONT = 3
              X_RAZ_03 := left (VEN001->RAZAO,36)
              X_END_03 := left (VEN001->END_PAG,36)
              X_BAI_03 := left (VEN001->BAIR_PAG,36)
              X_CEP_03 := VEN001->CEP_PAG
              X_CID_03 := left(VEN001->CIDA_PAG,30)
              X_EST_03 := VEN001->ESTA_PAG

      endcase

      W_CONT := W_CONT + 1

      VEN001->(dbskip())

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
   @ prow()+1, 2   say 'CEP:'+ transform(X_CEP_01,'@R 99999-999') + '  ' +'Ao Setor Comercial'
   @ prow()  , 45  say 'CEP:'+ transform(X_CEP_02,'@R 99999-999') + '  ' +'Ao Setor Comercial'
   @ prow()  , 88  say 'CEP:'+ transform(X_CEP_03,'@R 99999-999') + '  ' +'Ao Setor Comercial'
   @ prow()+1, 2   say ''

return WRET
      


