/*
   VEN - VENDAS
   VEN367.PRG - Tabela de Padrao de Medida
*/

abrir("VEN015")

status('Precos por Medida Padrao ')

@ 06,15 say '�����������������������������������������������Ŀ'
@ 07,15 say '� Medida �  Minimo  �  Maximo  �     Preco      �'
@ 08,15 say '�����������������������������������������������Ĵ'
@ 09,15 say '�        �          �          �                �'
@ 10,15 say '�        �          �          �                �'
@ 11,15 say '�        �          �          �                �'
@ 12,15 say '�        �          �          �                �'
@ 13,15 say '�        �          �          �                �'
@ 14,15 say '�        �          �          �                �'
@ 15,15 say '�        �          �          �                �'
@ 16,15 say '�        �          �          �                �'
@ 17,15 say '�        �          �          �                �'
@ 18,15 say '�        �          �          �                �'
@ 19,15 say '�        �          �          �                �'
@ 20,15 say '�        �          �          �                �'
@ 21,15 say '�        �          �          �                �'
@ 22,15 say '�������������������������������������������������'
//
sombra(6,15,22,63)

campos := {'VEN015->MEDIDA','VEN015->MINIMO','VEN015->MAXIMO','VEN015->PRECO'}

/*
              �����������������������������������������������Ŀ
              � Medida �  Minimo  �  Maximo  �     Preco      �
              �����������������������������������������������Ĵ
              �        �          �          �                �
                  xx      9999,99    9999,99   99999999999,99
                  19      27         38        48             63
*/

divisor:={"�   ","   �  "," �  "," � "}

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
              �����������������������������������������������Ŀ
              � Medida �  Minimo  �  Maximo  �     Preco      �
              �����������������������������������������������Ĵ
              �        �          �          �                �
                  xx      9999,99    9999,99   99999999999,99
                  19      27         38        48             63
*/


   @ 21,15 say '�        �          �          �                �'

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


