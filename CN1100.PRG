/*

   CR1100.PRG - Baixa de Duplicatas

*/
#include "inkey.ch"
altd(1)

telanum('SCE1100','CR1100')

abrir("VEN001")
abrir("VEN012")
abrir("CR0300")
abrir("CR0400")
abrir("CR0600")
abrir("CR1000")
abrir("CR1100")
abrir("CR9991")

X_CODCLI       := space(5)
X_DUPLICATA    := space(8)
X_SEQUENCIA    := space(1)
X_BOLETA       := space(10)
X_DT_EMISSAO   := ctod("  /  /  ")
X_DT_VENC      := ctod("  /  /  ")
X_DT_PAG       := ctod("  /  /  ")
X_STATUS       := "R"
X_JUROS        := 0.00
X_VALOR        := 0.00
X_TOTAL        := 0.00
X_TIPOVENDA    := space(2)
X_FORMAPAG     := space(2)

X_ACORDO       := space(1)
X_VLPAGO       := 0.00
X_VLSALDO      := 0.00
X_DTACORDO     := ctod("  /  /  ")
X_VLACORDO     := 0.00
X_SDACORDO     := 0.00

private  W_FILE      := {}
private  CAMPO       := {}
private  MASCARA     := {}
private  CABECALHO   := {}
private  TAMANHO     := {}
private  BESCAPE     := {|| STATUS = "P"  }
private  COR         := W_COREDIT
private  TITULO      := " Baixa de Duplicatas "
private  LININI      := 03
private  LINFIM      := 20
private  COLINI      := 02
private  COLFIM      := 77
private  BLOCK_DISP  := {|| .T. }
private  CAB_TITULO  := nil
private  BORDA       := 1

private  TECLA       := nil
private  TABELA      := nil

aadd( CAMPO     , "DUPLICATA"        )
aadd( CAMPO     , "SEQUENCIA"        )
aadd( CAMPO     , "GUERRA"           )
aadd( CAMPO     , "DT_VENC"          )
aadd( CAMPO     , "TIPOVENDA"        )
aadd( CAMPO     , "FORMAPAG"         )
aadd( CAMPO     , "QTD_CH"           )
aadd( CAMPO     , "ACORDO"           )
aadd( CAMPO     , "VALOR"            )

aadd( MASCARA   , "@!"               )
aadd( MASCARA   , "@!"               )
aadd( MASCARA   , "@!"               )
aadd( MASCARA   , "  /  /  "         )
aadd( MASCARA   , "@!"               )
aadd( MASCARA   , "@!"               )
aadd( MASCARA   , "@!"               )
aadd( MASCARA   , "@!"               )
aadd( MASCARA   , "999,999,999.99"   )

aadd( CABECALHO , "Duplicata"        )
aadd( CABECALHO , "Sq"               )
aadd( CABECALHO , "Cliente"          )
aadd( CABECALHO , "Vencimt."         )
aadd( CABECALHO , "T.V"              )
aadd( CABECALHO , "F.P"              )
aadd( CABECALHO , "Qt.Ch"            )
aadd( CABECALHO , "Acordo"           )
aadd( CABECALHO , "Valor"            )

aadd( TAMANHO   , 09                 )
aadd( TAMANHO   , 02                 )
aadd( TAMANHO   , 07                 )
aadd( TAMANHO   , 10                 )
aadd( TAMANHO   , 03                 )
aadd( TAMANHO   , 03                 )
aadd( TAMANHO   , 05                 )
aadd( TAMANHO   , 06                 )
aadd( TAMANHO   , 15                 )

aadd( W_FILE , "CR1000" )
aadd( W_FILE , "CR1000" )
aadd( W_FILE , "VEN001" )
aadd( W_FILE , "CR1000" )
aadd( W_FILE , "VEN012" )
aadd( W_FILE , "CR1000" )
aadd( W_FILE , "CR1000" )
aadd( W_FILE , "CR1000" )
aadd( W_FILE , "CR1000" )

select CR1000
CR1000->( dbsetorder(2) )
CR1000->( dbseek("P") )

CR1000->( dbsetrelation( "VEN001", {|| CR1000->CODCLI},"CR1000->CODCLI" ) )

setcolor(W_COREDIT)

te1100()

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
                     COLFIM         , ;
                     W_FILE           ;
                   )

CONTINUA := .T.

CR1100_pendente()

do while CONTINUA .and. ( (TEC:=tabmov(TABELA)) != K_ESC )

   mensagem('<F4> - Recebe Duplicata  <F6> - Busca Rapida     ')
   W_TEL1100 := savescreen(,,,,)

   do case
      case TEC == 28 ; help() ; return 1    
      case TEC == 27 ; return 0

      case TEC == -3   && alteracao f4
          if CR1000->(!eof())
             edit1100()
             restscreen(,,,,W_TEL1100)
             cr1100_pendente()
          end
          select CR1000
          CR1000->( dbsetorder(2) )
          CR1000->( dbseek("P") )
          TABELA:refreshall()

      case TEC == -5   // BUSCA DIRETA = F6
         if CR1000->( ! eof() )
            busca_duplicata("P")
	 end
         restscreen(,,,,W_TEL1100)
         select CR1000
         CR1000->( dbsetorder(2) )
         CR1000->( dbseek("P" + X_DUPLICATA )  )
         TABELA:refreshall()

      case TEC = K_ESC
         CONTINUA := .F.
   end

enddo

close data

return

************************************
function edit1100()
************************************
local getlist:= {}

setcursor(1)

tl1100()

X_CODCLI       := CR1000->CODCLI
X_DUPLICATA    := CR1000->DUPLICATA
X_SEQUENCIA    := CR1000->SEQUENCIA
X_BOLETA       := CR1000->BOLETA
X_FORMAPAG     := CR1000->FORMAPAG
X_DT_PAG       := date()
X_DT_VENC      := CR1000->DT_VENC
X_VALOR        := CR1000->VALOR
X_JUROS        := calc_juros(X_VALOR,X_DT_VENC)
X_TOTAL        := 0.0

X_ACORDO       := CR1000->ACORDO
X_VLPAGO       := CR1000->VLPAGO
X_VLSALDO      := CR1000->VLSALDO

if acessa_nf(X_DUPLICATA)
   X_TIPOVENDA  := VEN012->TIPOVENDA
   X_DT_EMISSAO := VEN012->DT_EMISSAO
   X_TIPOVENDA  := VEN012->TIPOVENDA
end

tes_codcli    (X_CODCLI,04,20)
tes_duplicata (05,20)
tes_tipovenda (7,45,15)
tes_formapag  (8,45,15)

show_saldo()

@ 07,20 say X_DT_EMISSAO  pict "  /  /  "
@ 08,20 say X_DT_VENC     pict "  /  /  "
@ 09,20 say X_VALOR       pict "@E 999999,999.99"

@ 09,45 get X_BOLETA      pict "@!" valid !empty(X_BOLETA) ;
                                    when CR0400->BOLETA = "X"
@ 11,20 get X_DT_PAG      pict "  /  /  "  valid tes_dtpag()
@ 12,20 get X_JUROS       pict "@E 9999,999,999.99"
@ 11,45 get X_ACORDO      pict "!" valid tes_acordo()

read
if lastkey() = K_ESC
   return nil
end

X_TOTAL  := X_VALOR + X_JUROS

@ 14,20 say X_TOTAL       pict "@E 9999,999,999.99"

CR0400->(Dbsetorder(1))
CR0400->(Dbseek(X_TIPOVENDA+X_FORMAPAG))

if CR0400->CHEQUE = "X"
   if ! cheque_valido()
      return nil
   end
end

INKEY()

if Pergunta('Confirma Pagamento da Duplicata (S/N) ?')
    if CR1000->QTD_CH > 0
       if ! baixa_cheque()
          return nil
       end
    end
    while CR1000->( ! rlock() ); end
    CR1000->BOLETA     := X_BOLETA
    CR1000->DT_PAG     := X_DT_PAG
    CR1000->JUROS      := X_JUROS
    CR1000->STATUS     := X_STATUS
    CR1000->ACORDO     := X_ACORDO
    CR1000->VLPAGO     := X_VLPAGO
    CR1000->VLSALDO    := X_VLSALDO
    CR1000->( dbunlock() )
    if X_STATUS = "R"
       baixa_nf(X_DUPLICATA)
    end
end

setcursor(0)

return nil

/*
-------------------------------------------------------------------------------
Procedimento .: TE1100
Objetivo .....: Menu rapido
-------------------------------------------------------------------------------
*/
procedure te1100()
   local W_OLDCOR := setcolor()

   setcolor(W_COREDIT)
   quadro(03,02,21,77,"")
   @ 05,02 say 'ф'
   @ 05,77 say '╣'
   @ 16,03 to 16,76 double
   @ 16,02 say 'ф'
   @ 16,77 say '╣'

   sombra(02,02,20,77)

   setcolor( W_OLDCOR )
return


/*
-------------------------------------------------------------------------------
Procedimento .: TL1100
Objetivo .....: Menu rapido
-------------------------------------------------------------------------------
*/
procedure tl1100()

   setcolor( W_COREDIT )
   @ 05,02 say 'Ё'
   @ 05,77 say 'Ё'
   setcolor( W_CORGET )
   @ 04,03 say ' Cliente......:                                                           '
   @ 05,03 say ' Duplicata....:         /                                                 '
   @ 06,03 say '                                                                          '
   @ 07,03 say ' Dt.Emiss└o...:                  Venda..:                                 '
   @ 08,03 say ' Dt.vencimento:                  F.Pag..:                                 '
   @ 09,03 say ' Valor........:                  Nr.Bol.:                                 '
   @ 10,03 say '                                                                          '
   @ 11,03 say ' Dt.Pagamento.:                  Acordo.:    Vl.Pago..:                   '
   @ 12,03 say ' Juros........:                              Saldo....:                   '
   @ 13,03 say '                                                                          '
   @ 14,03 say ' Total........:                                                           '
   @ 15,03 say '                                                                          '
   @ 16,03 say '                                                                          '
   @ 17,03 say '                                                                          '
   @ 18,03 say '                                                                          '
   @ 19,03 say '                                                                          '
   @ 20,03 say '                                                                          '
   @ 21,03 say '                                                                          '

return ' '

/*
-------------------------------------------------------------------------------
                                  BAIXA DO CHEQUE
-------------------------------------------------------------------------------
*/
function baixa_Cheque()
local WRET := .T.

   CR0600->(dbsetorder(3))
   if ! CR0600->(dbseek("P"+X_CODCLI+X_DUPLICATA+X_SEQUENCIA))
        mensbeep('N└o existe Cheque em Aberto para Devida Baixa')
        WRET := .F.
        return WRET
    end

   while CR0600->(! eof() )              .and. ;
         CR0600->CODCLI    = X_CODCLI    .and. ;
         CR0600->DUPLICATA = X_DUPLICATA .and. ;
         CR0600->SEQUENCIA = X_SEQUENCIA
         while CR0600->(!rlock()); end
         CR0600->STATUS := "R"
         CR0600->DT_PAG := date()
         CR0600->(dbunlock())
         CR0600->(dbskip())
   enddo

return WRET

/*
-------------------------------------------------------------------------------
                       CALCULA TOTAL DE DUPLICATAS PENDENTES
-------------------------------------------------------------------------------
*/
function cr1100_pendente()
   local WRET := 0, OLDREC := CR1000->( recno() )

   CR1000->(dbsetorder(3))
   CR1000->(dbseek("P"))

   do while CR1000->(! eof() )          .and. ;
            CR1000->STATUS   = "P"
            WRET = WRET + CR1000->VALOR
            CR1000->( dbskip() )
   enddo

   CR1000->( dbgoto( OLDREC ) )

   @ 20,02 say 'цдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд╢'
   @ 21,02 say 'Ё                                        Total Pendente...:                Ё'
   @ 22,02 say 'юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды'
   @ 21,62 say WRET picture "@E 999,999,999.99"

return WRET

/*
-------------------------------------------------------------------------------

-------------------------------------------------------------------------------
*/
function tes_dtpag()
local WRET := .T.

   if X_DT_PAG < X_DT_EMISSAO
      mensbeep(" Data de Pagamento inferior a Emissao ! ")
      WRET := .F.
   end

   X_JUROS := calc_juros(X_VALOR,X_DT_VENC,X_DT_PAG)

return WRET


/*
-------------------------------------------------------------------------------
                                      tes_acordo
-------------------------------------------------------------------------------
*/
function tes_acordo()
local WRET := .T.

local  CAMPO	   := {}
local  MASCARA	   := {}
local  CABECALHO   := {}
local  TAMANHO	   := {}
local  BESCAPE     := {|| CR1100->DUPLICATA = X_DUPLICATA .and.;
                          CR1100->SEQUENCIA = X_SEQUENCIA }
local  COR	   := W_COREDIT
local  TITULO      := " Acordos "
local  LININI	   := 15
local  LINFIM	   := 22
local  COLINI	   := 02
local  COLFIM	   := 77
local  BLOCK_DISP  := {|| .T. }
local  CAB_TITULO  := nil
local  BORDA	   := 1

local  TECLA	   := nil
local  TABELA	   := nil

if X_ACORDO != "X" .and. X_ACORDO != " "
   mensbeep('Acordo deve ser X ou Branco !')
   WRET := .F.
   return WRET
end

if X_ACORDO = " "
   return WRET
end

WRET := .T.

aadd( CAMPO , "DTACORDO"            )
aadd( CAMPO , "VLACORDO"            )
aadd( CAMPO , "SDACORDO"            )

aadd( MASCARA , "99/99/99"          )
aadd( MASCARA , "@E 999,999,999.99" )
aadd( MASCARA , "@E 999,999,999.99" )

aadd( CABECALHO , "Dt.Pag."         )
aadd( CABECALHO , "Vl.Pago"         )
aadd( CABECALHO , "Saldo a Pagar"   )

aadd( TAMANHO , 08                  )
aadd( TAMANHO , 15                  )
aadd( TAMANHO , 15                  )

setcolor(W_COREDIT)

select CR1100

CR1100->( dbsetorder(1) )
CR1100->( dbseek( X_DUPLICATA + X_SEQUENCIA ))

TABELA := tabelanew( CAMPO     , ;
     MASCARA	   , ;
     CABECALHO	   , ;
     TAMANHO	   , ;
     BESCAPE	   , ;
     COR	   , ;
     TITULO	   , ;
     LININI	   , ;
     LINFIM	   , ;
     COLINI	   , ;
     BLOCK_DISP    , ;
     CAB_TITULO    , ;
     BORDA	   , ;
     COLFIM	     ;
   )

CONTINUA := .T.

TABELA:refreshall()
do while CONTINUA .and. ( (TEC:=tabmov(TABELA)) != K_ESC )

   mensagem(' <F3> - Inclui / <F5> - Exclui / <ENTER> - Confirma Recebimento ')

   do case
      case TEC == 28 ; help() ; return 1

      case TEC == 27 ; return 0

      case TEC == K_F3
           ins_acordo()
           show_saldo()
	   TABELA:refreshall()

      case TEC = K_F5
           if CR1100->(!eof())
               if pergunta("Confirma exclus└o do Acordo (S/N) ?")
                  del_acordo()
                  show_saldo()
	       end
           end
	   TABELA:refreshall()

      case TEC = K_ENTER
           EXIT

   end
   Select CR1100

enddo

return WRET
//----------------------------------------------------------------------
function ins_acordo()
//----------------------------------------------------------------------
local getlist:= {}
WSCRDUP := savescreen(,,,,)

setcursor(1)

@ 10,10 say 'зддддддддддддддддддддддддддддддддддддддддддддд©'
@ 11,10 say 'Ё Data do Pagamento.:                         Ё'
@ 12,10 say 'Ё Valor Pago........:                         Ё'
@ 13,10 say 'Ё Saldo a Pagar.....:                         Ё'
@ 14,10 say 'юддддддддддддддддддддддддддддддддддддддддддддды'

X_DTACORDO   := date()
X_SDACORDO   := 0.00

if X_VLSALDO = 0
   X_VLACORDO := X_VALOR
else
   X_VLACORDO := X_VLSALDO
end

while .T.

    @ 11,32 get X_DTACORDO
    @ 12,32 get X_VLACORDO  picture "@E 999,999,999.99" valid tes_vlacordo()
    @ 13,32 get X_SDACORDO  picture "@E 999,999,999.99"
    read

    if lastkey() = K_ESC
       restscreen(,,,,WSCRDUP )
       setcursor(0)
       return nil
    end

    if pergunta("Confirma Inclusao do Acordo (S/N) ?")
       while CR1100->( ! rlock() ); end
       CR1100->(dbappend())
       CR1100->DUPLICATA := X_DUPLICATA
       CR1100->SEQUENCIA := X_SEQUENCIA
       CR1100->DTACORDO  := X_DTACORDO
       CR1100->VLACORDO  := X_VLACORDO
       CR1100->SDACORDO  := X_SDACORDO
       X_VLPAGO          := X_VLPAGO + X_VLACORDO
       X_VLSALDO         := X_SDACORDO
       CR1100->( dbunlock() )
       while CR1000->( ! rlock() ); end
       CR1000->ACORDO    := X_ACORDO
       CR1000->VLPAGO    := X_VLPAGO
       CR1000->VLSALDO   := X_VLSALDO
       CR1000->( dbunlock() )
       show_saldo()
       exit
    else
       loop
    end

enddo

restscreen(,,,,WSCRDUP )

setcursor(0)

return nil
/*
-------------------------------------------------------------------------------
                                      tes_vlacordo
-------------------------------------------------------------------------------
*/
function tes_vlacordo()
local WRET := .T.

  if X_VLSALDO = 0
     X_SDACORDO := (X_VALOR + X_JUROS) - X_VLACORDO
  else
     X_SDACORDO := X_VLSALDO - X_VLACORDO
  end
  @ 13,32 say X_SDACORDO  picture "@E 999,999,999.99"

  X_STATUS := "P"
  if X_SDACORDO = 0
     if pergunta ("Confirma Pagamento Final do Acordo (S/N) ?")
        X_STATUS := "R"
     else
        WRET := .F.
     end
  end

return WRET

/*
-------------------------------------------------------------------------------
                                      show_saldo
-------------------------------------------------------------------------------
*/
function show_saldo()
local WRET := .T.

  @ 11,60 say CR1000->VLPAGO  pict "@E 999,999,999.99"
  @ 12,60 say CR1000->VLSALDO pict "@E 999,999,999.99"

return WRET

/*
-------------------------------------------------------------------------------
                                      del_acordo
-------------------------------------------------------------------------------
*/
function del_acordo()
local WRET

  X_STATUS  := "P"
  X_VLPAGO  := CR1000->VLPAGO   - CR1100->VLACORDO
  X_VLSALDO := CR1000->VLSALDO  + CR1100->VLACORDO

  if (X_VLPAGO < 0)
      mensbeep(" Delecao Invalida Valor Pago Inferior a Zero ! ")
      WRET := .F.
  else
     while CR1100->( ! rlock() ); end
     CR1100->( dbdelete() )
     CR1100->( dbunlock() )
     CR1100->( dbskip()   )
     while CR1000->( ! rlock() ); end
     CR1000->VLPAGO    := X_VLPAGO
     CR1000->VLSALDO   := X_VLSALDO
     CR1000->ACORDO    := X_ACORDO
     CR1000->( dbunlock() )
  end

return WRET
