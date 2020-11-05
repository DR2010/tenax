
nHandle := fopen('CAMPOS.TXT', 0 )
if ferror() != 0
   ? 'erro : Arquivo sendo usado !'
   quit
end
set exact on
vez =1
cls
while .t.
   caracter := freadstr( nHandle, 1)
   if caracter = chr(13) .or. old_car = chr(13)
      if caracter = chr(13)
         @ row()+1,00 say ''
      else
      end
   else
      @ row(),col() say caracter
   end
   if vez > 10
      if len(caracter) = 0
         exit
      end
   end
   vez = vez + 1
   if row()=23
      inkey(0)
      cls
   end
   old_car := caracter
end



