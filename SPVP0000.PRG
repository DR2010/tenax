/*
  +---------------------------------------------------------------------------+
  | >>>>>>>>>>>>>>>>>>>>>>    MaCMeL   Consultoria  <<<<<<<<<<<<<<<<<<<<<<<<< |
  |                                                                           |
  | >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>  SPVP0000  <<<<<<<<<<<<<<<<<<<<<<<<<<<<<< |
  |                                                                           |
  | Sistema:                                                                  |
  |---------------------------------------------------------------------------|
  | Descricao..: Modulo principal de controle dos Menus.                      |
  |---------------------------------------------------------------------------|
  | Cliente....: TENAX ACO E FERRO          | Ultima Alteracao                |
  | Analista...:                            | Autor :                         |
  | Programador:                            | Dt/Hr :                         |
  | Inicio.....:                            | Motivo:                         |
  |                                         |                                 |
  +---------------------------------------------------------------------------+
*/
local getlist:={}
#include "inkey.ch"
#include "sic.ch"

public  C_USUARIO := space(8), C_ACESSO := "C", C_MODULO := "C"
public  W_PDCOR, W_CORGET, W_CORPERG, W_CORWIND, W_CORWG, PADRAO, W_DIR
public  P_LIN, P_COL, SCR_BASICO

private W_MENU000:={}, W_OPCAO000
private W_MENU001:={}, W_MENU002:={}, W_MENU003:={}, W_MENU004:={},;
        W_MENU005:={}, W_ABAND:=.F.,  W_MSG:={},     W_ACESSO

// Testa padrao de cor
W_PDCOR     := "W/B   , B/W    ,B, N, N     "       // Cor padrao
W_CORSOMBRA := "N/BG  , B/W    ,B, N, N     "       // Cor da sombra
W_CORWIND   := "W+/GR , W+/BG  ,B, N, W/GR  "       // Cor janela sem get's
W_CORGET    := "W+/BG , N/W    ,B, N, N/BG  "       // Cor gets com fundo basico
W_COREDIT   := "N/BG  , BG/RB+ ,B, N, W/N   "       // Cor gets com fundo basico
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
set message to 22

spv_dec() // verifica existencia dos dbfs

spv_verind("INDEX") // verifica existencia dos indices

W_ABAND := .T.

// Paragrafo 1
// ----------------------------------------------------------------------
// Define menu principal

W_MENU000:={}; W_MENU001:={}; W_MENU002:={}
W_MENU003:={}; W_MENU004:={}; W_MENU005:={}

aadd( W_MENU000, ' Pedidos ' )
aadd( W_MENU000, ' Empresas ' )
aadd( W_MENU000, ' Funcionarios ' )
aadd( W_MENU000, ' Relatorios ' )
aadd( W_MENU000, ' Utilitarios ' )

aadd( W_MSG, 'Fazer Pedido de Vale Transporte.    <ENTER>-Acessa <ESC>-Retorna.')
aadd( W_MSG, 'Cadastar Empresas.                  <ENTER>-Acessa <ESC>-Retorna.')
aadd( W_MSG, 'Cadastrar Funcionarios.             <ENTER>-Acessa <ESC>-Retorna.')
aadd( W_MSG, 'Emissao de Relatorios de Controle.  <ENTER>-Acessa <ESC>-Retorna.')
aadd( W_MSG, 'Utilitarios do sistema.             <ENTER>-Acessa <ESC>-Retorna.')

aadd( W_MENU001, ' Cadastrar   ')                        // 0110
aadd( W_MENU001, ' Gerar Disco ')                        // 0120
aadd( W_MENU001, ' Tarifas     ')                        // 0130

aadd( W_MENU002, ' Cadastrar   ')                        // 0210

aadd( W_MENU003, ' Cadastrar   ')                        // 0310

aadd( W_MENU004, ' Pedido Concessao de Vale   ')         // 0410
aadd( W_MENU004, ' Conferencia de Pedidos     ')         // 0420
aadd( W_MENU004, ' Relat¢rio de Controle      ')         // 0430
aadd( W_MENU004, ' Recibo de Entrega          ')         // 0440
aadd( W_MENU004, ' Relat¢rio total de Compras ')         // 0450

aadd( W_MENU005, ' Configura‡„o ')                       // 0510
aadd( W_MENU005, ' Relat. Tela  ')                       // 0520
aadd( W_MENU005, ' Reindexacao  ')                       //
aadd( W_MENU005, ' Sa¡da        ')                       //

telamain()
// telaentr()
private WTL0000 := savescreen() ; WCOR0000 := setcolor()

keyboard chr(13)
while .T.
   setcolor( W_PDCOR )
   telamain()
   mensagem("Tecle <ENTER> e mova as setas.")
   setcolor(W_CORMENU)
   rt_prompt(04, 05, W_MENU000[1])
   rt_prompt(04, 17, W_MENU000[2])
   rt_prompt(04, 30, W_MENU000[3])
   rt_prompt(04, 47, W_MENU000[4])
   rt_prompt(04, 60, W_MENU000[5])
   menu to WOPC0000

   if WOPC0000 > 0
       setcolor(W_PDCOR)
       mensagem(W_MSG[WOPC0000])
       setcolor(W_CORSUBM)
   end

   DO CASE
      CASE WOPC0000 = 1   // Pedidos

         WVARTELA := savescreen()
         setcolor(W_BACKMENU)
         @ 04,05 say W_MENU000[1]
         setcolor(W_CORSUBM)

         @ 05,03 say 'ÂÄÄÄÄÄÄÄÄÄÄÄÄÄÂ'
         @ 06,03 say '³             ³'
         @ 07,03 say '³             ³'
         @ 08,03 say '³             ³'
         @ 09,03 say 'ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÙ'
         sombra( 05, 03, 09, 17 )
         WOPC02 = achoice( 06, 04, 08, 16, W_MENU001 )
         telamain()

         do case
            case WOPC02 = 1
               SPVP0110()
               keyboard chr(13)
            case WOPC02 = 2
               SPVP0120()
               keyboard chr(13)
            case WOPC02 = 3
               SPVP0130()
               keyboard chr(13)
            case lastkey() = 4
               keyboard( chr( K_CTRL_X ) + chr( K_ENTER ) )
            case lastkey() = 19
               keyboard( chr( K_CTRL_E ) + chr( K_ENTER ) )
         endcase

         restscreen(,,,, WVARTELA)

      CASE WOPC0000 = 2  // Empresas

         WVARTELA := savescreen()
         setcolor(W_BACKMENU)
         @ 04,17 say W_MENU000[2]
         setcolor(W_CORSUBM)

         @ 05,16 say 'ÂÄÄÄÄÄÄÄÄÄÄÄÂ'
         @ 06,16 say '³           ³'
         @ 07,16 say 'ÀÄÄÄÄÄÄÄÄÄÄÄÙ'
         sombra( 05, 16, 07, 28 )
         WOPC02 = achoice( 06, 17, 06, 27, W_MENU002)
         telamain()

         do case
            case WOPC02 = 1
               SPVP0210()
               keyboard chr(13)
            case lastkey() = 4
               keyboard( chr( K_CTRL_X ) + chr( K_ENTER ) )
            case lastkey() = 19
               keyboard( chr( K_CTRL_E ) + chr( K_ENTER ) )
         endcase
         restscreen(,,,, WVARTELA)

      CASE WOPC0000 = 3   // Funcionarios

         WVARTELA := savescreen()
         setcolor(W_BACKMENU)
         @ 04,30 say W_MENU000[3]
         setcolor(W_CORSUBM)

         @ 05,31 say 'ÂÄÄÄÄÄÄÄÄÄÄÄÄÂ'
         @ 06,31 say '³            ³'
         @ 07,31 say 'ÀÄÄÄÄÄÄÄÄÄÄÄÄÙ'
         sombra( 05, 31, 07, 44 )

         WOPC03 = achoice( 06, 32, 06, 43, W_MENU003 )
         telamain()
         do case
            case WOPC03 = 1
               SPVP0310()
               keyboard chr(13)
            case lastkey() = 4
               keyboard( chr( K_CTRL_X ) + chr( K_ENTER ) )
            case lastkey() = 19
               keyboard( chr( K_CTRL_E ) + chr( K_ENTER ) )
            otherwise
         endcase
         restscreen(,,,, WVARTELA)

      CASE WOPC0000 = 4   // Relatorios

         WVARTELA := savescreen()
         setcolor(W_BACKMENU)
         @ 04,47 say W_MENU000[4]
         setcolor(W_CORSUBM)

         @ 05,45 say 'ÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂ'
         @ 06,45 say '³                           ³'
         @ 07,45 say '³                           ³'
         @ 08,45 say '³                           ³'
         @ 09,45 say '³                           ³'
         @ 10,45 say '³                           ³'
         @ 11,45 say 'ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ'
         sombra( 05, 45, 11, 73 )

         WOPC04 = achoice( 06, 46, 10, 72, W_MENU004 )
         telamain()
         do case
            case WOPC04 = 1
               SPVP0410()
               keyboard chr(13)
            case WOPC04 = 2
               SPVP0420()
               keyboard chr(13)
            case WOPC04 = 3
               SPVP0430()
               keyboard chr(13)
            case WOPC04 = 4
               SPVP0440()
               keyboard chr(13)
            case WOPC04 = 5
               SPVP0450()          // Relatorio de compras de vale
               keyboard chr(13)
            case lastkey() = 4
               keyboard( chr( K_CTRL_X ) + chr( K_ENTER ) )
            case lastkey() = 19
               keyboard( chr( K_CTRL_E ) + chr( K_ENTER ) )
         endcase
         restscreen(,,,, WVARTELA)

      CASE WOPC0000 = 5 // Utilitarios

         WVARTELA := savescreen()
         setcolor(W_BACKMENU)
         @ 04,60 say W_MENU000[5]
         setcolor(W_CORSUBM)

         @ 05,58 say 'ÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂ'
         @ 06,58 say '³                ³'
         @ 07,58 say '³                ³'
         @ 08,58 say '³                ³'
         @ 09,58 say '³                ³'
         @ 10,58 say 'ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ'
         sombra( 05, 58, 10, 75 )
         WOPC05 = achoice( 06, 59, 09, 74, W_MENU005 )
         telamain()
         do case
            case WOPC05 = 1
               SPVP0510()
               keyboard chr(13)
            case WOPC05 = 2
               SPVP0520()
               keyboard chr(13)
            case WOPC05 = 3
               if ESCIND()
                  AT_QTDFUN()
               endif
               keyboard chr(13)
            case WOPC05 = 4 // Saida
               if pergunta("Confirma Saida do Sistema (S/N) ?")
                  exit
                  //keyboard chr(27)
               end
            case lastkey() = 4
               keyboard( chr( K_CTRL_X ) + chr( K_ENTER ) )
            case lastkey() = 19
               keyboard( chr( K_CTRL_E ) + chr( K_ENTER ) )
         endcase
         restscreen(,,,, WVARTELA)

      CASE WOPC0000 = 0 // Saida
         if pergunta("Confirma Saida do Sistema (S/N) ?")
            exit
         end

   ENDCASE
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

   abrir("PARAMETRO")
   setcolor( W_CORMENU )
   if SCR_MENU0 = NIL

      setcolor(W_CORMENU)
      @ 00,02 say ' TENAX ACO E FERRO               Sistema de Controle de Estoque      MaCMeL '

      setcolor(W_PDCOR)
      @ 02,02 say '                                                                            '

      setcolor(W_CORMENU)
      @ 03,02 say 'ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿'
      @ 04,02 say '³   Pedidos     Empresas     Funcionarios     Relatorios   Utilitarios     ³'
      @ 05,02 say 'ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ'
      setcolor( W_PDCOR )
      @ 06,03 say '                                                                            '
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
      @ 23,00 say '                                                                                '

      setcolor( W_CORMENU )
      @ 24,02 say space(76)
      @ 24,02 say ' >'
      //sombra(23,01,23,78)
      SCR_MENU0 := savescreen(01,02,24,79)
   else
      restscreen( 01,02,24,79,SCR_MENU0)
   end
   setcolor( W_PDCOR )
   dbcloseall()

return

/*
 ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
 ³   Pedidos     Empresas     Funcionarios     Relatorios     Utilitarios   ³
 ÀÂÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
  ³ Cadastrar   ³
  ³ Gerar Disco ³
  ³ Tarifas     ³
  ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
  3            17

 ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
 ³   Pedidos     Empresas     Funcionarios     Relatorios     Utilitarios   ³
 ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
               ³ Cadastrar ³
               ÀÄÄÄÄÄÄÄÄÄÄÄÙ
              16          28

 ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
 ³   Pedidos     Empresas     Funcionarios     Relatorios     Utilitarios   ³
 ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
                            ³  Cadastrar   ³
                            ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
                           28             44

 ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
 ³   Pedidos     Empresas     Funcionarios     Relatorios     Utilitarios   ³
 ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÙ
                                             ³ Pedido Concessao de Vale ³
                                             ³ Conferencia de Pedidos   ³
                                             ³ Relatorio de Controle    ³
                                             ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
                                            45                         72

 ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
 ³   Pedidos     Empresas     Funcionarios     Relatorios     Utilitarios   ³
 ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÙ
                                                            ³ Configuracao ³
                                                            ³ Relat. Tela  ³
                                                            ³ Reindexacao  ³
                                                            ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
                                                           61             75
*/
