/*
     CONTAS A RECEBER/CONTRA RETIRADA
     SR0700.PRG - Cheques Pre-Datados
*/

#include "inkey.ch"
setcancel(.t.)

telanum('SCE0700','ER0700')

X_CODBANCO      := space(03)
X_CODAGENCIA    := space(04)
X_AGENCIA       := space(30)
S_NR_CHEQUE     := space(11)
S_NR_CONTA      := space(11)
S_DUPLICATA     := space(05)
S_SEQUE_CH      := space(01)
S_TIPOPAG       := space(02)
S_FLAG_CGC      := space(01)
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

private  W_FILE     := {}
private  CAMPO      := {}
private  MASCARA    := {}
private  CABECALHO  := {}
private  TAMANHO    := {}
private  BESCAPE    := {|| STATUS = "R" }
private  COR        := W_COR_002
private  TITULO     := " Cheques recebidos c/ Duplicatas Baixadas "
private  LININI     := 03
private  LINFIM     := 20
private  COLINI     := 02
private  COLFIM     := 77
private  BLOCK_DISP := {|| .T. }
private  CAB_TITULO := nil
private  BORDA      := 1

private  TECLA      := nil
private  TABELA     := nil


aadd( CAMPO     , "GUERRA"         )
aadd( CAMPO     , "DUPLICATA"      )
aadd( CAMPO     , "SEQUENCIA"      )
aadd( CAMPO     , "DT_PREDATA"     )
aadd( CAMPO     , "VALOR"          )
aadd( CAMPO     , "DEST_NOME"      )
aadd( CAMPO     , "DEST_DATA"      )

aadd( MASCARA   , "@!"             )
aadd( MASCARA   , "@!"             )
aadd( MASCARA   , "@!"             )
aadd( MASCARA   , "@!"             )
aadd( MASCARA   , "999,999,999.99" )
aadd( MASCARA   , "@!"             )
aadd( MASCARA   , "@!"             )
			       
aadd( CABECALHO , "Cliente"     )
aadd( CABECALHO , "Duplicata"   )
aadd( CABECALHO , "Sq"          )
aadd( CABECALHO , "Dep¢sito"    )
aadd( CABECALHO , "Valor"       )
aadd( CABECALHO , "Dest/nome"   )
aadd( CABECALHO , "Dest/data"   )

aadd( TAMANHO   , 10            )
aadd( TAMANHO   , 09            )
aadd( TAMANHO   , 02            )
aadd( TAMANHO   , 08            )
aadd( TAMANHO   , 14            )
aadd( TAMANHO   , 16            )
aadd( TAMANHO   , 09            )

aadd( W_FILE , "VEN001" )
aadd( W_FILE , "SR0600" )
aadd( W_FILE , "SR0600" )
aadd( W_FILE , "SR0600" )
aadd( W_FILE , "SR0600" )
aadd( W_FILE , "SR0600" )
aadd( W_FILE , "SR0600" )

SR0600->(dbsetorder(3))
SR0600->(dbseek("R"))

// SR0600->( dbsetrelation( "VEN001", {|| SR0600->CODCLI }, "SR0600->CODCLI" ) )
SR0600->( dbsetrelation( "VEN001", {|| SR0600->CODCLI }, "SR0600->CODCLI" ) )

setcolor(W_COR_002)
Stedite700()

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

Sr0700_tot()

SR0600->(dbsetorder(3))
SR0600->(dbseek("R"))

CONTINUA := .T.

do while CONTINUA .and. ( (TEC:=tabmov(TABELA)) != K_ESC )

  W_TEL0700 := savescreen(,,,,)

   do case
      case TEC == 28 ; help("HELP008")
      case TEC == 27 ; return 0

      case TEC == K_ENTER  && Consulta
	  if SR0600->( ! eof() )
	     Seditae700()
	  end
	  restscreen(,,,,W_TEL0700)
	  keyboard chr(1)
	  Sr0700_tot()
	  SELECT SR0600
          SR0600->(dbsetorder(2))

      case TEC == K_F6   // BUSCA DIRETA
         if SR0600->( ! eof() )
            busca_Scheque("P")
	 end
         restscreen(,,,,W_TEL0700)
         select SR0600
         SR0600->( dbsetorder(2) )
         SR0600->( dbseek(S_DUPLICATA),.T. )
	 TABELA:refreshall()

      case TEC = K_ESC
	 CONTINUA := .F.

   end
   SELECT SR0600
   SR0600->(dbsetorder(3))

enddo

close data

return


************************************
function Seditae700()
************************************
setcursor(1)

Stelae700()

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

SR1000->(dbsetorder(2))
if SR1000->(dbseek("R"+S_DUPLICATA+S_SEQUE_CH ))
   @ 08,42 say SR1000->DT_VENC       picture "99/99/99"
   @ 08,62 say SR1000->VALOR         picture "@E 999,999,999.99"
end

@ 10,15 say S_DT_PREDATA       picture "99/99/99"
@ 10,42 say S_VALOR            picture "@E 999,999,999.99"

TES_codbanco(12,15)
TES_codagencia(13,15)
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

inkey(0)
// fim do say

SR0600->( dbunlock() )

setcursor(0)

return nil

/*
-------------------------------------------------------------------------------
Procedimento .: Stedite700
Objetivo .....: Menu rapido
-------------------------------------------------------------------------------
*/
procedure Stedite700()
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
procedure Stelae700()

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
   @ 12,02 say '³ Banco.....:                                                              ³'
   @ 13,02 say '³ Agˆncia...:                                                              ³'
   @ 14,02 say '³ Conta.....:                                                              ³'
   @ 15,02 say '³ Nro.Cheque:                                                              ³'
   @ 16,02 say '³ Cpf/cGc...:[ ]                                                           ³'
   @ 17,02 say '³                                                                          ³'
   @ 18,02 say '³ Dest/Nome.:                                                              ³'
   @ 19,02 say '³ Dest/Data.:                                                              ³'
   @ 20,02 say '³                                                                          ³'
   @ 21,02 say '³                                                                          ³'
   @ 22,02 say 'ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ'



/*
-------------------------------------------------------------------------------
		       CALCULA TOTAL DE CHEQUES PENDENTES
-------------------------------------------------------------------------------
*/
function Sr0700_tot()
   local WRET := 0, OLDREC := SR0600->( recno() )

   SR0600->( dbsetorder(3))
   SR0600->( dbseek("R") )

   while SR0600->( ! eof() )
      if SR0600->STATUS = "R"
	 WRET = WRET + SR0600->VALOR
      else
	 exit
      end
      SR0600->( dbskip() )
   end

   SR0600->( dbgoto( OLDREC ) )

   @ 20,02 say 'ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´'
   @ 21,02 say '³                                        Total............:                ³'
   @ 22,02 say 'ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ'
   @ 21,62 say WRET picture "@E 999,999,999.99"

return WRET


/*
-------------------------------------------------------------------------------
Procedimento .: busca_Scheque
Objetivo .....: BUSCA cheque por duplicata
-------------------------------------------------------------------------------
*/
procedure busca_Scheque()

setcursor(1)

@ 10,14 say 'ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿'
@ 11,14 say '³                                  ³'
@ 12,14 say '³ Duplicata...:                    ³'
@ 13,14 say '³                                  ³'
@ 14,14 say 'ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ'
sombra(10,14,14,49)

S_DUPLICATA  := space(05)
@ 12,31 get S_DUPLICATA  picture "@!"
read

S_DUPLICATA := zerofill( S_DUPLICATA)

SR0600->( dbsetorder(2) )

Set Softseek on

SR0600->( dbseek(S_DUPLICATA), .T. )

S_DUPLICATA  := SR1000->DUPLICATA

setcursor(0)

return
