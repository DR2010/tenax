/*
  +---------------------------------------------------------------------------+
  | >>>>>>>>>>>>>>>>>>>>>>    AD       Consultoria  <<<<<<<<<<<<<<<<<<<<<<<<< |
  |									      |
  | >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>  MENUGERA  <<<<<<<<<<<<<<<<<<<<<<<<<<<<<< |
  |									      |
  | Sistema:								      |
  |---------------------------------------------------------------------------|
  | Descricao..: Modulo principal de controle dos Menus.		      |
  |---------------------------------------------------------------------------|
  | Cliente....: TENAX ACO E FERRO	    | Ultima Alteracao		      |
  | Analista...:			    | Autor :			      |
  | Programador:			    | Dt/Hr :			      |
  | Inicio.....:			    | Motivo:			      |
  |					    |				      |
  +---------------------------------------------------------------------------+
*/
local getlist:={}
#include "inkey.ch"
#include "sic.ch"

public	C_USUARIO := space(8), C_ACESSO := "C", C_MODULO := "C"
public	W_PDCOR, W_CORGET, W_CORPERG, W_CORWIND, W_CORWG, PADRAO, W_DIR
public	P_LIN, P_COL, SCR_BASICO, POSICAO := 1
public	T_BIT := .F., T_LARG := .F.
public	SEGURANCA := ' '
public	USUARIO   := 'TENAX'
public	C_DIREITO := space(1)
public	C_ACESSO  := space(7)
public	C_SENHA   := space(7)
public	C_USU_NIVEL := 0
public	WRESP_IMP := space(1)
public	WIMP_ARQ  := space(12)

private W_MENU000:={}, W_OPCAO000
private W_MENU001:={}, W_MENU002:={}, W_MENU003:={}, W_MENU004:={},;
	W_MENU005:={}, W_ABAND:=.F.,  W_MSG:={},     W_ACESSO

set deleted on
set key -8 to S_MATERIAL


//  Variaveis a serem verificadas -----------------

i_comp2       := '2'
i_comp3       := '3'
i_comp4       := '4'
i_comp5       := '5'
i_descompacta := '0'

// ------------------------------------------------
// Testa padrao de cor
W_PDCOR     := "W/B   , B/W    ,B, N, N     "       // Cor padrao
W_CORSOMBRA := "N/BG  , B/W    ,B, N, N     "       // Cor da sombra
W_CORWIND   := "W/B   , W/R    ,B, N, W/GR  "       // Cor janela sem get's
W_CORGET    := "N/BG  , N/W    ,B, N, N/BG  "       // Cor gets com fundo basico
W_COREDIT   := "N/BG  , BG/RB+ ,B, N, N/BG  "       // Cor gets com fundo basico
W_CORWG     := "RB/W  , N/G    ,B, N, RB/W  "       // Cor window com gets
W_CORPERG   := "N/G   , B/G    ,B, N, W/B+  "       // Cor das perguntas
W_CORMENS   := "N/W   , GR+/G  ,B, N, W/B+  "       // Cor das perguntas
W_CORMENU   := "N/W   , W/B    ,B, N, W/N   "       // Cor dos Menus
W_CORSUBM   := "N/W   , W/B    ,B, N, W/N   "       // Cor dos sub-menus
W_BACKMENU  := "W/B   , B/W    ,B, N, W/N   "       // Cor do back menu
W_BOTOES    := "R/W   , G/N    ,B, N, W/N   "       // Cor de botoes
W_PUSHBOT   := "W/B   , G/N    ,B, N, W/N   "       // Cor do botao push
W_FIRSTLET  := "B+/W  , G/N    ,B, N, W/N   "       // Cor primeira letra
W_CORSHOW   := "B/BG  , G/N    ,B, N, W/N   "       // Cor de show
//		 |	 |	|      +--> get inativo
//		 |	 |	+---------> borda
//		 |	 +----------------> get ativo
//		 +------------------------> say

// Configuracao do diretorio de trabalho, atual
W_DIR := ""

// Mostra tela principal
setcolor( W_PDCOR )
cls
telamain()

// Define ambiente
set date british
set scoreboard off
set wrap on
set deleted on
set confirm on
set intensity on
set message to 24

// spv_dec() // verifica existencia dos dbfs

verindex() // verifica existencia dos indices

P_ACESSO := space(6)
P_SENHA  := space(6)

@ 10,10 clear to 14,10
@ 10,10 say 'ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿'
@ 11,10 say '³ Acesso :                     ³'
@ 12,10 say '³                              ³'
@ 13,10 say '³ Senha  :                     ³'
@ 14,10 say 'ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ'

WLIB := .F.
setcolor( W_PDCOR )
//
abrir("ESTUSUAR")
abrir("ESTDIREI")
abrir("ESTROTIN")

while .T.
   @ 11,21 get P_ACESSO picture '@!'
   read
   if lastkey()=K_ESC; exit; end

   P_SENHA := get_senha(6,13,21)

   P_ACESSO := upper( P_ACESSO )
   P_SENHA  := upper( P_SENHA )

   if lastkey()=K_ESC; quit; end
   USUARIO->( dbseek(P_ACESSO) )
   if USUARIO->( ! found())
      mensbeep( "Acesso nao encontrado !")
      loop
   else
      G_SENHA := descript(USUARIO->SENHA )
      if upper( G_SENHA ) = P_SENHA
	 C_ACESSO := upper( P_ACESSO )
	 C_SENHA  := encript( upper( P_SENHA ))
	 WLIB := .T.
	 exit
      else
	 mensbeep("Senha Invalida !")
      end
   end

end

if ! WLIB; quit; end

setcolor( W_PDCOR )
cls
telamain()

//


W_ABAND := .T.

// Paragrafo 1
// ----------------------------------------------------------------------
// Define menu principal

PRIVATE WOPC01,WOPC02,WOPC03,WOPC04,WOPC05,WOPC011,WOPC016

W_MENU000:={}
W_MENU100:={}
W_MENU110:={}
W_MENU160:={}
W_MENU200:={}
W_MENU210:={}
W_MENU260:={}
W_MENU270:={}
W_MENU300:={}
W_MENU400:={}
W_MENU500:={}

aadd( W_MENU000, ' Estoque ' )
aadd( W_MENU000, ' Vendas ' )
aadd( W_MENU000, ' Contas a Pagar ' )
aadd( W_MENU000, ' Contas a Receber ' )
aadd( W_MENU000, ' Utilitarios ' )

aadd( W_MSG, 'Manutencao do Estoque               <ENTER>-Acessa <ESC>-Retorna.')
aadd( W_MSG, 'Vendas                              <ENTER>-Acessa <ESC>-Retorna.')
aadd( W_MSG, 'Contas a Pagar                      <ENTER>-Acessa <ESC>-Retorna.')
aadd( W_MSG, 'Contas a Receber                    <ENTER>-Acessa <ESC>-Retorna.')
aadd( W_MSG, 'Utilitarios do sistema.             <ENTER>-Acessa <ESC>-Retorna.')

if( ACES_NIVEL('M1001'), aadd( W_MENU100, { '1 Cadastros >          ', 'm1001' } ),.F. )
if( ACES_NIVEL('EST16'), aadd( W_MENU100, { '2 Compras              ', 'est16' } ),.F. )
if( ACES_NIVEL('EST18'), aadd( W_MENU100, { '3 Movimentacao         ', 'est18' } ),.F. )
if( ACES_NIVEL('EST22'), aadd( W_MENU100, { '4 Detalhar Peca Curta  ', 'est22' } ),.F. )
if( ACES_NIVEL('EST23'), aadd( W_MENU100, { '5 Recebimento Material ', 'est23' } ),.F. )
if( ACES_NIVEL('M1006'), aadd( W_MENU100, { '6 Relatorios >         ', 'm1006' } ),.F. )

// Estoque - Cadastros

if( ACES_NIVEL('EST11' ), aadd( W_MENU110, { '1 Almoxarifado         ', 'est11' } ),.F. )
if( ACES_NIVEL('EST12' ), aadd( W_MENU110, { '2 Fornecedor           ', 'est12' } ),.F. )
if( ACES_NIVEL('EST13' ), aadd( W_MENU110, { '3 Forma de Material    ', 'est13' } ),.F. )
if( ACES_NIVEL('EST14' ), aadd( W_MENU110, { '4 Tipo de Material     ', 'est14' } ),.F. )
if( ACES_NIVEL('EST17' ), aadd( W_MENU110, { '5 Item de Estoque      ', 'est17' } ),.F. )
if( ACES_NIVEL('EST21' ), aadd( W_MENU110, { '6 Tipo de Movimentacao ', 'est21' } ),.F. )
if( ACES_NIVEL('VEN099'), aadd( W_MENU110, { '7 Parametros           ', 'ven099'} ),.F. )

// Estoque - Relatorios

if( ACES_NIVEL('REL001'), aadd( W_MENU160, { '1 Almoxarifado         ','rel001'} ),.F. )
if( ACES_NIVEL('REL002'), aadd( W_MENU160, { '2 Fornecedores         ','rel002'} ),.F. )
if( ACES_NIVEL('REL003'), aadd( W_MENU160, { '3 Forma do Material    ','rel003'} ),.F. )
if( ACES_NIVEL('REL004'), aadd( W_MENU160, { '4 Tipo de Material     ','rel004'} ),.F. )
if( ACES_NIVEL('REL005'), aadd( W_MENU160, { '5 Itens Estoque/Compra ','rel005'} ),.F. )
if( ACES_NIVEL('REL006'), aadd( W_MENU160, { '6 Saida de Materiais   ','rel006'} ),.F. )
if( ACES_NIVEL('REL007'), aadd( W_MENU160, { '7 Entrada de Materiais ','rel007'} ),.F. )
if( ACES_NIVEL('REL008'), aadd( W_MENU160, { '8 Itens de Lote        ','rel008'} ),.F. )
if( ACES_NIVEL('REL009'), aadd( W_MENU160, { '9 Estoque Abaixo Minimo','rel009'} ),.F. )
if( ACES_NIVEL('REL010'), aadd( W_MENU160, { '10 Conferencia Estoque ','rel010'} ),.F. )
if( ACES_NIVEL('REL011'), aadd( W_MENU160, { '11 Lotes Detalhe       ','rel011'} ),.F. )
if( ACES_NIVEL('REL015'), aadd( W_MENU160, { '15 Qtde. Comprada      ','rel015'} ),.F. )

// Vendas

if( ACES_NIVEL('M2001' ), aadd( W_MENU200, { '1 Cadastros       > ', 'm2001'  } ),.F. )
if( ACES_NIVEL('VEN021'), aadd( W_MENU200, { '2 Consulta          ', 'ven021' } ),.F. )
if( ACES_NIVEL('VEN032'), aadd( W_MENU200, { '3 Pedido            ', 'ven032' } ),.F. )
if( ACES_NIVEL('VEN034'), aadd( W_MENU200, { '4 Nota Fiscal       ', 'ven034' } ),.F. )
if( ACES_NIVEL('VEN035'), aadd( W_MENU200, { '5 Separacao         ', 'ven035' } ),.F. )
if( ACES_NIVEL('M2006' ), aadd( W_MENU200, { '6 Precos de Venda > ', 'm2006'  } ),.F. )
if( ACES_NIVEL('M2007' ), aadd( W_MENU200, { '7 Relatorios      > ', 'm2007'  } ),.F. )

// Vendas - Relatorios
if( ACES_NIVEL('EST99'), aadd( W_MENU270, { '1 Tabela de Precos    ','rel013'} ),.F. )

// Vendas - Cadastros

if( ACES_NIVEL('VEN011'), aadd( W_MENU210, { '1 Clientes            ', 'ven011' } ),.F.)
if( ACES_NIVEL('VEN012'), aadd( W_MENU210, { '2 Vendedores          ', 'ven012' } ),.F.)
if( ACES_NIVEL('VEN362'), aadd( W_MENU210, { '3 Comissao Vendedor   ', 'ven362' } ),.F.)
if( ACES_NIVEL('VEN363'), aadd( W_MENU210, { '4 Comissao Comprador  ', 'ven363' } ),.F.)
if( ACES_NIVEL('VEN364'), aadd( W_MENU210, { '5 Pagamento Vendedor  ', 'ven364' } ),.F.)
if( ACES_NIVEL('VEN365'), aadd( W_MENU210, { '6 Pagamento Comprador ', 'ven365' } ),.F.)
if( ACES_NIVEL('VEN366'), aadd( W_MENU210, { '7 Comissoes de Venda  ', 'ven366' } ),.F.)

// Vendas - Precos de Venda

if( ACES_NIVEL('VEN367'), aadd( W_MENU260, { '1 Grupos          ', 'ven367' } ),.F.)
if( ACES_NIVEL('VEN368'), aadd( W_MENU260, { '2 Sub Grupos      ', 'ven368' } ),.F.)
if( ACES_NIVEL('VEN369'), aadd( W_MENU260, { '3 Precos/Colunas  ', 'ven369' } ),.F.)
if( ACES_NIVEL('VEN370'), aadd( W_MENU260, { '4 Sub Fatores     ', 'ven370' } ),.F.)

if( ACES_NIVEL(''), aadd( W_MENU300, { ' XXXXXXXXXXXXXX ','' } ),.F. )

if( ACES_NIVEL('CRC100'), aadd( W_MENU400, { ' Cadastros     ','' } ),.F. )
if( ACES_NIVEL('CRC200'), aadd( W_MENU400, { ' Nota Fiscal   ','crc200' } ),.F. )
if( ACES_NIVEL('CRC300'), aadd( W_MENU400, { ' Relatorios    ','' } ),.F. )

if( ACES_NIVEL('EST81'), aadd( W_MENU500, { ' Usuarios     ','est81' } ),.F. )
if( ACES_NIVEL('EST82'), aadd( W_MENU500, { ' Direitos     ','est82' } ),.F. )
if( ACES_NIVEL('EST83'), aadd( W_MENU500, { ' Senhas       ','est83' } ),.F. )
if( ACES_NIVEL('AGE001'), aadd( W_MENU500, { ' Agenda       ','age001' } ),.F. )
if( ACES_NIVEL('EST999'), aadd( W_MENU500, { ' V.Relatorios ','rel999' } ),.F. )

setcolor( W_PDCOR )
cls

telamain()

dbcloseall()

// telaentr()
private WTL0000 := savescreen() ; WCOR0000 := setcolor()

keyboard chr(13)
while .T.
   setcolor( W_PDCOR )
   telamain()
   mensagem("Tecle <ENTER> e mova as setas.")
   setcolor(W_CORMENU)
   @ 04, 05 prompt W_MENU000[1]
   @ 04, 16 prompt W_MENU000[2]
   @ 04, 26 prompt W_MENU000[3]
   @ 04, 44 prompt W_MENU000[4]
   @ 04, 64 prompt W_MENU000[5]
   menu to WOPC0000

   if WOPC0000 > 0
       setcolor(W_PDCOR)
       mensagem(W_MSG[WOPC0000])
       setcolor(W_CORSUBM)
   end

   WOPC00 := '   '
   DO CASE
      CASE WOPC0000 = 1   // Estoque

	 while ! WOPC00 $ '000ESQDIR'
	    WOPC00 := menu( W_MENU100, 07, 03, 'ESTOQUE' )
	 end

      CASE WOPC0000 = 2  // Vendas

	 while ! WOPC00 $ '000ESQDIR'
	    WOPC00 := menu( W_MENU200, 07, 15, 'VENDAS' )
	 end

      CASE WOPC0000 = 3   // Contas a Pagar

	 while ! WOPC00 $ '000ESQDIR'
	    WOPC00 := menu( W_MENU300, 07, 25, 'CONTAS A PAGAR' )
	 end

      CASE WOPC0000 = 4   // Contas a receber

	 while ! WOPC00 $ '000ESQDIR'
	    WOPC00 := menu( W_MENU400, 07, 43, 'CONTAS A RECEBER' )
	 end

      CASE WOPC0000 = 5 // Utilitarios

	 while ! WOPC00 $ '000ESQDIR'
	    WOPC00 := menu( W_MENU500, 07, 58, 'UTILITARIOS' )
	 end

      CASE WOPC0000 = 0 // Saida
	 if pergunta("Confirma Saida do Sistema (S/N) ?")
	    exit
	 end

   ENDCASE

   do case
      case WOPC00 = "ESQ"
	 keyboard( chr( K_CTRL_S ) + chr( K_ENTER ) )
      case WOPC00 = "DIR"
	 keyboard( chr( K_CTRL_D ) + chr( K_ENTER ) )
   endcase

end

restscreen(,,,,WTL0000)
setcolor("W/N,N/W,N")
cls
return

/*
-------------------------------------------------------------------------------
Procedimento .: TELAMAIN
Objetivo .....: Montar a tela principal
-------------------------------------------------------------------------------
*/
procedure telamain()
   static SCR_MENU0

   setcolor(W_CORMENU)
   if SCR_MENU0 = NIL

      setcolor( W_PDCOR )
      @ 00,00 say '                        Sistema de Controle de Estoque                     >AD< '
      @ 01,00 say '                               TENAX ACO E FERRO                                '
      @ 02,00 say '                                                                                '
      @ 03,00 say '                                                                                '
      @ 04,00 say '                                                                                '
      @ 05,00 say '                                                                                '
      setcolor( W_CORMENU )
      @ 03,02 say 'ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿'
      @ 04,02 say '³   Estoque    Vendas    Contas a Pagar    Contas a Receber    Utilitarios ³'
      @ 05,02 say 'ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ'
      setcolor( W_PDCOR )
      @ 06,03 say '                                                                                '
      sombra(03,02,05,77)
      @ 07,00 say '                                                                                '
      @ 08,00 say '                                                                                '
      @ 09,00 say '                                                                                '
      @ 10,00 say '                                                                                '
      @ 11,00 say '                                                                                '
      @ 12,00 say '                                                                                '
      @ 13,00 say '                                                                                '
      @ 14,00 say '                                                                                '
      @ 15,00 say '                                                                                '
      @ 16,00 say '                                                                                '
      @ 17,00 say '                                                                                '
      @ 18,00 say '                                                                                '
      @ 19,00 say '                                                                                '
      @ 20,00 say '                                                                                '
      @ 21,00 say '                                                                                '
      @ 22,00 say '                                                                                '
      @ 23,00 say '   >                                                                            '
      logotipo()
      telanum('SCR000','EST000')

      SCR_MENU0 := savescreen(00,00,24,79)
   else
      restscreen( 00,00,24,79,SCR_MENU0)
   end
   setcolor( W_PDCOR )

return

/*
-------------------------------------------------------------------------------
Procedimento .:
Objetivo .....:
-------------------------------------------------------------------------------
*/
procedure M1001

while ! WOPC00 $ '000ESQDIR'
   WOPC00 := menu( W_MENU110, 09, 05, 'CADASTRO' )
end
return

/*
-------------------------------------------------------------------------------
Procedimento .:
Objetivo .....:
-------------------------------------------------------------------------------
*/
procedure M1006

while ! WOPC00 $ '000ESQDIR'
   WOPC00 := menu( W_MENU160, 10, 05, 'RELATORIO' )
end

return

/*
-------------------------------------------------------------------------------
Procedimento .:
Objetivo .....:
-------------------------------------------------------------------------------
*/
procedure M2001

while ! WOPC00 $ '000ESQDIR'
   WOPC00 := menu( W_MENU210, 09, 17, 'CADASTRO' )
end

return

/*
-------------------------------------------------------------------------------
Procedimento .:
Objetivo .....:
-------------------------------------------------------------------------------
*/
function M2006

while ! WOPC00 $ '000ESQDIR'
   WOPC00 := menu( W_MENU260, 10, 17, 'PRECO DE VENDA' )
end
return

/*
-------------------------------------------------------------------------------
Procedimento .:
Objetivo .....:
-------------------------------------------------------------------------------
*/
function M2007

while ! WOPC00 $ '000ESQDIR'
   WOPC00 := menu( W_MENU270, 11, 17, 'RELATORIOS' )
end
return

/*
-------------------------------------------------------------------------------
Procedimento .:
Objetivo .....:
-------------------------------------------------------------------------------
*/
function TELANUM(TELANUM, PROGNOME)
local POLDCOR := setcolor()

setcolor( W_PDCOR )
@ 00,01 say TELANUM
@ 01,01 say PROGNOME
setcolor( POLDCOR)
return

/*
-----------------------------------------------------------------------------
Procedimento : VERREPO
Objetivo     : Consultar relatorio
-----------------------------------------------------------------------------
*/
procedure VERREPO( P_QUAL )
local ANTES := savescreen(,,,,)  ,;
      vet_tudo[adir("*.prn")]    ,;
      vet_size[adir("*.prn")]    ,;
      wnum

adir("*.PRN",vet_tudo,vet_size)

if P_QUAL = NIL
   @ 10,10 clear to 20,40
   @ 10,10 to 20,40
   wnum := achoice(11,11,19,39,vet_tudo )

   if wnum > 0
      ARQ := VET_TUDO[ WNUM ]
      if VET_SIZE[ WNUM ] < 65530
	 LARQ := memoread( ARQ )
	 ARQ := memoread( P_QUAL )
	 memoedit( LARQ, 0, 0, 24, 79, .F.,, 132 )
      else
	 mensbeep("Arquivo muito grande para memoria. <ENTER>")
      end
   end
else

   P_QUAL := alltrim( P_QUAL )
   WR := ascan( VET_TUDO, P_QUAL )
   if WR > 0
      if VET_SIZE[ WR ] < 65530
	 LARQ := memoread( P_QUAL )
	 memoedit( LARQ, 0, 0, 24, 79, .F.,, 132 )
      else
	 mensbeep("Arquivo muito grande para memoria. <ENTER>")
	 WEXEC := 'Q '+P_QUAL
	 ! &WEXEC
      end
   end

end

restscreen(,,,,ANTES)

return

/*
-------------------------------------------------------------------------------
Procedimento .:
Objetivo .....:
-------------------------------------------------------------------------------
*/
procedure LOGOTIPO

@ 08,04 say '±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±'
@ 09,04 say '±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±'
@ 10,04 say '±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±'
@ 11,04 say '±±          ±±±±±        ±±±±±  ±±±±  ±±±±±         ±±±±  ±±±±±±  ±±±±±±±'
@ 12,04 say '±± ±±±  ±±± ±±±±±  ±±±±± ±±±±±  ±±±±  ±±±±±  ±±±±±± ±±±±±  ±±±±  ±±±±±±±±'
@ 13,04 say '±±±±±±  ±±±±±±±±±  ±±±±±±±±±±±   ±±±  ±±±±±  ±±±±±± ±±±±±±  ±±  ±±±±±±±±±'
@ 14,04 say '±±±±±±  ±±±±±±±±±  ±±±±±±±±±±±    ±±  ±±±±±  ±±±±±± ±±±±±±±    ±±±±±±±±±±'
@ 15,04 say '±±±±±±  ±±±±±±±±±     ±±±±±±±±  ±  ±  ±±±±±         ±±±±±±±±  ±±±±±±±±±±±'
@ 16,04 say '±±±±±±  ±±±±±±±±±  ±±±±±±±±±±±  ±±    ±±±±±  ±±±±±± ±±±±±±±    ±±±±±±±±±±'
@ 17,04 say '±±±±±±  ±±±±±±±±±  ±±±±±±±±±±±  ±±±   ±±±±±  ±±±±±± ±±±±±±  ±±  ±±±±±±±±±'
@ 18,04 say '±±±±±±  ±±±±±±±±±  ±±±±± ±±±±±  ±±±±  ±±±±±  ±±±±±± ±±±±±  ±±±±  ±±±±±±±±'
@ 19,04 say '±±±±±±  ±±±±±±±±±        ±±±±±  ±±±±  ±±±±±  ±±±±±± ±±±±  ±±±±±±  ±±±±±±±'
@ 20,04 say '±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±'
@ 21,04 say '±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±'
@ 22,04 say '±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±'

return
