/*

   ESTERRO.PRG - Cadastro de Programas

*/
#include "inkey.ch"
altd(1)

telanum('SESTERRO','ESTERRO')

abrir("ESTERRO")

private  CAMPO	     := {}
private  MASCARA     := {}
private  CABECALHO   := {}
private  TAMANHO     := {}
private  BESCAPE     := {|| .T. }
private  COR	     := W_COREDIT
private  TITULO      := " Erros "
private  LININI      := 03
private  LINFIM      := 22
private  COLINI      := 02
private  COLFIM      := 77
private  BLOCK_DISP  := {|| .T. }
private  CAB_TITULO  := nil
private  BORDA	     := 1

private  TECLA	     := nil
private  TABELA      := nil

aadd( CAMPO	, "SUBSYSTEM"        )
aadd( CAMPO	, "SUBCODE"          )
aadd( CAMPO	, "DESCRESU"         )
aadd( CAMPO	, "DESCRICAO"        )

aadd( MASCARA	, "@!"               )
aadd( MASCARA	, "@!"               )
aadd( MASCARA	, "@!"               )
aadd( MASCARA	, "@!"               )

aadd( CABECALHO , "Subsystem"        )
aadd( CABECALHO , "Subcode"          )
aadd( CABECALHO , "Resumo"           )
aadd( CABECALHO , "Descricao"        )

aadd( TAMANHO	, 12		     )
aadd( TAMANHO	, 12		     )
aadd( TAMANHO	, 25		     )
aadd( TAMANHO	, 25		     )

setcolor(W_COREDIT)
t0_ESTERRO()

select ESTERRO
ESTERRO->(Dbsetorder(1))

TABELA := tabelanew( CAMPO	    , ;
		     MASCARA	    , ;
		     CABECALHO	    , ;
		     TAMANHO	    , ;
		     BESCAPE	    , ;
		     COR	    , ;
		     TITULO	    , ;
		     LININI	    , ;
		     LINFIM	    , ;
		     COLINI	    , ;
		     BLOCK_DISP     , ;
		     CAB_TITULO     , ;
		     BORDA	    , ;
		     COLFIM	      ;
		   )

CONTINUA := .T.
do while CONTINUA .and. ( (TEC:=tabmov(TABELA)) != K_ESC )

  mensagem('<F3> - Inclui / <F4> - Altera / <F5> - Exclui')

   do case
      case TEC == 28 ; help() ; return 1
      case TEC == 27 ; return 0

      case TEC == -3   && alteracao f4
	   if ESTERRO->(!eof())
	      edit_ESTERRO()
	   end
	   keyboard chr(1)

      case TEC = -2   && inclusao f3
	   ins_ESTERRO()
	   keyboard chr(1)

      case TEC = -4   &&  exclusao f5
	   if ESTERRO->(!eof())
	      if pergunta("Confirma exclusao da ESTERRO (S/N) ?")
		 while ESTERRO->( ! rlock() ); end
		 ESTERRO->( dbdelete() )
		 ESTERRO->( dbunlock() )
		 ESTERRO->( dbskip() )
	      end
	   end
	   keyboard chr(1)

      case TEC = K_ESC
	   CONTINUA := .F.

   end

   select ESTERRO
   ESTERRO->(Dbsetorder(1))

enddo

close data

return

************************************
function ins_ESTERRO()
************************************

private X_SUBSYSTEM,X_SUBCODE, X_DESCRICAO

setcursor(1)

while .t.

   t1_ESTERRO()

   X_SUBSYSTEM	  := space(10)
   X_SUBCODE	  := space(10)
   X_DESCRESU	  := space(20)
   X_DESCRICAO	  := space(40)

   @ 04,26 get X_SUBSYSTEM   picture "@!" valid ! empty( X_SUBSYSTEM )
   @ 06,26 get X_SUBCODE     picture "@!" valid ! empty( X_SUBCODE   )
   @ 08,26 get X_DESCRICAO   picture "@!"
   @ 10,26 get X_DESCRESU    picture "@!" valid ! empty( X_DESCRESU )
   read

   if lastkey()=27; exit; end

   X_SUBCODE := STRZERO( VAL( X_SUBCODE ), 10 )

   ESTERRO->(Dbsetorder(1))
   if ESTERRO->( dbseek(X_SUBSYSTEM + X_SUBCODE ) )
      mensbeep(" Erro ja cadastrado.")
      loop
   end

   if pergunta('Confirma inclusao do Erro (S/N) ?')
      ESTERRO->( dbappend() )
      ESTERRO->SUBSYSTEM  := X_SUBSYSTEM
      ESTERRO->SUBCODE	  := X_SUBCODE
      ESTERRO->DESCRESU   := X_DESCRESU
      ESTERRO->DESCRICAO  := X_DESCRICAO
      scroll(09,27,19,54,1)
      ESTERRO->( dbunlock() )
   end

end

************************************
function edit_ESTERRO()
************************************
setcursor(1)

t1_ESTERRO()


@ 04,26 say ESTERRO->SUBSYSTEM
@ 06,26 say ESTERRO->SUBCODE

X_DESCRICAO := ESTERRO->DESCRICAO
X_DESCRESU  := ESTERRO->DESCRESU

while .t.
   @ 08,26 get X_DESCRICAO
   @ 10,26 get X_DESCRESU   picture "@!"
   read

   if empty(X_SUBCODE) .or. lastkey()=27
      setcursor(0)
      return nil
   end

   // Busca por DESCRICAO existente
   ESTERRO->( dbsetorder(2) )
   ESTERRO->( dbseek( X_DESCRICAO ))
   if ESTERRO->( found() )
      mensbeep("DESCRICAO ja cadastrada !")
      loop
   end
   exit

end

ESTERRO->( dbsetorder(1) )
ESTERRO->( dbseek( X_SUBSYSTEM ))

while ESTERRO->( ! rlock() ); end
ESTERRO->DESCRICAO := X_DESCRICAO
ESTERRO->DESCRESU  := X_DESCRESU
ESTERRO->( dbunlock() )


setcursor(0)

return nil

/*
-------------------------------------------------------------------------------
Procedimento .: T0_ESTERRO
Objetivo .....: Menu rapido
-------------------------------------------------------------------------------
*/
procedure t0_ESTERRO()
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
Procedimento .: T1_ESTERRO
Objetivo .....: Menu rapido
-------------------------------------------------------------------------------
*/
procedure t1_ESTERRO()

   setcolor( W_COREDIT )
   @ 05,02 say '³'
   @ 05,77 say '³'
   setcolor( W_CORGET )
   @ 04,03 say ' Subsystem ..........:                                                    '
   @ 05,03 say '                                                                          '
   @ 06,03 say ' Subcode ............:                                                    '
   @ 07,03 say '                                                                          '
   @ 08,03 say ' Descricao ..........:                                                    '
   @ 09,03 say '                                                                          '
   @ 10,03 say ' Resumo .............:                                                    '
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






