/*

   SCM - Sistema de Controle Metalurgico
   EST13.prg - Cadastro de Forma de Material

*/

abrir("EST003")
abrir("EST004")

setcolor(W_COREDIT)
status('Cadastro de Forma de Material')

@ 06,10 say 'ÚÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄ¿'
@ 07,10 say '³ Forma ³      Descri‡„o       ³  Med.Mater  ³  Med.Corte  ³'
@ 08,10 say 'ÃÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄ´'
@ 09,10 say '³       ³                      ³             ³             ³'
@ 10,10 say '³       ³                      ³             ³             ³'
@ 11,10 say '³       ³                      ³             ³             ³'
@ 12,10 say '³       ³                      ³             ³             ³'
@ 13,10 say '³       ³                      ³             ³             ³'
@ 14,10 say '³       ³                      ³             ³             ³'
@ 15,10 say '³       ³                      ³             ³             ³'
@ 16,10 say '³       ³                      ³             ³             ³'
@ 17,10 say '³       ³                      ³             ³             ³'
@ 18,10 say '³       ³                      ³             ³             ³'
@ 19,10 say '³       ³                      ³             ³             ³'
@ 20,10 say 'ÀÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÙ'

w_med_mat  := space(11)
w_med_cor  := space(11)

sombra(6,10,20,69)

campos := {'EST003->forma','EST003->descricao','mat_for()','cor_for()'}

divisor:={"³  ","  ³ "," ³ "," ³ "}

mascara:={'@!','@!','@!','@!'}

EST003->( dbedit(09,13,19,67,campos,"funcao13",mascara,'','',divisor ) )

close data

return

************************************
function funcao13(mode,n)
************************************

local tec:=lastkey()

if     tec == 28 ; help() ; return 1

elseif tec == 27 ; return 0

elseif tec == -3   && alteracao f4
       if !eof()
	  edita13()
       end
       return 1

elseif tec = -2   && inclusao f3
       inser13()
       keyboard ""
       return 2

elseif tec = -4   &&  exclusao f5
       if EST003->( ! eof() )
          EST004->( dbsetorder(1) )
          EST004->( dbseek( EST003->FORMA ))
          if EST004->( ! found() )
             if pergunta("Confirma exclus„o do Forma de Material ? ")
                while EST003->( ! rlock());end
                EST003->( dbdelete() )
                dbskip()
             end
          else
             mensbeep("Existe Tipo de Material com esta forma !")
          end
	end
	return 2

elseif tec = -5  && busca direta f6
       if !eof()
	  busca13()
       end
       return 2

status('Cadastro de Forma de Material')

end

return 1

************************************
static func inser13()
************************************

private X_FORMA,X_DESCRICAO

setcursor(1)

while .t.

   X_FORMA	:= space(3)
   X_DESCRICAO	:= space(20)

   @ 19,10 say '³       ³                      ³             ³             ³'
   @ 19,13 say X_FORMA	    picture "@!"
   @ 19,20 say X_DESCRICAO  picture "@!"
   @ 19,43 say W_MED_MAT    picture "@!"
   @ 19,57 say W_MED_COR    picture "@!"

   @ 19,13 get X_FORMA      picture "@!"     valid tes_cod_for( zerofill( X_FORMA ) , 03 )
   @ 19,20 get X_DESCRICAO  picture "@!"     when msg_nada()
   @ 19,43 get W_MED_MAT    picture "@K!"    valid tes_med_mat( W_MED_MAT, 11 ) when msg_mat()
   @ 19,57 get W_MED_COR    picture "@K!"    valid tes_med_cor( W_MED_COR, 11 ) when msg_cor()
   read

   if empty( X_FORMA ) .or. lastkey()=27
      setcursor(0)
      return NIL
end

if pergunta('Confirma inclus„o de Forma de Material ? ')
   EST003->( dbappend() )
   EST003->FORMA      := X_FORMA
   EST003->DESCRICAO  := X_DESCRICAO
   EST003->P_MATERIAL := cod_medmat( W_MED_MAT )
   EST003->P_CORTE    := cod_medcor( W_MED_COR )

   EST003->( dbunlock() )
   scroll(09,13,19,67,1)

   W_MED_MAT  := '           '
   W_MED_COR  := '           '

   @ 19,43 say W_MED_MAT picture "@!"
   @ 19,57 say W_MED_COR picture "@!"

end

status('Cadastro de Forma de Material')

end

************************************
static func edita13()
************************************

private X_DESCRICAO  := EST003->descricao

W_MED_MAT := mat_for()
W_MED_COR := cor_for()

setcursor(1)

@ row(),20 get X_DESCRICAO    picture "@!" when msg_nada()
@ row(),43 get W_MED_MAT picture "@K!"  valid tes_med_mat (W_MED_MAT,11) when msg_mat()
@ row(),57 get W_MED_COR picture "@K!"  valid tes_med_cor (W_MED_COR,11) when msg_cor()
read

if empty(X_DESCRICAO) .or. lastkey()=27
   setcursor(0)
   return nil
end

while EST003->( ! rlock() ); end

EST003->DESCRICAO := X_DESCRICAO
EST003->P_MATERIAL := cod_medmat( W_MED_MAT )
EST003->P_CORTE    := cod_medcor( W_MED_COR )

EST003->( dbunlock() )
status('Cadastro de Forma de Material')

setcursor(0)

return nil

/*
----------------------------------------------------------------------------

                        Busca forma

----------------------------------------------------------------------------
*/
function busca13()
private X_FORMA := space(3)
private TB := savescreen(14,24,17,43)

setcursor(1)

@ 14,24 say "ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿"
@ 15,24 say '³ Forma...        ³'
@ 16,24 say "ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ"

sombra(14,24,16,42)

@ 15,35 get X_FORMA	picture "@!"

read

if (empty(X_FORMA)) .or. lastkey()=27
   setcursor(0)
   keyboar " "
   restscreen(14,24,17,41,tb)
   return nil
end

dbseek(X_FORMA,.t.)
setcursor(0)
restscreen(14,24,17,43,tb)

return nil

************************
function mat_for()
************************
   local WRET := space(11)

   do case
      case EST003->P_MATERIAL = 1
         WRET := 'B I T O L A'

      case EST003->P_MATERIAL = 2
         WRET := 'LARG / ESP '

      case EST003->P_MATERIAL = 3
         WRET := 'BIT.INT/EXT'

      case EST003->P_MATERIAL = 4
         WRET := 'ESPESSURA  '
   end

return WRET

***********************
function cor_for()
***********************
local WRET := space(11)

   do case
      case EST003->P_CORTE = 1
         WRET := 'COMPRIMENTO'

      case EST003->P_CORTE = 2
         WRET := 'COMP / LARG'

      case EST003->P_CORTE = 3
         WRET := 'SEM CORTE  '

      case EST003->P_CORTE = 4
         WRET := 'COM/LAR/ESP'

      case EST003->P_CORTE = 5
         WRET := 'ESPECIAL   '
   end

return WRET

************************
static func tes_desc(var)
************************

status('Material 1-Bitola 2-Lar/Esp 3-Bit.Int/Ext')

return .t.

****************************
static func tes_cod_for(var)
****************************
local R_VAR := readvar()

&R_VAR := VAR := strzero( val( VAR ), 3 )

EST003->( dbsetorder(1) )

if EST003->( dbseek( VAR ) )
   message("Forma de material ja cadastrada")
   return .f.
end

@ 19,13 say VAR picture "999"

return .t.

*****************************
static func tes_med_mat(var)
*****************************
local WRET := .T.

do case
   case VAR = '1          ' .or. VAR = 'B I T O L A'
      W_MED_MAT := 'B I T O L A'
      @ row(),43 say W_MED_MAT picture "@K!"

   case VAR = '2          ' .or. VAR = 'LARG / ESP '
      W_MED_MAT := 'LARG / ESP '
      @ row(),43 say W_MED_MAT picture "@K!"

   case VAR = '3          ' .or. VAR = 'BIT.INT/EXT'
      W_MED_MAT := 'BIT.INT/EXT'
      @ row(),43 say W_MED_MAT picture "@K!"

   case VAR = '4          ' .or. VAR = 'ESPESSURA  '
      W_MED_MAT := 'ESPESSURA  '
      @ row(),43 say W_MED_MAT picture "@K!"

   otherwise
      message ('Medidas para material inv lido')
      WRET := .F.

end


return WRET

************************
static func tes_med_cor(var)
************************
local WRET := .T.

   do case
      case VAR =  '1          '  .or. VAR = 'COMPRIMENTO'
         W_MED_COR := 'COMPRIMENTO'
      case VAR =  '2          '  .or. VAR = 'COMP / LARG'
         W_MED_COR := 'COMP / LARG'
      case VAR =  '3          '  .or. VAR = 'SEM CORTE  '
         W_MED_COR := 'SEM CORTE  '
      case VAR =  '4          '  .or. VAR = 'COM/LAR/ESP'
         W_MED_COR := 'COM/LAR/ESP'
      case VAR =  '5          '  .or. VAR = 'ESPECIAL   '
         W_MED_COR := 'ESPECIAL   '
      otherwise
         message ('Medidas de Corte para material inv lido')
	 WRET := .F.
   end

   @ row(),57 say W_MED_COR picture "@K!"

return WRET

******************
function msg_mat()
******************
   status('Material 1-Bitola; 2-Larg/Espes; 3-Bit.Int/Ext; 4-Espessura ')
return .T.

******************
function msg_cor()
******************
   status(' Corte  1-Comp; 2-Comp/Larg; 3-S/ Corte; 4-Com/Lar/Esp; 5-Esp')
return .T.

******************
function msg_nada()
******************
   status(' ')
return .T.

/*
----------------------------------------------------------------------------

     Retorna codigo da medida do MATERIAL

----------------------------------------------------------------------------
*/
function cod_medmat( P_MED_MAT)

   local WRET := 0

   // medida do material
   do case
      case P_MED_MAT = 'B I T O L A'
         WRET :=  1

      case W_MED_MAT = 'LARG / ESP '
         WRET :=  2

      case W_MED_MAT = 'BIT.INT/EXT'
         WRET :=  3

      case W_MED_MAT = 'ESPESSURA  '
         WRET :=  4
   endcase

return WRET

/*
----------------------------------------------------------------------------

     Retorna codigo da medida de CORTE do material

----------------------------------------------------------------------------
*/
function cod_medcor( P_MED_COR)
   local WRET := 0

   // medida do corte
   do case
      case P_MED_COR = 'COMPRIMENTO'       // COMP
         WRET :=  1

      case P_MED_COR = 'COMP / LARG'       // COMP/LARG
         WRET :=  2

      case P_MED_COR = 'SEM CORTE  '       // PESO
         WRET :=  3

      case P_MED_COR = 'COM/LAR/ESP'       // COMP/LARG/ESP
         WRET :=  4

      case P_MED_COR = 'ESPECIAL   '       // ESPECIAL
         WRET :=  5
   endcase

return WRET
