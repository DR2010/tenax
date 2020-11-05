/*
   VEN - VENDAS
   VEN025.PRG - Cadasastro de frete
*/

abrir("VEN024")

// TBROWSE

private  W_FILE      := {}
private  CAMPO       := {}
private  MASCARA     := {}
private  CABECALHO   := {}
private  TAMANHO     := {}
private  BESCAPE     := {|| .T. }
private  COR         := W_COREDIT
private  TITULO      := " Valor do Frete "
private  LININI      := 04
private  LINFIM      := 20
private  COLINI      := 15
private  COLFIM      := 55
private  BLOCK_DISP  := {|| .T. }
private  CAB_TITULO  := nil
private  BORDA       := 1
private  FLAG        := .T.
private  TECLA       := nil
private  TABELA      := nil

aadd( CAMPO     , "Peso_min" )
aadd( CAMPO     , "Peso_max" )
aadd( CAMPO     , "Valor" )

aadd( MASCARA   , "9999999.99"   )
aadd( MASCARA   , "9999999.99"   )
aadd( MASCARA   , "9999999.99"   )

aadd( CABECALHO , "Peso minimo"  )
aadd( CABECALHO , "Peso maximo"      )
aadd( CABECALHO , "Valor"   )

aadd( TAMANHO   , 12 )
aadd( TAMANHO   , 12 )
aadd( TAMANHO   , 12 )

aadd( W_FILE , "VEN024" )
aadd( W_FILE , "VEN024" )
aadd( W_FILE , "VEN024" )

W_TELA := savescreen(,,,,)

select VEN024
VEN024->( dbsetorder(1) )

TABELA := tabelanew( CAMPO          , ;
                     MASCARA        , ;
                     CABECALHO      , ;
                     TAMANHO        , ;
                     BESCAPE        , ;
                     COR            , ;
                     TITULO         , ;
                     LININI         , ;
                     LINFIM         , ;
                     COLINI         , ;
                     BLOCK_DISP     , ;
                     CAB_TITULO     , ;
                     BORDA          , ;
                     COLFIM         , ;
                     W_FILE         , ;
                   )

CONTINUA := .T.


do while CONTINUA .and. ( (TEC:=tabmov(TABELA)) != 27 )

 do case
  case  tec == 28 ; help("VEN024") 
  case  tec == 27 ; return 0
  case  tec == -3   && alteracao f4
       if !eof()
          edita024()
          keyboard ""
          TABELA:REFRESHALL()
       end

 
  case  tec = -2   && inclusao f3
       inser024()
       keyboard ""
       TABELA:REFRESHALL()

   case  tec = -4   &&  exclusao f5
       if !eof()
          if conf("Confirma exclus„o de Pre‡o ","S")
             while VEN024->( ! rlock());end
             dbdelete()
             dbskip()
          end
        end
        TABELA:REFRESHALL()
 
 end
end 
restscreen(,,,,,W_TELA)
dbcloseall()

 

************************************
function INSER024()
************************************
local wscr := savescreen()
setcursor(1)

while .t.

   X_PESO_MIN  := 0.0
   X_PESO_MAX  := 0.0
   X_VALOR     := 0.0

   tela024()

   @ 11,25 get X_PESO_MIN   pict "9999999.99"
   @ 12,25 get X_PESO_MAX   pict "9999999.99"
   @ 13,25 get X_VALOR      pict "9999999.99"
   read

   if lastkey()=27
      setcursor(0)
      exit
   end

   if VEN024->( dbseek( str(X_PESO_MIN,12,2 )))
      message('Valor de frete j  Cadastrado')
      INKEY(0)
      LOOP
   end

   if conf('Confirma inclus„o de Pre‡o','S')
      VEN024->( dbappend() )
      VEN024->PESO_MIN := X_PESO_MIN
      VEN024->PESO_MAX := X_PESO_MAX
      VEN024->VALOR    := X_VALOR
      VEN024->( dbunlock() )
      EXIT
   end

end

restscreen(,,,,WSCR )
return .T.

************************************
function EDITA024()
************************************
local wscr := savescreen()
setcursor(1)

while .t.

   X_PESO_MIN  := VEN024->PESO_MIN
   X_PESO_MAX  := VEN024->PESO_MAX
   X_VALOR     := VEN024->VALOR

   tela024()

   @ 11,25 get X_PESO_MIN   pict "99999.99"
   @ 12,25 get X_PESO_MAX   pict "99999.99"
   @ 13,25 get X_VALOR      pict "9999999.99"
   read

   if lastkey()=27
      setcursor(0)
      exit
   end

   if conf('Confirma Alteracao de Pre‡o','S')
      while VEN024->( ! rlock()); loop; end
      VEN024->PESO_MIN := X_PESO_MIN
      VEN024->PESO_MAX := X_PESO_MAX
      VEN024->VALOR    := X_VALOR
      VEN024->( dbunlock() )
      EXIT
   end

end

restscreen(,,,,WSCR )
return .T.

procedure tela024()

@ 10,10 say 'ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿'
@ 11,10 say '³ Peso minimo:                                ³'
@ 12,10 say '³ Peso maximo:                                ³'
@ 13,10 say '³ Preco......:                                ³'
@ 14,10 say 'ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ'

return
