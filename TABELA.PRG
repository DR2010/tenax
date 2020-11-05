//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ TABELA.PRG() - Funcao para criar tabela usando o TBROWSE(), controlar o   ³
//³                movimento dentro da tabela e mudancao de registro.         ³
//ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´
//³ Programador: Marcos A. F. Santos        ³ Data.......: 19/01/1995         ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

#include "inkey.ch"
#include "sic.ch"

#define LI_SEPH "Ä"
#define LI_SEPR "Í"
#define LI_SEPV "³"

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ TABELANEW() - Funcao para definir a tabela.                               ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
function tabelanew( CAMPO          , ; // Vetor de campos do arquivo
                    MASCARA        , ; // Vetor de picture dos campos
                    CABECALHO      , ; // Vetor de cabecalho da tabela
                    TAMANHO        , ; // Vetor de tamanho das colunas da tabela
                    BESCAPE        , ; // Bloco de codigo de condicao da tabela
                    COR            , ; // Cor da tabela
                    TITULO         , ; // Titulo da tabela
                    LININI         , ; // Linha inicial da tabela
                    LINFIM         , ; // Linha final da tabela
                    COLINI         , ; // Coluna inicial da tabela
                    BLOCK_DISP       ; // Bloco de codigo para definicao da visualizacao da coluna
                  )

local  N           := 0
local  TABELA      := nil
local  COLFIM      := 0
local  TAMCOL      := 0

for N:=1 to len(TAMANHO)
    TAMCOL += TAMANHO[N]
    TAMCOL += if( N>1 , 1 , 0 )
next

LININI := if( LININI==NIL , 03 , LININI )
LINFIM := if( LINFIM==NIL , 20 , LINFIM )
COLINI := if( COLINI==NIL , int((80-TAMCOL)/2)-1 , COLINI )
COLFIM := COLINI + TAMCOL + 1

if TAMCOL <= 80

   @ LININI,COLINI to LINFIM,COLFIM double
   @ LININI,COLINI+1+(((COLFIM-COLINI)-(len(TITULO)))/2) say TITULO

   TABELA := tbrowsedb( LININI+1, COLINI+1, LINFIM, COLFIM-1 )

   TABELA:headsep := LI_SEPH
   TABELA:footsep := LI_SEPR
   TABELA:colsep  := LI_SEPV

   TABELA:skipblock := {|x| mudareg(X,BESCAPE) }

   TABELA:colorspec := COR

   for N:=1 to len(CAMPO)
       COLUNA := tbcolumnnew( CABECALHO[N],fieldwblock(CAMPO[N],select()) )
       COLUNA:width := TAMANHO[N]
       if N > 1
          COLUNA:headsep := replicate("Ä",TAMANHO[N]-1)
          COLUNA:headsep := "Â" + COLUNA:headsep
          COLUNA:footsep := replicate("Í",TAMANHO[N]-1)
          COLUNA:footsep := "Ï" + COLUNA:footsep
       endif
       TIPO := valtype(eval(COLUNA:block))
       COLUNA:defcolor := {1,2}
       TABELA:addcolumn(COLUNA)
   next

   TABELA:freeze := len(CAMPO)-1 // Congela as colunas mais a esquerda

endif

return( TABELA )


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ TABMOV() - Funcao para controlar o movimento da tabela.                   ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
function tabmov( TABELA )

// Nao permite que o cursor seja posicionado nas coluna congeladas
if TABELA:colpos <= TABELA:freeze
   TABELA:colpos := TABELA:freeze + 1
endif

// Faz estabilizacao da tabela ate terminar ou uma tecla for pressionada
do while nextkey()==0 .and. .not. TABELA:stabilize()
enddo

TABELA:colorrect( {TABELA:rowpos,1,TABELA:rowpos,TABELA:colcount},{2,1} )

if ( TABELA:stable )
   if ( TABELA:hittop .OR. TABELA:hitbottom )
      tone( 125,0 )
   endif
   TK    := inkey(0)
endif

do case
   case ( TK == K_DOWN )
        TABELA:down()
   case ( TK == K_UP )
        TABELA:up()
   case ( TK == K_PGDN )
        TABELA:pagedown()
   case ( TK == K_PGUP )
        TABELA:pageup()
   case ( TK == K_CTRL_PGUP )
        TABELA:gotop()
   case ( TK == K_CTRL_PGDN )
        TABELA:gobottom()
   case ( TK == K_RIGHT )
        TABELA:right()
   case ( TK == K_LEFT )
        TABELA:left()
   case ( TK == K_HOME )
        TABELA:home()
   case ( TK == K_END )
        TABELA:end()
   case ( TK == K_CTRL_LEFT )
        TABELA:panleft()
   case ( TK == K_CTRL_RIGHT )
        TABELA:panright()
   case ( TK == K_CTRL_HOME )
        TABELA:panhome()
   case ( TK == K_CTRL_END )
        TABELA:panend()
endcase
TABELA:refreshcurrent()

return( TK )

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ MUDAREG() - Funcao para movimentar o ponteiro do arquivo .DBF             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
function mudareg( N,BESCAPE )

local  I          := 0
local  REG_ANT    := recno()
local  CONT       := 0

do case
   case N > 0 .AND. recno() < lastrec() + 1
        CONT := 1
        do while CONT <= N
           dbskip()
           if eof() .or. ! eval( BESCAPE )
              dbskip(-1)
              CONT := N + 1
           else
              I++
              CONT ++
           endif
        enddo
   case N < 0
        CONT := -1
        do while CONT >= N
           dbskip(-1)
           if bof() .or. eof() .or. ! eval( BESCAPE )
              CONT := N - 1
              if !bof() .and. !eof()
                 dbskip()
              endif
           else
              I --
              CONT --
           endif
        enddo
   case N == 0
        if deleted()
           dbskip()
           I++
        endif
        if ! eval( BESCAPE )
           I := 10
        endif

endcase

return( I )
