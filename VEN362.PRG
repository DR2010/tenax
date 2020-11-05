/*
   ven - Vendas
   ven362.prg - Comissao de Vendedor
*/
#include 'inkey.ch'

altd(1)

abrir("VEN002")
abrir("VEN005")
abrir("VEN006")
abrir("VEN008")

status('Cadastro de Comissao De Vendedor')

@ 02,02 say 'ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿'
@ 03,02 say '³                             Comissao De Vendedor                         ³'
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
@ 19,02 say '³                                                                          ³'
@ 20,02 say 'ÃÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´'
@ 21,02 say '³         ³        ³                  ³                 ³                  ³'
@ 22,02 say 'ÀÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ'

//       | Cod       Pedido              Valor        Valor Pago         Data"}
//       | xxx       xxxxxx       9,999,999.99      9,999,999.99     99/99/99 |
//         13 XXXXXXX22    xxxxxxx35          xxxxxx53          xxxxx70

X_CODVEN     := space(02)
X_PEDVEN     := space(05)
X_VALOR      := 0.00
X_VALOR_PAGO := 0.00
X_DATA       := date()

P_HDSEP := "ËÍ"
P_COLSEP := "-"
P_HEADER := {" Cod       Pedido              Valor        Valor Pago         Data"}
P_CAMPOS := {" ' '+VEN008->CODVEN +space(9)+ VEN008->PEDVEN           +" + ;
             " space(7)+transform(VEN008->VALOR     ,'9,999,999.99')  +" + ;
             " space(6)+transform(VEN008->VALOR_PAGO,'9,999,999.99')  +" + ;
             " space(5)+dtoc(VEN008->DATA) "}

VEN008->( dbedit(05,03,18,76,P_CAMPOS,"funcao362",,P_HEADER, P_HDSEP, P_COLSEP))
dbcloseall()

return

/*
-----------------------------------------------------------------------------
                               FUNCAO362
-----------------------------------------------------------------------------
*/
function funcao362( MODE, N )

private TEC := lastkey(), WRETP := 1, W_TELA362 := savescreen(,,,,)

do case
   case TEC == K_ESC ;                  WRETP := 0
   case TEC == K_F1  ; socorro1()     ; WRETP := 1
   case TEC == K_F3  ; p362_incluir() ; WRETP := 2
   case ! eof()
      do case
         case TEC == K_F4  ; p362_alterar()  ; WRETP := 1
         case TEC == K_F5  ; p362_excluir()  ; WRETP := 2
         case TEC == K_F6  ; p362_buscar()   ;  WRETP := 2
      endcase
endcase

status('Cadastro de Comissao de Vendedor')

restscreen(,,,,W_TELA362)

return WRETP

/*
-----------------------------------------------------------------------------
                               p362_incluir()
-----------------------------------------------------------------------------
*/
procedure p362_incluir()

 setcursor(1)
 while .t.
   @ 21,02 say '³         ³        ³                  ³                 ³                  ³'
   
   X_CODVEN     := space(02)
   X_PEDVEN     := space(05)
   X_VALOR      := 0.00
   X_VALOR_PAGO := 0.00
   X_DATA       := date()


   @ 21,04 get X_CODVEN     picture "@!"  valid tes_codven( X_CODVEN )
   @ 21,14 get X_PEDVEN     picture "@!"  valid tes_pedven( X_PEDVEN )
   read
   if lastkey()=K_ESC; exit; end

   VEN008->( dbsetorder(1) )
   VEN008->( dbseek(X_CODVEN+X_PEDVEN) )
   if VEN008->( found() )
      message('Comissao ja cadastrada.')
      loop
   end
   @ 21,27 get X_VALOR      picture "9,999,999.99"
   @ 21,45 get X_VALOR_PAGO picture "9,999,999.99"
   @ 21,62 get X_DATA
   read

   if lastkey() = K_ESC; loop; end
     VEN008->( dbappend() )
     VEN008->CODVEN      := X_CODVEN
     VEN008->PEDVEN      := X_PEDVEN
     VEN008->VALOR       := X_VALOR
     VEN008->VALOR_PAGO  := X_VALOR_PAGO
     VEN008->DATA        := X_DATA
     
     VEN008->( dbunlock() )
  
 end
 keyboard(chr(32))
return

/*
-----------------------------------------------------------------------------
                               p362_alterar()
-----------------------------------------------------------------------------
*/
procedure p362_alterar()

setcursor(1)
while .t.
   @ 21,02 say '³         ³        ³                  ³                 ³                  ³'

   X_CODVEN     := VEN008->CODVEN
   X_PEDVEN     := VEN008->PEDVEN
   X_VALOR      := VEN008->VALOR
   X_VALOR_PAGO := VEN008->VALOR_PAGO
   X_DATA       := VEN008->DATA
   
   @ 21,27 SAY X_VALOR      picture "9,999,999.99"
   @ 21,45 SAY X_VALOR_PAGO picture "9,999,999.99"
   @ 21,62 SAY X_DATA
   
   @ 21,04 get X_CODVEN     picture "@!"  valid tes_codven( X_CODVEN )
   @ 21,14 get X_PEDVEN     picture "@!"  valid tes_pedven( X_PEDVEN )
   read
   if lastkey()=K_ESC; exit; end
   VEN008->( dbsetorder(1) )
   VEN008->( dbseek(X_CODVEN+X_PEDVEN) )
   if VEN008->( ! found() )
      message('Comissao nao cadastrada.')
      loop
   end

   X_VALOR      := VEN008->VALOR
   X_VALOR_PAGO := VEN008->VALOR_PAGO
   X_DATA       := VEN008->DATA

   @ 21,27 get X_VALOR      picture "9,999,999.99"
   @ 21,45 get X_VALOR_PAGO picture "9,999,999.99"
   @ 21,62 get X_DATA
   read

   if lastkey() = K_ESC; loop; end

   while VEN008->( ! rlock() ); end
   VEN008->CODVEN      := X_CODVEN
   VEN008->PEDVEN      := X_PEDVEN
   VEN008->VALOR       := X_VALOR
   VEN008->VALOR_PAGO  := X_VALOR_PAGO
   VEN008->DATA        := X_DATA
   VEN008->( dbunlock() )
end
keyboard(chr(32))
return

/*
-----------------------------------------------------------------------------
                               p362_excluir()
-----------------------------------------------------------------------------
*/
procedure p362_excluir()

if conf('Confirma exclusao de comissao')
   while VEN008->( ! rlock() ); end
   VEN008->( dbdelete())
end

return

/*
-----------------------------------------------------------------------------
                               p362_buscar()
-----------------------------------------------------------------------------
*/
procedure p362_buscar()


setcursor(1)

@ 14,24 say "ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿"
@ 15,24 say '³ Vendedor :             ³'
@ 16,24 say '³ Pedido ..:             ³'
@ 17,24 say "ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ"

sombra(14,24,17,49)

while .t.
   X_CODVEN     := space(02)
   X_PEDVEN     := space(05)

   @ 15,35 get X_CODVEN     picture "@!"  valid tes_codven( X_CODVEN )
   @ 16,35 get X_PEDVEN     picture "@!"  valid tes_pedven( X_PEDVEN )
   read

   if lastkey()=K_ESC; exit; end

   if !VEN008->( dbseek(X_CODVEN , .T.) )
     message('Comissao nao cadastrada.')
     inkey(.5)
     loop
   else
     exit
   end

   setcursor(0)
end
keyboard(chr(32))
return

