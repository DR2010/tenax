use VEN001 NEW

use AGE001 new

VEN001->( dbgotop() )
while VEN001->( ! eof() )
   AGE001->( dbappend())
   AGE001->NOME   := VEN001->RAZAO
   AGE001->CODCLI := VEN001->CODCLI
   AGE001->TEL1   := VEN001->TEL01
   AGE001->DDD    := VEN001->DDD01

   VEN001->( dbskip() )
end

