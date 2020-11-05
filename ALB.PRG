/*

   SCM - Sistema de Controle Metalurgico
   RELDAN.PRG - Relatorio de Saida por Itens de Estoque

*/

#include "inkey.ch"

telanum('SCR001','REL006')
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

tela006()

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
            cab006_forma()
            while EST010->FORMA = W_FORMA_ATUAL .and. ;
                  EST010->( ! eof() )
                  W_TIPO_ATUAL := EST010->TIPO
                  cab006_tipo()
                  while EST010->FORMA = W_FORMA_ATUAL .and. ;
                        EST010->TIPO  = W_TIPO_ATUAL  .and. ;
                        EST010->( ! eof() )
                        W_ESTADO_ATUAL := EST010->ESTADO
                        cab006_estado()
                        while EST010->FORMA  = W_FORMA_ATUAL  .and. ;
                              EST010->TIPO   = W_TIPO_ATUAL   .and. ;
                              EST010->ESTADO = W_ESTADO_ATUAL .and. ;
                              EST010->( ! eof() )
                              W_BIT_MM_ATUAL := EST010->BIT_MM
                              cab006_bitola()
                              while EST010->FORMA  = W_FORMA_ATUAL  .and. ;
                                    EST010->TIPO   = W_TIPO_ATUAL   .and. ;
                                    EST010->ESTADO = W_ESTADO_ATUAL .and. ;
                                    EST010->BIT_MM = W_BIT_MM_ATUAL .and. ;
                                    EST010->( ! eof() )
                                    proc006_detalhe()
                                    EST010->(dbskip())
                              end
                              roda006_bitola()
                              if !empty(X_BIT_MM)
                                 exit
                              end
                       end
                       roda006_estado()
                       if !empty(X_ESTADO)
                          exit
                       end
                 end
                 roda006_tipo()
                 if !empty(X_TIPO)
                    exit
                 end
            end
            roda006_forma()
            if !empty(X_FORMA)
               exit
            end
      end
      roda006_geral()
      dh_impoff()
   end
end

/*
-----------------------------------------------------------------------------
                      Procedimento proc006_Detalhe
-----------------------------------------------------------------------------
*/
procedure proc006_detalhe()

if EST010->DATAMOVI < W_DATA_INI .or. ;
   EST010->DATAMOVI > W_DATA_FIM
   return
end

mensimp("Gerando Relatorio. Aguarde... "+str( EST010->(recno()) ) )

if prow() > 55
   cabgeral('Listagem de Saida de Material' )
   cab006_forma ()
   cab006_tipo  ()
   cab006_estado()
   cab006_bitola()
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
                      Procedimento cab006_forma
-----------------------------------------------------------------------------
*/
procedure cab006_forma()

    @ prow()+1, 00 say 'Forma...........: '+ W_FORMA_ATUAL

    W_FOR_KG := 0.00
    W_TIP_KG := 0.00
    W_EST_KG := 0.00
    W_BIT_KG := 0.00

return
/*
-----------------------------------------------------------------------------
                      Procedimento cab006_tipo
-----------------------------------------------------------------------------
*/
procedure cab006_tipo()

    EST004->( dbseek( W_FORMA_ATUAL+W_TIPO_ATUAL ) )

    @ prow()+1, 00 say '  Tipo..........: '+ W_TIPO_ATUAL + EST004->descricao

    W_TIP_KG := 0.00
    W_EST_KG := 0.00
    W_BIT_KG := 0.00

return
/*
-----------------------------------------------------------------------------
                      Procedimento cab006_estado
-----------------------------------------------------------------------------
*/
procedure cab006_estado()

    @ prow()+1, 00 say '    Estado......: '+ W_ESTADO_ATUAL + EST004->descricao

    W_EST_KG := 0.00
    W_BIT_KG := 0.00

return
/*
-----------------------------------------------------------------------------
                      Procedimento cab006_bitola
-----------------------------------------------------------------------------
*/
procedure cab006_bitola()

    @ prow()+1, 00 say '      Bitola....: '+ str(W_BIT_MM_ATUAL,8,3)

    W_BIT_KG       := 0.00

return
/*
-----------------------------------------------------------------------------
                      Procedimento Roda006_geral
-----------------------------------------------------------------------------
*/
procedure roda006_geral()

    @ prow()+1, 00     say 'Total no periodo..:'
    @ prow()  , 18     say str( W_GER_KG,12,2)
    @ prow(), pcol()+2 say 'Kg'
    @ prow()+1, 00     say ' '

return

/*
-----------------------------------------------------------------------------
                      Procedimento Roda006_forma
-----------------------------------------------------------------------------
*/
procedure roda006_forma()

    @ prow()+1, 00     say 'Tot.Forma.......: '
    @ prow()  , 18     say str( W_FOR_KG,12,2)
    @ prow(), pcol()+2 say 'Kg'
    @ prow()+1, 00     say ' '

return
/*
-----------------------------------------------------------------------------
                      Procedimento Roda006_tipo
-----------------------------------------------------------------------------
*/
procedure roda006_tipo()

    @ prow()+1, 00     say '  Tot.Tipo......: '
    @ prow()  , 18     say str( W_TIP_KG,12,2)
    @ prow(), pcol()+2 say 'Kg'
    @ prow()+1, 00     say ' '

return
/*
-----------------------------------------------------------------------------
                      Procedimento Roda006_estado
-----------------------------------------------------------------------------
*/
procedure roda006_estado()

    @ prow()+1, 00     say '    Tot.Estado..: '
    @ prow()  , 18     say str( W_EST_KG,12,2)
    @ prow(), pcol()+2 say 'Kg'
    @ prow()+1, 00     say ' '

return
/*
-----------------------------------------------------------------------------
                      Procedimento Roda006_bitola
-----------------------------------------------------------------------------
*/
procedure roda006_bitola()

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
procedure TELA006()

@ 02,02 say 'ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿'
@ 03,02 say '³                                                                          ³'
@ 04,02 say '³                                                                          ³'
@ 05,02 say '³  Forma    :       -                                                      ³'
@ 06,02 say '³  Tipo     :       -                                                      ³'
@ 07,02 say '³  Estado   :       -                                                      ³'
@ 08,02 say '³  Bit./Esp.:      /                                                       ³'
@ 09,02 say '³  Bit./Larg:      /                                                       ³'
@ 10,02 say '³                                                                          ³'
@ 11,02 say '³  Periodo..:           `a                                                 ³'
@ 12,02 say '³                                                                          ³'
@ 13,02 say '³                                                                          ³'
@ 14,02 say '³                                                                          ³'
@ 15,02 say '³                                                                          ³'
@ 16,02 say '³                                                                          ³'
@ 17,02 say '³                                                                          ³'
@ 18,02 say '³                                                                          ³'
@ 19,02 say '³                                                                          ³'
@ 20,02 say '³                                                                          ³'
@ 21,02 say '³                                                                       96 ³'
@ 22,02 say 'ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ'

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

EST010->( dbsetorder(2) )
EST010->( dbseek( W_CHAVE_ITEM + dtos(W_DATA_INI), .t. ))

return

