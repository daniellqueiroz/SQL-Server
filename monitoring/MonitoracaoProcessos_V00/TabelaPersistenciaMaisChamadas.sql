USE [Monitoria]
GO

/****** Object:  Table [dbo].[MaisChamadasPFSecundario]    Script Date: 28/11/2017 19:11:39 ******/
DROP TABLE [dbo].[MaisChamadasPFSecundario]
GO

/****** Object:  Table [dbo].[MaisChamadasPF]    Script Date: 28/11/2017 19:11:39 ******/
DROP TABLE [dbo].[MaisChamadasPF]
GO

/****** Object:  Table [dbo].[MaisChamadasNike]    Script Date: 28/11/2017 19:11:39 ******/
DROP TABLE [dbo].[MaisChamadasNike]
GO

/****** Object:  Table [dbo].[MaisChamadasEXSecundario]    Script Date: 28/11/2017 19:11:39 ******/
DROP TABLE [dbo].[MaisChamadasEXSecundario]
GO

/****** Object:  Table [dbo].[MaisChamadasEX]    Script Date: 28/11/2017 19:11:39 ******/
DROP TABLE [dbo].[MaisChamadasEX]
GO

/****** Object:  Table [dbo].[MaisChamadasCORPSecundario]    Script Date: 28/11/2017 19:11:39 ******/
DROP TABLE [dbo].[MaisChamadasCORPSecundario]
GO

/****** Object:  Table [dbo].[MaisChamadasCorp]    Script Date: 28/11/2017 19:11:39 ******/
DROP TABLE [dbo].[MaisChamadasCorp]
GO

/****** Object:  Table [dbo].[MaisChamadasCBSecundario]    Script Date: 28/11/2017 19:11:39 ******/
DROP TABLE [dbo].[MaisChamadasCBSecundario]
GO

/****** Object:  Table [dbo].[MaisChamadasCB]    Script Date: 28/11/2017 19:11:39 ******/
DROP TABLE [dbo].[MaisChamadasCB]
GO

/****** Object:  Table [dbo].[MaisChamadasB2B2CSecundario]    Script Date: 28/11/2017 19:11:39 ******/
DROP TABLE [dbo].[MaisChamadasB2B2CSecundario]
GO

/****** Object:  Table [dbo].[MaisChamadasB2B2C]    Script Date: 28/11/2017 19:11:39 ******/
DROP TABLE [dbo].[MaisChamadasB2B2C]
GO

/****** Object:  Table [dbo].[MaisChamadasB2B2C]    Script Date: 28/11/2017 19:11:39 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[MaisChamadasB2B2C](
	[DataHora] [datetime2](7) NOT NULL,
	[query_rank] [bigint] NOT NULL,
	[execution_count] [bigint] NOT NULL,
	[DBName] [nvarchar](128) NULL,
	[text] [nvarchar](max) NULL,
	[tempo_medio] [bigint] NULL,
	[Calls/Second] [numeric](19, 0) NULL,
	[Calls/Minute] [numeric](19, 0) NULL,
	[DuracaoDaUltimaChamada] [bigint] NULL,
	[last_execution_time] [datetime] NULL,
	[last_logical_reads] [bigint] NOT NULL,
	[last_physical_reads] [bigint] NOT NULL,
	[plan_handle] [varbinary](64) NULL,
	[last_worker_time] [bigint] NOT NULL,
	[total_worker_time] [bigint] NOT NULL,
	[modify_date] [datetime] NULL,
 CONSTRAINT [PK_MaisChamadasB2B2C] PRIMARY KEY CLUSTERED 
(
	[DataHora] ASC,
	[query_rank] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO

/****** Object:  Table [dbo].[MaisChamadasB2B2CSecundario]    Script Date: 28/11/2017 19:11:39 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[MaisChamadasB2B2CSecundario](
	[DataHora] [datetime2](7) NOT NULL,
	[query_rank] [bigint] NOT NULL,
	[execution_count] [bigint] NOT NULL,
	[DBName] [nvarchar](128) NULL,
	[text] [nvarchar](max) NULL,
	[tempo_medio] [bigint] NULL,
	[Calls/Second] [numeric](19, 0) NULL,
	[Calls/Minute] [numeric](19, 0) NULL,
	[DuracaoDaUltimaChamada] [bigint] NULL,
	[last_execution_time] [datetime] NULL,
	[last_logical_reads] [bigint] NOT NULL,
	[last_physical_reads] [bigint] NOT NULL,
	[plan_handle] [varbinary](64) NULL,
	[last_worker_time] [bigint] NOT NULL,
	[total_worker_time] [bigint] NOT NULL,
	[modify_date] [datetime] NULL,
 CONSTRAINT [PK_MaisChamadasB2B2CSecundario] PRIMARY KEY CLUSTERED 
(
	[DataHora] ASC,
	[query_rank] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO

/****** Object:  Table [dbo].[MaisChamadasCB]    Script Date: 28/11/2017 19:11:39 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[MaisChamadasCB](
	[DataHora] [datetime2](7) NOT NULL,
	[query_rank] [bigint] NOT NULL,
	[execution_count] [bigint] NOT NULL,
	[DBName] [nvarchar](128) NULL,
	[text] [nvarchar](max) NULL,
	[tempo_medio] [bigint] NULL,
	[Calls/Second] [numeric](19, 0) NULL,
	[Calls/Minute] [numeric](19, 0) NULL,
	[DuracaoDaUltimaChamada] [bigint] NULL,
	[last_execution_time] [datetime] NULL,
	[last_logical_reads] [bigint] NOT NULL,
	[last_physical_reads] [bigint] NOT NULL,
	[plan_handle] [varbinary](64) NULL,
	[last_worker_time] [bigint] NOT NULL,
	[total_worker_time] [bigint] NOT NULL,
	[modify_date] [datetime] NULL,
 CONSTRAINT [PK_MaisChamadasCB] PRIMARY KEY CLUSTERED 
(
	[DataHora] ASC,
	[query_rank] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO

/****** Object:  Table [dbo].[MaisChamadasCBSecundario]    Script Date: 28/11/2017 19:11:39 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[MaisChamadasCBSecundario](
	[DataHora] [datetime2](7) NOT NULL,
	[query_rank] [bigint] NOT NULL,
	[execution_count] [bigint] NOT NULL,
	[DBName] [nvarchar](128) NULL,
	[text] [nvarchar](max) NULL,
	[tempo_medio] [bigint] NULL,
	[Calls/Second] [numeric](19, 0) NULL,
	[Calls/Minute] [numeric](19, 0) NULL,
	[DuracaoDaUltimaChamada] [bigint] NULL,
	[last_execution_time] [datetime] NULL,
	[last_logical_reads] [bigint] NOT NULL,
	[last_physical_reads] [bigint] NOT NULL,
	[plan_handle] [varbinary](64) NULL,
	[last_worker_time] [bigint] NOT NULL,
	[total_worker_time] [bigint] NOT NULL,
	[modify_date] [datetime] NULL,
 CONSTRAINT [PK_MaisChamadasCBSecundario] PRIMARY KEY CLUSTERED 
(
	[DataHora] ASC,
	[query_rank] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO

/****** Object:  Table [dbo].[MaisChamadasCorp]    Script Date: 28/11/2017 19:11:39 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[MaisChamadasCorp](
	[DataHora] [datetime2](7) NOT NULL,
	[query_rank] [bigint] NOT NULL,
	[execution_count] [bigint] NOT NULL,
	[DBName] [nvarchar](128) NULL,
	[text] [nvarchar](max) NULL,
	[tempo_medio] [bigint] NULL,
	[Calls/Second] [numeric](19, 0) NULL,
	[Calls/Minute] [numeric](19, 0) NULL,
	[DuracaoDaUltimaChamada] [bigint] NULL,
	[last_execution_time] [datetime] NULL,
	[last_logical_reads] [bigint] NOT NULL,
	[last_physical_reads] [bigint] NOT NULL,
	[plan_handle] [varbinary](64) NULL,
	[last_worker_time] [bigint] NOT NULL,
	[total_worker_time] [bigint] NOT NULL,
	[modify_date] [datetime] NULL,
 CONSTRAINT [PK_MaisChamadasCorp] PRIMARY KEY CLUSTERED 
(
	[DataHora] ASC,
	[query_rank] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO

/****** Object:  Table [dbo].[MaisChamadasCORPSecundario]    Script Date: 28/11/2017 19:11:39 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[MaisChamadasCORPSecundario](
	[DataHora] [datetime2](7) NOT NULL,
	[query_rank] [bigint] NOT NULL,
	[execution_count] [bigint] NOT NULL,
	[DBName] [nvarchar](128) NULL,
	[text] [nvarchar](max) NULL,
	[tempo_medio] [bigint] NULL,
	[Calls/Second] [numeric](19, 0) NULL,
	[Calls/Minute] [numeric](19, 0) NULL,
	[DuracaoDaUltimaChamada] [bigint] NULL,
	[last_execution_time] [datetime] NULL,
	[last_logical_reads] [bigint] NOT NULL,
	[last_physical_reads] [bigint] NOT NULL,
	[plan_handle] [varbinary](64) NULL,
	[last_worker_time] [bigint] NOT NULL,
	[total_worker_time] [bigint] NOT NULL,
	[modify_date] [datetime] NULL,
 CONSTRAINT [PK_MaisChamadasCORPSecundario] PRIMARY KEY CLUSTERED 
(
	[DataHora] ASC,
	[query_rank] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO

/****** Object:  Table [dbo].[MaisChamadasEX]    Script Date: 28/11/2017 19:11:39 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[MaisChamadasEX](
	[DataHora] [datetime2](7) NOT NULL,
	[query_rank] [bigint] NOT NULL,
	[execution_count] [bigint] NOT NULL,
	[DBName] [nvarchar](128) NULL,
	[text] [nvarchar](max) NULL,
	[tempo_medio] [bigint] NULL,
	[Calls/Second] [numeric](19, 0) NULL,
	[Calls/Minute] [numeric](19, 0) NULL,
	[DuracaoDaUltimaChamada] [bigint] NULL,
	[last_execution_time] [datetime] NULL,
	[last_logical_reads] [bigint] NOT NULL,
	[last_physical_reads] [bigint] NOT NULL,
	[plan_handle] [varbinary](64) NULL,
	[last_worker_time] [bigint] NOT NULL,
	[total_worker_time] [bigint] NOT NULL,
	[modify_date] [datetime] NULL,
 CONSTRAINT [PK_MaisChamadasEX] PRIMARY KEY CLUSTERED 
(
	[DataHora] ASC,
	[query_rank] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO

/****** Object:  Table [dbo].[MaisChamadasEXSecundario]    Script Date: 28/11/2017 19:11:39 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[MaisChamadasEXSecundario](
	[DataHora] [datetime2](7) NOT NULL,
	[query_rank] [bigint] NOT NULL,
	[execution_count] [bigint] NOT NULL,
	[DBName] [nvarchar](128) NULL,
	[text] [nvarchar](max) NULL,
	[tempo_medio] [bigint] NULL,
	[Calls/Second] [numeric](19, 0) NULL,
	[Calls/Minute] [numeric](19, 0) NULL,
	[DuracaoDaUltimaChamada] [bigint] NULL,
	[last_execution_time] [datetime] NULL,
	[last_logical_reads] [bigint] NOT NULL,
	[last_physical_reads] [bigint] NOT NULL,
	[plan_handle] [varbinary](64) NULL,
	[last_worker_time] [bigint] NOT NULL,
	[total_worker_time] [bigint] NOT NULL,
	[modify_date] [datetime] NULL,
 CONSTRAINT [PK_MaisChamadasEXSecundario] PRIMARY KEY CLUSTERED 
(
	[DataHora] ASC,
	[query_rank] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO

/****** Object:  Table [dbo].[MaisChamadasNike]    Script Date: 28/11/2017 19:11:39 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[MaisChamadasNike](
	[DataHora] [datetime2](7) NOT NULL,
	[query_rank] [bigint] NOT NULL,
	[execution_count] [bigint] NOT NULL,
	[DBName] [nvarchar](128) NULL,
	[text] [nvarchar](max) NULL,
	[tempo_medio] [bigint] NULL,
	[Calls/Second] [numeric](19, 0) NULL,
	[Calls/Minute] [numeric](19, 0) NULL,
	[DuracaoDaUltimaChamada] [bigint] NULL,
	[last_execution_time] [datetime] NULL,
	[last_logical_reads] [bigint] NOT NULL,
	[last_physical_reads] [bigint] NOT NULL,
	[plan_handle] [varbinary](64) NULL,
	[last_worker_time] [bigint] NOT NULL,
	[total_worker_time] [bigint] NOT NULL,
	[modify_date] [datetime] NULL,
 CONSTRAINT [PK_MaisChamadasNike] PRIMARY KEY CLUSTERED 
(
	[DataHora] ASC,
	[query_rank] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO

/****** Object:  Table [dbo].[MaisChamadasPF]    Script Date: 28/11/2017 19:11:39 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[MaisChamadasPF](
	[DataHora] [DATETIME2](7) NOT NULL,
	[query_rank] [BIGINT] NOT NULL,
	[execution_count] [BIGINT] NOT NULL,
	[DBName] [NVARCHAR](128) NULL,
	[text] [NVARCHAR](MAX) NULL,
	[tempo_medio] [BIGINT] NULL,
	[Calls/Second] [NUMERIC](19, 0) NULL,
	[Calls/Minute] [NUMERIC](19, 0) NULL,
	[DuracaoDaUltimaChamada] [BIGINT] NULL,
	[last_execution_time] [DATETIME] NULL,
	[last_logical_reads] [BIGINT] NOT NULL,
	[last_physical_reads] [BIGINT] NOT NULL,
	[plan_handle] [VARBINARY](64) NULL,
	[last_worker_time] [BIGINT] NOT NULL,
	[total_worker_time] [BIGINT] NOT NULL,
	[modify_date] [DATETIME] NULL,
 CONSTRAINT [PK_MaisChamadasPF] PRIMARY KEY CLUSTERED 
(
	[DataHora] ASC,
	[query_rank] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO

/****** Object:  Table [dbo].[MaisChamadasPFSecundario]    Script Date: 28/11/2017 19:11:39 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[MaisChamadasPFSecundario](
	[DataHora] [DATETIME2](7) NOT NULL,
	[query_rank] [BIGINT] NOT NULL,
	[execution_count] [BIGINT] NOT NULL,
	[DBName] [NVARCHAR](128) NULL,
	[text] [NVARCHAR](MAX) NULL,
	[tempo_medio] [BIGINT] NULL,
	[Calls/Second] [NUMERIC](19, 0) NULL,
	[Calls/Minute] [NUMERIC](19, 0) NULL,
	[DuracaoDaUltimaChamada] [BIGINT] NULL,
	[last_execution_time] [DATETIME] NULL,
	[last_logical_reads] [BIGINT] NOT NULL,
	[last_physical_reads] [BIGINT] NOT NULL,
	[plan_handle] [VARBINARY](64) NULL,
	[last_worker_time] [BIGINT] NOT NULL,
	[total_worker_time] [BIGINT] NOT NULL,
	[modify_date] [DATETIME] NULL,
 CONSTRAINT [PK_MaisChamadasPFSecundario] PRIMARY KEY CLUSTERED 
(
	[DataHora] ASC,
	[query_rank] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO


