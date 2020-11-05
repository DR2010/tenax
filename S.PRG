use ESTROTIN new

use ESTDIREI new

ESTROTIN->( dbgotop() )
while ESTROTIN->(! EOF() )

   ESTDIREI->( dbappend() )
   ESTDIREI->CODROT   := ESTROTIN->CODROT
   ESTDIREI->CODUSUOT := 'DANIEL'
   ESTDIREI->ACESSO   := 'S'

   ESTROTIN->( dbskip() )
end
