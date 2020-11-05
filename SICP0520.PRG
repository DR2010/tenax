/*
  +---------------------------------------------------------------------------+
  | >>>>>>>>>>>>>>>>>>>>>> RODOTEC SISTEMAS DE CONTROLE <<<<<<<<<<<<<<<<<<<<< |
  |                                                                           |
  | >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>  SICP0520  <<<<<<<<<<<<<<<<<<<<<<<<<<<<<< |
  |                                                                           |
  | Sistema....: Sistema de Informacoes Cadastrais                            |
  |---------------------------------------------------------------------------|
  | Descricao..: Backup.                                                      |
  |---------------------------------------------------------------------------|
  | Cliente....: SEST/SENAT                               | Ultima Alteracao  |
  | Analista...: VanLoo/ Daniel Machado                   | Versao : 1.0      |
  | Programador: Daniel Machado                           | Data   : 20/04/94 |
  | Inicio.....: 06/04/1994                               | Hora   : 14:46    |
  +---------------------------------------------------------------------------+
*/
#include "inkey.ch"
#include "sic.ch"

private W_SCR := savescreen()

mensboxv({"O backup se utiliza do comando BACKUP do DOS, ",;
          "portanto e necessario te-lo no PATH.          ",;
          "                Tecle <ENTER> para prosseguir."})

WRESP := pergresp("(B)ackup - (R)estore - (A)bandona - (B/R) ?")

begin sequence
do case
   case WRESP = "B"
      cls
      ! backup c:\sest\*.dbf a:\ /s
   case WRESP = "R"
      cls
      ! restore a: c: /s
endcase

end sequence
restscreen(,,,,W_SCR)
return
