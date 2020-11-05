/*

   SCM - Sistema de Controle Metalurgico
   REL011.PRG - Listagem do Quantidade Comprada

*/
#include "inkey.ch"
telanum('SCR95 ','EST95 ')

//
// Arquivos
//
abrir("ESTREPO")
abrir("EST004")
abrir("EST003")
abrir("EST010")
abrir("EST007")

//
// variaveis para controle de impressoes geradas para arquivo
//
private W_TITULO := 'Listagem Qtde Itens de Estoque'
WRESP_IMP := 'I'
W_IMPARQ  := space(12)

private X_FORMA    := space(03)   ,;
	X_TIPO	   := space(05)   ,;
	X_ESTADO   := space(01)   ,;
	X_BIT_MM   := 0.00	  ,;
	X_ESP_MM   := 0.00	  ,;
	X_BIT_INT  := space(02)   ,;
	X_BIT_FN   := space(02)   ,;
	X_BIT_FD   := space(02)   ,;
	X_ESP_INT  := space(02)   ,;
	X_ESP_FN   := space(02)   ,;
	X_ESP_FD   := space(02)   ,;
	W_TOTAL_KG := 0 	  ,;
        W_DATA_INI := ctod(" ")   ,;
	W_DATA_FIM := ctod(" ")   ,;
	FLAG := 0		  ,;
        TUDO := 0                 ,;
        modo := 0                 ,;
        zero := 0                 ,;
        LIN := 9                 ,;
        POSICAO := NIL            ,;
	NUMPAG	   := 0 	  ,;
        T_MODO:= 0                ,;
        W_CHAVE_ITEM              ,;
        WRET

EST007->( dbsetorder(4) )
OLD_STATUS := savescreen(24,00,24,79)
// condicoes do sistema
private condicao := {|| EST004->( ! eof()) } ,;
        detalhe  := {|| det_95() }           ,;
        NUMPAG   := 0                        ,;
        FLAG     := 0                        ,;
        W_MESSAGE:= savescreen(24,00,24,79)


//
// corpo do programa
//
tela_97()
W_TELA := savescreen(,,,,)
if imp_tela()
    imp95()
end

*-------------------------------------------------------------------------------
                                function  imp95()
*-------------------------------------------------------------------------------


if dh_imprime()
   if WRESP_IMP = 'A'
      ESTREPO->( grava( WIMP_ARQ, date(), time(), W_TITULO, 80) )
   end

   set device to screen
   @ 24,00 say padc("Gerando Relatorio. Aguarde...",78)
   set device to print

   if ! tudo == 1
      if zero != 1
         cab_95()
      end
   end

   det_95()
   if ! tudo == 1
      if zero != 1
         rodape_95()
      end
   end

   @ 00,00 say '' // saltar pagina
   dh_impoff()

   restscreen(24,00,24,79,W_MESSAGE)
elseif t_modo=1
   imp9501()

end

return nil


// fim do programa

//
// Cabecalho
//
procedure cab_95()

    @ 01      , 00 say '+-----------------------------------------------------------------------------+'
    @ prow()+1, 00 say '|  TENAX A‡os Especiais'
    @ prow()  , 52 say 'Data: ' + dtoc(date())
    @ prow()  , 70 say 'Pag.: ' + strzero(++NUMPAG,2) + '  |'
    @ prow()+1, 00 say '|                                                  Per :'
    @ prow()  , 57 say dtoc(W_data_ini)+' `a'
    @ prow()  , 69 say dtoc(W_data_fim)+'  |'
    @ prow()+1, 00 say '|                       Listagem de Quantidade de Itens de Estoque             |'
    @ prow()+1, 00 say '|------------------------------------------------------------------------------|'

return
//
// Titulo do Item
//

/*
-----------------------------------------------------------------------------
                      Procedimento Rodape_95
-----------------------------------------------------------------------------
*/
procedure rodape_95()

    @ prow()+1, 00     say '|------------------------------------------------------------------------------|'
    @ prow()+1, 00     say '|            Total no periodo'
    @ prow()  , 61     say str( W_TOTAL_KG,12,2)
    @ prow(), pcol()+2 say 'Kg'
    @ prow()  , 79     say '|'
    @ prow()+1, 00     say '|------------------------------------------------------------------------------|'

return

procedure Tit_item()
 IF TUDO == 1
   select EST007
    @ prow()+1, 00 say '|------------------------------------------------------------------------------|'
    @ prow()+1, 00 say '|  '+EST004->FORMA+' '+EST004->TIPO+' '+EST004->ESTADO+'       '+EST004->DESCRICAO
    @ prow()  , 79 say '|'
    @ prow()+1, 00 say '|---------------------+---------------------+----------------------------------|'
    @ prow()+1, 00 say '|   Poleg          MM      Poleg      MM     Inteiras   Cortadas  Qtd (kg)     |'
    @ prow()+1, 00 say '|---------------------+---------------------+----------------------------------|'
 else

    EST004->( dbseek(left(W_CHAVE_ITEM,9))) // posiciona para pegar descricao

    @ prow()+1, 00 say '|------------------------------------------------------------------------------|'
    @ prow()+1, 00 say '|'+EST007->FORMA

    @ prow()  , 00 say '|          '+TIPO+' '+X_ESTADO+'  '+est004->descricao

    @ prow()  , 79 say '|'
    @ prow()+1, 00 say '|------------------------------------------------------------------------------|'
    @ prow()+1, 00 say '|   Poleg          MM      Poleg      MM     Inteiras   Cortadas  Qtd (kg)     |'
    @ prow()+1, 00 say '|------------------------------------------------------------------------------|'

end
return

//
// Linha detalhe
//
procedure det_95()


if ! Tudo=1
SELECT EST007
EST007->( dbgotop() )
EST007->( dbsetorder (4) )
EST007->( dbseek( W_CHAVE_ITEM ) )
end
//while .T.

     if tudo == 1
       tudoprn95()
       return
     end

 while  W_CHAVE_ITEM == ( EST007->FORMA )
             imptela001()
             return
end  //else

    while W_CHAVE_ITEM ==( EST007->FORMA+EST007->TIPO+EST007->ESTADO )

             if FLAG++ == 0
                 tit_item()
             end

             if prow() > 55
                @ prow()+1, 00 say '|------------------------------------------------------------------------------|'
                cab_95()
                 tit_item()
             end

          // linha detalhe
             if EST007->DAT_ULT >= W_DATA_INI .and. ;
              ( EST007->DAT_ULT <= W_DATA_FIM .or. empty( W_DATA_FIM ))

                @ prow()+1, 00       say "| "
                @ prow()  , pcol()   say TIRA_ZERO()+padl(EST007->BIT_FN,2)+'/'+padr(EST007->BIT_FD,2)
                @ prow()  , pcol()+3 say str( EST007->BIT_MM, 8, 3 )
                @ prow()  , pcol()+3 say TIRA_ZERO("ESP")+padl(EST007->ESP_FN,2)+'/'+padr(EST007->ESP_FD,2)
                @ prow()  , pcol()+3 say str( EST007->ESP_MM, 8, 3 )
                @ prow()  , pcol()+6 say str(EST007->QTD_INT,5)
                @ prow()  , pcol()+4 say str(EST007->QTD_COR,5)
                @ prow()  , pcol()+3 say str(EST007->QTD_KGT,12,2)
                @ prow()  , pcol()   say " |"
                W_TOTAL_KG += EST007->QTD_KGT
                LIN += 1

              end
             inkey()
             if lastkey() = K_ESC
                @ prow()+1, 04 say ''
                @ prow()+1, 04 say ''
                @ prow()+1, 00 say padc('****    Impressao interrompida pelo usuario    ****',78)
                @ prow()+1, 04 say ''
                @ prow()+1, 04 say ''
                EST007->( dbgobottom())
               EST007->( dbskip())

               return
             end
              EST007->( dbskip())
end    // else

    while W_CHAVE_ITEM == ( EST007->FORMA+EST007->TIPO+EST007->ESTADO +;
                        str( EST007->BIT_MM, 8, 3 ) + STR( ESP_MM,8,3 )  )

             if FLAG++ == 0
                 tit_item()
             end

             if prow() > 55
                @ prow()+1, 00 say '|------------------------------------------------------------------------------|'
                cab_95()
                 tit_item()
             end

          // linha detalhe
             if EST007->DAT_ULT >= W_DATA_INI .and. ;
              ( EST007->DAT_ULT <= W_DATA_FIM .or. empty( W_DATA_FIM ))

                @ prow()+1, 00       say "| "
                @ prow()  , pcol()   say TIRA_ZERO()+padl(EST007->BIT_FN,2)+'/'+padr(EST007->BIT_FD,2)
                @ prow()  , pcol()+3 say str( EST007->BIT_MM, 8, 3 )
                @ prow()  , pcol()+3 say TIRA_ZERO("ESP")+padl(EST007->ESP_FN,2)+'/'+padr(EST007->ESP_FD,2)
                @ prow()  , pcol()+3 say str( EST007->ESP_MM, 8, 3 )
                @ prow()  , pcol()+6 say str(EST007->QTD_INT,5)
                @ prow()  , pcol()+4 say str(EST007->QTD_COR,5)
                @ prow()  , pcol()+3 say str(EST007->QTD_KGT,12,2)
                @ prow()  , pcol()   say " |"
                W_TOTAL_KG += EST007->QTD_KGT
                LIN += 1

              end
             inkey()
             if lastkey() = K_ESC
                @ prow()+1, 04 say ''
                @ prow()+1, 04 say ''
                @ prow()+1, 00 say padc('****    Impressao interrompida pelo usuario    ****',78)
                @ prow()+1, 04 say ''
                @ prow()+1, 04 say ''
                EST007->( dbgobottom())
               EST007->( dbskip())

               return
             end

            EST007->( dbskip())

 end

return



/*
                   Listagem do Cadastro de Itens de Estoque

 |-----------------------+------------------------+-------------------------|
 |                       |        Bitola          |       Espessura         |
 |-----------------------+                        +                         +
 | Forma | Tipo | Estado |   Poleg         MM     |     Poleg        MM     |
 |------------------------------------------------+-------------------------|
 | 123    12345   1       12 + 12/12 12345678.123  12 + 12/12  12345678.123


+------------------------------------------------------------------------------+
|  TENAX A‡os Especiais                            Data: 16/09/95    Pag.: 01  |
|                                                                              |
|                       Listagem de Quantidade de Itens de Estoque             |
|------------------------------------------------------------------------------|
|  001 1020 L       ACO SAE 1020 RED.                                          |
|---------------------+---------------------+----------------------------------|
|  Poleg       MM     |  Poleg       MM     | Inteiras Cortadas Qtd Total (Kg) |
|---------------------+---------------------+----------------------------------|
| 12+12/1 12345678.123  12+12/1 12345678.123   12345   12345   123456789012.12 |
|  1 1 /4    31.750      6 1 /2   165.100           0       1          20.59    |
|  1 3 /4    44.450      2 1 /2    63.500           0       0           0.23    |
|    5 /16    7.938      4   /    101.600           0       0           0.18    |
|    5 /16    7.938      8 1 /2   215.900           0       1          13.30    |
*/


*-------------------------------------------------------------------------------
                                function  imp9501()
*-------------------------------------------------------------------------------

set device to screen
clear
det9501()
if ! tudo==1
   if zero != 1
      rodape_9501()
      INKEY(0)
   end
end
@ 24,15 say'               FIM   DE  SERVICO !!!  '
INKEY(0)
restscreen(24,00,24,79, OLD_STATUS)
return nil

/*
-------------------------------------------------------------------------------
                                 procedure det9501
-------------------------------------------------------------------------------
*/
procedure det9501()

IF ! TUDO=1
SELECT EST007
EST007->( dbgotop() )
EST007->( dbsetorder (4) )
LIN:=09
EST007->( dbseek( W_CHAVE_ITEM ) )
END

     if tudo == 1
       telaprn95()
       return
     end

  if W_CHAVE_ITEM == EST007->FORMA
       tela001()
       return
    end

   while W_CHAVE_ITEM == EST007->FORMA+TIPO+ESTADO

         if flag++ == 0
            tit_item01()
         end

         if LIN=23
            @ row()+2, 15 say 'Pressione qualquer tecla p/ continuar...'
            inkey(0)
            @ 09,01 CLEAR TO 24,79
             Lin:=09
            tit_ITEM01()
         end

         if lastkey() = K_ESC
            @ 05     , 04 say '³                *** Impressao interrompida pelo usuario ***                 ³'
             EST007->( dbgobottom())
             EST007->( dbskip())
             return
         end
         // linha detalhe
              if EST007->DAT_ULT  >= W_DATA_INI .and. ;
               ( EST007->DAT_ULT  <= W_DATA_FIM .or. empty( W_DATA_FIM ))

             //    @ LIN   , 08 say dtoc(EST007->DAT_ULT )
                   @ lin   , 03 say TIRA_ZERO()+padl(EST007->BIT_FN,2)+'/ '+padr(EST007->BIT_FD,2)
                   @ lin   , 15 say str( EST007->BIT_MM, 8, 3 )
                   @ lin   , 25 say TIRA_ZERO("ESP")+padl(EST007->ESP_FN,2)+'/ '+padr(EST007->ESP_FD,2)
                   @ lin   , 33 say str( EST007->ESP_MM, 8, 3 )
                   @ lin   , 45 say str(EST007->QTD_INT,5)
                   @ lin   , 54 say str(EST007->QTD_COR,5)
                   @ lin   , 61 say str(EST007->QTD_KGT,12,2)
                   W_TOTAL_KG += EST007->QTD_KGT
                   LIN += 1
               END
           EST007->( dbskip())
end

   while W_CHAVE_ITEM == EST007->FORMA+TIPO+ESTADO+STR(BIT_MM,8,3)+STR(ESP_MM,8,3)

         if flag++ == 0
            tit_item01()
         end

         if LIN=23
            @ row()+2, 15 say 'Pressione qualquer tecla p/ continuar...'
            inkey(0)
            @ 09,01 CLEAR TO 24,79
             Lin:=09
            tit_ITEM01()
         end

         if lastkey() = K_ESC
            @ 05     , 04 say '³                *** Impressao interrompida pelo usuario ***                 ³'
             EST007->( dbgobottom())
             EST007->( dbskip())
             return
         end
         // linha detalhe
              if EST007->DAT_ULT  >= W_DATA_INI .and. ;
               ( EST007->DAT_ULT  <= W_DATA_FIM .or. empty( W_DATA_FIM ))

             //    @ LIN   , 08 say dtoc(EST007->DAT_ULT )
                   @ lin   , 03 say TIRA_ZERO()+padl(EST007->BIT_FN,2)+'/ '+padr(EST007->BIT_FD,2)
                   @ lin   , 15 say str( EST007->BIT_MM, 8, 3 )
                   @ lin   , 25 say TIRA_ZERO("ESP")+padl(EST007->ESP_FN,2)+'/ '+padr(EST007->ESP_FD,2)
                   @ lin   , 33 say str( EST007->ESP_MM, 8, 3 )
                   @ lin   , 45 say str(EST007->QTD_INT,5)
                   @ lin   , 54 say str(EST007->QTD_COR,5)
                   @ lin   , 61 say str(EST007->QTD_KGT,12,2)
                   W_TOTAL_KG += EST007->QTD_KGT
                   LIN += 1
               END
           EST007->( dbskip())

end
/*
------------------------------------------------------------------------------
                          procedure Tit_item01()
------------------------------------------------------------------------------
*/
procedure Tit_item01()
   if ! Tudo = 1  .and. modo==0
    EST004->( dbseek(left(W_CHAVE_ITEM,9))) // posiciona para pegar descricao
   end
    @ 00     , 00 say 'ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿'
    @ row()+1, 00 say '³                             Tenax  Aco  e  Ferro                            ³'
    @ row()+1, 00 say '³                   Listagem de Quantidade de item de Estoque                 ³'
    @ row()  , 70 say 'Pag.: ' + strzero(++NUMPAG,2)
    @ row()+1, 00 say 'ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ'
    @ 04     , 00 say 'ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿'
    @ row()+1, 00 say '³                                                                             ³'
    @ row()+1, 00 say 'ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´'
    @ row()+1, 00 say '³   Poleg          MM      Poleg      MM     Inteiras   Cortadas  Qtd (kg)    ³'
    @ row()+1, 00 say 'ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ'

    @ 05      , 04 say EST004->FORMA
    @ row()  , 08 say TIPO+' '+X_ESTADO+'  '+EST004->DESCRICAO

return

/*
-----------------------------------------------------------------------------
                      Procedimento Rodape_9501
-----------------------------------------------------------------------------
*/
procedure rodape_9501()

    @ row()+1, 00     say'ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿'
    @ row()+1, 00     say'³           Total no periodo :                                                ³'
    @ row()  , 61     say str( W_TOTAL_KG,12,2)
    @ row()+1, 00     say'ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ'

    return

/*
------------------------------------------------------------------------------
                          function tudoprn95()
------------------------------------------------------------------------------
*/
 function tudoprn95()

while EST004-> ( ! eof() )                 //Listar todos os itens


select est004
est4:=EST004->forma+tipo
EST007->( dbsetorder (4) )
EST007->( dbseek( est4 ) )

if EST007->( ! FOUND() )
  EST004->( dbskip())
  loop
end

  while  est4  == EST007->FORMA+TIPO
  select EST007

	     if prow() > 55
                @ 00, 00 say ''
                @ prow()+1, 00 say '|------------------------------------------------------------------------------|'
                flag:=1
                cab_95()
                tit_ITEM()
	     end

           // linha detalhe
              if EST007->DAT_ULT >= W_DATA_INI .and. ;
               ( EST007->DAT_ULT <= W_DATA_FIM .or. empty( W_DATA_FIM ))

                 if flag == 0
                   cab_95()
                   tit_ITEM()
                   flag:=1
                 end
                @ prow()+1, 00       say "| "
                @ prow()  , pcol()   say TIRA_ZERO()+padl(EST007->BIT_FN,2)+'/'+padr(EST007->BIT_FD,2)
                @ prow()  , pcol()+3 say str( EST007->BIT_MM, 8, 3 )
                @ prow()  , pcol()+3 say TIRA_ZERO("ESP")+padl(EST007->ESP_FN,2)+'/'+padr(EST007->ESP_FD,2)
                @ prow()  , pcol()+3 say str( EST007->ESP_MM, 8, 3 )
                @ prow()  , pcol()+6 say str(EST007->QTD_INT,5)
                @ prow()  , pcol()+4 say str(EST007->QTD_COR,5)
                @ prow()  , pcol()+3 say str(EST007->QTD_KGT,12,2)
                @ prow()  , pcol()   say " |"
                   W_TOTAL_KG += EST007->QTD_KGT

               end
              inkey()
              if lastkey() = K_ESC
                 @ prow()+1, 04 say ''
                 @ prow()+1, 04 say ''
                 @ prow()+1, 00 say padc('****    Impressao interrompida pelo usuario    ****',78)
                 @ prow()+1, 04 say ''
                 @ prow()+1, 04 say ''
                 EST007->( dbgobottom())
                EST007->( dbskip())

               return
	     end
              EST007->( dbskip())

           if  est4 != EST007->FORMA+TIPO .and. flag==1
            rodape_95()
            w_total_kg := 0
           end
    end

              EST004->( dbskip())
              flag:=0
end
return
//----------------------------------------------------------------------------
//----------------------------------------------------------------------------
//----------------------------------------------------------------------------
//----------------------------------------------------------------------------
//                         LISTAGEM  NA    TELA
//----------------------------------------------------------------------------
//----------------------------------------------------------------------------
//----------------------------------------------------------------------------
//----------------------------------------------------------------------------

/*
------------------------------------------------------------------------------
                          function telaprn95()
------------------------------------------------------------------------------
*/
 function telaprn95()


while EST004-> ( ! eof() )                 //      TELA    Listar todos os itens
    select est004
    est4:=EST004->forma+tipo
    EST007->( dbsetorder (4) )
    EST007->( dbseek( est4 ) )
    LIN:=10
    if EST007->( ! FOUND() )
      EST004->( dbskip())
      loop
    end

  while  est4  == EST007->FORMA+TIPO
   select EST007

             if LIN = 23
                @ row()+2, 15 say 'Pressione qualquer tecla p/ continuar...'
                inkey(0)
                @ 09,01 CLEAR TO 24,79
                Lin=10
                flag:=1
                tit_ITEM01()
             end

           // linha detalhe
              if EST007->DAT_ULT >= W_DATA_INI .and. ;
               ( EST007->DAT_ULT <= W_DATA_FIM .or. empty( W_DATA_FIM ))

                 if flag == 0
                   tit_ITEM01()
                   flag:=1
                 end
                   @ lin   , 03 say TIRA_ZERO()+padl(EST007->BIT_FN,2)+'/ '+padr(EST007->BIT_FD,2)
                   @ lin   , 15 say str( EST007->BIT_MM, 8, 3 )
                   @ lin   , 25 say TIRA_ZERO("ESP")+padl(EST007->ESP_FN,2)+'/ '+padr(EST007->ESP_FD,2)
                   @ lin   , 33 say str( EST007->ESP_MM, 8, 3 )
                   @ lin   , 45 say str(EST007->QTD_INT,5)
                   @ lin   , 54 say str(EST007->QTD_COR,5)
                   @ lin   , 61 say str(EST007->QTD_KGT,12,2)
                   W_TOTAL_KG += EST007->QTD_KGT
                  lin += 1
               end
              inkey()
              if lastkey() = K_ESC
                 @ row()+1, 04 say ''
                 @ row()+1, 04 say ''
                 @ row()+1, 00 say padc('****    Impressao interrompida pelo usuario    ****',78)
                 @ row()+1, 04 say ''
                 @ row()+1, 04 say ''
                 EST007->( dbgobottom())
                EST007->( dbskip())
               return
              end
           EST007->( dbskip())
       end
             if  est4 != EST007->FORMA+TIPO .and. flag == 1
              rodape_9501()
             w_total_kg := 0
             INKEY(0)
             @ 09,00 CLEAR TO 24,79
            end

      EST004->( dbskip())
      flag:=0

end
return
//-----------

function   tela001()

    select est004
    est4:= w_chave_item //:= EST004->forma
    EST007->( dbsetorder (4) )
    EST007->( dbseek( est4 ) )
    LIN:=10
    if EST007->( ! FOUND() )
     mensbeep('Material nao encontrado. <ENTER>' )
      return
    end


  while  est4  == EST007->FORMA
   select EST007

     forti:=forma+tipo

  while  forti  == EST007->FORMA+tipo
             if LIN = 23
                @ row()+2, 15 say 'Pressione qualquer tecla p/ continuar...'
                inkey(0)
                @ 09,01 CLEAR TO 24,79
                Lin=10
                flag:=1
                tit_ITEM01()
             end
              if EST007->DAT_ULT >= W_DATA_INI .and. ;
               ( EST007->DAT_ULT <= W_DATA_FIM .or. empty( W_DATA_FIM ))

                 if flag == 0
                   tit_ITEM01()
                   flag:=1
                 end
                   @ lin   , 03 say TIRA_ZERO()+padl(EST007->BIT_FN,2)+'/ '+padr(EST007->BIT_FD,2)
                   @ lin   , 15 say str( EST007->BIT_MM, 8, 3 )
                   @ lin   , 25 say TIRA_ZERO("ESP")+padl(EST007->ESP_FN,2)+'/ '+padr(EST007->ESP_FD,2)
                   @ lin   , 33 say str( EST007->ESP_MM, 8, 3 )
                   @ lin   , 45 say str(EST007->QTD_INT,5)
                   @ lin   , 54 say str(EST007->QTD_COR,5)
                   @ lin   , 61 say str(EST007->QTD_KGT,12,2)
                   W_TOTAL_KG += EST007->QTD_KGT
                  lin += 1
               end
              inkey()
              if lastkey() = K_ESC
                 @ row()+1, 04 say ''
                 @ row()+1, 04 say ''
                 @ row()+1, 00 say padc('****    Impressao interrompida pelo usuario    ****',78)
                 @ row()+1, 04 say ''
                 @ row()+1, 04 say ''
                 EST007->( dbgobottom())
                EST007->( dbskip())
               return
              end
           EST007->( dbskip())
       end

             if  forti != EST007->FORMA+tipo .and. flag == 1
              rodape_9501()
             w_total_kg := 0
             INKEY(0)
             @ 09,00 CLEAR TO 24,79
             lin:=09
             flag:=0
            end

       end

return
//----------------------------------------------------------------------------
//----------------------------------------------------------------------------
//----------------------------------------------------------------------------
//                      Impressao    so    001
//----------------------------------------------------------------------------
//----------------------------------------------------------------------------
//----------------------------------------------------------------------------
//----------------------------------------------------------------------------

function  imptela001()

select est004
est4:= w_chave_item //:= EST004->forma
EST007->( dbsetorder (4) )
EST007->( dbseek( est4 ) )

if EST007->( ! FOUND() )
  EST004->( dbskip())
  return
end

  while  est4  == EST007->FORMA
  select EST007
     forti:=forma+tipo

  while  forti  == EST007->FORMA+tipo
	     if prow() > 55
                @ 00, 00 say ''
                @ prow()+1, 00 say '|------------------------------------------------------------------------------|'
                flag:=1
                cab_95()
                tit_ITEM()
	     end

           // linha detalhe
              if EST007->DAT_ULT >= W_DATA_INI .and. ;
               ( EST007->DAT_ULT <= W_DATA_FIM .or. empty( W_DATA_FIM ))

                 if flag == 0
                   cab_96()
                   tit_ITEM()
                   flag:=1
                 end
                @ prow()+1, 00       say "| "
                @ prow()  , pcol()   say TIRA_ZERO()+padl(EST007->BIT_FN,2)+'/'+padr(EST007->BIT_FD,2)
                @ prow()  , pcol()+3 say str( EST007->BIT_MM, 8, 3 )
                @ prow()  , pcol()+3 say TIRA_ZERO("ESP")+padl(EST007->ESP_FN,2)+'/'+padr(EST007->ESP_FD,2)
                @ prow()  , pcol()+3 say str( EST007->ESP_MM, 8, 3 )
                @ prow()  , pcol()+6 say str(EST007->QTD_INT,5)
                @ prow()  , pcol()+4 say str(EST007->QTD_COR,5)
                @ prow()  , pcol()+3 say str(EST007->QTD_KGT,12,2)
                @ prow()  , pcol()   say " |"
                   W_TOTAL_KG += EST007->QTD_KGT

               end
              inkey()
              if lastkey() = K_ESC
                 @ prow()+1, 04 say ''
                 @ prow()+1, 04 say ''
                 @ prow()+1, 00 say padc('****    Impressao interrompida pelo usuario    ****',78)
                 @ prow()+1, 04 say ''
                 @ prow()+1, 04 say ''
                 EST007->( dbgobottom())
                EST007->( dbskip())

               return
	     end
              EST007->( dbskip())
       end

             if  forti != EST007->FORMA+tipo .and. flag == 1
              rodape_95()
             w_total_kg := 0
             flag:=0
            end

   end

return


