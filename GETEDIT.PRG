//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ GETEDIT.PRG() - Funcao para editar get's na tela.                         ³
//ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´
//³ Programador: Marcos A. F. Santos        ³ Data.......: 26/01/1995         ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

#include "inkey.ch"
#include "sic.ch"

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Vetor de edicao - VET_EDICAO                                               ³
//³       1§ -> Variavel Get                                                   ³
//³       2§ -> Mascara                                                        ³
//³       3§ -> Linha                                                          ³
//³       4§ -> Coluna                                                         ³
//³ PREVALID -> Bloco de codigo da pre_validacao                               ³
//³ POSVALID -> Bloco de codigo da pos_validacao                               ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
function getedit( VET_EDICAO,PREVALID,POSVALID )

local  I            := 0
local  GETLIST_OLD  := {}

if ! empty( GETLIST )
   GETLIST_OLD := aclone( GETLIST )
endif
GETLIST := {}

for I:=1 to len( VET_EDICAO )

    @ VET_EDICAO[I,3],VET_EDICAO[I,4] get      VET_EDICAO[I,1]   ;
                                      picture (VET_EDICAO[I,2])
                                      GETLIST[I]:setfocus()
                                      GETLIST[I]:cargo     := I
                                      GETLIST[I]:preblock  := PREVALID
                                      GETLIST[I]:postblock := POSVALID
                                      GETLIST[I]:colorspec := W_GETOBJ
                                      GETLIST[I]:killfocus()

next

readmodal( GETLIST )

GETLIST := aclone( GETLIST_OLD )

return( nil )

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ INPUT_GET() - Inserir no get um valor determinado                          ³
//³       1§ -> Numero do get                                                  ³
//³       2§ -> Valor do get                                                   ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
function input_get( NUMERO,VALOR )

local  FOCO  := getlist[NUMERO]:hasfocus()

getlist[NUMERO]:varput(VALOR)
getlist[NUMERO]:setfocus()
getlist[NUMERO]:updatebuffer()
if ! FOCO
   getlist[NUMERO]:killfocus()
endif

return(nil)
