use VEN001  new
use VEN002  new
use VEN003  new
use VEN004  new
use VEN005  new
use VEN006  new
use VEN007  new
use VEN008  new
use VEN009  new
use VEN010  new
use VEN011  new
use VEN012  new
use VEN013  new
use VEN014  new
use VEN015  new
use VEN016  new
use VEN017  new
use VEN018  new
use VEN019  new
use VEN020  new
use VEN021  new
use VEN099  new

use EST000  new
use EST001  new
use EST002  new
use EST003  new
use EST004  new
use EST005  new
use EST006  new
use EST007  new
use EST008  new
use EST009  new
use EST010  new
use EST011  new
use EST031  new

index on
index on
/*
testaind(.t.,'est000','est00001','acesso',ind_ + 'Senha')
testaind(.t.,'est001','est00101','almoxari',ind_ + 'Arquivo de Almoxarifados')
testaind(.t.,'est002','est00201','fornecedor',ind_ + 'Arquivo de Fornecedores ')
testaind(.t.,'est002','est00202','fguerra',ind_ + 'Arquivo de Fornecedores (2) ')
testaind(.t.,'est003','est00301','forma',ind_ + 'Arquivo de Forma de Material')
testaind(.t.,'est004','est00401','forma+tipo',ind_ + 'Arquivo de Tipo de Material')
testaind(.t.,'est004','est00402','tipo+forma',ind_ + 'Arquivo de Tipo de Material')
testaind(.t.,'est004','est00403','forma+tipo+estado',ind_ + 'Arquivo de Tipo de Material (3)')
testaind(.t.,'est005','est00501','pedido+fornecedor',ind_ + 'Arquivo de Pedidos')
testaind(.t.,'est005','est00502','fornecedor+pedido',ind_ + 'Arquivo de Pedidos (2)')
testaind(.t.,'est006','est00601','pedido',ind_ + 'Arquivo de Pedidos')
testaind(.t.,'est006','est00602','pedido+str(sequenc,3,0)',ind_ + 'Arquivo de Pedidos')
testaind(.t.,'est006','est00603','pedido+forma+tipo+str(bit_mm,8,3)+str(esp_mm,8,3)+estado',ind_ + 'Arquivo de Pedidos')
testaind(.t.,'est007','est00701','forma+tipo+str(bit_mm,8,3)+str(esp_mm,8,3)+estado',ind_ + 'Arquivo de Material')
testaind(.t.,'est007','est00702','forma+tipo+estado+bit_int+bit_fn+bit_fd+esp_int+esp_fn+esp_fd',ind_ + 'Arquivo de Itens de Estoque(2)')
testaind(.t.,'est008','est00801','forma+tipo+str(bit_mm,8,3)+str(esp_mm,8,3)+estado',ind_ + 'Arquivo de Peca Cortada')
testaind(.t.,'est008','est00802','forma+tipo+str(bit_mm,8,3)+str(esp_mm,8,3)+estado+str(sequenc,5)',ind_ + 'Arquivo de Peca Cortada')
testaind(.t.,'est008','est00803','comprim',ind_ + 'Arquivo de Peca Cortada')
testaind(.t.,'est009','est00901','lote',ind_ + 'Arquivo de Lote')
testaind(.t.,'est010','est01001','forma+tipo+str(bit_mm,8,3)+str(esp_mm,8,3)+estado',ind_ + 'Arquivo de Movimentacao')
testaind(.t.,'est010','est01002','forma+tipo+estado+str(bit_mm,8,3)+str(esp_mm,8,3)+dtos(datamovi)',ind_ + 'Arquivo de Movimentacao (2)')
testaind(.t.,'est011','est01101','tipomovi',ind_ + 'Arquivo de Tipo de Movimentacao')
testaind(.t.,'est031','est03101','lote',ind_ + 'Arquivo de Lote (1)')
testaind(.t.,'est031','est03102','forma+tipo+str(bit_mm,8,3)+str(esp_mm,8,3)+estado+lote',ind_ + 'Arquivo de Lote (2)')
*/
index on forma+tipo+str(bit_mm,8,3)+str(esp_mm,8,3)+estado+descend(lote) to est03103
/*
testaind(.t.,'ven001','ven00101','codcli',ind_  + 'Arquivo de Clientes')
testaind(.t.,'ven001','ven00102','razao',ind_  + 'Arquivo de Clientes')
testaind(.t.,'ven002','ven00201','codven',ind_ + 'Arquivo de Vendedor')
testaind(.t.,'ven003','ven00301','consulta',ind_  + 'Arquivo de Consultas')
testaind(.t.,'ven003','ven00302','codcli+comprador+dtos(dt_cons)',ind_  + 'Arquivo de Consultas')
testaind(.t.,'ven003','ven00303','codcli+consulta',ind_  + 'Arquivo de Consultas')
testaind(.t.,'ven004','ven00401','consulta+str(sequenc,3)',ind_ + 'Arquivo de Item de Consultas')
testaind(.t.,'ven004','ven00402','usuario',ind_ + 'Arquivo de Item de Consultas')
testaind(.t.,'ven005','ven00501','pedven+codcli',ind_ + 'Arquivo de Pedidos')
testaind(.t.,'ven006','ven00601','pedven+str(sequenc,3)+forma+tipo+str(bit_mm,8,3)+str(esp_mm,8,3)+estado',ind_ + 'Arquivo de Item de Pedidos')
testaind(.t.,'ven006','ven00602','notafiscal',ind_ + 'Arquivo de Pedidos')
testaind(.t.,'ven006','ven00603','usuario+notafiscal',ind_ + 'Arquivo de Pedidos')
testaind(.t.,'ven006','ven00604','separacao',ind_ + 'Arquivo de Pedidos')
testaind(.t.,'ven008','ven00801','codven+pedven',ind_ + 'Arquivo de Comissao de Vendedor')
testaind(.t.,'ven009','ven00901','codven',ind_ + 'Arquivo de Pagamento de Vendedor')
testaind(.t.,'ven010','ven01001','codcli+pedven',ind_ + 'Arquivo de Comissao de Comprador')
testaind(.t.,'ven011','ven01101','codcli',ind_ + 'Arquivo de Pagamento de Comprador')
testaind(.t.,'ven012','ven01201','notafiscal',ind_ + 'Arquivo de Nota Fiscal')
testaind(.t.,'ven014','ven01401','grupo+str(descmax,8,2)',ind_ + 'Arquivo de Comissoes de Venda')
testaind(.t.,'ven015','ven01501','grupo',ind_ + 'Arquivo de Grupos')
testaind(.t.,'ven016','ven01601','separacao',ind_ + 'Arquivo Header Separacao')
testaind(.t.,'ven016','ven01602','pedven',ind_ + 'Arquivo Header Separacao')

testaind(.t.,'ven017','ven01701','grupo',ind_ + 'Arquivo Grupos')
testaind(.t.,'ven018','ven01801','grupo+subgrupo',ind_ + 'Arquivo de SubGrupos')
testaind(.t.,'ven019','ven01901','grupo+subgrupo+coluna',ind_ + 'Arquivo de Precos')
testaind(.t.,'ven020','ven02001','grupo+subfator+str(medidafim,8,3)',ind_ + 'Arquivo de SubFatores')
*/
verindex()

