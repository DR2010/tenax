/*

	SCM - Sistema de Controle Metalurgico
        VEN0351.PRG - Relatorio Separacao

*/
#include "inkey.ch"
#include "sic.ch"

/*
-----------------------------------------------------------------------------
Procedimento : SEP35REL
Parametros   : nenhum
Retorno      : nenhum
Objetivo     :
-----------------------------------------------------------------------------
*/
function SEP35REL( TIPO )

   local WRET := .T.
   private WPG := 1

   W_TIPO := TIPO

   mensimp("Gerando Separacao. Aguarde...")

   // ven035cab(.T.)

   if W_TIPO = 'E' .or. W_TIPO = 'C'
      ven035det()
   else
      ven0352det()
   end

return .t.


/*
-----------------------------------------------------------------------------
Procedimento : VEN035CAB
Parametros   : nenhum
Retorno      : nenhum
Objetivo     :
-----------------------------------------------------------------------------
*/
function VEN035CAB( X )
    LOCAL P := ''

    @ 00      , 00 say repl('�',132)
    @ prow()+1, 95 say 'ORDEM DE SEPARACAO INTERNA N.:'+X_SEPARACAO

    do case
       case VEN006->ESTOQUE   = 'E'
         P := 'ESTOQUE'
       case VEN006->ESTOQUE   = 'C'
         P := 'ESTOQUE A CHEGAR'
       case VEN006->ESTOQUE   = 'R'
         P := 'REVENDA'
    end

    @ prow()+1, 06 say 'TENAX'
    @ prow()  , 20 say 'Entrega : '
    @ prow()  , 31 say dtoc(VEN006->PRAZODT) + '-' + VEN006->PRAZOHR
    @ prow()  , 90 say P
    @ prow()+1, 03 say 'ACOS ESPECIAIS' + SPACE(20)+VEN005->CODCLI
    @ prow()+1, 95 say 'DATA : '+dtoc(DATE())+space(14)+'PAG.: ' +strzero( WPG,2)
    @ prow()+1, 00 say '�����������������������������������������������������������������������������������������������������������������������������������ͻ'

RETURN  (.t.)


/*
-----------------------------------------------------------------------------
Procedimento : VEN035DET
Parametros   : nenhum
Retorno      : nenhum
Objetivo     :
-----------------------------------------------------------------------------
*/
function ven035det()

   select EST004

   EST004->( dbsetorder(3) )
   EST004->( dbseek( VEN006->FORMA + VEN006->TIPO ) )

   select VEN006

   if prow() > 50
     WPG++
     ven035cab(.T.)
   end

   ven035cab1()

   @ prow()+1, 01     say str( WSEPSEQ, 3 )+' �'
   @ prow(), pcol()+2 say STR(ven006->QTD_PECAS,3) + '  �' // QUANTIDADE DE PECAS
   @ prow(), pcol()+1 say EST004->DESCRICAO+'  �'          //DESCRICAO DO MATERIAL
   @ prow(), pcol()   say BitEsp351()
   @ prow(), pcol()   say bitlarg351()

   do case
      case VEN006->SUBFORMA = 'D'
           @ prow(), pcol()+1 say 'DISCO'+'      �'

      case VEN006->SUBFORMA = 'A'
           @ prow(), pcol()+1 say 'ANEL'+'       �'

      case VEN006->SUBFORMA = 'R'
           @ prow(), pcol()+1 say 'RETANGULO'+'  �'

      case VEN006->SUBFORMA = 'M'
           @ prow(), pcol()+1 say 'MODELO'+'     �'

      other
           @ prow(), pcol()+1 say transform( VEN006->ESPESSURA,"@E 99,999,999" )+' �'
   endcase

   @ prow(), pcol()+1 say transform( VEN006->LARGURA,"@E 99,999,999" )+' �'
   @ prow(), pcol()+1 say transform( VEN006->COMPRIM,"@E 99,999,999" )+' �'

   ven035cab3()
   ven035cab2()
   ven035det2()
   ven035cab4()


return (.t.)

/*
-----------------------------------------------------------------------------
Procedimento : VEN035DET2
Parametros   : nenhum
Retorno      : nenhum
Objetivo     :
-----------------------------------------------------------------------------
*/
function ven035det2()

   @ prow()+1, 05       say '� '+str(ven006->peso_teo,6)+'       �'
   @ prow()  , pcol()+1 say EST004->COR+' �'
   @ prow()  , pcol()+2 say space(53) + '  �'
   @ prow()  , pcol()+1 say 'I=        C=       ' + '�'
   @ prow()  , pcol()+1 say '              ' + '  �'
RETURN(.T.)



/*
-----------------------------------------------------------------------------
Procedimento : VEN0352CAB2
Parametros   : nenhum
Retorno      : nenhum
Objetivo     :
-----------------------------------------------------------------------------
*/
function ven0352cab2()
    @ prow()+1,00 say '     � PESO TEORICO � COR          � MEDIDAS  ACHADAS => �                 �                 �            �            �            �'
return (.t.)


/*
-----------------------------------------------------------------------------
Procedimento : VEN035CAB2
Parametros   : nenhum
Retorno      : nenhum
Objetivo     :
-----------------------------------------------------------------------------
*/
function ven035cab2()
     @ prow()+1,00 say '     � PESO TEORICO � COR          � CORTADO DE                                              � N.PCS UTILIZ.      � PESO            �'

return (.t.)

/*
-----------------------------------------------------------------------------
Procedimento : VEN035CAB3
Parametros   : nenhum
Retorno      : nenhum
Objetivo     :
-----------------------------------------------------------------------------
*/
function ven035cab3()
  @ prow()+1, 00 say '     ������������������������������������������������������������������������������������������������������������������������������Ķ'
return (.t.)


/*
-----------------------------------------------------------------------------
Procedimento : VEN035CAB4
Parametros   : nenhum
Retorno      : nenhum
Objetivo     :
-----------------------------------------------------------------------------
*/
function ven035cab4()

  @ prow()+1, 00 say '     ������������������������������������������������������������������������������������������������������������������������������Ķ'
  @ prow()+1, 00 say '     � Sobra(s)mm                               � Lote           �  Observacao                                                      �'
  @ prow()+1, 00 say '     �                                          �                � '+VEN006->OBSSEPARA+'�'
  @ prow()+1, 00 say '�����������������������������������������������������������������������������������������������������������������������������������ͼ'

return (.t.)


/*
-----------------------------------------------------------------------------
Procedimento : BITESP351
Parametros   : nenhum
Retorno      : nenhum
Objetivo     :
-----------------------------------------------------------------------------
*/

function BitEsp351()

   local impt,nums

   if VEN006->BIT_MM <=0
      nums := SPACE(8)+' �'
   else
      nums := STR(VEN006->BIT_MM,8,3)+' �'
   endif
   impt := VEN006->BIT_INT+' '+VEN006->BIT_FN+'/'+''+VEN006->BIT_FD+''+nums

return( impt )  


/*
-----------------------------------------------------------------------------
Procedimento : BITLARG351
Parametros   : nenhum
Retorno      : nenhum
Objetivo     :
-----------------------------------------------------------------------------
*/
function bitlarg351() 

   local impt,nums
   if VEN006->ESP_MM <=0
      nums := SPACE(8)+' �'
   else
      nums := STR(VEN006->ESP_MM,8,3)+' �'
   endif
   impt := VEN006->ESP_INT+' '+VEN006->ESP_FN+'/'+''+VEN006->ESP_FD+''+nums

return( impt )  


/*
-----------------------------------------------------------------------------
Procedimento : VEN0352DET
Parametros   : nenhum
Retorno      : nenhum
Objetivo     :
-----------------------------------------------------------------------------
*/
function ven0352det()

   select EST004
   EST004->( dbsetorder(3) )

   EST004->( dbseek( VEN006->FORMA + VEN006->TIPO ))

   select VEN006

   if prow() > 50
      WPG++
      ven035cab(.F.)
   end

   ven035cab1()

   @ prow()+1, 01     say STR( WSEPSEQ,3 )+' �'     // NUMERO DO ITEM
   @ prow(), pcol()+2 say STR(ven006->QTD_PECAS,3) + '  �' // QUANTIDADE DE PECAS
   @ prow(), pcol()+1 say EST004->DESCRICAO+'  �'         //DESCRICAO DO MATERIAL
   @ prow(), pcol()   say BitEsp351()
   @ prow(), pcol()   say bitlarg351()
   @ prow(), pcol()+1 say transform( VEN006->ESPESSURA,"@E 99,999,999" )+' �'
   @ prow(), pcol()+1 say transform( VEN006->LARGURA,"@E 99,999,999" )+' �'
   @ prow(), pcol()+1 say transform( VEN006->COMPRIM,"@E 99,999,999" )+' �'
   @ PROW()+1, 00     SAY '     ������������������������������������������������������������������������������������������������������������������������������Ķ'

   ven0352cab2()

   @ prow()+1, 05     say '� '+str(ven006->peso_teo,6) +'      '
   @ prow(), PCOL()+1 say '� '+EST004->COR+' �                     �                 �                 �            �            �            �'

   @ PROW()+1, 00     say '     ������������������������������������������������������������������������������������������������������������������������������͹'
   @ PROW()+1, 00     say '     � OBSERVACAO                                                          � PESO                                                   �'
   @ prow()+1, 00     say '     � '+VEN006->OBSSEPARA+'   �                                                        �'

   @ PROW()+1, 00     SAY '�����������������������������������������������������������������������������������������������������������������������������������ͼ'

return (.t.)


/*
-----------------------------------------------------------------------------
Procedimento : VEN035CAB1
Parametros   : nenhum
Retorno      : nenhum
Objetivo     :
-----------------------------------------------------------------------------
*/
function ven035cab1()
     DO CASE
       CASE VEN006->SUBFORMA = 'A'
           @ prow()+1,00 say 'ITEM � QT.PC � MATERIAL                                  � BIT/ESP         � BIT/LARG        � SUBFORMA   � D.EXTERNO  � D.INTERNO  �'
       CASE VEN006->SUBFORMA = 'D'
           @ prow()+1,00 say 'ITEM � QT.PC � MATERIAL                                  � BIT/ESP         � BIT/LARG        � SUBFORMA   � DIAMETRO   � COMP.      �'
       CASE VEN006->SUBFORMA = 'R'
           @ prow()+1,00 say 'ITEM � QT.PC � MATERIAL                                  � BIT/ESP         � BIT/LARG        � SUBFORMA   � LARG.      � COMP.      �'
       OTHER
           @ prow()+1,00 say 'ITEM � QT.PC � MATERIAL                                  � BIT/ESP         � BIT/LARG        � ESP.       � LARG.      � COMP.      �'
     END
return (.t.)

