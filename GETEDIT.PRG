//旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�
//� GETEDIT.PRG() - Funcao para editar get's na tela.                         �
//쳐컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴쩡컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�
//� Programador: Marcos A. F. Santos        � Data.......: 26/01/1995         �
//읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴좔컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�

#include "inkey.ch"
#include "sic.ch"

//旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴커
//� Vetor de edicao - VET_EDICAO                                               �
//�       1� -> Variavel Get                                                   �
//�       2� -> Mascara                                                        �
//�       3� -> Linha                                                          �
//�       4� -> Coluna                                                         �
//� PREVALID -> Bloco de codigo da pre_validacao                               �
//� POSVALID -> Bloco de codigo da pos_validacao                               �
//읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴켸
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

//旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴커
//� INPUT_GET() - Inserir no get um valor determinado                          �
//�       1� -> Numero do get                                                  �
//�       2� -> Valor do get                                                   �
//읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴켸
function input_get( NUMERO,VALOR )

local  FOCO  := getlist[NUMERO]:hasfocus()

getlist[NUMERO]:varput(VALOR)
getlist[NUMERO]:setfocus()
getlist[NUMERO]:updatebuffer()
if ! FOCO
   getlist[NUMERO]:killfocus()
endif

return(nil)
