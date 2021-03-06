
/*
   ven - Vendas
   ven364.prg - Pagamento de Vendedor
*/
#include 'inkey.ch'

altd(1)

abrir("VEN002")
abrir("VEN009")

status('Pagamento de Vendedor')

@ 02,02 say '旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴커'
@ 03,02 say '�                             Pagamento de Vendedor                        �'
@ 04,02 say '쳐컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴캑'
@ 05,02 say '�                                                                          �'
@ 06,02 say '�                                                                          �'
@ 07,02 say '�                                                                          �'
@ 08,02 say '�                                                                          �'
@ 09,02 say '�                                                                          �'
@ 10,02 say '�                                                                          �'
@ 11,02 say '�                                                                          �'
@ 12,02 say '�                                                                          �'
@ 13,02 say '�                                                                          �'
@ 14,02 say '�                                                                          �'
@ 15,02 say '�                                                                          �'
@ 16,02 say '�                                                                          �'
@ 17,02 say '�                                                                          �'
@ 18,02 say '�                                                                          �'
@ 19,02 say '�                                                                          �'
@ 20,02 say '쳐컴컴컴컴쩡컴컴컴컫컴컴컴컴컴컴컴컴컴쩡컴컴컴컴컴컴컴컴쩡컴컴컴컴컴컴컴컴캑'
@ 21,02 say '�         �        �                  �                 �                  �'
@ 22,02 say '읕컴컴컴컴좔컴컴컴컨컴컴컴컴컴컴컴컴컴좔컴컴컴컴컴컴컴컴좔컴컴컴컴컴컴컴컴켸'

//       | Cod       Data                Valor"}
//       | xxx       99/99/99     9,999,999.99 |
//         13 XXXXXXX22    xxxxxxx35

X_CODVEN     := space(02)
X_VALOR      := 0.00
X_DATA       := date()

P_HDSEP := "箇"
P_COLSEP := "-"
P_HEADER := {" Cod          Data                Valor     "}
P_CAMPOS := {" ' '+VEN009->CODVEN +space(7)+ " + ;
             " space(5)+dtoc(VEN009->DATA) + " + ;
             " space(7)+transform(VEN009->VALOR ,'9,999,999.99')  " }

VEN009->( dbedit(05,03,18,76,P_CAMPOS,"funcao364",,P_HEADER, P_HDSEP, P_COLSEP))
dbcloseall()

return

/*
-----------------------------------------------------------------------------
                               FUNCAO364
-----------------------------------------------------------------------------
*/
function funcao364( MODE, N )

private TEC := lastkey(), WRETP := 1, W_TELA364 := savescreen(,,,,)

do case
   case TEC == K_ESC ;                  WRETP := 0
   case TEC == K_F1  ; socorro1()     ; WRETP := 1
   case TEC == K_F3  ; p364_incluir() ; WRETP := 2
   case ! eof()
      do case
         case TEC == K_F4  ; p364_alterar()  ; WRETP := 1
         case TEC == K_F5  ; p364_excluir()  ; WRETP := 2
         case TEC == K_F6  ; p364_buscar()   ;  WRETP := 2
      endcase
endcase

status('Pagamento de Vendedor')

restscreen(,,,,W_TELA364)

return WRETP

/*
-----------------------------------------------------------------------------
                               p364_incluir()
-----------------------------------------------------------------------------
*/
procedure p364_incluir()

setcursor(1)

while .t.
   @ 21,02 say '�         �        �                  �                 �                  �'

   X_CODVEN     := space(02)
   X_VALOR      := 0.00
   X_DATA       := date()

   @ 21,04 get X_CODVEN     picture "@!"  valid tes_codven( X_CODVEN )
   read
   if lastkey()=K_ESC; exit; end
   @ 21,27 get X_DATA
   @ 21,62 get X_VALOR      picture "9,999,999.99"

   read

   if lastkey() = K_ESC; loop; end

   VEN009->( dbappend() )
   VEN009->CODVEN      := X_CODVEN
   VEN009->VALOR       := X_VALOR
   VEN009->DATA        := X_DATA
   VEN009->( dbunlock() )
end
keyboard(chr(32))
return

/*
-----------------------------------------------------------------------------
                               p364_alterar()
-----------------------------------------------------------------------------
*/
procedure p364_alterar()

setcursor(1)
while .t.
   @ 21,02 say '�         �        �                  �                 �                  �'

   X_CODVEN     := VEN009->CODVEN
   X_VALOR      := VEN009->VALOR
   X_DATA       := VEN009->DATA

   @ 21,04 get X_CODVEN     picture "@!"  valid tes_codven( X_CODVEN )
   read
   if lastkey()=K_ESC; exit; end

   X_VALOR      := VEN009->VALOR
   X_DATA       := VEN009->DATA

   @ 21,27 get X_DATA
   @ 21,62 get X_VALOR      picture "9,999,999.99"
   read

   if lastkey() = K_ESC; loop; end

   while VEN009->( ! rlock() ); end
   VEN009->CODVEN      := X_CODVEN
   VEN009->VALOR       := X_VALOR
   VEN009->DATA        := X_DATA
   VEN009->( dbunlock() )
end
keyboard(chr(32))
return

/*
-----------------------------------------------------------------------------
                               p364_excluir()
-----------------------------------------------------------------------------
*/
procedure p364_excluir()

if conf('Confirma exclusao do Pagamento')
   while VEN009->( ! rlock() ); end
   VEN009->( dbdelete())
end

return

/*
-----------------------------------------------------------------------------
                               p364_buscar()
-----------------------------------------------------------------------------
*/
procedure p364_buscar()

setcursor(1)

@ 14,24 say "旼컴컴컴컴컴컴컴컴컴컴컴커"
@ 15,24 say '� Vendedor :             �'
@ 16,24 say "읕컴컴컴컴컴컴컴컴컴컴컴켸"

sombra(14,24,16,49)

while .t.
   X_CODVEN     := space(02)

   @ 15,35 get X_CODVEN     picture "@!"  valid tes_codven( X_CODVEN )
   read

   if lastkey()=K_ESC; exit; end

   if !VEN009->( dbseek(X_CODVEN , .T.) )
     message('Codigo de vendedor nao cadastrado !!')
     inkey(.5)
     message('                                    ')
     loop
   else
     exit
   end
   setcursor(0)
end
keyboard(chr(32))
return


