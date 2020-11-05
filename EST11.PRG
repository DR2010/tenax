/*

   SCM - Sistema de Controle Metalurgico
   EST11.PRG - Cadastro de Almoxarifado

*/
#include "inkey.ch"

abrir("EST001")
telanum('SCR011','EST011')
private  CAMPO       := {}
private  MASCARA     := {}
private  CABECALHO   := {}
private  TAMANHO     := {}
private  BESCAPE     := {|| .T. }
private  COR         := W_COREDIT
private  TITULO      := " Tabela de Almoxarifados "
private  LININI      := 03
private  LINFIM      := 16
private  COLINI      := 02
private  COLFIM      := 77
private  BLOCK_DISP  := {|| .T. }
private  CAB_TITULO  := nil
private  BORDA       := 1

private  TECLA       := nil
private  TABELA      := nil

aadd( CAMPO     , "ALMOXARI" )
aadd( CAMPO     , "DESCRICAO" )
aadd( MASCARA   , "999"        )
aadd( MASCARA   , "@!"         )
aadd( CABECALHO , "Cod"       )
aadd( CABECALHO , "Descri‡„o" )
aadd( TAMANHO   , 05 )
aadd( TAMANHO   , 70 )

setcolor(W_COREDIT)
status('Cadastro de Almoxarifado')

tedit11()

select EST001

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
	  if !eof()
	     edita11()
	  end
	  keyboard chr(1)

      case TEC = -2   && inclusao f3
	  inser11()
	  keyboard chr(1)

      case TEC = -4   &&  exclusao f5
	  if !eof()
	     if pergunta("Confirma exclus„o do Almoxarifado ? ")
		dbdelete()
		dbskip()
	     end
	   end
	  keyboard chr(1)

      case TEC = -5  && busca direta f6
	 if !eof()
	    busca11()
	 end
	 keyboard chr(1)

      case TEC = K_ESC
	 CONTINUA := .F.
   end
enddo

close data

return

************************************
function inser11()
************************************

private X_ALMOXARI,X_DESCRICAO

setcursor(1)

while .t.

   tela11()

   X_ALMOXARI  := space(3)
   X_DESCRICAO := space(20)

   @ 04,26 get X_ALMOXARI  pict "999" valid zero( X_ALMOXARI, 3 )
   @ 06,26 get X_DESCRICAO pict "@!"
   read

   if empty(X_ALMOXARI) .or. lastkey()=27
      setcursor(0)
      return nil
   end

   X_ALMOXARI:=strzero(val(X_ALMOXARI))

   @ 19,27 say X_ALMOXARI  pict "999"

   if dbseek(X_ALMOXARI)
      message("Almoxarifado j  cadastrado")
      loop
   end

   if pergunta('Confirma inclus„o do Almoxarifado ? ')
      EST001->( dbappend() )
      repl EST001->almoxari  with X_ALMOXARI
      repl EST001->descricao with X_DESCRICAO
      scroll(09,27,19,54,1)
      EST001->( dbunlock() )
   end

end

************************************
function edita11()
************************************
setcursor(1)

tela11()

@ 04,26 say EST001->ALMOXARI
X_DESCRICAO := EST001->DESCRICAO

@ 06,26 get X_DESCRICAO pict "@!"
read

if empty(X_DESCRICAO) .or. lastkey()=27
   setcursor(0)
   return nil
end

while EST001->( ! rlock() ); end
EST001->descricao := X_DESCRICAO
EST001->( dbunlock() )

setcursor(0)

return nil

************************************
function busca11()
************************************

private X_ALMOXARI := space(3)
private TB := savescreen(14,29,17,46)

setcursor(1)

@ 14,29 say "ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿"
@ 15,29 say '³ C¢digo..      ³'
@ 16,29 say "ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ"

sombra(14,29,16,45)

@ 15,40 get X_ALMOXARI pict "999" valid zero( X_ALMOXARI, 3 )
read

if empty(X_ALMOXARI) .or. lastkey()=27
   setcursor(0)
   keyboar " "
   restscreen(14,29,17,46,tb)
   return nil
end

X_ALMOXARI:= strzero(val(X_ALMOXARI),3)
dbseek(X_ALMOXARI,.t.)
setcursor(0)
restscreen(14,29,17,46,tb)

return nil


/*
-------------------------------------------------------------------------------
Procedimento .: TEDIT11
Objetivo .....: Menu rapido
-------------------------------------------------------------------------------
*/
procedure tedit11()
   local W_OLDCOR := setcolor()

   setcolor(W_COREDIT)
   quadro(03,02,21,77,"")
   @ 05,02 say 'Æ'
   @ 05,77 say 'µ'
   @ 16,03 to 16,76 double
   @ 16,02 say 'Æ'
   @ 16,77 say 'µ'

   sombra(02,02,21,77)

   cria_but( 17,07,' Incluir '   ,17,08,"I")
   cria_but( 17,18,' Alterar '   ,17,19,"A")
   cria_but( 17,29,' Excluir '   ,17,30,"E")
   cria_but( 17,40,' Retornar '  ,17,41,"R")

   setcolor( W_OLDCOR )
return


/*
-------------------------------------------------------------------------------
Procedimento .: TELA11
Objetivo .....: Menu rapido
-------------------------------------------------------------------------------
*/
procedure tela11()

   setcolor( W_COREDIT )
   @ 05,02 say '³'
   @ 05,77 say '³'
   setcolor( W_CORGET )
   @ 04,03 say ' C¢digo Almoxarifado :                                                    '
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

