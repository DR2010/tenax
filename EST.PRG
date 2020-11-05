/*

   SCM - Sistema de Controle Metalurgico
   EST.PRG - Modulo Principal

*/

setcancel(.t.)
ALTD(1)
set deleted on

i_comp2       := '2'
i_comp3       := '3'
i_comp4       := '4'
i_comp5       := '5'
i_descompacta := '0'

set key -8 to S_MATERIAL

// Cria padrao de cor
private W_PDCOR     := "W/N   , N/W    ,N, N, N      "  // Cor padrao
// private W_PDCOR     := "W/B   , B/W    ,B, N, N      "  // Cor padrao
private W_CORGET    := "W+/BG , N/W    ,B, N, N/BG   "  // Cor gets com fundo basico
private W_GETOBJ    := "N/W   , N+/W                 "  // Cor usada p/funcao getedit
private W_SAYOBJ    := "N+/W  , N/W                  "  // Cor inverso da funcao getedit
private W_CORPERG   := "B/W   , W/B    ,B, N, W/B+   "  // Cor das perguntas
private W_CORWIND   := "W+/GR , W+/BG  ,B, N, W/GR   "  // Cor janela sem get's
private W_CORWG     := "RB/W  , N/G    ,B, N, RB/W   "  // Cor window com gets
private W_CORMENU   := "N/W   , W/B    ,B, N, W/N    "  // Cor dos Menus
private W_CORMENS   := "N/W   , GR+/G  ,B, N, W/B+   "  // Cor das mensagens
private W_COREDIT   := "N/BG  , BG/RB+ ,B, N, W/N    "  // Cor gets com fundo basico
private W_COREDITV  := "W/B   , W/RB   ,B, N, W/N    "  // Cor gets com fundo basico para validacao
private W_CORBARR   := "BG/RB+, BG/RB+ ,B, RB+,BG/RB+"  // Cor da barra de luz do dbedit
private W_BOTOES    := "R/W   , G/N    ,B, N, W/N    "  // Cor de botoes
private W_FIRSTLET  := "B+/W  , G/N    ,B, N, W/N    "  // Cor primeira letra
private W_PUSHBOT   := "N/BG  , G/N    ,B, N, W/N    "  // Cor do botao push
private W_CORALERT  := "R/BG  , R/N    ,B, N, W/N    "  // Cor do botao push

external milogo
sistema := 'Sistema Integrado Tenax'
tit_aux := '<F1>  Ajuda'

init_screen('TENAX','Ver.1.0',sistema,'/IENTRADA DO SISTEMA','/lteladaf','/sest','/c100','/f100','/b30','/nreorg',tit_aux)

reorg()

*_________padrao de cabecalho__________*

setcancel(.t.)
ALTD(1)

defcab('/te1TENAX','/te2 ','/te3 ','/si1 -- Sistema Integrado Tenax --')

setcancel(.t.)
ALTD(1)

*-----------------------------------------*
*-----------------------------------------*

status('Modulos')

tit := {'Cadastros              ',;
        'Estoque                ',;
        'Vendas                 ',;
        'Contas a Pagar         ',;
        'Contas a Receber       ',;
        'Utilitarios            ' }

prog := {'cad000','est000','vendas1','cap000','car000','uti000'}

// variaveis publicas

public T_BIT := .F., T_LARG := .F.

setcancel(.t.)
ALTD(1)
sysmenu('c','c',' S i s t e m a s ',tit,prog,'')

set color to
clear

return

*------------------------------------*
Function CAD000
*------------------------------------*

wa := status('Menu Principal')

tit1 := {'Almoxarifados         ' ,;
         'Fornecedores          ' ,;
         'Forma de Material     ' ,;
         'Tipo de Material      ' ,;
         'Item de Estoque       ' ,;
         'Tipo de Movimentacao  ' ,;
         'Parametros de Sistema ' }

prog1 := {'est11',;
          'est12',;
          'est13',;
          'est14',;
          'est17',;
          'est21',;
          'ven099' }

sysmenu('+2','+8',' Cadastros ',tit1,prog1,'',0)

status(wa)

return nil

*------------------------------------*
Function EST000
*------------------------------------*

wa := status('Controle de Estoque')

tit2 := {'Compras                ',;
         'Movimentacao           ',;
         'Detalhar Peca Curta    ',;
         'Recebimento de Material',;
         'Relatorios             '}

prog2 := {'est16','est18','est22','est23','est9' }

sysmenu('+2','+8',' Controle de Estoque ',tit2,prog2,'',0)

status(wa)

return nil

*------------------------------------*
Function VENDAS1
*------------------------------------*

wa := status('V e n d a s')

tit3 := {' Consulta            ' ,;
         ' Consulta => Pedido  ' ,;
         ' Pedido              ' ,;
         ' Nota Fiscal         ' ,;
         ' Separacao           ' ,;
         ' Cadastros           '  }

prog3 := {'ven021'  ,;
          'ven031'  ,;
          'ven032'  ,;
          'ven034'  ,;
          'ven035'  ,;
          'vendas11' }

sysmenu('+2','+8',' V e n d a s ',tit3,prog3,'',0)

status(wa)

return nil

*------------------------------------*
Function VENDAS11
*------------------------------------*

wa := status('C a d a s t r o s')

tit4 := {' Clientes            ' ,;  // 011
         ' Vendedores          ' ,;  // 012
         ' Comissao Vendedor   ' ,;  // 362
         ' Comissao Comprador  ' ,;  // 363
         ' Pagamento Vendedor  ' ,;  // 364
         ' Pagamento Comprador ' ,;  // 365
         ' Comissoes de Venda  ' ,;  // 366
         ' Precos de Venda     '  }  // ven111

prog4 := {'ven011',;
          'ven012',;
          'ven362',;
          'ven363',;
          'ven364',;
          'ven365',;
          'ven366',;
          'vendas111' }

sysmenu('+2','+8','C a d a s t r o s',tit4,prog4,'',0)

status(wa)

return nil

*------------------------------------*
Function VENDAS111
*------------------------------------*

wa := status('Precos de Venda')

tit5 := {' Grupos              ' ,;  // 367
         ' Sub Grupos          ' ,;  // 368
         ' Precos/Colunas      ' ,;  // 369
         ' Sub Fatores         '  }  // 370

prog5 := {'ven367',;
          'ven368',;
          'ven369',;
          'ven370' }

sysmenu('+2','+8','Precos de Venda',tit5,prog5,'',0)

status(wa)

return nil

*------------------------------------*
Function CAP000
*------------------------------------*

wa := status('Contas a Pagar')

tit4 := {'                     ' ,;
         '                     '  }

prog4 := {'     ',;
          '      ' }

sysmenu('+2','+8',' Contas a Pagar ',tit4,prog4,'',0)

status(wa)

return nil

*------------------------------------*
Function CAR000
*------------------------------------*

wa := status('Contas a Receber')

tit5 := {'                     ' ,;
         '                     '  }

prog5 := {'     ',;
          '      ' }

sysmenu('+2','+8',' Contas a Receber ',tit5,prog5,'',0)

status(wa)

return nil

*-----------------------------------*
Function uti000
*-----------------------------------*

wa := status('Utilitarios')

Tit8 := {'Mudanca de senha       ',;
         'Reorganizar indices    ',;
         'Backup dos dados       ',;
         'Recupera os dados      ',;
         'Cadastrar senha        ' }

prog8 := {'est81','est82','est83','est84','est85'}

sysmenu('+2','+8',' Utilitarios ',tit8,prog8,'',0)

status(wa)

return nil

*-----------------------------------*
Function est9
*-----------------------------------*

wa := status('Relatorios')

Tit9 := {'Almoxarifado           ',;
         'Fornecedores           ',;
         'Forma do Material      ',;
         'Tipo de Material       ',;
         'Qtd.Itens de Estoque   ',;
         'Saida de Materiais     ',;
         'Entrada de Materiais   ',;
         'Lotes                  ' }

prog9 := {'est91','est92','est93','est94','est95','est96','est97','est98' }

sysmenu('+2','+8',' Relatorios ',tit9,prog9,'',0)

status(wa)

return nil

function clipper501

return nil
