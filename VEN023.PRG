/*
   SCM - Sistema de Controle Metalurgico
   VEN023.PRG - Cadastro de Fornecedores

*/

#include "inkey.ch"

FUNCTION fornece023(PED)

private pedido := if(ped=nil,.f.,.t.)
private W_PRECO := 0.00,p1 := 1

if PEDIDO
  VEN023->(dbsetorder(2))
  VEN023->(dbseek( VEN006->PEDVEN+STR(VEN006->SEQUENC,3)))
else
 VEN023->(dbsetorder(1))
 VEN023->(dbseek( VEN004->CONSULTA+STR(VEN004->SEQUENC,3)))
end

private w_t023 := savescreen()

private X_FORNECEDOR,;  
        X_TELEFONE  ,;
        X_DDD       ,;
        X_DATA      ,;
        X_PESO      ,;
        X_PRECO_UNI ,;      
        X_UNIDADE   ,;
        X_IPI       ,;      
        X_ICMS      ,;      
        X_FRETE     ,;     
        X_CUSTO         

// --> Inicio

setcolor(W_COREDIT)

While .T.

   status(' F o r n e c e d o r ')

   tela023()
   atrib023()

   if pedido
      say023()
      inkey(0)
      exit
   else
      if get023()
         if pergunta('Confirma Dados ? ')
            grava023()
            exit
         end
      else
         exit
      end
   end
end

if pedido  
   sele VEN006
else
   sele VEN004
end

setcolor(W_CORGET)
restscreen(,,,,w_t023)

RETURN

// --> Fim


/*
-----------------------------------------------------------------------------
                      Funcao GET023
-----------------------------------------------------------------------------
*/
function GET023()
   local WRET := .T.
   setcolor(W_COREDIT)   

   @ 04,63 SAY X_DDD        picture "@!"
   @ 04,68 SAY X_TELEFONE   picture "@!"
   @ 04,21 get X_FORNECEDOR picture "@!" valid tes_forn( X_FORNECEDOR,4)
   @ 04,63 get X_DDD        picture "@!"
   @ 04,68 get X_TELEFONE   picture "@!"
   @ 05,21 get X_COMPRADOR  picture "@!"
   @ 05,62 get X_DATA       picture "99/99/99"
   @ 07,21 get X_PRECO_UNI  picture "99999.99"
   @ 07,46 get X_PESO       picture "99999.99"
   @ 07,70 get X_UNIDADE    picture "@!"     valid tes_unidade(X_UNIDADE)
   @ 09,21 get X_IPI        picture "9999.99"
   @ 11,21 get X_ICMS       picture "9999.99"
   @ 13,21 say X_FRETE      picture "9999999.99"
   @ 15,21 SAY X_CUSTO        picture "9999999.99"
   read

   if lastkey() = K_ESC
      if pergunta('Abandona ? ')
         WRET := .F.
      else
         WRET := .T.
      end
   else
       setcolor(W_COREDIT)
       sele ven024
       locate for ven024->peso_max >= X_PESO
       if X_PESO >400
         X_FRETE := VEN024->VALOR
       else
         X_FRETE := VEN024->VALOR/X_PESO
       end
       @ 13,21 get X_FRETE      picture "9999999.99"
       read
       X_CUSTO := W_PRECO*(1+(X_IPI/100) +(18.667-X_ICMS)/100)+X_FRETE
       @ 13,21 SAY X_FRETE      picture "9999999.99"
       @ 15,21 SAY X_CUSTO      picture "9999999.99"
    end
return WRET

/*
-----------------------------------------------------------------------------
                      Funcao zera023
-----------------------------------------------------------------------------
*/

function SAY023()
   setcolor(W_COREDIT)   
   tes_forn( X_FORNECEDOR,4)
   @ 04,25 say left( EST002->FGUERRA, 24 )  picture '@!'
   @ 04,21 say X_FORNECEDOR picture "@!"
   @ 04,62 say X_DDD        picture "@!"
   @ 04,67 say X_TELEFONE   picture "@!"
   @ 05,21 say X_COMPRADOR  picture "@!"
   @ 05,62 say X_DATA       picture "99/99/99"
   @ 07,21 say X_PRECO_UNI  picture "99999.99"
   @ 07,46 say X_PESO       picture "99999.99"
   @ 07,70 say X_UNIDADE    picture "@!"
   @ 09,21 say X_IPI        picture "9999.99"
   @ 11,21 say X_ICMS       picture "9999.99"
   @ 13,21 SAY X_FRETE      picture "9999999.99"  
   @ 15,21 SAY X_CUSTO      picture "9999999.99"

return (.t.)

procedure atrib023()

X_FORNECEDOR := VEN023->FORNECEDOR 
X_COMPRADOR  := VEN023->COMPRADO

X_PRECO_UNI  := VEN023->PRECO_UNI
X_DATA       := DATE()
if pedido  
  X_IPI        := VEN023->IPI     
  X_ICMS       := VEN023->ICMS
  X_DATA       := VEN023->DATA
  X_TELEFONE   := VEN023->TELEFONE
  X_PESO       := VEN023->PESO
  X_UNIDADE    := VEN023->UNIDADE
else
  X_IPI        := 5     
  X_ICMS       := 12
  X_PESO       := VEN004->PESO_ITEM
  X_UNIDADE    := 'K'
end  

X_FRETE      := VEN023->FRETE    
X_CUSTO      := VEN023->CUSTO   

return


procedure grava023()
while VEN023->(!RLOCK()); LOOP ; END
IF VEN023->(!dbseek(VEN004->CONSULTA+STR(VEN004->SEQUENC,3)))
  VEN023->(DBAPPEND())
END
VEN023->FORNECEDOR := X_FORNECEDOR  
VEN023->TELEFONE   := X_TELEFONE    
VEN023->DDD        := X_DDD
VEN023->COMPRADO   := X_COMPRADOR
VEN023->DATA       := X_DATA       
VEN023->PRECO_UNI  := X_PRECO_UNI   
VEN023->UNIDADE    := X_UNIDADE     
VEN023->IPI        := X_IPI         
VEN023->ICMS       := X_ICMS        
VEN023->FRETE      := X_FRETE       
VEN023->CUSTO      := X_CUSTO       
VEN023->PESO       := X_PESO        
VEN023->CONSULTA   := VEN004->CONSULTA
VEN023->SEQUENC    := VEN004->SEQUENC
VEN023->( dbunlock() )
RETURN

function tes_unidade()
local wret := .f.
X_FORMA      := VEN006->FORMA
X_SUBFORMA   := VEN006->SUBFORMA
X_COMPRIM    := VEN006->COMPRIM
X_LARGURA    := VEN006->LARGURA
X_ESPESSURA  := VEN006->ESPESSURA
W_PESOMTR    := VEN006->PES_MATNOT
X_ESTADO     := VEN006->ESTADO
X_BIT_MM     := VEN006->BIT_MM
X_ESP_MM     := VEN006->ESP_MM

W_CHAVE_ITEM := ( X_FORMA+ X_TIPO+ ;
	     str( X_BIT_MM, 8, 3 ) + str( X_ESP_MM, 8, 3 ) + X_ESTADO )
W_PESOPECA   := 0.00
EST003->( dbseek( X_FORMA ) )
X_P_CORTE    := EST003->P_CORTE
EST007->(dbseek(W_CHAVE_ITEM))
if X_P_CORTE = 5 // Chapa
  do case
    case X_SUBFORMA = 'R'
        W_PESOPECA := ( ( (X_COMPRIM+5)*(X_LARGURA+5))/1000000 ) * W_PESOMTR

    case X_SUBFORMA = 'D'
        W_PESOPECA := (( (X_LARGURA+5)^2)/1000000 ) * W_PESOMTR

    case X_SUBFORMA = 'A'
        W_PESOPECA := (( (X_LARGURA+5)^2)/1000000 ) * W_PESOMTR

    case X_SUBFORMA = 'M'
        W_PESOPECA := 1

  endcase
 else
  if X_P_CORTE = 4 // COM/LAR/ESP
    W_PESOPECA := ( (X_COMPRIM*X_ESPESSURA*X_LARGURA*8)/1000000 )
  else
    W_PESOPECA := ( (X_COMPRIM/1000) * W_PESOMTR) + EST007->PER_COR
  end
end
if W_PESOPECA >= 10
  if W_PESOPECA <> int(W_PESOPECA)
    W_PESOPECA := int(W_PESOPECA) + 1
  end
else
  L_FRACAO := W_PESOPECA - int( W_PESOPECA )
  if L_FRACAO < 0.5
    W_PESOPECA := int( W_PESOPECA )+ 0.5
  else
    if L_FRACAO > 0.5
      W_PESOPECA := int( W_PESOPECA )+ 1
    end
  end
 end
 X_PESO_ITEM := W_PESOPECA * X_QTD_PECAS

 if p1 = 1
   W_PRECO := X_PRECO_UNI
   p1 = 2
  end
 if X_UNIDADE $ "KMP"
   do case
     case X_UNIDADE = 'K'
         X_PRECO_UNI := W_PRECO

      case X_UNIDADE = 'P'
          X_PRECO_UNI := W_PRECO * W_PESOPECA

    case X_UNIDADE = 'M'
       X_PRECO_UNI :=  W_PRECO * W_PESOMTR
  endcase
 wret := .t.
 @ 07,21 say X_PRECO_UNI  picture "99999.99"
end
return (wret)


/*
-----------------------------------------------------------------------------
                             Procedimento Tela
-----------------------------------------------------------------------------
*/
procedure tela023()
   @ 03,02 say 'ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿'
   @ 04,02 say '³  Fornecedor....:                                Telefone: (    )-        ³'
   @ 05,02 say '³  Comprado com..:                                Data....:                ³'
   @ 06,02 say '³                                                                          ³'
   @ 07,02 say '³  Preco Unitario:                    Peso:               Unidade.:        ³'
   @ 08,02 say '³                                                                          ³'
   @ 09,02 say '³  IPI(%)........:                                                         ³'
   @ 10,02 say '³                                                                          ³'
   @ 11,02 say '³  ICMS(%).......:                                                         ³'
   @ 12,02 say '³                                                                          ³'
   @ 13,02 say '³  Frete.........:                                                         ³'
   @ 14,02 say '³                                                                          ³'
   @ 15,02 say '³  Custo.........:                                                         ³'
   @ 16,02 say '³                                                                          ³'
   @ 17,02 say 'ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ'
return
