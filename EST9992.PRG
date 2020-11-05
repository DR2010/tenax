
************************
static func tes_sta_ped(var)
************************

if empty(var)
   message('Campo Obrigatorio')
   return .f.
end

if var == 'P'
   return .t.
else
   if var == 'R'
      return .t.
   else
      message ('Status do Pedido Invalido')
      return .f.
   end
end

db_dat_ped := var
db_dat_ent := var_ent_05
db_sta_ped := var

return .t.

/*
-----------------------------------------------------------------------------
                      Funcao SEQ_DETALHE
-----------------------------------------------------------------------------
*/
function SEQ_DETALHE( VAR )

   local W_SEQ := 0

   EST006->( dbsetorder (2) )
   EST006->( dbseek( VAR) )

   while !(EST006->(EOF())) .and. VAR = EST006->PEDIDO
      W_SEQ := EST006->SEQUENC
      EST006->( dbskip() )
   enddo

   W_SEQ++

return W_SEQ

