/*

   SCM - Sistema de Controle Metalurgico
   EST99.PRG - Cadastro de Lotes

*/

#include "inkey.ch"

setcolor(W_COREDIT)

abrir("EST001")
abrir("EST003")
abrir("EST004")
abrir("EST006")
abrir("EST007")
abrir("EST008")
abrir("EST009")
abrir("EST010")
abrir("EST011")
abrir("EST031")

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

X_OPERACAO := space(01)
X_ALMOXARI := space(03)
X_TIPOMOVI := space(03)
X_DATAMOVI := date() // ctod(' ')
X_QTD_KG   := 0.00
X_QTD_INT  := 0
X_VAL_KG   := 0.00000
X_CUS_ITEM := 0.00000
X_ORIGEM   := space(30)
X_LOTE     := space(05) //novo_lote()

T_BIT      := .F.
T_LARG     := .F.
W_TAM_I    := 0.00


// --> Inicio

While .T.

// status('Movimentacao de Material')

   tela99()
   zera_99()
  @ 03,15 get X_LOTE        picture "@k!"  valid lote99( X_LOTE )
  read
   @ 10,62 say EST031->QTD_KGT
   if lastkey()=K_ESC
      exit
   end

  atribui99()
show99()
   clear gets
  tes_formato()
  tes_tipo()
  tes_estado()
end
/*
-----------------------------------------------------------------------------
                      Funcao ZERA_99
-----------------------------------------------------------------------------
*/
procedure zera_99()

//   X_FORMA    := space(03)
//   X_TIPO     := space(05)
//   X_ESTADO   := space(01)
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
   X_DATAMOVI := date() //ctod(' ')
   X_QTD_KG   := 0.00           // quantidade em Kg
   X_QTD_INT  := 0           // Numero de pecas inteiras
   X_VAL_KG   := 0.00000        // Valor por Kg ( de material )
   X_CUS_ITEM := 0.00000        // Custo por Kg ( de material )
   X_ORIGEM   := space(30)

return

/*
-----------------------------------------------------------------------------
                      Funcao ATRIBUI99
-----------------------------------------------------------------------------
*/
procedure atribui99()

   X_FORMA    := EST031->FORMA
   X_TIPO     := EST031->TIPO
   X_ESTADO   := EST031->ESTADO
   X_BIT_MM   := EST031->BIT_MM
   X_ESP_MM   := EST031->ESP_MM
   X_BIT_INT  := EST031->BIT_INT
   X_BIT_FN   := EST031->BIT_FN
   X_BIT_FD   := EST031->BIT_FD
   X_ESP_INT  := EST031->ESP_INT
   X_ESP_FN   := EST031->ESP_FN
   X_ESP_FD   := EST031->ESP_FD
//   X_OPERACAO := EST031->OPERACAO
//   X_ALMOXARI := EST031->ALMOXARI
//   X_TIPOMOVI := EST031->TIPOMOVI
//   X_DATAMOVI := EST031->DATAMOVI
//   X_QTD_KG   := EST031->QTD_KG
   X_QTD_INT  := EST031->QTD_INT
//   X_VAL_KG   := EST031->VAL_KG
   X_ORIGEM   := EST031->ORIGEM

return

/*
-----------------------------------------------------------------------------
                      Funcao GRAVA_99()
-----------------------------------------------------------------------------
*/
procedure GRAVA_99( MODO )

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

// EST010->( dbunlock() )

return

/*
-----------------------------------------------------------------------------
                      Funcao ATUAL_99

 > Atualiza a quantidade em Kg e o numero de pecas INTEIRAS.
-----------------------------------------------------------------------------
*/
procedure ATUAL_99( )

   EST007->( dbsetorder( 1 ) )
   EST007->( dbseek( W_CHAVE_ITEM ) )

   while EST007->( ! rlock() ); end

   while EST031->( ! rlock() ); end

   EST007->QTD_KGI  := EST007->QTD_KGI + X_QTD_KG
   EST007->QTD_KGT  := EST007->QTD_KGT + X_QTD_KG
   EST007->QTD_INT  := EST007->QTD_INT + X_QTD_INT

   EST031->QTD_KGT  := EST031->QTD_KGT + X_QTD_KG
   EST031->QTD_INT  := EST031->QTD_INT + X_QTD_INT


   // calcula custo medio por KG
   EST007->CUS_MED  := (EST007->CUS_ULT * EST007->QTD_KGT + X_CUS_ITEM * X_QTD_KG ) / ;
                        EST007->QTD_KGT + X_QTD_KG

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

   status ( 'Escolha Op‡ao Desejada Altera‡„o / Exclus„o ' )
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
                      Procedimento Tela
-----------------------------------------------------------------------------
*/
procedure TELA99()

   @ 02,02 say 'ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿'
   @ 03,02 say '³  Num. Lote:                                                              ³'
   @ 04,02 say '³                                                                          ³'
   @ 05,02 say '³  Forma    :       -                                                      ³'
   @ 06,02 say '³  Tipo     :       -                                                      ³'
   @ 07,02 say '³  Estado   :       -                                                      ³'
   @ 08,02 say '³  Bit./Esp.:      /                                                       ³'
   @ 09,02 say '³  Bit./Larg:      /                                                       ³'
   @ 10,02 say '³                                          Qtd. em KG.....:                ³'
   @ 11,02 say '³                                                                          ³'
   @ 12,02 say '³                                                                          ³'
   @ 13,02 say '³                                                                          ³'
   @ 14,02 say '³                                                                          ³'
   @ 15,02 say '³                                                                          ³'
   @ 16,02 say '³                                                                          ³'
   @ 17,02 say '³                                                                          ³'
   @ 18,02 say '³                                                                          ³'
   @ 19,02 say '³                                                                          ³'
   @ 20,02 say '³                                                                          ³'
   @ 21,02 say '³                                                                          ³'
   @ 22,02 say 'ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ'
return


/*
-----------------------------------------------------------------------------
                      Funcao tesn_lote
-----------------------------------------------------------------------------
*/
function lote99( VAR )

   local WRET := .T.

   X_LOTE := VAR := zerofill( VAR )

   EST031->( dbsetorder(1) )
   EST031->( dbseek( VAR ) )

   if EST031->( ! found() )
      mensbeep(" N£mero de Lote n„o existente.<ENTER>")
      WRET := .F.
   else
      WRET := .T.
   end
return WRET

/*
-----------------------------------------------------------------------------
                      Funcao SHOW99()
-----------------------------------------------------------------------------
*/
procedure SHOW99()

      @ 05,16 get X_FORMA    picture "@!"     valid tes_formato()
      @ 06,16 get X_TIPO     picture "@!"     valid tes_tipo()
      @ 07,16 get X_ESTADO   picture "@!"     valid tes_estado()
      @ 08,16 get X_BIT_INT  picture "99"     valid tes_bitola() when T_BIT
      @ 08,19 get X_BIT_FN   picture "99"     when T_BIT
      @ 08,22 get X_BIT_FD   picture "99"     valid calc_bit() when T_BIT
      @ 08,25 get X_BIT_MM   picture "99999.999"   when ( val(X_BIT_INT) + ;
			     val(X_BIT_FN)+val(X_BIT_FD) = 0 ) .and. T_BIT

      @ 09,16 get X_ESP_INT  picture "99"      valid tes_espessura() when T_LARG
      @ 09,19 get X_ESP_FN   picture "99"      when T_LARG
      @ 09,22 get X_ESP_FD   picture "99"      valid calc_esp() when T_LARG
      @ 09,25 get X_ESP_MM   picture "99999.999" when ( val(X_ESP_INT)+;
			     val(X_ESP_FN)+val(X_ESP_FD) = 0 ) .and. ( T_LARG )


return

