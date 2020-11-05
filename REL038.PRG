/*
   TENAX
   EST038.PRG - Listagem de Clientes por Vendedor
*/

#include "inkey.ch"
telanum('REL038','REL038')

private linha134 := replicate('-',134),escolha

private W_TITULO := 'Clientes por Vendedor'
WRESP_IMP := 'I'
W_IMPARQ  := space(12)


abrir("ESTREPO")
abrir("VEN001")
abrir("VEN002")
X_TIPOCLI := ' '
X_CODCLI  := space(05)
X_CODVEN  := space(02)

VEN001->( dbgotop() )

if par_038()
       W_TITULO := 'Clientes por Vendedor..: '+ X_CODVEN + ' - '+VEN002->GUERRA
      if dh_imprime(1)
         if WRESP_IMP = 'A'
            ESTREPO->( grava( WIMP_ARQ, date(), time(), W_TITULO, 80) )
         end

         VEN001->( dbsetorder(4) )
         VEN001->( dbseek( X_CODVEN ) )

         W_PAG :=  0
         W_LIN :=  65

         while VEN001->( ! eof() ) .and. ;
               VEN001->CODVEN = X_CODVEN

         VEN002->( dbsetorder(1) )
         VEN002->( dbseek( X_CODVEN ) )

            if lastkey()=K_ESC
               @ prow()+2,20 say '---Impressao interrompida pelo usuario---'
               exit
            end
            if W_LIN  > 55
               W_PAG++
               R038_CAB(W_PAG)
               R038_TIT(W_TITULO,X_TIPOCLI)
               W_LIN := 10
            end
           IF X_TIPOCLI = 'T'
             R038_DET()
             W_LIN+=2
           ELSE
            if X_TIPOCLI = VEN001->TIPO_CLI
              R038_DET()
              W_LIN+=3
            END
          END
            VEN001->( dbskip() )
         end

         dh_impoff()
      end
end


// fim do programa


//-----------------------------------------------------------------------------
                             function par_038()
//-----------------------------------------------------------------------------

local WRET := .T.

@ 10,15 say 'ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄ Parametro de Impressao ÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿'
@ 11,15 say '³                                                    ³'
@ 12,15 say '³ Vendedor.......:                                   ³'
@ 13,15 say '³                                                    ³'
@ 14,15 say '³ Tipo de Cliente:       <C/P/R/T>                   ³'
@ 15,15 say 'ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ'

@ 12,34 get X_CODVEN     picture '99' valid tes_codven(12,34,12)
@ 14,34 get X_TIPOCLI    picture '!'  valid X_TIPOCLI $ 'CPRT'


read

if lastkey() = K_ESC
   WRET := .F.
end

do case
  case X_TIPOCLI = 'T' ; @ 14,40 SAY 'Todos os clientes'
  case X_TIPOCLI = 'C' ; @ 14,40 SAY 'Consumidor       '
  case X_TIPOCLI = 'R' ; @ 14,40 SAY 'Revenda          '
  case X_TIPOCLI = 'P' ; @ 14,40 SAY 'Particular       '
end
return WRET

/*
-----------------------------------------------------------------------------
                      Procedimento R038_CAB
-----------------------------------------------------------------------------
*/
procedure R038_CAB( P_PAG )

    @ 01      , 00 say linha134
    @ prow()+1, 00 say '   TENAX ACO E FERRO '
    @ prow()+1, 27 say 'Data: ' + dtoc(date())
    @ prow()  , 45 say 'Pag.: ' + strzero(P_PAG,3)
    @ prow()  , 60 say 'Hora: '
    @ prow()  , 66 say (Time())
    @ prow()+1, 00 say linha134


return

/*
-----------------------------------------------------------------------------
                      Procedimento R038_TIT
-----------------------------------------------------------------------------
*/
procedure R038_TIT( P_TITPROC,FLAG )

    @ prow()+1, int ((( 136-len(alltrim(P_TITPROC)) )/2)) say P_TITPROC
    do case
      case flag = nil
      case flag = 'C' ; @ prow(), pcol()+3 say flag + ' - '+ 'Consumidor'
      case flag = 'R' ; @ prow(), pcol()+3 say flag + ' - '+ 'Revenda'
      case flag = 'P' ; @ prow(), pcol()+3 say flag + ' - '+ 'Particular'
    end

    @ prow()+1, 00 say linha134

    @ prow()+2, 00  say 'Cliente'
    @ prow()  , 08  say 'Nome de Guerra'
    @ prow()  , 28  say 'DDD.'
    @ prow()  , 34  say 'Telefone'
    @ prow()  , 45  say 'Contato'
    @ prow()  , 70  say 'Endereco'
    @ prow()  , 96  say 'Municipio'
    @ prow()  , 121 say 'Es'
    @ prow()+1, 00  say linha134
return

/*
-----------------------------------------------------------------------------
                      Procedimento R038_DET
-----------------------------------------------------------------------------
*/
procedure R038_DET(FLAG)
   IF VEN001->CODCLI <> '00000'
    @ prow()+1,00  say VEN001->CODCLI
    @ prow()  ,08  say VEN001->GUERRA
    @ prow()  ,28  say VEN001->DDD01     picture '9999'
    @ prow()  ,34  say VEN001->TEL01     picture '999999999'
    @ prow()  ,45  say left(VEN001->CONTATO01,20)
    @ prow()  ,70  say left(VEN001->BAIRRO,20)
    @ prow()  ,96  say left(VEN001->MUNICIPIO,20)
    @ prow()  ,121 say VEN001->ESTADO
    @ prow()+1,70  say left(VEN001->ENDERECO,40)
  END
 
return




