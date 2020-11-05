/*
   VEN - VENDAS
   VEN368.PRG - Tabela de Padrao de GRUPO
*/

abrir("VEN017")
abrir("VEN018")

status(' Tabela de SubGrupos ')

@ 06,15 say 'ÚÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿'
@ 07,15 say '³ Grupo ³ Sub Grupo ³   Descri‡„o             ³'
@ 08,15 say 'ÃÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´'
@ 09,15 say '³ .xx.  ³ .......XX ³ xxxxxxxxxxxxxxx   xxxxx ³'
@ 10,15 say '³       ³           ³                         ³'
@ 11,15 say '³       ³           ³                         ³'
@ 12,15 say '³       ³           ³                         ³'
@ 13,15 say '³       ³           ³                         ³'
@ 14,15 say '³       ³           ³                         ³'
@ 15,15 say '³       ³           ³                         ³'
@ 16,15 say '³       ³           ³                         ³'
@ 17,15 say '³       ³           ³                         ³'
@ 18,15 say '³       ³           ³                         ³'
@ 19,15 say '³       ³           ³                         ³'
@ 20,15 say '³       ³           ³                         ³'
@ 21,15 say '³       ³           ³                         ³'
@ 22,15 say 'ÀÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ'
//
sombra(6,15,22,61)

campos := { "VEN018->GRUPO+space(1)+'³'+VEN018->SUBGRUPO+space(9)+'³'+VEN018->DESCRICAO" }
mascara:= {'@!','@!','@!'}

WSCR := savescreen(,,,,)

VEN018->( dbedit(09,16,21,59,campos,"funcao368",mascara,'','',''))

close data

return

************************************
function funcao368(mode,n)
************************************

local tec:=lastkey()

do case
 case  tec == 28 ; socorro1() ; return 1
 case  tec == 27 ; return 0
 case  tec == -3   && alteracao f4
      if !eof()
         edita368()
         keyboard ""
      end
      return 2

 case  tec = -2   && inclusao f3
      inser368()
      keyboard ""
      return 2
 case  tec = -4   &&  exclusao f5
      if !eof()
         if conf("Confirma exclus„o de Pre‡o ","S")
            while VEN018->( ! rlock());end
            dbdelete()
            dbskip()
         end
       end
       return 2

end

return 1

************************************
function INSER368()
************************************
setcursor(1)

while .t.

   X_GRUPO      := space(2)
   X_SUBGRUPO   := space(2)
   X_DESCRICAO  := space(20)

   // @ 21,15 say space(50)

   tela368()

   @ 11,25 get X_GRUPO      pict "@!"
   @ 12,25 get X_SUBGRUPO   pict "@!"
   @ 13,25 get X_DESCRICAO  pict "@!"
   read

   if lastkey()=27
      setcursor(0)
      exit
   end

   VEN017->(dbsetorder(1))
   if !(VEN017->(dbseek(X_GRUPO)))
      message('Grupo n„o Cadastrado')
      exit
   end

   VEN018->( dbsetorder(1) )
   VEN018->( dbseek(X_GRUPO+X_SUBGRUPO) )

   if VEN018->( found() )
      message('Subgrupo j  Cadastrado')
      exit
   end

   if conf('Confirma inclus„o de Pre‡o','S')
      VEN018->( dbappend() )
      VEN018->GRUPO      := X_GRUPO
      VEN018->SUBGRUPO   := X_SUBGRUPO
      VEN018->DESCRICAO  := X_DESCRICAO
      VEN018->( dbunlock() )
   end

end

restscreen(,,,,WSCR )
return .T.

************************************
function EDITA368()
************************************
setcursor(1)

tela368()

X_DESCRICAO := VEN018->DESCRICAO
@ 11,25 say VEN018->GRUPO      pict "@!"
@ 12,25 say VEN018->SUBGRUPO   pict "@!"
@ 13,25 get X_DESCRICAO  pict "@!"
read

if lastkey() <> 27

   while VEN018->( ! rlock());end
   VEN018->DESCRICAO := X_DESCRICAO
   VEN018->( dbunlock() )
end

setcursor(0)

restscreen(,,,,WSCR )

return nil


procedure tela368()

@ 10,10 say 'ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿'
@ 11,10 say '³ Grupo .....:                                ³'
@ 12,10 say '³ Subgrupo ..:                                ³'
@ 13,10 say '³ Descri‡„o .:                                ³'
@ 14,10 say 'ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ'

return
