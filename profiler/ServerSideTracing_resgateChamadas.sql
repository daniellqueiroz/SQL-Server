/****************************************************/
/* Created by: SQL Server 2008 Profiler             */
/* Date: 04/26/2012  02:39:29 PM         */
/****************************************************/


-- Create a Queue
declare @rc int
declare @TraceID int
declare @maxfilesize bigint
set @maxfilesize = 50

-- Please replace the text InsertFileNameHere, with an appropriate
-- filename prefixed by a path, e.g., c:\MyFolder\MyTrace. The .trc extension
-- will be appended to the filename automatically. If you are writing from
-- remote server to local drive, please use UNC path and make sure server has
-- write access to your network share

exec @rc = sp_trace_create @TraceID output, 0, N'd:\MyTrace', @maxfilesize, NULL 
if (@rc != 0) goto error

-- Client side File and Table cannot be scripted

-- Set the events
declare @on bit
set @on = 1
exec sp_trace_setevent @TraceID, 10, 15, @on
exec sp_trace_setevent @TraceID, 10, 8, @on
exec sp_trace_setevent @TraceID, 10, 16, @on
exec sp_trace_setevent @TraceID, 10, 1, @on
exec sp_trace_setevent @TraceID, 10, 9, @on
exec sp_trace_setevent @TraceID, 10, 17, @on
exec sp_trace_setevent @TraceID, 10, 2, @on
exec sp_trace_setevent @TraceID, 10, 10, @on
exec sp_trace_setevent @TraceID, 10, 18, @on
exec sp_trace_setevent @TraceID, 10, 26, @on
exec sp_trace_setevent @TraceID, 10, 34, @on
exec sp_trace_setevent @TraceID, 10, 11, @on
exec sp_trace_setevent @TraceID, 10, 35, @on
exec sp_trace_setevent @TraceID, 10, 12, @on
exec sp_trace_setevent @TraceID, 10, 13, @on
exec sp_trace_setevent @TraceID, 10, 6, @on
exec sp_trace_setevent @TraceID, 10, 14, @on
exec sp_trace_setevent @TraceID, 12, 15, @on
exec sp_trace_setevent @TraceID, 12, 8, @on
exec sp_trace_setevent @TraceID, 12, 16, @on
exec sp_trace_setevent @TraceID, 12, 1, @on
exec sp_trace_setevent @TraceID, 12, 9, @on
exec sp_trace_setevent @TraceID, 12, 17, @on
exec sp_trace_setevent @TraceID, 12, 6, @on
exec sp_trace_setevent @TraceID, 12, 10, @on
exec sp_trace_setevent @TraceID, 12, 14, @on
exec sp_trace_setevent @TraceID, 12, 18, @on
exec sp_trace_setevent @TraceID, 12, 26, @on
exec sp_trace_setevent @TraceID, 12, 11, @on
exec sp_trace_setevent @TraceID, 12, 35, @on
exec sp_trace_setevent @TraceID, 12, 12, @on
exec sp_trace_setevent @TraceID, 12, 13, @on


-- Set the Filters
declare @intfilter int
declare @bigintfilter bigint

exec sp_trace_setfilter @TraceID, 1, 1, 6, N'%ArquivoLojaListar.sql%'
exec sp_trace_setfilter @TraceID, 1, 1, 6, N'%CampoValorListar%'
exec sp_trace_setfilter @TraceID, 1, 1, 6, N'%CategoriaListar%'
exec sp_trace_setfilter @TraceID, 1, 1, 6, N'%ClienteFormaPagamentoListar%'
exec sp_trace_setfilter @TraceID, 1, 1, 6, N'%ClusterCarrinhoListar%'
exec sp_trace_setfilter @TraceID, 1, 1, 6, N'%ClusterListar%'
exec sp_trace_setfilter @TraceID, 1, 1, 6, N'%ColecaoParametroProdutoListar%'
exec sp_trace_setfilter @TraceID, 1, 1, 6, N'%DescontoListarComFormaPagamento%'
exec sp_trace_setfilter @TraceID, 1, 1, 6, N'%EmailTipoListar%'
exec sp_trace_setfilter @TraceID, 1, 1, 6, N'%FaixaPrecoListar%'
exec sp_trace_setfilter @TraceID, 1, 1, 6, N'%FaixaValorListaListar%'
exec sp_trace_setfilter @TraceID, 1, 1, 6, N'%FaixaValorListaObter%'
exec sp_trace_setfilter @TraceID, 1, 1, 6, N'%LayoutListar%'
exec sp_trace_setfilter @TraceID, 1, 1, 6, N'%ListaCasamentoListar%'
exec sp_trace_setfilter @TraceID, 1, 1, 6, N'%ListaDeCompraClienteEnderecoListar%'
exec sp_trace_setfilter @TraceID, 1, 1, 6, N'%ListaDeCompraClienteEnderecoObter%'
exec sp_trace_setfilter @TraceID, 1, 1, 6, N'%ListarCompreJuntoSkuLista1PorIdSku%'
exec sp_trace_setfilter @TraceID, 1, 1, 6, N'%ListarCompreJuntoSkuLista2PorIdDescontoCompreJunto%'
exec sp_trace_setfilter @TraceID, 1, 1, 6, N'%NewsletterListar%'
exec sp_trace_setfilter @TraceID, 1, 1, 6, N'%PaginaListar%'
exec sp_trace_setfilter @TraceID, 1, 1, 6, N'%QuantidadePresenteLista%'
exec sp_trace_setfilter @TraceID, 1, 1, 6, N'%SkuCampoValorListar%'
exec sp_trace_setfilter @TraceID, 1, 1, 6, N'%spCategoriaListarUrl%'
exec sp_trace_setfilter @TraceID, 1, 1, 6, N'%spCompraEntregaSkuListar%'
exec sp_trace_setfilter @TraceID, 1, 1, 6, N'%spFormaPagamentoParcelamentoListar%'
exec sp_trace_setfilter @TraceID, 1, 1, 6, N'%spListaDeCompraListar%'
exec sp_trace_setfilter @TraceID, 1, 1, 6, N'%UrlDeParaListar%'
exec sp_trace_setfilter @TraceID, 1, 1, 6, N'%ArquivoObter%'
exec sp_trace_setfilter @TraceID, 1, 1, 6, N'%BannerObter%'
exec sp_trace_setfilter @TraceID, 1, 1, 6, N'%ClienteFormaPagamentoObter%'
exec sp_trace_setfilter @TraceID, 1, 1, 6, N'%ClusterObter%'
exec sp_trace_setfilter @TraceID, 1, 1, 6, N'%ControleObter%'
exec sp_trace_setfilter @TraceID, 1, 1, 6, N'%DescontoCompreJuntoObter%'
exec sp_trace_setfilter @TraceID, 1, 1, 6, N'%FaixaValorListaObter%'
exec sp_trace_setfilter @TraceID, 1, 1, 6, N'%ListaDeCompraClienteEnderecoObter%'
exec sp_trace_setfilter @TraceID, 1, 1, 6, N'%NewsletterObter%'
exec sp_trace_setfilter @TraceID, 1, 1, 6, N'%SkuCampoValorObter%'
exec sp_trace_setfilter @TraceID, 1, 1, 6, N'%spCategoriaObterPorNome%'
exec sp_trace_setfilter @TraceID, 1, 1, 6, N'%spObterSkuTabelaValorVigente%'
exec sp_trace_setfilter @TraceID, 1, 1, 6, N'%UrlDeParaObter%'
exec sp_trace_setfilter @TraceID, 10, 0, 7, N'SQL Server Profiler%'
exec sp_trace_setfilter @TraceID, 8, 0, 7, N'Valencia01'
exec sp_trace_setfilter @TraceID, 35, 0, 7, N'tempdb'
exec sp_trace_setfilter @TraceID, 35, 0, 7, N'master'
exec sp_trace_setfilter @TraceID, 35, 0, 7, N'msdb'
exec sp_trace_setfilter @TraceID, 35, 0, 7, N'model'
exec sp_trace_setfilter @TraceID, 35, 0, 7, N'distribution'	
-- Set the trace status to start
exec sp_trace_setstatus @TraceID, 1

-- display trace id for future references
select TraceID=@TraceID
goto finish

error: 
select ErrorCode=@rc

finish: 
go


--exec sp_trace_setstatus 2, 1 --start
--exec sp_trace_setstatus 2, 0 --stop
--EXEC sp_trace_setstatus 2, 2; --close

-----------------------------------------
