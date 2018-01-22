-- creates partition function (com o id max da fretevalor atual)

DECLARE @maxid INT 
SELECT @maxid = MAX(idfretevalor) FROM fretevalor

SELECT @maxid

CREATE PARTITION FUNCTION IntegracaoFretePartitionFunction(INT)
AS 
RANGE LEFT FOR VALUES (@maxid) --YYYYMMDD


-- creates partition scheme

CREATE PARTITION SCHEME IntegracaoFreteScheme AS 
PARTITION IntegracaoFretePartitionFunction 
ALL TO ([PRIMARY]) -- note that this is not the optimal option. The best solution would be create one filegroup for each partition you have. Use "ALL TO PRIMARY" only if for testing purposes or if you have storage constraints  

-- exports the table with bcp while keeping the identity values

bcp db_prd_corp.dbo.fretevalor OUT d:\fretevalor.bcp -S10.140.1.16,1190 - T -n -E

-- rename your old tables for backup purposes 

-- create the partitioned tables within the new partition scheme 
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[FreteValor](
	[IdFreteValor] [INT] IDENTITY(1,1) NOT FOR REPLICATION NOT NULL,
	[IdFrete] [INT] NOT NULL,
	[CepDe] [INT] NOT NULL,
	[CepAte] [INT] NOT NULL,
	[PesoDe] [DECIMAL](18, 4) NOT NULL,
	[PesoAte] [DECIMAL](18, 4) NOT NULL,
	[ValorAbsoluto] [MONEY] NOT NULL,
	[ValorMinimoPorPreco] [MONEY] NOT NULL,
	[ValorPorPreco] [MONEY] NOT NULL,
	[ValorPorPeso] [MONEY] NOT NULL,
	[DataDe] [SMALLDATETIME] NULL,
	[DataAte] [SMALLDATETIME] NULL,
	[VolumeMaximo] [DECIMAL](18, 4) NULL,
	[PrazoEntrega] [INT] NULL,
	[PesoCubado] [DECIMAL](18, 4) NULL,
	[FlagAtiva] [BIT] NULL,
	[IdPeriodoEntrega] [INT] NULL,
 CONSTRAINT [PK_FreteValorNova] PRIMARY KEY CLUSTERED 
(
	[IdFreteValor] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON, FILLFACTOR = 80) ON IntegracaoFreteScheme (idfretevalor)
) ON IntegracaoFreteScheme (IdFreteValor)

GO

CREATE NONCLUSTERED INDEX [IX_FreteValor_CEpDeCepAte] ON [dbo].[FreteValor] 
(
	[CepDe] ASC,
	[CepAte] ASC,
	[VolumeMaximo] ASC
)
INCLUDE ( [IdFreteValor],
[IdFrete],
[PesoDe],
[PesoAte],
[ValorAbsoluto],
[ValorPorPreco],
[ValorPorPeso],
[PrazoEntrega],
[PesoCubado],
[IdPeriodoEntrega]) WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON, FILLFACTOR = 100) ON IntegracaoFreteScheme (IdFreteValor)
GO

CREATE NONCLUSTERED INDEX [ix_t4b_FreteValor_1] ON [dbo].[FreteValor] 
(
	[FlagAtiva] ASC,
	[CepDe] ASC,
	[CepAte] ASC,
	[DataDe] ASC,
	[DataAte] ASC,
	[VolumeMaximo] ASC
)
INCLUDE ( [ValorPorPeso],
[IdPeriodoEntrega],
[PesoCubado],
[PrazoEntrega],
[IdFrete],
[IdFreteValor],
[ValorPorPreco],
[ValorAbsoluto],
[PesoAte],
[PesoDe]) WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON, FILLFACTOR = 100) ON IntegracaoFreteScheme (IdFreteValor)
GO

CREATE NONCLUSTERED INDEX [ix_t4b_FreteValorCalcularParaEntregaTipo] ON [dbo].[FreteValor] 
(
	[FlagAtiva] ASC,
	[CepDe] ASC,
	[CepAte] ASC,
	[DataDe] ASC,
	[DataAte] ASC,
	[VolumeMaximo] ASC
)
INCLUDE ( [ValorPorPeso],
[PrazoEntrega],
[PesoCubado],
[IdPeriodoEntrega],
[IdFreteValor],
[IdFrete],
[PesoDe],
[PesoAte],
[ValorAbsoluto],
[ValorPorPreco]) WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON IntegracaoFreteScheme (IdFreteValor)
GO
ALTER TABLE [dbo].[FreteValor]  WITH NOCHECK ADD  CONSTRAINT [FK_FreteValor_Frete] FOREIGN KEY([IdFrete])
REFERENCES [dbo].[Frete] ([IdFrete])
NOT FOR REPLICATION 
GO
ALTER TABLE [dbo].[FreteValor] CHECK CONSTRAINT [FK_FreteValor_Frete]


-- importing the data into the partitioned table
bcp db_prd_corp.dbo.fretevalor IN d:\fretevalor.bcp -S10.140.1.16,1190 - T -n -E

-- validate record distribution within the partitions (you must have two - one with all the records and another without records)

-- create the staging table within the same partition schema of the main tables
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[FreteValorDeletar](
	[IdFreteValor] [INT] IDENTITY(1,1) NOT FOR REPLICATION NOT NULL,
	[IdFrete] [INT] NOT NULL,
	[CepDe] [INT] NOT NULL,
	[CepAte] [INT] NOT NULL,
	[PesoDe] [DECIMAL](18, 4) NOT NULL,
	[PesoAte] [DECIMAL](18, 4) NOT NULL,
	[ValorAbsoluto] [MONEY] NOT NULL,
	[ValorMinimoPorPreco] [MONEY] NOT NULL,
	[ValorPorPreco] [MONEY] NOT NULL,
	[ValorPorPeso] [MONEY] NOT NULL,
	[DataDe] [SMALLDATETIME] NULL,
	[DataAte] [SMALLDATETIME] NULL,
	[VolumeMaximo] [DECIMAL](18, 4) NULL,
	[PrazoEntrega] [INT] NULL,
	[PesoCubado] [DECIMAL](18, 4) NULL,
	[FlagAtiva] [BIT] NULL,
	[IdPeriodoEntrega] [INT] NULL,
 CONSTRAINT [PK_FreteValorDeletar] PRIMARY KEY CLUSTERED 
(
	[IdFreteValor] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON, FILLFACTOR = 80) ON IntegracaoFreteScheme (idfretevalor)
) ON IntegracaoFreteScheme (IdFreteValor)

GO

-- populate the main tables with new data

-- switch, split and merge da partition function
TRUNCATE TABLE FreteValorDeletar

ALTER TABLE dbo.FreteValor
SWITCH PARTITION 1 TO dbo.FreteValorDeletar PARTITION 1
GO

ALTER PARTITION SCHEME IntegracaoFreteScheme NEXT USED [primary]
GO

DECLARE @RANGE INT
DECLARE @NEWRANGE INT
SELECT @RANGE = CONVERT(INT,[value]) FROM sys.partition_range_values

--select @range

DECLARE @maxid INT 
SELECT @maxid = MAX(IdFreteValor) FROM FreteValor
SELECT @NEWRANGE = @maxid

--select @newrange

ALTER PARTITION FUNCTION IntegracaoFretePartitionFunction()
SPLIT RANGE (@NEWRANGE);

ALTER PARTITION FUNCTION IntegracaoFretePartitionFunction()
MERGE RANGE (@RANGE);
