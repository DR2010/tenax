/*
   VEN012.PRG - Cadastro de Vendedor
*/

setcancel(.t.)

altd(1)

abrir("VEN002")

setcolor(W_COREDIT)
status('Cadastro de Vendedores')

@ 06,03 say 'ÚÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿'
@ 07,03 say '³ Codigo ³               Nome                       ³ Nome de Guerra  ³'
@ 08,03 say 'ÃÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´'
@ 09,03 say '³        ³                                          ³                 ³'
@ 10,03 say '³        ³                                          ³                 ³'
@ 11,03 say '³        ³                                          ³                 ³'
@ 12,03 say '³        ³                                          ³                 ³'
@ 13,03 say '³        ³                                          ³                 ³'
@ 14,03 say '³        ³                                          ³                 ³'
@ 15,03 say '³        ³                                          ³                 ³'
@ 16,03 say '³        ³                                          ³                 ³'
@ 17,03 say '³        ³                                          ³                 ³'
@ 18,03 say '³        ³                                          ³                 ³'
@ 19,03 say '³        ³                                          ³                 ³'
@ 20,03 say 'ÀÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ'

sombra(6,03,20,73)

VEN002->( dbedit(09,07,19,71,{'VEN002->CODVEN','VEN002->NOME','VEN002->GUERRA'},"funcao012",'','','',{ "  " ,"   ³ "," ³ "}) )
close data

return

************************************
function funcao012(mode,n)
************************************

local tec:=lastkey()

do case
   case  tec == 28
      socorro1()
      return 1

   case tec == 27
      return 0

   case tec = -2   && inclusao f3
      inser012()
      keyboard ""
      return 2

   case tec == -3   && alteracao f4
      if !eof()
         edita012()
      end
      return 1

   case tec = -4   &&  exclusao f5
      if !eof()
         if conf("Confirma exclusao do Vendedor ","S")
            while VEN002->( ! rlock()); end
            dbdelete()
            dbskip()
         end
      end
      return 2

   case tec = -5  && busca direta f6
      if !eof()
         busca012()
      end
      return 2
endcase
return 1

************************************
static func inser012()
************************************

private X_CODVEND, X_NOME, X_GUERRA
 X_CODVEN    := space(2)
 X_NOME      := space(40)
 X_GUERRA    := space(15)

setcursor(1)

while .t.


   @ 19,04 say '        ³                                          ³                 '

   @ 19,07 get X_CODVEN    pict "@!" valid zero( X_CODVEN, 2)
   @ 19,14 get X_NOME      pict "@!"
   @ 19,57 get X_GUERRA    pict "@!"
   read

   if X_CODVEN == "00" .or. lastkey()=27
      setcursor(0)
      return nil
   end

   if dbseek(X_CODVEN)
      message("Vendedor ja cadastrado")
      INKEY(.5)
      loop
   end

   if conf('Confirma inclusao do Vendedor ? ','S')
      dbappend()
      repl VEN002->CODVEN    with X_CODVEN
      repl VEN002->NOME      with X_NOME
      repl VEN002->GUERRA    with X_GUERRA
      scroll(09,05,19,71,1)
      X_CODVEN    := space(2)
      X_NOME      := space(40)
      X_GUERRA    := space(15)

   end

end

************************************
static func edita012()
************************************

private X_NOME   := VEN002->NOME
private X_GUERRA := VEN002->GUERRA

setcursor(1)

@ row(),14 get X_NOME   pict "@!"
@ row(),57 get X_GUERRA pict "@!"
read

if empty(X_NOME) .or. lastkey()=27
   setcursor(0)
   return nil
end

if empty(X_GUERRA) .or. lastkey()=27
   setcursor(0)
   return nil
end


while VEN002->( ! rlock()); end

repl VEN002->NOME   with X_NOME
repl VEN002->GUERRA with X_GUERRA

setcursor(0)

return nil

************************************
static func busca012()
************************************

private X_CODVEN := space(2)
private TB := savescreen(14,29,17,48)

setcursor(1)

@ 14,29 say "ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿"
@ 15,29 say '³ Codigo..        ³'
@ 16,29 say "ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ"

sombra(14,29,16,47)

@ 15,40 get X_CODVEN pict "999999" valid zero( X_CODVEN, 2 )
read

if empty(X_CODVEN) .or. lastkey()=27
   setcursor(0)
   keyboar " "
   restscreen(14,29,17,48,tb)
   return nil
end

X_CODVEN:= strzero(val(X_CODVEN),2)
dbseek(X_CODVEN,.t.)
setcursor(0)
restscreen(14,29,17,48,tb)

return nil

********* fim de programa


