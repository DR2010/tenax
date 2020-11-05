
/*
   VEN0400.PRG - Contato com Clientes
*/

#include "inkey.ch"

telanum('SCE0400','VEN0400')

abrir("VEN0001")
abrir("VEN0400")

private  CAMPO       := {}
private  MASCARA     := {}
private  CABECALHO   := {}
private  TAMANHO     := {}
private  BESCAPE     := {|| .T. }
private  COR         := W_COREDIT
private  TITULO      := " Contato com Clientes "
private  LININI      := 03
private  LINFIM      := 22
private  COLINI      := 02
private  COLFIM      := 77
private  BLOCK_DISP  := {|| .T. }
private  CAB_TITULO  := nil
private  BORDA       := 1

private  TECLA       := nil
private  TABELA      := nil

aadd( CAMPO     , "CODCLI"     )
aadd( CAMPO     , "DTCONTATO"  )
aadd( CAMPO     , "CONTATO"    )
aadd( CAMPO     , "OBS01"      )
aadd( MASCARA   , "@!"         )
aadd( MASCARA   , "@!"         )
aadd( MASCARA   , "@!"         )
aadd( MASCARA   , "@!"         )
aadd( CABECALHO , "Cliente"    )
aadd( CABECALHO , "Data"       )
aadd( CABECALHO , "Contato"    )
aadd( CABECALHO , "Observacao" )
aadd( TAMANHO   , 05           )
aadd( TAMANHO   , 08           )
aadd( TAMANHO   , 10           )
aadd( TAMANHO   , 50           )

setcolor(W_COREDIT)
tedite0400()

select VEN0400

TABELA := tabelanew( CAMPO          , ;
                     MASCARA        , ;
                     CABECALHO      , ;
                     TAMANHO        , ;
                     BESCAPE        , ;
                     COR            , ;
                     TITULO         , ;
                     LININI         , ;
                     LINFIM         , ;
                     COLINI         , ;
                     BLOCK_DISP     , ;
                     CAB_TITULO     , ;
                     BORDA          , ;
                     COLFIM           ;
                   )

CONTINUA := .T.
do while CONTINUA .and. ( (TEC:=tabmov(TABELA)) != K_ESC )

   do case
      case TEC == 28 ; help() ; return 1

      case TEC == 27 ; return 0

      case TEC == -3   && alteracao f4
          if VEN0400->(!eof())
             editae0400()
          end
          keyboard chr(1)

      case TEC = -2   && inclusao f3
          insere0400()
          keyboard chr(1)

      case TEC = -4   &&  exclusao f5
          if !eof()
             if pergunta("Confirma excluso do Contato(S/N) ?")
                while VEN0400->( ! rlock() ); end
                VEN0400->( dbdelete() )
                VEN0400->( dbunlock() )
                VEN0400->( dbskip()   )
             end
           end
          keyboard chr(1)

      case TEC = K_ESC
         CONTINUA := .F.
   end
   select VEN0400
enddo

close data

return

************************************
function insere0400()
************************************

local X_OBS01,X_OBS02, X_OBS03,X_OBS04, X_OBS05
 
private X_CODCLI,X_DTCONTATO,X_CONTATO

X_DTCONTATO := date()
setcursor(1)

while .t.

   telae0400()

   X_CODCLI  := space(5)
   X_CONTATO := spaces(10)
   X_OBS01   := X_OBS02 := X_OBS03 := X_OBS04 := X_OBS05 := space(50)
   
   @ 04,17 get X_CODCLI      picture "@!" valid tes_codcli(X_CODCLI,05,17)
   @ 05,17 say VEN001->CODVEN
   @ 07,17 say X_DTCONTATO
   @ 08,17 get X_CONTATO
   @ 11,07 get X_OBS01        picture "@!"
   @ 12,07 get X_OBS02        picture "@!"
   @ 13,07 get X_OBS03        picture "@!"
   @ 14,07 get X_OBS04        picture "@!"
   @ 15,07 get X_OBS05        picture "@!"
   read

   if lastkey()=27; exit; end

   X_CODCLI := zerofill( X_CODCLI )

   @ 04,26 say X_CODCLI

   if dbseek(X_CODCLI)
      mensbeep(" Area j  cadastrada ")
      loop
   end

   if pergunta('Confirma incluso da Contato (S/N) ?')
      VEN0400->( dbappend() )
      VEN0400->CODCLI    :=   X_CODCLI
      VEN0400->CODVEN    :=   VEN001->CODVEN
      VEN0400->DTCONTATO :=   X_DTCONTATO
      VEN0400->CONTATO   :=   X_CONTATO
      VEN0400->CODVEN    :=   VEN001->CODVEN
      VEN0400->OBS01     :=   X_OBS01
      VEN0400->OBS02     :=   X_OBS02
      VEN0400->OBS03     :=   X_OBS03
      VEN0400->OBS04     :=   X_OBS04
      VEN0400->OBS05     :=   X_OBS05
      scroll(09,27,19,54,1)
      VEN0400->( dbunlock() )
   end

end

************************************
function editae0400()
************************************
LOCAL X_OBS01
LOCAL X_OBS02
LOCAL X_OBS03
LOCAL X_OBS04
LOCAL X_OBS05
local X_DTCONTATO
local X_CONTATO

setcursor(1)

telae0400()

X_DTCONTATO := date()

@ 04,17 say VEN0400->CODCLI
@ 05,17 say VEN0400->CODVEN
@ 07,17 say X_DTCONTATO

X_OBS01     := VEN0400->OBS01
X_OBS02     := VEN0400->OBS02
X_OBS03     := VEN0400->OBS03
X_OBS04     := VEN0400->OBS04
X_OBS05     := VEN0400->OBS05

while .t.

 @ 08,17 get X_CONTATO      pict "@!"
 @ 11,07 get X_OBS01        pict "@!"
 @ 12,07 get X_OBS02        pict "@!"
 @ 13,07 get X_OBS03        pict "@!"
 @ 14,07 get X_OBS04        pict "@!"
 @ 15,07 get X_OBS05        pict "@!"
 read

 if pergunta("Confirma alteracao do Contato (S/N) ?")
   while VEN0400->( ! rlock() ); end
   VEN0400->DTCONTATO  :=   X_DTCONTATO
   VEN0400->CONTATO    :=   X_CONTATO
   VEN0400->OBS01      :=   X_OBS01
   VEN0400->OBS02      :=   X_OBS02
   VEN0400->OBS03      :=   X_OBS03
   VEN0400->OBS04      :=   X_OBS04
   VEN0400->OBS05      :=   X_OBS05
   VEN0400->( dbunlock() )
 end
end
setcursor(0)

return nil
/*
-------------------------------------------------------------------------------
Procedimento .: TEDITe0400
Objetivo .....: Menu rapido
-------------------------------------------------------------------------------
*/
procedure tedite0400()
   local W_OLDCOR := setcolor()

   setcolor(W_COREDIT)
   quadro(03,02,21,77,"")
   @ 05,02 say 'ฦ'
   @ 05,77 say 'ต'
   @ 16,03 to 16,76 double
   @ 16,02 say 'ฦ'
   @ 16,77 say 'ต'

   sombra(02,02,21,77)

   setcolor( W_OLDCOR )
return


/*
-------------------------------------------------------------------------------
Procedimento .: TELAe0400
Objetivo .....: Menu rapido
-------------------------------------------------------------------------------
*/
procedure telae0400()

   setcolor( W_COREDIT )
   @ 05,02 say 'ณ'
   @ 05,77 say 'ณ'
   setcolor( W_CORGET )
   @ 04,03 say ' Cliente...:                                                              '
   @ 05,03 say ' Vendedor..:                                                              '
   @ 06,03 say '                                                                          '
   @ 07,03 say ' Data......:                                                              '
   @ 08,03 say ' Contato...:                                                              '
   @ 09,03 say '                                                                          '
   @ 10,03 say ' ษออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออป '
   @ 11,03 say ' บ                                                                      บ '
   @ 12,03 say ' บ                                                                      บ '
   @ 13,03 say ' บ                                                                      บ '
   @ 14,03 say ' บ                                                                      บ '
   @ 15,03 say ' บ                                                                      บ '
   @ 16,03 say ' บ                                                                      บ '
   @ 17,03 say ' บ                                                                      บ '
   @ 18,03 say ' บ                                                                      บ '
   @ 19,03 say ' บ                                                                      บ '
   @ 20,03 say ' บ                                                                      บ '
   @ 21,03 say ' ศออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผ '
   @ 22,03 say '                                                                          '







