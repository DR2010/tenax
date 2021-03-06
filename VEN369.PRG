/*
   VEN - VENDAS
   VEN369.PRG - Tabela de Precos
*/

abrir("VEN018")
abrir("VEN019")

status(' Medida de Sub Grupo ')

@ 06,10 say '旼컴컴컴쩡컴컴컴컴컴쩡컴컴컴컫컴컴컴컴컴컴컫컴컴컴컴컴컴컴컴컴컴컴�'
@ 07,10 say '� Grupo � Sub Grupo � Coluna �       Pre뇇 �         Descri뇙o    �'
@ 08,10 say '쳐컴컴컴탠컴컴컴컴컴탠컴컴컴컵컴컴컴컴컴컴컵컴컴컴컴컴컴컴컴컴컴컴�'
@ 09,10 say '�                                                                 �'
@ 10,10 say '�                                                                 �'
@ 11,10 say '�                                                                 �'
@ 12,10 say '�                                                                 �'
@ 13,10 say '�                                                                 �'
@ 14,10 say '�                                                                 �'
@ 15,10 say '�                                                                 �'
@ 16,10 say '�                                                                 �'
@ 17,10 say '�                                                                 �'
@ 18,10 say '�                                                                 �'
@ 19,10 say '�                                                                 �'
@ 20,10 say '�                                                                 �'
@ 21,10 say '�                                                                 �'
@ 22,10 say '읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�'
//
sombra(6,13,22,79)

campos := { " '  '+VEN019->GRUPO+'   �   '    +  " +;
            " VEN019->SUBGRUPO +'      �  '   +  " +;
            " VEN019->COLUNA   +'    � '      +  " +;
            " str(VEN019->PRECO,10,2) + '  � ' +  " +;
            " VEN019->DESCRICAO" }

VEN019->( dbedit(09,11,21,75,campos,"funcao369",,'','' ) )

close data

return

************************************
function funcao369( MODE, N )
************************************

local   TEC  := lastkey()
private WRET := 1

do case
   case TEC == 28
      socorro1()
      WRET := 1

   case TEC == 27
      WRET := 0

   case TEC == -2
      inser369()
      WRET := 2

   case TEC == -3
      alter369()
      keyboard(chr(32))
      WRET := 2

   case TEC == -4 && EXCLUSAO
      WRET := 2

      if VEN019->(! eof())
         if conf("Confirma exclus꼘 da Medida de Sub Grupo ","N")
            while VEN019->( ! rlock() ) ;end
            VEN019->( dbdelete() )
            VEN019->( dbskip() )
         end
      end
end

return WRET

************************************
function inser369()
************************************
private WRET := NIL

setcursor(1)

while .t.

   X_GRUPO      := space(2)
   X_SUBGRUPO   := space(2)
   X_COLUNA     := space(2)
   X_DESCRICAO  := space(LEN(VEN019->DESCRICAO))
   X_PRECO      := 0.0
   
   @ 21,10 say '�       �           �        �             �'
   @ 21,13 get X_GRUPO       picture "@!"
   @ 21,22 get X_SUBGRUPO    picture "@!"
   @ 21,33 get X_COLUNA      picture "@!"
   read
   if lastkey()=27
      exit
   end

   @ 21,42 get X_PRECO       picture "999999.99"
   @ 21,55 get X_DESCRICAO   picture "@!"
   read

   if lastkey()=27; loop; end

   VEN018->(dbsetorder(1))
   VEN018->(dbseek(X_GRUPO+X_SUBGRUPO))

   if VEN018->(! found() )
      message('Pre뇇 de Grupo n꼘 Cadastrado')
      loop
   end

   VEN019->(dbsetorder(1))
   VEN019->( dbseek (X_GRUPO+X_SUBGRUPO+X_COLUNA) )

   if VEN019->( found() )
      message('Medida de Sub Grupo j� Cadastrado')
      loop
   end

   if conf('Confirma inclus꼘 de Medida de Sub Grupo','N')
      VEN019->( dbappend() )
      VEN019->GRUPO      := X_GRUPO
      VEN019->SUBGRUPO   := X_SUBGRUPO
      VEN019->COLUNA     := X_COLUNA
      VEN019->PRECO      := X_PRECO
      VEN019->DESCRICAO  := X_DESCRICAO
      VEN019->( dbunlock() )
   end
   @ 21,10 say '�       �           �        �             �'
   @ 20,12 say X_GRUPO       picture "@!"
   @ 20,21 say X_SUBGRUPO    picture "@!"
   @ 20,33 say X_COLUNA      picture "@!"

end

keyboard chr(1)
setcursor(0)

return WRET

************************************
function alter369()
************************************
private WRET := NIL

setcursor(1)

begin sequence

   X_GRUPO      := VEN019->GRUPO
   X_SUBGRUPO   := VEN019->SUBGRUPO
   X_COLUNA     := VEN019->COLUNA
   X_DESCRICAO  := VEN019->DESCRICAO
   X_PRECO      := VEN019->PRECO

   @ row(),42 get X_PRECO       picture "999999.99"
   @ row(),55 get X_DESCRICAO   picture "@!"
   read

   if lastkey()=27; break; end

   VEN019->(dbsetorder(1))
   VEN019->( dbseek (X_GRUPO+X_SUBGRUPO+X_COLUNA) )

   if VEN019->( ! found() )
      message('Medida de Sub Grupo n꼘 Cadastrado')
      break
   end

   if conf('Confirma altera뇙o de Medida de Sub Grupo','N')
      while VEN019->( ! rlock()); end
      VEN019->GRUPO      := X_GRUPO
      VEN019->SUBGRUPO   := X_SUBGRUPO
      VEN019->COLUNA     := X_COLUNA
      VEN019->PRECO      := X_PRECO
      VEN019->DESCRICAO  := X_DESCRICAO
      VEN019->( dbunlock() )
   end

end sequence
setcursor(0)

return WRET

