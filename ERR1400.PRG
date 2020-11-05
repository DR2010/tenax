/*
   CONTAS A RECEBER
   ERR1400.PRG - Emissao de Boleta Bancaria

*/
setcancel(.t.)
altd(1)

telanum('SCE1400','CR1400')

#include "inkey.ch"

abrir("CR9991")
abrir("VEN001")
abrir("ER1000")
abrir("ER1100")
abrir("VEN050")
abrir("ESTREPO")

OLD_STATUS := savescreen(24,00,24,79)

W_NOTAFISCAL  := space(08)
W_VL          := 0.00

if par_Enf()
   if dh_imprime()
      ERR1400proc()
      dh_impoff()
   end
end


/*
-----------------------------------------------------------------------------
                      Parametro de Nota Fiscal
-----------------------------------------------------------------------------
*/
function par_ENF()

local WRET:= .T.

WSCRDUP := savescreen(,,,,)

setcursor(1)

@ 10,14 say '--------------------------'
@ 11,14 say '                          '
@ 12,14 say ' Nota Fiscal..:           '
@ 13,14 say '                          '
@ 14,14 say '--------------------------'

@ 12,30 get W_NOTAFISCAL picture '@!'
read

if lastkey()=27
   WRET := .F.
   return WRET
end

W_NOTAFISCAL  := zerofill( W_NOTAFISCAL  )
@ 12,30 say W_NOTAFISCAL

if ! (acessa_Enf(W_NOTAFISCAL))
   WRET := .F.
   return WRET
end

ER1000->(dbsetorder(2))
if !(ER1000-> (dbseek("P"+VEN050->NOTAFISCAL)) )
    mensbeep(" Nota Fiscal Nao tem Duplicatas Pedentes ! ")
    WRET := .F.
    return WRET
end

VEN001->(dbsetorder(1))
if !(VEN001-> (dbseek(ER1000->CODCLI)) )
    mensbeep(" Cliente Nao Cadastrado ! ")
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
function ERR1400proc()

local WRET := .T.

   mensimp("Gerando Relatorio. Aguarde...")

   do while (ER1000->(!eof()) ) .and. ;
            (ER1000->DUPLICATA = VEN050->NOTAFISCAL )
             if ER1000->STATUS = "P"
                ERR1400det()
             end
             ER1000->(dbskip())
   enddo

return

/*
--------------------------------------------------------------------------
                  Impressao do Detalhe
--------------------------------------------------------------------------
*/
procedure ERR1400det()

local WRET  := .T.

      @ prow(), 00 say '@  0 E'
      @ prow()+1, 52 say dtoc(ER1000->DT_VENC)
//       @ prow()  , 52 say dtoc(ER1000->DT_VENC)

      @ prow()+4, 00 say VEN050->DT_EMISSAO
//       @ prow()  , 00 say VEN050->DT_EMISSAO

      @ prow()  , 14 say ER1000->DUPLICATA
//       @ prow()  , 14 say ER1000->DUPLICATA

      @ prow()  , 23 say ER1000->SEQUENCIA
//       @ prow()  , 23 say ER1000->SEQUENCIA

      @ prow()+2, 48 say transform(ER1000->VALOR,'@E 9,999,999.99')
//       @ prow()  , 48 say transform(ER1000->VALOR,'@E 9,999,999.99')

      W_VL := ( (CR9991->JUROS / 30) * ER1000->VALOR) / 100

      @ prow()+4, 01 say ' VALORES EXPRESSOS EM REAIS'
//       @ prow()  , 01 say ' VALORES EXPRESSOS EM REAIS'

      @ prow()+1, 01 say ' Permanencia por dia de atrazo R$ '
//       @ prow()  , 01 say ' Permanencia por dia de atrazo R$ '

      @ prow()  , 30 say W_VL
//       @ prow()  , 30 say W_VL

      @ prow()+2, 01 say ' PROTESTAR 3 DIAS APOS VENCIMENTO'
//       @ prow()  , 01 say ' PROTESTAR 3 DIAS APOS VENCIMENTO'

      @ prow()+5, 43 say VEN001->CGC                  picture "@R 99.999.999/9999-99"
//       @ prow()  , 43 say VEN001->CGC                  picture "@R 99.999.999/9999-99"

      @ prow()+1, 00 say VEN001->RAZAO+'F'

      @ prow()+1, 00 say ''
      @ prow()  , 00 say VEN001->END_PAG
      @ prow()  , 48 say VEN001->BAIR_PAG
      @ prow()+1, 40 say 'CEP.:'
      @ prow()  , 46 say VEN001->CEP_PAG              picture "@R 99999-999"
      @ prow()  , 59 say VEN001->CIDA_PAG+' - '+VEN001->ESTA_PAG

      @ prow()+10, 00 say ''

return WRET

