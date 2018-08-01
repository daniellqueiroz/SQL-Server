--select count(*) from dbo.Endereco


/*

truncate table dbo.Cliente
truncate table dbo.ClienteEndereco
truncate table dbo.ClienteFormaPagamento
truncate table [dbo].[ClienteCampoClienteValor]
truncate table [dbo].[ClienteFrete]
truncate table [dbo].[ClienteFreteEntrega]
truncate table [dbo].[ClienteFreteEntregaPeriodo]
truncate table [dbo].[ClienteFreteEntregaProduto]
truncate table [dbo].[ClienteFreteProduto]


if object_id('Log') is not null
TRUNCATE TABLE dbo.Log
if object_id('IntegracaoInterfaceLogErro') is not null
TRUNCATE TABLE dbo.IntegracaoInterfaceLogErro
if object_id('Email') is not null
TRUNCATE TABLE dbo.Email
if object_id('compraentregastatuslog') is not null
truncate table compraentregastatuslog
if object_id('LegadoCompraTracking') is not null
truncate table LegadoCompraTracking
if object_id('CompraFormaPagamentoLog') is not null
truncate table CompraFormaPagamentoLog
if object_id('Site_Tracking') is not null
truncate table Site_Tracking
if object_id('clienteoptout') is not null
truncate table clienteoptout
if object_id('LegadoCompraEnderecoEntrega') is not null
truncate table LegadoCompraEnderecoEntrega
if object_id('CompraPagamentoLog') is not null
truncate table CompraPagamentoLog
if object_id('LegadoCompraEntregaSku') is not null
truncate table LegadoCompraEntregaSku
if object_id('LegadoCompraFormaPagamento') is not null
truncate table LegadoCompraFormaPagamento
if object_id('clienteia') is not null
truncate table clienteia
TRUNCATE TABLE dbo.Carrinho
truncate table dbo.CarrinhoFormaPagamento
truncate table dbo.CarrinhoGarantiaAvulsa
truncate table dbo.CarrinhoProdutoCustomizado
truncate table dbo.CarrinhoSku
truncate table dbo.CarrinhoSkuServico
truncate table Compra
truncate table CompraFormaPagamento
truncate table CompraEntrega
truncate table ClienteFormaPagamento
truncate table CompraEnderecoEntrega
truncate table CompraEntregaSku

truncate table ListaCasamento
truncate table ListaCasamentoConsolidado
truncate table ListaCasamentoConvidado
truncate table ListaCasamentoDivulgacao
truncate table ListaCasamentoItemComprado
truncate table ListaCasamentoMensagem
truncate table ListaDeCompra
truncate table ListaDeCompraClienteEndereco
truncate table ListaDeCompraEvento
truncate table ListaDeCompraItem
truncate table ListaSugestiva


*/

