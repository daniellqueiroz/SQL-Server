CREATE DATABASE PartitionTest
GO 

USE PartitionTest
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO

-- Creating the partition function
CREATE PARTITION FUNCTION OrderDateRangePFN([SMALLDATETIME])
AS 
RANGE LEFT FOR VALUES ('2011-06-30 23:59:59') --YYYYMMDD

-- Create partition scheme
CREATE PARTITION SCHEME OrderDateRangeScheme AS 
PARTITION OrderDateRangePFN 
ALL TO ([PRIMARY]) -- note that this is not the optimal option. The best solution would be create one filegroup for each partition you have. Use "ALL TO PRIMARY" only if for testing purposes or if you have storage constraints  

-- creating and populating the table
BEGIN
	CREATE TABLE [dbo].[CarrinhoDeletar](	[UsuarioGUID] [nchar](36) NOT NULL,	[CEP] [varchar](10) NULL,	[IdFreteEntregaTipo] [int] NULL,	[Parceiro] [varchar](100) NULL,	[Midia] [varchar](100) NULL,	[Campanha] [varchar](100) NULL,	[PalavraChave] [varchar](max) NULL,	[Data] [smalldatetime] NOT NULL,	[Cupom] [varchar](50) NULL ,[TesteAB] [varchar](1) NULL,	[IdListaDeCompra] [int] NULL,	[IdAfiliado] [int] NULL,	[flagFinalizado] [bit] NOT NULL ,	[codigoPromocao] [int] NULL,	[infoComplCodigoPromocao] [varchar](1000) NULL,	[EntregaAgendada] [bit] NULL,	[DataEntregaAgendada] [datetime] NULL,	[IdPeriodoEntrega] [int] NULL,	[xmlIdFreteValor] [xml] NULL,	[IdOpcaoEntregaExpressa] [int] NULL,	[FlagRespostaPromocao] [bit] NULL,	[RespostaPromocao] [nvarchar](50) NULL, CONSTRAINT [PK_CarrinhoDeletar] PRIMARY KEY CLUSTERED ([UsuarioGUID],data ASC)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON, FILLFACTOR = 75) ON OrderDateRangeScheme(Data)
	) ON OrderDateRangeScheme(Data)
END
go

IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Carrinho]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[Carrinho](	[UsuarioGUID] [nchar](36) NOT NULL,	[CEP] [varchar](10) NULL,	[IdFreteEntregaTipo] [int] NULL,	[Parceiro] [varchar](100) NULL,	[Midia] [varchar](100) NULL,	[Campanha] [varchar](100) NULL,	[PalavraChave] [varchar](max) NULL,	[Data] [smalldatetime] NOT NULL,	[Cupom] [varchar](50) NULL CONSTRAINT [DF_Carrinho_Cupom]  DEFAULT (''),	[TesteAB] [varchar](1) NULL,	[IdListaDeCompra] [int] NULL,	[IdAfiliado] [int] NULL,	[flagFinalizado] [bit] NOT NULL CONSTRAINT [DF_Carrinho_flagFinalizado]  DEFAULT ((0)),	[codigoPromocao] [int] NULL,	[infoComplCodigoPromocao] [varchar](1000) NULL,	[EntregaAgendada] [bit] NULL,	[DataEntregaAgendada] [datetime] NULL,	[IdPeriodoEntrega] [int] NULL,	[xmlIdFreteValor] [xml] NULL,	[IdOpcaoEntregaExpressa] [int] NULL,	[FlagRespostaPromocao] [bit] NULL,	[RespostaPromocao] [nvarchar](50) NULL, 
CONSTRAINT [PK_Carrinho] PRIMARY KEY CLUSTERED (	[UsuarioGUID],data ASC)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON, FILLFACTOR = 75) ON OrderDateRangeScheme(Data)
) ON OrderDateRangeScheme(Data)
END
go

insert into Carrinho ( UsuarioGUID, CEP, IdFreteEntregaTipo, Parceiro, Midia, Campanha, PalavraChave, Data, Cupom, TesteAB, IdListaDeCompra, flagFinalizado, codigoPromocao, infoComplCodigoPromocao, EntregaAgendada, DataEntregaAgendada, IdPeriodoEntrega, IdOpcaoEntregaExpressa, FlagRespostaPromocao, RespostaPromocao) values ( '00000554-6b32-44f2-8ad4-4cdefa4f9ee2', NULL, 1, NULL, NULL, NULL, NULL, '2012-10-01 00:00:00', NULL, 'B', NULL		, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL)
insert into Carrinho ( UsuarioGUID, CEP, IdFreteEntregaTipo, Parceiro, Midia, Campanha, PalavraChave, Data, Cupom, TesteAB, IdListaDeCompra, flagFinalizado, codigoPromocao, infoComplCodigoPromocao, EntregaAgendada, DataEntregaAgendada, IdPeriodoEntrega, IdOpcaoEntregaExpressa, FlagRespostaPromocao, RespostaPromocao) values ( '00000554-6C32-44f2-8ad4-4cdefa4f9ee2', NULL, 1, NULL, NULL, NULL, NULL, '2012-10-02 00:00:00', NULL, 'B', NULL		, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL)
insert into Carrinho ( UsuarioGUID, CEP, IdFreteEntregaTipo, Parceiro, Midia, Campanha, PalavraChave, Data, Cupom, TesteAB, IdListaDeCompra, flagFinalizado, codigoPromocao, infoComplCodigoPromocao, EntregaAgendada, DataEntregaAgendada, IdPeriodoEntrega, IdOpcaoEntregaExpressa, FlagRespostaPromocao, RespostaPromocao) values ( '00000554-6D32-44f2-8ad4-4cdefa4f9ee2', NULL, 1, NULL, NULL, NULL, NULL, '2012-10-03 00:00:00', NULL, 'B', NULL		, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL)
insert into Carrinho ( UsuarioGUID, CEP, IdFreteEntregaTipo, Parceiro, Midia, Campanha, PalavraChave, Data, Cupom, TesteAB, IdListaDeCompra, flagFinalizado, codigoPromocao, infoComplCodigoPromocao, EntregaAgendada, DataEntregaAgendada, IdPeriodoEntrega, IdOpcaoEntregaExpressa, FlagRespostaPromocao, RespostaPromocao) values ( '00000554-6E32-44f2-8ad4-4cdefa4f9ee2', NULL, 1, NULL, NULL, NULL, NULL, '2012-10-04 00:00:00', NULL, 'B', NULL		, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL)
insert into Carrinho ( UsuarioGUID, CEP, IdFreteEntregaTipo, Parceiro, Midia, Campanha, PalavraChave, Data, Cupom, TesteAB, IdListaDeCompra, flagFinalizado, codigoPromocao, infoComplCodigoPromocao, EntregaAgendada, DataEntregaAgendada, IdPeriodoEntrega, IdOpcaoEntregaExpressa, FlagRespostaPromocao, RespostaPromocao) values ( '00000554-6F32-44f2-8ad4-4cdefa4f9ee2', NULL, 1, NULL, NULL, NULL, NULL, '2012-10-05 00:00:00', NULL, 'B', NULL		, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL)
insert into Carrinho ( UsuarioGUID, CEP, IdFreteEntregaTipo, Parceiro, Midia, Campanha, PalavraChave, Data, Cupom, TesteAB, IdListaDeCompra, flagFinalizado, codigoPromocao, infoComplCodigoPromocao, EntregaAgendada, DataEntregaAgendada, IdPeriodoEntrega, IdOpcaoEntregaExpressa, FlagRespostaPromocao, RespostaPromocao) values ( '00000554-6G32-44f2-8ad4-4cdefa4f9ee2', NULL, 1, NULL, NULL, NULL, NULL, '2012-11-30 00:00:00.000', NULL, 'B', NULL	, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL)
insert into Carrinho ( UsuarioGUID, CEP, IdFreteEntregaTipo, Parceiro, Midia, Campanha, PalavraChave, Data, Cupom, TesteAB, IdListaDeCompra, flagFinalizado, codigoPromocao, infoComplCodigoPromocao, EntregaAgendada, DataEntregaAgendada, IdPeriodoEntrega, IdOpcaoEntregaExpressa, FlagRespostaPromocao, RespostaPromocao) values ( '00000554-6H32-44f2-8ad4-4cdefa4f9ee2', NULL, 1, NULL, NULL, NULL, NULL, '2012-11-01 00:00:00.000', NULL, 'B', NULL	, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL)
insert into Carrinho ( UsuarioGUID, CEP, IdFreteEntregaTipo, Parceiro, Midia, Campanha, PalavraChave, Data, Cupom, TesteAB, IdListaDeCompra, flagFinalizado, codigoPromocao, infoComplCodigoPromocao, EntregaAgendada, DataEntregaAgendada, IdPeriodoEntrega, IdOpcaoEntregaExpressa, FlagRespostaPromocao, RespostaPromocao) values ( '00000554-6J32-44f2-8ad4-4cdefa4f9ee2', NULL, 1, NULL, NULL, NULL, NULL, '2012-11-02 00:00:00.000', NULL, 'B', NULL	, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL)
insert into Carrinho ( UsuarioGUID, CEP, IdFreteEntregaTipo, Parceiro, Midia, Campanha, PalavraChave, Data, Cupom, TesteAB, IdListaDeCompra, flagFinalizado, codigoPromocao, infoComplCodigoPromocao, EntregaAgendada, DataEntregaAgendada, IdPeriodoEntrega, IdOpcaoEntregaExpressa, FlagRespostaPromocao, RespostaPromocao) values ( '00000554-6K32-44f2-8ad4-4cdefa4f9ee2', NULL, 1, NULL, NULL, NULL, NULL, '2012-11-03 00:00:00.000', NULL, 'B', NULL	, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL)
insert into Carrinho ( UsuarioGUID, CEP, IdFreteEntregaTipo, Parceiro, Midia, Campanha, PalavraChave, Data, Cupom, TesteAB, IdListaDeCompra, flagFinalizado, codigoPromocao, infoComplCodigoPromocao, EntregaAgendada, DataEntregaAgendada, IdPeriodoEntrega, IdOpcaoEntregaExpressa, FlagRespostaPromocao, RespostaPromocao) values ( '00000554-6L32-44f2-8ad4-4cdefa4f9ee2', NULL, 1, NULL, NULL, NULL, NULL, '2012-11-04 00:00:00.000', NULL, 'B', NULL	, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL)
*/



-- checking the metadata
SELECT * FROM sys.partitions WHERE object_id = OBJECT_ID('carrinho')
SELECT * FROM sys.partition_range_values;


DECLARE @RANGE SMALLDATETIME
SELECT @RANGE = CONVERT(DATETIME,[value]) FROM sys.partition_range_values

SELECT TOP 100 Data, $Partition.OrderDateRangePFN(Data) AS [Partition] FROM Carrinho 
WHERE 1=1 AND Data <= @RANGE
ORDER BY Data,[Partition]


SELECT TOP 100 Data, $Partition.OrderDateRangePFN(Data) AS [Partition] FROM Carrinho 
WHERE CONVERT(DATETIME,Data,120) > @RANGE
ORDER BY Data,[Partition]

------------------------

-- cleaning the staging table
TRUNCATE TABLE carrinhodeletar

-- switching partitions between tables
ALTER TABLE dbo.Carrinho
SWITCH PARTITION 1 TO dbo.carrinhodeletar PARTITION 1
GO

ALTER PARTITION SCHEME OrderDateRangeScheme NEXT USED [primary]
GO

DECLARE @RANGE SMALLDATETIME
DECLARE @NEWRANGE SMALLDATETIME
SELECT @RANGE = CONVERT(DATETIME,[value]) FROM sys.partition_range_values
SELECT @NEWRANGE = DATEADD(M,3,@RANGE)

-- spliting and merging the partitions
ALTER PARTITION FUNCTION OrderDateRangePFN()
SPLIT RANGE (@NEWRANGE);

ALTER PARTITION FUNCTION OrderDateRangePFN()
MERGE RANGE (@RANGE);


