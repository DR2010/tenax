/*

   SCM - Sistema de Controle Metalurgico
   EST18.PRG - Movimentacao de material

*/
#include "inkey.ch"
set key K_F7 to tela_peca_cort
set key K_F8 to tela_ped_compra
set key K_F9 to tela_bloquinho

setcolor(W_COREDIT)
abrir("EST001")
abrir("EST002")
abrir("EST003")
abrir("EST004")
abrir("EST005")
abrir("EST006")
abrir("EST007")
abrir("EST008")
abrir("EST009")
abrir("EST010")
abrir("EST011")
abrir("EST031")
abrir("EST040") // Caixote

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
X_SUBFORMA := space(01)
X_LARGMOV  := 0
X_COMPMOV  := 0
X_LARGSOB  := 0
X_COMPSOB  := 0
X_QTDPECAS := 0
X_N_BLOQ   := 0
X_QSOBCOR  := 0
X_QSOBBLO  := 0

X_OPERACAO := space(01)
X_ALMOXARI := space(03)
X_TIPOMOVI := space(03)
X_DATAMOVI := date() // ctod(' ')
X_QTD_KG   := 0.00
X_QTD_INT  := 0
X_VAL_KG   := 0.00000
X_SUCATA   := 0.00000
X_CUS_ITEM := 0.00000
X_ORIGEM   := space(30)
X_LOTE     := space(05) //novo_lote()

T_BIT      := .F.
T_LARG     := .F.
W_TAM_I    := 0.00


// --> Inicio

While .T.

   status('Movimenta‡„o de Material')

   tela_18()
   zera_18()
   get_mainkey()
   read
   if lastkey()=K_ESC
      exit
   end

   W_CHAVE_ITEM := ( X_FORMA+ X_TIPO+ ;
                str( X_BIT_MM, 8, 3 ) + str( X_ESP_MM, 8, 3 ) + X_ESTADO )

   // caso encontre o material...
   if ver_material( W_CHAVE_ITEM )
      get_18()
   else
      mensbeep("Material N„o Cadastrado.<ENTER>")
   end
End

dbcloseall()

// --> Fim


/*
-----------------------------------------------------------------------------
                      Procedimento Tela
-----------------------------------------------------------------------------
*/
procedure TELA_18()

   telanum('SCR18 ','EST18 ')
   @ 02,02 say 'ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿'
   @ 03,02 say '³                                                                          ³'
   @ 04,02 say '³                                                     Opera‡„o (E/S) :     ³'
   @ 05,02 say '³  Forma    :       -                                                      ³'
   @ 06,02 say '³  Tipo     :       -                                                      ³'
   @ 07,02 say '³  Estado   :       -                                                      ³'
   @ 08,02 say '³  Bit./Esp.:      /                                                       ³'
   @ 09,02 say '³  Bit./Larg:      /                       Peso por Metro :                ³'
   @ 10,02 say '³                                          Qtd. em KG.....:                ³'
   @ 11,02 say '³  Almoxarifado :     -                                                    ³'
   @ 12,02 say '³                                                                          ³'
   @ 13,02 say '³  Tipo de Movimenta‡„o :     -                                            ³'
   @ 14,02 say '³                                                                          ³'
   @ 15,02 say '³  Data da Movimenta‡„o :                                                  ³'
   @ 16,02 say '³                                                                          ³'
   @ 17,02 say '³                                                                          ³'
   @ 18,02 say '³                                                                          ³'
   @ 19,02 say '³                                                                          ³'
   @ 20,02 say '³                                                                          ³'
   @ 21,02 say '³                                                                          ³'
   @ 22,02 say 'ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ'
   @ 23,02 say '                                                                      Est18'
return

/*
-----------------------------------------------------------------------------
                      Funcao TELA_181
-----------------------------------------------------------------------------
*/
function tela_181()


   telanum('SCR18 ','EST18 ')
   @ 16,02 say '³                                                                          ³'
   IF X_OPERACAO = 'E'
     @ 17,02 say '³  Qtd. Pecas   :                     Qtd. em Kg :                         ³'
   ELSE
     @ 17,02 say '³  Qtd. em Kg   :                     Qtd. Pecas :                         ³'
   end
   @ 18,02 say '³                                                                          ³'
   @ 19,02 say '³  Pre‡o por Kg :                   Custo por Kg :                         ³'
   @ 20,02 say '³                                                                          ³'
   @ 21,02 say '³  Origem :                                                                ³'
   @ 22,02 say 'ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ'
   @ 23,02 say '                                                                      Est18'
return

/*
-----------------------------------------------------------------------------
                      Funcao GET_18
-----------------------------------------------------------------------------
*/
function get_18()
   local WRET := .T.

   @ 04,73 get X_OPERACAO picture "!" valid X_OPERACAO $ "ES"
   read
   @ 09,62 say EST007->PES_MTR
   @ 10,62 say EST007->QTD_KGT

   if X_OPERACAO = "E"
      status('Entrada de Material')
      tela_181()

      while .t.
         @ 11,20 get X_ALMOXARI picture "@!" valid TES_ALMOXA( X_ALMOXARI, 2 )
         @ 13,28 get X_TIPOMOVI picture "@!" valid TES_MOVIME( X_TIPOMOVI )
         read

         if lastkey()=K_ESC; exit; end

         EST011->( dbsetorder(1) )
         EST011->( dbseek( X_TIPOMOVI ))

         @ 15,28 get X_DATAMOVI
         @ 17,27 get X_QTD_INT  picture "99999"      valid EST011->ACERTO = 'S';
                                .OR. ( X_QTD_INT > 0 .AND. EST011->ACERTO = 'N')
         @ 17,53 get X_QTD_KG   picture "9999999.99" valid EST011->ACERTO = 'S';
                                .OR. ( X_QTD_KG  > 0 .AND. EST011->ACERTO = 'N')

         @ 19,20 get X_VAL_KG   picture "999.99999"  when EST011->ACERTO = 'N'
         @ 19,53 get X_CUS_ITEM picture "999.99999"  when EST011->ACERTO = 'N'
         @ 21,14 get X_ORIGEM   picture "@!"
         read

         if lastkey()=K_ESC; exit; end

         if x_tipomovi="004"
            if conf('Confirma Dados')
              grava_18('I')
              atual_18()
            end
           exit
        end

        if EST011->ACERTO = 'N'
           it23_lote()
        end

        if conf('Confirma Dados')
           grava_18('I')
           atual_18() // atualiza quantidade em estoque, ou seja,
                      // QTD_KGT -> quantidade total em Kg;
                      // QTD_KGI -> quantidade em Kg de pecas inteiras;
                      // QTD_INT -> numero de pecas inteiras
           exit
        end
      end
   else
      est19()
      if lastkey() # K_ESC
         grava_18('I')
      end
   end
return WRET


/*
-----------------------------------------------------------------------------
                      Funcao SHOW_18
-----------------------------------------------------------------------------
*/
procedure SHOW_18()

   @ 04,73 say EST010->OPERACAO
   @ 11,20 say EST010->ALMOXARI
   @ 13,28 say EST010->TIPOMOVI
   @ 15,63 say EST010->DATAMOVI
   @ 17,27 say EST010->QTD_KG
   @ 17,53 say EST010->QTD_INT
   @ 19,20 say EST010->VAL_KG
   @ 21,14 say EST010->ORIGEM

return

/*
-----------------------------------------------------------------------------
                      Funcao ZERA_18
-----------------------------------------------------------------------------
*/
procedure zera_18()

   X_BIT_MM   := 0.00
   X_ESP_MM   := 0.00
   X_BIT_INT  := space(02)
   X_BIT_FN   := space(02)
   X_BIT_FD   := space(02)
   X_ESP_INT  := space(02)
   X_ESP_FN   := space(02)
   X_ESP_FD   := space(02)
   X_OPERACAO := space(01)
   X_ALMOXARI := space(03)
   X_TIPOMOVI := space(03)
   X_DATAMOVI := date()
   X_QTD_KG   := 0.00           // quantidade em Kg
   X_QTD_INT  := 0              // Numero de pecas inteiras
   X_VAL_KG   := 0.00000        // Valor por Kg ( de material )
   X_CUS_ITEM := 0.00000        // Custo por Kg ( de material )
   X_ORIGEM   := space(30)
   X_SUBFORMA := space(1)

return

/*
-----------------------------------------------------------------------------
                      Funcao ATRIBUI_18
-----------------------------------------------------------------------------
*/
procedure atribui_18()

   X_FORMA    := EST010->FORMA
   X_TIPO     := EST010->TIPO
   X_ESTADO   := EST010->ESTADO
   X_BIT_MM   := EST010->BIT_MM
   X_ESP_MM   := EST010->ESP_MM
   X_BIT_INT  := EST010->BIT_INT
   X_BIT_FN   := EST010->BIT_FN
   X_BIT_FD   := EST010->BIT_FD
   X_ESP_INT  := EST010->ESP_INT
   X_ESP_FN   := EST010->ESP_FN
   X_ESP_FD   := EST010->ESP_FD
   X_OPERACAO := EST010->OPERACAO
   X_ALMOXARI := EST010->ALMOXARI
   X_TIPOMOVI := EST010->TIPOMOVI
   X_DATAMOVI := EST010->DATAMOVI
   X_QTD_KG   := EST010->QTD_KG
   X_QTD_INT  := EST010->QTD_INT
   X_VAL_KG   := EST010->VAL_KG
   X_ORIGEM   := EST010->ORIGEM
   X_SUBFORMA := EST010->SUBFORMA

return

/*
-----------------------------------------------------------------------------
                      Funcao GRAVA_18()
-----------------------------------------------------------------------------
*/
procedure GRAVA_18( MODO )

   if MODO = "I"
      EST010->( dbappend() )
   else
      while EST007->( ! rlock() ); end
   end

   while EST010->( ! rlock() ); end

   EST010->FORMA    := X_FORMA
   EST010->TIPO     := X_TIPO
   EST010->ESTADO   := X_ESTADO
   EST010->BIT_MM   := X_BIT_MM
   EST010->ESP_MM   := X_ESP_MM
   EST010->BIT_INT  := X_BIT_INT
   EST010->BIT_FN   := X_BIT_FN
   EST010->BIT_FD   := X_BIT_FD
   EST010->ESP_INT  := X_ESP_INT
   EST010->ESP_FN   := X_ESP_FN
   EST010->ESP_FD   := X_ESP_FD
   EST010->OPERACAO := X_OPERACAO
   EST010->ALMOXARI := X_ALMOXARI
   EST010->TIPOMOVI := X_TIPOMOVI
   EST010->DATAMOVI := X_DATAMOVI
   EST010->QTD_KG   := X_QTD_KG
   EST010->QTD_INT  := X_QTD_INT
   EST010->VAL_KG   := X_VAL_KG
   EST010->ORIGEM   := X_ORIGEM

   EST010->( dbunlock() )

return

/*
-----------------------------------------------------------------------------
                      Funcao ATUAL_18

 > Atualiza a quantidade em Kg e o numero de pecas INTEIRAS.
-----------------------------------------------------------------------------
*/
procedure ATUAL_18()

   EST007->( dbsetorder( 1 ) )
   EST007->( dbseek( W_CHAVE_ITEM ) )

   while EST007->( ! rlock() ); end

   while EST031->( ! rlock() ); end

   EST007->QTD_KGI  := EST007->QTD_KGI + X_QTD_KG
   EST007->QTD_INT  := EST007->QTD_INT + X_QTD_INT

   //
   // Nao calcula preco medio caso seja acerto
   //
   if EST011->ACERTO = 'S'
      // calcula custo medio por KG
      EST007->CUS_MED  :=( ( X_CUS_ITEM * X_QTD_KG ) + ( EST007->CUS_MED * EST007->QTD_KGT ) ) / ;
                           ( EST007->QTD_KGT + X_QTD_KG )
   end

   // atualiza quantidade de quilo depois do calculo
   EST007->QTD_KGT  := EST007->QTD_KGT + X_QTD_KG

   EST007->DAT_ULT  := X_DATAMOVI
   EST007->CUS_ULT  := X_CUS_ITEM

   EST007->( dbunlock() )

return

/*
-----------------------------------------------------------------------------
                          Funcao ESP_ALT
-----------------------------------------------------------------------------
*/
static function esp_alt()

   local TEC

   status ( 'Escolha Op‡„o Desejada Altera‡„o / Exclus„o ' )
   @ 24,41 prompt "Alteracao"
   @ 24,53 prompt "Exclusao"
   menu to TEC

   do case
   case TEC = 1
      WRET := "A"
   case TEC = 2
      WRET := "E"
   case TEC = 0  // ESC
      WRET := "*"
   endcase

return ( WRET )

/*
-----------------------------------------------------------------------------
                          Funcao CALC_INT
-----------------------------------------------------------------------------
*/
function CALC_INT( X_VAL )
   local WRET := 0

   EST007->( dbsetorder(1))
   EST007->( dbseek(W_CHAVE_ITEM))

   if EST007->PES_INT > 0
      WRET := X_VAL/EST007->PES_INT
   end

   X_QTD_INT := WRET

return .T.
