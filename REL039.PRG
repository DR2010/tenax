/*

   SCM - Sistema de Controle Metalurgico
   RELDAN.PRG - Relatorio de Saida por Itens de Estoque

*/

#include "inkey.ch"

telanum('SCR001','REL039')
status('Relatorio de Saida de Material')

//
// Arquivos
//
abrir("ESTREPO")
abrir("EST003")
abrir("EST004")
abrir("EST007")
abrir("EST010")
abrir("EST011")

EST004->( dbsetorder(2) ) // FORMA+TIPO

EST010->( dbsetorder(4) ) // data da movimentacao
EST010->( dbgotop() )

//
// variaveis para controle de impressoes geradas para arquivo
//
private W_TITULO := 'Listagem de Saida de Material'
WRESP_IMP := 'I'
W_IMPARQ  := space(12)

//
// Variaveis
//
BL_CHAVE_ITEM := {|| EST010->( ! eof() ) }

W_CHAVE_ITEM   := ' '
X_FORMA        := space(03)
X_TIPO         := space(05)
X_ESTADO       := space(01)
X_BIT_MM       := 0.00      //  8.3
X_ESP_MM       := 0.00      //  8.3
X_BIT_INT      := space(02)
X_BIT_FN       := space(02)
X_BIT_FD       := space(02)
X_ESP_INT      := space(02)
X_ESP_FN       := space(02)
X_ESP_FD       := space(02)
W_FORMA_ATUAL  := space(03)
W_TIPO_ATUAL   := space(05)
W_ESTADO_ATUAL := space(01)
W_BIT_MM_ATUAL := 0.00
W_ESP_MM_ATUAL := 0.00
W_GER_KG       := 0.00
W_FOR_KG       := 0.00
W_TIP_KG       := 0.00
W_EST_KG       := 0.00
W_BIT_KG       := 0.00

WTRACO80 := replicate('-',80)

W_DATA_INI := date()
W_DATA_FIM := date()
NUMPAG	   := 1

//
// Inicio
//

tela39()

W_TELA := savescreen(,,,,)
if imp_tela()

   if dh_imprime()

      if WRESP_IMP = 'A'
	 ESTREPO->( grava( WIMP_ARQ, date(), time(), W_TITULO, 80) )
      end

      cabgeral('Listagem de Saida de Material' )

      gera_acesso()

      while EST010->( ! eof() )
            W_FORMA_ATUAL := EST010->FORMA
            cab39_forma()
            while EST010->FORMA = W_FORMA_ATUAL .and. ;
                  EST010->( ! eof() )
                  W_TIPO_ATUAL := EST010->TIPO
                  cab39_tipo()
                  while EST010->FORMA = W_FORMA_ATUAL .and. ;
                        EST010->TIPO  = W_TIPO_ATUAL  .and. ;
                        EST010->( ! eof() )
                        W_ESTADO_ATUAL := EST010->ESTADO
                        cab39_estado()
                        while EST010->FORMA  = W_FORMA_ATUAL  .and. ;
                              EST010->TIPO   = W_TIPO_ATUAL   .and. ;
                              EST010->ESTADO = W_ESTADO_ATUAL .and. ;
                              EST010->( ! eof() )
                              W_BIT_MM_ATUAL := EST010->BIT_MM
                              W_ESP_MM_ATUAL := EST010->ESP_MM
                              cab39_bitola()
                              while EST010->FORMA  = W_FORMA_ATUAL  .and. ;
                                    EST010->TIPO   = W_TIPO_ATUAL   .and. ;
                                    EST010->ESTADO = W_ESTADO_ATUAL .and. ;
                                    EST010->ESP_MM = W_ESP_MM_ATUAL .and. ;
                                    EST010->( ! eof() )
                                    proc39_detalhe()
                                    EST010->(dbskip())
                              end
                              roda39_bitola()
                              if !empty(X_BIT_MM)
                                 exit
                              end
                       end
                       roda39_estado()
                       if !empty(X_ESTADO)
                          exit
                       end
                 end
                 roda39_tipo()
                 if !empty(X_TIPO)
                    exit
                 end
            end
            roda39_forma()
            if !empty(X_FORMA)
               exit
            end
      end
      roda39_geral()
      dh_impoff()
   end
end

/*
-----------------------------------------------------------------------------
                      Procedimento proc39_Detalhe
-----------------------------------------------------------------------------
*/
procedure proc39_detalhe()

if EST010->DATAMOVI < W_DATA_INI .or. ;
   EST010->DATAMOVI > W_DATA_FIM
   return
end

mensimp("Gerando Relatorio. Aguarde... "+str( EST010->(recno()) ) )

if prow() > 55
   cabgeral('Listagem de Saida de Material' )
   cab39_forma ()
   cab39_tipo  ()
   cab39_estado()
   cab39_bitola()
end

EST011->( dbseek( EST010->TIPOMOVI ) )

if EST011->ES = 'S'

   W_GER_KG += EST010->QTD_KG
   W_FOR_KG += EST010->QTD_KG
   W_TIP_KG += EST010->QTD_KG
   W_EST_KG += EST010->QTD_KG
   W_BIT_KG += EST010->QTD_KG

   @ prow()+1, 08 say left( dtoc(EST010->DATAMOVI),5 )
   @ prow()  , 12 say EST010->BIT_INT+' '+EST010->BIT_FN+'/'+EST010->BIT_FD+''+STR(EST010->BIT_MM,8,3)
   @ prow()  , 30 say EST010->ESP_INT+' '+EST010->ESP_FN+'/'+EST010->ESP_FD+''+STR(EST010->ESP_MM,8,3)
   @ prow()  , 51 say str(EST010->QTD_KG,12,2)
   if EST011->ACERTO = 'S'
      @ prow()  , 66  say 'ACERTO SAIDA'
   else
      @ prow()  , 66  say left( EST010->ORIGEM, 13 )
   end

end

return

/*
-----------------------------------------------------------------------------
                      Procedimento cab39_forma
-----------------------------------------------------------------------------
*/
procedure cab39_forma()

    @ prow()+1, 00 say 'Forma...........: '+ W_FORMA_ATUAL + ' -  ' + EST003->DESCRICAO

    W_FOR_KG := 0.00
    W_TIP_KG := 0.00
    W_EST_KG := 0.00
    W_BIT_KG := 0.00

return
/*
-----------------------------------------------------------------------------
                      Procedimento cab39_tipo
-----------------------------------------------------------------------------
*/
procedure cab39_tipo()

    EST004->( dbseek( W_FORMA_ATUAL+W_TIPO_ATUAL ) )

    @ prow()+1, 00 say '  Tipo..........: '+ W_TIPO_ATUAL + ' -  ' + EST004->DESCRICAO

    W_TIP_KG := 0.00
    W_EST_KG := 0.00
    W_BIT_KG := 0.00

return
/*
-----------------------------------------------------------------------------
                      Procedimento cab39_estado
-----------------------------------------------------------------------------
*/
procedure cab39_estado()

    @ prow()+1, 00 say '    Estado......: '+ W_ESTADO_ATUAL

    W_EST_KG := 0.00
    W_BIT_KG := 0.00

return
/*
-----------------------------------------------------------------------------
                      Procedimento cab39_bitola
-----------------------------------------------------------------------------
*/
procedure cab39_bitola()

    @ prow()+1, 00 say '      Bitola....: '+ str(W_BIT_MM_ATUAL,8,3) + ' ' + ;
                                             str(W_ESP_MM_ATUAL,8,3)

    W_BIT_KG       := 0.00

return
/*
-----------------------------------------------------------------------------
                      Procedimento Roda39_geral
-----------------------------------------------------------------------------
*/
procedure roda39_geral()

    @ prow()+1, 00     say 'Total no periodo..:'
    @ prow()  , 18     say str( W_GER_KG,12,2)
    @ prow(), pcol()+2 say 'Kg'
    @ prow()+1, 00     say ' '

return

/*
-----------------------------------------------------------------------------
                      Procedimento Roda39_forma
-----------------------------------------------------------------------------
*/
procedure roda39_forma()

    @ prow()+1, 00     say 'Tot.Forma.......: '
    @ prow()  , 18     say str( W_FOR_KG,12,2)
    @ prow(), pcol()+2 say 'Kg'
    @ prow()+1, 00     say ' '

return
/*
-----------------------------------------------------------------------------
                      Procedimento Roda39_tipo
-----------------------------------------------------------------------------
*/
procedure roda39_tipo()

    @ prow()+1, 00     say '  Tot.Tipo......: '
    @ prow()  , 18     say str( W_TIP_KG,12,2)
    @ prow(), pcol()+2 say 'Kg'
    @ prow()+1, 00     say ' '

return
/*
-----------------------------------------------------------------------------
                      Procedimento Roda39_estado
-----------------------------------------------------------------------------
*/
procedure roda39_estado()

    @ prow()+1, 00     say '    Tot.Estado..: '
    @ prow()  , 18     say str( W_EST_KG,12,2)
    @ prow(), pcol()+2 say 'Kg'
    @ prow()+1, 00     say ' '

return
/*
-----------------------------------------------------------------------------
                      Procedimento Roda39_bitola
-----------------------------------------------------------------------------
*/
procedure roda39_bitola()

    @ prow()+1, 00     say '      Tot.Bitola: '
    @ prow()  , 18     say str( W_BIT_KG,12,2)
    @ prow(), pcol()+2 say 'Kg'
    @ prow()+1, 00     say ' '

return

/*
-----------------------------------------------------------------------------
		      Procedimento Tela
-----------------------------------------------------------------------------
*/
procedure TELA39()

@ 02,02 say '旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴커'
@ 03,02 say '�                                                                          �'
@ 04,02 say '�                                                                          �'
@ 05,02 say '�  Forma    :       -                                                      �'
@ 06,02 say '�  Tipo     :       -                                                      �'
@ 07,02 say '�  Estado   :       -                                                      �'
@ 08,02 say '�  Bit./Esp.:      /                                                       �'
@ 09,02 say '�  Bit./Larg:      /                                                       �'
@ 10,02 say '�                                                                          �'
@ 11,02 say '�  Periodo..:           `a                                                 �'
@ 12,02 say '�                                                                          �'
@ 13,02 say '�                                                                          �'
@ 14,02 say '�                                                                          �'
@ 15,02 say '�                                                                          �'
@ 16,02 say '�                                                                          �'
@ 17,02 say '�                                                                          �'
@ 18,02 say '�                                                                          �'
@ 19,02 say '�                                                                          �'
@ 20,02 say '�                                                                          �'
@ 21,02 say '�                                                                       96 �'
@ 22,02 say '읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴켸'

return

/*
-----------------------------------------------------------------------------
                      Procedimento Gera Acesso
-----------------------------------------------------------------------------
*/
procedure gera_acesso()

if empty(X_FORMA)
   W_CHAVE_ITEM := X_FORMA +X_TIPO+X_ESTADO+str(X_BIT_MM,8,3)+str(X_ESP_MM,8,3)
else
  if empty(X_TIPO)
     W_CHAVE_ITEM := W_CHAVE_ITEM +X_TIPO+X_ESTADO+str(X_BIT_MM,8,3)+str(X_ESP_MM,8,3)
  else
    if empty(X_ESTADO)
       W_CHAVE_ITEM := W_CHAVE_ITEM+X_ESTADO+str(X_BIT_MM,8,3)+str(X_ESP_MM,8,3)
    else
       if empty(str(X_BIT_MM,8,3))
          W_CHAVE_ITEM := W_CHAVE_ITEM+str(X_BIT_MM,8,3 )+str(X_ESP_MM,8,3)
       end
    end
  end
end

EST010->( dbgotop()     )
EST010->( dbsetorder(2) )
EST010->( dbseek( W_CHAVE_ITEM + dtos(W_DATA_INI), .t. ))

return

