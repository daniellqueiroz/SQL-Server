-- use this script to get all indexes that do not comply with your naming standards
-- the script will generate the command to recreate those indexes
-- alter the script according to necessity

SET CONCAT_NULL_YIELDS_NULL OFF

-- Autor: Rafael Bahia

-- Get all existing indexes, but NOT the primary keys
DECLARE cIX CURSOR FOR
   SELECT OBJECT_NAME(SI.object_id), SI.object_id, SI.name, SI.index_id
      FROM sys.indexes SI 
         LEFT JOIN INFORMATION_SCHEMA.TABLE_CONSTRAINTS TC ON SI.name = TC.CONSTRAINT_NAME AND OBJECT_NAME(SI.object_id) = TC.TABLE_NAME
      WHERE 1=1 --TC.CONSTRAINT_NAME IS NULL
	  AND SI.type <> 1
      AND OBJECTPROPERTY(SI.object_id, 'IsUserTable') = 1 AND OBJECT_NAME(SI.object_id) NOT LIKE 'sys%'
      AND OBJECT_NAME(SI.object_id) NOT LIKE '%audit%' 
      --AND SI.[name] not like 'IX_%' 
      --AND SI.[name] is not null 
	  AND (LEN(SI.[name]) - LEN(REPLACE(SI.[name],'_',''))) = 1
      AND SI.[name] LIKE 'IX_%' 
      AND OBJECT_NAME(SI.object_id) NOT LIKE 'Ms%' 
      -- comente a linha abaixo para pegar todos os índices. com esse filtro pegamos somente os índices de tabelas de replicação
      --and object_name(SI.object_id) in ('Administrador','Campo','CampoValor','CanalVenda','Categoria','CategoriaArvoreFilho','CategoriaArvorePai','CategoriaMarcaSidebar','CategoriaSimilar','ColecaoModelo','ColecaoTipo','CompraEntregaStatus','Controle','Estoque','Fabricante','FaixaPreco','Feriado','FormaPagamento','FormaPagamentoSige','Fornecedor','Frete','FreteEntregaTipo','FreteModalTipo','FreteValor','Grupo','Marca','NomenclaturaBrasileiraMercadoria','Perfil','PerfilRecursoSeguro','PrazoCentroDistribuicao','Produto','ProdutoCampoValor','ProdutoCategoriaSimilar','RecursoSeguro','ResenhaInteresse','Sku','SkuCondicaoComercial','SkuEan','SkuKitFilho','SkuServico','SkuServicoTipo','TipoCampo','TipoProgramaRecompensa','ValeStatus')
	-- comente a linha abaixo para pegar todos os índices. com esse filtro pegamos somente os índices de tabelas de replicação de imagem
         --and object_name(SI.object_id) in ('Arquivo','SkuArquivo','ProdutoArquivo','TipoArquivo','FormatoArquivo')
      -- comente a linha abaixo para pegar todos os índices. com esse filtro pegamos somente os índices de uma tabela específica (passar o nome da tabela)
         --and object_name(SI.object_id) = 'Produto'
		 --and object_name(SI.object_id) in ('CompraEntregaStatusLog','ProcessoOptOut_Diferenca','CompraFormaPagamento','Endereco','FormaPagamento','ListaCasamento','ListaCasamentoConvidado','ListaCasamentoDivulgacao','ListaDeCompra','Marca','ProdutoCampoValor','Newsletter','Produto','Sku','ClienteEndereco','invalidos_PontoFrio','base_comprou_PF_antigo','SkuServicoValor','ProdutoArquivo','CompraEntregaSkuServico','SkuServico','SkuEstoqueSaldoParcial','Estoque','Categoria','Cliente','ProcessoOptOut_Principal','Compra','CompraEntrega','ProcessoOptOut_Auxiliar','CompraEntregaSku')
      ORDER BY OBJECT_NAME(SI.object_id), SI.index_id

DECLARE @IxTable sysname
DECLARE @PKSQL sysname
DECLARE @IxTableID INT
DECLARE @IxName sysname
DECLARE @IxID INT
DECLARE @IXincludeSQL NVARCHAR(4000)
SET @IXincludeSQL = ') include (' 

-- Loop through all indexes
OPEN cIX
FETCH NEXT FROM cIX INTO @IxTable, @IxTableID, @IxName, @IxID
WHILE (@@FETCH_STATUS = 0)
BEGIN
   DECLARE @IXSQL NVARCHAR(4000) SET @PKSQL = ''
   SET @IXSQL = 'CREATE '
	IF (INDEXPROPERTY(@IxTableID, @IxName, 'IsUnique') = 1)
		PRINT 'alter table ' + OBJECT_NAME(@IxTableID) + ' drop constraint ' + @IxName
	ELSE
		PRINT 'drop index ' + @IxName + ' on ' + OBJECT_NAME(@IxTableID)
   -- Check if the index is unique
   IF (INDEXPROPERTY(@IxTableID, @IxName, 'IsUnique') = 1)
      SET @IXSQL = @IXSQL + 'UNIQUE '
   -- Check if the index is clustered
   IF (INDEXPROPERTY(@IxTableID, @IxName, 'IsClustered') = 1)
      SET @IXSQL = @IXSQL + 'CLUSTERED '

   SET @IXSQL = @IXSQL + 'INDEX IX_' + OBJECT_NAME(@IxTableID) + '_' 
   
   
   
   
   -- Compoe o nome do índice conforme os campos principais
   DECLARE cIxColumn CURSOR FOR 
      SELECT SC.name, is_included_column
      FROM sys.index_columns IC
         JOIN sys.columns SC ON IC.object_id = SC.object_id AND IC.column_id = SC.column_id
      WHERE IC.object_id = @IxTableID AND index_id = @IxID AND IC.is_included_column = 0
      ORDER BY IC.index_column_id

   DECLARE @included BIT
   SET @included = 0
   DECLARE @IxColumn sysname
   DECLARE @IxFirstColumn BIT SET @IxFirstColumn = 1

   -- Loop throug all columns of the index and append them to the CREATE statement
   OPEN cIxColumn
   FETCH NEXT FROM cIxColumn INTO @IxColumn, @included
   WHILE (@@FETCH_STATUS = 0)
   BEGIN
	
      SET @IXSQL = @IXSQL + @IxColumn
      
      FETCH NEXT FROM cIxColumn INTO @IxColumn, @included
   END
   CLOSE cIxColumn
   DEALLOCATE cIxColumn
   
  SET @IXSQL = @IXSQL + ' ON ' + @IxTable + '('
   
   -- Get all columns of the index
   DECLARE cIxColumn CURSOR FOR 
      SELECT SC.name, is_included_column
      FROM sys.index_columns IC
         JOIN sys.columns SC ON IC.object_id = SC.object_id AND IC.column_id = SC.column_id
      WHERE IC.object_id = @IxTableID AND index_id = @IxID AND IC.is_included_column = 0
      ORDER BY IC.index_column_id

   
   -- Loop throug all columns of the index and append them to the CREATE statement
   OPEN cIxColumn
   FETCH NEXT FROM cIxColumn INTO @IxColumn, @included
   WHILE (@@FETCH_STATUS = 0)
   BEGIN
	
      IF (@IxFirstColumn = 1)
         SET @IxFirstColumn = 0
      ELSE
         SET @IXSQL = @IXSQL + ', '

      SET @IXSQL = @IXSQL + @IxColumn
      
      

      FETCH NEXT FROM cIxColumn INTO @IxColumn, @included
   END
   CLOSE cIxColumn
   DEALLOCATE cIxColumn

	SET @IXSQL = @IXSQL + ')'
	
	
	IF (SELECT COUNT(*)
      FROM sys.index_columns IC
         JOIN sys.columns SC ON IC.object_id = SC.object_id AND IC.column_id = SC.column_id
      WHERE IC.object_id = @IxTableID AND index_id = @IxID AND IC.is_included_column = 1) > 0
		BEGIN
		
		SET @IXSQL = @IXSQL + ' include ('
		
		DECLARE cIxColumn CURSOR FOR 
      SELECT SC.name, is_included_column
      FROM sys.index_columns IC
         JOIN sys.columns SC ON IC.object_id = SC.object_id AND IC.column_id = SC.column_id
      WHERE IC.object_id = @IxTableID AND index_id = @IxID AND IC.is_included_column = 1
      ORDER BY IC.index_column_id
	
   --declare @included bit
   SET @included = 0
   --DECLARE @IxColumn SYSNAME
   --DECLARE @IxFirstColumn BIT 
   SET @IxFirstColumn = 1

   -- Loop throug all columns of the index and append them to the CREATE statement
   OPEN cIxColumn
   FETCH NEXT FROM cIxColumn INTO @IxColumn, @included
   WHILE (@@FETCH_STATUS = 0)
   BEGIN
   
		
      IF (@IxFirstColumn = 1)
         SET @IxFirstColumn = 0
      ELSE
         SET @IXSQL = @IXSQL + ', '

      SET @IXSQL = @IXSQL + @IxColumn
		
		
		
      FETCH NEXT FROM cIxColumn INTO @IxColumn, @included
      
   END
   CLOSE cIxColumn
   DEALLOCATE cIxColumn
	   
	   SET @IXSQL = @IXSQL + ')' + CHAR(13)
	   END
	   
   -- Print out the CREATE statement for the index
   PRINT @IXSQL

   FETCH NEXT FROM cIX INTO @IxTable, @IxTableID, @IxName, @IxID
END

CLOSE cIX
DEALLOCATE cIX

