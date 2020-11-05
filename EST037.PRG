
/*
   EST037.PRG - Cadastro de Areas
*/

#include "inkey.ch"
altd(1)

telanum('SCE037','EST037')

abrir("EST037")

private  CAMPO       := {}
private  MASCARA     := {}
private  CABECALHO   := {}
private  TAMANHO     := {}
private  BESCAPE     := {|| .T. }
private  COR         := W_COREDIT
private  TITULO      := " Tabela de Areas "
private  LININI      := 03
private  LINFIM      := 22
private  COLINI      := 02
private  COLFIM      := 77
private  BLOCK_DISP  := {|| .T. }
private  CAB_TITULO  := nil
private  BORDA       := 1

private  TECLA       := nil
private  TABELA      := nil

aadd( CAMPO     , "CODAREA"   )
aadd( CAMPO     , "DESCRICAO" )
aadd( MASCARA   , "99"        )
aadd( MASCARA   , "@!"        )
aadd( CABECALHO , "Area"      )
aadd( CABECALHO , "Descri‡„o" )
aadd( TAMANHO   , 05 )
aadd( TAMANHO   , 70 )

setcolor(W_COREDIT)
tedite037()

select EST037

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

  mensagem('<F3> - Inclui / <F4> - Altera / <F5> - Exclui')

   do case
      case TEC == 28 ; help() ; return 1

      case TEC == 27 ; return 0

      case TEC == -3   && alteracao f4
          if !eof()
             editae037()
          end
          keyboard chr(1)

      case TEC = -2   && inclusao f3
          insere037()
          keyboard chr(1)

      case TEC = -4   &&  exclusao f5
          if !eof()
             if pergunta("Confirma exclus„o da Area (S/N) ?")
                while EST037->( ! rlock() ); end
                EST037->( dbdelete() )
                EST037->( dbunlock() )
                EST037->( dbskip()   )
             end
           end
          keyboard chr(1)

      case TEC = K_ESC
         CONTINUA := .F.
   end
   select EST037
enddo

close data

return

************************************
function insere037()
************************************

local X_DESC2, X_DESC3,X_DESC4, X_DESC5
 
private X_CODAREA,X_DESCRICAO

setcursor(1)

while .t.

   telae037()

   X_CODAREA      := space(2)
   X_DESCRICAO    := X_DESC2 := X_DESC3 := X_DESC4 := X_DESC5 := space(40)
   
   @ 04,26 get X_CODAREA      picture "99" valid ! empty( X_CODAREA )
   @ 06,26 get X_DESCRICAO    picture "@!"
   @ 07,26 get X_DESC2        picture "@!"
   @ 08,26 get X_DESC3        picture "@!"
   @ 08,26 get X_DESC4        picture "@!"
   @ 08,26 get X_DESC5        picture "@!"
   read

   if lastkey()=27; exit; end

   X_CODAREA := zerofill( X_CODAREA )

   @ 04,26 say X_CODAREA

   if dbseek(X_CODAREA)
      mensbeep(" Area j  cadastrada ")
      loop
   end

   if pergunta('Confirma inclus„o da Area (S/N) ?')
      EST037->( dbappend() )
      repl EST037->CODAREA     with X_CODAREA
      repl EST037->DESCRICAO   with ALLTRIM(X_DESCRICAO)+ALLTRIM(X_DESC2)+ALLTRIM(X_DESC3)+ALLTRIM(X_DESC4)+ALLTRIM(X_DESC5)
      scroll(09,27,19,54,1)
      EST037->( dbunlock() )
   end

end

************************************
function editae037()
************************************
LOCAL X_DESC2 
LOCAL X_DESC3  
LOCAL X_DESC4
LOCAL X_DESC5

setcursor(1)

telae037()

@ 04,26 say    EST037->CODAREA
X_DESCRICAO  := SUBSTR(EST037->DESCRICAO,01,40)
X_DESC2      := SUBSTR(EST037->DESCRICAO,41,40)
X_DESC3      := SUBSTR(EST037->DESCRICAO,81,40)
X_DESC4      := SUBSTR(EST037->DESCRICAO,81,40)
X_DESC4      := SUBSTR(EST037->DESCRICAO,81,40)

while .t.
                                 
 @ 06,26 get X_DESCRICAO pict "@!"
 @ 07,26 get X_DESC2        picture "@!"
 @ 08,26 get X_DESC3        picture "@!"
 @ 08,26 get X_DESC4        picture "@!"
 @ 08,26 get X_DESC5        picture "@!"
 read

 if empty(X_DESCRICAO) .or. lastkey()=27
   setcursor(0)
   return nil
 end
 if pergunta("Confirma alteracao da Area (S/N) ?")
   while EST037->( ! rlock() ); end
   EST037->descricao := X_DESCRICAO+ALLTRIM(X_DESC2)+ALLTRIM(X_DESC3)+ALLTRIM(X_DESC4)+ALLTRIM(X_DESC5)
   EST037->( dbunlock() )
 end
end
setcursor(0)

return nil


/*
-------------------------------------------------------------------------------
Procedimento .: TEDITe037
Objetivo .....: Menu rapido
-------------------------------------------------------------------------------
*/
procedure tedite037()
   local W_OLDCOR := setcolor()

   setcolor(W_COREDIT)
   quadro(03,02,21,77,"")
   @ 05,02 say 'Æ'
   @ 05,77 say 'µ'
   @ 16,03 to 16,76 double
   @ 16,02 say 'Æ'
   @ 16,77 say 'µ'

   sombra(02,02,21,77)

   setcolor( W_OLDCOR )
return


/*
-------------------------------------------------------------------------------
Procedimento .: TELAe037
Objetivo .....: Menu rapido
-------------------------------------------------------------------------------
*/
procedure telae037()

   setcolor( W_COREDIT )
   @ 05,02 say '³'
   @ 05,77 say '³'
   setcolor( W_CORGET )
   @ 04,03 say ' C¢digo da Area......:                                                    '
   @ 05,03 say '                                                                          '
   @ 06,03 say ' Descri‡„o ..........:                                                    '
   @ 07,03 say '                                                                          '
   @ 08,03 say '                                                                          '
   @ 09,03 say '                                                                          '
   @ 10,03 say '                                                                          '
   @ 11,03 say '                                                                          '
   @ 12,03 say '                                                                          '
   @ 13,03 say '                                                                          '
   @ 14,03 say '                                                                          '
   @ 15,03 say '                                                                          '
   @ 16,03 say '                                                                          '
   @ 17,03 say '                                                                          '
   @ 18,03 say '                                                                          '
   @ 19,03 say '                                                                          '
   @ 20,03 say '                                                                          '
   @ 21,03 say '                                                                          '
   @ 22,03 say '                                                                          '






