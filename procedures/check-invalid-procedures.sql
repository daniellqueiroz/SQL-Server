/*
Remarks:

1. Configure the session to discard results
2. This script will create the execution code for procedures so that you can find out which procedures reference invalid or non existent objects. It can be a good way to validate a procedure and check if it is not obsolete. 

*/



SET CONCAT_NULL_YIELDS_NULL off
SELECT REPLACE(REPLACE('SET CONCAT_NULL_YIELDS_NULL on;set nocount on;SET FMTONLY on; exec '+[proc]+' '+a.Parametros1 +'; SET FMTONLY off;','|',''),', ;',''),*
FROM (
select  r.name AS [PROC],
(SELECT REPLACE((SELECT CASE type_name(p1.system_type_id) WHEN 'table type' THEN '' else p1.name+'=NULL,' end AS [data()] FROM sys.parameters p1 where p1.object_id=r.object_id FOR XML PATH('')) +'|' ,',|','')) AS Parametros1
--,(SELECT REPLACE((SELECT p1.name+'=NULL,' AS [data()] FROM sys.parameters p1 where p1.object_id=r.object_id FOR XML PATH('')) +'|' ,',|','')) AS Parametros
  from 
  sys.procedures r 
  --WHERE r.name='ConfiguracaoPrimeiraCompraAtualizar'
) AS a
GO

select
   'Parameter_name' = p.name,  
   'Type'   = type_name(p.user_type_id),  
   'Length'   = p.max_length,  
   'Prec'   = case when type_name(p.system_type_id) = 'uniqueidentifier' 
              then precision  
              else OdbcPrec(p.system_type_id, p.max_length, precision) end,  
   'Scale'   = OdbcScale(p.system_type_id, p.scale),  
   'Param_order'  = p.parameter_id,  
   'Collation'   = convert(sysname, 
                   case when p.system_type_id in (35, 99, 167, 175, 231, 239)  
                   then ServerProperty('collation') end)  
	,p.is_nullable
	,type_name(p.system_type_id) typename
  from sys.procedures r, sys.parameters p where p.object_id=r.object_id
  AND r.name='ConfiguracaoPrimeiraCompraAtualizar'
GO

SET CONCAT_NULL_YIELDS_NULL on;set nocount on;SET FMTONLY on; exec sp_ListaTop20 ; SET FMTONLY off;
SET CONCAT_NULL_YIELDS_NULL on;set nocount on;SET FMTONLY on; exec MarcaAltera @IdMarca=NULL, @Nome=NULL, @Texto=NULL, @PalavraChave=NULL, @TituloSite=NULL, @FlagAtiva=NULL, @LinkChat=NULL, @Telefone=NULL, @EmailSite=NULL, @ObsSAC=NULL, @FlagExibirContato=NULL; SET FMTONLY off;
SET CONCAT_NULL_YIELDS_NULL on;set nocount on;SET FMTONLY on; exec ConfiguracaoPrimeiraCompraAtualizar  @IdTipoPrimeiraCompra=NULL; SET FMTONLY off;
SET CONCAT_NULL_YIELDS_NULL on;set nocount on;SET FMTONLY on; exec LogPrimeiraCompraAlterar @idCliente=NULL, @NumeroProposta=NULL, @StatusPrimeiraCompra=NULL, @ValorCompra=NULL, @ValorProposta=NULL, @CodigoProduto=NULL, @CodigoBandeira=NULL, @CodigoRetorno=NULL, @MensagemRetorno=NULL, @PropostaAceita=NULL, @Fluxo=NULL, @IpCliente=NULL, @ValorLimiteRotativo=NULL, @ValorLimiteParcelado=NULL, @QuantidadeParcelasSemJuros=NULL, @FlagSeguro=NULL, @FlagSms=NULL, @FlagOverLimit=NULL, @FlagAceitaSmsCampanha=NULL, @FlagBacen=NULL, @DiaVencimento=NULL, @EstadoCobranca=NULL, @MunicipioCobranca=NULL, @NumeroCobranca=NULL, @ComplementoCobranca=NULL, @BairroCobranca=NULL, @CepCobranca=NULL, @RuaCobranca=NULL, @CodigoParceiro=NULL, @DataReenvio=NULL, @IdLogPrimeiraCompra=NULL, @PontoReferenciaCobranca=NULL, @CodVariante=NULL, @IdCompra=NULL, @Transmitido=NULL; SET FMTONLY off;
SET CONCAT_NULL_YIELDS_NULL on;set nocount on;SET FMTONLY on; exec ObterSkuTabelaValorVigente @idsku=NULL; SET FMTONLY off;
SET CONCAT_NULL_YIELDS_NULL on;set nocount on;SET FMTONLY on; exec spDeleteCarrinhoProdutoCustomizadoByIdCarrinhoSku @IdCarrinhoSku=NULL; SET FMTONLY off;
SET CONCAT_NULL_YIELDS_NULL on;set nocount on;SET FMTONLY on; exec TicketRecursoSeguroExcluir @Ticket=NULL; SET FMTONLY off;
SET CONCAT_NULL_YIELDS_NULL on;set nocount on;SET FMTONLY on; exec spFormaPagamentoParcelamentoParcelasMenoresOuIguaisListar @quantidadeParcelas=NULL, @valorVitrine=NULL, @valorPromocao=NULL, @idCartaoComBandeiraPreferencial=NULL; SET FMTONLY off;
SET CONCAT_NULL_YIELDS_NULL on;set nocount on;SET FMTONLY on; exec TermoRecomendacaoListar @FlagNPC=NULL, @BitWise=NULL; SET FMTONLY off;
SET CONCAT_NULL_YIELDS_NULL on;set nocount on;SET FMTONLY on; exec AdministradorSistemaAlterar @IdAdministrador=NULL, @NomeSistema=NULL, @Campanha=NULL, @Midia=NULL, @Parceiro=NULL, @IdAdministradorSistema=NULL; SET FMTONLY off;
SET CONCAT_NULL_YIELDS_NULL on;set nocount on;SET FMTONLY on; exec ValeHistoricoListar @IdVale=NULL, @IdValeStatus=NULL, @Valor=NULL, @DataUltimaAtualizacaoStatus=NULL, @DataValidade=NULL, @CpfCnpj=NULL, @ValorOriginal=NULL, @Top=NULL; SET FMTONLY off;
SET CONCAT_NULL_YIELDS_NULL on;set nocount on;SET FMTONLY on; exec spFormaPagamentoListar @IdFormaPagamento=NULL, @IdFormaPagamentoGrupo=NULL, @FlagAtiva=NULL, @Tipo=NULL, @FlagHabilitadoPagtoComplementar=NULL; SET FMTONLY off;
SET CONCAT_NULL_YIELDS_NULL on;set nocount on;SET FMTONLY on; exec PrecoLivePriceListar @IdSku=NULL; SET FMTONLY off;
SET CONCAT_NULL_YIELDS_NULL on;set nocount on;SET FMTONLY on; exec spGuiaVideoIncluir @IdProduto=NULL, @Nome=NULL, @Ordem=NULL, @Link=NULL, @Compartilhador=NULL; SET FMTONLY off;
SET CONCAT_NULL_YIELDS_NULL on;set nocount on;SET FMTONLY on; exec CompraClienteListarPorIdsCompras ; SET FMTONLY off;
SET CONCAT_NULL_YIELDS_NULL on;set nocount on;SET FMTONLY on; exec sp_MSupd_dboColecaoModelo @c1=NULL, @c2=NULL, @pkc1=NULL, @bitmap=NULL; SET FMTONLY off;
SET CONCAT_NULL_YIELDS_NULL on;set nocount on;SET FMTONLY on; exec spListarClienteNaoEnviadosHotline ; SET FMTONLY off;
SET CONCAT_NULL_YIELDS_NULL on;set nocount on;SET FMTONLY on; exec IntegracaoTrackingTempCanceladasListar @QtdeMaxTentativas=NULL, @QtdeMaxDias=NULL; SET FMTONLY off;
SET CONCAT_NULL_YIELDS_NULL on;set nocount on;SET FMTONLY on; exec CampanhaArquivoB2BAlterar @NomeArquivo=NULL, @Tipo=NULL, @DataGeracao=NULL, @IdCampanha=NULL; SET FMTONLY off;
SET CONCAT_NULL_YIELDS_NULL on;set nocount on;SET FMTONLY on; exec spBuscarGrupoCustomByIdSkuPai @IdSkuPai=NULL; SET FMTONLY off;
SET CONCAT_NULL_YIELDS_NULL on;set nocount on;SET FMTONLY on; exec PaginaCandidatoListaCompleto @IdPaginaCandidato=NULL, @IdPaginaAreaElemento=NULL, @FlagAtiva=NULL; SET FMTONLY off;
SET CONCAT_NULL_YIELDS_NULL on;set nocount on;SET FMTONLY on; exec AjusteDisponibilidadeProduto ; SET FMTONLY off;
SET CONCAT_NULL_YIELDS_NULL on;set nocount on;SET FMTONLY on; exec AjusteNomeSku ; SET FMTONLY off;
SET CONCAT_NULL_YIELDS_NULL on;set nocount on;SET FMTONLY on; exec BuscaExecutaNoFullTextLojista @XmlIdMarca=NULL, @IdLinha=NULL, @strBusca=NULL, @XmlIdCategorias=NULL, @XmlIdCampoValores=NULL, @XmlFaixaPreco=NULL, @idColecao=NULL; SET FMTONLY off;
SET CONCAT_NULL_YIELDS_NULL on;set nocount on;SET FMTONLY on; exec CarrinhoManutencaoApaga ; SET FMTONLY off;
SET CONCAT_NULL_YIELDS_NULL on;set nocount on;SET FMTONLY on; exec spDeleteCarrinhoProdutoCustomizadoByIdCarrinhoSkuPai @IdCarrinhoSkuPai=NULL; SET FMTONLY off;
SET CONCAT_NULL_YIELDS_NULL on;set nocount on;SET FMTONLY on; exec ProdutoListarIdsPorColecao @IdColecao=NULL, @QtdPorPagina=NULL, @NumeroPagina=NULL; SET FMTONLY off;
SET CONCAT_NULL_YIELDS_NULL on;set nocount on;SET FMTONLY on; exec PaginaSistemaAreaInclui @Nome=NULL, @Pagina=NULL, @Texto=NULL; SET FMTONLY off;
SET CONCAT_NULL_YIELDS_NULL on;set nocount on;SET FMTONLY on; exec CampanhaRegraFixaListar @IdSku=NULL, @IdCategoria=NULL, @IdCampanha=NULL, @Valor=NULL; SET FMTONLY off;
SET CONCAT_NULL_YIELDS_NULL on;set nocount on;SET FMTONLY on; exec ValeTransacaoListar @IdCompra=NULL, @IdVale=NULL; SET FMTONLY off;
SET CONCAT_NULL_YIELDS_NULL on;set nocount on;SET FMTONLY on; exec ValeListar @IdVale=NULL, @IdValeStatus=NULL, @Valor=NULL, @DataUltimaAtualizacaoStatus=NULL, @DataValidade=NULL, @CpfCnpj=NULL, @ValorOriginal=NULL, @GerencialId=NULL, @Top=NULL; SET FMTONLY off;
SET CONCAT_NULL_YIELDS_NULL on;set nocount on;SET FMTONLY on; exec spSkuServicoAlterar @IdSkuServico=NULL, @IdSkuServicoTipo=NULL, @IdSku=NULL, @Nome=NULL, @GerencialId=NULL, @Prazo=NULL, @FlagAtiva=NULL, @IdSkuServicoValor=NULL, @texto=NULL, @PlanoIndisponivel=NULL; SET FMTONLY off;
SET CONCAT_NULL_YIELDS_NULL on;set nocount on;SET FMTONLY on; exec spColecaoSimplesListar @IdColecao=NULL, @IdColecaoTipo=NULL, @Nome=NULL, @FlagExcluido=NULL, @FlagExpirado=NULL, @OrdenaPorCodigo=NULL, @OrdenaPorExpiracao=NULL, @Top=NULL, @IdCategoria=NULL, @FlagProdutoDisponivel=NULL; SET FMTONLY off;
SET CONCAT_NULL_YIELDS_NULL on;set nocount on;SET FMTONLY on; exec spGuiaVideoApaga @IdProduto=NULL, @XmlIdGuiaVideo=NULL; SET FMTONLY off;
SET CONCAT_NULL_YIELDS_NULL on;set nocount on;SET FMTONLY on; exec spFiltrosProduto @IdProduto=NULL; SET FMTONLY off;
SET CONCAT_NULL_YIELDS_NULL on;set nocount on;SET FMTONLY on; exec sp_MSdel_dboColecaoModelo @pkc1=NULL; SET FMTONLY off;
SET CONCAT_NULL_YIELDS_NULL on;set nocount on;SET FMTONLY on; exec FormaPagamentoCampanhaInserir @IdCampanha=NULL, @idFormaPagamento=NULL, @BinsRestritos=NULL, @ValorMaximoAceito=NULL; SET FMTONLY off;
SET CONCAT_NULL_YIELDS_NULL on;set nocount on;SET FMTONLY on; exec DadosConfiguracaoCampanhaAlterar @IdCampanha=NULL, @Nome=NULL, @Valor=NULL; SET FMTONLY off;
SET CONCAT_NULL_YIELDS_NULL on;set nocount on;SET FMTONLY on; exec spCompraFormaPagamentoAlterar @IdCompraFormaPagamento=NULL, @IdFormaPagamento=NULL, @IdCompra=NULL, @IdVale=NULL, @IdCompraFormaPagamentoStatus=NULL, @QuantidadeParcelas=NULL, @ValorComJuros=NULL, @ValorJuros=NULL, @CcNome=NULL, @CcUltimos4Numeros=NULL, @CcNumero=NULL, @CcCodigo=NULL, @CcAnoMes=NULL, @CcAno=NULL, @CcMes=NULL, @FlagModoManual=NULL, @FlagAtivo=NULL, @Data=NULL, @Url=NULL, @CcPrimeiros6Numeros=NULL, @TipoJuros=NULL, @TaxaJuros=NULL, @FatorCalculoJuros=NULL, @AjusteCarencia=NULL, @NumeroCDCTabela=NULL, @CodigoCiclo=NULL, @IdCDCTabela=NULL, @IdDesconto=NULL, @IdCliente=NULL, @UsuarioGuid=NULL, @NumeroAgencia=NULL, @NumeroContrato=NULL, @FlagGarantiaEstendida=NULL, @Sequencial=NULL, @TipoWallet=NULL, @IdTransWallet=NULL; SET FMTONLY off;
SET CONCAT_NULL_YIELDS_NULL on;set nocount on;SET FMTONLY on; exec spBuscaRelacionadaSliApagar @IdSku=NULL; SET FMTONLY off;
SET CONCAT_NULL_YIELDS_NULL on;set nocount on;SET FMTONLY on; exec ProdutoReviewClientePossui @IdCliente=NULL, @IdProduto=NULL; SET FMTONLY off;
SET CONCAT_NULL_YIELDS_NULL on;set nocount on;SET FMTONLY on; exec MarcaLista @IdMarca=NULL, @IdMarcas=NULL, @Nome=NULL, @FlagAtiva=NULL; SET FMTONLY off;
SET CONCAT_NULL_YIELDS_NULL on;set nocount on;SET FMTONLY on; exec LogManutencaoApaga ; SET FMTONLY off;
SET CONCAT_NULL_YIELDS_NULL on;set nocount on;SET FMTONLY on; exec spCOMPARETABLECOLUMNS_ApenasOrigem @INSTANCE1=NULL, @DATABASE1=NULL, @TABLE1=NULL, @INSTANCE2=NULL, @DATABASE2=NULL, @TABLE2=NULL; SET FMTONLY off;
SET CONCAT_NULL_YIELDS_NULL on;set nocount on;SET FMTONLY on; exec PaginaSistemaAreaLista @IdPaginaSistemaArea=NULL, @Pagina=NULL; SET FMTONLY off;
SET CONCAT_NULL_YIELDS_NULL on;set nocount on;SET FMTONLY on; exec spListarFormaPagamentoParcelamentoPorFormaPagamento @idFormaPagamento=NULL; SET FMTONLY off;
SET CONCAT_NULL_YIELDS_NULL on;set nocount on;SET FMTONLY on; exec CategoriaAltera @IdCategoria=NULL, @IdCategoriaPai=NULL, @idDepartamento=NULL, @FlagAtiva=NULL, @FlagMenu=NULL, @Nome=NULL, @Texto=NULL, @MargemLucro=NULL, @PalavraChave=NULL, @TituloSite=NULL, @ModoExibicaoProduto=NULL, @FlagFiltroMarca=NULL, @FlagAtivaMenuLink=NULL, @NomeURL=NULL, @NomeAlternativo=NULL, @TituloSiteAlternativo=NULL, @NomeURLAlternativo=NULL, @TagAnalyticsCategoria=NULL, @TagAnalyticsCheckout=NULL, @TextoAlternativo=NULL, @GoogleProductCategory=NULL, @FlagExibeSegundaImagem=NULL, @FlagCompraRestricaoIdade=NULL; SET FMTONLY off;
SET CONCAT_NULL_YIELDS_NULL on;set nocount on;SET FMTONLY on; exec DESCONTOSPERCENTUAISSKU @IDSKU=NULL; SET FMTONLY off;
SET CONCAT_NULL_YIELDS_NULL on;set nocount on;SET FMTONLY on; exec spCompraEntregaSkuListarPorCompraSemKit @IdCompra=NULL; SET FMTONLY off;
SET CONCAT_NULL_YIELDS_NULL on;set nocount on;SET FMTONLY on; exec CompraFormaPagamentoListarLinhaDigitavelPendenteEnvio ; SET FMTONLY off;
SET CONCAT_NULL_YIELDS_NULL on;set nocount on;SET FMTONLY on; exec spGuiaVideoAlterar @IdGuiaVideo=NULL, @IdProduto=NULL, @Nome=NULL, @Ordem=NULL, @Link=NULL, @Compartilhador=NULL; SET FMTONLY off;
SET CONCAT_NULL_YIELDS_NULL on;set nocount on;SET FMTONLY on; exec CompraClienteListarPelaDataStatus @IdCompra=NULL, @CpfCnpj=NULL, @Email=NULL, @TipoCliente=NULL, @DataInicioStatus=NULL, @DataFimStatus=NULL, @IdCompraEntregaStatus=NULL; SET FMTONLY off;
SET CONCAT_NULL_YIELDS_NULL on;set nocount on;SET FMTONLY on; exec sp_MSins_dboColecaoTipo @c1=NULL, @c2=NULL, @c3=NULL; SET FMTONLY off;
SET CONCAT_NULL_YIELDS_NULL on;set nocount on;SET FMTONLY on; exec SkuTributacaoPrecoCalculadoListar @IdParceiro=NULL; SET FMTONLY off;
SET CONCAT_NULL_YIELDS_NULL on;set nocount on;SET FMTONLY on; exec spListarTodosIdSku ; SET FMTONLY off;
SET CONCAT_NULL_YIELDS_NULL on;set nocount on;SET FMTONLY on; exec CompraEntregaCorreiosInclui @IdCompraEntrega=NULL, @SroCorreios=NULL; SET FMTONLY off;
SET CONCAT_NULL_YIELDS_NULL on;set nocount on;SET FMTONLY on; exec ClusterSkuListar ; SET FMTONLY off;
SET CONCAT_NULL_YIELDS_NULL on;set nocount on;SET FMTONLY on; exec ProdutoDisponibilidadeBeneficioTempIncluir ; SET FMTONLY off;
SET CONCAT_NULL_YIELDS_NULL on;set nocount on;SET FMTONLY on; exec spFilialListar @IdFilial=NULL, @CNPJ=NULL, @Filial=NULL, @CentroDistribuicao=NULL, @FilialColetaCD=NULL, @TOP=NULL; SET FMTONLY off;
SET CONCAT_NULL_YIELDS_NULL on;set nocount on;SET FMTONLY on; exec LogPrimeiraCompraListarCadastrados ; SET FMTONLY off;
SET CONCAT_NULL_YIELDS_NULL on;set nocount on;SET FMTONLY on; exec CarrinhoSkuAlteraCarrinho @UsuarioGUIDAntigo=NULL, @UsuarioGUIDNovo=NULL; SET FMTONLY off;
SET CONCAT_NULL_YIELDS_NULL on;set nocount on;SET FMTONLY on; exec PaginaSistemaAreaApaga @IdPaginaSistemaArea=NULL; SET FMTONLY off;
SET CONCAT_NULL_YIELDS_NULL on;set nocount on;SET FMTONLY on; exec spObterIdsProdutosAcessorios @Total=NULL, @IdProdutoReferencia=NULL, @IdSkuReferencia=NULL, @flagExibe=NULL, @flagAtiva=NULL, @IdTipoComplemento=NULL, @XmlIdProdutosInclusos=NULL; SET FMTONLY off;
SET CONCAT_NULL_YIELDS_NULL on;set nocount on;SET FMTONLY on; exec SkuComplementoComTipoObter @IdSku=NULL; SET FMTONLY off;
SET CONCAT_NULL_YIELDS_NULL on;set nocount on;SET FMTONLY on; exec spColecaoParametroProdutoAtualizarAuto @idColecao=NULL; SET FMTONLY off;
SET CONCAT_NULL_YIELDS_NULL on;set nocount on;SET FMTONLY on; exec SkuServicoPrefixoExcecaoListar ; SET FMTONLY off;
SET CONCAT_NULL_YIELDS_NULL on;set nocount on;SET FMTONLY on; exec SkuComplementoMerge @IdSku=NULL, @IdSkuPai=NULL, @IdSkuComplementoTipo=NULL, @IdSkuComplementoGrupo=NULL; SET FMTONLY off;
SET CONCAT_NULL_YIELDS_NULL on;set nocount on;SET FMTONLY on; exec MontagemMoveisAgendamentoAlterar @IdAgendamento=NULL, @IdCliente=NULL, @TipoMontagem=NULL, @DataAgendamento=NULL, @DataAgendamentoParceiro=NULL, @TurnoAtendimento=NULL, @IdAgendamentoParceiro=NULL, @IdAgendamentoStatus=NULL, @Rua=NULL, @Numero=NULL, @Complemento=NULL, @Bairro=NULL, @Cep=NULL, @PontoReferencia=NULL, @Municipio=NULL, @Estado=NULL, @Telefone=NULL; SET FMTONLY off;
SET CONCAT_NULL_YIELDS_NULL on;set nocount on;SET FMTONLY on; exec sp_MSupd_dboColecaoTipo @c1=NULL, @c2=NULL, @c3=NULL, @pkc1=NULL, @bitmap=NULL; SET FMTONLY off;
SET CONCAT_NULL_YIELDS_NULL on;set nocount on;SET FMTONLY on; exec CategoriaCorrigirOrdemArvore ; SET FMTONLY off;
SET CONCAT_NULL_YIELDS_NULL on;set nocount on;SET FMTONLY on; exec SkuTributacaoModificadorTempGerar @IdParceiro=NULL, @IdTipoBeneficio=NULL, @IdTipoAplicacaoBeneficio=NULL, @Valor=NULL SET FMTONLY off;
SET CONCAT_NULL_YIELDS_NULL on;set nocount on;SET FMTONLY on; exec spContratoListarPaginada @IdContrato=NULL, @IdCliente=NULL, @Cnpj=NULL, @DataInicial=NULL, @DataFinal=NULL, @PageIndex=NULL, @PageSize=NULL, @rowsCount=NULL; SET FMTONLY off;
SET CONCAT_NULL_YIELDS_NULL on;set nocount on;SET FMTONLY on; exec ResultadoPowerReviewsInlineFilesListar ; SET FMTONLY off;
SET CONCAT_NULL_YIELDS_NULL on;set nocount on;SET FMTONLY on; exec spPedidoParceiroIncluir @IdPedidoParceiro=NULL, @IdCampanha=NULL, @IdCompra=NULL, @DataPedidoParceiro=NULL, @SenhaAtendimento=NULL, @XmlRetorno=NULL, @VersaoServicosB2B=NULL, @Apolice=NULL; SET FMTONLY off;
SET CONCAT_NULL_YIELDS_NULL on;set nocount on;SET FMTONLY on; exec ConfigListaSemXml ; SET FMTONLY off;
SET CONCAT_NULL_YIELDS_NULL on;set nocount on;SET FMTONLY on; exec CompraEntregaCorreiosListar @IdCompraEntrega=NULL, @SroCorreios=NULL; SET FMTONLY off;
SET CONCAT_NULL_YIELDS_NULL on;set nocount on;SET FMTONLY on; exec InsereReviewLojista @Classificacao=NULL, @Comentario=NULL, @idLojista=NULL; SET FMTONLY off;
SET CONCAT_NULL_YIELDS_NULL on;set nocount on;SET FMTONLY on; exec ResenhaAvaliacaoProdutoLista @IdProduto=NULL; SET FMTONLY off;
SET CONCAT_NULL_YIELDS_NULL on;set nocount on;SET FMTONLY on; exec SkuServicoAltera @IdSkuServico=NULL, @IdSku=NULL, @IdSkuServicoTipo=NULL, @IdSkuServicoValor=NULL, @Nome=NULL, @Texto=NULL, @FlagAtiva=NULL, @GerencialId=NULL, @Prazo=NULL; SET FMTONLY off;
SET CONCAT_NULL_YIELDS_NULL on;set nocount on;SET FMTONLY on; exec RelatorioProdutosDimensoesePesos @pPesoMenor=NULL, @pPesoMaior=NULL, @pM3Menor=NULL, @pM3Maior=NULL; SET FMTONLY off;
SET CONCAT_NULL_YIELDS_NULL on;set nocount on;SET FMTONLY on; exec AdministradorAlteraSenha @IdAdministrador=NULL, @Senha=NULL; SET FMTONLY off;
SET CONCAT_NULL_YIELDS_NULL on;set nocount on;SET FMTONLY on; exec PefilRecursoSeguroAlterar @IdPerfilRecursoSeguro=NULL, @IdRecursoSeguro=NULL, @IdPerfil=NULL; SET FMTONLY off;
SET CONCAT_NULL_YIELDS_NULL on;set nocount on;SET FMTONLY on; exec ProdutoPrimeiraCompraDiaVencimentoAtualizar @IdProdutoPrimeiraCompra=NULL SET FMTONLY off;
SET CONCAT_NULL_YIELDS_NULL on;set nocount on;SET FMTONLY on; exec PaginaSistemaAreaAltera @IdPaginaSistemaArea=NULL, @Nome=NULL, @Pagina=NULL, @Texto=NULL; SET FMTONLY off;
SET CONCAT_NULL_YIELDS_NULL on;set nocount on;SET FMTONLY on; exec spCompraPMVConsultar @IDCLIENTE=NULL; SET FMTONLY off;
SET CONCAT_NULL_YIELDS_NULL on;set nocount on;SET FMTONLY on; exec spSkuServicoValorListar @IdSkuServicoValor=NULL, @IdSkuServicoTipo=NULL, @PrazoPlanoGarantech=NULL, @Prefixo=NULL, @Top=NULL, @Preco=NULL, @Garantia=NULL, @PlanoAtivo=NULL; SET FMTONLY off;
SET CONCAT_NULL_YIELDS_NULL on;set nocount on;SET FMTONLY on; exec spCarrinhoObter @UsuarioGUID=NULL; SET FMTONLY off;
SET CONCAT_NULL_YIELDS_NULL on;set nocount on;SET FMTONLY on; exec MontagemMoveisAgendamentoStatusObter @IdAgendamentoStatus=NULL; SET FMTONLY off;
SET CONCAT_NULL_YIELDS_NULL on;set nocount on;SET FMTONLY on; exec sp_MSdel_dboColecaoTipo @pkc1=NULL; SET FMTONLY off;
SET CONCAT_NULL_YIELDS_NULL on;set nocount on;SET FMTONLY on; exec FormaPagamentoCampanhaListar @IdCampanha=NULL, @IdFormaPagamento=NULL; SET FMTONLY off;
SET CONCAT_NULL_YIELDS_NULL on;set nocount on;SET FMTONLY on; exec CategoriaRearranjarOrdem ; SET FMTONLY off;
SET CONCAT_NULL_YIELDS_NULL on;set nocount on;SET FMTONLY on; exec DIFERENCIALLATUALIZACAOCOLECAOMONGO @MINUTO=NULL; SET FMTONLY off;
SET CONCAT_NULL_YIELDS_NULL on;set nocount on;SET FMTONLY on; exec spValidaItemComprado @idListaCompra=NULL, @idSku=NULL; SET FMTONLY off;
SET CONCAT_NULL_YIELDS_NULL on;set nocount on;SET FMTONLY on; exec AvaliacaoLista @IdAvaliacao=NULL, @IdCategoria=NULL; SET FMTONLY off;
SET CONCAT_NULL_YIELDS_NULL on;set nocount on;SET FMTONLY on; exec ClienteEnderecoListaV2 @IdCliente=NULL, @IdEndereco=NULL, @IdClienteEndereco=NULL; SET FMTONLY off;
SET CONCAT_NULL_YIELDS_NULL on;set nocount on;SET FMTONLY on; exec SkuServicoObter @IdSkuServico=NULL; SET FMTONLY off;
SET CONCAT_NULL_YIELDS_NULL on;set nocount on;SET FMTONLY on; exec CampoListaArvore2 @IdCategoria=NULL, @IdGrupo=NULL, @IdTipoCampo=NULL, @FlagFiltro=NULL, @FlagAtivaCategoria=NULL, @FlagExibeEspecificacao=NULL, @FlagAdmin=NULL, @FlagObrigatorio=NULL, @XmlIdCampo=NULL, @FlagSku=NULL, @FlagWizard=NULL, @FlagTemValor=NULL, @FlagPais=NULL, @FlagFilhos=NULL; SET FMTONLY off;
SET CONCAT_NULL_YIELDS_NULL on;set nocount on;SET FMTONLY on; exec CompraConsolidacaoLista @IdCompraPai=NULL; SET FMTONLY off;
SET CONCAT_NULL_YIELDS_NULL on;set nocount on;SET FMTONLY on; exec ClienteArquivoAlterar @IdCliente=NULL, @idArquivo=NULL; SET FMTONLY off;
SET CONCAT_NULL_YIELDS_NULL on;set nocount on;SET FMTONLY on; exec ListarCategoriasRecomendadas  @IdCliente=NULL; SET FMTONLY off;