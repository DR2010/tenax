/*
   VEN - VENDAS
   VEN370.PRG - Tabela de Fator de Preco (peca pequena)
*/

abrir("VEN017")
abrir("VEN018")
abrir("VEN019")
abrir("VEN020")

status(' Fator de Grupo ')

@ 06,02 say '旼컴컴컴쩡컴컴컴컴컴쩡컴컴컴컴컴컴컴컴컴컴컴컴쩡컴컴컴컴컴컴쩡컴컴컴컴컴컴커'
@ 07,02 say '� Grupo � Sub Fator �       Descri뇙o         �  Med. M쟸im �    Fator     �'
@ 08,02 say '쳐컴컴컴탠컴컴컴컴컴탠컴컴컴컴컴컴컴컴컴컴컴컴탠컴컴컴컴컴컴탠컴컴컴컴컴컴캑'
@ 09,02 say '�       �           �                         �             �              �'
@ 10,02 say '�       �           �                         �             �              �'
@ 11,02 say '�       �           �                         �             �              �'
@ 12,02 say '�       �           �                         �             �              �'
@ 13,02 say '�       �           �                         �             �              �'
@ 14,02 say '�       �           �                         �             �              �'
@ 15,02 say '�       �           �                         �             �              �'
@ 16,02 say '�       �           �                         �             �              �'
@ 17,02 say '�       �           �                         �             �              �'
@ 18,02 say '�       �           �                         �             �              �'
@ 19,02 say '�       �           �                         �             �              �'
@ 20,02 say '�       �           �                         �             �              �'
@ 21,02 say '�       �           �                         �             �              �'
@ 22,02 say '읕컴컴컴좔컴컴컴컴컴좔컴컴컴컴컴컴컴컴컴컴컴컴좔컴컴컴컴컴컴좔컴컴컴컴컴컴켸'
//
sombra(6,02,22,77)

campos := { " ' '+ VEN020->GRUPO        + '  �  '     + " +;
            " VEN020->SUBFATOR           + '       �  ' +" +;
            " VEN020->DESCRICAO           + '        �  ' +" +;
            " str(VEN020->MEDIDAFIM,8,3) + '   � '       + " +;
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
          if conf("Confirma exclus꼘 da Fator ","N")
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

   @ 21,02 say '�       �           �                         �             �              �'

   @ 21,06 get X_GRUPO       picture "@!"
   @ 21,13 get X_SUBFATOR    picture "@!"
   @ 21,49 get X_MEDIDAFIM   picture "999999.999"
   @ 21,65 get X_FATOR       picture "999.99"
   read

   if lastkey()=27; exit; end

   VEN017->(dbsetorder(1))
   VEN017->(dbseek(X_GRUPO))

   if VEN017->(! found() )
      message('Grupo de Pre뇇 n꼘 Cadastrado')
      exit
   end

   VEN020->(dbsetorder(1))
   VEN020->(dbseek (X_GRUPO+X_SUBFATOR+str(X_MEDIDAFIM,8,3)))

   if VEN020->( found() )
      message('Fator de Grupo j� Cadastrado')
      exit
   end

   if conf('Confirma inclus꼘 de Fator de Grupo','N')
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


