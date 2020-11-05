/*

		    CR0600.PRG - Cheques Pre-Datados

*/

#include "inkey.ch"
setcancel(.t.)
ALTD(1)

telanum('SCE0600','CR0600')

setcolor(W_COREDIT)

X_CODBANCO	:= space(03)
X_CODAGENCIA    := space(04)
X_AGENCIA       := space(30)
X_NR_CHEQUE	:= space(11)
X_NR_CONTA	:= space(11)
X_DUPLICATA	:= space(08)
X_SEQUE_CH      := space(01)
X_TIPOPAG	:= space(02)
X_FLAG_CGC      := space(01)
X_CGC           := space(14)
X_CPF           := space(11)
X_NOME          := space(20)
X_VALOR 	:= 0.00
X_DDD01         := space(04)
X_TEL01         := space(07)
X_DT_PREDATADA	:= date()
X_CODCLI	:= space(05)
X_NOME		:= space(40)
X_DESTINO       := space(50)
X_USUARIO	:= space(10)
X_DESCRICAO	:= space(30)

// --> Inicio

abrir("CR0100")
abrir("CR0200")
abrir("CR0400")
abrir("CR0600")
abrir("CR1000")
abrir("CR1200")
abrir("VEN001")
abrir("VEN011")
abrir("VEN012")

private  W_FILE      := {}
private  CAMPO	     := {}
private  MASCARA     := {}
private  CABECALHO   := {}
private  TAMANHO     := {}
private  BESCAPE     := {|| STATUS = "P" }
private  COR	     := W_COREDIT
private  TITULO      := " Cadastro de Cheques "
private  LININI      := 03
private  LINFIM      := 20
private  COLINI      := 02
private  COLFIM      := 77
private  BLOCK_DISP  := {|| .T. }
private  CAB_TITULO  := nil
private  BORDA	     := 1

private  TECLA	     := nil
private  TABELA      := nil


aadd( CAMPO     , "CODBANCO"          )
aadd( CAMPO     , "CODAGENCIA"        )
aadd( CAMPO     , "NR_CONTA"          )
aadd( CAMPO     , "GUERRA"            )
aadd( CAMPO     , "DUPLICATA"         )
aadd( CAMPO     , "SEQUENCIA"         )
aadd( CAMPO     , "DT_PREDATA"        )
aadd( CAMPO     , "VALOR"             )

aadd( MASCARA   , "@!"                )
aadd( MASCARA   , "@!"                )
aadd( MASCARA   , "@!"                )
aadd( MASCARA   , "@!"                )
aadd( MASCARA   , "@!"                )
aadd( MASCARA   , "@!"                )
aadd( MASCARA   , "@!"                )
aadd( MASCARA   , "999,999,999.99"    )

aadd( CABECALHO , "Bc"                )
aadd( CABECALHO , "Ag"                )
aadd( CABECALHO , "Conta"             )
aadd( CABECALHO , "Cliente"           )
aadd( CABECALHO , "Duplicata"         )
aadd( CABECALHO , "Sq"                )
aadd( CABECALHO , "Dep¢sito"          )
aadd( CABECALHO , "Valor"             )

aadd( TAMANHO   , 03                  )
aadd( TAMANHO   , 04                  )
aadd( TAMANHO   , 11                  )
aadd( TAMANHO   , 10                  )
aadd( TAMANHO   , 09                  )
aadd( TAMANHO   , 02                  )
aadd( TAMANHO   , 08                  )
aadd( TAMANHO   , 14                  )

aadd( W_FILE , "CR0600" )
aadd( W_FILE , "CR0600" )
aadd( W_FILE , "CR0600" )
aadd( W_FILE , "VEN001" )
aadd( W_FILE , "CR0600" )
aadd( W_FILE , "CR0600" )
aadd( W_FILE , "CR0600" )
aadd( W_FILE , "CR0600" )

CR0600->(dbsetorder(3))
CR0600->(dbseek("P"))

// CR0600->( dbsetrelation( "VEN001", {|| CR0600->CODCLI }, "CR0600->CODCLI" ) )
CR0600->( dbsetrelation( "VEN001", {|| CR0600->CODCLI }, "CR0600->CODCLI" ) )

setcolor(W_COREDIT)
tedite600()

select CR0600

TABELA := tabelanew( CAMPO          , ;
                     MASCARA        , ;
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
                     COLFIM         , ;
                     W_FILE           ;
		   )

cr0600_pendente()

CR0600->(dbsetorder(3))
CR0600->(dbseek("P"))

CONTINUA := .T.

do while CONTINUA .and. ( (TEC:=tabmov(TABELA)) != K_ESC )

  mensagem('<F3> - Inclui / <F4> - Altera / <F5> - Exclui')


  W_TEL0600 := savescreen(,,,,)
  restscreen(,,,,W_TEL0600)

   do case
      case TEC == 28 ; help() ; return 1
      case TEC == 27 ; return 0

      case TEC = -2   && inclusao f3
	  insere600()
	  restscreen(,,,,W_TEL0600)
	  keyboard chr(1)
	  cr0600_pendente()
	  SELECT CR0600
	  CR0600->(dbsetorder(3))

      case TEC == -3   && alteracao f4
	  if CR0600->( ! eof() )
	     editae600()
	  end
	  restscreen(,,,,W_TEL0600)
	  keyboard chr(1)
	  cr0600_pendente()
	  SELECT CR0600
	  CR0600->(dbsetorder(3))

      case TEC = -4   &&  exclusao f5
          if CR0600->(!eof())
             if pergunta("Confirma exclus„o do Cheque (S/N) ?")
		X_DUPLICATA := CR0600->DUPLICATA
                X_SEQUE_CH  := CR0600->SEQUENCIA
                if flag_duplicata("D") .AND. VEN012->STATUS = "C"
		   while CR0600->( ! rlock() ); end
		   CR0600->( dbdelete() )
		   CR0600->( dbunlock() )
		   CR0600->(dbskip())
		end
	     end
	  end
	  restscreen(,,,,W_TEL0600)
	  keyboard chr(1)
	  cr0600_pendente()
	  SELECT CR0600
	  CR0600->(dbsetorder(3))

      case TEC = K_ESC
	 CONTINUA := .F.

   end
   SELECT CR0600
   CR0600->(dbsetorder(3))

enddo

close data

return

************************************
function insere600()
************************************

setcursor(1)

while .t.

   telae600()

   X_CODCLI	 :=    space(05)
   X_CODBANCO	 :=    space(03)
   X_CODAGENCIA  :=    space(04)
   X_AGENCIA     :=    space(30)
   X_NR_CONTA	 :=    space(11)
   X_NR_CHEQUE	 :=    space(11)
   X_FLAG_CGC    :=    space(01)
   X_CGC         :=    space(14)
   X_CPF         :=    space(11)
   X_NOME        :=    space(20)
   X_DUPLICATA	 :=    space(08)
   X_SEQUE_CH    :=    space(01)
   X_DESCRICAO	 :=    space(30)
   X_VALOR	 :=    0.00
   X_DT_PREDATA  :=    ctod('')
   X_DESTINO     :=    space(50)
   X_DDD01	 :=    space(04)
   X_TEL01	 :=    space(07)

   @ 05,15 get X_CODCLI           picture "@!"  valid tes_codcli(X_CODCLI,05,15,20)
   read
   if lastkey() = K_ESC;exit;end

   X_DDD01 := VEN001->DDD01
   @ 06,17 say VEN001->DDD01      picture "9999"
   @ 06,17 get X_DDD01            picture "9999"
   X_TEL01 := VEN001->TEL01
   @ 06,22 say VEN001->TEL01      picture "@R 999-9999"
   @ 06,22 get X_TEL01            picture "@R 999-9999"
   X_NOME := left(VEN001->RAZAO,40)
   @ 06,33 get X_NOME             picture "@!"

   @ 07,15 get X_DUPLICATA        picture "@!"
   @ 07,24 get X_SEQUE_CH         picture "@!"                valid tes_dup_ch(07,15)
   read
   if lastkey() = K_ESC; exit;end

   VEN012->(dbsetorder(1))
   if ! ( VEN012->(dbseek(X_DUPLICATA)) )
      mensbeep (" Nota Fiscal Inexistente !")
      loop
   else
      @ 08,15 say VEN012->DT_EMISSAO       picture "99/99/99"
   end

   CR0400->(dbsetorder(1))
   if !CR0400->(dbseek(VEN012->TIPOVENDA + CR1000->FORMAPAG))
      mensbeep (" Forma de Pagamento Inexistente !")
      loop
   end
   if CR0400->CHEQUE # 'X'
      mensbeep (" Forma de Pagamento da Duplicata N„o Indica Cheque !")
      loop
   end

   @ 08,42 say CR1000->DT_VENC       picture "99/99/99"
   @ 08,62 say CR1000->VALOR         picture "@E 999,999,999.99"
   X_DT_PREDATA := CR1000->DT_VENC

   @ 10,15 get X_DT_PREDATA       picture "99/99/99"
   @ 10,42 get X_VALOR            picture "@E 999,999,999.99"


   @ 12,15 get X_CODBANCO         picture "999"               valid tes_codbanco  (12,15)

   inc_codagencia(13,15)

   @ 14,15 get X_NR_CONTA         picture "99999999999"
   @ 15,15 get X_NR_CHEQUE        picture "99999999999"
   read

   if lastkey() = K_ESC; exit;end

   X_NR_CONTA  := zerofill(X_NR_CONTA  )
   X_NR_CHEQUE := zerofill(X_NR_CHEQUE )
   @ 14,15 say X_NR_CONTA
   @ 15,15 say X_NR_CHEQUE

   CR0600->(dbsetorder(1))
   if CR0600->(dbseek(X_CODBANCO+X_CODAGENCIA+X_NR_CONTA+X_NR_CHEQUE))
      mensbeep(" Cheque Ja Existente ")
      loop
   end

   @ 16,16 get X_FLAG_CGC         picture "@!" valid X_FLAG_CGC $ "CG"

   @ 16,19 get X_CGC              picture "@R 99.999.999/9999-99"   ;
                                           valid testa_cgc( X_CGC ) ;
                                           when X_FLAG_CGC = "G"

   @ 16,19 get X_CPF              picture "@R 999.999.999-99"       ;
                                           valid testa_cpf( X_CPF ) ;
                                           when X_FLAG_CGC = "C"

   if empty( X_CGC )
      X_CGC := X_CPF+space(3)
   end

   @ 20,15 get X_DESTINO          picture "@!"
   read

   if lastkey()=27; exit; end

   if pergunta('Confirma inclus„o do Cheque (S/N) ?')
      if flag_duplicata("I")
	 CR0600->( dbappend() )
	 CR0600->CODBANCO   :=	  X_CODBANCO
	 CR0600->CODAGENCIA :=	  X_CODAGENCIA
	 CR0600->NR_CONTA   :=	  X_NR_CONTA
	 CR0600->NR_CHEQUE  :=	  X_NR_CHEQUE
         CR0600->CGC        :=    X_CGC
         CR0600->CPF        :=    X_CPF
         CR0600->NOME       :=    X_NOME
	 CR0600->CODCLI     :=	  X_CODCLI
	 CR0600->DUPLICATA  :=	  X_DUPLICATA
         CR0600->SEQUENCIA  :=    X_SEQUE_CH
	 CR0600->DT_PREDATA :=	  X_DT_PREDATA
	 CR0600->VALOR	    :=	  X_VALOR
	 CR0600->DESTINO    :=	  X_DESTINO
	 CR0600->STATUS     :=	  "P"
	 scroll(09,27,19,54,1)
	 CR0600->( dbunlock() )
     end
   end

end

************************************
function editae600()
************************************
setcursor(1)

telae600()

X_CODCLI	 := CR0600->CODCLI
X_CODBANCO	 := CR0600->CODBANCO
X_CODAGENCIA	 := CR0600->CODAGENCIA
X_NR_CONTA	 := CR0600->NR_CONTA
X_NR_CHEQUE	 := CR0600->NR_CHEQUE
X_FLAG_CGC       := SPACE(1)
X_CGC            := CR0600->CGC
X_CPF            := CR0600->CPF
X_NOME           := CR0600->NOME
X_DUPLICATA	 := CR0600->DUPLICATA
X_SEQUE_CH       := CR0600->SEQUENCIA
X_VALOR 	 := CR0600->VALOR
X_DT_PREDATA	 := CR0600->DT_PREDATA
X_DESTINO        := CR0600->DESTINO
X_DDD01 	 := VEN001->DDD01
X_TEL01 	 := VEN001->TEL01

tes_codcli    (X_CODCLI,05,15,30)
@ 05,15 get X_CODCLI           picture "@!" valid tes_codcli    (X_CODCLI,05,15,30)

@ 06,17 get X_DDD01            picture "9999"
@ 06,22 get X_TEL01            picture "@R 999-9999"
@ 06,38 get X_NOME             picture "@!"
@ 07,15 say X_DUPLICATA        picture "@!"
@ 07,24 say X_SEQUE_CH         picture "@!" //VAlid tes_duplicata(07,24)

VEN012->(dbsetorder(1))
if VEN012->(dbseek(X_DUPLICATA))
   @ 08,15 say VEN012->DT_EMISSAO       picture "99/99/99"
end

CR1000->(dbsetorder(2))
if CR1000->(dbseek("P"+X_DUPLICATA+X_SEQUE_CH ))
   @ 08,42 say CR1000->DT_VENC       picture "99/99/99"
   @ 08,62 say CR1000->VALOR         picture "@E 999,999,999.99"
end

@ 10,15 get X_DT_PREDATA       picture "99/99/99"
@ 10,42 get X_VALOR            picture "@E 999,999,999.99"

tes_codbanco(12,15)
tes_codagencia(13,15)
@ 12,15 get X_CODBANCO         picture "999"               valid tes_codbanco  (12,15)
@ 13,15 get X_CODAGENCIA       picture "9999"              valid tes_codagencia(13,15)
@ 14,15 get X_NR_CONTA         picture "99999999999"
@ 15,15 get X_NR_CHEQUE        picture "99999999999"

if len( alltrim(X_CGC) ) = 14
   X_FLAG_CGC := "G"
else
   X_FLAG_CGC := "C"
   X_CPF      := alltrim(X_CGC)
end

@ 16,16 get X_FLAG_CGC         picture "!" valid X_FLAG_CGC $ "CG"

@ 16,19 get X_CGC              picture "@R 99.999.999/9999-99"   ;
                                          valid testa_cgc( X_CGC ) ;
                                          when X_FLAG_CGC = "G"

@ 16,19 get X_CPF              picture "@R 999.999.999-99"       ;
                                        valid testa_cpf( X_CPF ) ;
                                        when X_FLAG_CGC = "C"

@ 20,15 get X_DESTINO          picture "@!"
read

if lastkey() = K_ESC
   return nil
end

if ! empty( X_CPF )
   X_CGC := X_CPF+space(3)
end

while CR0600->( ! rlock() ); end
CR0600->CGC        := X_CGC
CR0600->CPF        := X_CPF
CR0600->NOME       := X_NOME
CR0600->DUPLICATA  := X_DUPLICATA
CR0600->SEQUENCIA  := X_SEQUE_CH
CR0600->CODCLI	   := X_CODCLI
CR0600->VALOR	   := X_VALOR
CR0600->DT_PREDATA := X_DT_PREDATA
CR0600->DESTINO    := X_DESTINO
CR0600->STATUS     :=    "P"
CR0600->( dbunlock() )

setcursor(0)

return nil

/*
-------------------------------------------------------------------------------
Procedimento .: TEDITe600
Objetivo .....: Menu rapido
-------------------------------------------------------------------------------
*/
procedure tedite600()
   local W_OLDCOR := setcolor()

   setcolor(W_COREDIT)
   quadro(03,02,20,77,"")
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
Procedimento .: TELAe600
Objetivo .....: Menu rapido
-------------------------------------------------------------------------------
*/
procedure telae600()

   setcolor( W_COREDIT )
   @ 05,02 say '³'
   @ 05,77 say '³'
   setcolor( W_CORGET )

   @ 04,02 say '³                                                                          ³'
   @ 05,02 say '³ Cliente...:       -                                                      ³'
   @ 06,02 say '³ Telefone..: (    )                                                       ³'
   @ 07,02 say '³ Duplicata.:         /                                                    ³'
   @ 08,02 say '³ Emiss„o...:   /   /     Vencimento...:          Valor...:                ³'
   @ 09,02 say '³                                                                          ³'
   @ 10,02 say '³ Bom Para..:   /   /     Valor Cheque.:                                   ³'
   @ 11,02 say '³                                                                          ³'
   @ 12,02 say '³ Banco.....:      -                                                       ³'
   @ 13,02 say '³ Agˆncia...:      -                                                       ³'
   @ 14,02 say '³ Conta.....:                                                              ³'
   @ 15,02 say '³ Nro.Cheque:                                                              ³'
   @ 16,02 say '³ Cpf/cGc...:[ ]                                                           ³'
   @ 17,02 say '³                                                                          ³'
   @ 18,02 say '³                                                                          ³'
   @ 19,02 say '³                                                                          ³'
   @ 20,02 say '³ Destino...:                                                              ³'
   @ 21,02 say '³                                                                          ³'
   @ 22,02 say 'ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ'


// --> Fim

//---------------------
function flag_duplicata(P_MODO)
//---------------------
local WRET := .T.

CR1000->(dbsetorder(2))
if ! (CR1000->(dbseek("P" + X_DUPLICATA + X_SEQUE_CH )) )
   mensbeep('Duplicata Inexistente !')
   WRET := .F.
   return WRET
end

While CR1000->( ! rlock() ); end
if P_MODO = "I"
   CR1000->QTD_CH := CR1000->QTD_CH + 1
else
   if CR1000->QTD_CH = 0
      mensbeep(' Qtd Cheque insuficiente ! ')
      WRET:= .F.
      return WRET
   else
     CR1000->QTD_CH := CR1000->QTD_CH - 1
   end
end

if X_VALOR = (CR1000->VALOR + CR1000->JUROS)
   CR1000->TIPO_DOC := ' '
end

CR1000->(dbunlock())

return WRET


/*
-------------------------------------------------------------------------------
		       CALCULA TOTAL DE CHEQUES PENDENTES
-------------------------------------------------------------------------------
*/
function cr0600_pendente()
   local WRET := 0, OLDREC := CR0600->( recno() )

   CR0600->( dbsetorder(3))
   CR0600->( dbseek("P") )

   while CR0600->( ! eof() )
      if CR0600->STATUS = "P"
	 WRET = WRET + CR0600->VALOR
      else
	 exit
      end
      CR0600->( dbskip() )
   end

   CR0600->( dbgoto( OLDREC ) )

   @ 20,02 say 'ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´'
   @ 21,02 say '³                                        Total Pendente...:                ³'
   @ 22,02 say 'ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ'
   @ 21,62 say WRET picture "@E 999,999,999.99"

return WRET


