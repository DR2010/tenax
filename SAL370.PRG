/*
   VEN - VENDAS
   VEN370.PRG - Tabela de Fator de Preco (peca pequena)
*/

abrir("VEN017")
abrir("VEN020")

status(' Fator de Grupo ')

@ 06,15 say 'ÚÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄ¿'
@ 07,15 say '³ Grupo ³ Sub Grupo ³       Fator ³'
@ 08,15 say 'ÃÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄ´'
@ 09,15 say '³       ³           ³             ³'
@ 10,15 say '³       ³           ³             ³'
@ 11,15 say '³       ³           ³             ³'
@ 12,15 say '³       ³           ³             ³'
@ 13,15 say '³       ³           ³             ³'
@ 14,15 say '³       ³           ³             ³'
@ 15,15 say '³       ³           ³             ³'
@ 16,15 say '³       ³           ³             ³'
@ 17,15 say '³       ³           ³             ³'
@ 18,15 say '³       ³           ³             ³'
@ 19,15 say '³       ³           ³             ³'
@ 20,15 say '³       ³           ³             ³'
@ 21,15 say '³       ³           ³             ³'
@ 22,15 say 'ÀÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÙ'
//
sombra(6,15,22,49)

campos := {'VEN020->GRUPO','VEN020->SUBGRUPO','VEN020->APLICADOR'}

/*

              ÚÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
              ³ Grupo ³ Sub Grupo ³       Fator ³
              ÃÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄ´
              ³       ³           ³             ³
                  xx       xx            999,99
                  19       28            42   4749
*/

divisor:={"³   ","  ³    ","     ³      "}

mascara:={'@!','@!','999.99'}

VEN020->( dbedit(09,19,21,47,campos,"funcao370",mascara,'','',divisor ) )

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
          if conf("Confirma exclusao da Grupo de Preco ","S")
             dbdelete()
             dbskip()
          end
        end
        return 2

end

return 1

************************************
static func inser370()
************************************

private X_GRUPO  ,;
        X_MINIMO

setcursor(1)

while .t.

   X_GRUPO      := space(2)
   X_SUBGRUPO   := space(2)
   X_APLICADOR := 0.0

/*
              ÚÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
              ³ Grupo ³ Sub Grupo ³       Fator ³
              ÃÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄ´
              ³       ³           ³             ³
                  xx       xx            999,99
                  19       28            42   4749

*/

   @ 21,15 say '³       ³           ³             ³'

   @ 21,19 get X_GRUPO       pict "@!"
   @ 21,28 get X_SUBGRUPO    pict "@!"
   @ 21,42 get X_APLICADOR   pict "999.99"

   read

   if lastkey()=27
      setcursor(0)
      return nil
   end

   VEN017->(dbsetorder(1))
   if !(VEN017->(dbseek(X_GRUPO)))
      message('Grupo de Preco nao Cadastrado')
      return nil
   end

   VEN020->(dbsetorder(1))
   if VEN020->(dbseek(X_GRUPO+X_SUBGRUPO))
      message('Fator de Grupo ja Cadastrado')
      return nil
   end

   if conf('Confirma inclusao de Fator de Grupo','S')
      VEN020->( dbappend() )
      VEN020->GRUPO      := X_GRUPO
      VEN020->SUBGRUPO   := X_SUBGRUPO
      VEN020->APLICADOR  := X_APLICADOR
      scroll(09,19,21,47,1)
   end

end

************************************
static func edita370()
************************************

local X_APLICADOR  := VEN020->APLICADOR

setcursor(1)

@ row(),42 get X_APLICADOR  pict "999.99"
read

if empty(X_APLICADOR) .or. lastkey()=27
   setcursor(0)
   return nil
end

VEN020->APLICADOR  := X_APLICADOR

setcursor(0)

return nil




