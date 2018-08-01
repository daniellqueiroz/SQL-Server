/****** Object:  StoredProcedure [dbo].[MongoDB_CategoriaExtrair]    Script Date: 04/03/2013 18:17:07 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[MongoDB_CategoriaExtrair]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[MongoDB_CategoriaExtrair]
GO


/****** Object:  StoredProcedure [dbo].[MongoDB_CategoriaExtrair]    Script Date: 04/03/2013 18:17:07 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[Mongo].[MongoDB_CategoriaExtrair]') AND type in (N'P', N'PC'))
DROP PROCEDURE [Mongo].[MongoDB_CategoriaExtrair]
GO

CREATE PROCEDURE [Mongo].[MongoDB_CategoriaExtrair] (
@versao BIGINT,
@versao_recuperada BIGINT OUTPUT
)
AS
BEGIN
	DECLARE @oid int=(SELECT OBJECT_ID('Categoria'))
	
	DECLARE @min_version BIGINT,@max bigint
	SET @min_version = change_tracking_min_valid_version(@oid);
	----SELECT @last_version 

	SET @max=(SELECT MAX(sys_change_version)
	FROM changetable(changes Categoria,@min_version) AS ct)

	--Seta o parametro de saida passando para aplicacao qual a versao que está sendo reruperada.
	SET @versao_recuperada = @max; 
	
	IF(@versao_recuperada IS NULL)
	BEGIN
		SET @versao_recuperada = @min_version;
	END

	SELECT --ct.*,
	ct.idcategoria,ct.sys_change_operation,dc.*
	FROM changetable(changes Categoria,@min_version) AS ct
	LEFT JOIN categoria dc ON ct.idcategoria=dc.idcategoria
	WHERE sys_change_version BETWEEN @versao AND @max


END

GO

/****** Object:  StoredProcedure [dbo].[MongoDB_FaixaPrecoExtrair]    Script Date: 04/03/2013 18:17:07 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[MongoDB_FaixaPrecoExtrair]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[MongoDB_FaixaPrecoExtrair]
GO


/****** Object:  StoredProcedure [dbo].[MongoDB_FaixaPrecoExtrair]    Script Date: 04/03/2013 18:17:07 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[Mongo].[MongoDB_FaixaPrecoExtrair]') AND type in (N'P', N'PC'))
DROP PROCEDURE [Mongo].[MongoDB_FaixaPrecoExtrair]
GO

CREATE PROCEDURE [Mongo].[MongoDB_FaixaPrecoExtrair] (
@versao BIGINT,
@versao_recuperada BIGINT OUTPUT
)
AS
BEGIN
	DECLARE @oid int=(SELECT OBJECT_ID('FaixaPreco'))
	
	DECLARE @min_version BIGINT,@max bigint
	SET @min_version = change_tracking_min_valid_version(@oid);
	----SELECT @last_version 

	SET @max=(SELECT MAX(sys_change_version)
	FROM changetable(changes FaixaPreco,@min_version) AS ct)

	--Seta o parametro de saida passando para aplicacao qual a versao que está sendo reruperada.
	SET @versao_recuperada = @max; 
	
	IF(@versao_recuperada IS NULL)
	BEGIN
		SET @versao_recuperada = @min_version;
	END

	SELECT --ct.*,
	ct.idfaixapreco,ct.sys_change_operation,dc.*
	FROM changetable(changes FaixaPreco,@min_version) AS ct
	LEFT JOIN faixapreco dc ON ct.idfaixapreco=dc.idfaixapreco
	WHERE sys_change_version BETWEEN @versao AND @max


END

GO