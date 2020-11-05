/*
  FAX000.PRG - PROGRAMA DE EMISSAO DE FAX
*/

// declaracao de variaveis

PRIVATE X_TITULO  := 'TENAX ACO E FERRO LTDA. - TRAV. LEONOR MASCARENHAS,101 - RAMOS'
PRIVATE X_TITULO2 := 'TRANSMISAO DE FAX'
PRIVATE X_CEP     := 'CEP 21040-130 - RIO DE JANEIRO'
PRIVATE X_TEL     := 'TELEFONE: (021) 260-0675'
PRIVATE X_FAX     := 'FAX: (021) 230-3195'
PRIVATE X_CGC     := 'CGC 33.097.536/0001-26'
PRIVATE X_IE      := 'INSC.EST. 81.801.215'

PRIVATE X_DESTINO := SPACE(40) 
PRIVATE X_N_FAX   := 0
PRIVATE X_AT      := SPACE(25)
PRIVATE X_DEPTO   := SPACE(25)
PRIVATE X_N_MENS  := 0
PRIVATE X_DATA    := '  /  /  '
PRIVATE X_N_PAG   := 0
PRIVATE X_SOLICI  := SPACE(15)
PRIVATE X_ASSUNTO := SPACE(25)
PRIVATE X_MEMO                   
PRIVATE X_TELANT  := SAVESCREEN(,,,,)

Faxtel0()
Faxget0()

RESTSCREEN(,,,,X_TELANT)
procedure Faxtel0()

   setcolor( W_COREDIT )
   @ 05,02 say '�'
   @ 05,77 say '�'
   setcolor( W_CORGET )
   @ 02,02 say '���������������������������� ' + X_TITULO2 + ' ��������������������������Ŀ'
   @ 03,02 say '�                                                                 Pag.:   �'
   @ 04,02 say '� Para..:                                           N. Fax..:             �'
   @ 05,02 say '� At....:                             Depto...:                           �'
   @ 06,02 say '� Mensagem N..:                 Data....:    /  /       N. Pag..:         �'
   @ 07,02 say '� Solicitante.:                 Assunto.:                                 �'
   @ 08,02 say '�                                                                         �'
   @ 09,02 say '�                                                                         �'
   @ 10,02 say '�                                                                         �'
   @ 11,02 say '�                                                                         �'
   @ 12,02 say '�                                                                         �'
   @ 13,02 say '�                                                                         �'
   @ 14,02 say '�                                                                         �'
   @ 15,02 say '�                                                                         �'
   @ 16,02 say '�                                                                         �'
   @ 17,02 say '�                                                                         �'
   @ 18,02 say '�                                                                         �'
   @ 19,02 say '�                                                                         �'
   @ 20,02 say '�                                                                         �'
   @ 21,02 say '�                                                                         �'
   @ 22,02 say '�                                                                         �'
   return

procedure Faxget0()

   @ 04,12 get X_DESTINO PICT '@!'
   @ 04,64 get X_N_FAX   PICT '99'
   @ 05,12 get X_AT
   @ 05,50 get X_DEPTO   PICT '@!'
   @ 06,18 get X_N_MENS  PICT '99'
   @ 06,44 get X_DATA    PICT '99/99/99'
   @ 06,69 get X_N_PAG   PICT '99'
   @ 07,18 get X_SOLICI  PICT '@!'
   @ 07,44 get X_ASSUNTO PICT '@!'
   READ   
return
