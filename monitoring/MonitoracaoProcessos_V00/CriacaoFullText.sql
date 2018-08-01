IF  EXISTS (SELECT * FROM sys.fulltext_indexes fti WHERE fti.object_id = OBJECT_ID(N'[dbo].[WaitsPFPrimario]'))
ALTER FULLTEXT INDEX ON dbo.WaitsPFPrimario DISABLE
GO
IF  EXISTS (SELECT * FROM sys.fulltext_indexes fti WHERE fti.object_id = OBJECT_ID(N'[dbo].[WaitsPFPrimario]'))
DROP FULLTEXT INDEX ON dbo.WaitsPFPrimario
GO

-- ATENÇÃO!!!! ALTERAR AQUI O CAMINHO FÍSICO DO CATÁLOGO!!! VER SE O CAMINHO FÍSICO ESPECIFICADO EXISTE
CREATE FULLTEXT CATALOG BuscaWaits
WITH ACCENT_SENSITIVITY = ON
AS DEFAULT
AUTHORIZATION dbo
GO

IF not EXISTS (SELECT * FROM sys.fulltext_indexes fti WHERE fti.object_id = OBJECT_ID(N'[dbo].[WaitsPFPrimario]'))
CREATE FULLTEXT INDEX ON dbo.WaitsPFPrimario(
Query LANGUAGE 1033,
Query2 LANGUAGE 1033,
Query3 LANGUAGE 1033,
Query4 LANGUAGE 1033)
KEY INDEX IX_Unique_Waits ON BuscaWaits
WITH CHANGE_TRACKING AUTO
GO
IF not EXISTS (SELECT * FROM sys.fulltext_indexes fti WHERE fti.object_id = OBJECT_ID(N'[dbo].[WaitsCBPrimario]'))
CREATE FULLTEXT INDEX ON dbo.WaitsCBPrimario(
Query LANGUAGE 1033,
Query2 LANGUAGE 1033,
Query3 LANGUAGE 1033,
Query4 LANGUAGE 1033)
KEY INDEX IX_Unique_Waits ON BuscaWaits
WITH CHANGE_TRACKING AUTO
GO
IF not EXISTS (SELECT * FROM sys.fulltext_indexes fti WHERE fti.object_id = OBJECT_ID(N'[dbo].[WaitsEXPrimario]'))
CREATE FULLTEXT INDEX ON dbo.WaitsEXPrimario(
Query LANGUAGE 1033,
Query2 LANGUAGE 1033,
Query3 LANGUAGE 1033,
Query4 LANGUAGE 1033)
KEY INDEX IX_Unique_Waits ON BuscaWaits
WITH CHANGE_TRACKING AUTO
GO
IF not EXISTS (SELECT * FROM sys.fulltext_indexes fti WHERE fti.object_id = OBJECT_ID(N'[dbo].[WaitsEXSecundario]'))
CREATE FULLTEXT INDEX ON dbo.WaitsEXSecundario(
Query LANGUAGE 1033,
Query2 LANGUAGE 1033,
Query3 LANGUAGE 1033,
Query4 LANGUAGE 1033)
KEY INDEX IX_Unique_Waits ON BuscaWaits
WITH CHANGE_TRACKING AUTO
GO
IF not EXISTS (SELECT * FROM sys.fulltext_indexes fti WHERE fti.object_id = OBJECT_ID(N'[dbo].[WaitsCORPPrimario]'))
CREATE FULLTEXT INDEX ON dbo.WaitsCORPPrimario(
Query LANGUAGE 1033,
Query2 LANGUAGE 1033,
Query3 LANGUAGE 1033,
Query4 LANGUAGE 1033)
KEY INDEX IX_Unique_Waits ON BuscaWaits
WITH CHANGE_TRACKING AUTO
GO


ALTER TABLE dbo.WaitsCBPrimario DROP COLUMN IdRegistro
ALTER TABLE dbo.WaitsCORPPrimario DROP COLUMN IdRegistro
ALTER TABLE dbo.WaitsEXPrimario DROP COLUMN IdRegistro
ALTER TABLE dbo.WaitsPFPrimario DROP COLUMN IdRegistro

ALTER TABLE dbo.WaitsCBPrimario ADD IdRegistro BIGINT NOT NULL IDENTITY(-9223372036854775808,1)
ALTER TABLE dbo.WaitsCORPPrimario ADD IdRegistro BIGINT NOT NULL IDENTITY(-9223372036854775808,1)
ALTER TABLE dbo.WaitsEXPrimario ADD IdRegistro BIGINT NOT NULL IDENTITY(-9223372036854775808,1)
ALTER TABLE dbo.WaitsPFPrimario ADD IdRegistro BIGINT NOT NULL IDENTITY(-9223372036854775808,1)

drop INDEX IX_Unique_Waits ON dbo.WaitsCBPrimario
drop INDEX IX_Unique_Waits ON dbo.WaitsCORPPrimario
drop INDEX IX_Unique_Waits ON dbo.WaitsEXPrimario
drop INDEX IX_Unique_Waits ON dbo.WaitsPFPrimario

CREATE UNIQUE NONCLUSTERED INDEX IX_Unique_Waits ON dbo.WaitsCBPrimario(IdRegistro)
CREATE UNIQUE NONCLUSTERED INDEX IX_Unique_Waits ON dbo.WaitsCORPPrimario(IdRegistro)
CREATE UNIQUE NONCLUSTERED INDEX IX_Unique_Waits ON dbo.WaitsEXPrimario(IdRegistro)
CREATE UNIQUE NONCLUSTERED INDEX IX_Unique_Waits ON dbo.WaitsPFPrimario(IdRegistro)


CREATE TABLE dbo.WaitsPFPrimario
(
session_id smallint NOT NULL,
wait_duration_ms bigint NULL,
wait_type nvarchar (60) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
Query nvarchar (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
hostname nchar (128) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
loginame nchar (128) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
blocked smallint NULL,
Query2 nvarchar (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
LoginQ2 nchar (128) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
HostQ2 nchar (128) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
BlockQ2 smallint NULL,
WaitQ2 nchar (32) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
Query3 nvarchar (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
LoginQ3 nchar (128) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
HostQ3 nchar (128) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
BlockQ3 smallint NULL,
WaitQ3 nchar (32) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
Query4 nvarchar (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
LoginQ4 nchar (128) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
HostQ4 nchar (128) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
BlockQ4 smallint NULL,
WaitQ4 nchar (32) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
DataHora datetime2 NOT NULL CONSTRAINT DF__WaitsPFPr__DataH__1367E606 DEFAULT (getdate()),
TempoMedio int NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
ALTER TABLE dbo.WaitsPFPrimario ADD CONSTRAINT PK_WaitsPFPrimario PRIMARY KEY CLUSTERED  (DataHora, session_id) ON [PRIMARY]
GO

ALTER FULLTEXT CATALOG BuscaWaits REBUILD