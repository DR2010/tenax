***********************************************************************
*
*   REDE1.PRG
*   ARQUIVO DE PROCEDIMENTO PARA O USO DO CLIPPER EM REDE
*
*   AUTOR : RICARDO J. S. RITO
*   INICIO : 11:39:54  05/08/1994
*
***********************************************************************

function  Net_use
parameters  pfile,palias,pexclusive,pretry
private   pforever

pforever = pretry == 0

DO WHILE (pretry > 0 .or. pforever)
    IF  pexclusive
        USE (pfile) ALIAS  &palias.  EXCLUSIVE
    ELSE
        USE (pfile) ALIAS  &palias.
    ENDIF
    IF USED()
       EXIT
    ENDIF
    INKEY(1)
    pretry = pretry - 1
ENDDO
RETURN USED()


function  Rec_lock
parameter  Lretry
private  Lforever

Lforever = Lretry == 0
DO WHILE (!RLOCK () .AND. (Lretry > 0 .or. Lforever))
   INKEY (1)
   Lretry = lretry - 1
ENDDO
RETURN RLOCK()

function ADD_REC
   parameters lretry
   private lforever
   lforever = lretry == 0
   Do while lretry > 0 .or. lforever
      Append blank
      If !NETERR()
         Exit
      Endif
      Inkey(1)
      lretry = lretry - 1
   Enddo
Return !NETERR()