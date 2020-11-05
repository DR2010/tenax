# include "inkey.ch"

/*
  VEN373.PRG - 
*/

abrir("ESTREPO")

telanum('VEN373','VEN373')
// declaracao de variaveis

PRIVATE X_CAB1    := 'TENAX'
PRIVATE X_CAB2    := 'ACO E FERRO LTDA'
PRIVATE X_TITULO  := 'TRAV. LEONOR MASCARENHAS,101 - RAMOS'
PRIVATE X_CEP     := 'CEP 21040-130 - RIO DE JANEIRO - RJ'
PRIVATE X_TEL     := 'TEL: (021) 260-0675'
PRIVATE X_FAX     := 'FAX: (021) 564-3195'
PRIVATE X_CGC     := 'CGC 33.097.536/0001-26'
PRIVATE X_IE      := 'INSC.EST. 81.801.215'
PRIVATE X_TITU1   := 'Chapas de Aco SAE 1045 a SAE 1080'
PRIVATE X_TITU2   := 'Acos para ferramentas'
PRIVATE X_TITU3   := 'Acos cromo-niquel beneficiados'
PRIVATE X_TITU4   := 'Acos para moldes P-20'
PRIVATE X_TITU5   := 'Acos para cementacao' 
PRIVATE X_TITU6   := 'Secao de corte, a frio e a fogo'
PRIVATE X_TITU7   := 'Barras laminadas'
PRIVATE X_TITU8   := 'Trefiladas'
PRIVATE X_TITU9   := 'Decapadas'
PRIVATE X_TITU10  := 'Forjadas'
PRIVATE X_TITU11  := 'Redondas - Quadradas'
PRIVATE X_TITU12  := 'Retangulares - Sextavada'         

PRIVATE X_TEXTO, X_PAGINA := 1   ,linhas := 1
PRIVATE X_MEMO                   
PRIVATE X_TELANT  := SAVESCREEN(,,,,)

PRIVATE WRESP_IMP := 'I'
PRIVATE W_IMPARQ  := space(12)
        
PRIVATE n_i   := chr(27)+chr(71)
PRIVATE n_f   := chr(27)+chr(72)
PRIVATE c_i   := chr(27)+chr(15)
PRIVATE c_f   := chr(18)
PRIVATE e_i   := CHR(27)+chr(14)
PRIVATE e_f   := chr(20)
PRIVATE roman := chr(27)+'x'+CHR(49)
*PRIVATE normal:= chr(27)+'x'+CHR(48)
PRIVATE linha80 := repl(chr(240),80)
    
telae373()
mensagem('<F10> imprime     <ESC> Retorna')
while .T. 
  if memo2(.t.)
    if CONF('Confirma Impressao')
      if VEN373_IMPRE(); exit; end
    end
  end
  if lastkey()=27
    if CONF('Abandona'); exit ;end
  end

end

restscreen(,,,,,X_TELANT)
RETURN

procedure telae373()

   setcolor( W_CORGET )
   @ 02,00 say 'ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ Texto ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿'
   @ 03,00 say '³                                                                    Pag.:     ³'
   @ 04,00 say 'ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´'                                                                    
   @ 05,00 say '³                                                                              ³'
   @ 06,00 say '³                                                                              ³'
   @ 07,00 say '³                                                                              ³'
   @ 08,00 say '³                                                                              ³'
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

procedure memo2(modo)
 PRIVATE XRET :=.T.
 x_memo := memoedit(x_memo,05,02,21,78,modo,"memofunc2")

return XRET

procedure memofunc2( modo, linha, coluna )
  local X_KEY := LASTKEY(),PAG := INT((linha/53)), WRET := X_KEY
  SETCURSOR(1)
  @ 03,75 say strzero( PAG+1,3)
  @ 03,03 say 'linha: '+strzero(linha,3)
  @ 03,col()+8 say 'coluna: '+strzero(coluna,3)
  do case
    case X_KEY = K_F10
        WRET := 23
        XRET := .T.
    case X_KEY = K_ESC
        XRET := .F.
        WRET := 27
    end

RETURN (WRET)

procedure ven373_impre()

    X_N_PAG   := INT(MLCOUNT( X_MEMO,78 )/53 ) + 1
    W_TITULO  := 'Emissao de carta'
    if DH_IMPRIME()
     if WRESP_IMP = 'A'
       ESTREPO->( grava( WIMP_ARQ, date(), time(), W_TITULO, 80) )
     end
     for a = 1 to X_N_PAG
       @ 00,00 say ''
       ven373_CAB1()
       ven373_det1()
    NEXT
  end
  DH_IMPOFF()
  @ 00,00 say ''
RETURN (if(WRESP_IMP='R',.F.,.T.))


procedure ven373_cab1()
    @ prow(),00   say  roman  
    @ prow(),00   say  c_i + n_i  
    @ prow()+1,00 say X_TITU1 + SPACE(15)+X_TITU7
    @ prow()+1,00 say X_TITU2 + SPACE(15)+X_TITU8
    @ prow()+1,00 say X_TITU3 + SPACE(15)+X_TITU9
    @ prow()+1,00 say X_TITU4 + SPACE(15)+X_TITU10
    @ prow()+1,00 say X_TITU5 + SPACE(25)+e_i+X_CAB1+e_f+SPACE(10)+X_TITU11
    @ prow()+1,00 say X_TITU6 + SPACE(10)+e_i+X_CAB2+e_f+SPACE(10)+X_TITU12
    @ prow(),00   say c_f
    @ prow()+1,00 say linha80
RETURN

procedure ven373_det1()

    for i=linhas to linhas+52
       X_TEXTO := memoline(X_MEMO,78,i) 
       @ prow()+1,00   say X_TEXTO
    next
    linhas := linhas +53
    @ prow()+1,30 say 'Fornecendo Acos de Qualidade Desde 1963'
    @ prow()+1,00 say repl(CHR(196),80)
    @ prow(),00   say c_i
    @ prow()+1,00 say X_TITULO+SPACE(30)+X_IE
    @ prow()+1,00 say X_TEL+'   '+X_CEP+SPACE(20)+X_CGC
    @ prow()+1,00 say X_FAX
    @ prow(),00   say c_f

return
