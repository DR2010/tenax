/*

   SCM - Sistema de Controle Metalurgico
   EST31.PRG - LOTE

*/
#include "inkey.ch"

abrir("EST006")
abrir("EST009")
abrir("EST031")
telanum('SCR30 ','EST30 ')
setcolor(W_COREDIT)
status('Registro do Lote')
/*
-------------------------------------------------------------------------------
                           lote31_TELA
-------------------------------------------------------------------------------
*/
procedure lote31_tela()

   @ 14,02 say '³                                                                          ³'
   @ 15,02 say '³  Lote :                                        Ord. Produc.:             ³'
   @ 16,02 say '³                                                Pun‡„o      :             ³'
   @ 17,02 say '³  Nota Fiscal - n.o  :                          Corrida     :             ³'
   @ 18,02 say '³                data :                          Certificado :             ³'
   @ 19,02 say '³  Acabamento.........:                                                    ³'
   @ 20,02 say '³  Obs.:                                                                   ³'
   @ 21,02 say '³                                                                          ³'
   @ 22,02 say 'ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ'
   @ 23,02 say'                                                                       Est31'
return

/*
-------------------------------------------------------------------------------
                           Lote31_GET
-------------------------------------------------------------------------------
*/
procedure lote31_get
local WRET := .F.
select est031
//FORMA := EST006->FORMA

X_LOTE := novo_lote()
@ 15,12 get X_LOTE        picture "@k!"  valid tesn_lote( X_LOTE )
read

@ 17,26 get X_NOTAFISCAL picture "@k!" valid zero( X_NOTAFISCAL, len(X_NOTAFISCAL) )
@ 18,26 get X_DTFISCAL
@ 19,26 get X_ACABAMENTO picture "@K!"
@ 15,65 get X_O_PRODUCAO               valid  ( X_PUNCAO := X_O_PRODUCAO, .t.)
@ 16,65 get X_PUNCAO
@ 17,65 get X_CORRIDA    picture "@k!" valid zero( X_CORRIDA, len(X_CORRIDA) )
@ 18,65 get X_CERTIFIC   picture "@k!" valid zero( X_CERTIFIC, len(X_CERTIFIC) )
@ 20,11 get X_OBS        picture "@k!"
@ 21,11 get X_OBS1       picture "@k!"
read

if lastkey()=K_ESC
      WRET:=.F.
else
   if conf(' Confirma Recebimento do Item ')
           select est007
           EST007->( dbsetorder(1) )
           EST007->( dbseek( W_CHAVE_ITEM ) )

             if EST007->( ! found() )
              mensbeep('Favor cadastrar o ¡tem no estoque.<ENTER> ')
              WRET := .F.
              ELSE
              WRET := .T.
             END

   end
end
W_CHAVE_ITEM := ( X_FORMA+ X_TIPO+ ;
             str( X_BIT_MM, 8, 3 ) + str( X_ESP_MM, 8, 3 ) + X_ESTADO )

return WRET
/*
-----------------------------------------------------------------------------
                      Funcao tesn_lote
-----------------------------------------------------------------------------
*/
function tesn_lote( VAR )

   local WRET := .T.

   X_LOTE := VAR := zerofill( VAR )

   EST031->( dbsetorder(1) )
   EST031->( dbseek( VAR ) )

   if EST031->( found() )
      mensbeep(" N£mero de Lote j  existente.<ENTER>")
      x_lote := novo_lote()
      WRET := .F.
   end

return WRET

/*
-----------------------------------------------------------------------------
                      Funcao lote31_grava
-----------------------------------------------------------------------------
*/
procedure lote31_grava( MODO )


 if MODO =="M" .or. MODO =="m"
 while ( ! rlock() ) ;end
   EST031->( dbappend() )

   EST031->FORMA    := X_FORMA
   EST031->TIPO     := X_TIPO
   EST031->ESTADO   := X_ESTADO
   EST031->BIT_MM   := X_BIT_MM
   EST031->ESP_MM   := X_ESP_MM
   EST031->BIT_INT  := X_BIT_INT
   EST031->BIT_FN   := X_BIT_FN
   EST031->BIT_FD   := X_BIT_FD
   EST031->ESP_INT  := X_ESP_INT
   EST031->ESP_FN   := X_ESP_FN
   EST031->ESP_FD   := X_ESP_FD
   EST031->QTD_KGT  := X_QTD_KG
   EST031->QTD_INT  := X_QTD_INT
   EST031->ORIGEM   := X_ORIGEM

   EST031->LOTE     := X_LOTE
   EST031->( dbunlock() )

 else
 while ( ! rlock() ) ;end
   EST031->( dbappend() )

   EST031->FORMA    := X_FORMA
   EST031->TIPO     := X_TIPO
   EST031->ESTADO   := X_ESTADO
   EST031->BIT_MM   := X_BIT_MM
   EST031->ESP_MM   := X_ESP_MM
   EST031->BIT_INT  := X_BIT_INT
   EST031->BIT_FN   := X_BIT_FN
   EST031->BIT_FD   := X_BIT_FD
   EST031->ESP_INT  := X_ESP_INT
   EST031->ESP_FN   := X_ESP_FN
   EST031->ESP_FD   := X_ESP_FD
   EST031->QTD_KGT  := X_R_QTDKG
   EST031->QTD_INT  := X_R_QTDPEC
   EST031->ORIGEM   := X_FORNECEDOR := EST002->FGUERRA

   EST031->LOTE     := X_LOTE
   EST031->( dbunlock() )
endif
// .................
   EST009->( dbappend() )

   EST009->LOTE       := X_LOTE
   EST009->NOTAFISCAL := X_NOTAFISCAL
   EST009->DTFISCAL   := X_DTFISCAL
   EST009->ACABAMENTO := X_ACABAMENTO
   EST009->O_PRODUCAO := X_O_PRODUCAO
   EST009->PUNCAO     := X_PUNCAO
   EST009->CORRIDA    := X_CORRIDA
   EST009->CERTIFIC   := X_CERTIFICADO
   EST009->OBS        := X_OBS
   EST009->OBS1       := X_OBS1

   EST009->( dbunlock() )
return
