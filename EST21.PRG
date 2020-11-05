/*

   SCM - Sistema de Controle Metalurgico
   EST21.PRG - Cadastro de tipo de Movimentacao

*/


abrir("EST011")

setcolor(W_COREDIT)
status('Tipo de Movimentacao')
telanum('SCR21 ','EST21 ')
@ 06,24 say 'ÚÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÂÄÄÄÄÄÄ¿'
@ 07,24 say '³  C¢d  ³          Descri‡„o         ³E/S³ACERTO³'
@ 08,24 say 'ÃÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÅÄÄÄÄÄÄ´'
@ 09,24 say '³       ³                            ³   ³      ³'
@ 10,24 say '³       ³                            ³   ³      ³'
@ 11,24 say '³       ³                            ³   ³      ³'
@ 12,24 say '³       ³                            ³   ³      ³'
@ 13,24 say '³       ³                            ³   ³      ³'
@ 14,24 say '³       ³                            ³   ³      ³'
@ 15,24 say '³       ³                            ³   ³      ³'
@ 16,24 say '³       ³                            ³   ³      ³'
@ 17,24 say '³       ³                            ³   ³      ³'
@ 18,24 say '³       ³                            ³   ³      ³'
@ 19,24 say '³       ³                            ³   ³      ³'
@ 20,24 say 'ÀÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÁÄÄÄÄÄÄÙ'
sombra(6,24,20,72)

EST011->( dbedit(09,26,19,71,{'EST011->TIPOMOVI','EST011->DESCRICAO',' '+;
                              'EST011->ES','EST011->ACERTO'+' '},"funcao21",'','','',;
                               {'',"  ³ ","  ³ "," ³    "}) )

close data

return

************************************
function funcao21(mode,n)
************************************

local tec:=lastkey()

if     tec == 28 ; help() ; return 1

elseif tec == 27 ; return 0

elseif tec == -3   && alteracao f4
       if !eof()
          edita21()
       end
       return 1

elseif tec = -2   && inclusao f3
       inser21()
       keyboard ""
       return 2

elseif tec = -4   &&  exclusao f5
       if !eof()
          if conf("Confirma exclus„o da Movimenta‡„o","S")
             dbdelete()
             dbskip()
          end
        end
        return 2

elseif tec = -5  && busca direta f6
       if !eof()
          busca21()
       end
       return 2

end

return 1

************************************
static func inser21()
************************************

private X_TIPOMOVI  ,;
        X_DESCRICAO ,;
        X_ACERTO    ,;
        X_ES

setcursor(1)

while .t.

   X_TIPOMOVI  := space(3)
   X_DESCRICAO := space(20)
   X_ES        := space(01)
   X_ACERTO    := space(01)

   @ 19,24 say '³       ³                            ³   ³      ³'
   @ 19,27 say X_TIPOMOVI  pict "999"
   @ 19,35 say X_DESCRICAO pict "@!"
   @ 19,63 say X_ES        pict "@!"
   @ 19,70 say X_ACERTO    pict "@!"

   @ 19,27 get X_TIPOMOVI  pict "@K" valid tes_mov2( zerofill( X_TIPOMOVI ) )
   @ 19,35 get X_DESCRICAO pict "@!"
   @ 19,63 get X_ES        pict "@!" valid X_ES $ "ES"
   @ 19,70 get X_ACERTO    pict "@!" valid X_ACERTO $ "ES"
   read

   if lastkey()=27
      setcursor(0)
      return nil
   end

   if conf('Confirma inclus„o da Movimenta‡„o','S')
      EST011->( dbappend() )
      EST011->TIPOMOVI  := X_TIPOMOVI
      EST011->DESCRICAO := X_DESCRICAO
      EST011->ES        := X_ES
      EST011->ACERTO    := X_ACERTO
      EST011->( dbunlock() )

      scroll(09,27,19,64,1)
   end

end

************************************
static func edita21()
************************************

local X_DESCRICAO := EST011->DESCRICAO ,;
      X_ES        := EST011->ES        ,;
      X_ACERTO    := EST011->ACERTO

setcursor(1)

@ row(),34 get X_DESCRICAO pict "@!"
@ row(),63 get X_ES        pict "@!" valid X_ES $ "ES"
@ row(),70 get X_ACERTO    pict "@!" valid X_ACERTO $ "ES"
read

if empty(X_DESCRICAO) .or. lastkey()=27
   setcursor(0)
   return nil
end

while EST011->( ! rlock() ); end
EST011->DESCRICAO := X_DESCRICAO
EST011->ES        := X_ES
EST011->ACERTO    := X_ACERTO
EST011->( dbunlock() )

setcursor(0)

return nil

************************************
static func busca21()
************************************

local X_TIPOMOVI := space(3)
local tb    := savescreen(14,29,17,50)

setcursor(1)

@ 14,29 say "ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿"
@ 15,29 say '³ Codigo..      ³'
@ 16,29 say "ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ"

sombra(14,29,16,45)

@ 15,40 get X_TIPOMOVI pict "999"
read

if empty(X_TIPOMOVI) .or. lastkey()=27
   setcursor(0)
   keyboar " "
   restscreen(14,29,17,46,tb)
   return nil
end

X_TIPOMOVI:= strzero(val(X_TIPOMOVI),3)
dbseek(X_TIPOMOVI,.t.)
setcursor(0)
restscreen(14,29,17,46,tb)

return nil
