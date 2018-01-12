SELECT --DISTINCT ''''+ sj.name + ''',' 
sj.name AS 'Nome do Job'
,step_name
,REPLACE(REPLACE(REPLACE(sjs.command,CHAR(10),''),CHAR(13),''),CHAR(9),'') AS 'Comando Executado'
,	'Frequencia' = (CASE sc.freq_type
		WHEN 1 THEN 'Once'
		WHEN 4 THEN 'Daily'
		WHEN 8 THEN 'Weekly'
		WHEN 16 THEN 'Monthly'
		WHEN 32 THEN 'Monthly relative'
		WHEN 64 THEN 'When SQLServer Agent starts'
	END + ' ' +

	CASE(sc.freq_subday_interval)
		WHEN 0 THEN 'Once'
		ELSE CAST('Every ' 
				+ RIGHT(sc.freq_subday_interval,2) 
				+ ' '
				+     CASE(sc.freq_subday_type)
							WHEN 1 THEN 'Once'
							WHEN 4 THEN 'Minutes'
							WHEN 8 THEN 'Hours'
							WHEN 2 THEN 'Seconds'
						END AS CHAR(16))
    END) 

	+ ' começando as ' + CASE LEN(active_start_time)
		WHEN 1 THEN CAST('00:00:0' + RIGHT(active_start_time,2) AS CHAR(8))
		WHEN 2 THEN CAST('00:00:' + RIGHT(active_start_time,2) AS CHAR(8))
		WHEN 3 THEN CAST('00:0' 
				+ LEFT(RIGHT(active_start_time,3),1)  
				+':' + RIGHT(active_start_time,2) AS CHAR (8))
		WHEN 4 THEN CAST('00:' 
				+ LEFT(RIGHT(active_start_time,4),2)  
				+':' + RIGHT(active_start_time,2) AS CHAR (8))
		WHEN 5 THEN CAST('0' 
				+ LEFT(RIGHT(active_start_time,5),1) 
				+':' + LEFT(RIGHT(active_start_time,4),2)  
				+':' + RIGHT(active_start_time,2) AS CHAR (8))
		WHEN 6 THEN CAST(LEFT(RIGHT(active_start_time,6),2) 
				+':' + LEFT(RIGHT(active_start_time,4),2)  
				+':' + RIGHT(active_start_time,2) AS CHAR (8))
	END
	+ ' e término as ' + CASE LEN(active_end_time)
		WHEN 1 THEN CAST('00:00:0' + RIGHT(active_end_time,2) AS CHAR(8))
		WHEN 2 THEN CAST('00:00:' + RIGHT(active_end_time,2) AS CHAR(8))
		WHEN 3 THEN CAST('00:0' 
				+ LEFT(RIGHT(active_end_time,3),1)  
				+':' + RIGHT(active_end_time,2) AS CHAR (8))
		WHEN 4 THEN CAST('00:' 
				+ LEFT(RIGHT(active_end_time,4),2)  
				+':' + RIGHT(active_end_time,2) AS CHAR (8))
		WHEN 5 THEN CAST('0' 
				+ LEFT(RIGHT(active_end_time,5),1) 
				+':' + LEFT(RIGHT(active_end_time,4),2)  
				+':' + RIGHT(active_end_time,2) AS CHAR (8))
		WHEN 6 THEN CAST(LEFT(RIGHT(active_end_time,6),2) 
				+':' + LEFT(RIGHT(active_end_time,4),2)  
				+':' + RIGHT(active_end_time,2) AS CHAR (8))
	END

    ,CASE sc.enabled WHEN 1 THEN 'Ativo' WHEN 0 THEN 'Desativado' END AS StatusAgendamento
	,CASE sj.enabled WHEN 1 THEN 'Ativo' WHEN 0 THEN 'Desativado' END AS StatusJob

, CASE WHEN step_name = 'SPAM' AND sj.name='CRM - Atualização Email Inválido' THEN 'Marca/Desmarca email de marketing enviado ao cliente como SPAM'
WHEN step_name = 'FlagNews' AND sj.name='CRM - Atualização Email Inválido' THEN 'Marca/Desmarca cliente para receber Newsletter de marketing'
WHEN step_name = 'Newsletter' AND sj.name='CRM - Atualização Email Inválido' THEN 'Deleta da tabela Newsletter os clientes que optaram por optout'
WHEN step_name = 'Email Inválido' AND sj.name='CRM - Atualização Email Inválido' THEN 'Marca/Desmarca email de cliente como email inválido'
WHEN step_name = 'Limpa' AND sj.name='RN - Acerta CompraFormaPagamento' THEN 'Exclui registros obsoletos da tabela TransacaoCarteira e CompraFormaPagamento'
WHEN step_name = 'AtualizaDisponibilidadeKit' AND sj.name='RN - AtualizaDisponibilidadeKit' THEN 'Atualiza a flag de disponibilidade dos kits de acordo com a posição do estoque'
WHEN step_name = 'Atualizar FlagSkuSaldoDisponivel' AND sj.name='RN - AtualizarFlagSkuSaldoDisponivel' THEN 'Atualiza a flag de disponibilidade de Skus não kits na SkuLojista de acordo com a posição do estoque'
WHEN step_name = 'Ajuste Disponibilidade Produto' AND sj.name='RN - AtualizarFlagSkuSaldoDisponivel' THEN 'Atualiza a flag de disponibilidade do Produto de acordo com a posição de seus Skus'
WHEN step_name = 'execucao db_prd_extra' AND sj.name='RN - EnvioEmailAlertaBoletoVencendo' THEN 'Insere registro na tabela Email relativo ao boleto, gerado para um cliente, que está prestes a vencer'
WHEN step_name = 'DROP CONSTRAINT' AND sj.name='RN - LimpaClienteFrete' THEN 'Exclui constraints antes da limpeza das tabelas de frete calculado para o cliente'
WHEN step_name = 'TRUNCATE TABLE' AND sj.name='RN - LimpaClienteFrete' THEN 'Limpa tabelas de frete calculado para o cliente'
WHEN step_name = 'ADD CONSTRAINT' AND sj.name='RN - LimpaClienteFrete' THEN 'Recria constraints após a limpeza das tabelas de frete calculado para o cliente'
WHEN step_name = 'LimpaEmails' AND sj.name='RN - LimpaFilaEmailEnderecosProblemas' THEN 'Atualiza data de envio dos emails inválidos constantes na tabela Email'
WHEN step_name = 'Executa procedure para alimentar tabela' AND sj.name='RN - MonitoracaoPPM' THEN 'Job para geração de dados para alerta de pedidos por minuto'
WHEN step_name = 'Exec' AND sj.name='RN - MonitoracaoPPM' THEN 'Job para geração de dados para alerta de pedidos por minuto'
WHEN step_name = 'Exec' AND sj.name='RN - MonitoracaoPPM B2B' THEN 'Job para geração de dados para alerta de pedidos B2B por minuto '
WHEN step_name = 'Exec' AND sj.name='RN - MonitoracaoPPM MarketPlace' THEN 'Job para geração de dados para alerta de pedidos MarketPlace por minuto'
WHEN step_name = 'Executa procedure para alimentar tabela' AND sj.name='RN - MonitoracaoPPM Mobile' THEN 'Job para geração de dados para alerta de pedidos Mobile por minuto'
WHEN step_name = 'Exec' AND sj.name='RN - MonitoracaoPPM Retira em Loja' THEN 'Job para geração de dados para alerta de pedidos do tipo Retira Em Loja por minuto'
WHEN step_name = 'Exec' AND sj.name='RN - MonitoracaoPPM Televendas' THEN 'Job para geração de dados para alerta de pedidos via Televendas por minuto'
WHEN step_name = 'Consolida Informações de catálogo' AND sj.name='RN - Propaga Alterações Catalogo' THEN 'Consolida a posição de vários campos na tabela Produto com base na tabela Sku. Consolida a posição de vários campos na tabela Sku com base na tabela SkuLojista. Para mais detalhes, ver comando executados.'
WHEN step_name = 'SkuAlteracaoParceiroAtualizarCargaFull' AND sj.name='RN - SkuAlteracaoParceiroAtualizarCargaFull' THEN 'Executa atualização de parceiros para posterior execução de carga full da API de parceiros'
WHEN step_name = 'Envia' AND sj.name='RN - EnvioEmailAlertaBoletoVencendo' THEN 'Job que insere registro na tabela Email para avisar ao cliente sobre o vencimento do boleto'
WHEN step_name = 'IndisponibilizaRegistroParaXMLParceiro' AND sj.name LIKE '%IndisponibilizaRegistroParaXMLParceiro%' THEN 'Job que atualiza informação de disponibilidade do Sku no XML do parceiro'
WHEN step_name = 'GerarRegistroXmlParaAtualizacao' AND sj.name LIKE '%ManterRegistroParaXMLParceiro%' THEN 'Job que gera registro do Sku no XML do parceiro'
WHEN step_name = 'EXECUTA LIMPEZA' AND sj.name LIKE '%RN - Remover Produtos Inativos de Colecoes%' THEN 'Job que remove produtos inativos das coleções. Executado apenas sob demanda'
WHEN step_name = 'AtualizaFlagExibe' AND sj.name = 'RN - Atualizacao Exibicao Produto' THEN 'Atualizar FlagExibe do Produto de acordo com a disponibilidade no estoque.'
WHEN step_name = 'AtualizaMaisVendidos' AND sj.name = 'RN - AtualizaMaisVendidos' THEN 'Realiza manutenção do campo _maisVendidos na tabela Produto'
WHEN step_name = 'Executa Atualiza Cliente GPA' AND sj.name = 'RN - Atualizar Dados Cliente Clube Extra' THEN 'Atualiza tabela ClienteGPA de acordo com o banco do Marketing'
WHEN step_name = 'ATUALIZACAO FLAG CLIENTE CLUBE EXTRA' AND sj.name = 'RN - Atualizar Dados Cliente Clube Extra' THEN 'Mantém o campo FlagClubeExtra da tabela ClienteClubeExtra'
WHEN step_name = 'INCLUSAO NOVOS REGISTROS' AND sj.name = 'RN - Atualizar Dados Cliente Clube Extra' THEN 'Inclui novos clientes do Clube Extra na base'
WHEN step_name = 'AtualizarAvaliacoesLojista' AND sj.name = 'RN - AtualizarAvaliacoesLojista' THEN 'Atualiza reviews de lojista Market Place'
WHEN step_name = 'Executa_Procedure_de_Carga' AND sj.name = 'RN - CarregarTabelaCategoriaFiltro' THEN 'Carrega a tabela CategoriaFiltro todos os dias de madrugada'
WHEN step_name = 'DesativarDescontoAtivosPorLimiteVigencia' AND sj.name = 'RN - DesativarPromocoesVencidas' THEN 'Desativa promoções vencidas de acordo com as regras cadastradas para o desconto'
WHEN step_name = 'Limpa tabela IntegracaoInterfaceLogErro' AND sj.name = 'RN - Limpa Dados Obsoletos' THEN 'Remanejamento, para banco de histórico, de registros antigos da tabela IntegracaoInterfaceLogErro'
WHEN step_name = 'Limpa Aviseme Pendentes Obsoletos' AND sj.name = 'RN - Limpa Dados Obsoletos' THEN 'Remanejamento, para banco de histórico, de emails obsoletos do tipo Avise-me baseado no campo FlagAviseMeConcluido e no campo DataEnvio'
WHEN step_name = 'Limpa Dados Log Saida Produto da Colecao' AND sj.name = 'RN - Limpa Dados Obsoletos' THEN 'Limpa dados mais antigos que 3 dias da tabea LogSaidaProdutoColecao'
WHEN step_name = 'Efetuar Limpeza' AND sj.name = 'RN - Limpa Dados Obsoletos - Auditoria DML' THEN 'Limpa dados mais antigos que 7 dias da tabela de auditoria'
WHEN step_name = 'Efetuar Remanejamento' AND sj.name = 'RN - Limpa Dados Obsoletos - Auditoria DML' THEN 'Job que faz controle das sessões ASP, excluindo as sessões expiradas'
WHEN step_name = 'LIMPAR COMPRAS DE TESTE' AND sj.name = 'RN - LIMPAR COMPRAS DE TESTE' THEN 'Limpa compras efetuadas com clintes cujo FlagBlackList = 1'
WHEN step_name = 'Limpa IntegracaoInterfaceLog' AND sj.name = 'RN - Limpar IntegracaoInterface' THEN 'Remanejamento, para banco de histórico, de dados antigos da tabela IntegracaoInterfaceLog'
WHEN step_name = 'LIMPARCARRINHOSOBSOLETOS' AND sj.name = 'RN - LimparCarrinhosObsoletos' THEN 'Limpa carrinhos anônimos mais antigos que 45 dias'
WHEN step_name = 'RN - LimparColecaoObsoleta' AND sj.name = 'RN - LimparColecaoObsoleta' THEN 'Limpa registros da tabela Colecao onde  FlagExcluido=1'
WHEN step_name = 'Exec Proc' AND sj.name = 'RN - SkuDesativaNaoProduzido' THEN 'Desativa Skus não produzidos (onde FlagProduzido=0)'
WHEN step_name = 'Exec proc SkuLojistaPrecoDeAtualizar' AND sj.name = 'RN - SkuLojistaPrecoDeAtualizar' THEN 'Mantém campo PrecoDe da tabela SkuLojista'
WHEN sj.name = 'RN - Relatorio Operacoes - Outros' THEN 'Relatório para diversas áreas (Marketing, Financeiro, etc.)'
WHEN step_name = 'PropagarDesativacaoLojista' AND sj.name = 'RN - Propagar Desativacao de Lojistas' THEN 'Mantém campo PrecoDe da tabela SkuLojista'
WHEN step_name = 'Efetuar Remanejamento' AND sj.name = 'RN - Limpa Dados Obsoletos - Tabela Log' THEN 'Remanejamento, para banco de histórico, de registros antigos da tabela Log'
WHEN sj.name like 'RN - Limpa Dados Obsoletos%' THEN 'Limpeza ou remanejamento de dados antigos ou obsoletos'
WHEN step_name = 'Verificacao' AND sj.name = 'GERAL - VERIFICA ULTIMA ATUALIZACAO DE FRETE' THEN 'Job obsoleto'
WHEN step_name = 'RevogarAutorizacaoPrecificacao' AND sj.name = 'OPER - RevogarAutorizacaoPrecificacao - Operacao' THEN 'Envia relatório para Marketing com todos os Skus cujo campo FlagPrecificaAbaixoCusto estava como 1 e passou a ser 0.'
WHEN step_name = 'AtualizaPosicaoFlagExisteProduto' AND sj.name = 'RN - Atualizacao _FlagExisteProduto' THEN 'Mantém o campo _FlagExisteProduto na tabela Categoria'
WHEN step_name = 'CarregaFreteEntregaTipoCep' AND sj.name = 'RN - CarregarFretesPosIntegracao' THEN 'Atualiza tabela FrenteEntregaTipo'
WHEN step_name = 'CarregaFreteValorConsolidado' AND sj.name = 'RN - CarregarFretesPosIntegracao' THEN 'Atualiza tabela FreteValorConsolidado'
WHEN step_name = 'Gera Historico SkuEstoqueSaldoParcial' AND sj.name = 'RN - GeracaoHistoricoSkuEstoqueSaldoParcial' THEN 'Remanejamento, para tabela secundária, de registros antigos/duplicados da tabela SkuEstoqueSaldoParcial'
WHEN step_name = 'Exec' AND sj.name = 'RN - Limpa Ficha MarketPlace' THEN 'Dá baixa em todos os registros da tabela IntegracaoFichaProduto'
WHEN step_name = 'DesprecificaSkuAbaixoCusto' AND sj.name = 'RN- CancelaPrecificaçãoAbaixoDoCusto' THEN 'Marca todos os skus como FlagPrecificaAbaixoCusto=0'
WHEN step_name = 'EsvaziarCarrinhosAntigos' AND sj.name = 'RN - EsvaziarCarrinhosAntigos' THEN 'Marca todos os skus como FlagPrecificaAbaixoCusto=0'
WHEN step_name = 'Executa limpeza' AND sj.name = 'RN - Limpeza Tabela Dominio' THEN 'Elimina, na tabela Dominio, os registros que apontam para coleções obsoletas'
WHEN step_name = 'Remanejar IntegracaoPedidoProxyLog' AND sj.name like 'RN - Remanejar IntegracaoPedidoProxyLog%' THEN 'Remaneja registros antigos da tabela IntegracaoPedidoProxyLog para o banco de histórico da respectiva loja'
WHEN step_name = 'AtualizaCompraMarketPlacePendenteEnvio' AND sj.name like 'RN - CompraEntregaEnviarMarketPlace%' THEN 'Atualiza tabela consolidada que contém compras vindas de market place pendentes para envio para integração de compras'
WHEN step_name = 'GeraEmailRevOnline' AND sj.name like 'RN - Gera Email Rev Online%' THEN 'Cria registro na tabela Email para disparo de notificações para clientes com compras em REV'
WHEN step_name = 'ManterCompraCertificadoGarantiaPendente' AND sj.name like 'RN - ManterCompraCertificadoGarantiaPendente%' THEN 'Consolida dados de certificados pendentes de criação.'
WHEN step_name = 'Relatorio Alteracoes Recentes' AND sj.name like 'RN - Relatorio Alteracoes Recentes%' THEN 'Envia relatório de objetos alterados nas últimas 24 horas para grupos de desenvolvedores.'

END 
 AS PropositoDoStep
 --,sj.category_id
 --,sjs.database_name
FROM msdb.dbo.sysjobs sj 
INNER JOIN msdb.dbo.sysjobsteps sjs ON sj.job_id = sjs.job_id
INNER JOIN msdb.dbo.sysjobschedules sjss ON sj.job_id = sjss.job_id
INNER JOIN msdb.dbo.sysschedules sc ON sjss.schedule_id = sc.schedule_id
WHERE 1=1
AND category_id NOT IN (8,16,13)
--AND sc.freq_subday_type <> 1
AND sj.name NOT LIKE 'TI_BANCO%'
AND sj.name NOT LIKE 'sysutility%'
AND sjs.step_name NOT IN ('AlwaysOn','OPMON','OK','nagios')
AND sjs.database_name LIKE '%prd%'
--AND sj.enabled=1
--AND sc.enabled=1
ORDER BY sj.name
--,step_id

