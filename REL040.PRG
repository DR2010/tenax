/*

   SCM - Sistema de Controle Metalurgico

   REL040.PRG - Lotes Detalhe

*/
#include "inkey.ch"
telanum('SCR040 ','REL040 ')

//
// Arquivos
//
abrir("ESTREPO")
abrir("EST004")
abrir("EST009")
abrir("EST031")

X_LOTEINI := space(05)
X_LOTEFIM := space(05)

//
// variaveis para controle de impressoes geradas para arquivo
//
private W_TITULO := 'Conferencia / Marcacao de Lotes'
private m_busca := {'T','F','L',' '}, id := 1
WRESP_IMP := 'I'
W_IMPARQ  := space(12)

//
// condicoes do sistema
//
private condicao := {|| EST009->( ! eof() ) }
private detalhe  := {|| det_040() }

//
// corpo do programa
//

if par_lote()
   if dh_imprime("G")
      if WRESP_IMP = 'A'
         ESTREPO->( grava( WIMP_ARQ, date(), time(), W_TITULO, 130 ) )
      end
      set device to screen
      @ 24,00 say padc("Gerando Relatorio. Aguarde...")
      set device to print
      det_040()
      @ 00,00 say '' // saltar pagina
      dh_impoff()
   end
end

return

// fim do programa

//
// Cabecalho
//
procedure cab_040()
   @ 01      , 00 say PADC( W_titulo+'             DATA: '+TRIM(DTOC(DATE())),132 )
   
   @ prow()+1, 00 say Replicate('-',132)

   @ prow()+1, 00  say 'Lote'
   @ prow()  , 09  say 'Descricao'
   @ prow()  , 37  say 'Est'
   @ prow()  , 43  say 'Bit/Esp'
   @ prow()  , 64  say 'Bit/Larg'
   @ prow()  , 83  say 'Qt Pcs'
   @ prow()  , 94  say 'Cor'
   @ prow()  , 111 say 'Puncao'
   @ prow()  , 125 say 'Obs'

   @ prow()+1, 00 say Replicate('-',132)

return

//
// Linha detalhe
//
procedure det_040()

   SELECT EST009
   EST009->( dbgotop() )
   EST009->( dbsetorder (1) )
   EST009->( dbseek(X_LOTEINI,.T.) )

   cab_040()

   while .T.
       id := 1
       if prow() > 60
          cab_040()
       end

       if val(EST009->LOTE) > val(X_LOTEFIM)
          exit
       end

       EST031->( dbsetorder (1) )
       if EST031->( dbseek(EST009->LOTE) )

          EST004->( dbsetorder(3) ) // FORMA + TIPO + ESTADO
          EST004->( dbseek( EST031->FORMA+EST031->TIPO+EST031->ESTADO) )
          while !EST004->(FOUND()) .AND. id <= 4
            EST004->( dbseek( EST031->FORMA+EST031->TIPO+m_busca[ id ] ) )
            id++                
          end
/*
-----------------------------------------------------------------------------------------------------------------------------------
Lote     Descricao                   Est   Bit/Esp              Bit/Larg           Qt Pcs     Cor              Puncao        Obs
------------------------------------------------------------------------------------------------------------------------------------
04802 |  ACO SAE 1045 TREF.RED.    |  T |  3    /    76.200 |        /     0.000 |    0 |     VERDE        |             |
------+----------------------------+----+-------------------+--------------------+------+------------------+-------------+----------
04804 |  ACO AISI D6 (VC131) CHATO |  L |  0  3 /4   19.050 |   6  1 /2  165.100 |    0 |     AMA/VERD/AMA |             |
------+----------------------------+----+-------------------+--------------------+------+-----------------+-------------+------
04805 |  ACO AISI D6 (VC131) CHATO |  L |  0  3 /4   19.050 |   2    /    50.800 |    0 |     AMA/VERD/AMA |             |
------+----------------------------+----+-------------------+--------------------+------+-----------------+-------------+------
04806 |  ACO AISI D6 (VC131) RED.  |  L |  0  3 /4   19.050 |        /     0.000 |    0 |     AMA/VERD/AMA |             |
------+----------------------------+----+-------------------+--------------------+------+-----------------+-------------+------
04807 |  ACO AISI D6 (VC131) RED.  |  L |  0  7 /8   22.225 |        /     0.000 |    0 |     AMA/VERD/AMA |             |
------+----------------------------+----+-------------------+--------------------+------+-----------------+-------------+------
*/
          @ prow()+1, 00 say CHR(27)+CHR(71)+EST009->LOTE +CHR(27)+CHR(72)+' |'
        *  @ prow()+1, 00 say EST009->LOTE +' |'
          @ prow()  , 09 say left(EST004->DESCRICAO,25) +' |'
          @ prow()  , 38 say EST031->ESTADO+ ' |'
          @ prow()  , 43 say bitola040()
          @ prow()  , 64 say bitola041()
          @ prow()  , 84 say str(EST031->QTD_INT,3)+' |'
          @ prow()  , 94 say left(EST004->COR,20)+' |' 
          @ prow()  , 111 say EST009->PUNCAO+' |'
       else
          @ prow()+1,00       say EST009->LOTE
          @ prow()  ,08       say "Nao encontrado"
       end
       
       @ prow()+1, 00 say '------+----------------------------+----+-------------------+--------------------+------+------------------+-------------+----------'       

       if prow() > 55
          @ prow()+1, 00 say Replicate('-',132)
          cab_040()
       end

       inkey()
       if lastkey() = K_ESC
          @ row()+1, 04 say ''
          @ row()+1, 04 say ''
          @ row()+1, 00 say padc('****    Impressao interrompida pelo usuario    ****',130)
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

function bitola040()
 //Bit/Esp
 local impt,nums
*  @ prow()  , 43 say EST031->BIT_INT+' '+EST031->BIT_FN+'/'+''+EST031->BIT_FD+''+STR(EST031->BIT_MM,8,3)+' |'
   if EST031->BIT_MM <=0
     nums := SPACE(8)+' |'
   ELSE
     nums := STR(EST031->BIT_MM,8,3)+' |'
   endif
   impt := EST031->BIT_INT+' '+EST031->BIT_FN+'/'+''+EST031->BIT_FD+''+nums
return( impt )  

function bitola041()
 // bitlarg
 local impt,nums
*  @ prow()  , 64 say EST031->ESP_INT+' '+EST031->ESP_FN+'/'+EST031->ESP_FD+''+STR(EST031->ESP_MM,8,3)+' |'
   if EST031->ESP_MM <=0
     nums := SPACE(8)+' |'
   ELSE
     nums := STR(EST031->ESP_MM,8,3)+' |'
   endif
   impt := EST031->ESP_INT+' '+EST031->ESP_FN+'/'+''+EST031->ESP_FD+''+nums
return( impt )  

