/*
   CONTAS A RECEBER/CONTRA RETIRADA
   SR0500.PRG - Cadastro de Vencimentos
*/
#include "inkey.ch"
altd(1)

telanum('SCE0500','SR0500')

abrir("SR0500")

private  CAMPO	     := {}
private  MASCARA     := {}
private  CABECALHO   := {}
private  TAMANHO     := {}
private  BESCAPE     := {|| .T. }
private  COR         := W_COR_002
private  TITULO      := " Tabela de Vencimentos "
private  LININI      := 03
private  LINFIM      := 22
private  COLINI      := 02
private  COLFIM      := 77
private  BLOCK_DISP  := {|| .T. }
private  CAB_TITULO  := nil
private  BORDA	     := 1

private  TECLA	     := nil
private  TABELA      := nil

aadd( CAMPO	, "CODVENC"        )
aadd( CAMPO	, "DESCRICAO"      )
aadd( CAMPO	, "DIAS_1"        )
aadd( CAMPO	, "DIAS_2"        )
aadd( CAMPO	, "DIAS_3"        )
aadd( CAMPO	, "DIAS_4"        )
aadd( CAMPO	, "DIAS_5"        )

aadd( MASCARA	, "@!"             )
aadd( MASCARA	, "@!"             )
aadd( MASCARA	, "99"             )
aadd( MASCARA	, "99"             )
aadd( MASCARA	, "99"             )
aadd( MASCARA	, "99"             )
aadd( MASCARA	, "99"             )

aadd( CABECALHO , "Venc."          )
aadd( CABECALHO , "Descri‡„o"      )
aadd( CABECALHO , "    "           )
aadd( CABECALHO , "    "           )
aadd( CABECALHO , "    "           )
aadd( CABECALHO , "    "           )
aadd( CABECALHO , "Dias"           )

aadd( TAMANHO	, 05		   )
aadd( TAMANHO	, 43		   )
aadd( TAMANHO	, 04		   )
aadd( TAMANHO	, 04		   )
aadd( TAMANHO	, 04		   )
aadd( TAMANHO	, 04		   )
aadd( TAMANHO	, 04		   )

setcolor(W_COR_002)
Stedite500()

select SR0500

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
	  if !eof()
	     Seditae500()
	  end
	  keyboard chr(1)

      case TEC = -2   && inclusao f3
	  Sinsere500()
	  keyboard chr(1)

      case TEC = -4   &&  exclusao f5
	  if !eof()
	     if pergunta("Confirma exclus„o do Vencimento (S/N) ?")
		while SR0500->( ! rlock() ); end
		SR0500->( dbdelete() )
		SR0500->( dbunlock() )
		SR0500->(dbskip())
	     end
	   end
	  keyboard chr(1)

      case TEC = K_ESC
	 CONTINUA := .F.
   end
   select SR0500
enddo

close data

return

************************************
function Sinsere500()
************************************

private S_CODVENC,S_DESCRICAO,S_DIAS_1,S_DIAS_2,S_DIAS_3,S_DIAS_4,S_DIAS_5

setcursor(1)

while .t.

   Stelae500()

   S_CODVENC      := space(2)
   S_DESCRICAO    := space(30)
   S_DIAS_1       := 0
   S_DIAS_2       := 0
   S_DIAS_3       := 0
   S_DIAS_4       := 0
   S_DIAS_5       := 0

   @ 04,20 get S_CODVENC       picture "99" valid ! empty( S_CODVENC   )
   @ 06,20 get S_DESCRICAO     picture "@!"
   @ 08,20 get S_DIAS_1        picture "99"
   @ 08,23 get S_DIAS_2        picture "99" when S_DIAS_1 > 0
   @ 08,26 get S_DIAS_3        picture "99" when S_DIAS_2 > 0
   @ 08,29 get S_DIAS_4        picture "99" when S_DIAS_3 > 0
   @ 08,32 get S_DIAS_5        picture "99" when S_DIAS_4 > 0
   read

   if lastkey()=27; exit; end

   S_CODVENC   := zerofill( S_CODVENC   )

   @ 04,20 say S_CODVENC

   if dbseek(S_CODVENC  )
      mensbeep(" Vencimento j  cadastrado ")
      loop
   end

   W_CONT := 0

   if S_DIAS_1  > 0
      W_CONT := W_CONT + 1
   end
   if S_DIAS_2  > 0
      W_CONT := W_CONT + 1
   end
   if S_DIAS_3  > 0
      W_CONT := W_CONT + 1
   end
   if S_DIAS_4  > 0
      W_CONT := W_CONT + 1
   end
   if S_DIAS_5  > 0
      W_CONT := W_CONT + 1
   end

   if pergunta('Confirma inclus„o do Vencimento (S/N) ?')
      SR0500->( dbappend() )
      SR0500->CODVENC      := S_CODVENC
      SR0500->DESCRICAO    := S_DESCRICAO
      SR0500->DIAS_1       := S_DIAS_1
      SR0500->DIAS_2       := S_DIAS_2
      SR0500->DIAS_3       := S_DIAS_3
      SR0500->DIAS_4       := S_DIAS_4
      SR0500->DIAS_5       := S_DIAS_5
      SR0500->QTDVENC	   := W_CONT
      scroll(09,27,19,54,1)
      SR0500->( dbunlock() )
   end

end

************************************
function Seditae500()
************************************
setcursor(1)

Stelae500()

@ 04,26 say    SR0500->CODVENC

S_DESCRICAO  := SR0500->DESCRICAO
S_DIAS_1     := SR0500->DIAS_1
S_DIAS_2     := SR0500->DIAS_2
S_DIAS_3     := SR0500->DIAS_3
S_DIAS_4     := SR0500->DIAS_4
S_DIAS_5     := SR0500->DIAS_5

@ 06,20 get S_DESCRICAO     picture "@!"
@ 08,20 get S_DIAS_1        picture "99"
@ 08,23 get S_DIAS_2        picture "99" when S_DIAS_1 > 0
@ 08,26 get S_DIAS_3        picture "99" when S_DIAS_2 > 0
@ 08,29 get S_DIAS_4        picture "99" when S_DIAS_3 > 0
@ 08,32 get S_DIAS_5        picture "99" when S_DIAS_4 > 0
read

if lastkey()=27; return nil ; end

while SR0500->( ! rlock() ); end

W_CONT := 0

if S_DIAS_1  > 0
   W_CONT := W_CONT + 1
end
if S_DIAS_2  > 0
   W_CONT := W_CONT + 1
end
if S_DIAS_3  > 0
   W_CONT := W_CONT + 1
end
if S_DIAS_4  > 0
   W_CONT := W_CONT + 1
end
if S_DIAS_5  > 0
   W_CONT := W_CONT + 1
end

SR0500->DESCRICAO   :=  S_DESCRICAO
SR0500->DIAS_1      :=  S_DIAS_1
SR0500->DIAS_2      :=  S_DIAS_2
SR0500->DIAS_3      :=  S_DIAS_3
SR0500->DIAS_4      :=  S_DIAS_4
SR0500->DIAS_5      :=  S_DIAS_5
SR0500->QTDVENC     :=	W_CONT

SR0500->( dbunlock() )

setcursor(0)

return nil


/*
-------------------------------------------------------------------------------
Procedimento .: TEDITe500
Objetivo .....: Menu rapido
-------------------------------------------------------------------------------
*/
procedure Stedite500()
   local W_OLDCOR := setcolor()

   setcolor(W_COR_002)
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
Procedimento .: TELAe500
Objetivo .....: Menu rapido
-------------------------------------------------------------------------------
*/
procedure Stelae500()

   setcolor( W_COR_002 )
   @ 05,02 say '³'
   @ 05,77 say '³'
   setcolor( W_COR_002 )
   @ 04,03 say ' Vencimento....:                                                          '
   @ 05,03 say '                                                                          '
   @ 06,03 say ' Descri‡„o.....:                                                          '
   @ 07,03 say '                                                                          '
   @ 08,03 say ' Parcelamento..:   /  /  /  /   Dias                                      '
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






