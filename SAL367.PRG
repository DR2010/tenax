/*
   VEN - VENDAS
   VEN367.PRG - Tabela de Padrao de Medida
*/

abrir("VEN015")

status('Precos por Medida Padrao ')

@ 06,15 say 'ÚÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿'
@ 07,15 say '³ Medida ³  Minimo  ³  Maximo  ³     Preco      ³'
@ 08,15 say 'ÃÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´'
@ 09,15 say '³        ³          ³          ³                ³'
@ 10,15 say '³        ³          ³          ³                ³'
@ 11,15 say '³        ³          ³          ³                ³'
@ 12,15 say '³        ³          ³          ³                ³'
@ 13,15 say '³        ³          ³          ³                ³'
@ 14,15 say '³        ³          ³          ³                ³'
@ 15,15 say '³        ³          ³          ³                ³'
@ 16,15 say '³        ³          ³          ³                ³'
@ 17,15 say '³        ³          ³          ³                ³'
@ 18,15 say '³        ³          ³          ³                ³'
@ 19,15 say '³        ³          ³          ³                ³'
@ 20,15 say '³        ³          ³          ³                ³'
@ 21,15 say '³        ³          ³          ³                ³'
@ 22,15 say 'ÀÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ'
//
sombra(6,15,22,63)

campos := {'VEN015->MEDIDA','VEN015->MINIMO','VEN015->MAXIMO','VEN015->PRECO'}

/*
              ÚÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
              ³ Medida ³  Minimo  ³  Maximo  ³     Preco      ³
              ÃÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´
              ³        ³          ³          ³                ³
                  xx      9999,99    9999,99   99999999999,99
                  19      27         38        48             63
*/

divisor:={"³   ","   ³  "," ³  "," ³ "}

mascara:={'@!','@!','@!','@!'}

VEN015->( dbedit(09,19,21,62,campos,"funcao367",mascara,'','',divisor ) )

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
          if conf("Confirma exclusao da Medida Padrao ","S")
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

private X_MEDIDA  ,;
        X_MINIMO

setcursor(1)

while .t.

   X_MEDIDA    := space(2)
   X_MINIMO    := 0.0
   X_MAXIMO    := 0.0
   X_PRECO     := 0.0

/*
              ÚÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
              ³ Medida ³  Minimo  ³  Maximo  ³     Preco      ³
              ÃÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´
              ³        ³          ³          ³                ³
                  xx      9999,99    9999,99   99999999999,99
                  19      27         38        48             63
*/


   @ 21,15 say '³        ³          ³          ³                ³'

   @ 21,19 get X_MEDIDA    pict "@!"
   @ 21,27 get X_MINIMO    pict "@E 9999,99"
   @ 21,38 get X_MAXIMO    pict "@E 9999,99"
   @ 21,48 get X_PRECO     pict "@E 99999999999,99"

   read

   if lastkey()=27
      setcursor(0)
      return nil
   end

   dbsetorder(1)
   if VEN015->(dbseek(X_MEDIDA))
      message('Medida Padrao ja Cadastrada')
      return nil
   end

   if conf('Confirma inclusao da Medida Padrao','S')
      VEN015->( dbappend() )
      VEN015->MEDIDA  := X_MEDIDA
      VEN015->MINIMO  := X_MINIMO
      VEN015->MAXIMO  := X_MAXIMO
      VEN015->PRECO   := X_PRECO
      scroll(09,19,21,62,1)
   end

end

************************************
static func edita367()
************************************

local X_MINIMO := VEN015->MINIMO,X_MAXIMO := VEN015->MAXIMO,X_PRECO  := VEN015->PRECO

setcursor(1)

@ row(),27 get X_MINIMO pict "@E 9999,99"
@ row(),38 get X_MAXIMO pict "@E 9999,99"
@ row(),48 get X_PRECO  pict "@E 99999999999,99"

read

if empty(X_MINIMO) .or. lastkey()=27
   setcursor(0)
   return nil
end

VEN015->MINIMO := X_MINIMO
VEN015->MAXIMO := X_MAXIMO
VEN015->PRECO  := X_PRECO

setcursor(0)

return nil


