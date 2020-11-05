/*
   DAF - Demonstrativo de Aplicacao Financeira
   DAF76.PRG - Atualizacao de Valores
   Mauricio -  2:59pm Apr 05,1993
*/

use daf003 index daf00301 new           //  Feriados
use daf004 index daf00401 new           //  Investimentos
use daf009 index daf00901 new           //  Cotas
use daf001 index daf00101 new           //  Bancos
use daf011 index daf01101 new           //  Taxas Diarias
use daf006 index daf00601,daf00602,daf00603,daf00604,daf00605,daf00606 new // Aplicacao
set relation to cod_invest           into daf004,;
                cod_banco+cod_invest into daf009,;
                cod_banco            into daf001

cls(5,22,c_padrao)
status('Atualizacao de Valores')

atext1 :='Confirma Atualizacao dos Valores!'
opcdsk :={"Nao","Sim"}
// ?? chr(7)
opcdsk:=wbox("C","C",,atext1,opcdsk,"ÕÍ¸³¾ÍÔ³ ")
if opcdsk==1 .or. lastkey()==27
   dbcloseall() ; return
endif
winv:=" "
cota:=.f.
while !eof()
   if winv!=cod_invest
      winv:=cod_invest
      cota:=if(daf004->taxa_cota=='T',.f.,.t.)
   end
   if cota
      wvalor:=qtd_cotas*daf009->valor_cota
   else
      wvalor:=valor_inic
      wndias:=date()-data_inic
      if wndias>dias
         wndias:=dias
      end
      if daf004->txdiamuda=='S'
         daf011->(dbseek(daf006->(cod_fed+cod_invest+cod_banco+seq)))
         watu:=.f.
         while daf011->(cod_fed+cod_invest+cod_banco+seq)==daf006->(cod_fed+cod_invest+cod_banco+seq)
            wvalor+=(wvalor*daf011->tx_diaria/100)
            if daf011->data_tx==date()
               watu:=.t.
               exit
            end
            daf011->(dbskip())
         enddo
         if !watu
            watu:={'Taxa diaria da aplicacao abaixo nao foi atualizada hoje!!',;
                   '- Federacao: '+if(daf006->cod_fed=='1','FS','FF'),;
                   '- Banco: '+daf001->descricao,;
                   '- Investimento: '+daf004->descricao,;
                   '- Data Aplicacao: '+dtoc(daf006->data_inic)}
            message(watu)
         end
      else
         for x:=1 to wndias
            if daf004->dias_uteis=="S"
               if duteis(x)
                  loop
               end
            end
            wvalor+=(wvalor*tx_diaria/100)
         next
      end
   end
   repl saldo_atua with wvalor
   dbskip()
enddo

dbcloseall()
return

/* =-=-=-=-=-=-=-=-=-=-= */
Static Function duteis(x)
Local dt
dt:=data_inic+x
if str(dow(dt),1)$'17' .or. daf003->(dbseek(dtos(dt)))
   return .t.
end
return .f.
