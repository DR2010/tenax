/*

   SCM - Sistema de Controle Metalurgico
   EST98.PRG  - Itens de Lote

   REL008.PRG - Itens de Lote

*/
#include "inkey.ch"

//
// Arquivos
//
abrir("ESTREPO")
abrir("EST010")
abrir("EST004")
abrir("EST031")
abrir("EST007")

//
// variaveis para controle de impressoes geradas para arquivo
//
private W_TITULO := 'Itens de Lote'
WRESP_IMP := 'I'
W_IMPARQ  := space(12)

private condicao := {|| EST007->( ! eof()) }
private detalhe  := {|| det_98() },;
	FLAG := 0		  ,;
	lote1	   :=  space(05)  ,;
	lote2	   :=  space(05)  ,;
        X_LOTEINI   :=  space(05)  ,;
        X_LOTEFIM   :=  space(05)  ,;
        X_LOTE     :=  space(05)  ,;
	NUMPAG	   := 0 	  ,;
	t_modo	   := 0 	  ,;
	OLD_STATUS := savescreen(24,00,24,79)
	@ 24,00 say padc("Gerando o relatorio. Aguarde um instante...")

telanum('SCR98 ','EST98 ')

SET WRAP ON
W_TELA := savescreen(,,,,)

if parametro()

   imp98()

end

/*
-----------------------------------------------------------------------------
		      Parametro de Data Inicial / Final
-----------------------------------------------------------------------------
*/
function parametro()

local WRET:= .T.

WSCRDUP := savescreen(,,,,)

setcursor(1)

X_LOTEINI := space(05)
X_LOTEFIM := space(05)

@ 10,14 say '旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴�'
@ 11,14 say '�                             �'
@ 12,14 say '� Lote.....:       a          �'
@ 13,14 say '�                             �'
@ 14,14 say '읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴�'

@ 12,27 get X_LOTEINI picture '@!'
@ 12,35 get X_LOTEFIM picture '@!'
read
if lastkey() = K_ESC
   WRET := .F.
end

restscreen(,,,,WSCRDUP )

setcursor(0)

return WRET

*-------------------------------------------------------------------------------
				function  imp98()
*-------------------------------------------------------------------------------

  if dh_imprime()
       if WRESP_IMP = 'A'
	  ESTREPO->( grava( WIMP_ARQ, date(), time(), W_TITULO, 80) )
       end
       set device to screen
       @ 24,00 say padc("Gerando Relatorio. Aguarde...")
       set device to print
       det_98()
       @ 00,00 say '' // saltar pagina
       dh_impoff()
       restscreen(24,00,24,79, OLD_STATUS)
  elseif t_modo=1
   imp9801()
 end
return nil


// fim do programa
/*
-----------------------------------------------------------------------------
		      Procedimento Tit_98()
-----------------------------------------------------------------------------
*/
procedure tit_98()


     @ 01     , 00 say '+-----------------------------------------------------------------------------+'
    @ prow()+1, 00 say '|                             Tenax  Aco  e  Ferro                            |'
    @ prow()+1, 00 say '|                              Listagem de Lotes                              | '
    @ prow()  , 70 say 'Pag.: ' + strzero(++NUMPAG,2)
    @ prow()+1, 00 say '|-----------------------------------------------------------------------------|'
    @ prow()+1, 00 say '|---------------------------Bit/Esp----------Bit/Larg-------------------------|'
    @ prow()+1, 00 say '|Lote Forma Tipo  Est.    Pol     mm        Pol     mm      Qt.Pc  Q.Kg  Orig.|'
    @ prow()+1, 00 say '+-----------------------------------------------------------------------------+'
return
/*
-----------------------------------------------------------------------------
		      Procedimento Det_98
-----------------------------------------------------------------------------
*/

procedure det_98()


SELECT EST031
EST031->( dbgotop() )
EST031->( dbsetorder (1) )
EST031->( dbseek( X_LOTE ) )

//  while .t.
  while EST031->( ! eof() )      .and.;
        EST031->LOTE >= X_LOTEINI .and.;
        EST031->LOTE <= X_LOTEFIM

      if flag==0
	 tit_98()
	 FLAG:=1
       end

	 @ prow()+1, 00 say '|'
	 @ prow() ,01 say EST031->lote
	 @ prow() ,08 say EST031->FORMA+' '+EST031->TIPO+'  '+EST031->ESTADO
	 @ prow() ,22 say EST031->BIT_INT+' '+EST031->BIT_FN+'/'+''+EST031->BIT_FD+''+STR(BIT_MM,8,3)
	 @ prow() ,pcol()+2 say EST031->ESP_INT+' '+EST031->ESP_FN+'/'+EST031->ESP_FD+''+STR(ESP_MM,8,3)
	 @ prow() ,pcol()+2 say str(EST031->QTD_INT,5)
	 @ prow() ,pcol()+2 say str(EST031->QTD_KGT,5)
	 @ prow() ,pcol()+3 say left( EST031->ORIGEM,3)
	 @ prow() ,78 say '|'

	      if prow() > 55
		 @ prow()+1, 00 say '+-----------------------------------------------------------------------------+'
		 tit_98()
	      end

//             if  EST031->( eof() )
//                 EST031->LOTE >= X_LOTEINI .and.;
//                 EST031->LOTE <= X_LOTEFIM
//                 exit
//             end
	      inkey()
	      if lastkey() = K_ESC
		 @ row()+1, 04 say ''
		 @ row()+1, 04 say ''
		 @ row()+1, 00 say padc('****    Impressao interrompida pelo usuario    ****',80)
		 @ row()+1, 04 say ''
		 @ row()+1, 04 say ''
		 EST031->( dbgobottom())
		EST031->( dbskip())

		exit
	      end
	    EST031->( dbskip())
  end
return


*-------------------------------------------------------------------------------
				function  imp9801()
*-------------------------------------------------------------------------------

       set device to screen
       clear
       det_9801()
//	 rodape_9801()
  //	  INKEY(0)
       restscreen(24,00,24,79, OLD_STATUS)
return nil

return


// fim do programa
/*
-----------------------------------------------------------------------------
			 procedure tit_9801()
-----------------------------------------------------------------------------
*/
procedure tit_9801()
    @ 00     , 00 say '旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�'
    @ row()+1, 00 say '�                             Tenax  Aco  e  Ferro                            �'
    @ row()+1, 00 say '�                              Listagem de Lotes                              � '
    @ row()  , 70 say 'Pag.: ' + strzero(++NUMPAG,2)
    @ row()+1, 00 say '쳐컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�'
    @ row()+1, 00 say '쳐컴컴컴컴컴컴컴컴컴컴컴컴컴Bit/Esp컴컴컴컴컴Bit/Larg컴컴컴컴컴컴컴컴컴컴컴컴캑'
    @ row()+1, 00 say '쿗ote Forma Tipo  Est.    Pol     mm        Pol     mm      Qt.Pc  Q.Kg  Orig.�'
    @ row()+1, 00 say '읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�'
return
/*
-----------------------------------------------------------------------------
		      Procedimento Det_9801
-----------------------------------------------------------------------------
*/
procedure det_9801()


SELECT EST031
EST031->( dbgotop() )
EST031->( dbsetorder (1) )

//EST031->( dbseek( lote1 ) )
//if EST031->( ! found() )
//    mensbeep('Lote nao encontrado.<ENTER>')
//    return
//end
Lin=07
flag=0

  while .t.	//EST031->( ! eof() )
      if flag==0
	 tit_9801()
	 FLAG:=1
       end
	 @ lin,01 say EST031->lote
	 @ lin,08 say EST031->FORMA+' '+EST031->TIPO+'  '+EST031->ESTADO
	 @ lin,22 say EST031->BIT_INT+' '+EST031->BIT_FN+'/'+''+EST031->BIT_FD+''+STR(BIT_MM,8,3)
	 @ lin,COL()+2 say EST031->ESP_INT+' '+EST031->ESP_FN+'/'+EST031->ESP_FD+''+STR(ESP_MM,8,3) //38 say
	 @ lin,COL()+2 say str(EST031->QTD_INT,5)
	 @ lin,COL()+2 say str(EST031->QTD_KGT,5)
	 @ lin,COL()+3 say left( EST031->ORIGEM,3)
	     if LIN = 23
		@ row()+1, 15 say 'Pressione qualquer tecla p/ continuar...'
		inkey(0)
		@ 06,01 CLEAR TO 24,79
		Lin:=06
		flag=0
	     end
	     if  EST031->( eof() )
	     @ 24, 15 say '                      FIM DE SERVICO  !!!'
		 inkey(0)
		 exit
	     end
		  LIN += 1
	      inkey()
	      if lastkey() = K_ESC
		 @ row()+1, 04 say ''
		 @ row()+1, 04 say ''
		 @ row()+1, 00 say padc('****    Impressao interrompida pelo usuario    ****',80)
		 @ row()+1, 04 say ''
		 @ row()+1, 04 say ''
		 EST007->( dbgobottom())
		EST007->( dbskip())

		exit
	      end
	    EST031->( dbskip())
end
return


