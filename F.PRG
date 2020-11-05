











@01,00 say 'Esperando p/ continuar...'
inkey(0)

*-------------------------
function caixa (msg)
*-------------------------


lin1 = 11
col1 = 32
lin2 = 12
col2 = 37

wlin1   = 8
wcol1   = 20
wlin2   = 15
wcol2   = 46

do while col1 <> wcol1 .and. col2 <> wcol2

      @ lin1 ,col1 to lin2 ,col2

      @ lin1 ,col1 clear to lin2 ,col2


      lin1 = lin1-1
      col1 = col1 -3
      wlin2  = wlin2   +1
      col2   = wcol2   +3
enddo

if col1 =  wcol1 .and. col2 = wcol2

    @ lin1,col1   to   lin2,col2

end
@ lin1,col1 say msg

return (0)

