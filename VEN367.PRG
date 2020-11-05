/*
   VEN - VENDAS
   VEN367.PRG - Tabela de GRUPO
*/

abrir("VEN017")

status(' Tabela de Grupo ')

@ 06,15 say 'ÚÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄ¿'
@ 07,15 say '³ Grupo ³ Compr. Min. ³'
@ 08,15 say 'ÃÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄ´'
@ 09,15 say '³       ³             ³'
@ 10,15 say '³       ³             ³'
@ 11,15 say '³       ³             ³'
@ 12,15 say '³       ³             ³'
@ 13,15 say '³       ³             ³'
@ 14,15 say '³       ³             ³'
@ 15,15 say '³       ³             ³'
@ 16,15 say '³       ³             ³'
@ 17,15 say '³       ³             ³'
@ 18,15 say '³       ³             ³'
@ 19,15 say '³       ³             ³'
@ 20,15 say '³       ³             ³'
@ 21,15 say '³       ³             ³'
@ 22,15 say 'ÀÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÙ'
//
sombra(6,15,22,37)

campos := {'VEN017->GRUPO','VEN017->COMPMINIMO'}

/*
              ÚÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
              ³ Grupo ³ Peso Minimo ³
              ÃÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄ´
              ³       ³             ³
                  xx        999,999
                  19        29      37
*/

divisor:={"³   ","  ³     "}

mascara:={'@!','999.999'}

VEN017->( dbedit(09,19,21,35,campos,"funcao367",mascara,'','',divisor ) )

close data

return

************************************
function funcao367(mode,n)
************************************

local tec:=lastkey()

if     tec == 28 ; socorro1() ; return 1

elseif tec == 27 ; return 0

elseif tec == -3   && alteracao f4
       if !eof()
          edita367()
       end
       return 1

elseif tec = -2   && inclusao f3
       inser367()
       keyboard ""
       return 2

elseif tec = -4   &&  exclusao f5
       if !eof()
          if conf("Confirma exclus„o de Grupo ","S")
             while VEN017->( ! rlock() ); end
             dbdelete()
             dbskip()
          end
        end
        return 2

end

return 1

************************************
static func inser367()
************************************

private X_GRUPO  ,;
        X_MINIMO

setcursor(1)

while .t.

   X_GRUPO      := space(2)
   X_COMPMINIMO := 0.0

/*
              ÚÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
              ³ Grupo ³ Peso Minimo ³
              ÃÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄ´
              ³       ³             ³
                  xx        999,999
                  19        29      37
*/

   @ 21,15 say '³       ³             ³'

   @ 21,19 get X_GRUPO       pict "@!"
   @ 21,29 get X_COMPMINIMO  pict "999.999"

   read

   if lastkey()=27
      setcursor(0)
      return nil
   end

   dbsetorder(1)
   if VEN017->(dbseek(X_GRUPO))
      message('Grupo ja Cadastrado')
      return nil
   end

   if conf('Confirma inclusao de Grupo ','S')
      VEN017->( dbappend() )
      VEN017->GRUPO       := X_GRUPO
      VEN017->COMPMINIMO  := X_COMPMINIMO
      VEN017->( dbunlock() )
   end

end

************************************
static func edita367()
************************************

local X_COMPMINIMO  := VEN017->COMPMINIMO

setcursor(1)

@ row(),29 get X_COMPMINIMO  pict "999.999"
read

if empty(X_COMPMINIMO) .or. lastkey()=27
   setcursor(0)
   return nil
end

while VEN017->( ! rlock() ); end
VEN017->COMPMINIMO  := X_COMPMINIMO
VEN017->( dbunlock() )

setcursor(0)

return nil


