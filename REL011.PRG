/*

   SCM - Sistema de Controle Metalurgico

   REL011.PRG - Lotes Detalhe

*/
#include "inkey.ch"
telanum('SCR011 ','REL011 ')

//
// Arquivos
//
abrir("ESTREPO")
abrir("EST009")
abrir("EST031")

X_LOTEINI := space(05)
X_LOTEFIM := space(05)

//
// variaveis para controle de impressoes geradas para arquivo
//
private W_TITULO := 'Lotes Detalhe'
WRESP_IMP := 'I'
W_IMPARQ  := space(12)

//
// condicoes do sistema
//
private condicao := {|| EST009->( ! eof() ) }
private detalhe  := {|| det_011() }

//
// corpo do programa
//

if par_lote()
   if dh_imprime()
      if WRESP_IMP = 'A'
         ESTREPO->( grava( WIMP_ARQ, date(), time(), W_TITULO, 80 ) )
      end
      set device to screen
      @ 24,00 say padc("Gerando Relatorio. Aguarde...")
      set device to print
      det_011()
      @ 00,00 say '' // saltar pagina
      dh_impoff()
   end
end

return

// fim do programa

//
// Cabecalho
//
procedure cab_011()
   @ 01      , 00 say PADC( "Detalhamento Lote",128 )
   @ prow()+1, 00 say Replicate('-',128)

   @ prow()+1, 00 say ' Lote Forma Tipo  Est.    Pol     mm        Pol     mm      Qt.Pc  Q.Kg  Orig. '
   @ prow()+1, 06       say 'NotaFiscal'
   @ prow(),   pcol()+1 say 'DtFiscal'
   @ prow(),   pcol()+1 say 'Acabamento-----'
   @ prow(),   pcol()+1 say 'O_Producao'
   @ prow(),   pcol()+1 say 'Puncao---'
   @ prow(),   pcol()+1 say 'Corrida--'
   @ prow(),   pcol()+1 say 'Certific-'
   @ prow(),   pcol()+1 say 'Obs-------------------------------------------'
   @ prow()+1, 00 say Replicate('-',128)

return

//
// Linha detalhe
//
procedure det_011()

   SELECT EST009
   EST009->( dbgotop() )
   EST009->( dbsetorder (1) )
   EST009->( dbseek(X_LOTEINI,.T.) )

   cab_011()

   while .T.

       if prow() > 60
          cab_011()
       end

       if val(EST009->LOTE) > val(X_LOTEFIM)
          exit
       end

       EST031->( dbsetorder (1) )
       if EST031->( dbseek(EST009->LOTE) )
          @ prow()+1,00       say EST009->LOTE
          @ prow()  ,08       say EST031->FORMA+' '+EST031->TIPO+'  '+EST031->ESTADO
          @ prow()  ,22       say EST031->BIT_INT+' '+EST031->BIT_FN+'/'+''+EST031->BIT_FD+''+STR(EST031->BIT_MM,8,3)
          @ prow()  ,pcol()+2 say EST031->ESP_INT+' '+EST031->ESP_FN+'/'+EST031->ESP_FD+''+STR(EST031->ESP_MM,8,3)
          @ prow()  ,pcol()+2 say str (EST031->QTD_INT,5)
          @ prow()  ,pcol()+2 say str (EST031->QTD_KGT,5)
          @ prow()  ,pcol()+3 say left(EST031->ORIGEM,3)

          @ prow()+1,06       say EST009->NOTAFISCAL
          @ prow()  ,pcol()+1 say EST009->DTFISCAL
          @ prow()  ,pcol()+1 say EST009->ACABAMENTO
          @ prow()  ,pcol()+1 say EST009->O_PRODUCAO
          @ prow()  ,pcol()+1 say EST009->PUNCAO
          @ prow()  ,pcol()+1 say EST009->CORRIDA
          @ prow()  ,pcol()+1 say EST009->CERTIFIC
          @ prow()+1,02       say EST009->OBS
          @ prow()+1,02       say EST009->OBS1
       else
          @ prow()+1,00       say EST009->LOTE
          @ prow()  ,08       say "Nao encontrado"
       end

       if prow() > 55
          @ prow()+1, 00 say '+-----------------------------------------------------------------------------+'
          cab_011()
       end

       inkey()
       if lastkey() = K_ESC
          @ row()+1, 04 say ''
          @ row()+1, 04 say ''
          @ row()+1, 00 say padc('****    Impressao interrompida pelo usuario    ****',80)
          @ row()+1, 04 say ''
          @ row()+1, 04 say ''
          EST009->( dbgobottom())
          EST009->( dbskip())
          exit
       end
       EST009->( dbskip())

       if EST009->( eof() )
          exit
       end
   end
return

