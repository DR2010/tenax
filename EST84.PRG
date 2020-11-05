/*

   SCM - Sistema de Controle Metalurgico
   EST84.PRG - Recuperacao dos Dados
*/

save screen to back
clear

text
       旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴커
       �84                 RECUPERACAO DO SISTEMA                   �
       읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴켸

           ATENCAO OS DISCOS DEVERAO ESTAR NA ORDEM DE GRAVACAO

                      (TECLE <CTRL-C> PARA ABORTAR)

endtext

! restore a: c: /s
! del *.ntx

verindex()

data := date()
save to back all like data
restore screen from back

return
