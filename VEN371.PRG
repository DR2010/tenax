/*
   VEN - VENDAS
   VEN371.PRG - Medida de Fator (peca pequena)
*/

abrir("VEN021")

status(' Medida de Fator ')

@ 06,05 say '旼컴컴컴쩡컴컴컴컴컴쩡컴컴컴컴컴컴컴쩡컴컴컴컴컴컴컴쩡컴컴컴컴컴커'
@ 07,05 say '� Grupo � Sub Fator � Descri뇙o     � Med.M쟸 Corte � Fator      �'
@ 08,05 say '쳐컴컴컴탠컴컴컴컴컴탠컴컴컴컴컴컴컴탠컴컴컴컴컴컴컴탠컴컴컴컴컴캑'
@ 09,05 say '�       �           �               �               �            �'
@ 10,05 say '�       �           �               �               �            �'
@ 11,05 say '�       �           �               �               �            �'
@ 12,05 say '�       �           �               �               �            �'
@ 13,05 say '�       �           �               �               �            �'
@ 14,05 say '�       �           �               �               �            �'
@ 15,05 say '�       �           �               �               �            �'
@ 16,05 say '�       �           �               �               �            �'
@ 17,05 say '�       �           �               �               �            �'
@ 18,05 say '�       �           �               �               �            �'
@ 19,05 say '�       �           �               �               �            �'
@ 20,05 say '�       �           �               �               �            �'
@ 21,05 say '�       �           �               �               �            �'
@ 22,05 say '읕컴컴컴좔컴컴컴컴컴좔컴컴컴컴컴컴컴좔컴컴컴컴컴컴컴좔컴컴컴컴컴켸'
//
sombra(06,05,22,70)

campos := {'VEN021->GRUPO','VEN021->SUBFATOR','VEN021->DESCRICAO','VEN021->MEDIDAFIM','VEN021->FATOR'}

divisor:={"�   ","  �    ","  �  ","     �      "," �    "}

mascara:={'@!','@!','@!','9999.999','999.999'}

VEN021->( dbedit(09,05,21,70,campos,"funcao371",mascara,'','',divisor ) )

close data

return

************************************
function funcao371(mode,n)
************************************

local tec:=lastkey()

if     tec == 28 ; help() ; return 1

elseif tec == 27 ; return 0

elseif tec = -2   && inclusao f3
       inser371()
       keyboard ""
       return 2

elseif tec = -4   && exclusao f5
       if !eof()
          if conf("Confirma exclus꼘 da Medida de Fator ","S")
             dbdelete()
             dbskip()
          end
        end
        return 2

end

return 1

************************************
static func inser371()
************************************

setcursor(1)

while .t.

   X_GRUPO      := space(2)
   X_SUBFATOR   := space(2)
   X_DESCRICAO  := space(15)
   X_FATOR    := 0.0
   X_MEDIDAFIM  := 0.0

   @ 21,15 say '�       �           �               �            �'

   @ 21,07 get X_GRUPO       pict "@!"
   @ 21,15 get X_SUBFATOR    pict "@!"
   @ 21,25 get X_DESCRICAO   pict "@!"
   @ 21,45 get X_MEDIDAFIM   pict "9999.999"
   @ 21,63 get X_FATOR     pict "999.999"

   read

   if lastkey()=27
      setcursor(0)
      return nil
   end

   VEN021->(dbsetorder(1))
   if VEN021->(dbseek(X_GRUPO+X_SUBFATOR+STR(X_MEDIDAFIM,8,3)+STR(X_FATOR,7,3)))
      message('Medida de Fator ja Cadastrada')
      loop
   end

   if conf('Confirma inclus꼘 da  Medida de Fator ','S')
      VEN021->( dbappend() )
      VEN021->GRUPO      := X_GRUPO
      VEN021->SUBFATOR   := X_SUBFATOR
      VEN021->DESCRICAO  := X_DESCRICAO
      VEN021->MEDIDAFIM  := X_MEDIDAFIM
      VEN021->FATOR      := X_FATOR
      scroll(09,19,21,62,1)
   end

end

return nil
