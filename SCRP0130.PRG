//旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�
//� >>>>>>>>>>>>>>>>>>>>>> RODOTEC SISTEMAS DE CONTROLE <<<<<<<<<<<<<<<<<<<<< �
//�                                                                           �
//� >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>  SCRP0130  <<<<<<<<<<<<<<<<<<<<<<<<<<<<<< �
//�                                                                           �
//� Sistema: Sistema de Cadastro de Rodoviarios                               �
//쳐컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�
//� Descricao..: Modulo de tabela de cargos                                   �
//쳐컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴쩡컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�
//� Cliente....: SETRERJ                    � Ultima Alteracao                �
//� Analista...: Selita                     � Autor :                         �
//� Programador: Marcos A. F. Santos        � Dt/Hr :                         �
//� Inicio.....: 24/01/1995                 � Motivo:                         �
//�                                         �                                 �
//읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴좔컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�

#include "inkey.ch"
#include "sic.ch"

function scrp0130()

local  getlist     := {}

local  COR_OLD     := setcolor()
local  CURSOR_OLD  := setcursor(0)
local  CONTINUA    := .T.

local  CAMPO       := {}
local  MASCARA     := {}
local  CABECALHO   := {}
local  TAMANHO     := {}
local  TECLA       := nil
local  BESCAPE     := {|| .T. }
local  TITULO      := " Tabela de Cargos "

private TABELA     := nil

if fileopen( "TABCARGO" )

   AADD( CAMPO     , "COD_CARGO" )
   AADD( CAMPO     , "DESC_CARG" )

   AADD( MASCARA   , "999"        )
   AADD( MASCARA   , "@!"         )

   AADD( CABECALHO , "Cd."       )
   AADD( CABECALHO , "Descri뇙o" )

   AADD( TAMANHO   , 03 )
   AADD( TAMANHO   , 25 )

   setcolor( W_PDCOR )
   @ 03,00 clear to 20,79

   setcolor( W_COREDIT )

   boxefunc() // Coloca as teclas de funcao na tela

   mensagem("Escolha uma fun뇙o...")

   TABELA := tabelanew( CAMPO          , ;
                        MASCARA        , ;
                        CABECALHO      , ;
                        TAMANHO        , ;
                        BESCAPE        , ;
                        W_COREDIT      , ;
                        TITULO         , ;
                        04               ;
                      )

   CONTINUA := .T.
   do while CONTINUA .and. ( (TECLA:=tabmov(TABELA)) != K_ESC )

      TECLA := upper(chr(TECLA))

      do case
         case ( TECLA == "I" ) // Inclusao
              push_but(22,14," Incluir ")
              T_INC( MASCARA,TAMANHO )
              cria_but( 22,14,' Incluir ',22,15,"I" )
              TABELA:refreshall() // Determina que todas as linha sejam reapresentadas

         case ( TECLA == "A" ) // Alteracao
              if !eof()
                 push_but(22,25," Alterar ")
                 T_ALT( MASCARA,TAMANHO )
                 cria_but( 22,25,' Alterar ',22,26,"A" )
                 TABELA:refreshcurrrent() // Determina que a linha seja reapresentada
              endif

         case ( TECLA == "E" ) // Exclusao
              if !eof()
                 push_but(22,36," Excluir ")
                 T_EXC( )
                 cria_but( 22,36,' Excluir ',22,37,"E" )
                 TABELA:refreshall() // Determina que todas as linha sejam reapresentadas
              endif

         case ( TECLA == "B" ) // Busca
              if !eof()
                 push_but(22,47," Busca ")
                 T_BUS( MASCARA )
                 cria_but( 22,47,' Busca ',22,48,"B" )
                 TABELA:refreshall() // Determina que todas as linha sejam reapresentadas
              endif

         case ( TECLA == "S" ) // Sair
              push_but(22,56," Sair ")
              CONTINUA := .F.

      endcase

   enddo

endif

dbcloseall()
setcursor(CURSOR_OLD)
setcolor(COR_OLD)

return( nil )

//旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴커
//� Procedimento .: BOXEFUNC                                                   �
//� Objetivo .....: Boxe com as teclas de funcao                               �
//읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴켸
static function boxefunc()

local W_OLDCOR := setcolor()

setcolor( W_PDCOR )
cria_but( 22,14,' Incluir '      ,22,15,"I" )
cria_but( 22,25,' Alterar '      ,22,26,"A" )
cria_but( 22,36,' Excluir '      ,22,37,"E" )
cria_but( 22,47,' Busca '        ,22,48,"B" )
cria_but( 22,56,' Sair '         ,22,57,"S" )

setcolor( W_OLDCOR )

return( NIL )

//旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴커
//� Procedimento : T_INC                                                       �
//� Objetivo     : Incluir cargos                                              �
//읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴켸
static function T_INC( MASCARA,TAMANHO )

local  REG_ANT    := recno()
local  CURSOR_OLD := setcursor(1)
local  N          := 0
local  COLUNA     := {}
local  VET_EDICAO := {}

// Limpar as colunas para inclusao de registros
setcolor( W_COREDIT )
for N:=1 to len(TAMANHO)
    AADD( COLUNA , if( N==1 , TABELA:nleft , (COLUNA[N-1]+TAMANHO[N-1]+1) ) )
    @ TABELA:ntop+2,COLUNA[N] clear to TABELA:nbottom-1,COLUNA[N]+TAMANHO[N]-1
next

do while .t.

   VET_EDICAO := { {           0,MASCARA[1],TABELA:ntop+2,COLUNA[1] } , ;
                   {   space(25),MASCARA[2],TABELA:ntop+2,COLUNA[2] }   ;
                 }

   setcolor( W_CORGET )

   getedit( VET_EDICAO,{|A| pre_valid(A,"I")},{|A| pos_valid(A,"I")} )

   if lastkey()=K_ESC; exit; endif

   if pergunta( " Confirma inclus꼘 do cargo (S/N)? " )
      if appendnet()
         fieldput( 1 , VET_EDICAO[1,1] )
         fieldput( 2 , VET_EDICAO[2,1] )
         dbcommit()
         dbunlock()
         REG_ANT := recno()
      else
         menswait( "N꼘 foi poss죞el gravar o registro, tente novamente!" )
      endif
   endif

enddo

mensagem("Escolha uma fun뇙o...")
dbgoto( REG_ANT )
setcursor( CURSOR_OLD )

return( NIL )

//旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴커
//� Procedimento : T_ALT                                                       �
//� Objetivo     : Alterar cargo                                               �
//읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴켸
static function T_ALT( MASCARA,TAMANHO )

local  CURSOR_OLD := setcursor(1)
local  LINHA      := TABELA:ntop + TABELA:rowpos + 1
local  COLUNA     := {}
local  N          := 0
local  LLOCK      := .T.
local  VET_EDICAO := {}

for N:=1 to len(TAMANHO)
    AADD( COLUNA , if( N==1 , TABELA:nleft , (COLUNA[N-1]+TAMANHO[N-1]+1) ) )
next

VET_EDICAO := { { COD_CARGO,MASCARA[1],LINHA,COLUNA[1] } , ;
                { DESC_CARG,MASCARA[2],LINHA,COLUNA[2] }   ;
               }

setcolor( W_CORGET )

getedit( VET_EDICAO,{|A| pre_valid(A,"A")},{|A| pos_valid(A,"A")} )

if lastkey() != K_ESC
   if pergunta( " Confirma altera뇙o do cargo (S/N)? " )
      do while ! rlocknet()
         if ! pergunta( "Registro locado por outra esta뇙o, Continua?" )
            LLOCK := .F.
            exit
         endif
         mensagem( "" )
      enddo
      if LLOCK
         fieldput( 1 , VET_EDICAO[1,1] )
         fieldput( 2 , VET_EDICAO[2,1] )
         dbcommit()
         dbunlock()
      endif
   endif
endif

setcursor( CURSOR_OLD )

return( NIL )

//旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴커
//� Procedimento : T_EXC                                                       �
//� Objetivo     : Excluir cargo                                               �
//읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴켸
static function T_EXC( )

local  CURSOR_OLD := setcursor(1)
local  LLOCK      := .T.

setcolor( W_CORBARR )

if pergunta( " Confirma exclus꼘 do cargo (S/N)? " )
   do while ! rlocknet()
      if ! pergunta( "Registro locado por outra esta뇙o, Continua?" )
         LLOCK := .F.
         exit
      endif
      mensagem( "" )
   enddo
   if LLOCK
      dbdelete()
   endif
endif

setcursor( CURSOR_OLD )

return( NIL )

//旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴커
//� Procedimento : T_BUS                                                       �
//� Objetivo     : Muda a ordem do indice e procura uma chave                  �
//읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴켸
static function T_BUS( MASCARA )

local  REG_ANT    := recno()
local  ORDEM_ANT  := indexord()
local  CURSOR_OLD := setcursor(1)
local  COR_OLD    := setcolor()
local  TELA_OLD   := savescreen()
local  VET_MENU   := {}
local  OPCAO      := 0
local  BLOCO_CHAV := nil
local  NORDEM     := nil
local  COLMAX     := maxcol()-2
local  VET_EDICAO := {}

aadd( VET_MENU , " C줰igo    " )
aadd( VET_MENU , " Descri뇙o " )

setcolor( W_CORMENU )
@ 16,COLMAX-2-11 to 19,COLMAX
@ 16,COLMAX-1-11 say " Ordem "
sombra(16,COLMAX-2-11,19,COLMAX)

mensagem( "Selecione o tipo de consulta!" )

OPCAO := achoice( 17,COLMAX-1-11,18,COLMAX-1,VET_MENU,.T.)

if OPCAO > 0
   restscreen( ,,,,TELA_OLD )
   do case
      case OPCAO == 1
           @ 15,COLMAX+1-16 say "旼컴컴컴컴컴컴커"
           @ 16,COLMAX+1-16 say "� C줰igo :     �"
           @ 17,COLMAX+1-16 say "읕컴컴컴컴컴컴켸"
           sombra(15,COLMAX+1-16,17,COLMAX)
           NORDEM := 1
           BLOCO_CHAV := {|| dbseek( strzero(VET_EDICAO[1,1],3) ) }
           VET_EDICAO := { { 0,MASCARA[1],16,COLMAX-1-03 } }
      case OPCAO == 2
           @ 15,COLMAX+1-41 say "旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�"
           @ 16,COLMAX+1-41 say "� Descri뇙o :                           �"
           @ 17,COLMAX+1-41 say "읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�"
           sombra(15,COLMAX+1-41,17,COLMAX)
           NORDEM := 2
           BLOCO_CHAV := {|| dbseek( VET_EDICAO[1,1] ) }
           VET_EDICAO := { { space(25),MASCARA[2],16,COLMAX-1-25 } }
   endcase

   getedit( VET_EDICAO,{|A| pre_valid(A,"I")},{|| .T.} )

   if lastkey() != K_ESC
      TABELA:gotop()
      dbsetorder( NORDEM )
      set softseek on
      eval( BLOCO_CHAV )
      set softseek off
   endif

endif

setcursor( CURSOR_OLD )
setcolor( COR_OLD )
restscreen( ,,,,TELA_OLD )

return( nil )

//旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴커
//� Procedimento : PRE_VALID                                                   �
//� Objetivo     : Pre-Valida o get                                            �
//읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴켸
static function PRE_VALID( CORRENTE,TIPO )

local  LVALUERET       := .T.
local  NUMERO          := CORRENTE:CARGO

do case
   case NUMERO == 1
        if TIPO == "I"
           mensagem("Digite o c줰igo do cargo...")
        else
           LVALUERET := .F.
        endif
   case NUMERO == 2
        mensagem("Digite a descri뇙o do cargo...")
endcase

return( LVALUERET )

//旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴커
//� Procedimento : POS_VALID                                                   �
//� Objetivo     : Pos-Valida o get                                            �
//읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴켸
static function POS_VALID( CORRENTE,TIPO )

local  CURSOR_OLD      := setcursor(1)
local  ORDEM_OLD       := indexord()
local  LVALUERET       := .T.
local  REG_ANT         := recno()
local  NUMERO          := CORRENTE:CARGO

do case
   case NUMERO == 1 // Codigo do cargo
        if empty( val(getlist[NUMERO]:buffer) )
           LVALUERET := .F.
           menswait( "C줰igo do cargo n꼘 pode ser vazio!" )
           mensagem("Digite o c줰igo do cargo...")
        else
           if getlist[NUMERO]:original != getlist[NUMERO]:varget()
              getlist[NUMERO]:buffer := strzero( val(getlist[NUMERO]:buffer),3 )
              dbsetorder( 1 )
              if dbseek( getlist[NUMERO]:buffer )
                 LVALUERET := .F.
                 menswait( "C줰igo do cargo j� existe!" )
                 mensagem("Digite o c줰igo do cargo...")
                 getlist[NUMERO]:undo()
              endif
              dbgoto( REG_ANT )
           endif
        endif

   case NUMERO == 2 // Descricao do cargo
        if empty( getlist[NUMERO]:buffer )
           LVALUERET := .F.
           menswait( "Descri뇙o do cargo n꼘 pode ser vazio!" )
           mensagem("Digite a descri뇙o do cargo...")
        else
           if getlist[NUMERO]:original != getlist[NUMERO]:varget()
              dbsetorder( 2 )
              if dbseek( getlist[NUMERO]:buffer )
                 LVALUERET := .F.
                 menswait( "Descri뇙o do cargo j� existe!" )
                 mensagem("Digite a descri뇙o do cargo...")
                 getlist[NUMERO]:undo()
              endif
              dbgoto( REG_ANT )
           endif
        endif

endcase

getlist[NUMERO]:varput( getlist[NUMERO]:buffer )
setcursor( CURSOR_OLD )
dbsetorder( ORDEM_OLD )

return( LVALUERET )
