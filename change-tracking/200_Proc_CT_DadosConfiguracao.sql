if object_id('[Mongo].[MongoDB_DadosConfiguracaoExtrair]') is not null
	drop PROCEDURE [Mongo].[MongoDB_DadosConfiguracaoExtrair]
GO

/****** Object:  StoredProcedure [Mongo].[MongoDB_DadosConfiguracaoExtrair]    Script Date: 26/04/2013 17:25:39 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [Mongo].[MongoDB_DadosConfiguracaoExtrair] (@versao BIGINT, @versao_recuperada BIGINT OUTPUT)
AS
BEGIN
	DECLARE @oid int=(SELECT OBJECT_ID('DadosConfiguracao'))

	DECLARE @min_version BIGINT,@max bigint
	SET @min_version = change_tracking_min_valid_version(@oid);
	----SELECT @last_version 

	SET @max=(SELECT MAX(sys_change_version)
	FROM changetable(changes DadosConfiguracao,@min_version) AS ct)
	
	SET @versao_recuperada = @max; 
	
	IF(@versao_recuperada IS NULL)
	BEGIN
		SET @versao_recuperada = @min_version;
	END

	SELECT --ct.*,
	ct.iddadosconfiguracao,ct.sys_change_operation,dc.*
	FROM changetable(changes DadosConfiguracao,@min_version) AS ct
	LEFT JOIN dadosconfiguracao dc ON ct.iddadosconfiguracao=dc.iddadosconfiguracao
	WHERE sys_change_version BETWEEN @versao AND @max
	
END
GO





/****** Object:  StoredProcedure [Mongo].[MongoDB_DadosRecursosExtrair]    Script Date: 04/22/2013 16:24:02 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[Mongo].[MongoDB_DadosRecursosExtrair]') AND type in (N'P', N'PC'))
DROP PROCEDURE [Mongo].[MongoDB_DadosRecursosExtrair]
GO

/****** Object:  StoredProcedure [Mongo].[MongoDB_DadosRecursosExtrair]    Script Date: 04/22/2013 16:24:02 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [Mongo].[MongoDB_DadosRecursosExtrair] (
@versao BIGINT,
@versao_recuperada BIGINT OUTPUT
)
AS
BEGIN
	DECLARE @oid int=(SELECT OBJECT_ID('DadosRecursos'))

	DECLARE @min_version BIGINT,@max bigint
	SET @min_version = change_tracking_min_valid_version(@oid);
	----SELECT @last_version 

	SET @max=(SELECT MAX(sys_change_version)
	FROM changetable(changes DadosRecursos,@min_version) AS ct)

	--Seta o parametro de saida passando para aplicacao qual a versao que está sendo reruperada.
	SET @versao_recuperada = @max; 
	
	IF(@versao_recuperada IS NULL)
	BEGIN
		SET @versao_recuperada = @min_version;
	END

	SELECT --ct.*,
	ct.idDadosRecursos,ct.sys_change_operation,dc.*
	FROM changetable(changes DadosRecursos,@min_version) AS ct
	LEFT JOIN DadosRecursos dc ON ct.idDadosRecursos=dc.idDadosRecursos
	WHERE sys_change_version BETWEEN @versao AND @max
	
END



GO




--------------- Para retornar baseline de cada linha

--SELECT 
--    c.SYS_CHANGE_VERSION,
--    c.SYS_CHANGE_CONTEXT,
--    e.*
--FROM dadosconfiguracao e
--CROSS APPLY CHANGETABLE
--(
--    VERSION dadosconfiguracao, 
--    (iddadosconfiguracao), 
--    (e.iddadosconfiguracao)
--) c;