
CREATE TABLE AGE001 (
       NOME                 Character(40) NULL,
       TEL1                 Character(10) NULL,
       TEL2                 Character(10) NULL,
       DDD                  Character(4) NULL,
       FAX                  Character(10) NULL,
       CONTATO              Character(40) NULL,
       CODCLI               Character(6) NULL,
       END01                Character(55) NULL,
       END02                Character(55) NULL,
       OBS                  Character(55) NULL,
       OBS1                 Character(55) NULL,
       OBS2                 Character(55) NULL
);


CREATE TABLE ALB (
       PEDVEN               Character(5) NULL,
       DT_PEDIDO            Date NULL,
       CODCLI               Character(5) NULL,
       COMPRADOR            Character(20) NULL,
       CODVEN               Character(2) NULL,
       VALOR                Numeric(12,2) NULL,
       DT_PEDVEN            Date NULL,
       QTD_ITENS            Numeric(2) NULL
);


CREATE TABLE BAC999 (
       CODCLI               Character(5) NULL,
       CODNOVO              Character(5) NULL,
       DESCRICAO            Character(40) NULL
);


CREATE TABLE CADCLI (
       CODIGO               Character(7) NULL,
       FIRMA                Character(40) NULL,
       ENDERECO             Character(35) NULL,
       MUNICIPIO            Character(20) NULL,
       ESTADO               Character(3) NULL,
       CEP                  Character(6) NULL,
       CGC                  Character(19) NULL,
       INSCRICAO            Character(13) NULL
);


CREATE TABLE CN0100 (
       CODBANCO             Character(3) NULL,
       DESCRICAO            Character(30) NULL
);


CREATE TABLE CN0200 (
       CODBANCO             Character(3) NULL,
       CODAGENCIA           Character(6) NULL,
       DESCRICAO            Character(30) NULL
);


CREATE TABLE CN0300 (
       TIPOVENDA            Character(2) NULL,
       DESCRICAO            Character(30) NULL,
       PARCELA              Character(1) NULL
);


CREATE TABLE CN0400 (
       TIPOVENDA            Character(2) NULL,
       FORMAPAG             Character(2) NULL,
       DESCRICAO            Character(30) NULL,
       CHEQUE               Character(1) NULL,
       BOLETA               Character(1) NULL,
       DUPLIC               Character(1) NULL
);


CREATE TABLE CN0500 (
       CODVENC              Character(2) NULL,
       DESCRICAO            Character(30) NULL,
       DIAS_1               Numeric(2) NULL,
       DIAS_2               Numeric(2) NULL,
       DIAS_3               Numeric(2) NULL,
       DIAS_4               Numeric(2) NULL,
       DIAS_5               Numeric(2) NULL,
       QTDVENC              Numeric(1) NULL
);


CREATE TABLE CN0600 (
       CODBANCO             Character(3) NULL,
       CODAGENCIA           Character(6) NULL,
       NR_CHEQUE            Character(11) NULL,
       NR_CONTA             Character(11) NULL,
       DUPLICATA            Character(8) NULL,
       SEQUENCIA            Character(1) NULL,
       CGC                  Character(14) NULL,
       CPF                  Character(11) NULL,
       FLAG_CGC             Character(1) NULL,
       FLAG_CPF             Character(1) NULL,
       NOME                 Character(30) NULL,
       VALOR                Numeric(14,2) NULL,
       DT_PREDATA           Date NULL,
       EMISSAO              Date NULL,
       DT_PAG               Date NULL,
       CODCLI               Character(5) NULL,
       DESTINO              Character(60) NULL,
       USUARIO              Character(10) NULL,
       STATUS               Character(1) NULL,
       RAZAO                Character(30) NULL,
       DDD01                Character(4) NULL,
       TEL01                Character(11) NULL
);


CREATE TABLE CN1000 (
       DUPLICATA            Character(8) NULL,
       SEQUENCIA            Character(1) NULL,
       DT_VENC              Date NULL,
       DT_PAG               Date NULL,
       VALOR                Numeric(14,2) NULL,
       JUROS                Numeric(10,2) NULL,
       CODCLI               Character(5) NULL,
       USUARIO              Character(10) NULL,
       STATUS               Character(1) NULL,
       FORMAPAG             Character(2) NULL,
       QTD_CH               Numeric(1) NULL,
       BOLETA               Character(8) NULL,
       TIPO_DOC             Character(1) NULL,
       ACORDO               Character(1) NULL,
       VLPAGO               Numeric(15,2) NULL,
       VLSALDO              Numeric(15,2) NULL
);


CREATE TABLE CN1100 (
       DUPLICATA            Character(8) NULL,
       SEQUENCIA            Character(1) NULL,
       DTACORDO             Date NULL,
       VLACORDO             Numeric(14,2) NULL,
       SDACORDO             Numeric(14,2) NULL
);


CREATE TABLE CN1300 (
       CODIGO               Character(5) NULL,
       DESCRICAO            Character(30) NULL
);


CREATE TABLE CN9991 (
       JUROS                Numeric(6,2) NULL,
       VALOR                Numeric(5,2) NULL,
       DTJUROS              Date NULL
);


CREATE TABLE CNM1000 (
       DUPLICATA            Character(8) NULL,
       SEQUENCIA            Character(1) NULL,
       DT_VENC              Date NULL,
       DT_PAG               Date NULL,
       VALOR                Numeric(14,2) NULL,
       JUROS                Numeric(10,2) NULL,
       CODCLI               Character(5) NULL,
       USUARIO              Character(10) NULL,
       STATUS               Character(1) NULL,
       FORMAPAG             Character(2) NULL,
       QTD_CH               Numeric(1) NULL,
       BOLETA               Character(8) NULL,
       TIPO_DOC             Character(1) NULL,
       ICMS                 Numeric(14,2) NULL
);


CREATE TABLE COLOR (
       COLOR_ID             Numeric(12) NULL,
       COLOR_TYPE           Character(6) NULL,
       DIAG_ID              Numeric(12) NULL,
       COLOR_VAL            Numeric(12) NULL
);


CREATE TABLE CR0100 (
       CODBANCO             Character(3) NULL,
       DESCRICAO            Character(30) NULL
);


CREATE TABLE CR0200 (
       CODBANCO             Character(3) NULL,
       CODAGENCIA           Character(6) NULL,
       DESCRICAO            Character(30) NULL
);


CREATE TABLE CR0300 (
       TIPOVENDA            Character(2) NULL,
       DESCRICAO            Character(50) NULL,
       PARCELA              Character(1) NULL
);


CREATE TABLE CR0400 (
       TIPOVENDA            Character(2) NULL,
       FORMAPAG             Character(2) NULL,
       DESCRICAO            Character(30) NULL,
       CHEQUE               Character(1) NULL,
       BOLETA               Character(1) NULL,
       DUPLIC               Character(1) NULL,
       DEVOLUC              Character(2) NULL
);


CREATE TABLE CR0500 (
       CODVENC              Character(2) NULL,
       DESCRICAO            Character(30) NULL,
       DIAS_1               Numeric(2) NULL,
       DIAS_2               Numeric(2) NULL,
       DIAS_3               Numeric(2) NULL,
       DIAS_4               Numeric(2) NULL,
       DIAS_5               Numeric(2) NULL,
       QTDVENC              Numeric(1) NULL
);


CREATE TABLE CR0600 (
       CODBANCO             Character(3) NULL,
       CODAGENCIA           Character(6) NULL,
       NR_CHEQUE            Character(11) NULL,
       NR_CONTA             Character(11) NULL,
       DUPLICATA            Character(8) NULL,
       SEQUENCIA            Character(1) NULL,
       CGC                  Character(14) NULL,
       CPF                  Character(11) NULL,
       FLAG_CGC             Character(1) NULL,
       FLAG_CPF             Character(1) NULL,
       NOME                 Character(30) NULL,
       VALOR                Numeric(14,2) NULL,
       DT_PREDATA           Date NULL,
       EMISSAO              Date NULL,
       DT_PAG               Date NULL,
       CODCLI               Character(5) NULL,
       DESTINO              Character(60) NULL,
       USUARIO              Character(10) NULL,
       STATUS               Character(1) NULL,
       RAZAO                Character(30) NULL,
       DDD01                Character(4) NULL,
       TEL01                Character(11) NULL
);


CREATE TABLE CR1000 (
       DUPLICATA            Character(8) NULL,
       SEQUENCIA            Character(1) NULL,
       DT_VENC              Date NULL,
       DT_PAG               Date NULL,
       VALOR                Numeric(14,2) NULL,
       JUROS                Numeric(10,2) NULL,
       CODCLI               Character(5) NULL,
       USUARIO              Character(10) NULL,
       STATUS               Character(1) NULL,
       FORMAPAG             Character(2) NULL,
       QTD_CH               Numeric(1) NULL,
       BOLETA               Character(10) NULL,
       TIPO_DOC             Character(1) NULL,
       ACORDO               Character(1) NULL,
       VLPAGO               Numeric(15,2) NULL,
       VLSALDO              Numeric(15,2) NULL,
       TIPOVENDA            Character(2) NULL,
       TXADM                Numeric(12,2) NULL,
       ABATIMENTO           Numeric(12,2) NULL,
       FLG_ABATI            Character(1) NULL,
       FLG_TXADM            Character(1) NULL,
       DT_CREDITO           Date NULL,
       JRACORDO             Numeric(6,2) NULL,
       VLACPAGAR            Numeric(14,2) NULL,
       JRACPAGAR            Numeric(10,2) NULL,
       VLACPAGO             Numeric(14,2) NULL,
       JRACPAGO             Numeric(10,2) NULL,
       DTACORDO             Date NULL
);


CREATE TABLE CR1100 (
       DUPLICATA            Character(8) NULL,
       SEQUENCIA            Character(1) NULL,
       DTACORDO             Date NULL,
       VLACORDO             Numeric(14,2) NULL,
       SDACORDO             Numeric(14,2) NULL,
       JRACORDO             Numeric(6,2) NULL,
       JRACPAGO             Numeric(10,2) NULL,
       VLACPAGO             Numeric(15,2) NULL,
       JRACPAGAR            Numeric(10,2) NULL,
       VLACPAGAR            Numeric(15,2) NULL
);


CREATE TABLE CR1300 (
       CODIGO               Character(5) NULL,
       DESCRICAO            Character(30) NULL
);


CREATE TABLE CR9991 (
       JUROS                Numeric(6,2) NULL,
       VALOR                Numeric(5,2) NULL,
       DTJUROS              Date NULL
);


CREATE TABLE CRM1000 (
       DUPLICATA            Character(8) NULL,
       SEQUENCIA            Character(1) NULL,
       DT_VENC              Date NULL,
       DT_PAG               Date NULL,
       VALOR                Numeric(14,2) NULL,
       JUROS                Numeric(10,2) NULL,
       CODCLI               Character(5) NULL,
       USUARIO              Character(10) NULL,
       STATUS               Character(1) NULL,
       FORMAPAG             Character(2) NULL,
       QTD_CH               Numeric(1) NULL,
       BOLETA               Character(8) NULL,
       TIPO_DOC             Character(1) NULL,
       ICMS                 Numeric(14,2) NULL
);


CREATE TABLE DBU (
       FORMA                Character(3) NULL,
       TIPO                 Character(5) NULL,
       ESTADO               Character(1) NULL,
       DESCRICAO            Character(25) NULL,
       COR                  Character(12) NULL
);


CREATE TABLE DEF_VAL (
       DFLT_ID              Numeric(12) NULL,
       DFLT_TYPE            Character(6) NULL,
       DIAG_ID              Numeric(12) NULL,
       DFLT_NAME            Character(254) NULL,
       CLI_VAL              Numeric(12) NULL,
       SVR_VAL              Numeric(12) NULL,
       DFLT_FLAG            Numeric(12) NULL
);


CREATE TABLE DIAG_OPT (
       OPT_NAME             Character(6) NULL,
       DIAG_ID              Numeric(12) NULL,
       SUBJ_ID              Numeric(12) NULL,
       DISPLAY_ID           Numeric(12) NULL,
       OPT_VAL              Character(254) NULL
);


CREATE TABLE DICT_VER (
       VERSION              Character(18) NULL
);


CREATE TABLE DISPLAY (
       DIAG_ID              Numeric(12) NULL,
       SUBJ_ID              Numeric(12) NULL,
       DISPLAY_ID           Numeric(12) NULL,
       DISP_NAME            Character(254) NULL,
       DISP_DESC            Numeric(12) NULL,
       DISP_AUTH            Character(254) NULL,
       DISP_CRDT            Numeric(12) NULL,
       DISP_MDDT            Numeric(12) NULL,
       EFIL_CLR             Numeric(12) NULL,
       BKCLR                Numeric(12) NULL,
       RELFNT               Numeric(12) NULL,
       ENAMEFNT             Numeric(12) NULL,
       EDEFFNT              Numeric(12) NULL,
       ELINECLR             Numeric(12) NULL,
       EDEFCLR              Numeric(12) NULL,
       RNAMECLR             Numeric(12) NULL,
       ENAMECLR             Numeric(12) NULL,
       FONT_TYPE            Character(6) NULL,
       COLOR_TYPE           Character(6) NULL
);


CREATE TABLE DOMAINPV (
       DMN_ID               Numeric(12) NULL,
       DMN_TYPE             Character(6) NULL,
       DIAG_ID              Numeric(12) NULL,
       TARG_SYS             Character(6) NULL,
       DMNP_SEQ             Numeric(12) NULL,
       DMNP_TYPE            Character(6) NULL,
       DMNP_TVAL            Numeric(12) NULL,
       DMNP_IVAL            Numeric(12) NULL,
       DMNP_IDVL            Numeric(12) NULL,
       DMNP_SVAL            Character(254) NULL,
       DMNP_INH             Numeric(12) NULL
);


CREATE TABLE ENT_INDX (
       INDEX_ID             Numeric(12) NULL,
       INDEX_TYPE           Character(6) NULL,
       ENT_ID               Numeric(12) NULL,
       ENT_TYPE             Character(6) NULL,
       DIAG_ID              Numeric(12) NULL,
       GENERATE             Numeric(12) NULL,
       IDX_LNAME            Character(254) NULL,
       IDX_PNAME            Character(254) NULL,
       IDX_FLAGS            Numeric(12) NULL
);


CREATE TABLE ENT_PROP (
       ENT_ID               Numeric(12) NULL,
       ENT_TYPE             Character(6) NULL,
       DIAG_ID              Numeric(12) NULL,
       TARG_SYS             Character(6) NULL,
       PROP_TYPE            Character(6) NULL,
       PROP_VAL             Numeric(12) NULL,
       PROP_IVAL            Numeric(12) NULL,
       PROP_IDVAL           Numeric(12) NULL
);


CREATE TABLE ENT_SYN (
       SYN_NAME             Character(128) NULL,
       ENT_ID               Numeric(12) NULL,
       ENT_TYPE             Character(6) NULL,
       DIAG_ID              Numeric(12) NULL
);


CREATE TABLE ENT_TRIG (
       ENT_ID               Numeric(12) NULL,
       ENT_TYPE             Character(6) NULL,
       DIAG_ID              Numeric(12) NULL,
       TARG_SYS             Character(6) NULL,
       TRIG_NAME            Character(254) NULL,
       TRIG_TYPE            Character(6) NULL,
       TRIG_DSBL            Numeric(12) NULL,
       TRIG_FIRE            Character(6) NULL,
       TRIG_SCOPE           Character(6) NULL,
       TRIG_OLD             Character(254) NULL,
       TRIG_NEW             Character(254) NULL,
       TRIG_BODY            Numeric(12) NULL
);


CREATE TABLE ER0600 (
       CODBANCO             Character(3) NULL,
       CODAGENCIA           Character(6) NULL,
       NR_CHEQUE            Character(11) NULL,
       NR_CONTA             Character(11) NULL,
       DUPLICATA            Character(8) NULL,
       SEQUENCIA            Character(1) NULL,
       CGC                  Character(14) NULL,
       CPF                  Character(11) NULL,
       FLAG_CGC             Character(1) NULL,
       FLAG_CPF             Character(1) NULL,
       NOME                 Character(30) NULL,
       VALOR                Numeric(14,2) NULL,
       DT_PREDATA           Date NULL,
       EMISSAO              Date NULL,
       DT_PAG               Date NULL,
       CODCLI               Character(5) NULL,
       DESTINO              Character(60) NULL,
       USUARIO              Character(10) NULL,
       STATUS               Character(1) NULL,
       RAZAO                Character(30) NULL,
       DDD01                Character(4) NULL,
       TEL01                Character(11) NULL
);


CREATE TABLE ER1000 (
       DUPLICATA            Character(8) NULL,
       SEQUENCIA            Character(1) NULL,
       DT_VENC              Date NULL,
       DT_PAG               Date NULL,
       VALOR                Numeric(14,2) NULL,
       JUROS                Numeric(10,2) NULL,
       CODCLI               Character(5) NULL,
       USUARIO              Character(10) NULL,
       STATUS               Character(1) NULL,
       FORMAPAG             Character(2) NULL,
       QTD_CH               Numeric(1) NULL,
       BOLETA               Character(8) NULL,
       TIPO_DOC             Character(1) NULL,
       ACORDO               Character(1) NULL,
       DTACORDO             Date NULL,
       TIPOVENDA            Character(2) NULL,
       FLG_ABATI            Character(1) NULL,
       ABATIMENTO           Numeric(10,2) NULL,
       TXADM                Numeric(10,2) NULL,
       FLG_TXADM            Character(1) NULL,
       DT_CREDITO           Date NULL,
       JRACORDO             Numeric(6) NULL,
       VLACPAGAR            Numeric(14,2) NULL,
       JRACPAGAR            Numeric(10,2) NULL,
       VLACPAGO             Numeric(14,2) NULL,
       JRACPAGO             Numeric(10,2) NULL
);


CREATE TABLE ER1100 (
       DUPLICATA            Character(8) NULL,
       SEQUENCIA            Character(1) NULL,
       DTACORDO             Date NULL,
       VLACORDO             Numeric(14,2) NULL,
       JRACORDO             Numeric(6,2) NULL,
       JRACPAGO             Numeric(10,2) NULL,
       VLACPAGO             Numeric(15,2) NULL,
       JRACPAGAR            Numeric(10,2) NULL,
       VLACPAGAR            Numeric(15,2) NULL
);


CREATE TABLE ERW_ATT (
       ATT_ID               Numeric(12) NULL,
       ATT_TYPE             Character(6) NULL,
       DIAG_ID              Numeric(12) NULL,
       EA_TYPE              Character(6) NULL,
       ENT_ID               Numeric(12) NULL,
       ENT_TYPE             Character(6) NULL,
       REL_ID               Numeric(12) NULL,
       REL_TYPE             Character(6) NULL,
       ATT_PARENT           Numeric(12) NULL,
       ATT_ORDER            Numeric(12) NULL,
       COL_POS              Numeric(12) NULL,
       ATT_FONT             Numeric(12) NULL,
       ATT_COLOR            Numeric(12) NULL,
       ATT_FLAGS            Numeric(12) NULL
);


CREATE TABLE ERW_BMP (
       BMP_ID               Numeric(12) NULL,
       BMP_TYPE             Character(6) NULL,
       DIAG_ID              Numeric(12) NULL,
       BMP_NAME             Character(256) NULL,
       BMP_SIZE             Numeric(12) NULL,
       BMP_BITS             Numeric(12) NULL,
       BMP_FLAGS            Numeric(12) NULL,
       BMP_MMID             Numeric(12) NULL
);


CREATE TABLE ERW_DMN (
       DMN_ID               Numeric(12) NULL,
       DMN_TYPE             Character(6) NULL,
       DIAG_ID              Numeric(12) NULL,
       PDMN_ID              Numeric(12) NULL,
       DMN_INT              Numeric(12) NULL
);


CREATE TABLE ERW_DR (
       DR_ID                Numeric(12) NULL,
       DR_TYPE              Character(6) NULL,
       DIAG_ID              Numeric(12) NULL,
       DR_NAME              Character(254) NULL,
       DR_COMMENT           Numeric(12) NULL
);


CREATE TABLE ERW_DVO (
       SUBJ_ID              Numeric(12) NULL,
       DISPLAY_ID           Numeric(12) NULL,
       OBJECT_ID            Numeric(12) NULL,
       OBJECT_TYP           Character(6) NULL,
       DIAG_ID              Numeric(12) NULL,
       XCOORD1              Numeric(12) NULL,
       YCOORD1              Numeric(12) NULL,
       XCOORD2              Numeric(12) NULL,
       YCOORD2              Numeric(12) NULL,
       ENRN_FNT             Numeric(12) NULL,
       ENR_CLR              Numeric(12) NULL,
       ELINE_CLR            Numeric(12) NULL,
       EFILL_CLR            Numeric(12) NULL,
       EDEF_FNT             Numeric(12) NULL,
       EDEF_CLR             Numeric(12) NULL,
       COLOR_TYPE           Character(6) NULL,
       FONT_TYPE            Character(6) NULL,
       USER_TOUCH           Numeric(12) NULL,
       PATH0_X              Numeric(12) NULL,
       PATH0_Y              Numeric(12) NULL,
       PATH1_X              Numeric(12) NULL,
       PATH1_Y              Numeric(12) NULL,
       PATH2_X              Numeric(12) NULL,
       PATH2_Y              Numeric(12) NULL,
       PATH3_X              Numeric(12) NULL,
       PATH3_Y              Numeric(12) NULL,
       PATH4_X              Numeric(12) NULL,
       PATH4_Y              Numeric(12) NULL,
       VERB1_X              Numeric(12) NULL,
       VERB1_Y              Numeric(12) NULL,
       VERB2_X              Numeric(12) NULL,
       VERB2_Y              Numeric(12) NULL,
       MID_X                Numeric(12) NULL,
       MID_Y                Numeric(12) NULL
);


CREATE TABLE ERW_DWXC (
       DSC_ID               Numeric(12) NULL,
       DSC_TYPE             Character(6) NULL,
       DIAG_ID              Numeric(12) NULL,
       DST_ID               Numeric(12) NULL,
       DST_TYPE             Character(6) NULL,
       DSC_SEQ              Numeric(12) NULL,
       DSC_NAME             Character(256) NULL,
       DSC_DTYPE            Character(256) NULL,
       DSC_CMNT             Numeric(12) NULL
);


CREATE TABLE ERW_DWXS (
       DWXSRC_ID            Numeric(12) NULL,
       DWXSRC_TYP           Character(6) NULL,
       DIAG_ID              Numeric(12) NULL,
       DWXSRC_NAM           Character(256) NULL,
       DWXSRC_SYS           Character(256) NULL,
       DWXSRC_HOS           Character(256) NULL,
       DWXSRC_DBM           Character(256) NULL,
       DWXSRC_SOU           Character(256) NULL,
       DWXSRC_MMI           Numeric(12) NULL,
       DWXSRC_DB            Character(256) NULL,
       DWXSRC_SER           Character(256) NULL,
       DWXSRC_VER           Character(256) NULL,
       DWXSRC_LOG           Character(256) NULL,
       DWXSRC_STY           Numeric(12) NULL,
       DWXSRC_ITY           Numeric(12) NULL,
       DWXSRC_DEF           Numeric(12) NULL
);


CREATE TABLE ERW_DWXT (
       DST_ID               Numeric(12) NULL,
       DST_TYPE             Character(6) NULL,
       DIAG_ID              Numeric(12) NULL,
       DS_ID                Numeric(12) NULL,
       DS_TYPE              Character(6) NULL,
       DST_SEQ              Numeric(12) NULL,
       DST_NAME             Character(256) NULL,
       DST_OWNER            Character(256) NULL
);


CREATE TABLE ERW_ENT (
       ENT_ID               Numeric(12) NULL,
       ENT_TYPE             Character(6) NULL,
       DIAG_ID              Numeric(12) NULL,
       ENT_NAME             Character(254) NULL,
       TABLE_NAME           Character(254) NULL,
       ENT_NOTE             Numeric(12) NULL,
       ENT_DEF              Numeric(12) NULL,
       WITH_CHK             Numeric(12) NULL,
       ENT_FLAGS            Numeric(12) NULL
);


CREATE TABLE ERW_REL (
       REL_ID               Numeric(12) NULL,
       REL_TYPE             Character(6) NULL,
       DIAG_ID              Numeric(12) NULL,
       PENT_ID              Numeric(12) NULL,
       PENT_TYPE            Character(6) NULL,
       CENT_ID              Numeric(12) NULL,
       CENT_TYPE            Character(6) NULL,
       CARDINAL             Character(6) NULL,
       PAR_DEL              Character(6) NULL,
       PAR_UPD              Character(6) NULL,
       CHILD_INS            Character(6) NULL,
       CHILD_DEL            Character(6) NULL,
       CHILD_UPD            Character(6) NULL,
       PAR_INS              Character(6) NULL,
       NULL_RULE            Character(6) NULL,
       REL_DEF              Numeric(12) NULL,
       VERBPHRASE           Character(254) NULL,
       SYN_NAME             Character(128) NULL,
       VIEWSEQ              Numeric(12) NULL,
       ISOUTER              Numeric(12) NULL,
       MMASSOC              Numeric(12) NULL,
       REL_FLAGS            Numeric(12) NULL
);


CREATE TABLE ERW_RPT (
       DIAG_ID              Numeric(12) NULL,
       RPT_ID               Numeric(12) NULL,
       RPT_TYPE             Character(6) NULL,
       RPT_NAME             Character(254) NULL,
       RPT_COMENT           Numeric(12) NULL
);


CREATE TABLE ERW_SUBT (
       SUBT_ID              Numeric(12) NULL,
       SUBT_TYPE            Character(6) NULL,
       DIAG_ID              Numeric(12) NULL,
       DISCRIM              Character(254) NULL
);


CREATE TABLE ERW_TEXT (
       ERWTXTID             Numeric(12) NULL,
       DIAG_ID              Numeric(12) NULL,
       ERWTXTVAL            Memo NULL
);


CREATE TABLE ERW_UDP (
       UDP_ID               Numeric(12) NULL,
       UDP_TYPE             Character(6) NULL,
       DIAG_ID              Numeric(12) NULL,
       UDP_NAME             Character(256) NULL,
       UDP_DEF              Numeric(12) NULL,
       UDP_DATATY           Numeric(12) NULL,
       UDP_DEFLT            Numeric(12) NULL,
       UDP_FLAGS            Numeric(12) NULL,
       UDP_SEQ              Numeric(12) NULL,
       UDP_DISP             Numeric(12) NULL,
       UDP_MM_ID            Numeric(12) NULL
);


CREATE TABLE ERW_UDPU (
       OBJECT_ID            Numeric(12) NULL,
       OBJECT_TYP           Character(6) NULL,
       UDP_ID               Numeric(12) NULL,
       UDP_TYPE             Character(6) NULL,
       DIAG_ID              Numeric(12) NULL,
       UDP_VAL              Numeric(12) NULL,
       UDP_INH              Numeric(12) NULL
);


CREATE TABLE ESPTMPLT (
       ENT_ID               Numeric(12) NULL,
       ENT_TYPE             Character(6) NULL,
       TMPLT_ID             Numeric(12) NULL,
       TMPLT_TYPE           Character(6) NULL,
       DIAG_ID              Numeric(12) NULL,
       TARG_SYS             Character(6) NULL
);


CREATE TABLE EST000 (
       ACESSO               Character(7) NULL,
       NOME                 Character(30) NULL,
       SENHA                Character(7) NULL,
       NIVEL                Character(5) NULL
);


CREATE TABLE EST001 (
       ALMOXARI             Character(3) NULL,
       DESCRICAO            Character(20) NULL
);


CREATE TABLE EST002 (
       FORNECEDOR           Character(3) NULL,
       FGUERRA              Character(12) NULL,
       DESCRICAO            Character(55) NULL,
       INSC_EST             Character(15) NULL,
       CGC                  Character(14) NULL,
       ENDERECO             Character(57) NULL,
       CEP                  Character(8) NULL,
       BAIRRO               Character(20) NULL,
       CIDADE               Character(20) NULL,
       ESTADO               Character(2) NULL,
       DDD1                 Character(4) NULL,
       DDD2                 Character(4) NULL,
       DDD3                 Character(4) NULL,
       DDD4                 Character(4) NULL,
       TEL01                Character(10) NULL,
       TEL02                Character(10) NULL,
       TEL03                Character(10) NULL,
       TEL04                Character(10) NULL,
       CONTATO              Character(21) NULL,
       OBS1                 Character(57) NULL,
       OBS2                 Character(71) NULL,
       OBS3                 Character(71) NULL
);


CREATE TABLE EST003 (
       FORMA                Character(3) NULL,
       DESCRICAO            Character(20) NULL,
       P_MATERIAL           Numeric(1) NULL,
       P_CORTE              Numeric(1) NULL
);


CREATE TABLE EST004 (
       FORMA                Character(3) NULL,
       TIPO                 Character(5) NULL,
       ESTADO               Character(1) NULL,
       DESCRICAO            Character(40) NULL,
       COR                  Character(12) NULL
);


CREATE TABLE EST005 (
       PEDIDO               Character(5) NULL,
       DTPEDIDO             Date NULL,
       STATUS               Character(1) NULL,
       FORNECEDOR           Character(3) NULL,
       QTD_ITENS            Numeric(3) NULL,
       R_DTPED              Date NULL,
       COND_PGTO            Character(20) NULL,
       CONTATO              Character(58) NULL,
       TOTAL_PEDI           Numeric(15,2) NULL,
       TOTAL_PEND           Numeric(15,2) NULL,
       QTDITPEND            Numeric(6) NULL
);


CREATE TABLE EST006 (
       PEDIDO               Character(5) NULL,
       SEQUENC              Numeric(3) NULL,
       FORMA                Character(3) NULL,
       TIPO                 Character(5) NULL,
       ESTADO               Character(1) NULL,
       BIT_INT              Character(2) NULL,
       BIT_FN               Character(2) NULL,
       BIT_FD               Character(2) NULL,
       BIT_MM               Numeric(8,3) NULL,
       ESP_INT              Character(2) NULL,
       ESP_FN               Character(2) NULL,
       ESP_FD               Character(2) NULL,
       ESP_MM               Numeric(8,3) NULL,
       DT_PREV              Date NULL,
       QTD_KG               Numeric(10,2) NULL,
       VAL_KG               Numeric(9,5) NULL,
       LOTE                 Character(5) NULL,
       IPI                  Numeric(5,2) NULL,
       ICMS                 Numeric(5,2) NULL,
       FRETE                Numeric(10,2) NULL,
       OUTRATX              Numeric(10,2) NULL,
       QTD_PEC              Numeric(5) NULL,
       R_DTPED              Date NULL,
       R_QTDPEC             Numeric(13,2) NULL,
       R_QTDKG              Numeric(10,2) NULL,
       R_VALKG              Numeric(16,5) NULL,
       CUSTO_KG             Numeric(10,2) NULL,
       CUS_ITOT             Numeric(10,2) NULL
);


CREATE TABLE EST007 (
       FORMA                Character(3) NULL,
       TIPO                 Character(5) NULL,
       ESTADO               Character(1) NULL,
       BIT_INT              Character(2) NULL,
       BIT_FN               Character(2) NULL,
       BIT_FD               Character(2) NULL,
       BIT_MM               Numeric(8,3) NULL,
       ESP_INT              Character(2) NULL,
       ESP_FN               Character(2) NULL,
       ESP_FD               Character(2) NULL,
       ESP_MM               Numeric(8,3) NULL,
       QTD_MIN              Numeric(12,2) NULL,
       QTD_KGT              Numeric(12,2) NULL,
       QTD_KGI              Numeric(12,2) NULL,
       QTD_KGC              Numeric(12,2) NULL,
       QTD_INT              Numeric(5) NULL,
       QTD_COR              Numeric(5) NULL,
       QTD_PED              Numeric(12,2) NULL,
       PES_MTR              Numeric(10,3) NULL,
       PER_COR              Numeric(6,3) NULL,
       CUS_MED              Numeric(12,2) NULL,
       DAT_ULT              Date NULL,
       OBS_MAT              Character(65) NULL,
       CUS_ULT              Numeric(12,2) NULL,
       TAM_INT              Numeric(8,2) NULL,
       PES_INT              Numeric(8,2) NULL,
       CART_LOT             Character(49) NULL,
       GRUPO                Character(2) NULL,
       SUBGRUPO             Character(2) NULL,
       COLUNA               Character(2) NULL,
       SUBFATOR             Character(2) NULL,
       RESERVADO            Numeric(10,2) NULL
);


CREATE TABLE EST008 (
       FORMA                Character(3) NULL,
       TIPO                 Character(5) NULL,
       ESTADO               Character(1) NULL,
       BIT_INT              Character(2) NULL,
       BIT_FN               Character(2) NULL,
       BIT_FD               Character(2) NULL,
       BIT_MM               Numeric(8,3) NULL,
       ESP_INT              Character(2) NULL,
       ESP_FN               Character(2) NULL,
       ESP_FD               Character(2) NULL,
       ESP_MM               Numeric(8,3) NULL,
       SEQUENC              Numeric(5) NULL,
       COMPRIM              Numeric(12,2) NULL,
       LARGURA              Numeric(12,2) NULL,
       QTD_KG               Numeric(12,2) NULL,
       TAM_INT              Numeric(10,2) NULL,
       PES_MET              Numeric(10,2) NULL,
       LOTE                 Character(5) NULL
);


CREATE TABLE EST009 (
       LOTE                 Character(5) NULL,
       NOTAFISCAL           Character(10) NULL,
       DTFISCAL             Date NULL,
       ACABAMENTO           Character(15) NULL,
       O_PRODUCAO           Character(9) NULL,
       PUNCAO               Character(9) NULL,
       CORRIDA              Character(9) NULL,
       CERTIFIC             Character(9) NULL,
       CAR_LOT              Character(30) NULL,
       OBS                  Character(60) NULL,
       OBS1                 Character(60) NULL
);


CREATE TABLE EST010 (
       OPERACAO             Character(1) NULL,
       FORMA                Character(3) NULL,
       TIPO                 Character(5) NULL,
       ESTADO               Character(1) NULL,
       BIT_INT              Character(2) NULL,
       BIT_FN               Character(2) NULL,
       BIT_FD               Character(2) NULL,
       BIT_MM               Numeric(8,3) NULL,
       ESP_INT              Character(4) NULL,
       ESP_FN               Character(2) NULL,
       ESP_FD               Character(2) NULL,
       ESP_MM               Numeric(8,3) NULL,
       TIPOMOVI             Character(3) NULL,
       DATAMOVI             Date NULL,
       QTD_KG               Numeric(12,2) NULL,
       QTD_INT              Numeric(5) NULL,
       VAL_KG               Numeric(9,5) NULL,
       ORIGEM               Character(30) NULL,
       ALMOXARI             Character(3) NULL
);


CREATE TABLE EST011 (
       TIPOMOVI             Character(3) NULL,
       DESCRICAO            Character(25) NULL,
       ES                   Character(1) NULL,
       ACERTO               Character(1) NULL
);


CREATE TABLE EST021 (
       FORNECEDOR           Character(4) NULL,
       NITEM                Character(2) NULL,
       TELEFONE             Character(7) NULL
);


CREATE TABLE EST031 (
       FORMA                Character(3) NULL,
       TIPO                 Character(5) NULL,
       ESTADO               Character(1) NULL,
       BIT_INT              Character(2) NULL,
       BIT_FN               Character(2) NULL,
       BIT_FD               Character(2) NULL,
       BIT_MM               Numeric(8,3) NULL,
       ESP_INT              Character(2) NULL,
       ESP_FN               Character(2) NULL,
       ESP_FD               Character(2) NULL,
       ESP_MM               Numeric(8,3) NULL,
       LOTE                 Character(5) NULL,
       QTD_KGT              Numeric(12,2) NULL,
       QTD_INT              Numeric(12,2) NULL,
       QTD_COR              Numeric(5) NULL,
       ORIGEM               Character(30) NULL
);


CREATE TABLE EST035 (
       CODCOMP              Character(2) NULL,
       DESCRICAO            Character(30) NULL
);


CREATE TABLE EST036 (
       TIPO                 Character(5) NULL,
       CODCOMP              Character(2) NULL,
       MINIMO               Numeric(10,3) NULL,
       MAXIMO               Numeric(10,3) NULL
);


CREATE TABLE EST037 (
       CODAREA              Character(10) NULL,
       DESCRICAO            Character(200) NULL
);


CREATE TABLE EST040 (
       FORMA                Character(3) NULL,
       TIPO                 Character(5) NULL,
       COMPRIM              Numeric(10,3) NULL,
       LARGURA              Numeric(10,3) NULL,
       ESPESSU              Numeric(10,3) NULL
);


CREATE TABLE EST666 (
       LOTE                 Character(5) NULL,
       DESCRICAO            Character(30) NULL
);


CREATE TABLE EST999 (
       ROTINA               Character(10) NULL,
       NIVEL                Numeric(5) NULL
);


CREATE TABLE ESTDAN (
       ACESSO               Character(11) NULL,
       NOME                 Character(30) NULL,
       SENHA                Character(10) NULL,
       NIVEIS               Character(15) NULL
);


CREATE TABLE ESTDIREI (
       CODUSU               Character(6) NULL,
       CODROT               Character(10) NULL,
       ACESSO               Character(1) NULL,
       DIRVER               Character(11) NULL
);


CREATE TABLE ESTERRO (
       SUBSYSTEM            Character(10) NULL,
       SUBCODE              Character(10) NULL,
       DESCRICAO            Character(40) NULL,
       DESCRESU             Character(20) NULL,
       DESCINGLES           Character(40) NULL
);


CREATE TABLE ESTM05 (
       PEDIDO               Character(5) NULL,
       DTPEDIDO             Date NULL,
       STATUS               Character(1) NULL,
       FORNECEDOR           Character(3) NULL,
       QTD_ITENS            Numeric(3) NULL,
       R_DTPED              Date NULL,
       COND_PGTO            Character(20) NULL,
       CONTATO              Character(58) NULL,
       TOTAL_PEDI           Numeric(15,2) NULL,
       TOTAL_PEND           Numeric(15,2) NULL,
       QTDITPEND            Numeric(6) NULL
);


CREATE TABLE ESTM06 (
       PEDIDO               Character(5) NULL,
       SEQUENC              Numeric(3) NULL,
       FORMA                Character(3) NULL,
       TIPO                 Character(5) NULL,
       ESTADO               Character(1) NULL,
       BIT_INT              Character(2) NULL,
       BIT_FN               Character(2) NULL,
       BIT_FD               Character(2) NULL,
       BIT_MM               Numeric(8,3) NULL,
       ESP_INT              Character(2) NULL,
       ESP_FN               Character(2) NULL,
       ESP_FD               Character(2) NULL,
       ESP_MM               Numeric(8,3) NULL,
       DT_PREV              Date NULL,
       QTD_KG               Numeric(10,2) NULL,
       VAL_KG               Numeric(9,5) NULL,
       LOTE                 Character(5) NULL,
       IPI                  Numeric(5,2) NULL,
       ICMS                 Numeric(5,2) NULL,
       FRETE                Numeric(10,2) NULL,
       OUTRATX              Numeric(10,2) NULL,
       QTD_PEC              Numeric(5) NULL,
       R_DTPED              Date NULL,
       R_QTDPEC             Numeric(13,2) NULL,
       R_QTDKG              Numeric(10,2) NULL,
       R_VALKG              Numeric(16,5) NULL,
       CUSTO_KG             Numeric(10,2) NULL,
       CUS_ITOT             Numeric(10,2) NULL
);


CREATE TABLE ESTNN (
       CODROT               Character(10) NULL,
       DESCRICAO            Character(30) NULL
);


CREATE TABLE ESTREPO (
       DTEMISSAO            Date NULL,
       TITULO               Character(40) NULL,
       HREMISSAO            Character(8) NULL,
       STATUS               Character(1) NULL,
       ARQPRN               Character(12) NULL,
       PADRAO               Numeric(3) NULL
);


CREATE TABLE ESTROTIN (
       CODROT               Character(10) NULL,
       DESCROT              Character(30) NULL,
       FASTKEY              Character(10) NULL,
       NIVEL                Numeric(5) NULL
);


CREATE TABLE ESTTMP10 (
       OPERACAO             Character(1) NULL,
       FORMA                Character(3) NULL,
       TIPO                 Character(5) NULL,
       ESTADO               Character(1) NULL,
       BIT_INT              Character(2) NULL,
       BIT_FN               Character(2) NULL,
       BIT_FD               Character(2) NULL,
       BIT_MM               Numeric(8,3) NULL,
       ESP_INT              Character(4) NULL,
       ESP_FN               Character(2) NULL,
       ESP_FD               Character(2) NULL,
       ESP_MM               Numeric(8,3) NULL,
       TIPOMOVI             Character(3) NULL,
       DATAMOVI             Date NULL,
       QTD_KG               Numeric(12,2) NULL,
       QTD_INT              Numeric(5) NULL,
       VAL_KG               Numeric(9,5) NULL,
       ORIGEM               Character(30) NULL,
       ALMOXARI             Character(3) NULL
);


CREATE TABLE ESTUSUAR (
       CODUSU               Character(6) NULL,
       NOMEUSU              Character(20) NULL,
       SENHA                Character(7) NULL
);


CREATE TABLE FONT (
       FONT_ID              Numeric(12) NULL,
       FONT_TYPE            Character(6) NULL,
       DIAG_ID              Numeric(12) NULL,
       FONT_HGHT            Numeric(12) NULL,
       FONT_WDTH            Numeric(12) NULL,
       FONT_ESCP            Numeric(12) NULL,
       FONT_ORNT            Numeric(12) NULL,
       FONT_WGHT            Numeric(12) NULL,
       FONT_ITLC            Numeric(12) NULL,
       FONT_UNDRL           Numeric(12) NULL,
       FONT_STRKT           Numeric(12) NULL,
       FONT_CHRST           Numeric(12) NULL,
       FONT_OTPR            Numeric(12) NULL,
       FONT_CLIP            Numeric(12) NULL,
       FONT_QUAL            Numeric(12) NULL,
       FONT_PITCH           Numeric(12) NULL,
       FONT_NAME            Character(254) NULL,
       OLDFONTH             Numeric(12) NULL
);


CREATE TABLE FOXINST (
       FILENAME             Character(12) NULL,
       SUBDIR               Character(8) NULL,
       INSTALLPRC           Character(8) NULL,
       OPTIONAL             Logical NULL,
       ARCHIVED             Logical NULL,
       DISKNO               Numeric(2) NULL,
       SEQNO                Numeric(2) NULL,
       DESCRIPT1            Character(70) NULL,
       DESCRIPT2            Character(70) NULL,
       DESCRIPT3            Character(70) NULL
);


CREATE TABLE GBL_TMPL (
       TMPLT_ID             Numeric(12) NULL,
       TMPLT_TYPE           Character(6) NULL,
       DIAG_ID              Numeric(12) NULL,
       TARG_SYS             Character(6) NULL,
       TMPLT_PURP           Character(6) NULL
);


CREATE TABLE INDX_MEM (
       INDEX_ID             Numeric(12) NULL,
       INDEX_TYPE           Character(6) NULL,
       ENT_ID               Numeric(12) NULL,
       ENT_TYPE             Character(6) NULL,
       ATT_ID               Numeric(12) NULL,
       ATT_TYPE             Character(6) NULL,
       DIAG_ID              Numeric(12) NULL,
       INDEX_POS            Numeric(12) NULL
);


CREATE TABLE INDX_MPP (
       INDEX_ID             Numeric(12) NULL,
       INDEX_TYPE           Character(6) NULL,
       ENT_ID               Numeric(12) NULL,
       ENT_TYPE             Character(6) NULL,
       ATT_ID               Numeric(12) NULL,
       ATT_TYPE             Character(6) NULL,
       DIAG_ID              Numeric(12) NULL,
       TARG_SYS             Character(6) NULL,
       PROP_NAME            Character(254) NULL,
       PROP_VAL             Numeric(12) NULL
);


CREATE TABLE INDXPROP (
       INDEX_ID             Numeric(12) NULL,
       INDEX_TYPE           Character(6) NULL,
       ENT_ID               Numeric(12) NULL,
       ENT_TYPE             Character(6) NULL,
       DIAG_ID              Numeric(12) NULL,
       TARG_SYS             Character(6) NULL,
       IDX_PV_TYP           Character(6) NULL,
       IDX_PV_POB           Numeric(12) NULL,
       IDX_PV_VAL           Numeric(12) NULL
);


CREATE TABLE PHYS_OBJ (
       POBJ_ID              Numeric(12) NULL,
       POBJ_TYPE            Character(6) NULL,
       DIAG_ID              Numeric(12) NULL,
       TARG_SYS             Character(6) NULL,
       POBJ_NAME            Character(254) NULL
);


CREATE TABLE POBJPV (
       POBJ_ID              Numeric(12) NULL,
       POBJ_TYPE            Character(6) NULL,
       DIAG_ID              Numeric(12) NULL,
       POBJPV_TYP           Character(6) NULL,
       POBJPV_VAL           Numeric(12) NULL,
       POBJPV_IVA           Numeric(12) NULL,
       POBJPV_SVA           Character(254) NULL
);


CREATE TABLE REL_PHYS (
       REL_ID               Numeric(12) NULL,
       REL_TYPE             Character(6) NULL,
       DIAG_ID              Numeric(12) NULL,
       TARG_SYS             Character(6) NULL,
       FOREIGNKEY           Character(254) NULL,
       PHYS_CMT             Numeric(12) NULL
);


CREATE TABLE REL_TMPL (
       REL_ID               Numeric(12) NULL,
       REL_TYPE             Character(6) NULL,
       TMPLT_ID             Numeric(12) NULL,
       TMPLT_TYPE           Character(6) NULL,
       DIAG_ID              Numeric(12) NULL,
       TARG_SYS             Character(6) NULL,
       RTMPLPURP            Character(6) NULL
);


CREATE TABLE RELATARQ (
       DTEMISSAO            Date NULL,
       TITULO               Character(40) NULL,
       HREMISSAO            Character(8) NULL,
       STATUS               Character(1) NULL,
       ARQPRN               Character(12) NULL,
       PADRAO               Numeric(3) NULL
);


CREATE TABLE RPT_OPT (
       DIAG_ID              Numeric(12) NULL,
       RPT_ID               Numeric(12) NULL,
       RPT_OPT_ID           Numeric(12) NULL,
       RPT_OPT_SE           Numeric(12) NULL,
       RPT_OPT_NA           Character(254) NULL,
       RPT_OPT_VA           Numeric(12) NULL,
       RPT_OPT_TY           Numeric(12) NULL,
       RPT_OPT_MU           Numeric(12) NULL
);


CREATE TABLE S (
       TESTE                Character(20) NULL
);


CREATE TABLE SICADIR (
       CODUSU               Character(5) NULL,
       CODROT               Character(4) NULL,
       ACESSO               Character(1) NULL,
       DIRVER               Character(11) NULL
);


CREATE TABLE SICAROT (
       CODROT               Character(4) NULL,
       DESCROT              Character(30) NULL
);


CREATE TABLE SICAUSU (
       CODUSU               Character(5) NULL,
       NOMEUSU              Character(20) NULL,
       SENHA                Character(6) NULL
);


CREATE TABLE SR0100 (
       CODBANCO             Character(3) NULL,
       DESCRICAO            Character(30) NULL
);


CREATE TABLE SR0200 (
       CODBANCO             Character(3) NULL,
       CODAGENCIA           Character(6) NULL,
       DESCRICAO            Character(30) NULL
);


CREATE TABLE SR0300 (
       TIPOVENDA            Character(2) NULL,
       DESCRICAO            Character(30) NULL,
       PARCELA              Character(1) NULL
);


CREATE TABLE SR0400 (
       TIPOVENDA            Character(2) NULL,
       FORMAPAG             Character(2) NULL,
       DESCRICAO            Character(30) NULL,
       CHEQUE               Character(1) NULL,
       BOLETA               Character(1) NULL,
       DUPLIC               Character(1) NULL
);


CREATE TABLE SR0500 (
       CODVENC              Character(2) NULL,
       DESCRICAO            Character(30) NULL,
       DIAS_1               Numeric(2) NULL,
       DIAS_2               Numeric(2) NULL,
       DIAS_3               Numeric(2) NULL,
       DIAS_4               Numeric(2) NULL,
       DIAS_5               Numeric(2) NULL,
       QTDVENC              Numeric(1) NULL
);


CREATE TABLE SR0600 (
       CODBANCO             Character(3) NULL,
       CODAGENCIA           Character(6) NULL,
       NR_CHEQUE            Character(11) NULL,
       NR_CONTA             Character(11) NULL,
       DUPLICATA            Character(5) NULL,
       SEQUENCIA            Character(1) NULL,
       CGC                  Character(14) NULL,
       CPF                  Character(11) NULL,
       FLAG_CGC             Character(1) NULL,
       FLAG_CPF             Character(1) NULL,
       NOME                 Character(30) NULL,
       VALOR                Numeric(14,2) NULL,
       DT_PREDATA           Date NULL,
       EMISSAO              Date NULL,
       DT_PAG               Date NULL,
       CODCLI               Character(5) NULL,
       USUARIO              Character(10) NULL,
       STATUS               Character(1) NULL,
       RAZAO                Character(30) NULL,
       DDD01                Character(4) NULL,
       TEL01                Character(11) NULL,
       DEST_NOME            Character(20) NULL,
       DEST_DATA            Date NULL,
       TIPO                 Character(1) NULL
);


CREATE TABLE SR1000 (
       DUPLICATA            Character(5) NULL,
       SEQUENCIA            Character(1) NULL,
       DT_VENC              Date NULL,
       DT_PAG               Date NULL,
       VALOR                Numeric(14,2) NULL,
       JUROS                Numeric(10,2) NULL,
       CODCLI               Character(5) NULL,
       USUARIO              Character(10) NULL,
       STATUS               Character(1) NULL,
       FORMAPAG             Character(2) NULL,
       QTD_CH               Numeric(1) NULL,
       BOLETA               Character(8) NULL,
       TIPO_DOC             Character(1) NULL,
       ACORDO               Character(1) NULL,
       VLPAGO               Numeric(15,2) NULL,
       VLSALDO              Numeric(15,2) NULL,
       DEST_NOME            Character(20) NULL,
       DEST_DATA            Date NULL,
       JRACORDO             Numeric(10,2) NULL,
       VLACPAGAR            Numeric(12,2) NULL,
       JRACPAGAR            Numeric(10,2) NULL,
       VLACPAGO             Numeric(12,2) NULL,
       JRACPAGO             Numeric(10,2) NULL,
       FLG_ABATI            Character(1) NULL,
       ABATIMENTO           Numeric(12,2) NULL,
       FLG_TXADM            Character(1) NULL,
       DT_CREDITO           Date NULL,
       DTACORDO             Date NULL,
       TXADM                Numeric(12,2) NULL,
       TIPO                 Character(1) NULL
);


CREATE TABLE SR1100 (
       DUPLICATA            Character(5) NULL,
       SEQUENCIA            Character(1) NULL,
       DTACORDO             Date NULL,
       VLACORDO             Numeric(14,2) NULL,
       SDACORDO             Numeric(14,2) NULL,
       JRACORDO             Numeric(10,2) NULL,
       JRACPAGO             Numeric(10,2) NULL,
       VLACPAGO             Numeric(12,2) NULL,
       JRACPAGAR            Numeric(10,2) NULL,
       VLACPAGAR            Numeric(12,2) NULL
);


CREATE TABLE SR1300 (
       CODIGO               Character(5) NULL,
       DESCRICAO            Character(30) NULL
);


CREATE TABLE SR9991 (
       JUROS                Numeric(6,2) NULL,
       VALOR                Numeric(5,2) NULL,
       DTJUROS              Date NULL
);


CREATE TABLE SUBJECT (
       DIAG_ID              Numeric(12) NULL,
       SUBJ_ID              Numeric(12) NULL,
       SUBJ_NAME            Character(254) NULL,
       SUBJ_DESC            Numeric(12) NULL,
       SUBJ_AUTH            Character(254) NULL,
       SUBJ_CRDT            Numeric(12) NULL,
       SUBJ_MDDT            Numeric(12) NULL,
       SUBJ_FLAG            Numeric(12) NULL,
       SUBJ_BPX             Numeric(12) NULL
);


CREATE TABLE SYN_PROP (
       SYN_NAME             Character(128) NULL,
       ENT_ID               Numeric(12) NULL,
       ENT_TYPE             Character(6) NULL,
       DIAG_ID              Numeric(12) NULL,
       TARG_SYS             Character(6) NULL,
       SYN_PV_TP            Character(6) NULL,
       SYN_PV_VAL           Character(256) NULL
);


CREATE TABLE TBLCONST (
       ENT_ID               Numeric(12) NULL,
       ENT_TYPE             Character(6) NULL,
       DIAG_ID              Numeric(12) NULL,
       VLDRULE_ID           Numeric(12) NULL,
       VLDRULE_TP           Character(6) NULL,
       TARG_SVR             Character(6) NULL,
       TARG_CLI             Character(6) NULL
);


CREATE TABLE TEMPLATE (
       TMPLT_ID             Numeric(12) NULL,
       TMPLT_TYPE           Character(6) NULL,
       DIAG_ID              Numeric(12) NULL,
       TARG_SYS             Character(6) NULL,
       TMPL_NAME            Character(254) NULL,
       TMPL_CODE            Numeric(12) NULL
);


CREATE TABLE TEXT_BLK (
       TEXT_ID              Numeric(12) NULL,
       TEXT_TYPE            Character(6) NULL,
       DIAG_ID              Numeric(12) NULL,
       TEXT_VAL             Numeric(12) NULL
);


CREATE TABLE TRIGCOLS (
       ENT_ID               Numeric(12) NULL,
       ENT_TYPE             Character(6) NULL,
       DIAG_ID              Numeric(12) NULL,
       TARG_SYS             Character(6) NULL,
       TRIG_NAME            Character(254) NULL,
       COLS_LOG             Character(254) NULL,
       COLS_ORDER           Numeric(12) NULL,
       COLS_PHYS            Character(254) NULL
);


CREATE TABLE V (
       CODCLI               Character(5) NULL,
       GUERRA               Character(10) NULL,
       RAZAO                Character(40) NULL,
       CGC                  Character(14) NULL,
       CPF                  Character(21) NULL,
       INSC_EST             Character(12) NULL,
       ENDERECO             Character(40) NULL,
       DDD01                Character(4) NULL,
       TEL01                Character(11) NULL,
       RAMAL01              Character(4) NULL,
       CONTATO01            Character(26) NULL,
       DDD02                Character(4) NULL,
       TEL02                Character(11) NULL,
       RAMAL02              Character(4) NULL,
       CONTATO02            Character(26) NULL,
       DDD03                Character(4) NULL,
       TEL03                Character(11) NULL,
       RAMAL03              Character(4) NULL,
       CONTATO03            Character(26) NULL,
       DDD04                Character(4) NULL,
       TEL04                Character(11) NULL,
       RAMAL04              Character(4) NULL,
       CONTATO04            Character(26) NULL,
       DDD05                Character(4) NULL,
       TEL05                Character(11) NULL,
       RAMAL05              Character(4) NULL,
       CONTATO05            Character(26) NULL,
       PRAC_PAG             Character(53) NULL,
       LOCAL_ENT            Character(53) NULL,
       TRANSPORT            Character(53) NULL,
       COMPRADOR            Character(20) NULL,
       COMISSAO             Numeric(5) NULL,
       AC_PERDA             Character(1) NULL,
       AC_ACRESC            Character(1) NULL,
       LIM_CREDI            Numeric(12,2) NULL,
       SALDO                Numeric(12,2) NULL,
       TIPO_CLI             Character(1) NULL,
       P_C_MENSAL           Numeric(15,2) NULL,
       CODVEN               Character(2) NULL,
       CHEQUE_PRE           Character(1) NULL,
       CIDADE               Character(20) NULL,
       BAIRRO               Character(20) NULL,
       MUNICIPIO            Character(10) NULL,
       ESTADO               Character(2) NULL,
       CEP                  Character(8) NULL,
       DDDFAX01             Character(4) NULL,
       FAX01                Character(11) NULL,
       DDDFAX02             Character(4) NULL,
       FAX02                Character(11) NULL,
       END_ENT              Character(40) NULL,
       CEP_ENT              Character(8) NULL,
       BAIR_ENT             Character(20) NULL,
       CIDA_ENT             Character(20) NULL,
       ESTA_ENT             Character(2) NULL,
       END_PAG              Character(40) NULL,
       CEP_PAG              Character(8) NULL,
       BAIR_PAG             Character(20) NULL,
       CIDA_PAG             Character(20) NULL,
       ESTA_PAG             Character(2) NULL,
       END_TRAN             Character(40) NULL,
       TEL_TRAN             Character(8) NULL,
       BAIR_TRAN            Character(20) NULL,
       CIDA_TRAN            Character(20) NULL,
       ESTA_TRAN            Character(2) NULL
);


CREATE TABLE VEN001 (
       CODCLI               Character(5) NULL,
       RAZAO                Character(55) NULL,
       CGC                  Character(14) NULL,
       CPF                  Character(21) NULL,
       INSC_EST             Character(15) NULL,
       ENDERECO             Character(40) NULL,
       DDD01                Character(4) NULL,
       TEL01                Character(11) NULL,
       RAMAL01              Character(4) NULL,
       CONTATO01            Character(26) NULL,
       DDD02                Character(4) NULL,
       TEL02                Character(11) NULL,
       RAMAL02              Character(4) NULL,
       CONTATO02            Character(26) NULL,
       DDD03                Character(4) NULL,
       TEL03                Character(11) NULL,
       RAMAL03              Character(4) NULL,
       CONTATO03            Character(26) NULL,
       DDD04                Character(4) NULL,
       TEL04                Character(11) NULL,
       RAMAL04              Character(4) NULL,
       CONTATO04            Character(26) NULL,
       DDD05                Character(4) NULL,
       TEL05                Character(11) NULL,
       RAMAL05              Character(4) NULL,
       CONTATO05            Character(26) NULL,
       CODAREA              Character(2) NULL,
       PRAC_PAG             Character(53) NULL,
       LOCAL_ENT            Character(53) NULL,
       TRANSPORT            Character(53) NULL,
       COMPRADOR            Character(20) NULL,
       COMISSAO             Numeric(5) NULL,
       AC_PERDA             Character(1) NULL,
       AC_ACRESC            Character(1) NULL,
       LIM_CREDI            Numeric(12,2) NULL,
       SALDO                Numeric(12,2) NULL,
       TIPO_CLI             Character(1) NULL,
       P_C_MENSAL           Numeric(15,2) NULL,
       CODVEN               Character(2) NULL,
       CHEQUE_PRE           Character(1) NULL,
       CIDADE               Character(20) NULL,
       BAIRRO               Character(20) NULL,
       ESTADO               Character(2) NULL,
       CEP                  Character(8) NULL,
       DDDFAX01             Character(4) NULL,
       FAX01                Character(11) NULL,
       DDDFAX02             Character(4) NULL,
       FAX02                Character(11) NULL,
       END_ENT              Character(40) NULL,
       CEP_ENT              Character(8) NULL,
       BAIR_ENT             Character(20) NULL,
       CIDA_ENT             Character(20) NULL,
       ESTA_ENT             Character(2) NULL,
       END_PAG              Character(40) NULL,
       CEP_PAG              Character(8) NULL,
       BAIR_PAG             Character(20) NULL,
       CIDA_PAG             Character(20) NULL,
       ESTA_PAG             Character(2) NULL,
       GUERRA               Character(15) NULL,
       END_TRAN             Character(40) NULL,
       BAIR_TRAN            Character(20) NULL,
       CIDA_TRAN            Character(20) NULL,
       ESTA_TRAN            Character(2) NULL,
       TEL_TRAN             Character(15) NULL,
       TEL2_TRAN            Character(9) NULL,
       TEL3_TRAN            Character(9) NULL,
       MUNICIPIO            Character(20) NULL,
       NOME_TRAN            Character(30) NULL,
       OBS1                 Character(50) NULL,
       OBS2                 Character(50) NULL,
       OBS3                 Character(50) NULL,
       OBS4                 Character(50) NULL,
       OBS5                 Character(50) NULL
);


CREATE TABLE VEN002 (
       CODVEN               Character(2) NULL,
       NOME                 Character(40) NULL,
       GUERRA               Character(15) NULL
);


CREATE TABLE VEN003 (
       CONSULTA             Character(6) NULL,
       DT_CONS              Date NULL,
       CODCLI               Character(8) NULL,
       CLIENTE              Character(20) NULL,
       COMPRADOR            Character(20) NULL,
       CODVEN               Character(2) NULL,
       QTD_ITENS            Numeric(2) NULL,
       VALOR                Numeric(12,2) NULL,
       OBS                  Character(40) NULL,
       STATUS               Character(1) NULL
);


CREATE TABLE VEN004 (
       CONSULTA             Character(6) NULL,
       SEQUENC              Numeric(3) NULL,
       FORMA                Character(3) NULL,
       TIPO                 Character(5) NULL,
       ESTADO               Character(1) NULL,
       BIT_INT              Character(2) NULL,
       BIT_FN               Character(2) NULL,
       BIT_FD               Character(2) NULL,
       BIT_MM               Numeric(8,3) NULL,
       ESP_INT              Character(2) NULL,
       ESP_FN               Character(2) NULL,
       ESP_FD               Character(2) NULL,
       ESP_MM               Numeric(8,3) NULL,
       COMPRIM              Numeric(10,2) NULL,
       LARGURA              Numeric(10,2) NULL,
       ESPESSURA            Numeric(10,2) NULL,
       QTD_PECAS            Numeric(5) NULL,
       PESO_TEO             Numeric(10,2) NULL,
       PESO_COBRA           Numeric(10,2) NULL,
       PESO_BALAN           Numeric(10,2) NULL,
       UNIDADE              Character(1) NULL,
       PRECO                Numeric(10,2) NULL,
       DT_VALID             Date NULL,
       PEDVEN               Character(5) NULL,
       STATUS               Character(1) NULL,
       USUARIO              Character(30) NULL,
       PRECOTAB             Numeric(10,2) NULL,
       SEPARA               Character(1) NULL,
       PESO_ITEM            Numeric(10,2) NULL,
       SUBFORMA             Character(1) NULL,
       TIPOEST              Character(1) NULL,
       DIGITACAO            Character(1) NULL,
       PES_MATNOT           Numeric(10,2) NULL,
       OBSERVACAO           Character(65) NULL,
       COM_COMP             Numeric(7,2) NULL,
       COM_VEND             Numeric(7,2) NULL,
       PESOPECA             Numeric(12,2) NULL
);


CREATE TABLE VEN005 (
       PEDVEN               Character(5) NULL,
       CODCLI               Character(5) NULL,
       COMPRADOR            Character(20) NULL,
       CODVEN               Character(2) NULL,
       DT_PEDVEN            Date NULL,
       DT_PEDIDO            Date NULL,
       VALOR                Numeric(12,2) NULL,
       QTD_ITENS            Numeric(2) NULL,
       ORDCOMPRA            Character(10) NULL,
       FLG_SEP              Character(1) NULL,
       TIPOVENDA            Character(2) NULL,
       FLG_TV               Character(1) NULL,
       CODVENC              Character(2) NULL,
       TELEFONE             Character(17) NULL,
       FORMAPAG             Character(2) NULL,
       FRETE                Numeric(12,2) NULL
);


CREATE TABLE VEN006 (
       PEDVEN               Character(5) NULL,
       SEQUENC              Numeric(3) NULL,
       SEQNF                Numeric(3) NULL,
       FORMA                Character(3) NULL,
       TIPO                 Character(5) NULL,
       ESTADO               Character(1) NULL,
       BIT_INT              Character(2) NULL,
       BIT_FN               Character(2) NULL,
       BIT_FD               Character(2) NULL,
       BIT_MM               Numeric(8,3) NULL,
       ESP_INT              Character(2) NULL,
       ESP_FN               Character(2) NULL,
       ESP_FD               Character(2) NULL,
       ESP_MM               Numeric(8,3) NULL,
       COMPRIM              Numeric(10,2) NULL,
       LARGURA              Numeric(10,2) NULL,
       ESPESSURA            Numeric(10,2) NULL,
       QTD_PECAS            Numeric(2) NULL,
       PESO_TEO             Numeric(6) NULL,
       COM_VEND             Numeric(7,2) NULL,
       COM_COMP             Numeric(6,2) NULL,
       PER_ACRES            Numeric(7,2) NULL,
       SEPARACAO            Character(10) NULL,
       TIPO_SEP             Character(1) NULL,
       PESO_BALAN           Numeric(9,2) NULL,
       DT_PEDIDO            Date NULL,
       DT_EMISSAO           Date NULL,
       DT_SEPARA            Date NULL,
       SEQ_SEPARA           Numeric(3) NULL,
       PESO_COBRA           Numeric(9,2) NULL,
       UNIDADE              Character(1) NULL,
       PRECO_UNI            Numeric(12,2) NULL,
       PRECO                Numeric(12,2) NULL,
       NOTAFISCAL           Character(8) NULL,
       CONSULTA             Character(6) NULL,
       USUARIO              Character(30) NULL,
       DT_PEDVEN            Date NULL,
       DT_VALID             Date NULL,
       PERDA                Numeric(9,2) NULL,
       SEPARADO             Character(1) NULL,
       SUBFORMA             Character(1) NULL,
       PESO_ITEM            Numeric(8,2) NULL,
       ESTOQUE              Character(1) NULL,
       QTD_SEP              Numeric(2) NULL,
       PES_MATNOT           Numeric(10,2) NULL,
       DIGITACAO            Character(1) NULL,
       RETORNADO            Character(1) NULL,
       OBSERVACAO           Character(65) NULL,
       OBSSEPARA            Character(65) NULL,
       PRAZODT              Date NULL,
       PRAZOHR              Character(5) NULL
);


CREATE TABLE VEN007 (
       PEDIDO               Character(5) NULL,
       FORMA                Character(3) NULL,
       TIPO                 Character(5) NULL,
       ESTADO               Character(1) NULL,
       BIT_INT              Character(2) NULL,
       BIT_FN               Character(2) NULL,
       BIT_FD               Character(2) NULL,
       BIT_MM               Numeric(8,3) NULL,
       ESP_INT              Character(2) NULL,
       ESP_FN               Character(2) NULL,
       ESP_FD               Character(2) NULL,
       ESP_MM               Numeric(8,3) NULL,
       COMPRIM              Numeric(10,2) NULL,
       LARGURA              Numeric(10,2) NULL,
       CUSTO                Numeric(10,2) NULL,
       DT_COMPRA            Date NULL,
       DT_PREV              Date NULL,
       DT_ENTREGA           Date NULL,
       FORNECEDOR           Character(2) NULL,
       CONTATO              Character(20) NULL,
       OBS                  Character(40) NULL
);


CREATE TABLE VEN008 (
       CODVEN               Character(2) NULL,
       DATA                 Date NULL,
       PEDVEN               Character(5) NULL,
       VALOR                Numeric(10,2) NULL,
       VALOR_PAGO           Numeric(10,2) NULL
);


CREATE TABLE VEN009 (
       CODVEN               Character(6) NULL,
       DATA                 Date NULL,
       VALOR                Numeric(12,2) NULL
);


CREATE TABLE VEN010 (
       CODCLI               Character(5) NULL,
       PEDVEN               Character(5) NULL,
       VALOR                Numeric(12,2) NULL,
       VALOR_PAGO           Numeric(12,2) NULL,
       DATA                 Date NULL
);


CREATE TABLE VEN011 (
       CODCLI               Character(5) NULL,
       DATA                 Date NULL,
       VALOR                Numeric(10,2) NULL
);


CREATE TABLE VEN012 (
       NOTAFISCAL           Character(8) NULL,
       SERIE                Character(6) NULL,
       VALOR                Numeric(10,2) NULL,
       ICMS                 Numeric(10,2) NULL,
       FRETE                Numeric(12,2) NULL,
       SEGURO               Numeric(10,2) NULL,
       VAL_TOTAL            Numeric(12,2) NULL,
       TRANSPORT            Character(25) NULL,
       DT_EMISSAO           Date NULL,
       TIPO_NOTA            Character(1) NULL,
       CODCLI               Character(5) NULL,
       QTDPARC              Numeric(2) NULL,
       QTDREC               Numeric(2) NULL,
       EMITIDO              Character(1) NULL,
       TIPOVENDA            Character(2) NULL,
       FORMAPAG             Character(2) NULL,
       STATUS               Character(1) NULL,
       CODVENC              Character(2) NULL,
       B_CALC               Numeric(10,2) NULL,
       COMPRANF             Character(8) NULL,
       COMPRADT             Date NULL
);


CREATE TABLE VEN013 (
       FORMA                Character(3) NULL,
       TIPO                 Character(5) NULL,
       ESTADO               Character(1) NULL,
       BIT_INT              Character(2) NULL,
       BIT_FN               Character(2) NULL,
       BIT_FD               Character(2) NULL,
       BIT_MM               Numeric(8,3) NULL,
       ESP_INT              Character(2) NULL,
       ESP_FN               Character(2) NULL,
       ESP_FD               Character(2) NULL,
       ESP_MM               Numeric(8,3) NULL,
       MINIMO               Numeric(10,2) NULL,
       MAXIMO               Numeric(10,2) NULL,
       GRUPO                Character(1) NULL,
       VALOR                Numeric(15,2) NULL,
       DT_ATU               Date NULL
);


CREATE TABLE VEN014 (
       GRUPO                Character(2) NULL,
       DESCMIN              Numeric(6,2) NULL,
       DESCMAX              Numeric(6,2) NULL,
       COMISSAO             Numeric(6,2) NULL,
       DATA                 Date NULL,
       USUARIO              Character(10) NULL,
       SENHA                Character(1) NULL
);


CREATE TABLE VEN015 (
       GRUPO                Character(2) NULL,
       DESCRICAO            Character(25) NULL
);


CREATE TABLE VEN016 (
       SEPARACAO            Character(10) NULL,
       EXTRAIDA             Character(20) NULL,
       CONFERIDA            Character(20) NULL,
       SEPARADA             Character(20) NULL,
       DATA                 Date NULL,
       PEDVEN               Character(5) NULL,
       STATUS               Character(1) NULL,
       OBSERVACAO           Character(65) NULL,
       FLG_CR_NF            Character(1) NULL
);


CREATE TABLE VEN017 (
       GRUPO                Character(2) NULL,
       COMPMINIMO           Numeric(7,3) NULL
);


CREATE TABLE VEN018 (
       GRUPO                Character(2) NULL,
       SUBGRUPO             Character(2) NULL,
       DESCRICAO            Character(20) NULL
);


CREATE TABLE VEN019 (
       GRUPO                Character(2) NULL,
       SUBGRUPO             Character(2) NULL,
       COLUNA               Character(2) NULL,
       DESCRICAO            Character(20) NULL,
       PRECO                Numeric(15,2) NULL
);


CREATE TABLE VEN020 (
       GRUPO                Character(2) NULL,
       SUBFATOR             Character(2) NULL,
       DESCRICAO            Character(15) NULL,
       MEDIDAFIM            Numeric(10,2) NULL,
       FATOR                Numeric(5,2) NULL
);


CREATE TABLE VEN021 (
       GRUPO                Character(2) NULL,
       SUBFATOR             Character(2) NULL,
       MEDIDAFIM            Numeric(8,3) NULL,
       FATOR                Numeric(7,3) NULL
);


CREATE TABLE VEN023 (
       PEDVEN               Character(5) NULL,
       ITEM                 Numeric(3) NULL,
       CONSULTA             Character(6) NULL,
       SEQUENC              Numeric(3) NULL,
       FORNECEDOR           Character(30) NULL,
       TELEFONE             Character(17) NULL,
       COMPRADO             Character(30) NULL,
       DATA                 Date NULL,
       PRECO_UNI            Numeric(8,2) NULL,
       PESO                 Numeric(8,2) NULL,
       UNIDADE              Character(1) NULL,
       IPI                  Numeric(6,2) NULL,
       ICMS                 Numeric(6,2) NULL,
       FRETE                Numeric(12,2) NULL,
       CUSTO                Numeric(12,2) NULL,
       DDD                  Character(4) NULL
);


CREATE TABLE VEN024 (
       PESO_MIN             Numeric(12,2) NULL,
       PESO_MAX             Numeric(12,2) NULL,
       VALOR                Numeric(12,2) NULL
);


CREATE TABLE VEN025 (
       PEDVEN               Character(5) NULL,
       SEQUENC              Numeric(3) NULL,
       SEQNF                Numeric(3) NULL,
       FORMA                Character(3) NULL,
       TIPO                 Character(5) NULL,
       ESTADO               Character(1) NULL,
       BIT_INT              Character(2) NULL,
       BIT_FN               Character(2) NULL,
       BIT_FD               Character(2) NULL,
       BIT_MM               Numeric(8,3) NULL,
       ESP_INT              Character(2) NULL,
       ESP_FN               Character(2) NULL,
       ESP_FD               Character(2) NULL,
       ESP_MM               Numeric(8,3) NULL,
       COMPRIM              Numeric(12,2) NULL,
       LARGURA              Numeric(12,2) NULL,
       ESPESSURA            Numeric(12,2) NULL,
       QTD_PECAS            Numeric(5) NULL,
       PESO_TEO             Numeric(12,2) NULL,
       COM_VEND             Numeric(7,2) NULL,
       COM_COMP             Numeric(6,2) NULL,
       PER_ACRES            Numeric(7,2) NULL,
       SEPARACAO            Character(10) NULL,
       TIPO_SEP             Character(1) NULL,
       PESO_BALAN           Numeric(12,2) NULL,
       DT_PEDIDO            Date NULL,
       DT_EMISSAO           Date NULL,
       DT_SEPARA            Date NULL,
       SEQ_SEPARA           Numeric(3) NULL,
       PESO_COBRA           Numeric(12,2) NULL,
       UNIDADE              Character(1) NULL,
       PRECO                Numeric(12,2) NULL,
       PRECO_UNI            Numeric(12,2) NULL,
       NOTAFISCAL           Character(8) NULL,
       CONSULTA             Character(6) NULL,
       USUARIO              Character(30) NULL,
       DT_PEDVEN            Date NULL,
       DT_VALID             Date NULL,
       PERDA                Numeric(9,2) NULL,
       PESO_ITEM            Numeric(12,2) NULL,
       SEPARADO             Character(1) NULL,
       ESTOQUE              Character(1) NULL,
       SUBFORMA             Character(1) NULL,
       RETORNADO            Character(1) NULL,
       QTD_SEP              Numeric(2) NULL,
       PES_MATNOT           Numeric(12,2) NULL,
       DIGITACAO            Character(1) NULL,
       OBSERVACAO           Character(65) NULL
);


CREATE TABLE VEN030 (
       NUMERO               Character(5) NULL,
       VALOR                Numeric(10,2) NULL,
       FRETE                Numeric(12,2) NULL,
       SEGURO               Numeric(10,2) NULL,
       VAL_TOTAL            Numeric(12,2) NULL,
       TRANSPORT            Character(25) NULL,
       DT_EMISSAO           Date NULL,
       CODCLI               Character(5) NULL,
       QTDPARC              Numeric(2) NULL,
       QTDREC               Numeric(2) NULL,
       EMITIDO              Character(1) NULL,
       TIPOVENDA            Character(2) NULL,
       FORMAPAG             Character(2) NULL,
       STATUS               Character(1) NULL,
       CODVENC              Character(2) NULL,
       ICMS                 Numeric(10,2) NULL
);


CREATE TABLE VEN050 (
       NOTAFISCAL           Character(8) NULL,
       SERIE                Character(6) NULL,
       VALOR                Numeric(10,2) NULL,
       ICMS                 Numeric(10,2) NULL,
       FRETE                Numeric(12,2) NULL,
       SEGURO               Numeric(10,2) NULL,
       VAL_TOTAL            Numeric(12,2) NULL,
       TRANSPORT            Character(25) NULL,
       DT_EMISSAO           Date NULL,
       TIPO_NOTA            Character(1) NULL,
       CODCLI               Character(5) NULL,
       QTDPARC              Numeric(2) NULL,
       QTDREC               Numeric(2) NULL,
       EMITIDO              Character(1) NULL,
       TIPOVENDA            Character(2) NULL,
       FORMAPAG             Character(2) NULL,
       STATUS               Character(1) NULL,
       CODVENC              Character(2) NULL,
       B_CALC               Numeric(10,2) NULL,
       COMPRANF             Character(8) NULL,
       COMPRADT             Date NULL,
       ORIGEM               Character(10) NULL
);


CREATE TABLE VEN099 (
       ACRESCIMO            Numeric(10,2) NULL
);


CREATE TABLE VEN117 (
       GRUPO                Character(2) NULL,
       COMPMINIMO           Numeric(7,3) NULL
);


CREATE TABLE VEN372 (
       CODIGO               Character(6) NULL,
       NFAX                 Character(17) NULL,
       DESTINO              Character(35) NULL,
       ASSUNTO              Character(20) NULL,
       DATA                 Date NULL,
       AT                   Character(25) NULL,
       DEPTO                Character(25) NULL,
       NMENS                Numeric(4) NULL,
       SOLIC                Character(25) NULL,
       NPAG                 Numeric(4) NULL,
       ARQUIVO              Character(8) NULL,
       MENSAGEM             Memo NULL
);


CREATE TABLE VEN95 (
       PEDVEN               Character(5) NULL,
       CODCLI               Character(5) NULL,
       CODVEN               Character(2) NULL,
       DT_PEDVEN            Date NULL,
       DT_PEDIDO            Date NULL,
       VALOR                Numeric(12,2) NULL,
       QTD_ITENS            Numeric(2) NULL
);


CREATE TABLE VENM012 (
       NOTAFISCAL           Character(8) NULL,
       SERIE                Character(6) NULL,
       VALOR                Numeric(10,2) NULL,
       ICMS                 Numeric(14,2) NULL,
       FRETE                Numeric(12,2) NULL,
       SEGURO               Numeric(10,2) NULL,
       VAL_TOTAL            Numeric(12,2) NULL,
       TRANSPORT            Character(25) NULL,
       DT_EMISSAO           Date NULL,
       TIPO_NOTA            Character(1) NULL,
       CODCLI               Character(5) NULL,
       QTDPARC              Numeric(2) NULL,
       QTDREC               Numeric(2) NULL,
       EMITIDO              Character(1) NULL,
       TIPOVENDA            Character(2) NULL,
       FORMAPAG             Character(2) NULL,
       STATUS               Character(1) NULL,
       CODVENC              Character(2) NULL
);


CREATE TABLE VLDRULE (
       VLDRULE_ID           Numeric(12) NULL,
       VLDRULE_TP           Character(6) NULL,
       DIAG_ID              Numeric(12) NULL,
       VLDRULE_NA           Character(254) NULL,
       CLI_RULE             Numeric(12) NULL,
       SVR_RULE             Numeric(12) NULL,
       C_S_TYPE             Numeric(12) NULL,
       CLI_TYPE             Numeric(12) NULL,
       CLI_WARN             Character(254) NULL,
       MIN_VALUE            Character(254) NULL,
       MAX_VALUE            Character(254) NULL,
       SVR_WARN             Character(254) NULL
);


CREATE TABLE VLDVAL (
       VLDRULE_ID           Numeric(12) NULL,
       VLDRULE_TP           Character(6) NULL,
       DIAG_ID              Numeric(12) NULL,
       VLDVAL_VAL           Character(254) NULL,
       VLDVAL_DEF           Numeric(12) NULL,
       VLDVAL_DIS           Character(254) NULL,
       VLDVAL_SEQ           Numeric(12) NULL
);

