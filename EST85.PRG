/*

   SCM - Sistema de Controle Metalurgico
   EST85.PRG - Cadastro de Senha
*/

begin sequence

/*
if substr( SEGURANCA,8,1 ) == " "
   message("Opcao nao autorizada para usuario desta senha!")
   break
end
*/
abrir("EST000")

save screen to telsenha


exclui  := alt      := .f.
flagsen := space(01)
vniveis := space(08)
vsenha  := space(10)
vacesso := space(11)
vnome   := space(30)

do while .t.

   @ 07,19 say 'ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿'
   @ 08,19 say '³                                         ³'
   @ 09,19 say '³ Codigo de Acesso                        ³'
   @ 10,19 say '³                                         ³'
   @ 11,19 say '³ Nome                                    ³'
   @ 12,19 say '³                                         ³'
   @ 13,19 say 'ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´'
   @ 14,19 say '³85       Senha                           ³'
   @ 15,19 say 'ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ'
   sombra(7,19,15,61)

   x := setcolor()

   setcolor(c_wtitle)

   @ 07,30 say 'Manutencao de Senhas'

   setcolor(x)

   save screen to telsenha2

   vacesso := decripta(vacesso)

   @ 09,38 get vacesso pict '@!'
   read

   if empty(vacesso)
      close data
      restore screen from telsenha
      break
   endif

   vacesso := encripta(vacesso)

   seek vacesso

   if found()
      cf := recchoice()

      do case
         case cf = 'R'
              vacesso := space(11)
              loop

         case cf = 'A'
              vnome   := decripta(nome)
              vniveis := decripta(niveis)
              alt     := .t.

         case cf = 'E'
              if conf('Confirma exclusao','N')
                 while EST000->( ! rlock() ); end
                 EST000->( dbdelete() )
                 EST000->( dbunlock() )
                 vacesso := space(11)
                 exclui  := .t.
              endif
              loop
      endcase
   else
     alt := .f.
   endif

   @ 11,26 get vnome pict "@!"
   read

   vsenha1 := "XZXZXZXZXZ"

   do while vsenha # vsenha1

      vsenha := vsenha1 := space(10)

      vsenha  := get_senha(14,37,10)

      xx := status("Reentre a senha para confirmar")

      // ?? chr(7)
      vsenha1 := get_senha(14,37,10)
 
      status(xx)

      if empty(vsenha)
         message(' Nao e valido senha em branco ! ')
         vsenha1 := 'ccc'
      endif

      if vsenha # vsenha1
         message(' Senha nao confirmada ! ')
      endif
   enddo

   select EST000

   if !alt
      append blank
   endif

   vnome   := encripta(vnome)
   vacesso := encripta(vacesso)
   vsenha  := encripta(vsenha)

   store ' ' to s1,s2,s3,s4,s5,s6,s7,s8,s9,s10,s11

   setanivel()

   vniveis := encripta(vniveis)

   while EST000->( ! flock() ); end

   replace nome   with vnome   , acesso with vacesso,;
           niveis with vniveis , senha  with vsenha

   vacesso := space(11)
   vnome   := space(30)
   flagsen := space(01)
   vniveis := space(08)
   restore screen from telsenha2

   if exclui
      pack
   endif

   EST000->( dbunlock() )

enddo
end sequence

return

*-----------------------------------------*
Static Function setanivel

save screen to telnivel

opcoes := {'Altera quantidade de Estoq.diretame/t.',;
           '......................................',;
           '......................................',;
           '......................................',;
           '......................................',;
           '......................................',;
           'Reorganiza/Salva/Recuperacao de dados.',;
           'Cadastro de senha.....................'}

tamlin := len(opcoes[1])+3
p1     := 40-int(tamlin/2)-2

@ 13,p1-1 to 22,p1+tamlin+1

sombra(13,p1-1,22,p1+tamlin+1)

@ 13,38-int(15/2) say ' S E T O R E S '             color c_wtitle
@ 22,38-int(27/2) say ' Tecle [ESC] para terminar ' color c_wtitle
op := 1
while op # 0
   for i = 1 to 8
       @ 13+i,p1 prompt opcoes[i]+ iif(substr(vniveis,i,1)='*','Sim ','Nao ')
   next
   menu to op
   if op # 0
      vniveis := substr(vniveis,1,op-1)+ iif(substr(vniveis,op,1)='*',' ','*')+substr(vniveis,op+1,len(vniveis)-op)
   end
end
restore screen from telnivel
return nil
