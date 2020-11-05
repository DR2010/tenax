/*
     CONTAS A RECEBER/CONTRA RETIRADA
     SR0600.PRG - Cheques Pre-Datados
*/

#include "inkey.ch"
setcancel(.t.)
ALTD(1)

telanum('SCE0600','SR0600')

X_CODBANCO      := space(03)
X_CODAGENCIA    := space(04)
X_AGENCIA       := space(30)
S_NR_CHEQUE     := space(11)
S_NR_CONTA      := space(11)
S_DUPLICATA     := space(05)
S_SEQUE_CH      := space(01)
S_TIPOPAG       := space(02)
S_FLAG_CGC      := 'G'
S_CGC           := space(14)
S_CPF           := space(11)
S_NOME          := space(20)
S_VALOR         := 0.00
S_DDD01         := space(04)
S_TEL01         := space(07)
S_DT_PREDATADA  := date()
X_CODCLI        := space(05)
S_NOME          := space(40)
S_USUARIO       := space(10)
S_DESCRICAO     := space(30)
S_DEST_NOME     := space(20)
S_DEST_DATA     := date()

// --> Inicio

abrir("CR0100")
abrir("CR0200")
abrir("CR1000")
abrir("SR0400")
abrir("CR0600")
abrir("SR0600")
abrir("SR1000")
abrir("SR1200")
abrir("VEN001")
abrir("VEN011")
abrir("VEN030")

private  W_FILE      := {}
private  CAMPO       := {}
private  MASCARA     := {}
private  CABECALHO   := {}
private  TAMANHO     := {}
private  BESCAPE     := {|| STATUS = "P" }
private  COR         := W_COR_002
private  TITULO      := " Cadastro de Cheques "
private  LININI      := 03
private  LINFIM      := 20
private  COLINI      := 02
private  COLFIM      := 77
private  BLOCK_DISP  := {|| .T. }
private  CAB_TITULO  := nil
private  BORDA       := 1

private  TECLA       := nil
private  TABELA      := nil


aadd( CAMPO     , "GUERRA"            )
aadd( CAMPO     , "DUPLICATA"         )
aadd( CAMPO     , "SEQUENCIA"         )
aadd( CAMPO     , "DT_PREDATA"        )
aadd( CAMPO     , "VALOR"             )
aadd( CAMPO     , "DEST_NOME"         )
aadd( CAMPO     , "DEST_DATA"         )

aadd( MASCARA   , "@!"                )
aadd( MASCARA   , "@!"                )
aadd( MASCARA   , "@!"                )
aadd( MASCARA   , "@!"                )
aadd( MASCARA   , "999,999,999.99"    )
aadd( MASCARA   , "@!"                )
aadd( MASCARA   , "@!"                )

aadd( CABECALHO , "Cliente"           )
aadd( CABECALHO , "Duplicata"         )
aadd( CABECALHO , "Sq"                )
aadd( CABECALHO , "Dep¢sito"          )
aadd( CABECALHO , "Valor"             )
aadd( CABECALHO , "Dest/nome"         )
aadd( CABECALHO , "Dest/data"         )

aadd( TAMANHO   , 10                  )
aadd( TAMANHO   , 09                  )
aadd( TAMANHO   , 02                  )
aadd( TAMANHO   , 08                  )
aadd( TAMANHO   , 14                  )
aadd( TAMANHO   , 16                  )
aadd( TAMANHO   , 09                  )

aadd( W_FILE , "VEN001" )
aadd( W_FILE , "SR0600" )
aadd( W_FILE , "SR0600" )
aadd( W_FILE , "SR0600" )
aadd( W_FILE , "SR0600" )
aadd( W_FILE , "SR0600" )
aadd( W_FILE , "SR0600" )

SR0600->(dbsetorder(3))
SR0600->(dbseek("P"))

// SR0600->( dbsetrelation( "VEN001", {|| SR0600->CODCLI }, "SR0600->CODCLI" ) )
SR0600->( dbsetrelation( "VEN001", {|| SR0600->CODCLI }, "SR0600->CODCLI" ) )

setcolor(W_COR_002)
Stedite600()

select SR0600

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

SR0600_pendente()

SR0600->(dbsetorder(3))
SR0600->(dbseek("P"))

CONTINUA := .T.

do while CONTINUA .and. ( (TEC:=tabmov(TABELA)) != K_ESC )

  mensagem('<F3> - Inclui / <F4> - Altera / <F5> - Exclui')


  W_TEL0600 := savescreen(,,,,)
  restscreen(,,,,W_TEL0600)

   do case
      case TEC == 28 ; help() ; return 1
      case TEC == 27 ; return 0

      case TEC = -2   && inclusao f3
	  Sinsere600()
	  restscreen(,,,,W_TEL0600)
	  keyboard chr(1)
	  SR0600_pendente()
	  SELECT SR0600
	  SR0600->(dbsetorder(3))

      case TEC == 13   && consulta - enter
	  if SR0600->( ! eof() )
             Seditae600('a')
	  end
	  restscreen(,,,,W_TEL0600)
	  keyboard chr(1)
	  SR0600_pendente()
	  SELECT SR0600
	  SR0600->(dbsetorder(3))

      case TEC == -3   && alteracao f4
	  if SR0600->( ! eof() )
	     Seditae600()
	  end
	  restscreen(,,,,W_TEL0600)
	  keyboard chr(1)
	  SR0600_pendente()
	  SELECT SR0600
	  SR0600->(dbsetorder(3))

      case TEC = -4   &&  exclusao f5
	  if SR0600->(!eof())
	     if pergunta("Confirma exclus„o do Cheque (S/N) ?")
		S_DUPLICATA := SR0600->DUPLICATA
		S_SEQUE_CH  := SR0600->SEQUENCIA
                if flag_Sduplicata("D")
		   while SR0600->( ! rlock() ); end
		   SR0600->( dbdelete() )
		   SR0600->( dbunlock() )
		   SR0600->(dbskip())
		end
	     end
	  end
	  restscreen(,,,,W_TEL0600)
	  keyboard chr(1)
	  SR0600_pendente()
	  SELECT SR0600
	  SR0600->(dbsetorder(3))

      case TEC = K_ESC
	 CONTINUA := .F.

   end
   SELECT SR0600
   SR0600->(dbsetorder(3))

enddo

close data

return

************************************
function Sinsere600()
************************************

setcursor(1)

while .t.

   Stelae600()

   X_CODCLI      :=  space(05)
   X_CODBANCO    :=  space(03)
   X_CODAGENCIA  :=  space(04)
   X_AGENCIA     :=  space(30)
   S_NR_CONTA    :=  space(11)
   S_NR_CHEQUE   :=  space(11)
   S_FLAG_CGC    :=  'G'
   S_CGC         :=  space(14)
   S_CPF         :=  space(11)
   S_NOME        :=  space(20)
   S_DUPLICATA   :=  space(05)
   S_SEQUE_CH    :=  space(01)
   S_DESCRICAO   :=  space(30)
   S_VALOR       :=  0.00
   S_DT_PREDATA  :=  ctod('')
   S_DDD01       :=  space(04)
   S_TEL01       :=  space(07)
   S_DEST_NOME   :=  space(20)
   S_DEST_DATA   :=  ctod ('')

   @ 05,15 get X_CODCLI           picture "@!"  valid TES_CODCLI(X_CODCLI,05,15,20)
   read
   if lastkey() = K_ESC;exit;end

   S_DDD01 := VEN001->DDD01
   @ 06,17 say VEN001->DDD01      picture "9999"
   @ 06,17 get S_DDD01            picture "9999"
   S_TEL01 := VEN001->TEL01
   @ 06,22 say VEN001->TEL01      picture "@R 999-9999"
   @ 06,22 get S_TEL01            picture "@R 999-9999"
   S_NOME := left(VEN001->RAZAO,40)
   S_CGC  := VEN001->CGC
   @ 16,19 SAY S_CGC           picture "@R 99.999.999/9999-99"
   @ 06,33 get S_NOME             picture "@!"

   @ 07,15 get S_DUPLICATA        picture "@!"
   @ 07,24 get S_SEQUE_CH         picture "@!"                valid TES_Sdup_ch(07,15)
   read
   if lastkey() = K_ESC; exit;end

   VEN030->(dbsetorder(1))
   if ! ( VEN030->(dbseek(S_DUPLICATA)) )
      mensbeep (" Nota Fiscal Inexistente !")
      loop
   else
      @ 08,15 say VEN030->DT_EMISSAO       picture "99/99/99"
   end

   SR0400->(dbsetorder(1))
   if !SR0400->(dbseek(VEN030->TIPOVENDA + SR1000->FORMAPAG))
      mensbeep (" Forma de Pagamento Inexistente !")
      loop
   end
   if SR0400->CHEQUE # 'X'
      mensbeep (" Forma de Pagamento da Duplicata N„o Indica Cheque !")
      loop
   end

   @ 08,42 say SR1000->DT_VENC       picture "99/99/99"
   @ 08,62 say SR1000->VALOR         picture "@E 999,999,999.99"
   S_DT_PREDATA := SR1000->DT_VENC

   @ 10,15 get S_DT_PREDATA       picture "99/99/99"
   @ 10,42 get S_VALOR            picture "@E 999,999,999.99"


   @ 12,15 get X_CODBANCO             picture "999"               valid TES_codbanco  (12,15)

   inc_codagencia(13,15)

   @ 14,15 get S_NR_CONTA         picture "@!"
   @ 15,15 get S_NR_CHEQUE        picture "@!"
   read

   if lastkey() = K_ESC; exit;end

   @ 14,15 say S_NR_CONTA
   @ 15,15 say S_NR_CHEQUE

   SR0600->(dbsetorder(1))
   if SR0600->(dbseek(X_CODBANCO+X_CODAGENCIA+S_NR_CONTA+S_NR_CHEQUE))
      mensbeep(" Cheque Ja Existente ")
      loop
   end

   @ 16,16 get S_FLAG_CGC         picture "@!" valid TESTE_CGC() // S_FLAG_CGC $ "CG"
   read

   if empty( S_CGC )
      S_CGC := S_CPF+space(3)
   end

   @ 18,15 get S_DEST_NOME        picture "@!"
   @ 19,15 get S_DEST_DATA        picture "99/99/99"
   read

   if lastkey()=27; exit; end

   if pergunta('Confirma inclus„o do Cheque (S/N) ?')
      if flag_Sduplicata("I")
	 SR0600->( dbappend() )
	 SR0600->CODBANCO     :=  X_CODBANCO
	 SR0600->CODAGENCIA   :=  X_CODAGENCIA
	 SR0600->NR_CONTA     :=  S_NR_CONTA
	 SR0600->NR_CHEQUE    :=  S_NR_CHEQUE
	 SR0600->CGC          :=  S_CGC
	 SR0600->CPF          :=  S_CPF
	 SR0600->NOME         :=  S_NOME
	 SR0600->CODCLI       :=  X_CODCLI
	 SR0600->DUPLICATA    :=  S_DUPLICATA
	 SR0600->SEQUENCIA    :=  S_SEQUE_CH
	 SR0600->DT_PREDATA   :=  S_DT_PREDATA
	 SR0600->VALOR        :=  S_VALOR
	 SR0600->STATUS       :=  "P"
	 SR0600->DEST_NOME    :=  S_DEST_NOME
	 SR0600->DEST_DATA    :=  S_DEST_DATA
	 scroll(09,27,19,54,1)
	 SR0600->( dbunlock() )
     end
   end

end

************************************
function Seditae600(FLAG)
************************************
setcursor(1)

Stelae600()

X_CODCLI         := SR0600->CODCLI
X_CODBANCO       := SR0600->CODBANCO
X_CODAGENCIA     := SR0600->CODAGENCIA
S_NR_CONTA       := SR0600->NR_CONTA
S_NR_CHEQUE      := SR0600->NR_CHEQUE
S_FLAG_CGC       := SPACE(1)
S_CGC            := SR0600->CGC
S_CPF            := SR0600->CPF
S_NOME           := SR0600->NOME
S_DUPLICATA      := SR0600->DUPLICATA
S_SEQUE_CH       := SR0600->SEQUENCIA
S_VALOR          := SR0600->VALOR
S_DT_PREDATA     := SR0600->DT_PREDATA
S_DDD01          := VEN001->DDD01
S_TEL01          := VEN001->TEL01
S_DEST_NOME      := SR0600->DEST_NOME
S_DEST_DATA      := SR0600->DEST_DATA

TES_CODCLI    (X_CODCLI,05,15,30)
TES_codbanco  (12,15)
TES_COdagencia(13,15)

// inicio do Say

@ 06,17 say S_DDD01            picture "9999"
@ 06,22 say S_TEL01            picture "@R 999-9999"
@ 06,38 say S_NOME             picture "@!"
@ 07,15 say S_DUPLICATA        picture "@!"
@ 07,24 say S_SEQUE_CH         picture "@!"

VEN030->(dbsetorder(1))
if VEN030->(dbseek(S_DUPLICATA))
   @ 08,15 say VEN030->DT_EMISSAO       picture "99/99/99"
end

SR1000->(dbsetorder(1))
if SR1000->(dbseek(S_DUPLICATA+S_SEQUE_CH ))
   @ 08,42 say SR1000->DT_VENC       picture "99/99/99"
   @ 08,62 say SR1000->VALOR         picture "@E 999,999,999.99"
end

@ 10,15 say S_DT_PREDATA       picture "99/99/99"
@ 10,42 say S_VALOR            picture "@E 999,999,999.99"
@ 14,15 say S_NR_CONTA         picture "@!"
@ 15,15 say S_NR_CHEQUE        picture "@!"

if len( alltrim(S_CGC) ) = 14
   S_FLAG_CGC := "G"
else
   S_FLAG_CGC := "C"
   S_CPF      := alltrim(S_CGC)
end

@ 16,16 say S_FLAG_CGC         picture "!"

if S_FLAG_CGC = "G"
   @ 16,19 say S_CGC           picture "@R 99.999.999/9999-99"
else
   @ 16,19 say S_CPF           picture "@R 999.999.999-99"
end
@ 18,15 say S_DEST_NOME        picture "@!"
@ 19,15 say S_DEST_DATA        picture "99/99/99"

if FLAG # nil
   inkey(0)
   return nil
end

// fim do say
WHILE .T.
@ 05,15 get X_CODCLI           picture "@!" valid TES_CODCLI    (X_CODCLI,05,15,30)
@ 06,17 get S_DDD01            picture "9999"
@ 06,22 get S_TEL01            picture "@R 999-9999"
@ 06,38 get S_NOME             picture "@!"
@ 10,15 get S_DT_PREDATA       picture "99/99/99"
@ 10,42 get S_VALOR            picture "@E 999,999,999.99"
@ 12,15 get X_CODBANCO         picture "999"               valid TES_codbanco  (12,15)
@ 13,15 get X_CODAGENCIA       picture "9999"              valid TES_COdagencia(13,15)
@ 14,15 get S_NR_CONTA         picture "@!"
@ 15,15 get S_NR_CHEQUE        picture "@!"
@ 16,16 get S_FLAG_CGC         picture "!" valid TESTE_CGC() //S_FLAG_CGC $ "CG"
read

if lastkey() = K_ESC
  exit
end
@ 18,15 get S_DEST_NOME        picture "@!"
@ 19,15 get S_DEST_DATA        picture "99/99/99"
read

if lastkey() = K_ESC
  exit
end

if S_FLAG_CGC = "C"
   S_CGC := S_CPF+space(3)
end

 if conf('Confirma alteracao dos dados ?')
  while SR0600->( ! rlock() ); end
  SR0600->CODBANCO   :=    X_CODBANCO
  SR0600->CODAGENCIA :=    X_CODAGENCIA
  SR0600->NR_CONTA   :=    S_NR_CONTA
  SR0600->NR_CHEQUE  :=    S_NR_CHEQUE
  SR0600->CGC        :=    S_CGC
  SR0600->CPF        :=    S_CPF
  SR0600->NOME       :=    S_NOME
  SR0600->CODCLI     :=    X_CODCLI
  SR0600->DUPLICATA  :=    S_DUPLICATA
  SR0600->SEQUENCIA  :=    S_SEQUE_CH
  SR0600->DT_PREDATA :=    S_DT_PREDATA
  SR0600->VALOR      :=    S_VALOR
  SR0600->STATUS     :=    "P"
  SR0600->DEST_NOME  :=    S_DEST_NOME      
  SR0600->DEST_DATA  :=    S_DEST_DATA      

  SR0600->( dbunlock() )
  exit
 end
END
setcursor(0)

return nil

/*
-------------------------------------------------------------------------------
Procedimento .: STEDITe600
Objetivo .....: Menu rapido
-------------------------------------------------------------------------------
*/
procedure Stedite600()
   local W_OLDCOR := setcolor()

   setcolor(W_COR_002)
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
procedure Stelae600()

   setcolor( W_COR_002 )
   @ 05,02 say '³'
   @ 05,77 say '³'
   setcolor( W_COR_002 )

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
   @ 18,02 say '³ Dest/Nome.:                                                              ³'
   @ 19,02 say '³ Dest/Data.:                                                              ³'
   @ 20,02 say '³                                                                          ³'
   @ 21,02 say '³                                                                          ³'
   @ 22,02 say 'ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ'


// --> Fim

//---------------------
function flag_Sduplicata(P_MODO)
//---------------------
local WRET := .T.

SR1000->(dbsetorder(2))
if ! (SR1000->(dbseek("P" + S_DUPLICATA + S_SEQUE_CH )) )
   mensbeep('Duplicata Inexistente !')
   WRET := .F.
   return WRET
end

While SR1000->( ! rlock() ); end
if P_MODO = "I"
   SR1000->QTD_CH := SR1000->QTD_CH + 1
else
   if SR1000->QTD_CH = 0
      mensbeep(' Qtd Cheque insuficiente ! ')
      WRET:= .F.
      return WRET
   else
     SR1000->QTD_CH := SR1000->QTD_CH - 1
   end
end

if S_VALOR = (SR1000->VALOR + SR1000->JUROS)
   SR1000->TIPO_DOC := ' '
end

SR1000->(dbunlock())

return WRET


/*
-------------------------------------------------------------------------------
		       CALCULA TOTAL DE CHEQUES PENDENTES
-------------------------------------------------------------------------------
*/
function SR0600_pendente()
   local WRET := 0, OLDREC := SR0600->( recno() )

   SR0600->( dbsetorder(3))
   SR0600->( dbseek("P") )

   while SR0600->( ! eof() )
      if SR0600->STATUS = "P"
	 WRET = WRET + SR0600->VALOR
      else
	 exit
      end
      SR0600->( dbskip() )
   end

   SR0600->( dbgoto( OLDREC ) )

   @ 20,02 say 'ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´'
   @ 21,02 say '³                                        Total Pendente...:                ³'
   @ 22,02 say 'ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ'
   @ 21,62 say WRET picture "@E 999,999,999.99"

return WRET

function teste_cgc()
 local getlist := {}
 local wret := .t.
 if S_FLAG_CGC $ "CG"
   @ 16,19 say space(19)
   if S_FLAG_CGC = "G"
      @ 16,19 get S_CGC           picture "@R 99.999.999/9999-99"   ;
					   valid testa_cgc( S_CGC )
   else
      @ 16,19 get S_CPF           picture "@R 999.999.999-99"       ;
					   valid testa_cpf( S_CPF )
   end
   read
   if lastkey() = 27
     wret := .f.
   end


end
return (wret)
