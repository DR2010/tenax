

/*
   ven - Vendas
   ven365.prg - Pagamento de Comprador
*/
#include 'inkey.ch'

altd(1)

abrir("VEN001")
abrir("VEN011")

status('Pagamento de Comprador')

@ 02,02 say '旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴커'
@ 03,02 say '�                             Pagamento de Comprador                       �'
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

//       | Cliente   Data                Valor"}
//       | xxxxx     99/99/99     9,999,999.99 |
//         13   XXXXX22    xxxxxxx35

X_CODCLI     := space(05)
X_VALOR      := 0.00
X_DATA       := date()

P_HDSEP := "箇"
P_COLSEP := "-"
P_HEADER := {" Cliente            Data            Valor        "}
P_CAMPOS := {" ' '+VEN011->CODCLI +space(5)+ " + ;
             " space(5)+dtoc(VEN011->DATA) + " + ;
             " space(7)+transform(VEN011->VALOR ,'9,999,999.99')  " }

VEN011->( dbedit(05,03,18,76,P_CAMPOS,"funcao365",,P_HEADER, P_HDSEP, P_COLSEP))
dbcloseall()

return

/*
-----------------------------------------------------------------------------
                               FUNCAO365
-----------------------------------------------------------------------------
*/
function funcao365( MODE, N )

private TEC := lastkey(), WRETP := 1, W_TELA365 := savescreen(,,,,)

do case
   case TEC == K_ESC ;                  WRETP := 0
   case TEC == K_F1  ; socorro1()     ; WRETP := 1
   case TEC == K_F3  ; p365_incluir() ; WRETP := 2
   case ! eof()
      do case
         case TEC == K_F4  ; p365_alterar()  ; WRETP := 1
         case TEC == K_F5  ; p365_excluir()  ; WRETP := 2
         case TEC == K_F6  ; p365_buscar()   ;  WRETP := 2
      endcase
endcase

status('Pagamento de Vendedor')

restscreen(,,,,W_TELA365)

return WRETP

/*
-----------------------------------------------------------------------------
                               p365_incluir()
-----------------------------------------------------------------------------
*/
procedure p365_incluir()

setcursor(1)

X_CODCLI     := space(05)
X_VALOR      := 0.00
X_DATA       := date()

while .t.

   @ 21,04 get X_CODCLI     picture "@!"  valid tes_CODCLI( X_CODCLI )
   read
   if lastkey()=K_ESC; exit; end
   @ 21,27 get X_DATA
   @ 21,62 get X_VALOR      picture "9,999,999.99"

   read

   if lastkey() = K_ESC; loop; end
   if conf('Confirma inclusao')
     VEN011->( dbappend() )
     VEN011->CODCLI      := X_CODCLI
     VEN011->VALOR       := X_VALOR
     VEN011->DATA        := X_DATA
     VEN011->( dbunlock() )
     X_CODCLI     := space(05)
     X_VALOR      := 0.00
     X_DATA       := date()
     @ 21,02 say '�         �        �                  �                 �                  �'
   endif
end
keyboard(chr(32))
return

/*
-----------------------------------------------------------------------------
                               p365_alterar()
-----------------------------------------------------------------------------
*/
procedure p365_alterar()

setcursor(1)
while .t.
  
   X_CODCLI     := VEN011->CODCLI
   X_VALOR      := VEN011->VALOR
   X_DATA       := VEN011->DATA
   
   @ 21,62 say X_DATA
   @ 21,27 say X_VALOR      picture "9,999,999.99"

   @ 21,04 get X_CODCLI     picture "@!"  valid tes_CODCLI( X_CODCLI )
   read
   if lastkey()=K_ESC; exit; end

   X_VALOR      := VEN011->VALOR
   X_DATA       := VEN011->DATA

   @ 21,62 get X_DATA
   @ 21,27 get X_VALOR      picture "9,999,999.99"
   read

   if lastkey() = K_ESC; loop; end
   if conf('Confirma a alteracao')
     while VEN011->( ! rlock() ); end
     VEN011->CODCLI      := X_CODCLI
     VEN011->VALOR       := X_VALOR
     VEN011->DATA        := X_DATA
     VEN011->( dbunlock() )
     @ 21,02 say '�         �        �                  �                 �                  �'
  end
end
keyboard(chr(32))
return

/*
-----------------------------------------------------------------------------
                               p365_excluir()
-----------------------------------------------------------------------------
*/
procedure p365_excluir()

if conf('Confirma exclusao do Pagamento')
   while VEN011->( ! rlock() ); end
   VEN011->( dbdelete())
end

return

/*
-----------------------------------------------------------------------------
                               p365_buscar()
-----------------------------------------------------------------------------
*/
procedure p365_buscar()

setcursor(1)

@ 14,24 say "旼컴컴컴컴컴컴컴컴컴컴컴커"
@ 15,24 say '� Cliente..:             �'
@ 16,24 say "읕컴컴컴컴컴컴컴컴컴컴컴켸"

sombra(14,24,16,49)

while .t.
   X_CODCLI     := space(05)

   @ 15,35 get X_CODCLI     picture "@!"  valid tes_CODCLI( X_CODCLI )
   read

   if lastkey()=K_ESC; exit; end
   if !VEN011->( dbseek(X_CODCLI , .T.) )
     message('Nao encontrado !')
     inkey(.5)
     message('                ')
     loop
   else
     exit
   endif

   setcursor(0)
end

return



