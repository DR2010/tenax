/*

   SCM - Sistema de Controle Metalurgico
   EST17.PRG - Cadastro do Item de Estoque
*/
local DIVISOR, CAMPOS
#include "inkey.ch"


set key K_F1  to help
set key K_F7  to tela_peca_cort
set key K_F8  to tela_ped_compra
set key K_F9  to tela_bloquinho
// set key K_F10 to conta_cortadas

set deleted on

abrir("EST002")
abrir("EST003")
abrir("EST004")
abrir("EST005")
abrir("EST006")
abrir("EST007")
abrir("EST008")
abrir("EST010")
abrir("EST031")
abrir("EST040")
abrir("DIREITO")


// Verificacao dos direitos

L_DIREITO := verdireito( C_ACESSO, 'EST17' )

setcolor(W_COREDIT)
status('Cadastro de Item de Estoque')

// chave
X_FORMA   := space(03)
X_TIPO    := space(05)
X_ESTADO  := space(01)
X_BIT_MM  := 0.00      //  8.3
X_ESP_MM  := 0.00      //  8.3
X_BIT_INT := space(02)
X_BIT_FN  := space(02)
X_BIT_FD  := space(02)
X_ESP_INT := space(02)
X_ESP_FN  := space(02)
X_ESP_FD  := space(02)

X_QTD_KGI := 0.00      // 12.2
X_QTD_KGC := 0.00      // 12.2
X_QTD_KGT := 0.00
X_QTD_MIN := 0.00

X_QTD_PED := 0.00      // 12.2
X_TAM_INT := 0.00      //  8.2

X_QTD_INT := 0         //  5.0
X_QTD_COR := 0         //  5.0

X_PER_COR := 0.000     //  6.1
X_PES_MTR := 0.000    // 10.3
X_PES_INT := 1.00      // 10.1

X_CUS_ULT := 0.00      // 12.2
X_CUS_MED := 0.00      // 12.2
X_OBS_MAT := space(65)
X_CART_LOT:= space(49)
X_DAT_ULT := ctod(" ")

X_GRUPO   := space(02)
X_COLUNA  := space(02)
X_SUBGRUPO:= space(02)
X_SUBFATOR:= space(02)

T_BIT := .F.
T_LARG := .F.
x_modo:=0

// --> Inicio

While .T.

   status('Cadastro de Item de Estoque')
   tela_17()
   zera_17()

   get_mainkey()
   read

   if lastkey()=K_ESC
      exit
   end

   W_CHAVE_ITEM := ( X_FORMA+ X_TIPO+ ;
                str( X_BIT_MM, 8, 3 ) + str( X_ESP_MM, 8, 3 ) + X_ESTADO )

   if ver_material( W_CHAVE_ITEM )
      atribui_17()
      show_17()

      status('Cadastro de Item de Estoque')

      W_RESP := esp_alt()
      do case
         case LASTKEY()= 27
           loop

         case W_RESP="C"
           SHOW_17()

           X_KEY := ' '
           @ 03,67 say 'F7/F8 :'get X_KEY picture "9"
           read

           LOOP

         case W_RESP="A" .and. L_DIREITO $ "SAI"

           atribui_17()
           while .t.
              get_17()
              if lastkey() = K_ESC
                 if conf('Abandona Alteracoes')
                   exit
                 end
              end
              if conf('Confirma Dados')
                 grava_17('A')
                 exit
              end
           end

         case W_RESP="E" .and. L_DIREITO $ "SAI"
            if conf( 'Confirma Exclusao')
               if movimentacao( W_CHAVE_ITEM )
                  mensbeep("H  movimenta‡„o para este item. Imposs¡vel excluir.")
               else
                  while EST007->( ! rlock() ); end
                  EST007->( dbdelete() )
                  EST007->( dbunlock() )
                  mensbeep("Excluido. <ENTER>")
                  loop
               end
            end
      endcase
   else
      while .t.
        get_17()
        if lastkey() = K_ESC
           if conf('Abandona Altera‡”es')
              exit
           end
        end
        if conf('Confirma Dados')
           grava_17('I')
           exit
        end
      end
   end
end

set key K_F7 to
set key K_F8 to
dbcloseall()

// --> Fim


/*
-----------------------------------------------------------------------------
                          Procedimento Tela
-----------------------------------------------------------------------------
*/
procedure TELA_17()

   @ 02,02 say 'ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿'
   @ 03,02 say '³                                                                          ³'
   @ 04,02 say '³                                                                          ³'
   @ 05,02 say '³  Forma    :       -                                                      ³'
   @ 06,02 say '³  Tipo     :       -                                                      ³'
   @ 07,02 say '³  Estado   :       -                                                      ³'
   @ 08,02 say '³  Bit./Esp.:      /                                                       ³'
   @ 09,02 say '³  Bit./Larg:      /                                                       ³'
   @ 10,02 say '³                                       Qtd. Comprada - Kg.:               ³'
   @ 11,02 say '³  Qtd. em KG - Total  :                                                   ³'
   @ 12,02 say '³               M¡nima :                Custo - Medio......:               ³'
   @ 13,02 say '³                                             - Ult.Compra.:               ³'
   @ 14,02 say '³  Qtd. Pe‡a  - Inteira:                                                   ³'
   @ 15,02 say '³               Cortada:                Data Ultima Compra.:               ³'
   @ 16,02 say '³                                                                          ³'
   @ 17,02 say '³  Peso por Metro......:                 ÚÄ Pre‡o ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿  ³'
   @ 18,02 say '³  Tam. Pe‡a Inteira...:                 ³ Grupo  :      SubGrupo :     ³  ³'
   @ 19,02 say '³  Perda por Corte.....:                 ³ Coluna :      SubFator :     ³  ³'
   @ 20,02 say '³                                                                          ³'
   @ 21,02 say '³  Carteira de Lotes...:                                                   ³'
   @ 22,02 say '³  Obs :                                                                   ³'
   @ 23,02 say 'ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ'


return

/*
-----------------------------------------------------------------------------
                    Funcao GET_17
-----------------------------------------------------------------------------
*/
function get_17()
   local WRET := .T.

   @ 11,27 get X_QTD_KGT picture "999999999.99" when !(substr( SEGURANCA,1,1 ) == " ")
   @ 12,27 get X_QTD_MIN picture "999999999.99"

   @ 14,27 get X_QTD_INT picture "99999" when !(substr( SEGURANCA,1,1 ) == " ")
   @ 15,27 get X_QTD_COR picture "99999" when !(substr( SEGURANCA,1,1 ) == " ")

   @ 17,27 get X_PES_MTR picture "99999999.999"
   @ 18,27 get X_TAM_INT picture "99999.99"
   @ 19,27 get X_PER_COR picture "9999.999"

   @ 10,63 get X_QTD_PED picture "999999999.99"

   @ 12,63 get X_CUS_MED picture "999,999,999.99" when !(substr( SEGURANCA,1,1 ) == " ")
   @ 13,63 get X_CUS_ULT picture "999,999,999.99" when !(substr( SEGURANCA,1,1 ) == " ")

   @ 15,63 get X_DAT_ULT

   @ 18,54 get X_GRUPO    picture "@!"
   @ 18,70 get X_SUBGRUPO picture "@!"
   @ 19,54 get X_COLUNA   picture "@!"
   @ 19,70 get X_SUBFATOR picture "@!"

   @ 22,11 get X_OBS_MAT picture "@!"
   read

return WRET


/*
-----------------------------------------------------------------------------
                    Funcao SHOW_17
-----------------------------------------------------------------------------
*/
procedure SHOW_17()

   @ 11,27 say EST007->QTD_KGT picture "999999999.99"
   @ 12,27 say EST007->QTD_MIN picture "999999999.99"

   @ 14,27 say EST007->QTD_INT picture "99999"
   @ 15,27 say EST007->QTD_COR picture "99999"

   @ 17,27 say EST007->PES_MTR picture "99999999.999"
   @ 18,27 say EST007->TAM_INT picture "99999.99"
   @ 19,27 say EST007->PER_COR picture "9999.999"

   @ 10,63 say EST007->QTD_PED picture "999999999.99"

   @ 12,63 say EST007->CUS_MED picture "999,999,999.99"
   @ 13,63 say EST007->CUS_ULT picture "999,999,999.99"

   @ 15,63 say EST007->DAT_ULT

   @ 18,54 say EST007->GRUPO    picture "@!"
   @ 18,70 say EST007->SUBGRUPO picture "@!"
   @ 19,54 say EST007->COLUNA   picture "@!"
   @ 19,70 say EST007->SUBFATOR picture "@!"

   @ 21,27 say ULTLOTES( 5)
   @ 22,11 say EST007->OBS_MAT picture "@!"
return

/*
-----------------------------------------------------------------------------
                    Funcao ZERA_17
-----------------------------------------------------------------------------
*/
procedure zera_17()

//   X_FORMA   := space(03)
//   X_TIPO    := space(05)
//   X_ESTADO  := space(01)
   X_BIT_MM  := 0.00
   X_ESP_MM  := 0.00
   X_BIT_INT := space(02)
   X_BIT_FN  := space(02)
   X_BIT_FD  := space(02)
   X_ESP_INT := space(02)
   X_ESP_FN  := space(02)
   X_ESP_FD  := space(02)

   X_QTD_KGI := 0.00
   X_QTD_KGC := 0.00
   X_QTD_KGT := 0.00
   X_QTD_MIN := 0.00

   X_QTD_PED := 0.00
   X_TAM_INT := 0.00

   X_QTD_INT := 0
   X_QTD_COR := 0

   X_PER_COR := 0.000
   X_PES_MTR := 0.000
   X_PES_INT := 1.00

   X_CUS_ULT := 0.00
   X_CUS_MED := 0.00

   X_GRUPO   := space(02)
   X_SUBGRUPO:= space(02)
   X_COLUNA  := space(02)
   X_SUBFATOR:= space(02)

   X_OBS_MAT := space(65)
   X_CART_LOT:= space(49)
   X_DAT_ULT := ctod(" ")

return

/*
-----------------------------------------------------------------------------
                    Funcao ATRIBUI_17
-----------------------------------------------------------------------------
*/
procedure atribui_17()

   X_FORMA   := EST007->FORMA
   X_TIPO    := EST007->TIPO
   X_ESTADO  := EST007->ESTADO
   X_BIT_MM  := EST007->BIT_MM
   X_ESP_MM  := EST007->ESP_MM
   X_BIT_INT := EST007->BIT_INT
   X_BIT_FN  := EST007->BIT_FN
   X_BIT_FD  := EST007->BIT_FD
   X_ESP_INT := EST007->ESP_INT
   X_ESP_FN  := EST007->ESP_FN
   X_ESP_FD  := EST007->ESP_FD

   X_QTD_KGI := EST007->QTD_KGI
   X_QTD_KGC := EST007->QTD_KGC
   X_QTD_KGT := EST007->QTD_KGT
   X_QTD_MIN := EST007->QTD_MIN
   X_QTD_PED := EST007->QTD_PED
   X_TAM_INT := EST007->TAM_INT
   X_QTD_INT := EST007->QTD_INT
   X_QTD_COR := EST007->QTD_COR
   X_PER_COR := EST007->PER_COR
   X_PES_MTR := EST007->PES_MTR
   X_PES_INT := EST007->PES_INT
   X_CUS_ULT := EST007->CUS_ULT
   X_CUS_MED := EST007->CUS_MED
   X_OBS_MAT := EST007->OBS_MAT
   X_CART_LOT:= EST007->CART_LOT
   X_DAT_ULT := EST007->DAT_ULT
                                 
   X_GRUPO   := EST007->GRUPO
   X_COLUNA  := EST007->COLUNA
   X_SUBGRUPO:= EST007->SUBGRUPO
   X_SUBFATOR:= EST007->SUBFATOR

return

/*
-----------------------------------------------------------------------------
                    Funcao GRAVA_17()
-----------------------------------------------------------------------------
*/
procedure GRAVA_17( MODO )

   if MODO = "I"
      EST007->( dbappend() )
   else
      while EST007->( ! rlock() ); end
   end

   EST007->FORMA   := X_FORMA
   EST007->TIPO    := X_TIPO
   EST007->ESTADO  := X_ESTADO
   EST007->BIT_MM  := X_BIT_MM
   EST007->ESP_MM  := X_ESP_MM
   EST007->BIT_INT := X_BIT_INT
   EST007->BIT_FN  := X_BIT_FN
   EST007->BIT_FD  := X_BIT_FD
   EST007->ESP_INT := X_ESP_INT
   EST007->ESP_FN  := X_ESP_FN
   EST007->ESP_FD  := X_ESP_FD

   EST007->QTD_KGI := X_QTD_KGI
   EST007->QTD_KGC := X_QTD_KGC
   EST007->QTD_KGT := X_QTD_KGT
   EST007->QTD_MIN := X_QTD_MIN
   EST007->QTD_PED := X_QTD_PED
   EST007->TAM_INT := X_TAM_INT
   EST007->QTD_INT := X_QTD_INT
   EST007->QTD_COR := X_QTD_COR
   EST007->PER_COR := X_PER_COR
   EST007->PES_MTR := X_PES_MTR
   EST007->PES_INT := X_PES_INT
   EST007->CUS_ULT := X_CUS_ULT
   EST007->CUS_MED := X_CUS_MED
   EST007->OBS_MAT := X_OBS_MAT
   EST007->CART_LOT:= X_CART_LOT
   EST007->DAT_ULT := X_DAT_ULT
   EST007->DAT_ULT := X_DAT_ULT
   EST007->GRUPO   := X_GRUPO
   EST007->SUBGRUPO:= X_SUBGRUPO
   EST007->COLUNA  := X_COLUNA
   EST007->SUBFATOR:= X_SUBFATOR

   EST007->( dbunlock() )

return

/*
-----------------------------------------------------------------------------
                    Funcao ULTLOTES
-----------------------------------------------------------------------------
*/
function ULTLOTES( QTDLOTES )

local WLOTES := 0, WRET := " "

EST031->( dbsetorder(3) )
EST031->( dbseek( W_CHAVE_ITEM ) )

while W_CHAVE_ITEM =  EST031->FORMA +EST031->TIPO + str( EST031->BIT_MM, 8, 3 ) + str( EST031->ESP_MM, 8, 3 ) + EST031->ESTADO

   ++WLOTES

   WRET := WRET+' '+EST031->LOTE

   if WLOTES = QTDLOTES
      exit
   end
   EST031->( dbskip() )
end

return WRET


