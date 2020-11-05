/*
   TENAX - Demonstrativo de Aplicacao Financeira
   TENAX11.PRG - Cadastro de Clientes
   satoy - 10:51 11 Jan,1993
*/

#include "inkey.ch"
setcancel(.t.)
ALTD(1)

setcolor(W_COREDIT)
status(' C l i e n t e ')

X_CODCLI     := space(05)

X_TIPO_CLI   := space(01)
X_RAZAO      := space(55)
X_CGC        := space(14)
X_CPF        := space(11)
X_INSC_EST   := space(15)
X_ENDERECO   := space(40)
X_CEP        := space(08)
X_BAIRRO     := space(20)
X_MUNICIPIO  := space(20)
X_ESTADO     := space(2)

X_DDD01   := X_DDD02   := X_DDD03   := X_DDD04   := X_DDD05   := space(04)
X_TEL01   := X_TEL02   := X_TEL03   := X_TEL04   := X_TEL05   := space(11)
X_RAMAL01 := X_RAMAL02 := X_RAMAL03 := X_RAMAL04 := X_RAMAL05 := space(04)
X_CONT01  := X_CONT02  := X_CONT03  := X_CONT04  := X_CONT05  := space(20)

X_DDDFAX01   := X_DDDFAX02   := space(04)
X_FAX01      := X_FAX02      := space(11)

X_CODAREA    := space(02)
X_COMPRADOR  := space(20)
X_COMISSAO   := 0.00 // N-5
X_AC_PERDA   := 'S'
X_AC_ACRESC  := 'N'
X_LIM_CREDI  := 0.00 // N-12
X_SALDO      := 0.00 // N-12
X_TIPO_CLI   := space(01)
X_P_C_MENSAL := 0.00 // N-12
X_CODVEN     := space(02)
X_GUERRA     := space(15)
X_CLIGUERRA  := space(10)

X_END_PAG    := space(40)
X_CEP_PAG    := space(08)
X_BAIR_PAG   := space(20)
X_CIDA_PAG   := space(20)
X_ESTA_PAG   := space(02)

X_END_ENT    := space(40)
X_CEP_ENT    := space(08)
X_BAIR_ENT   := space(20)
X_CIDA_ENT   := space(20)
X_ESTA_ENT   := space(02)

X_NOME_TRAN  := space(30)
X_END_TRAN   := space(40)
X_TEL_TRAN   := space(15)
X_TEL2_TRAN   := space(09)
X_TEL3_TRAN   := space(09)
X_BAIR_TRAN  := space(20)
X_CIDA_TRAN  := space(20)
X_ESTA_TRAN  := space(02)
X_OBS1       := space(50)
X_OBS2       := space(50)
X_OBS3       := space(50)
X_OBS4       := space(50)
X_OBS5       := space(50)

WLOCENT  := space(1)
WLOCCOB  := space(1)
WLOCTRAN := space(1)
WCREDITO := space(1)
WOBS     := space(1)


// --> Inicio

abrir("VEN001")
abrir("VEN002")
abrir("EST037")

While .T.

   status(' C l i e n t e ')

   tela_11()
   zera_11()

   @ 03,19 get X_CODCLI picture "@!"
   read

   if lastkey()=K_ESC; exit; end

   if empty( X_CODCLI )
      m_tabelas( "X_CODCLI" )
      if lastkey()=K_ESC; loop; end
   end

   if lastkey()=K_ESC; exit; end

   VEN001->( dbseek(X_CODCLI) )

   if VEN001->( found() )
      atribui_11()
      show_11()

      W_RESP := esp_alt()

      do case

      case W_RESP = "*"
         exit

      case W_RESP = "A"
         while .t.
            if get_11("ALTERACAO")
               if conf('Confirma Dados')
                  grava_11('A')
                  exit
               end
            else
               exit
            end
         end

      case W_RESP = "E"
         if conf( 'Confirma Exclusao')
            while VEN001->( ! rlock() ); end
            VEN001->( dbdelete() )
         end
      end
   else
      while .t.
         if get_11("INCLUSAO")
            if conf('Confirma Dados')
               grava_11('I')
               exit
            end
         else
            if conf('Abandona Alteracoes')
               exit
            end
         end
      end
   end
end

dbcloseall()

// --> Fim

/*
-----------------------------------------------------------------------------
                             Procedimento Tela
-----------------------------------------------------------------------------
*/
procedure TELA_11()

   @ 02,02 say 'ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿'
   @ 03,02 say '³  Cliente.....:                             Tipo Cliente ..:              ³'
   @ 04,02 say '³  Nome Guerra :                                                           ³'
   @ 05,02 say '³  Raz„o Social:                                                           ³'
   @ 06,02 say '³  CGC/CPF.....:                       Inscric.Estadual:                   ³'
   @ 07,02 say '³  Endere‡o....:                                          CEP:      -      ³'
   @ 08,02 say '³  Bairro......:                       Mun:                      Estado:   ³'
   @ 09,02 say '³  Telefone: (    )    -      Ramal:       Contato:                        ³'
   @ 10,02 say '³            (    )    -      Ramal:       Contato:                        ³'
   @ 11,02 say '³            (    )    -      Ramal:       Contato:                        ³'
   @ 12,02 say '³            (    )    -      Ramal:       Contato:                        ³'
   @ 13,02 say '³            (    )    -      Ramal:       Contato:                        ³'
   @ 14,02 say '³  Fax     : (    )    -      Fax  :(    )   -                             ³'
   @ 15,02 say '³  Area........:                                                           ³'
   @ 16,02 say '³  Comprador...:                                                           ³'
   @ 17,02 say '³  Vendedor ...:                                                           ³'
   @ 18,02 say '³  Credito ........:                                                       ³'
   @ 19,02 say '³  Local Entrega ..:                                                       ³'
   @ 20,02 say '³  Local Cobran‡a .:                                                       ³'
   @ 21,02 say '³  Transportadora .:          Obs..:                                       ³'
   @ 22,02 say 'ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ'

return

/*
-----------------------------------------------------------------------------
                      Funcao GET_11
-----------------------------------------------------------------------------
*/
function get_11( P_ACAO )
   local WRET := .T.

   status(' C l i e n t e s ')
   L_SAVESCR := savescreen(,,,,)

   while .T.
      
      @ 03,64 get X_TIPO_CLI     picture "!" valid X_TIPO_CLI $ "CRP"
      @ 04,19 get X_GUERRA       picture "@!"
      @ 05,19 get X_RAZAO        picture "@!"
      read

      if lastkey()=K_ESC
         WRET :=.F.
         exit
      end

      if X_TIPO_CLI $ "CR"
         @ 06,02 say '³  CGC.........:                       Inscric.Estadual:                   ³'
         @ 06,19 get X_CGC picture "@R 99.999.999/9999-99" valid testa_cgc( X_CGC )
      else
         @ 06,02 say '³  CPF.........:                       Inscric.Estadual:                   ³'
         X_CPF := left(X_CGC,11)
         @ 06,19 get X_CPF picture "@R 999.999.999-99"     valid testa_cpf( X_CPF )
      end


      @ 06,59 get X_INSC_EST
      @ 07,19 get X_ENDERECO     picture "@!"
      @ 07,65 get X_CEP          picture "@R 99999-999"
      @ 08,19 get X_BAIRRO       picture "@!"
      @ 08,46 get X_MUNICIPIO    picture "@!"
      @ 08,75 get X_ESTADO       picture "@!"

      @ 09,16 get X_DDD01        picture "9999"
      @ 09,22 get X_TEL01        picture "XXXXXXXXX"
      @ 09,39 get X_RAMAL01      picture "9999"
      @ 09,54 get X_CONT01       picture "@S20"

      @ 10,16 get X_DDD02        picture "9999"       when ! empty( X_TEL01 )
      @ 10,22 get X_TEL02        picture "XXXXXXXXX"  when ! empty( X_TEL01 )
      @ 10,39 get X_RAMAL02      picture "9999"       when ! empty( X_TEL01 )
      @ 10,54 get X_CONT02       picture "@S20"       when ! empty( X_TEL01 )

      @ 11,16 get X_DDD03        picture "9999"       when ! empty( X_TEL02 )
      @ 11,22 get X_TEL03        picture "XXXXXXXXX"  when ! empty( X_TEL02 )
      @ 11,39 get X_RAMAL03      picture "9999"       when ! empty( X_TEL02 )
      @ 11,54 get X_CONT03       picture "@S20"       when ! empty( X_TEL02 )

      @ 12,16 get X_DDD04        picture "9999"       when ! empty( X_TEL03 )
      @ 12,22 get X_TEL04        picture "XXXXXXXXX"  when ! empty( X_TEL03 )
      @ 12,39 get X_RAMAL04      picture "9999"       when ! empty( X_TEL03 )
      @ 12,54 get X_CONT04       picture "@S20"       when ! empty( X_TEL03 )

      @ 13,16 get X_DDD05        picture "9999"       when ! empty( X_TEL04 )
      @ 13,22 get X_TEL05        picture "XXXXXXXXX"  when ! empty( X_TEL04 )
      @ 13,39 get X_RAMAL05      picture "9999"       when ! empty( X_TEL04 )
      @ 13,54 get X_CONT05       picture "@S20"       when ! empty( X_TEL04 )

      @ 14,16 get X_DDDFAX01     picture "9999"
      @ 14,22 get X_FAX01        picture "XXXXXXXXX"
      @ 14,39 get X_DDDFAX02     picture "9999"
      @ 14,45 get X_FAX02        picture "XXXXXXXXX"

      @ 15,19 get X_CODAREA      picture "99"         valid tes_codarea(15,19,00)

      @ 16,19 get X_COMPRADOR    picture "@!"
      IF C_ACESSO = 'NISSIM' .OR. P_ACAO = 'INCLUSAO'
        @ 17,19 get X_CODVEN       picture "@!"         valid tes_codven(X_CODVEN,17,19)
      END
      @ 18,23 get WCREDITO  picture "!" valid WCREDITO $ "X "
      @ 19,23 get WLOCENT   picture "!" valid WLOCENT  $ "X "
      @ 20,23 get WLOCCOB   picture "!" valid WLOCCOB  $ "X "
      @ 21,23 get WLOCTRAN  picture "!" valid WLOCTRAN $ "X "
      @ 21,39 get WOBS      picture "!" valid WOBS     $ "X "
      read

      if empty( X_CGC )
         X_CGC := X_CPF+space(3)
      end

      L_SAVESCR := savescreen(,,,,)

      if lastkey()=K_ESC
         WRET := .F.
         exit
      end

      if P_ACAO = "INCLUSAO"
         X_END_PAG  := X_END_ENT   := X_ENDERECO
         X_CEP_PAG  := X_CEP_ENT   := X_CEP
         X_BAIR_PAG := X_BAIR_ENT  := X_BAIRRO
         X_CIDA_PAG := X_CIDA_ENT  := X_MUNICIPIO
         X_ESTA_PAG := X_ESTA_ENT  := X_ESTADO
      end

      if WCREDITO="X"
         lgetcredito("GET")
      end

      if WLOCENT="X"
         lgetentrega( "GET" )
      end

      if WLOCCOB="X"
         lgetcobranca("GET")
      end

      if WLOCTRAN="X"
         lgettransportadora("GET")
      end

      if WOBS    ="X"
         lgetobs("GET")
      end

      if lastkey() = K_ESC
         WRET := .F.
      end
      exit
   end
   restscreen(,,,,L_SAVESCR )

return WRET

/*
-----------------------------------------------------------------------------
                      Funcao SHOW_11
-----------------------------------------------------------------------------
*/
procedure SHOW_11()

   @ 03,19 say VEN001->CODCLI       picture "@!"
   @ 03,64 say VEN001->TIPO_CLI     picture "!"
   @ 04,19 say VEN001->GUERRA       picture "@!"
   @ 05,19 say VEN001->RAZAO        picture "@!"

   if len( alltrim(VEN001->CGC) ) = 14
      @ 06,02 say '³  CGC.........:                       Inscric.Estadual:                   ³'
      @ 06,19 say VEN001->CGC          picture "@R 99.999.999/9999-99"
   else
      @ 06,02 say '³  CPF.........:                       Inscric.Estadual:                   ³'
      @ 06,19 say VEN001->CGC          picture "@R 999.999.999-99"
   end

   @ 06,59 say VEN001->INSC_EST     picture "@!"
   @ 07,19 say VEN001->ENDERECO     picture "@!"
   @ 07,65 say VEN001->CEP          picture "@R 99999-999"
   @ 08,19 say VEN001->BAIRRO       picture "@!"
   @ 08,46 say VEN001->MUNICIPIO    picture "@!"
   @ 08,75 say VEN001->ESTADO       picture "@!"
   @ 09,16 say VEN001->DDD01        picture "9999"
   @ 09,22 say VEN001->TEL01        picture "XXXXXXXXX"
   @ 09,39 say VEN001->RAMAL01      picture "9999"
   @ 09,54 say left( VEN001->CONTATO01, 20 )
   @ 10,16 say VEN001->DDD02                   picture "9999"
   @ 10,22 say VEN001->TEL02                   picture "XXXXXXXXX"
   @ 10,39 say VEN001->RAMAL02                 picture "9999"
   @ 10,54 say left( VEN001->CONTATO02, 20 )
   @ 11,16 say VEN001->DDD03                   picture "9999"
   @ 11,22 say VEN001->TEL03                   picture "XXXXXXXXX"
   @ 11,39 say VEN001->RAMAL03                 picture "9999"
   @ 11,54 say left( VEN001->CONTATO03, 20 )
   @ 12,16 say VEN001->DDD04                   picture "9999"
   @ 12,22 say VEN001->TEL04                   picture "XXXXXXXXX"
   @ 12,39 say VEN001->RAMAL04                 picture "9999"
   @ 12,54 say left( VEN001->CONTATO04, 20 )
   @ 13,16 say VEN001->DDD05                   picture "9999"
   @ 13,22 say VEN001->TEL05                   picture "XXXXXXXXX"
   @ 13,39 say VEN001->RAMAL05                 picture "9999"
   @ 13,54 say left( VEN001->CONTATO05, 20 )
   @ 14,16 say VEN001->DDDFAX01     picture "9999"
   @ 14,22 say VEN001->FAX01        picture "XXXXXXXXX"
   @ 14,39 say VEN001->DDDFAX02     picture "9999"
   @ 14,45 say VEN001->FAX02        picture "XXXXXXXXX"
   @ 15,19 say VEN001->CODAREA      picture "99"
   @ 16,19 say VEN001->COMPRADOR    picture "@!"
   @ 17,19 say VEN001->CODVEN       picture "@!"

   tes_codven(VEN001->CODVEN,17,19)

   inkey(0)

   if lastkey()=K_ESC
      WRET := .F.
      return WRET
   end

   lgetobs           ("SAY")
   lgetentrega       ("SAY")
   lgetcobranca      ("SAY")
   lgettransportadora("SAY")
   lgetcredito       ("SAY")

return

/*
-----------------------------------------------------------------------------
                      Funcao ZERA_11
-----------------------------------------------------------------------------
*/
procedure zera_11()

X_CODCLI     := space(05)

X_TIPO_CLI   := space(01)
X_RAZAO      := space(55)
X_GUERRA     := space(55)
X_CGC        := space(14)
X_INSC_EST   := space(15)
X_ENDERECO   := space(40)
X_CEP        := space(08)
X_BAIRRO     := space(20)
X_MUNICIPIO  := space(20)
X_ESTADO     := space(2)

X_DDD01      := X_DDD02      := X_DDD03    := X_DDD04    := X_DDD05    := space(04)
X_TEL01      := X_TEL02      := X_TEL03    := X_TEL04    := X_TEL05    := space(11)
X_RAMAL01    := X_RAMAL02    := X_RAMAL03  := X_RAMAL04  := X_RAMAL05  := space(04)
X_CONT01     := X_CONT02     := X_CONT03   := X_CONT04   := X_CONT05   := space(20)

X_DDDFAX01   := X_DDDFAX02   := space(04)
X_FAX01      := X_FAX02      := space(11)

X_CODAREA    := space(02)
X_COMPRADOR  := space(20)
X_COMISSAO   := 0.00 // N-5
X_AC_PERDA   := 'S'
X_AC_ACRESC  := 'N'
X_LIM_CREDI  := 0.00 // N-12
X_SALDO      := 0.00 // N-12
X_TIPO_CLI   := space(01)
X_P_C_MENSAL := 0.00 // N-12
X_CODVEN     := space(02)
X_GUERRA     := space(15)
X_LOCENT     := space(60)
X_LOCCOB     := space(60)

X_END_PAG    := space(40)
X_CEP_PAG    := space(08)
X_BAIR_PAG   := space(20)
X_CIDA_PAG   := space(20)
X_ESTA_PAG   := space(02)

X_END_ENT    := space(40)
X_CEP_ENT    := space(08)
X_BAIR_ENT   := space(20)
X_CIDA_ENT   := space(20)
X_ESTA_ENT   := space(02)

X_NOME_TRAN  := space(30)
X_END_TRAN   := space(40)
X_TEL_TRAN   := space(15)
X_TEL2_TRAN   := space(09)
X_TEL3_TRAN   := space(09)
X_BAIR_TRAN  := space(20)
X_CIDA_TRAN  := space(20)
X_ESTA_TRAN  := space(02)
X_OBS1       := space(50)
X_OBS2       := space(50)
X_OBS3       := space(50)
X_OBS4       := space(50)
X_OBS5       := space(50)

return

/*
-----------------------------------------------------------------------------
                      Funcao ATRIBUI_11
-----------------------------------------------------------------------------
*/
procedure atribui_11()

   X_CODCLI     := VEN001->CODCLI

   X_TIPO_CLI   := VEN001->TIPO_CLI
   X_RAZAO      := VEN001->RAZAO
   X_CGC        := VEN001->CGC
   X_INSC_EST   := VEN001->INSC_EST
   X_ENDERECO   := VEN001->ENDERECO
   X_CEP        := VEN001->CEP
   X_BAIRRO     := VEN001->BAIRRO
   X_MUNICIPIO  := VEN001->MUNICIPIO
   X_ESTADO     := VEN001->ESTADO

   X_DDD01      := VEN001->DDD01
   X_TEL01      := VEN001->TEL01
   X_RAMAL01    := VEN001->RAMAL01
   X_CONT01     := VEN001->CONTATO01

   X_DDD02      := VEN001->DDD02
   X_TEL02      := VEN001->TEL02
   X_RAMAL02    := VEN001->RAMAL02
   X_CONT02     := VEN001->CONTATO02

   X_DDD03      := VEN001->DDD03
   X_TEL03      := VEN001->TEL03
   X_RAMAL03    := VEN001->RAMAL03
   X_CONT03     := VEN001->CONTATO03

   X_DDD04      := VEN001->DDD04
   X_TEL04      := VEN001->TEL04
   X_RAMAL04    := VEN001->RAMAL04
   X_CONT04     := VEN001->CONTATO04

   X_DDD05      := VEN001->DDD05
   X_TEL05      := VEN001->TEL05
   X_RAMAL05    := VEN001->RAMAL05
   X_CONT05     := VEN001->CONTATO05

   X_DDDFAX01   := VEN001->DDDFAX01
   X_FAX01      := VEN001->FAX01
   X_DDDFAX02   := VEN001->DDDFAX02
   X_FAX02      := VEN001->FAX02

   X_CODAREA    := VEN001->CODAREA
   X_COMPRADOR  := VEN001->COMPRADOR
   X_COMISSAO   := VEN001->COMISSAO
   X_AC_PERDA   := VEN001->AC_PERDA
   X_AC_ACRESC  := VEN001->AC_ACRESC
   X_LIM_CREDI  := VEN001->LIM_CREDI
   X_SALDO      := VEN001->SALDO
   X_P_C_MENSAL := VEN001->P_C_MENSAL
   X_CODVEN     := VEN001->CODVEN
   X_GUERRA     := VEN001->GUERRA

   X_END_ENT    := VEN001->END_ENT
   X_CEP_ENT    := VEN001->CEP_ENT
   X_BAIR_ENT   := VEN001->BAIR_ENT
   X_CIDA_ENT   := VEN001->CIDA_ENT
   X_ESTA_ENT   := VEN001->ESTA_ENT

   X_END_PAG    := VEN001->END_PAG
   X_CEP_PAG    := VEN001->CEP_PAG
   X_BAIR_PAG   := VEN001->BAIR_PAG
   X_CIDA_PAG   := VEN001->CIDA_PAG
   X_ESTA_PAG   := VEN001->ESTA_PAG

   X_NOME_TRAN  := VEN001->NOME_TRAN
   X_END_TRAN   := VEN001->END_TRAN
   X_TEL_TRAN   := VEN001->TEL_TRAN
   X_TEL2_TRAN  := VEN001->TEL2_TRAN
   X_TEL3_TRAN  := VEN001->TEL3_TRAN
   X_BAIR_TRAN  := VEN001->BAIR_TRAN
   X_CIDA_TRAN  := VEN001->CIDA_TRAN
   X_ESTA_TRAN  := VEN001->ESTA_TRAN

   X_OBS1       := VEN001->OBS1
   X_OBS2       := VEN001->OBS2
   X_OBS3       := VEN001->OBS3
   X_OBS4       := VEN001->OBS4
   X_OBS5       := VEN001->OBS5

return

/*
-----------------------------------------------------------------------------
                      Funcao GRAVA_11()
-----------------------------------------------------------------------------
*/
procedure GRAVA_11( MODO )

   if MODO = "I"
      VEN001->( dbappend() )
      VEN001->CODCLI     := X_CODCLI
   else
      while VEN001->( ! rlock() ); end
   end

   VEN001->CODCLI     := X_CODCLI
   VEN001->CGC        := X_CGC

   VEN001->GUERRA     := X_GUERRA
   VEN001->TIPO_CLI   := X_TIPO_CLI
   VEN001->RAZAO      := X_RAZAO
   VEN001->INSC_EST   := X_INSC_EST
   VEN001->ENDERECO   := X_ENDERECO
   VEN001->CEP        := X_CEP
   VEN001->BAIRRO     := X_BAIRRO
   VEN001->MUNICIPIO  := X_MUNICIPIO
   VEN001->ESTADO     := X_ESTADO
   VEN001->DDD01      := X_DDD01
   VEN001->TEL01      := X_TEL01
   VEN001->RAMAL01    := X_RAMAL01
   VEN001->CONTATO01  := X_CONT01
   VEN001->DDD02      := X_DDD02
   VEN001->TEL02      := X_TEL02
   VEN001->RAMAL02    := X_RAMAL02
   VEN001->CONTATO02  := X_CONT02

   VEN001->DDD03      := X_DDD03
   VEN001->TEL03      := X_TEL03
   VEN001->RAMAL03    := X_RAMAL03
   VEN001->CONTATO03  := X_CONT03

   VEN001->DDD04      := X_DDD04
   VEN001->TEL04      := X_TEL04
   VEN001->RAMAL04    := X_RAMAL04
   VEN001->CONTATO04  := X_CONT04

   VEN001->DDD05      := X_DDD05
   VEN001->TEL05      := X_TEL05
   VEN001->RAMAL05    := X_RAMAL05
   VEN001->CONTATO05  := X_CONT05

   VEN001->DDDFAX01   := X_DDDFAX01
   VEN001->FAX01      := X_FAX01
   VEN001->DDDFAX02   := X_DDDFAX02
   VEN001->FAX02      := X_FAX02

   VEN001->CODAREA    := X_CODAREA
   VEN001->COMPRADOR  := X_COMPRADOR
   VEN001->COMISSAO   := X_COMISSAO
   VEN001->AC_PERDA   := X_AC_PERDA
   VEN001->AC_ACRESC  := X_AC_ACRESC
   VEN001->LIM_CREDI  := X_LIM_CREDI
   VEN001->SALDO      := X_SALDO
   VEN001->P_C_MENSAL := X_P_C_MENSAL
   VEN001->CODVEN     := X_CODVEN

   VEN001->END_ENT    := X_END_ENT
   VEN001->CEP_ENT    := X_CEP_ENT
   VEN001->BAIR_ENT   := X_BAIR_ENT
   VEN001->CIDA_ENT   := X_CIDA_ENT
   VEN001->ESTA_ENT   := X_ESTA_ENT

   VEN001->END_PAG    := X_END_PAG
   VEN001->CEP_PAG    := X_CEP_PAG
   VEN001->BAIR_PAG   := X_BAIR_PAG
   VEN001->CIDA_PAG   := X_CIDA_PAG
   VEN001->ESTA_PAG   := X_ESTA_PAG

   VEN001->NOME_TRAN  := X_NOME_TRAN
   VEN001->END_TRAN   := X_END_TRAN
   VEN001->TEL_TRAN   := X_TEL_TRAN
   VEN001->TEL2_TRAN  := X_TEL2_TRAN
   VEN001->TEL3_TRAN  := X_TEL3_TRAN
   VEN001->BAIR_TRAN  := X_BAIR_TRAN
   VEN001->CIDA_TRAN  := X_CIDA_TRAN
   VEN001->ESTA_TRAN  := X_ESTA_TRAN

   VEN001->OBS1       := X_OBS1
   VEN001->OBS2       := X_OBS2
   VEN001->OBS3       := X_OBS3
   VEN001->OBS4       := X_OBS4
   VEN001->OBS5       := X_OBS5

return

* ----------> Fim do meu programa


/*
-----------------------------------------------------------------------------
                      Funcao LGETCOBRANCA
-----------------------------------------------------------------------------
*/

function lgetcobranca( P_ACAO )

local WSCRCOB := savescreen(,,,,), WRET := .T.

@ 12,15 say 'ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´                 ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿'
@ 13,15 say '³ Endere‡o :                                          ³'
@ 14,15 say '³ C.E.P. ..:                                          ³'
@ 15,15 say '³ Bairro ..:                                          ³'
@ 16,15 say '³ Cidade ..:                                          ³'
@ 17,15 say '³ Estado ..:                                          ³'
@ 18,15 say 'ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ'

@ 12,30 say ' Local Cobran‡a  '

@ 13,28 get X_END_PAG  picture "@!"
@ 14,28 get X_CEP_PAG  picture "@R 99999-999"
@ 15,28 get X_BAIR_PAG picture "@!"
@ 16,28 get X_CIDA_PAG picture "@!"
@ 17,28 get X_ESTA_PAG picture "@!"

if P_ACAO = "GET"
   read
else
   clear gets
   inkey(0)
end

if lastkey()=K_ESC
   WRET := .F.
end

restscreen(,,,,WSCRCOB )

return WRET


/*
-----------------------------------------------------------------------------
                      Funcao LGETENTREGA
-----------------------------------------------------------------------------
*/
function lgetentrega( P_ACAO )

local WSCRENT := savescreen(,,,,), WRET := .T.

@ 12,15 say 'ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´                 ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿'
@ 13,15 say '³ Endere‡o :                                          ³'
@ 14,15 say '³ C.E.P. ..:                                          ³'
@ 15,15 say '³ Bairro ..:                                          ³'
@ 16,15 say '³ Cidade ..:                                          ³'
@ 17,15 say '³ Estado ..:                                          ³'
@ 18,15 say 'ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ'

@ 12,30 say ' Local Entrega   '

@ 13,28 get X_END_ENT  picture "@!"
@ 14,28 get X_CEP_ENT  picture "@R 99999-999"
@ 15,28 get X_BAIR_ENT picture "@!"
@ 16,28 get X_CIDA_ENT picture "@!"
@ 17,28 get X_ESTA_ENT picture "@!"
if P_ACAO = "GET"
   read
else
   clear gets
   inkey(0)
end

if lastkey()=K_ESC
   WRET := .F.
end

restscreen(,,,,WSCRENT )

return WRET


/*
-----------------------------------------------------------------------------
                      Funcao LGETTRANSPORTADORA
-----------------------------------------------------------------------------
*/
function lgettransportadora( P_ACAO )

local WSCRTRA := savescreen(,,,,), WRET := .T.

@ 12,15 say 'ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´                 ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿'
@ 13,15 say '³ Nome ....:                                          ³'
@ 14,15 say '³ Endere‡o :                                          ³'
@ 15,15 say '³ Telefone :                                          ³'
@ 16,15 say '³ Bairro ..:                                          ³'
@ 17,15 say '³ Cidade ..:                                          ³'
@ 18,15 say '³ Estado ..:                                          ³'
@ 19,15 say 'ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ'

@ 12,30 say ' Transportadora '

@ 13,28 get X_NOME_TRAN picture "@!"
@ 14,28 get X_END_TRAN  picture "@!"
@ 15,28 get X_TEL_TRAN  picture "@!"
@ 15,COL()+3 get X_TEL2_TRAN  picture "@!"
@ 15,COL()+3 get X_TEL3_TRAN  picture "@!"
@ 16,28 get X_BAIR_TRAN picture "@!"
@ 17,28 get X_CIDA_TRAN picture "@!"
@ 18,28 get X_ESTA_TRAN picture "@!"
if P_ACAO = "GET"
   read
else
   clear gets
   inkey(0)
end

if lastkey()=K_ESC
   WRET := .F.
end

restscreen(,,,,WSCRTRA)

return WRET


/*
-----------------------------------------------------------------------------
                      Funcao LGETCREDITO
-----------------------------------------------------------------------------
*/
function lgetcredito( P_ACAO )

local WSCRTRA := savescreen(,,,,), WRET := .T.

@ 12,15 say 'ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´                 ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿'
@ 13,15 say '³ Comiss„o .......:     %                             ³'
@ 14,15 say '³ Perda (S/N) ....:                                   ³'
@ 15,15 say '³ Acrescimo (S/N) :                                   ³'
@ 16,15 say '³ Limite Credito .:                                   ³'
@ 17,15 say '³ Saldo ..........:                                   ³'
@ 18,15 say 'ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ'

@ 12,30 say ' Credito '

@ 13,35 get X_COMISSAO     picture "9999"
@ 14,35 get X_AC_PERDA     picture "!"  valid X_AC_PERDA $ "SN "
@ 15,35 get X_AC_ACRESC    picture "!"  valid X_AC_ACRESC $ "SN "
@ 16,35 get X_LIM_CREDI    picture "999,999,999.99"
@ 17,35 get X_SALDO        picture "999,999,999.99"

if P_ACAO = "GET"
   read
else
   clear gets
   inkey(0)
end

if lastkey()=K_ESC
   WRET := .F.
end

restscreen(,,,,WSCRTRA)

return WRET

/*
-----------------------------------------------------------------------------
                      Funcao LGETOBS
-----------------------------------------------------------------------------
*/
function lgetobs    ( P_ACAO )

local WSCRTRA := savescreen(,,,,), WRET := .T.

@ 12,15 say 'ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´ Observacao ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿'
@ 13,15 say '³                                                       ³'
@ 14,15 say '³                                                       ³'
@ 15,15 say '³                                                       ³'
@ 16,15 say '³                                                       ³'
@ 17,15 say '³                                                       ³'
@ 18,15 say '³                                                       ³'
@ 19,15 say '³                                                       ³'
@ 20,15 say 'ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ'

@ 14,17 get X_OBS1         picture "@!"
@ 15,17 get X_OBS2         picture "@!"
@ 16,17 get X_OBS3         picture "@!"
@ 17,17 get X_OBS4         picture "@!"
@ 18,17 get X_OBS5         picture "@!"

if P_ACAO = "GET"
   read
else
   clear gets
   inkey(0)
end

if lastkey()=K_ESC
   WRET := .F.
end

restscreen(,,,,WSCRTRA)

return WRET



