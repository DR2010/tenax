/*
   ven - Vendas
   ven363.prg - Comissao de Comprador
*/
#include 'inkey.ch'

altd(1)

abrir("VEN001")
abrir("VEN005")
abrir("VEN010")

status('Comissao De Comprador')

@ 02,02 say 'ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿'
@ 03,02 say '³                             Comissao de Comprador                        ³'
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

//       | Cliente   Pedido              Valor        Valor Pago         Data"}
//       | xxxxx     xxxxxx       9,999,999.99      9,999,999.99     99/99/99 |
//         13   XXXXX22    xxxxxxx35          xxxxxx53          xxxxx70

X_CODCLI     := space(05)
X_PEDVEN     := space(05)
X_VALOR      := 0.00
X_VALOR_PAGO := 0.00
X_DATA       := date()

P_HDSEP := "ËÍ"
P_COLSEP := "-"
P_HEADER := {" Cod       Pedido              Valor        Valor Pago       Data"}
P_CAMPOS := {" ' '+ven010->CODCLI +space(5)+ ven010->PEDVEN           +" + ;
             " space(7)+transform(ven010->VALOR     ,'9,999,999.99')  +" + ;
             " space(6)+transform(ven010->VALOR_PAGO,'9,999,999.99')  +" + ;
             " space(5)+dtoc(ven010->DATA) "}

ven010->( dbedit(05,03,18,76,P_CAMPOS,"funcao363",,P_HEADER, P_HDSEP, P_COLSEP))
dbcloseall()

return

/*
-----------------------------------------------------------------------------
                               FUNCAO363
-----------------------------------------------------------------------------
*/
function funcao363( MODE, N )

private TEC := lastkey(), WRETP := 1, W_TELA363 := savescreen(,,,,)

do case
   case TEC == K_ESC ;                  WRETP := 0
   case TEC == K_F1  ; socorro1()     ; WRETP := 1
   case TEC == K_F3  ; p363_incluir() ; WRETP := 2
   case ! eof()
      do case
         case TEC == K_F4  ; p363_alterar()  ; WRETP := 1
         case TEC == K_F5  ; p363_excluir()  ; WRETP := 2
         case TEC == K_F6  ; p363_buscar()   ; WRETP := 2
      endcase
endcase

status('Comissao de Comprador')

restscreen(,,,,W_TELA363)

return WRETP

/*
-----------------------------------------------------------------------------
                               p363_incluir()
-----------------------------------------------------------------------------
*/
procedure p363_incluir()

setcursor(1)

X_CODCLI     := space(05)
X_PEDVEN     := space(05)
X_VALOR      := 0.00
X_VALOR_PAGO := 0.00
X_DATA       := date()
while .t.
   @ 21,02 say '³         ³        ³                  ³                 ³                  ³'


   @ 21,04 get X_CODCLI     picture "@!"  valid tes_codcli( X_CODCLI )
   @ 21,14 get X_PEDVEN     picture "@!"  valid tes_pedven( X_PEDVEN )
   read
   if lastkey()=K_ESC; exit; end

   ven010->( dbsetorder(1) )
   ven010->( dbseek(X_CODCLI+X_PEDVEN) )
   if ven010->( found() )
      message('Comissao ja cadastrada.')
      loop
   end
   @ 21,27 get X_VALOR      picture "9,999,999.99"
   @ 21,45 get X_VALOR_PAGO picture "9,999,999.99"
   @ 21,62 get X_DATA
   read

   if lastkey() = K_ESC; loop; end

   ven010->( dbappend() )
   ven010->CODCLI      := X_CODCLI
   ven010->PEDVEN      := X_PEDVEN
   ven010->VALOR       := X_VALOR
   ven010->VALOR_PAGO  := X_VALOR_PAGO
   ven010->DATA        := X_DATA
   ven010->( dbunlock() )
   X_CODCLI     := space(05)
   X_PEDVEN     := space(05)
   X_VALOR      := 0.00
   X_VALOR_PAGO := 0.00
   X_DATA       := date()

end
KEYBOARD(CHR(32))
return

/*
-----------------------------------------------------------------------------
                               p363_alterar()
-----------------------------------------------------------------------------
*/
procedure p363_alterar()

setcursor(1)
while .t.
   @ 21,02 say '³         ³        ³                  ³                 ³                  ³'

   X_CODCLI     := ven010->CODCLI
   X_PEDVEN     := ven010->PEDVEN
   X_VALOR      := ven010->VALOR
   X_VALOR_PAGO := ven010->VALOR_PAGO
   X_DATA       := ven010->DATA
   
   @ 21,27 SAY X_VALOR      picture "9,999,999.99"
   @ 21,45 SAY X_VALOR_PAGO picture "9,999,999.99"
   @ 21,62 SAY X_DATA

   @ 21,04 get X_CODCLI     picture "@!"  valid tes_codcli( X_CODCLI )
   @ 21,14 get X_PEDVEN     picture "@!"  valid tes_pedven( X_PEDVEN )
   read
   if lastkey()=K_ESC; exit; end

   ven010->( dbsetorder(1) )
   ven010->( dbseek(X_CODCLI+X_PEDVEN) )
   if ven010->( ! found() )
      message('Comissao nao cadastrada.')
      loop
   end

   X_VALOR      := ven010->VALOR
   X_VALOR_PAGO := ven010->VALOR_PAGO
   X_DATA       := ven010->DATA

   @ 21,27 get X_VALOR      picture "9,999,999.99"
   @ 21,45 get X_VALOR_PAGO picture "9,999,999.99"
   @ 21,62 get X_DATA
   read

   if lastkey() = K_ESC; loop; end

   while ven010->( ! rlock() ); end
   ven010->CODCLI      := X_CODCLI
   ven010->PEDVEN      := X_PEDVEN
   ven010->VALOR       := X_VALOR
   ven010->VALOR_PAGO  := X_VALOR_PAGO
   ven010->DATA        := X_DATA
   ven010->( dbunlock() )
end

return

/*
-----------------------------------------------------------------------------
                               p363_excluir()
-----------------------------------------------------------------------------
*/
procedure p363_excluir()

if conf('Confirma exclusao de comissao')
   while ven010->( ! rlock() ); end
   ven010->( dbdelete())
end

return

/*
-----------------------------------------------------------------------------
                               p363_buscar()
-----------------------------------------------------------------------------
*/
procedure p363_buscar()


setcursor(1)

@ 14,24 say "ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿"
@ 15,24 say '³ Cliente..:             ³'
@ 16,24 say '³ Pedido...:             ³'
@ 17,24 say "ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ"

sombra(14,24,17,49)

while .t.
   X_CODCLI     := space(05)
   X_PEDVEN     := space(05)

   @ 15,36 get X_CODCLI     picture "@!"  valid tes_codcli( X_CODCLI )
   @ 16,36 get X_PEDVEN     picture "@!"  valid tes_pedven( X_PEDVEN )
   read

   if lastkey()=K_ESC; exit; end

   if !ven010->( dbseek(X_CODCLI , .T.) )
     message('Nao foi encontrado !')
     inkey(.5)
     message('                    ')
     loop
   else 
     exit
   endif

   setcursor(0)
end
keyboard(chr(32))
return


