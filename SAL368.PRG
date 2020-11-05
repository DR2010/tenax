/*
-------------------------------------------------------------------------------
                              - TENAX -
                        Tabela Geral de Precos
-------------------------------------------------------------------------------
*/
local DIVISOR, CAMPOS
#include "inkey.ch"

set key K_F1 to help
setcancel(.t.)

ALTD(1)
set deleted on

abrir("EST003")
abrir("EST004")
abrir("EST005")
abrir("EST007")
abrir("VEN013")
abrir("VEN015")

status('T a b e l a   G e r a l   d e   P r e c o s')

// --> VEN013 -> TABELA GERAL DE PRECOS
private  X_FORMA    := space(03)         ,;
	 X_TIPO     := space(05)	 ,;
	 X_ESTADO   := space(01)	 ,;
	 X_BIT_MM   := 0.00		 ,;
	 X_ESP_MM   := 0.00		 ,;
	 X_BIT_INT  := space(02)	 ,;
	 X_BIT_FN   := space(02)	 ,;
         X_BIT_FD   := space(02)         ,;
	 X_ESP_INT  := space(02)	 ,;
	 X_ESP_FN   := space(02)	 ,;
         X_MEDIDA   := space(02)          ;

private W_CHAVE_ITEM

TELA := wsave(01,02,19,68)

//
// variaveis DBEDIT
//

P_HDSEP := "ËÍ"
P_COLSEP := "-"

P_HEADER := {"Forma  Tipo   Bit/Esp  Bit/Larg  Medida       Preco "}
//            xxx    xxxxx 9999,999  9999,999   XX   999999999999

P_CAMPOS := {"   VEN013->FORMA                + '    '  + VEN013->TIPO + ' '       " +;
             " + no_zero (VEN013->BIT_MM,8,3) + '  '                               " +;
             " + no_zero (VEN013->ESP_MM,8,3) + '   '   +                          " +;
             " +          VEN013->MEDIDA      + '   '   + STR(VEN015->PRECO,12,2)  "  }

private  X_FORMA    := space(03) ,;
	 X_TIPO     := space(05) ,;
	 X_ESTADO   := space(01) ,;
	 X_BIT_MM   := 0.00	 ,;
	 X_ESP_MM   := 0.00	 ,;
	 X_BIT_INT  := space(02) ,;
	 X_BIT_FN   := space(02) ,;
	 X_BIT_FD   := space(02) ,;
	 X_ESP_INT  := space(02) ,;
	 X_ESP_FN   := space(02) ,;
	 X_ESP_FD   := space(02) ,;
         X_MEDIDA   := space(02)  ;

W_TELA := savescreen(,,,,)

Prec_tela368()

VEN013->( dbgotop() )

VEN013->( dbsetrelation("VEN015",{|| VEN013->MEDIDA},"VEN013->MEDIDA") )

VEN013->( dbedit(05,03,18,76,P_CAMPOS,"PREC_FUNC368",, P_HEADER, P_HDSEP, P_COLSEP))

restscreen(,,,,W_TELA)

dbcloseall()
return

//
//
// -------------------------  FIM DO PROGRAMA PRINCIPAL -----------------------
//
//

/*
-------------------------------------------------------------------------------
                          PREC_TELA368
-------------------------------------------------------------------------------
*/
procedure prec_tela368()

   @ 02,02 say 'ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿'
   @ 03,02 say '³                          TABELA GERAL DE PRECOS                          ³'
   @ 04,02 say 'ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´'
   @ 05,02 say '³                                                                          ³'
   @ 06,02 say '³                                                                          ³'
   @ 07,02 say '³                                                                          ³'
   @ 08,02 say '³                                                                          ³'
   @ 09,02 say '³                                                                          ³'
   @ 10,02 say '³                                                                          ³'
   @ 11,02 say '³                                                                          ³'
   @ 12,02 say '³                                                                          ³'
   @ 13,02 say '³                                                                          ³'
   @ 14,02 say '³                                                                          ³'
   @ 15,02 say '³                                                                          ³'
   @ 16,02 say '³                                                                          ³'
   @ 17,02 say '³                                                                          ³'
   @ 18,02 say '³                                                                          ³'
   @ 19,02 say 'ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄ´'
   @ 20,02 say '³  <F3> Inclui  ³  <F4> Altera  ³ <F5> Exclui   ³                 ³ <ESC>  ³'
   @ 21,02 say '³               ³               ³               ³                 ³        ³'
   @ 22,02 say 'ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÙ'

return

/*
-------------------------------------------------------------------------------
                           PREC_FUNC368
-------------------------------------------------------------------------------
*/
function PREC_FUNC368( modo, coluna )
private WRET := 1, W_PRECSCR := savescreen(07,01,20,79)
setcursor(1)

if modo = 4
   do case
      case lastkey() = K_F1
	 socorro1()
	 WRET := 1

      case lastkey() = K_F3
         PREC_inclui368()
	 WRET := 2

      case lastkey() = K_F4
         PREC_altera368()
	 WRET := 2

      case lastkey() = K_F5
         PREC_exclui368()
	 WRET := 2

      case lastkey() = K_ESC
	 WRET := 0
  endcase
end
restscreen(07,01,20,79,W_PRECSCR )

return WRET

/*
-------------------------------------------------------------------------------
                           PREC_INCLUI368
-------------------------------------------------------------------------------
*/
Function PREC_inclui368()
local W_OLDSCR := savescreen()

PREC_zera368()
Item_tela368()
get_mainkey(2)

read

W_CHAVE_ITEM := ( X_FORMA+ X_TIPO+ ;
	     str( X_BIT_MM, 8, 3 ) + str( X_ESP_MM, 8, 3 ) + X_ESTADO )

if lastkey()#K_ESC
   if PREC_get368()
      PREC_grava368("I")
   end
end
return

/*
-------------------------------------------------------------------------------
                           PREC_ALTERA368
-------------------------------------------------------------------------------
*/
function PREC_altera368()

local W_OLDSCR := savescreen()

PREC_atrib368()
Item_tela368()
PREC_show368()

get_mainkey(2)

clear gets

tes_formato(2)
tes_tipo(2)
tes_estado(2)

W_CHAVE_ITEM := ( X_FORMA+ X_TIPO+ ;
	     str( X_BIT_MM, 8, 3 ) + str( X_ESP_MM, 8, 3 ) + X_ESTADO )

if PREC_get368()
   PREC_grava368("A")
end

return

/*
-------------------------------------------------------------------------------
                           PREC_CONSULTA368
-------------------------------------------------------------------------------
*/
Function PREC_consulta368()
local W_OLDSCR := savescreen()

PREC_atrib368()
PREC_tela368()
PREC_show368()

return

/*
-------------------------------------------------------------------------------
                           PREC_EXCLUI368
-------------------------------------------------------------------------------
*/
Function PREC_exclui368()

local W_OLDSCR := savescreen()

Item_tela368()
PREC_show368()

if conf(' Confirma Exclusao ')
   VEN013->( dbdelete() )
end

return

/*
-------------------------------------------------------------------------------
                           PREC_ZERA368
-------------------------------------------------------------------------------
*/
procedure PREC_zera368()

   X_FORMA    := space(03)
   X_TIPO     := space(05)
   X_ESTADO   := space(01)
   X_BIT_MM   := 0.00
   X_ESP_MM   := 0.00
   X_BIT_INT  := space(02)
   X_BIT_FN   := space(02)
   X_BIT_FD   := space(02)
   X_ESP_INT  := space(02)
   X_ESP_FN   := space(02)
   X_ESP_FD   := space(02)
   X_MEDIDA   := space(02)

return

/*
----------------------------------------------------------------------------------------
                           PREC_GRAVA368
-------------------------------------------------------------------------------
*/
procedure PREC_grava368( P_MODO )

   if P_MODO = "I"
      VEN013->( dbappend())
   end

   VEN013->FORMA    := X_FORMA
   VEN013->TIPO     := X_TIPO
   VEN013->ESTADO   := X_ESTADO
   VEN013->BIT_MM   := X_BIT_MM
   VEN013->ESP_MM   := X_ESP_MM
   VEN013->BIT_INT  := X_BIT_INT
   VEN013->BIT_FN   := X_BIT_FN
   VEN013->BIT_FD   := X_BIT_FD
   VEN013->ESP_INT  := X_ESP_INT
   VEN013->ESP_FN   := X_ESP_FN
   VEN013->ESP_FD   := X_ESP_FD
   VEN013->MEDIDA   := X_MEDIDA

return

/*
-------------------------------------------------------------------------------
                           PREC_ATRIB368
-------------------------------------------------------------------------------
*/
procedure PREC_atrib368()

   X_FORMA      :=  VEN013->FORMA
   X_TIPO       :=  VEN013->TIPO
   X_ESTADO     :=  VEN013->ESTADO
   X_BIT_MM     :=  VEN013->BIT_MM
   X_ESP_MM     :=  VEN013->ESP_MM
   X_BIT_INT    :=  VEN013->BIT_INT
   X_BIT_FN     :=  VEN013->BIT_FN
   X_BIT_FD     :=  VEN013->BIT_FD
   X_ESP_INT    :=  VEN013->ESP_INT
   X_ESP_FN     :=  VEN013->ESP_FN
   X_ESP_FD     :=  VEN013->ESP_FD
   X_MEDIDA     :=  VEN013->MEDIDA

return

/*
-------------------------------------------------------------------------------
                           PREC_SHOW368
-------------------------------------------------------------------------------
*/
procedure PREC_show368()

   get_mainkey(2)
   clear gets

   W_CHAVE_ITEM := ( X_FORMA+ X_TIPO+ ;
                str( X_BIT_MM, 8, 3 ) + str( X_ESP_MM, 8, 3 ) + X_ESTADO )

   @ 16,18 say VEN013->MEDIDA      picture "@!"

return

/*
-------------------------------------------------------------------------------
                           PREC_GET368
-------------------------------------------------------------------------------
*/
procedure PREC_get368

local WRET         := .F.
local W_MEDIDA_TAB := space(02)

set key K_F1 to help

@ 16,18 get X_MEDIDA  picture "@!" valid tes_medida(X_MEDIDA,16,18)
read

if lastkey() = K_ESC
   return .f.
end

if conf(' Confirma Operacao ')
   WRET := .T.
end

return WRET

/*
-------------------------------------------------------------------------------
                           ITEM_TELA368
-------------------------------------------------------------------------------
*/
procedure item_tela368()

   @ 07,02 say 'ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´'
   @ 08,02 say '³                                                                          ³'
   @ 09,02 say '³  Forma    :       -                                                      ³'
   @ 10,02 say '³  Tipo     :       -                                                      ³'
   @ 11,02 say '³  Estado   :       -                                                      ³'
   @ 12,02 say '³  Bit./Esp.:      /                                                       ³'
   @ 13,02 say '³  Bit./Larg:      /                                                       ³'
   @ 14,02 say 'ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´'
   @ 15,02 say '³                                                                          ³'
   @ 16,02 say '³  Medida...:                                                              ³'
   @ 17,02 say '³                                                                          ³'
   @ 18,02 say '³                                                                          ³'
   @ 19,02 say '³                                                                          ³'
   @ 20,02 say 'ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´'
   @ 21,02 say '³                                                                          ³'
   @ 22,02 say 'ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ'

return


