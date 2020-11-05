# include "inkey.ch"

/*
  VEN372.PRG - PROGRAMA DE EMISSAO DE FAX
*/

abrir("VEN372")
abrir("ESTREPO")

telanum('VEN372','VEN372')
// declaracao de variaveis

PRIVATE X_CAB1    := 'TENAX'
PRIVATE X_CAB2    := 'ACOS ESPECIAIS'
PRIVATE X_TITULO  := 'TENAX ACO E FERRO LTDA. - TRAV. LEONOR MASCARENHAS,101 - RAMOS'
PRIVATE X_TITULO2 := 'TRANSMISAO DE FAX'
PRIVATE X_CEP     := 'CEP 21040-130 - RIO DE JANEIRO - RJ'
PRIVATE X_TEL     := 'TELEFONE: (021) 560-0675'
PRIVATE X_FAX     := 'FAX: (021) 564-3195'
PRIVATE X_CGC     := 'CGC 33.097.536/0001-26'
PRIVATE X_IE      := 'INSC.EST. 81.801.215'
PRIVATE X_TEXTO, X_PAGINA := 1 ,linhas := 1  

PRIVATE WRESP_IMP := 'I'
PRIVATE WIMP_ARQ  := space(12)
PRIVATE X_CODIGO
PRIVATE X_DESTINO  
PRIVATE X_N_FAX   
PRIVATE X_AT      
PRIVATE X_DEPTO   
PRIVATE X_N_MENS  
PRIVATE X_DATA    := date()
PRIVATE X_N_PAG
PRIVATE X_SOLICI  
PRIVATE X_ASSUNTO 
PRIVATE X_MEMO                   
PRIVATE X_TELANT  := SAVESCREEN(,,,,)

PRIVATE n_i   := chr(27)+chr(71)
PRIVATE n_f   := chr(27)+chr(72)
PRIVATE c_i   := chr(27)+chr(15)
PRIVATE c_f   := chr(18)
PRIVATE e_i   := CHR(27)+chr(14)
PRIVATE e_f   := chr(20)
PRIVATE roman := chr(27)+'x'+CHR(49)
*PRIVATE normal:= chr(27)+'x'+CHR(48)
PRIVATE linha80 := repl(chr(240),80)
    
PRIVATE p_e     := chr(195)
PRIVATE p_d     := chr(180)
PRIVATE baixo   := chr(193)
PRIVATE cima    := chr(194) 
PRIVATE parede  := chr(179)
PRIVATE c_d_c   := chr(191) 
PRIVATE c_e_c   := chr(218)
PRIVATE c_d_b   := chr(217)
PRIVATE c_e_b   := chr(192)


PRIVATE  W_FILE      := {}
PRIVATE  CAMPO       := {}
PRIVATE  MASCARA     := {}
PRIVATE  CABECALHO   := {}
PRIVATE  TAMANHO     := {}
PRIVATE  BESCAPE     := {|| .T.  }
PRIVATE  COR         := W_COREDIT
PRIVATE  TITULO      := " Fax "
PRIVATE  LININI      := 02

PRIVATE  LINFIM      := 22
PRIVATE  COLINI      := 00
PRIVATE  COLFIM      := 79
PRIVATE  BLOCK_DISP  := {|| .T. }
PRIVATE  CAB_TITULO  := nil
PRIVATE  BORDA       := 1

PRIVATE  TECLA       := nil
PRIVATE  TABELA      := nil

aadd( CAMPO , "CODIGO"     )
aadd( CAMPO , "NFAX"       )
aadd( CAMPO , "NPAG"       )
aadd( CAMPO , "DESTINO"    )
aadd( CAMPO , "ASSUNTO"    )
aadd( CAMPO , "DATA"       )
aadd( CAMPO , "ARQUIVO"       )

aadd( MASCARA , "@!"       )
aadd( MASCARA , "@!"       )
aadd( MASCARA , "99"       )
aadd( MASCARA , "@!"       )
aadd( MASCARA , "@!"       )
aadd( MASCARA , "99/99/99" )
aadd( MASCARA , "@!"       )

aadd( CABECALHO , "Numero" )
aadd( CABECALHO , "Fax" )
aadd( CABECALHO , "Pg" )
aadd( CABECALHO , "Para"       )
aadd( CABECALHO , "Assunto"    )
aadd( CABECALHO , "Data"       )
aadd( CABECALHO , "Arquivo"    )

aadd( TAMANHO , 06             )
aadd( TAMANHO , 15             )
aadd( TAMANHO , 02             )
aadd( TAMANHO , 23             )
aadd( TAMANHO , 10             )
aadd( TAMANHO , 08             )
aadd( TAMANHO , 08             )

aadd( W_FILE , "VEN372" )
aadd( W_FILE , "VEN372" )
aadd( W_FILE , "VEN372" )
aadd( W_FILE , "VEN372" )
aadd( W_FILE , "VEN372" )
aadd( W_FILE , "VEN372" )
aadd( W_FILE , "VEN372" )

setcolor(W_COREDIT)
SELECT VEN372
VEN372->(DBSETORDER(1))

TABELA := tabelanew( CAMPO          , ;
           MASCARA       , ;
           CABECALHO     , ;
           TAMANHO       , ;
           BESCAPE       , ;
           COR           , ;
           TITULO        , ;
           LININI        , ;
           LINFIM        , ;
           COLINI        , ;
           BLOCK_DISP    , ;
           CAB_TITULO    , ;
           BORDA         , ;
           COLFIM        , ;
           W_FILE          ;
         )

CONTINUA := .T.

do while CONTINUA .and. ( (TEC:=tabmov(TABELA)) != 27 )

   do case
      case TEC == 28 ; help("VEN372") 
      case TEC == 27 ; return 0

      case TEC == -3   && alteracao f4
          X_N_PAG := 0
          if VEN372->(!eof())
             editae372()
          end
          keyboard chr(1)
          tabela:refreshall()

      case TEC = -2   && inclusao f3
          insere372()
          FAX_IMPRE()
          keyboard chr(1)
          tabela:refreshall()

      case TEC = -5   && busca f6
          p372_busca()
          keyboard chr(32)
          tabela:refreshall()


      case TEC = -6   && emite fax
         if ! empty( VEN372->ARQUIVO )
            emite_fax()
         else
            mensbeep("Nao existe arquivo. ENTER")
         end

      case TEC = -4   &&  exclusao f5
          if VEN372->(!eof())
             if pergunta("Confirma exclus„o do Fax (S/N) ?")
                while VEN372->( ! rlock() ); end
                VEN372->( dbdelete() )
                VEN372->( dbunlock() )
                VEN372->( dbskip() )
             end
           end
          keyboard chr(1)
          tabela:refreshall()

      case tec = K_F10
          X_N_PAG := 0
          FAX_IMPRE()

      case TEC = K_ESC
         CONTINUA := .F.
   end
   select VEN372
enddo

close data

return

************************************
function insere372()
************************************

setcursor(1)

while .t.

    telae372()

    X_DESTINO := SPACE(35)
    X_N_FAX   := SPACE(17)
    X_AT      := SPACE(25)
    X_DEPTO   := SPACE(25)
    X_N_MENS  := 0
    X_DATA    := DATE()
*    X_N_PAG   := 0
    X_SOLICI  := SPACE(25)
    X_ASSUNTO := SPACE(20)
    X_MEMO    := space(10)
    X_CODIGO  := NOVO_FAX()

    @ 03,10 say X_CODIGO  PICT '@!'
    @ 04,10 get X_DESTINO PICT '@!'
    @ 04,62 get X_N_FAX   PICT '(9999)9999-99999'
    @ 05,10 get X_AT
    @ 05,48 get X_DEPTO   PICT '@!'
    @ 06,16 get X_N_MENS  PICT '999999'
    @ 06,42 get X_DATA    PICT '99/99/99'
 *   @ 06,67 get X_N_PAG   PICT '9999'
    @ 07,16 get X_SOLICI  PICT '@!'
    @ 07,53 get X_ASSUNTO PICT '@!'
    READ   
    if lastkey()=27; exit; end
    memo(.t.)
    
    if pergunta('Confirma inclus„o do Fax (S/N) ?')
       while VEN372->(!rlock());end
       VEN372->NFAX     := X_N_FAX
       VEN372->DESTINO  := X_DESTINO
       VEN372->ASSUNTO  := X_ASSUNTO
       VEN372->NMENS    := X_N_MENS
       VEN372->DATA     := X_DATA
       VEN372->AT       := X_AT
       VEN372->DEPTO    := X_DEPTO
       VEN372->MENSAGEM := strtran(X_MEMO,chr(141)+chr(10)," " )
       VEN372->SOLIC    := X_SOLICI
       VEN372->NPAG     := INT(MLCOUNT( VEN372->MENSAGEM,78 )/39 ) + 1
       VEN372->( DBUNLOCK() )
       EXIT
     end

end
RETURN
************************************
function editae372()
************************************
setcursor(1)

telae372()
    
    
    X_CODIGO  := VEN372->CODIGO
    X_DESTINO := VEN372->DESTINO
    X_N_FAX   := VEN372->NFAX
    X_AT      := VEN372->AT
    X_DEPTO   := VEN372->DEPTO
    X_N_MENS  := VEN372->NMENS
    X_DATA    := VEN372->DATA
    X_SOLICI  := VEN372->SOLIC
    X_ASSUNTO := VEN372->ASSUNTO
    X_MEMO    := strtran(VEN372->MENSAGEM,chr(141)+chr(10)," " )
    X_N_PAG   :=  INT(MLCOUNT( X_MEMO,78 )/39 ) + 1


    @ 03,10 say X_CODIGO  PICT '@!'
    @ 04,10 get X_DESTINO PICT '@!'
    @ 04,62 get X_N_FAX   PICT '(9999)9999-99999'
    @ 05,10 get X_AT
    @ 05,48 get X_DEPTO   PICT '@!'
    @ 06,16 get X_N_MENS  PICT '999999'
    @ 06,42 get X_DATA    PICT '99/99/99'
    @ 06,53 say 'N.Paginas...:'
    @ 06,67 say X_N_PAG   PICT '9999'
    @ 07,16 get X_SOLICI  PICT '@!'
    @ 07,53 get X_ASSUNTO PICT '@!'
    READ   
    if lastkey()=27
      RETURN
    end
    memo(.t.)

   if pergunta('Confirma Alteracao do Fax (S/N) ?')
      while VEN372->(!rlock());end
      VEN372->NFAX     := X_N_FAX
      VEN372->DESTINO  := X_DESTINO
      VEN372->ASSUNTO  := X_ASSUNTO
      VEN372->NMENS    := X_N_MENS
      VEN372->DATA     := X_DATA
      VEN372->AT       := X_AT
      VEN372->DEPTO    := X_DEPTO
      VEN372->MENSAGEM := strtran(X_MEMO,chr(141)+chr(10)," " )
      VEN372->SOLIC    := X_SOLICI
      VEN372->NPAG     := INT(MLCOUNT( X_MEMO,78 )/39 ) + 1
      VEN372->( DBUNLOCK() )
   end
return nil


/*
-------------------------------------------------------------------------------
Procedimento .: TEDITe372
Objetivo .....: Menu rapido
-------------------------------------------------------------------------------
*/
procedure tedite372()
   local W_OLDCOR := setcolor()

   setcolor(W_COREDIT)
   quadro(03,02,21,77,"")
   @ 05,02 say 'Æ'
   @ 05,77 say 'µ'
   @ 16,03 to 16,76 double
   @ 16,02 say 'Æ'
   @ 16,77 say 'µ'

   sombra(02,02,21,77)

   setcolor( W_OLDCOR )
return


/*
-------------------------------------------------------------------------------
Procedimento .: TELAe372
Objetivo .....: Menu rapido
-------------------------------------------------------------------------------
*/
procedure telae372()

   setcolor( W_CORGET )
   @ 02,00 say 'ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ '+'TRANSMISAO DE FAX'+' ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿'
   @ 03,00 say '³ Codigo:                                                          Pag.:       ³'
   @ 04,00 say '³ Para..:                                           N. Fax..:                  ³'
   @ 05,00 say '³ At....:                             Depto...:                                ³'
   @ 06,00 say '³ Mensagem N..:                 Data....:    /  /                              ³'
   @ 07,00 say '³ Solicitante.:                           Assunto.:                            ³'
   @ 08,00 say 'ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ Texto ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´'
   @ 09,00 say '³                                                                              ³'
   @ 10,00 say '³                                                                              ³'
   @ 11,00 say '³                                                                              ³'
   @ 12,00 say '³                                                                              ³'
   @ 13,00 say '³                                                                              ³'
   @ 14,00 say '³                                                                              ³'
   @ 15,00 say '³                                                                              ³'
   @ 16,00 say '³                                                                              ³'
   @ 17,00 say '³                                                                              ³'
   @ 18,00 say '³                                                                              ³'
   @ 19,00 say '³                                                                              ³'
   @ 20,00 say '³                                                                              ³'
   @ 21,00 say '³                                                                              ³'
   @ 22,00 say 'ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ'
  
return

/*
-------------------------------------------------------------------------------
Procedimento .: emite_fax
Objetivo .....: emite fax
-------------------------------------------------------------------------------
*/
procedure emite_fax()
   local W_SCROLD := savescreen()
   setcolor( W_CORGET )
   setcursor( 1 )
   @ 09,17 say 'ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿'
   @ 10,17 say '³ Disca 0 antes (S/N) :         ³'
   @ 11,17 say '³ Fax :                         ³'
   @ 12,17 say 'ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ'

   X_PREFIX  := 'S'
   X_FAXNUM  := space(20)

   @ 10,41 get X_PREFIX  picture '@!' valid X_PREFIX $ 'SN'
   @ 11,25 get X_FAXNUM  picture '@!'
   read

   if lastkey() <> K_ESC
      if pergunta( 'Confirma emissao (S/N) ?' )

         if X_PREFIX = 'S'
            X_RUN := 'ssfaxer 2 P0w'+ alltrim( x_faxnum )+' '+alltrim( VEN372->ARQUIVO ) + '.prn'
         else
            X_RUN := 'ssfaxer 2 P'  + alltrim( x_faxnum )+' '+alltrim( VEN372->ARQUIVO ) + '.prn'

         end

         ! (X_RUN)
      end
   end
   setcursor( 0 )
   restscreen(,,,,W_SCROLD )
return

procedure memo(modo)

 x_memo := memoedit(x_memo,09,02,21,78,modo,"memofunc")

return .T.

procedure memofunc( modo, linha, coluna )
  local X_KEY := LASTKEY(),PAG := INT((linha/39)), WRET := X_KEY
  
  @ 03,75 say strzero( PAG+1,3)
  @ 08,05 say ' linha: '+strzero(linha,3)
  @ 08,60 say ' coluna: '+strzero(coluna,3)
  IF X_KEY = K_F10
    WRET := 23
  end

RETURN (WRET)


procedure fax_impre()

    X_CODIGO  := VEN372->CODIGO
    X_DESTINO := VEN372->DESTINO
    X_N_FAX   := VEN372->NFAX
    X_AT      := VEN372->AT
    X_DEPTO   := VEN372->DEPTO
    X_N_MENS  := VEN372->NMENS
    X_DATA    := VEN372->DATA
    X_SOLICI  := VEN372->SOLIC
    X_ASSUNTO := VEN372->ASSUNTO
    X_MEMO    := strtran(VEN372->MENSAGEM,chr(141)+chr(10)," " )
    X_N_PAG   := INT(MLCOUNT( X_MEMO,78 )/39 ) + 1
    W_TITULO  := 'Fax para '+X_DESTINO
  IF DH_IMPRIME()
    while VEN372->( ! rlock() ); end
    VEN372->ARQUIVO := LEFT(WIMP_ARQ,8)
    VEN372->( dbunlock() )
    if WRESP_IMP = 'A'
      ESTREPO->( grava( WIMP_ARQ, date(), time(), W_TITULO, 80) )
    end
    for a = 1 to X_N_PAG
       @ 00,00 say ''
       FAX_CAB1()
       FAX_DET1(X_PAGINA)
       X_PAGINA++
    NEXT
  END
  DH_IMPOFF()
  @ 00,00 say ''
  X_PAGINA := 1
  linhas := 0
RETURN

procedure fax_cab1()
    @ prow(),00   say  roman + n_i
    @ prow()+1, int ((( 80-len(alltrim(X_CAB1)) )/2)) say X_CAB1
    @ prow()+1, int ((( 80-len(alltrim(X_CAB2)) )/2)) say X_CAB2 
    @ prow()+1,00 say linha80
    @ prow()+1,00 say X_TITULO 
    @ prow()+1,00 say X_CEP+space(21)+X_CGC
    @ prow()+1,00 say X_TEL + ' - ' + X_FAX +space(10)+X_IE
    
    
RETURN

procedure fax_det1(P)
    @ prow()+2,00      say 'ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ TRANSMISSAO DE FAX ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ'+X_CODIGO+'ÄÄ¿'
    @ prow()+1,00      say '³                                                                              ³'
    @ prow()+1,00      say parede +' Para:'
    @ prow(),pcol()+01 say X_DESTINO
    @ prow(),pcol()+04 say parede
    @ prow(),pcol()+03 say 'N. do Fax:'
    @ prow(),pcol()+01 say X_N_FAX
    @ prow(),79        say parede
    @ prow()+1,00      say 'ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´'
    @ prow()+1,00      say parede
    @ prow(),pcol()+01 say 'At.:'
    @ prow(),pcol()+01 say X_AT
    @ prow(),pcol()+01 say parede
    @ prow(),pcol()+01 say 'Depto.:'
    @ prow(),pcol()+01 say X_DEPTO
    @ prow(),79        say parede
    @ prow()+1,00      say 'ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´'
    @ prow()+1,00      say parede
    @ prow(),pcol()+01 say 'Mensagem n.:'
    @ prow(),pcol()+01 say if(X_N_MENS=0,'      ',str(X_N_MENS,6))
    @ prow(),pcol()+05 say parede
    @ prow(),pcol()+01 say 'Data:'
    @ prow(),pcol()+01 say X_DATA
    @ prow(),pcol()+01 say parede
    @ prow(),pcol()+01 say 'Paginas:'
    @ prow(),pcol()+07 say STR(P,2)+'/'+str(X_N_PAG,4)
    @ prow(),pcol()+12 say parede
    @ prow()+1,00      say 'ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´'
    @ prow()+1,00      say parede
    @ prow(),pcol()+01 say 'Solicitante:'
    @ prow(),pcol()+01 say X_SOLICI
    @ prow(),pcol()+01 say parede
    @ prow(),pcol()+01 say 'Assunto:'
    @ prow(),pcol()+01 say X_ASSUNTO
    @ prow(),pcol()+07 say parede
    @ prow()+1,00      say 'ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´'
    @ prow()+1,00      say '³ TEXTO:                                                                       ³'
    for i=linhas to linhas+38
       X_TEXTO := memoline(X_MEMO,78,i) 
       @ prow()+1,00   say parede +if(empty(X_TEXTO),SPACE(78),X_TEXTO) + parede
    next
    linhas := linhas + 39
    @ prow()+1,00      say 'ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´'
    @ prow()+1,00      say '³ CASO  ESTA MENSAGEM  NAO SEJA BEM  RECEBIDA,  FAVOR  COMUNICAR-NOS   PELO    ³'
    @ prow()+1,00      say '³ TELEFONE : (021) 560-0675                                                    ³'
    @ prow()+1,00      say 'ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ'
    @ prow()+1,00      say n_f

return


function p372_busca()
local X_Busca := space(06)
@ 14,24 say "ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿"
@ 15,24 say '³ Fax.....:              ³'
@ 16,24 say "ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ"

sombra(14,24,16,49)

while .t.
   
   

   @ 15,36 get X_Busca     picture "@!" 
   read
   SELECT VEN372
   if lastkey()=K_ESC .or. empty(X_Busca) ; exit; end
   if VEN372->( dbseek((zerofill( X_Busca ) ) ))
     exit
   else
     message('Fax nao existe.')
     inkey(.5)
     loop
   end

   setcursor(0)
end
return
