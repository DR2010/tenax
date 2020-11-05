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

    @ 00      , 00 say repl('Í',132)
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
    @ prow()+1, 00 say 'ÍÍÍÍÍËÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÍÍÍÍÍ»'

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

   @ prow()+1, 01     say str( WSEPSEQ, 3 )+' º'
   @ prow(), pcol()+2 say STR(ven006->QTD_PECAS,3) + '  º' // QUANTIDADE DE PECAS
   @ prow(), pcol()+1 say EST004->DESCRICAO+'  º'          //DESCRICAO DO MATERIAL
   @ prow(), pcol()   say BitEsp351()
   @ prow(), pcol()   say bitlarg351()

   do case
      case VEN006->SUBFORMA = 'D'
           @ prow(), pcol()+1 say 'DISCO'+'      º'

      case VEN006->SUBFORMA = 'A'
           @ prow(), pcol()+1 say 'ANEL'+'       º'

      case VEN006->SUBFORMA = 'R'
           @ prow(), pcol()+1 say 'RETANGULO'+'  º'

      case VEN006->SUBFORMA = 'M'
           @ prow(), pcol()+1 say 'MODELO'+'     º'

      other
           @ prow(), pcol()+1 say transform( VEN006->ESPESSURA,"@E 99,999,999" )+' º'
   endcase

   @ prow(), pcol()+1 say transform( VEN006->LARGURA,"@E 99,999,999" )+' º'
   @ prow(), pcol()+1 say transform( VEN006->COMPRIM,"@E 99,999,999" )+' º'

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

   @ prow()+1, 05       say 'º '+str(ven006->peso_teo,6)+'       º'
   @ prow()  , pcol()+1 say EST004->COR+' º'
   @ prow()  , pcol()+2 say space(53) + '  º'
   @ prow()  , pcol()+1 say 'I=        C=       ' + 'º'
   @ prow()  , pcol()+1 say '              ' + '  º'
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
    @ prow()+1,00 say '     º PESO TEORICO º COR          º MEDIDAS  ACHADAS => º                 º                 º            º            º            º'
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
     @ prow()+1,00 say '     º PESO TEORICO º COR          º CORTADO DE                                              º N.PCS UTILIZ.      º PESO            º'

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
  @ prow()+1, 00 say '     ÇÄÄÄÄÄÄÄÐÄÄÄÄÄÄÒÄÄÄÄÄÄÄÄÄÄÄÄÄÄÒÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÐÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÐÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ×ÄÄÄÄÄÄÄÄÄÄÄÄÐÄÄÄÄÄÄÄÒÄÄÄÄÐÄÄÄÄÄÄÄÄÄÄÄÄ¶'
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

  @ prow()+1, 00 say '     ÇÄÄÄÄÄÄÄÄÄÄÄÄÄÄÐÄÄÄÄÄÄÄÄÄÄÄÄÄÄÐÄÄÄÄÄÄÄÄÄÄÄÄÒÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÒÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÐÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÐÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¶'
  @ prow()+1, 00 say '     º Sobra(s)mm                               º Lote           º  Observacao                                                      º'
  @ prow()+1, 00 say '     º                                          º                º '+VEN006->OBSSEPARA+'º'
  @ prow()+1, 00 say 'ÍÍÍÍÍÊÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼'

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
      nums := SPACE(8)+' º'
   else
      nums := STR(VEN006->BIT_MM,8,3)+' º'
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
      nums := SPACE(8)+' º'
   else
      nums := STR(VEN006->ESP_MM,8,3)+' º'
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

   @ prow()+1, 01     say STR( WSEPSEQ,3 )+' º'     // NUMERO DO ITEM
   @ prow(), pcol()+2 say STR(ven006->QTD_PECAS,3) + '  º' // QUANTIDADE DE PECAS
   @ prow(), pcol()+1 say EST004->DESCRICAO+'  º'         //DESCRICAO DO MATERIAL
   @ prow(), pcol()   say BitEsp351()
   @ prow(), pcol()   say bitlarg351()
   @ prow(), pcol()+1 say transform( VEN006->ESPESSURA,"@E 99,999,999" )+' º'
   @ prow(), pcol()+1 say transform( VEN006->LARGURA,"@E 99,999,999" )+' º'
   @ prow(), pcol()+1 say transform( VEN006->COMPRIM,"@E 99,999,999" )+' º'
   @ PROW()+1, 00     SAY '     ÇÄÄÄÄÄÄÄÐÄÄÄÄÄÄÒÄÄÄÄÄÄÄÄÄÄÄÄÄÄÒÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ×ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ×ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ×ÄÄÄÄÄÄÄÄÄÄÄÄ×ÄÄÄÄÄÄÄÄÄÄÄÄ×ÄÄÄÄÄÄÄÄÄÄÄÄ¶'

   ven0352cab2()

   @ prow()+1, 05     say 'º '+str(ven006->peso_teo,6) +'      '
   @ prow(), PCOL()+1 say 'º '+EST004->COR+' º                     º                 º                 º            º            º            º'

   @ PROW()+1, 00     say '     ÌÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÎÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÍÍÍÍÍÎÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÍÍÍÍÍ¹'
   @ PROW()+1, 00     say '     º OBSERVACAO                                                          º PESO                                                   º'
   @ prow()+1, 00     say '     º '+VEN006->OBSSEPARA+'   º                                                        º'

   @ PROW()+1, 00     SAY 'ÍÍÍÍÍÊÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼'

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
           @ prow()+1,00 say 'ITEM º QT.PC º MATERIAL                                  º BIT/ESP         º BIT/LARG        º SUBFORMA   º D.EXTERNO  º D.INTERNO  º'
       CASE VEN006->SUBFORMA = 'D'
           @ prow()+1,00 say 'ITEM º QT.PC º MATERIAL                                  º BIT/ESP         º BIT/LARG        º SUBFORMA   º DIAMETRO   º COMP.      º'
       CASE VEN006->SUBFORMA = 'R'
           @ prow()+1,00 say 'ITEM º QT.PC º MATERIAL                                  º BIT/ESP         º BIT/LARG        º SUBFORMA   º LARG.      º COMP.      º'
       OTHER
           @ prow()+1,00 say 'ITEM º QT.PC º MATERIAL                                  º BIT/ESP         º BIT/LARG        º ESP.       º LARG.      º COMP.      º'
     END
return (.t.)

