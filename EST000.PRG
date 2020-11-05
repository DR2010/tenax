/*
  +---------------------------------------------------------------------------+
  | >>>>>>>>>>>>>>>>>>>>>>    AD       Consultoria  <<<<<<<<<<<<<<<<<<<<<<<<< |
  |									      |
  | >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>  EST000    <<<<<<<<<<<<<<<<<<<<<<<<<<<<<< |
  |									      |
  | Sistema: TENAX - Sistema de Controle de Estoque			      |
  |---------------------------------------------------------------------------|
  | Descricao..: Modulo principal de controle dos Menus.		      |
  |---------------------------------------------------------------------------|
  | Cliente....: TENAX ACO E FERRO	    | Ultima Alteracao		      |
  | Analista...: Alberto Mello/ Daniel	    | Autor :			      |
  | Programador: Alberto/ Daniel	    | Dt/Hr :			      |
  | Inicio.....:			    | Motivo:			      |
  |					    |				      |
  +---------------------------------------------------------------------------+
*/
local getlist:={}
#include "inkey.ch"
#include "sic.ch"

public	USUARIO := space(8), C_ACESSO := "C", C_MODULO := "C"
public	W_PDCOR,W_CORGET, W_CORPERG, W_CORWIND, W_CORWG,W_CORWD, PADRAO, W_DIR
public	P_LIN, P_COL, SCR_BASICO, POSICAO := 1
public	T_BIT				  := .F., T_LARG := .F.
public	SEGURANCA			  := ' '
public	USUARIO 			  := 'TENAX'
public	C_DIREITO			  := space(1)
public	C_ACESSO			  := space(7)
public	C_SENHA 			  := space(7)
public	C_USU_NIVEL			  := 0
public	WRESP_IMP			  := space(1)
public	WIMP_ARQ			  := space(12)
public	f_separa    := .f.
private W_MENU000:={}, W_OPCAO000
private W_MENU001:={}, W_MENU002:={}, W_MENU003:={}, W_MENU004:={},;
	W_MENU005:={}, W_ABAND:=.F.,  W_MSG:={},     W_ACESSO

set deleted on
set key -8 to S_MATERIAL

//
// Testa padrao de cor
//

C_MONITOR := getenv( "ADMONO" )

C_VERSAO  := getenv( "VERSAO" )

if C_VERSAO = NIL
   C_VERSAO := 'TENAX'
end

if asc( C_MONITOR ) = 0

   W_PDCOR     := "W/B   , B/W    ,B, N, N     "       // Cor padrao
   W_CORSOMBRA := "N/BG  , B/W    ,B, N, N     "       // Cor da sombra
   W_CORWIND   := "W/B   , W/R    ,B, N, W/GR  "       // Cor janela sem get's
   W_CORGET    := "N/BG  , N/W    ,B, N, N/BG  "       // Cor gets com fundo basico
   W_COREDIT   := "N/BG  , BG/RB+ ,B, N, N/BG  "       // Cor gets com fundo basico
   W_CORWG     := "RB/W  , N/G    ,B, N, RB/W  "       // Cor window com gets
   W_CORWD     := "N/W   , W+/B   ,B, N, N/W  "        // Cor window com gets
   W_CORPERG   := "N/G   , B/G    ,B, N, W/B+  "       // Cor das perguntas
   W_CORMENS   := "N/W   , GR+/G  ,B, N, W/B+  "       // Cor das perguntas
   W_CORMENU   := "N/W   , W/B    ,B, N, W/N   "       // Cor dos Menus
   W_CORSUBM   := "N/W   , W/B    ,B, N, W/N   "       // Cor dos sub-menus
   W_CORSUB01  := "N/G   , BG/RB+ ,B, N, W/N   "       // Cor dos sub-menus C/R
   W_CORSUB02  := "N/RB  , BG/RB+ ,B, N, N/BG "     // Cor dos sub-menus Controle Gerencial   W_BACKMENU  := "W/B   , B/W    ,B, N, W/N   "       // Cor do back menu
   W_BOTOES    := "R/W   , G/N    ,B, N, W/N   "       // Cor de botoes
   W_PUSHBOT   := "W/B   , G/N    ,B, N, W/N   "       // Cor do botao push
   W_FIRSTLET  := "B+/W  , G/N    ,B, N, W/N   "       // Cor primeira letra
   W_CORSHOW   := "B/BG  , G/N    ,B, N, W/N   "       // Cor de show

   W_COR_001   := "N/BG  , BG/RB+ ,B, N, N/BG  "       // Contas a Receber
   W_COR_002   := "N/G   , BG/RB+ ,B, N, N/BG  "       // Contra Retirada
   W_COR_003   := "N/RB  , B/W    ,B, N, N/BG "    //
   //		    |	    |	   |	  +--> get inativo
   //		    |	    |	   +---------> borda
   //		    |	    +----------------> get ativo
   //		    +------------------------> say

else
   W_PDCOR     := "  "       // Cor padrao
   W_CORSOMBRA := "  "       // Cor da sombra
   W_CORWIND   := "  "       // Cor janela sem get's
   W_CORGET    := "  "       // Cor gets com fundo basico
   W_COREDIT   := "  "       // Cor gets com fundo basico
   W_CORWG     := "  "       // Cor window com gets
   W_CORPERG   := "  "       // Cor das perguntas
   W_CORMENS   := "  "       // Cor das perguntas
   W_CORMENU   := "  "       // Cor dos Menus
   W_CORSUBM   := "  "       // Cor dos sub-menus
   W_CORSUB01  := "  "       // Cor dos sub-menus C/R
   W_CORSUB02  := "  "       // Cor dos sub-menus Controle gerencial
   W_BACKMENU  := "  "       // Cor do back menu
   W_BOTOES    := "  "       // Cor de botoes
   W_PUSHBOT   := "  "       // Cor do botao push
   W_FIRSTLET  := "  "       // Cor primeira letra
   W_CORSHOW   := "  "       // Cor de show
   W_COR_001   := "  "       // Contas a Receber
   W_COR_002   := "  "       // Contra Retirada
   W_COR_003   := "  "       //

   //		    |	    |	   |	  +--> get inativo
   //		    |	    |	   +---------> borda
   //		    |	    +----------------> get ativo
   //		    +------------------------> say
end


// Rotina de erro

// errorblock( { |varerro| blocodeerro(varerro) } )

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

verindex() // verifica existencia dos indices
mensagem('')

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
  abrir("USUARIO")
  abrir("ROTINA")
  abrir("DIREITO")

while .T.

   setcursor(1)
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
W_MENU310:={}
W_MENU320:={}
W_MENU330:={}
W_MENU340:={}
W_MENU400:={}
W_MENU410:={}
W_MENU420:={}
W_MENU430:={}
W_MENU440:={}
W_MENU500:={}
W_MENU600:={}
W_MENU610:={}
W_MENU620:={}
W_MENU630:={}
W_MENU640:={}
W_MENU650:={}
W_MENU660:={}
W_MENU670:={}
W_MENU680:={}
W_MENU690:={}


aadd( W_MENU000, ' Estoque ' )
aadd( W_MENU000, ' Vendas ' )
aadd( W_MENU000, ' Contas a Pagar ' )
aadd( W_MENU000, ' Contas a Receber ' )
aadd( W_MENU000, ' Utilit rios ' )

aadd( W_MSG, 'Manuten‡„o do Estoque               <ENTER>-Acessa <ESC>-Retorna.')
aadd( W_MSG, 'Vendas                              <ENTER>-Acessa <ESC>-Retorna.')
aadd( W_MSG, 'Contas a Pagar                      <ENTER>-Acessa <ESC>-Retorna.')
aadd( W_MSG, 'Contas a Receber                    <ENTER>-Acessa <ESC>-Retorna.')
aadd( W_MSG, 'Utilit rios do sistema.             <ENTER>-Acessa <ESC>-Retorna.')

//******************************* Estoque **************************************
//******************************************************************************


// Estoque - Menu Principal

if( ACES_NIVEL('M1001'), aadd( W_MENU100, { '1 Cadastros >          ', 'M1001' } ),.F. )
if( ACES_NIVEL('EST16'), aadd( W_MENU100, { '2 Compras              ', 'EST16' } ),.F. )
if( ACES_NIVEL('EST18'), aadd( W_MENU100, { '3 Movimenta‡„o         ', 'EST18' } ),.F. )
if( ACES_NIVEL('EST22'), aadd( W_MENU100, { '4 Detalhar Peca Curta  ', 'EST22' } ),.F. )
if( ACES_NIVEL('EST40'), aadd( W_MENU100, { '5 Detalhar Caixote     ', 'EST40' } ),.F. )
if( ACES_NIVEL('EST23'), aadd( W_MENU100, { '6 Recebimento Material ', 'EST23' } ),.F. )
if( ACES_NIVEL('M1006'), aadd( W_MENU100, { '7 Relat¢rios >         ', 'M1006' } ),.F. )

// Estoque - Cadastros

if( ACES_NIVEL('EST11' ), aadd( W_MENU110, { ' 1 Almoxarifado         ', 'EST11' } ),.F. )
if( ACES_NIVEL('EST12' ), aadd( W_MENU110, { ' 2 Fornecedor           ', 'EST12' } ),.F. )
if( ACES_NIVEL('EST13' ), aadd( W_MENU110, { ' 3 Forma de Material    ', 'EST13' } ),.F. )
if( ACES_NIVEL('EST14' ), aadd( W_MENU110, { ' 4 Tipo de Material     ', 'EST14' } ),.F. )
if( ACES_NIVEL('EST17' ), aadd( W_MENU110, { ' 5 Item de Estoque      ', 'EST17' } ),.F. )
if( ACES_NIVEL('EST21' ), aadd( W_MENU110, { ' 6 Tipo de Movimenta‡„o ', 'EST21' } ),.F. )
if( ACES_NIVEL('EST35' ), aadd( W_MENU110, { ' 7 Tabela Peri¢dica     ', 'EST35' } ),.F. )
if( ACES_NIVEL('EST36' ), aadd( W_MENU110, { ' 8 Composi‡„o do Tipo   ', 'EST36' } ),.F. )
if( ACES_NIVEL('ESTM05'), aadd( W_MENU110, { ' 9 Arq.Morto - Pedidos  ', 'ESTM05'} ),.F. )
if( ACES_NIVEL('VEN099'), aadd( W_MENU110, { '10 Parƒmetros           ', 'VEN099'} ),.F. )

// Estoque - Relatorios

if( ACES_NIVEL('REL001'), aadd( W_MENU160, { ' 1 Almoxarifado         ','REL001'} ),.F. )
if( ACES_NIVEL('REL002'), aadd( W_MENU160, { ' 2 Fornecedores         ','REL002'} ),.F. )
if( ACES_NIVEL('REL003'), aadd( W_MENU160, { ' 3 Forma do Material    ','REL003'} ),.F. )
if( ACES_NIVEL('REL004'), aadd( W_MENU160, { ' 4 Tipo de Material     ','REL004'} ),.F. )
if( ACES_NIVEL('REL005'), aadd( W_MENU160, { ' 5 Itens Estoque/Compra ','REL005'} ),.F. )
if( ACES_NIVEL('REL006'), aadd( W_MENU160, { ' 6 Sa¡da de Materiais   ','REL006'} ),.F. )
if( ACES_NIVEL('REL007'), aadd( W_MENU160, { ' 7 Entrada de Materiais ','REL007'} ),.F. )
if( ACES_NIVEL('REL008'), aadd( W_MENU160, { ' 8 Itens de Lote        ','REL008'} ),.F. )
if( ACES_NIVEL('REL009'), aadd( W_MENU160, { ' 9 Estoque Abaixo M¡nimo','REL009'} ),.F. )
if( ACES_NIVEL('REL010'), aadd( W_MENU160, { '10 Conferˆncia Estoque  ','REL010'} ),.F. )
if( ACES_NIVEL('REL011'), aadd( W_MENU160, { '11 Lotes Detalhe        ','REL011'} ),.F. )
if( ACES_NIVEL('REL015'), aadd( W_MENU160, { '12 Qtde. Comprada       ','REL015'} ),.F. )
if( ACES_NIVEL('REL016'), aadd( W_MENU160, { '13 Qtde.min. G/SG/COL/SF','REL016'} ),.F. )
if( ACES_NIVEL('REL040'), aadd( W_MENU160, { '14 Lote / Resumo        ','REL040'} ),.F. )
if( ACES_NIVEL('REL006'), aadd( W_MENU160, { '15 Sa¡da de Materiais A ','REL042'} ),.F. )



//******************************* Vendas ***************************************
//******************************************************************************

// Vendas

if( ACES_NIVEL('M2001'  ), aadd( W_MENU200, { '1 Cadastros       > ', 'M2001'  } ),.F. )
if( ACES_NIVEL('VEN021' ), aadd( W_MENU200, { '2 Consulta          ', 'VEN021' } ),.F. )
if( ACES_NIVEL('VEN0321'), aadd( W_MENU200, { '3 Manuten. pedido   ', 'VEN0321'} ),.F. )
// if( ACES_NIVEL('VEN035' ), aadd( W_MENU200, { '4 Separacao         ', 'VEN035'  } ),.F. )
if( ACES_NIVEL('VEN034' ), aadd( W_MENU200, { '5 Nota Fiscal       ', 'VEN034' } ),.F. )
if( ACES_NIVEL('VEN016' ), aadd( W_MENU200, { '6 Retorna Separacao ', 'VEN016' } ),.F. )
if( ACES_NIVEL('M2006'  ), aadd( W_MENU200, { '7 Pre‡os de Venda > ', 'M2006'  } ),.F. )
if( ACES_NIVEL('M2007'  ), aadd( W_MENU200, { '8 Relat¢rios      > ', 'M2007'  } ),.F. )

// Vendas - Relatorios

if( ACES_NIVEL('VEN100'), aadd( W_MENU270, { '1 Clientes/endereco    ','VEN100'} ),.F. )
if( ACES_NIVEL('VEN110'), aadd( W_MENU270, { '2 Clientes/razao       ','VEN110'} ),.F. )
if( ACES_NIVEL('EST99') , aadd( W_MENU270, { '3 Tabela de Pre‡os     ','REL013'} ),.F. )
if( ACES_NIVEL('REL037'), aadd( W_MENU270, { '4 Areas                ','REL037'} ),.F. )
if( ACES_NIVEL('REL038'), aadd( W_MENU270, { '5 Clientes p/Vendedor  ','REL038'} ),.F. )
if( ACES_NIVEL('REL0381'), aadd( W_MENU270,{ '6 Clientes p/Tipo      ','REL0381'} ),.F. )

// Vendas - Cadastros

if( ACES_NIVEL('VEN011'), aadd( W_MENU210, { '1 Clientes            ', 'VEN011' } ),.F.)
if( ACES_NIVEL('VEN012'), aadd( W_MENU210, { '2 Vendedores          ', 'VEN012' } ),.F.)
if( ACES_NIVEL('VEN362'), aadd( W_MENU210, { '3 Comiss„o Vendedor   ', 'VEN362' } ),.F.)
if( ACES_NIVEL('VEN363'), aadd( W_MENU210, { '4 Comiss„o Comprador  ', 'VEN363' } ),.F.)
if( ACES_NIVEL('VEN364'), aadd( W_MENU210, { '5 Pagamento Vendedor  ', 'VEN364' } ),.F.)
if( ACES_NIVEL('VEN365'), aadd( W_MENU210, { '6 Pagamento Comprador ', 'VEN365' } ),.F.)
if( ACES_NIVEL('VEN366'), aadd( W_MENU210, { '7 Comissoes de Venda  ', 'VEN366' } ),.F.)
if( ACES_NIVEL('EST037'), aadd( W_MENU210, { '8 Areas               ', 'EST037' } ),.F.)
if( ACES_NIVEL('VEN372'), aadd( W_MENU210, { '9 Emite Fax           ', 'VEN372' } ),.F.)
if( ACES_NIVEL('VEN024'), aadd( W_MENU210, { '10 Cadastra Frete     ', 'VEN024' } ),.F.)
if( ACES_NIVEL('BAC999'), aadd( W_MENU210, { '11 Alteracao Cliente  ', 'BAC999' } ),.F.)

// Vendas - Precos de Venda

if( ACES_NIVEL('VEN367'), aadd( W_MENU260, { '1 Grupos          ', 'VEN367' } ),.F.)
if( ACES_NIVEL('VEN368'), aadd( W_MENU260, { '2 Sub Grupos      ', 'VEN368' } ),.F.)
if( ACES_NIVEL('VEN369'), aadd( W_MENU260, { '3 Pre‡os/Colunas  ', 'VEN369' } ),.F.)
if( ACES_NIVEL('VEN370'), aadd( W_MENU260, { '4 Sub Fatores     ', 'VEN370' } ),.F.)

//******************* Contas a Receber / Contas Receber     ********************
//******************************************************************************


// Contas a Receber - MENU PRINCIPAL

if( ACES_NIVEL('aRM6500'), aadd( W_MENU400, {'   CONTRA RETIRADA      ','SRM6500'} ),.F. )
if( ACES_NIVEL('aRM1000'), aadd( W_MENU400, {'   CONTROLE GERENCIAL   ','ERM1000'} ),.F. )
if( ACES_NIVEL('aRM6000'), aadd( W_MENU400, {' 1 Cadastros   >        ','CRM6000'} ),.F. )
if( ACES_NIVEL('aR1000') , aadd( W_MENU400, {' 2 Nota Fiscal          ','CR1000' } ),.F. )
if( ACES_NIVEL('aR1500'),  aadd( W_MENU400, {' 3 NF Canceladas        ','CR1500' } ),.F. )
if( ACES_NIVEL('aRM6100'), aadd( W_MENU400, {' 4 Lan‡amentos >        ','CRM6100'} ),.F. )
if( ACES_NIVEL('aRM6200'), aadd( W_MENU400, {' 5 Consultas   >        ','CRM6200'} ),.F. )
if( ACES_NIVEL('aRM6300'), aadd( W_MENU400, {' 6 Relat¢rios  >        ','CRM6300'} ),.F. )

// Contas a Receber - CADASTROS

if( ACES_NIVEL('aR0100'),   aadd( W_MENU410, {' 1 Bancos               ','CR0100' } ),.F. )
if( ACES_NIVEL('aR0200'),   aadd( W_MENU410, {' 2 Agˆncias             ','CR0200' } ),.F. )
if( ACES_NIVEL('aR0300'),   aadd( W_MENU410, {' 3 Tipo de Venda        ','CR0300' } ),.F. )
if( ACES_NIVEL('aR0400'),   aadd( W_MENU410, {' 4 Forma de Pagamento   ','CR0400' } ),.F. )
if( ACES_NIVEL('aR0500'),   aadd( W_MENU410, {' 5 Vencimentos          ','CR0500' } ),.F. )
if( ACES_NIVEL('aR9991'),   aadd( W_MENU410, {' 6 Parƒmetros           ','CR9991' } ),.F. )

// Contas a Receber - lancamentos

if( ACES_NIVEL('aR0600'), aadd( W_MENU420, {' 1 Cheques Pendentes       ','CR0600' } ),.F. )
if( ACES_NIVEL('aR1100'), aadd( W_MENU420, {' 2 Baixa de Duplicata      ','CR1100' } ),.F. )
if( ACES_NIVEL('aR1101'), aadd( W_MENU420, {' 3 Alteracao de Duplicata  ','CR1101' } ),.F. )

// Contas a Receber - Consultas

if( ACES_NIVEL('aR1200'), aadd( W_MENU430, {' 1 Duplicatas Pendentes    ','CR1200' } ),.F. )
if( ACES_NIVEL('aR1300'), aadd( W_MENU430, {' 2 Duplicatas Recebidas    ','CR1300' } ),.F. )
if( ACES_NIVEL('aR1400'), aadd( W_MENU430, {' 3 Extrato de Cliente      ','CR1400' } ),.F. )

// Contas a Receber - Relatorios

if( ACES_NIVEL('aRR1000'), aadd( W_MENU440, {' 1 Duplicatas Pendentes    ','CRR1000' } ),.F. )
if( ACES_NIVEL('aRR1100'), aadd( W_MENU440, {' 2 Duplicatas Recebidas    ','CRR1100' } ),.F. )
if( ACES_NIVEL('aRR1200'), aadd( W_MENU440, {' 3 Cheques Pendentes       ','CRR1200' } ),.F. )
if( ACES_NIVEL('aRR1300'), aadd( W_MENU440, {' 4 Cheques Recebidos       ','CRR1300' } ),.F. )
if( ACES_NIVEL('aRR1400'), aadd( W_MENU440, {' 5 Boleta Banc ria         ','CRR1400' } ),.F. )
if( ACES_NIVEL('aRR1500'), aadd( W_MENU440, {' 6 Nota Fiscal             ','CRR1500' } ),.F. )
if( ACES_NIVEL('aRR1700'), aadd( W_MENU440, {' 7 Rel.extr. cliente       ','CRR1700' } ),.F. )


//******************* Contas a Receber / Contra Retirada    ********************
//******************************************************************************

// Contas a Receber / CONTRA RETIRADA - MENU PRINCIPAL

if( ACES_NIVEL('aRM6000'), aadd( W_MENU600, {' 1 Cadastros   >        ','SRM6000'} ),.F. )
if( ACES_NIVEL('aR1000') , aadd( W_MENU600, {' 2 Pedido               ','SR1000' } ),.F. )
if( ACES_NIVEL('aR1500'),  aadd( W_MENU600, {' 3 Pedidos Cancelados   ','SR1500' } ),.F. )
if( ACES_NIVEL('aRM6100'), aadd( W_MENU600, {' 4 Lan‡amentos >        ','SRM6100'} ),.F. )
if( ACES_NIVEL('aRM6200'), aadd( W_MENU600, {' 5 Consultas   >        ','SRM6200'} ),.F. )
if( ACES_NIVEL('aRM6300'), aadd( W_MENU600, {' 6 Relat¢rios  >        ','SRM6300'} ),.F. )
if( ACES_NIVEL('aAZIO'),   aadd( W_MENU600, {'                        ','TESTE'} ),.F. )

// Contas a Receber / CONTRA RETIRADA  - CADASTROS

if( ACES_NIVEL('aR0300'),   aadd( W_MENU610, {' 1 Tipo de Venda     C/R','SR0300' } ),.F. )
if( ACES_NIVEL('aR0400'),   aadd( W_MENU610, {' 2 Forma de Pagamento CR','SR0400' } ),.F. )
if( ACES_NIVEL('aR0500'),   aadd( W_MENU610, {' 3 Vencimentos       C/R','SR0500' } ),.F. )
if( ACES_NIVEL('aR9991'),   aadd( W_MENU610, {' 4 Parƒmetros        C/R','SR9991' } ),.F. )

// Contas a Receber / CONTRA RETIRADA - lancamentos

if( ACES_NIVEL('aR0600'), aadd( W_MENU620, {' 1 Cheques Pendentes      C/R','SR0600' } ),.F. )
if( ACES_NIVEL('aR1100'), aadd( W_MENU620, {' 2 Baixa de Duplicata     C/R','SR1100' } ),.F. )
if( ACES_NIVEL('aR1101'), aadd( W_MENU620, {' 3 Alteracao de Duplicata C/R','SR1101' } ),.F. )

// Contas a Receber / CONTRA RETIRADA - Consultas

if( ACES_NIVEL('aR1200'), aadd( W_MENU630, {' 1 Duplicatas Pendentes C/R','SR1200' } ),.F. )
if( ACES_NIVEL('aR1300'), aadd( W_MENU630, {' 2 Duplicatas Recebidas C/R','SR1300' } ),.F. )
if( ACES_NIVEL('aR1400'), aadd( W_MENU630, {' 3 Extrato de Cliente   C/R','SR1400' } ),.F. )
if( ACES_NIVEL('aR0700'), aadd( W_MENU630, {' 4 Cheques pagos        C/R','SR0700' } ),.F. )

// Contas a Receber / CONTRA RETIRADA - Relatorios

if( ACES_NIVEL('aRR1000'), aadd( W_MENU640, {' 1 Duplicatas Pendentes C/R','SRR1000' } ),.F. )
if( ACES_NIVEL('aRR1100'), aadd( W_MENU640, {' 2 Duplicatas Recebidas C/R','SRR1100' } ),.F. )
if( ACES_NIVEL('aRR1200'), aadd( W_MENU640, {' 3 Cheques Pendentes    C/R','SRR1200' } ),.F. )
if( ACES_NIVEL('aRR1300'), aadd( W_MENU640, {' 4 Cheques Recebidos    C/R','SRR1300' } ),.F. )
if( ACES_NIVEL('aRR1700'), aadd( W_MENU640, {' 5 Cheques Detalhados   C/R','SRR1700' } ),.F. )
if( ACES_NIVEL('aRR1500'), aadd( W_MENU640, {' 6 Pedido               C/R','SRR1500' } ),.F. )


//******************* Contas a Receber / Controle Gerencial ********************
//******************************************************************************

// Controle Gerencial - Menu Principal


if( ACES_NIVEL('aRM1100'), aadd( W_MENU650, {' 1 Cadastros             ','ERM1100' } ),.F. )
if( ACES_NIVEL('aR0900') , aadd( W_MENU650, {' 2 Nota Fiscal- Geracao  ','ER0900'  } ),.F. )
if( ACES_NIVEL('aR1000') , aadd( W_MENU650, {' 3 Nota Fiscal           ','ER1000'  } ),.F. )
if( ACES_NIVEL('aR1500') , aadd( W_MENU650, {' 4 Nota Fiscal Cancelada ','ER1500'  } ),.F. )
if( ACES_NIVEL('aRM1200'), aadd( W_MENU650, {' 5 Lancamentos           ','ERM1200' } ),.F. )
if( ACES_NIVEL('aRM1300'), aadd( W_MENU650, {' 6 Consultas             ','ERM1300' } ),.F. )
if( ACES_NIVEL('aRM1400'), aadd( W_MENU650, {' 7 Relatorios            ','ERM1400' } ),.F. )

// Controle Gerencial - Cadastros

if( ACES_NIVEL('aR0100'),   aadd( W_MENU660, {' 1 Bancos               ','CR0100' } ),.F. )
if( ACES_NIVEL('aR0200'),   aadd( W_MENU660, {' 2 Agˆncias             ','CR0200' } ),.F. )
if( ACES_NIVEL('aR0300'),   aadd( W_MENU660, {' 3 Tipo de Venda        ','CR0300' } ),.F. )
if( ACES_NIVEL('aR0400'),   aadd( W_MENU660, {' 4 Forma de Pagamento   ','CR0400' } ),.F. )
if( ACES_NIVEL('aR0500'),   aadd( W_MENU660, {' 5 Vencimentos          ','CR0500' } ),.F. )
if( ACES_NIVEL('aR9991'),   aadd( W_MENU660, {' 6 Parƒmetros           ','CR9991' } ),.F. )

// Controle Gerencial - Lancamentos

if( ACES_NIVEL('aR0600'),  aadd( W_MENU670, {' 1 Cheques Pendentes      ','ER0600' } ),.F. )
if( ACES_NIVEL('aR1100'),  aadd( W_MENU670, {' 2 Baixa de Duplicata     ','ER1100' } ),.F. )
if( ACES_NIVEL('aR1101'),  aadd( W_MENU670, {' 3 Alteracao de Duplicata ','ER1101' } ),.F. )

// Controle Gerencial - Consultas

if( ACES_NIVEL('aR1200'), aadd( W_MENU680, {' 1 Duplicatas Pendentes    ','ER1200' } ),.F. )
if( ACES_NIVEL('aR1300'), aadd( W_MENU680, {' 2 Duplicatas Recebidas    ','ER1300' } ),.F. )
if( ACES_NIVEL('aR1400'), aadd( W_MENU680, {' 3 Extrato de Cliente      ','ER1400' } ),.F. )

// Contas a Receber / Contole Gerencial - Relatorios

if( ACES_NIVEL('aRR1000'), aadd( W_MENU690, {' 1 Duplicatas Pendentes ','ERR1000' } ),.F. )
if( ACES_NIVEL('aRR1100'), aadd( W_MENU690, {' 2 Duplicatas Recebidas ','ERR1100' } ),.F. )
if( ACES_NIVEL('aRR1200'), aadd( W_MENU690, {' 3 Cheques Pendentes    ','ERR1200' } ),.F. )
if( ACES_NIVEL('aRR1300'), aadd( W_MENU690, {' 4 Cheques Recebidos    ','ERR1300' } ),.F. )
if( ACES_NIVEL('aRR1700'), aadd( W_MENU690, {' 5 Cheques Detalhados   ','ERR1700' } ),.F. )
if( ACES_NIVEL('aRR1500'), aadd( W_MENU690, {' 6 Nota Fiscal Controle ','ERR1500' } ),.F. )

//******************************* Contas a Pagar *******************************
//******************************************************************************


// Contas a Pagar


// if( ACES_NIVEL(''), aadd( W_MENU300, { ' XXXXXXXXXXXXXX ','' } ),.F. )


//******************************* Utilitarios do Sistema ***********************
//******************************************************************************


// Utilitarios

if( ACES_NIVEL('EST81'),  aadd( W_MENU500, { ' 1 Usu rios        ','EST81'  } ),.F. )
if( ACES_NIVEL('EST82'),  aadd( W_MENU500, { ' 2 Direitos        ','EST82'  } ),.F. )
if( ACES_NIVEL('EST83'),  aadd( W_MENU500, { ' 3 Senhas          ','EST83'  } ),.F. )
if( ACES_NIVEL('ROTIN'),  aadd( W_MENU500, { ' 4 Rotinas         ','ROTIN'  } ),.F. )
if( ACES_NIVEL('ERROS'),  aadd( W_MENU500, { ' 5 Erros           ','ESTERRO'} ),.F. )
if( ACES_NIVEL('AGE001'), aadd( W_MENU500, { ' 6 Agenda          ','AGE001' } ),.F. )
if( ACES_NIVEL('VEN570'), aadd( W_MENU500, { ' 7 Etq - Clientes  ','VEN570' } ),.F. )
if( ACES_NIVEL('EST570'), aadd( W_MENU500, { ' 8 Etq - Fornecedor','EST570' } ),.F. )
if( ACES_NIVEL('EST999'), aadd( W_MENU500, { ' 9 V.Relat¢rios    ','REL999' } ),.F. )

setcolor( W_PDCOR )
cls

telamain()
dbcloseall()

private WTL0000 := savescreen() ; WCOR0000 := setcolor()


while .T.
   restscreen(,,,,WTL0000)
   setcolor( W_PDCOR )
   setcursor(1)
   abrir("ROTINA")
   abrir("DIREITO")

   P_FASTKEY := space(10)

   @ 10,10 clear to 14,10
   @ 10,10 say 'ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿'
   @ 11,10 say '³                              ³'
   @ 12,10 say '³ Opcao  :                     ³'
   @ 13,10 say '³                              ³'
   @ 14,10 say 'ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ'

   clear gets
   @ 12,21 get P_FASTKEY picture '@!'
   read
   if lastkey()=K_ESC
      if pergunta("Confirma Saida do Sistema (S/N) ?")
	 exit
      end
   end

   //

   if ! empty( P_FASTKEY )

      ROTINA->( dbsetorder(2) )
      ROTINA->( dbseek( P_FASTKEY ) )

      if ROTINA->( found() )
         W_EXEC := alltrim( ROTINA->CODROT )

         if ACES_NIVEL( W_EXEC )
            X := " {|| " + W_EXEC + "() }"
            Y := &( X )
            eval( Y )
         else
            mensbeep("Acesso nao permitido. ENTER")
         end
         loop
      end
   end

   keyboard chr(13)

   while .T.
      setcolor( W_PDCOR )
      telamain()
      mensagem("Escolha sua opcao e tecle <ENTER>.")
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
	       WOPC00 := menu( W_MENU500, 07, 55, 'UTILITARIOS' )
	    end

	 CASE WOPC0000 = 0 // Saida
	    exit

      ENDCASE

      do case
	 case WOPC00 = "ESQ"
	    keyboard( chr( K_CTRL_S ) + chr( K_ENTER ) )
	 case WOPC00 = "DIR"
	    keyboard( chr( K_CTRL_D ) + chr( K_ENTER ) )
      endcase

   end

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
      @ 00,00 say '                        Sistema de Controle de Estoque                   A&D    '
      @ 01,00 say '                               TENAX ACO E FERRO                       Sistemas '
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
   WOPC00 := menu( W_MENU160, 06, 05, 'RELATORIO' )
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
   WOPC00 := menu( W_MENU210, 08, 18, 'CADASTRO' )
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
   WOPC00 := menu( W_MENU260, 15, 17, 'PRECO DE VENDA' )
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
   WOPC00 := menu( W_MENU270, 13, 17, 'RELATORIOS' )
end
return

/*
-------------------------------------------------------------------------------
Procedimento .:
Objetivo .....:
-------------------------------------------------------------------------------
*/
procedure CRM6000

while ! WOPC00 $ '000ESQDIR'
   WOPC00 := menu( W_MENU410, 09, 48, 'Cadastros' )
end

return

/*
-------------------------------------------------------------------------------
Procedimento .:
Objetivo .....:
-------------------------------------------------------------------------------
*/
procedure CRM6100

Juros_pend()

while ! WOPC00 $ '000ESQDIR'
   WOPC00 := menu( W_MENU420, 12, 48, 'Lancamentos' )
end

return
/*
-------------------------------------------------------------------------------
Procedimento .:
Objetivo .....:
-------------------------------------------------------------------------------
*/
procedure CRM6200

Juros_pend()

while ! WOPC00 $ '000ESQDIR'
   WOPC00 := menu( W_MENU430, 13, 48, 'Consultas' )
end

return
/*
-------------------------------------------------------------------------------
Procedimento .:
Objetivo .....:
-------------------------------------------------------------------------------
*/
procedure CRM6300

Juros_pend()

while ! WOPC00 $ '000ESQDIR'
   WOPC00 := menu( W_MENU440, 14, 48, 'Relatorios' )
end

return

/*
-------------------------------------------------------------------------------
Procedimento .:
Objetivo .....:
-------------------------------------------------------------------------------
*/
procedure SRM6000

while ! WOPC00 $ '000ESQDIR'
   WOPC00 := menu( W_MENU610, 10, 50, 'Cadastros',W_CORSUB01 )
end

return
/*
-------------------------------------------------------------------------------
Procedimento .:
Objetivo .....:
-------------------------------------------------------------------------------
*/
procedure SRM6100

Juros_Spend()

while ! WOPC00 $ '000ESQDIR'
   WOPC00 := menu( W_MENU620, 13, 45, 'Lancamentos',W_CORSUB01 )
end

return
/*
-------------------------------------------------------------------------------
Procedimento .:
Objetivo .....:
-------------------------------------------------------------------------------
*/
procedure SRM6200

Juros_Spend()

while ! WOPC00 $ '000ESQDIR'
   WOPC00 := menu( W_MENU630, 14, 48, 'Consultas', W_CORSUB01)
end

return
/*
-------------------------------------------------------------------------------
Procedimento .:
Objetivo .....:
-------------------------------------------------------------------------------
*/
procedure SRM6300

Juros_Spend()

while ! WOPC00 $ '000ESQDIR'
   WOPC00 := menu( W_MENU640, 15, 48, 'Relatorios',W_CORSUB01 )
end

return
/*
-------------------------------------------------------------------------------
Procedimento .:
Objetivo .....:
-------------------------------------------------------------------------------
*/
procedure SRM6500

juros_Spend()

while ! WOPC00 $ '000ESQDIR'
   WOPC00 := menu( W_MENU600, 09, 47, 'CONTRA RETIRADA',W_CORSUB01 )
end

/*
-------------------------------------------------------------------------------
Procedimento .:
Objetivo .....:
-------------------------------------------------------------------------------
*/
procedure TESTE

RETURN
/*
-------------------------------------------------------------------------------
Procedimento .:
Objetivo .....:
-------------------------------------------------------------------------------
*/
procedure ERM1000

Juros_pend()

while ! WOPC00 $ '000ESQDIR'
   WOPC00 := menu( W_MENU650, 10, 50, 'Controle gerencial',W_CORSUB02 )
end

return

/*
-------------------------------------------------------------------------------
Procedimento .:
Objetivo .....:
-------------------------------------------------------------------------------
*/
procedure ERM1100

while ! WOPC00 $ '000ESQDIR'
   WOPC00 := menu( W_MENU660, 13, 48, 'Cadastros',W_CORSUB02 )
end

return

/*
-------------------------------------------------------------------------------
Procedimento .:
Objetivo .....:
-------------------------------------------------------------------------------
*/
procedure ERM1200

while ! WOPC00 $ '000ESQDIR'
   WOPC00 := menu( W_MENU670, 13, 48, 'Lancamentos',W_CORSUB02 )
end

return

/*
-------------------------------------------------------------------------------
Procedimento .:
Objetivo .....:
-------------------------------------------------------------------------------
*/
procedure ERM1300

while ! WOPC00 $ '000ESQDIR'
   WOPC00 := menu( W_MENU680, 13, 48, 'Consultas',W_CORSUB02 )
end

return

/*
-------------------------------------------------------------------------------
Procedimento .:
Objetivo .....:
-------------------------------------------------------------------------------
*/
procedure ERM1400

while ! WOPC00 $ '000ESQDIR'
   WOPC00 := menu( W_MENU690, 13, 48, 'Relatorios',W_CORSUB02 )
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

return

/*
-------------------------------------------------------------------------------
Procedimento .:
Objetivo .....:
-------------------------------------------------------------------------------
*/
procedure LOGOTIPO

@ 07,04 say '±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±'
@ 08,04 say '±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±'
@ 09,04 say '±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±'
@ 10,04 say '±±          ±±±±±        ±±±±±  ±±±±  ±±±±±         ±±±±  ±±±±±±  ±±±±±±±'
@ 11,04 say '±± ±±±  ±±± ±±±±±  ±±±±± ±±±±±  ±±±±  ±±±±±  ±±±±±  ±±±±±  ±±±±  ±±±±±±±±'
@ 12,04 say '±±±±±±  ±±±±±±±±±  ±±±±±±±±±±±   ±±±  ±±±±±  ±±±±±  ±±±±±±  ±±  ±±±±±±±±±'
@ 13,04 say '±±±±±±  ±±±±±±±±±  ±±±±±±±±±±±    ±±  ±±±±±  ±±±±±  ±±±±±±±    ±±±±±±±±±±'
@ 14,04 say '±±±±±±  ±±±±±±±±±     ±±±±±±±±  ±  ±  ±±±±±         ±±±±±±±±  ±±±±±±±±±±±'
@ 15,04 say '±±±±±±  ±±±±±±±±±  ±±±±±±±±±±±  ±±    ±±±±±  ±±±±±  ±±±±±±±    ±±±±±±±±±±'
@ 16,04 say '±±±±±±  ±±±±±±±±±  ±±±±±±±±±±±  ±±±   ±±±±±  ±±±±±  ±±±±±±  ±±  ±±±±±±±±±'
@ 17,04 say '±±±±±±  ±±±±±±±±±  ±±±±± ±±±±±  ±±±±  ±±±±±  ±±±±±  ±±±±±  ±±±±  ±±±±±±±±'
@ 18,04 say '±±±±±±  ±±±±±±±±±        ±±±±±  ±±±±  ±±±±±  ±±±±±  ±±±±  ±±±±±±  ±±±±±±±'
@ 19,04 say '±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±'
@ 20,04 say '±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±'
@ 21,04 say '±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±'
@ 21,65 say C_VERSAO

return

function blocodeerro( erro )

      WERRSSYS  := left( erro:subsystem, 10 )
      WERRSCODE := strzero( erro:subcode, 10 )
      WERRENGDC := erro:description
      WERROPER  := if( erro:operation=NIL," - ",erro:operation)
      WERRFNAME := if( erro:filename =NIL," - ",erro:filename )
      WERRARGS  := if( erro:args     =NIL," - ",erro:args     )

      if len( WERRSSYS ) < 10
         WERRSSYS := WERRSSYS + space( 10 - len( WERRSSYS ) )
      end

      abrir("ESTERRO")
      ESTERRO->( dbsetorder(1) )
      ESTERRO->( dbseek( WERRSSYS + WERRSCODE ))

      WERRDESC := if( empty( ESTERRO->DESCRESU ), 'Erro Indefinido.', ESTERRO->DESCRESU )

      mensboxv( { " ERRO - Contacte a A&D ", ;
                  "Prefixo   : " +  WERRSSYS  ,;
                  "Codigo    : " +  WERRSCODE ,;
                  "Desc Port : " +  WERRDESC  ,;
                  "Desc Ingl : " +  WERRENGDC ,;
                  "Operacao  : " +  WERROPER  ,;
                  "Nome Arq  : " +  WERRFNAME } )

      est000()
return
