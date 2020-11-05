/*
   VEN - VENDAS
   VEN369.PRG - Tabela de Precos
*/

abrir("VEN018")
abrir("VEN019")

status(' Medida de Sub Grupo ')

@ 06,10 say 'ÚÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿'
@ 07,10 say '³ Grupo ³ Sub Grupo ³ Coluna ³       Pre‡o ³         Descri‡„o    ³'
@ 08,10 say 'ÃÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´'
@ 09,10 say '³                                                                 ³'
@ 10,10 say '³                                                                 ³'
@ 11,10 say '³                                                                 ³'
@ 12,10 say '³                                                                 ³'
@ 13,10 say '³                                                                 ³'
@ 14,10 say '³                                                                 ³'
@ 15,10 say '³                                                                 ³'
@ 16,10 say '³                                                                 ³'
@ 17,10 say '³                                                                 ³'
@ 18,10 say '³                                                                 ³'
@ 19,10 say '³                                                                 ³'
@ 20,10 say '³                                                                 ³'
@ 21,10 say '³                                                                 ³'
@ 22,10 say 'ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ'
//
sombra(6,13,22,79)

campos := { " '  '+VEN019->GRUPO+'   ³   '    +  " +;
            " VEN019->SUBGRUPO +'      ³  '   +  " +;
            " VEN019->COLUNA   +'    ³ '      +  " +;
            " str(VEN019->PRECO,10,2) + '  ³ ' +  " +;
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
         if conf("Confirma exclus„o da Medida de Sub Grupo ","N")
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
   
   @ 21,10 say '³       ³           ³        ³             ³'
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
      message('Pre‡o de Grupo n„o Cadastrado')
      loop
   end

   VEN019->(dbsetorder(1))
   VEN019->( dbseek (X_GRUPO+X_SUBGRUPO+X_COLUNA) )

   if VEN019->( found() )
      message('Medida de Sub Grupo j  Cadastrado')
      loop
   end

   if conf('Confirma inclus„o de Medida de Sub Grupo','N')
      VEN019->( dbappend() )
      VEN019->GRUPO      := X_GRUPO
      VEN019->SUBGRUPO   := X_SUBGRUPO
      VEN019->COLUNA     := X_COLUNA
      VEN019->PRECO      := X_PRECO
      VEN019->DESCRICAO  := X_DESCRICAO
      VEN019->( dbunlock() )
   end
   @ 21,10 say '³       ³           ³        ³             ³'
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
      message('Medida de Sub Grupo n„o Cadastrado')
      break
   end

   if conf('Confirma altera‡„o de Medida de Sub Grupo','N')
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

