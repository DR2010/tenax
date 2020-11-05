/*
   ven - Vendas
   ven366.prg - Comissao de Vendedor
*/
#include 'inkey.ch'

abrir("VEN014")

status('Tabela de Comissoes de Venda')

tela366()

X_DESCMAX    := 0.00
X_COMISSAO   := 0.00
X_DATA       := date()
X_USUARIO    := space(20)
X_GRUPO      := space(2)

     //  ³ 12    ³ 20        ³ 32        ³ 44       ³ 55                   ³'

P_CAMPOS := { " ' '+ VEN014->GRUPO            +'     ³ '+"+;
              " str(VEN014->DESCMAX ,8,2)+'    ³  '+"+;
              " str(VEN014->COMISSAO,8,2)+'   ³  '+"+;
              " dtoc(ven014->DATA)       +'  ³  '+"+;
              " VEN014->USUARIO " }

ven014->( dbedit(09,11,21,68,P_CAMPOS,"funcao366",,'','') )
dbcloseall()

return

/*
-----------------------------------------------------------------------------
                               FUNCAO366
-----------------------------------------------------------------------------
*/
function funcao366( MODE, N )

local tec:=lastkey()

if     tec == 28 ; socorro1() ; return 1

elseif tec == 27 ; return 0

elseif tec == -3   && alteracao f4
       if !eof()
          p366_alterar()
          end
          return 1

elseif tec = -2   && inclusao f3
       p366_incluir()
       keyboard ""
       tela366()
       return 2

elseif tec = -4   &&  exclusao f5
       if !eof()
          if conf("Confirma exclus„o da Comissao de Venda ","S")
             while VEN014->( ! rlock() ); end
             dbdelete()
             dbskip()
          end
        end
        return 2

end

return 1

/*
-----------------------------------------------------------------------------
                               p366_incluir()
-----------------------------------------------------------------------------
*/
procedure p366_incluir()

setcursor(1)

while .t.

   X_GRUPO      := space(2)
   X_DESCMAX    := 0.00
   X_COMISSAO   := 0.00
   X_DATA       := date()
   X_USUARIO    := space(20)
   
   @ 21,12 get X_GRUPO     picture '@!'
   @ 21,23 get X_DESCMAX   picture '999.99'
   read

   if lastkey()=K_ESC; exit; end

   VEN014->( dbsetorder(1))
   VEN014->( dbseek( X_GRUPO+str(X_DESCMAX,6,2) ) )

   if VEN014->( found() )
       message('Comissao de Venda Ja Cadastrado')
       exit
   end

   @ 21,38 get X_COMISSAO  Picture "999.99"
   @ 21,50 get X_DATA
   read

   if lastkey()=27
      setcursor(0)
      return nil
   end

   if conf('Confirma inclus„o da Comiss„o de Venda','N')
     ven014->( dbappend() )
     ven014->GRUPO    :=  X_GRUPO
     ven014->DESCMAX  :=  X_DESCMAX
     ven014->COMISSAO :=  X_COMISSAO
     ven014->DATA     :=  X_DATA
     ven014->USUARIO  :=  M->USUARIO
     ven014->( dbunlock() )
     @ 21,10 say '³        ³             ³             ³            ³            ³'
   end
end

return

/*
-----------------------------------------------------------------------------
                               p366_alterar()
-----------------------------------------------------------------------------
*/
procedure p366_alterar()

setcursor(1)
   @ row(),19 say '³             ³             ³            ³            ³'
   X_DESCMAX   := ven014->DESCMAX
   X_COMISSAO  := ven014->COMISSAO
   X_DATA      := ven014->DATA
   X_USUARIO   := ven014->USUARIO
   
   @ row(),23 say X_DESCMAX

   @ row(),38 get X_COMISSAO  Picture "999.99"
   @ row(),50 get X_DATA
   @ row(),63 say X_USUARIO

   read

   if lastkey()=27
      setcursor(0)
      return nil
   end
   if conf('Confirma a alteracao ?')
     while ven014->( ! rlock() ); end
     ven014->DESCMAX  :=  X_DESCMAX
     ven014->COMISSAO :=  X_COMISSAO
     ven014->DATA     :=  X_DATA
     ven014->USUARIO  :=  M->USUARIO
     ven014->( dbunlock() )
   endif
   setcursor(0)

return nil

/*
-----------------------------------------------------------------------------
                               p366_excluir()
-----------------------------------------------------------------------------
*/
procedure p366_excluir()

if conf('Confirma exclus„o de comiss„o')
   while ven014->( ! rlock() ); end
   ven014->( dbdelete())
end

return

function tela366()
 @ 06,10 say 'ÚÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄ¿'
 @ 07,10 say '³ Grup   ³  %Desc.M x  ³  %Comiss„o  ³    Data    ³  Usu rio   ³'
 @ 08,10 say 'ÃÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄ´'
 @ 09,10 say '³        ³             ³             ³            ³            ³'
 @ 10,10 say '³        ³             ³             ³            ³            ³'
 @ 11,10 say '³        ³             ³             ³            ³            ³'
 @ 12,10 say '³        ³             ³             ³            ³            ³'
 @ 13,10 say '³        ³             ³             ³            ³            ³'
 @ 14,10 say '³        ³             ³             ³            ³            ³'
 @ 15,10 say '³        ³             ³             ³            ³            ³'
 @ 16,10 say '³        ³             ³             ³            ³            ³'
 @ 17,10 say '³        ³             ³             ³            ³            ³'
 @ 18,10 say '³        ³             ³             ³            ³            ³'
 @ 19,10 say '³        ³             ³             ³            ³            ³'
 @ 20,10 say '³        ³             ³             ³            ³            ³'
 @ 21,10 say '³        ³             ³             ³            ³            ³'
 @ 22,10 say 'ÀÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÙ'
return  
