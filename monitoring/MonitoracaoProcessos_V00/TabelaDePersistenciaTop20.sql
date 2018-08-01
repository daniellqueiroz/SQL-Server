CREATE TABLE [dbo].[MaisPesadasPF]
(
DataHora DATETIME2 NOT null
,[query_rank] [bigint] NOT NULL,
[execution_count] [bigint] NOT NULL,
[DBName] [nvarchar] (128) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[text] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[tempo_medio] [bigint] NULL,
[Calls/Second] [numeric] (19, 0) NULL,
[Calls/Minute] [numeric] (19, 0) NULL,
[DuracaoDaUltimaChamada] [bigint] NULL,
[last_execution_time] [datetime] NULL,
[last_logical_reads] [bigint] NOT NULL,
[last_physical_reads] [bigint] NOT NULL,
[plan_handle] [varbinary] (64) NULL,
[last_worker_time] [bigint] NOT NULL,
[total_worker_time] [bigint] NOT NULL,
[modify_date] [datetime] NULL
,CONSTRAINT PK_MaisPesadasPF PRIMARY KEY(DataHora,query_rank)
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO

CREATE TABLE [dbo].[MaisPesadasEX]
(
DataHora DATETIME2 NOT null
,[query_rank] [bigint] NOT NULL,
[execution_count] [bigint] NOT NULL,
[DBName] [nvarchar] (128) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[text] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[tempo_medio] [bigint] NULL,
[Calls/Second] [numeric] (19, 0) NULL,
[Calls/Minute] [numeric] (19, 0) NULL,
[DuracaoDaUltimaChamada] [bigint] NULL,
[last_execution_time] [datetime] NULL,
[last_logical_reads] [bigint] NOT NULL,
[last_physical_reads] [bigint] NOT NULL,
[plan_handle] [varbinary] (64) NULL,
[last_worker_time] [bigint] NOT NULL,
[total_worker_time] [bigint] NOT NULL,
[modify_date] [datetime] NULL
,CONSTRAINT PK_MaisPesadasEX PRIMARY KEY(DataHora,query_rank)
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO


CREATE TABLE [dbo].[MaisPesadasCB]
(
DataHora DATETIME2 NOT null
,[query_rank] [bigint] NOT NULL,
[execution_count] [bigint] NOT NULL,
[DBName] [nvarchar] (128) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[text] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[tempo_medio] [bigint] NULL,
[Calls/Second] [numeric] (19, 0) NULL,
[Calls/Minute] [numeric] (19, 0) NULL,
[DuracaoDaUltimaChamada] [bigint] NULL,
[last_execution_time] [datetime] NULL,
[last_logical_reads] [bigint] NOT NULL,
[last_physical_reads] [bigint] NOT NULL,
[plan_handle] [varbinary] (64) NULL,
[last_worker_time] [bigint] NOT NULL,
[total_worker_time] [bigint] NOT NULL,
[modify_date] [datetime] NULL
,CONSTRAINT PK_MaisPesadasCB PRIMARY KEY(DataHora,query_rank)
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO


CREATE TABLE [dbo].[MaisPesadasCorp]
(
DataHora DATETIME2 NOT null
,[query_rank] [bigint] NOT NULL,
[execution_count] [bigint] NOT NULL,
[DBName] [nvarchar] (128) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[text] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[tempo_medio] [bigint] NULL,
[Calls/Second] [numeric] (19, 0) NULL,
[Calls/Minute] [numeric] (19, 0) NULL,
[DuracaoDaUltimaChamada] [bigint] NULL,
[last_execution_time] [datetime] NULL,
[last_logical_reads] [bigint] NOT NULL,
[last_physical_reads] [bigint] NOT NULL,
[plan_handle] [varbinary] (64) NULL,
[last_worker_time] [bigint] NOT NULL,
[total_worker_time] [bigint] NOT NULL,
[modify_date] [datetime] NULL
,CONSTRAINT PK_MaisPesadasCorp PRIMARY KEY(DataHora,query_rank)
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO

