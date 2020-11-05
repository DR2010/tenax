/*
   VEN - VENDAS
   VEN370.PRG - Tabela de Fator de Preco (peca pequena)
*/

abrir("VEN017")
abrir("VEN018")
abrir("VEN019")
abrir("VEN020")

status(' Fator de Grupo ')

@ 06,02 say 'ÚÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿'
@ 07,02 say '³ Grupo ³ Sub Fator ³       Descri‡„o         ³  Med. M xim ³    Fator     ³'
@ 08,02 say 'ÃÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´'
@ 09,02 say '³       ³           ³                         ³             ³              ³'
@ 10,02 say '³       ³           ³                         ³             ³              ³'
@ 11,02 say '³       ³           ³                         ³             ³              ³'
@ 12,02 say '³       ³           ³                         ³             ³              ³'
@ 13,02 say '³       ³           ³                         ³             ³              ³'
@ 14,02 say '³       ³           ³                         ³             ³              ³'
@ 15,02 say '³       ³           ³                         ³             ³              ³'
@ 16,02 say '³       ³           ³                         ³             ³              ³'
@ 17,02 say '³       ³           ³                         ³             ³              ³'
@ 18,02 say '³       ³           ³                         ³             ³              ³'
@ 19,02 say '³       ³           ³                         ³             ³              ³'
@ 20,02 say '³       ³           ³                         ³             ³              ³'
@ 21,02 say '³       ³           ³                         ³             ³              ³'
@ 22,02 say 'ÀÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ'
//
sombra(6,02,22,77)

campos := { " ' '+ VEN020->GRUPO        + '  ³  '     + " +;
            " VEN020->SUBFATOR           + '       ³  ' +" +;
            " VEN020->DESCRICAO           + '        ³  ' +" +;
            " str(VEN020->MEDIDAFIM,8,3) + '   ³ '       + " +;
            " str(VEN020->FATOR,10,2) " }


VEN020->( dbedit(09,03,21,75,campos,"funcao370",,'','' ))

close data
return

************************************
function funcao370(mode,n)
************************************

local tec:=lastkey()

if     tec == 28 ; socorro1() ; return 1

elseif tec == 27 ; return 0

elseif tec == -3   && alteracao f4
       if !eof()
          edita370()
       end
       return 1

elseif tec = -2   && inclusao f3
       inser370()
       keyboard ""
       return 2

elseif tec = -4   &&  exclusao f5
       if !eof()
          if conf("Confirma exclus„o da Fator ","N")
             while VEN020->( ! rlock() ); end
             dbdelete()
             dbskip()
          end
        end
        return 2
end

return 1

************************************
function inser370()
************************************

private WRET := NIL

setcursor(1)

while .t.

   X_GRUPO      := space(2)
   X_SUBFATOR   := space(2)
   X_MEDIDAFIM  := 0.0
   X_FATOR      := 0.0

   @ 21,02 say '³       ³           ³                         ³             ³              ³'

   @ 21,06 get X_GRUPO       picture "@!"
   @ 21,13 get X_SUBFATOR    picture "@!"
   @ 21,49 get X_MEDIDAFIM   picture "999999.999"
   @ 21,65 get X_FATOR       picture "999.99"
   read

   if lastkey()=27; exit; end

   VEN017->(dbsetorder(1))
   VEN017->(dbseek(X_GRUPO))

   if VEN017->(! found() )
      message('Grupo de Pre‡o n„o Cadastrado')
      exit
   end

   VEN020->(dbsetorder(1))
   VEN020->(dbseek (X_GRUPO+X_SUBFATOR+str(X_MEDIDAFIM,8,3)))

   if VEN020->( found() )
      message('Fator de Grupo j  Cadastrado')
      exit
   end

   if conf('Confirma inclus„o de Fator de Grupo','N')
      VEN020->( dbappend() )
      VEN020->GRUPO      := X_GRUPO
      VEN020->SUBFATOR   := X_SUBFATOR
      VEN020->MEDIDAFIM  := X_MEDIDAFIM
      VEN020->FATOR      := X_FATOR
      VEN020->( dbunlock() )
      EXIT
   end

end

************************************
static func edita370()
************************************

X_FATOR := VEN020->FATOR

setcursor(1)

@ row(),68 get X_FATOR  picture "999.99"
read

if empty(X_FATOR) .or. lastkey()=27
   setcursor(0)
   return nil
end

if conf('Confirma alteracao do Fator de Grupo','N')
  while VEN020->(!RLOCK()); LOOP ; END
  VEN020->FATOR := X_FATOR
  VEN020->(DBUNLOCK())
END
setcursor(0)
return nil


