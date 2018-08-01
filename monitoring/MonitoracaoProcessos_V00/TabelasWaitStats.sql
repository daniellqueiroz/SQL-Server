USE [Monitoria]
GO

ALTER TABLE [dbo].[WaitsPFSecundario] DROP CONSTRAINT [DF__WaitsPFSe__DataH__36B12243]
GO

ALTER TABLE [dbo].[WaitsPFPrimario] DROP CONSTRAINT [DF__WaitsPFPr__DataH__1367E606]
GO

ALTER TABLE [dbo].[WaitsNikePrimario] DROP CONSTRAINT [DF__WaitsNike__DataH__0E6FEB08]
GO

ALTER TABLE [dbo].[WaitsEXSecundario] DROP CONSTRAINT [DF__WaitsEXSe__DataH__33D4B598]
GO

ALTER TABLE [dbo].[WaitsEXPrimario] DROP CONSTRAINT [DF__WaitsEXPr__DataH__1273C1CD]
GO

ALTER TABLE [dbo].[WaitsCORPSecundario] DROP CONSTRAINT [DF__WaitsCORP__DataH__30F848ED]
GO

ALTER TABLE [dbo].[WaitsCORPPrimario] DROP CONSTRAINT [DF__WaitsCORP__DataH__239E4DCF]
GO

ALTER TABLE [dbo].[WaitsCDiscountSecundario] DROP CONSTRAINT [DF__WaitsCDis__DataH__1B174FBD]
GO

ALTER TABLE [dbo].[WaitsCDiscountPrimario] DROP CONSTRAINT [DF__WaitsCDis__DataH__7D86ECD6]
GO

ALTER TABLE [dbo].[WaitsCBSecundario] DROP CONSTRAINT [DF__WaitsCBSe__DataH__2E1BDC42]
GO

ALTER TABLE [dbo].[WaitsCBPrimario] DROP CONSTRAINT [DF__WaitsCBPr__DataH__117F9D94]
GO

ALTER TABLE [dbo].[WaitsB2B2CSecundario] DROP CONSTRAINT [DF__WaitsB2B2__DataH__3B2D511C]
GO

ALTER TABLE [dbo].[WaitsB2B2CPrimario] DROP CONSTRAINT [DF__WaitsB2B2__DataH__3E09BDC7]
GO

ALTER TABLE [dbo].[WaitsAtacadoSecundario] DROP CONSTRAINT [DF__WaitsAtac__DataH__4C57DD1E]
GO

ALTER TABLE [dbo].[WaitsAtacadoPrimario] DROP CONSTRAINT [DF__WaitsAtac__DataH__4F3449C9]
GO

ALTER TABLE [dbo].[WaitsAssaiSecundario] DROP CONSTRAINT [DF__WaitsAssa__DataH__20D02913]
GO

ALTER TABLE [dbo].[WaitsAssaiPrimario] DROP CONSTRAINT [DF__WaitsAssa__DataH__1DF3BC68]
GO

/****** Object:  Table [dbo].[WaitsPFSecundario]    Script Date: 28/11/2017 19:09:58 ******/
DROP TABLE [dbo].[WaitsPFSecundario]
GO

/****** Object:  Table [dbo].[WaitsPFPrimario]    Script Date: 28/11/2017 19:09:58 ******/
DROP TABLE [dbo].[WaitsPFPrimario]
GO

/****** Object:  Table [dbo].[WaitsNikePrimario]    Script Date: 28/11/2017 19:09:58 ******/
DROP TABLE [dbo].[WaitsNikePrimario]
GO

/****** Object:  Table [dbo].[WaitsEXSecundario]    Script Date: 28/11/2017 19:09:58 ******/
DROP TABLE [dbo].[WaitsEXSecundario]
GO

/****** Object:  Table [dbo].[WaitsEXPrimario]    Script Date: 28/11/2017 19:09:58 ******/
DROP TABLE [dbo].[WaitsEXPrimario]
GO

/****** Object:  Table [dbo].[WaitsCORPSecundario]    Script Date: 28/11/2017 19:09:58 ******/
DROP TABLE [dbo].[WaitsCORPSecundario]
GO

/****** Object:  Table [dbo].[WaitsCORPPrimario]    Script Date: 28/11/2017 19:09:58 ******/
DROP TABLE [dbo].[WaitsCORPPrimario]
GO

/****** Object:  Table [dbo].[WaitsCDiscountSecundario]    Script Date: 28/11/2017 19:09:58 ******/
DROP TABLE [dbo].[WaitsCDiscountSecundario]
GO

/****** Object:  Table [dbo].[WaitsCDiscountPrimario]    Script Date: 28/11/2017 19:09:58 ******/
DROP TABLE [dbo].[WaitsCDiscountPrimario]
GO

/****** Object:  Table [dbo].[WaitsCBSecundario]    Script Date: 28/11/2017 19:09:58 ******/
DROP TABLE [dbo].[WaitsCBSecundario]
GO

/****** Object:  Table [dbo].[WaitsCBPrimario]    Script Date: 28/11/2017 19:09:58 ******/
DROP TABLE [dbo].[WaitsCBPrimario]
GO

/****** Object:  Table [dbo].[WaitsB2B2CSecundario]    Script Date: 28/11/2017 19:09:58 ******/
DROP TABLE [dbo].[WaitsB2B2CSecundario]
GO

/****** Object:  Table [dbo].[WaitsB2B2CPrimario]    Script Date: 28/11/2017 19:09:58 ******/
DROP TABLE [dbo].[WaitsB2B2CPrimario]
GO

/****** Object:  Table [dbo].[WaitsAtacadoSecundario]    Script Date: 28/11/2017 19:09:58 ******/
DROP TABLE [dbo].[WaitsAtacadoSecundario]
GO

/****** Object:  Table [dbo].[WaitsAtacadoPrimario]    Script Date: 28/11/2017 19:09:58 ******/
DROP TABLE [dbo].[WaitsAtacadoPrimario]
GO

/****** Object:  Table [dbo].[WaitsAssaiSecundario]    Script Date: 28/11/2017 19:09:58 ******/
DROP TABLE [dbo].[WaitsAssaiSecundario]
GO

/****** Object:  Table [dbo].[WaitsAssaiPrimario]    Script Date: 28/11/2017 19:09:58 ******/
DROP TABLE [dbo].[WaitsAssaiPrimario]
GO

/****** Object:  Table [dbo].[WaitsAssaiPrimario]    Script Date: 28/11/2017 19:09:58 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[WaitsAssaiPrimario](
	[session_id] [smallint] NOT NULL,
	[wait_duration_ms] [bigint] NULL,
	[wait_type] [nvarchar](60) NULL,
	[Query] [nvarchar](max) NULL,
	[hostname] [nchar](128) NULL,
	[loginame] [nchar](128) NULL,
	[blocked] [smallint] NULL,
	[Query2] [nvarchar](max) NULL,
	[LoginQ2] [nchar](128) NULL,
	[HostQ2] [nchar](128) NULL,
	[BlockQ2] [smallint] NULL,
	[WaitQ2] [nchar](32) NULL,
	[Query3] [nvarchar](max) NULL,
	[LoginQ3] [nchar](128) NULL,
	[HostQ3] [nchar](128) NULL,
	[BlockQ3] [smallint] NULL,
	[WaitQ3] [nchar](32) NULL,
	[Query4] [nvarchar](max) NULL,
	[LoginQ4] [nchar](128) NULL,
	[HostQ4] [nchar](128) NULL,
	[BlockQ4] [smallint] NULL,
	[WaitQ4] [nchar](32) NULL,
	[DataHora] [datetime2](7) NOT NULL,
	[TempoMedio] [int] NULL,
	[IdRegistro] [bigint] IDENTITY(-9223372036854775808,1) NOT NULL,
 CONSTRAINT [PK_WaitsAssai] PRIMARY KEY CLUSTERED 
(
	[DataHora] ASC,
	[session_id] ASC,
	[IdRegistro] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO

/****** Object:  Table [dbo].[WaitsAssaiSecundario]    Script Date: 28/11/2017 19:09:58 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[WaitsAssaiSecundario](
	[session_id] [smallint] NOT NULL,
	[wait_duration_ms] [bigint] NULL,
	[wait_type] [nvarchar](60) NULL,
	[Query] [nvarchar](max) NULL,
	[hostname] [nchar](128) NULL,
	[loginame] [nchar](128) NULL,
	[blocked] [smallint] NULL,
	[Query2] [nvarchar](max) NULL,
	[LoginQ2] [nchar](128) NULL,
	[HostQ2] [nchar](128) NULL,
	[BlockQ2] [smallint] NULL,
	[WaitQ2] [nchar](32) NULL,
	[Query3] [nvarchar](max) NULL,
	[LoginQ3] [nchar](128) NULL,
	[HostQ3] [nchar](128) NULL,
	[BlockQ3] [smallint] NULL,
	[WaitQ3] [nchar](32) NULL,
	[Query4] [nvarchar](max) NULL,
	[LoginQ4] [nchar](128) NULL,
	[HostQ4] [nchar](128) NULL,
	[BlockQ4] [smallint] NULL,
	[WaitQ4] [nchar](32) NULL,
	[DataHora] [datetime2](7) NOT NULL,
	[TempoMedio] [int] NULL,
	[IdRegistro] [bigint] IDENTITY(-9223372036854775808,1) NOT NULL,
 CONSTRAINT [PK_WaitsAssaiSecundario] PRIMARY KEY CLUSTERED 
(
	[DataHora] ASC,
	[session_id] ASC,
	[IdRegistro] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO

/****** Object:  Table [dbo].[WaitsAtacadoPrimario]    Script Date: 28/11/2017 19:09:58 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[WaitsAtacadoPrimario](
	[session_id] [smallint] NOT NULL,
	[wait_duration_ms] [bigint] NULL,
	[wait_type] [nvarchar](60) NULL,
	[Query] [nvarchar](max) NULL,
	[hostname] [nchar](128) NULL,
	[loginame] [nchar](128) NULL,
	[blocked] [smallint] NULL,
	[Query2] [nvarchar](max) NULL,
	[LoginQ2] [nchar](128) NULL,
	[HostQ2] [nchar](128) NULL,
	[BlockQ2] [smallint] NULL,
	[WaitQ2] [nchar](32) NULL,
	[Query3] [nvarchar](max) NULL,
	[LoginQ3] [nchar](128) NULL,
	[HostQ3] [nchar](128) NULL,
	[BlockQ3] [smallint] NULL,
	[WaitQ3] [nchar](32) NULL,
	[Query4] [nvarchar](max) NULL,
	[LoginQ4] [nchar](128) NULL,
	[HostQ4] [nchar](128) NULL,
	[BlockQ4] [smallint] NULL,
	[WaitQ4] [nchar](32) NULL,
	[DataHora] [datetime2](7) NOT NULL,
	[TempoMedio] [int] NULL,
	[IdRegistro] [bigint] IDENTITY(-9223372036854775807,1) NOT NULL,
 CONSTRAINT [PK_WaitsAtacadoPrimario] PRIMARY KEY CLUSTERED 
(
	[DataHora] ASC,
	[session_id] ASC,
	[IdRegistro] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO

/****** Object:  Table [dbo].[WaitsAtacadoSecundario]    Script Date: 28/11/2017 19:09:58 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[WaitsAtacadoSecundario](
	[session_id] [smallint] NOT NULL,
	[wait_duration_ms] [bigint] NULL,
	[wait_type] [nvarchar](60) NULL,
	[Query] [nvarchar](max) NULL,
	[hostname] [nchar](128) NULL,
	[loginame] [nchar](128) NULL,
	[blocked] [smallint] NULL,
	[Query2] [nvarchar](max) NULL,
	[LoginQ2] [nchar](128) NULL,
	[HostQ2] [nchar](128) NULL,
	[BlockQ2] [smallint] NULL,
	[WaitQ2] [nchar](32) NULL,
	[Query3] [nvarchar](max) NULL,
	[LoginQ3] [nchar](128) NULL,
	[HostQ3] [nchar](128) NULL,
	[BlockQ3] [smallint] NULL,
	[WaitQ3] [nchar](32) NULL,
	[Query4] [nvarchar](max) NULL,
	[LoginQ4] [nchar](128) NULL,
	[HostQ4] [nchar](128) NULL,
	[BlockQ4] [smallint] NULL,
	[WaitQ4] [nchar](32) NULL,
	[DataHora] [datetime2](7) NOT NULL,
	[TempoMedio] [int] NULL,
	[IdRegistro] [bigint] IDENTITY(-9223372036854775807,1) NOT NULL,
 CONSTRAINT [PK_WaitsAtacadoSecundario] PRIMARY KEY CLUSTERED 
(
	[DataHora] ASC,
	[session_id] ASC,
	[IdRegistro] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO

/****** Object:  Table [dbo].[WaitsB2B2CPrimario]    Script Date: 28/11/2017 19:09:58 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[WaitsB2B2CPrimario](
	[session_id] [smallint] NOT NULL,
	[wait_duration_ms] [bigint] NULL,
	[wait_type] [nvarchar](60) NULL,
	[Query] [nvarchar](max) NULL,
	[hostname] [nchar](128) NULL,
	[loginame] [nchar](128) NULL,
	[blocked] [smallint] NULL,
	[Query2] [nvarchar](max) NULL,
	[LoginQ2] [nchar](128) NULL,
	[HostQ2] [nchar](128) NULL,
	[BlockQ2] [smallint] NULL,
	[WaitQ2] [nchar](32) NULL,
	[Query3] [nvarchar](max) NULL,
	[LoginQ3] [nchar](128) NULL,
	[HostQ3] [nchar](128) NULL,
	[BlockQ3] [smallint] NULL,
	[WaitQ3] [nchar](32) NULL,
	[Query4] [nvarchar](max) NULL,
	[LoginQ4] [nchar](128) NULL,
	[HostQ4] [nchar](128) NULL,
	[BlockQ4] [smallint] NULL,
	[WaitQ4] [nchar](32) NULL,
	[DataHora] [datetime2](7) NOT NULL,
	[TempoMedio] [int] NULL,
	[IdRegistro] [bigint] IDENTITY(-9223372036854775807,1) NOT NULL,
 CONSTRAINT [PK_WaitsB2B2CPrimario] PRIMARY KEY CLUSTERED 
(
	[DataHora] ASC,
	[session_id] ASC,
	[IdRegistro] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO

/****** Object:  Table [dbo].[WaitsB2B2CSecundario]    Script Date: 28/11/2017 19:09:58 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[WaitsB2B2CSecundario](
	[session_id] [smallint] NOT NULL,
	[wait_duration_ms] [bigint] NULL,
	[wait_type] [nvarchar](60) NULL,
	[Query] [nvarchar](max) NULL,
	[hostname] [nchar](128) NULL,
	[loginame] [nchar](128) NULL,
	[blocked] [smallint] NULL,
	[Query2] [nvarchar](max) NULL,
	[LoginQ2] [nchar](128) NULL,
	[HostQ2] [nchar](128) NULL,
	[BlockQ2] [smallint] NULL,
	[WaitQ2] [nchar](32) NULL,
	[Query3] [nvarchar](max) NULL,
	[LoginQ3] [nchar](128) NULL,
	[HostQ3] [nchar](128) NULL,
	[BlockQ3] [smallint] NULL,
	[WaitQ3] [nchar](32) NULL,
	[Query4] [nvarchar](max) NULL,
	[LoginQ4] [nchar](128) NULL,
	[HostQ4] [nchar](128) NULL,
	[BlockQ4] [smallint] NULL,
	[WaitQ4] [nchar](32) NULL,
	[DataHora] [datetime2](7) NOT NULL,
	[TempoMedio] [int] NULL,
	[IdRegistro] [bigint] IDENTITY(-9223372036854775807,1) NOT NULL,
 CONSTRAINT [PK_WaitsB2B2CSecundario] PRIMARY KEY CLUSTERED 
(
	[DataHora] ASC,
	[session_id] ASC,
	[IdRegistro] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO

/****** Object:  Table [dbo].[WaitsCBPrimario]    Script Date: 28/11/2017 19:09:58 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[WaitsCBPrimario](
	[session_id] [smallint] NOT NULL,
	[wait_duration_ms] [bigint] NULL,
	[wait_type] [nvarchar](60) NULL,
	[Query] [nvarchar](max) NULL,
	[hostname] [nchar](128) NULL,
	[loginame] [nchar](128) NULL,
	[blocked] [smallint] NULL,
	[Query2] [nvarchar](max) NULL,
	[LoginQ2] [nchar](128) NULL,
	[HostQ2] [nchar](128) NULL,
	[BlockQ2] [smallint] NULL,
	[WaitQ2] [nchar](32) NULL,
	[Query3] [nvarchar](max) NULL,
	[LoginQ3] [nchar](128) NULL,
	[HostQ3] [nchar](128) NULL,
	[BlockQ3] [smallint] NULL,
	[WaitQ3] [nchar](32) NULL,
	[Query4] [nvarchar](max) NULL,
	[LoginQ4] [nchar](128) NULL,
	[HostQ4] [nchar](128) NULL,
	[BlockQ4] [smallint] NULL,
	[WaitQ4] [nchar](32) NULL,
	[DataHora] [datetime2](7) NOT NULL,
	[TempoMedio] [int] NULL,
	[IdRegistro] [bigint] IDENTITY(-9223372036854775808,1) NOT NULL,
 CONSTRAINT [PK_WaitsCBPrimario] PRIMARY KEY CLUSTERED 
(
	[DataHora] ASC,
	[session_id] ASC,
	[IdRegistro] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO

/****** Object:  Table [dbo].[WaitsCBSecundario]    Script Date: 28/11/2017 19:09:58 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[WaitsCBSecundario](
	[session_id] [smallint] NOT NULL,
	[wait_duration_ms] [bigint] NULL,
	[wait_type] [nvarchar](60) NULL,
	[Query] [nvarchar](max) NULL,
	[hostname] [nchar](128) NULL,
	[loginame] [nchar](128) NULL,
	[blocked] [smallint] NULL,
	[Query2] [nvarchar](max) NULL,
	[LoginQ2] [nchar](128) NULL,
	[HostQ2] [nchar](128) NULL,
	[BlockQ2] [smallint] NULL,
	[WaitQ2] [nchar](32) NULL,
	[Query3] [nvarchar](max) NULL,
	[LoginQ3] [nchar](128) NULL,
	[HostQ3] [nchar](128) NULL,
	[BlockQ3] [smallint] NULL,
	[WaitQ3] [nchar](32) NULL,
	[Query4] [nvarchar](max) NULL,
	[LoginQ4] [nchar](128) NULL,
	[HostQ4] [nchar](128) NULL,
	[BlockQ4] [smallint] NULL,
	[WaitQ4] [nchar](32) NULL,
	[DataHora] [datetime2](7) NOT NULL,
	[TempoMedio] [int] NULL,
	[IdRegistro] [bigint] IDENTITY(-9223372036854775807,1) NOT NULL,
 CONSTRAINT [PK_WaitsCBSecundario] PRIMARY KEY CLUSTERED 
(
	[DataHora] ASC,
	[session_id] ASC,
	[IdRegistro] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO

/****** Object:  Table [dbo].[WaitsCDiscountPrimario]    Script Date: 28/11/2017 19:09:58 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[WaitsCDiscountPrimario](
	[session_id] [smallint] NOT NULL,
	[wait_duration_ms] [bigint] NULL,
	[wait_type] [nvarchar](60) NULL,
	[Query] [nvarchar](max) NULL,
	[hostname] [nchar](128) NULL,
	[loginame] [nchar](128) NULL,
	[blocked] [smallint] NULL,
	[Query2] [nvarchar](max) NULL,
	[LoginQ2] [nchar](128) NULL,
	[HostQ2] [nchar](128) NULL,
	[BlockQ2] [smallint] NULL,
	[WaitQ2] [nchar](32) NULL,
	[Query3] [nvarchar](max) NULL,
	[LoginQ3] [nchar](128) NULL,
	[HostQ3] [nchar](128) NULL,
	[BlockQ3] [smallint] NULL,
	[WaitQ3] [nchar](32) NULL,
	[Query4] [nvarchar](max) NULL,
	[LoginQ4] [nchar](128) NULL,
	[HostQ4] [nchar](128) NULL,
	[BlockQ4] [smallint] NULL,
	[WaitQ4] [nchar](32) NULL,
	[DataHora] [datetime2](7) NOT NULL,
	[TempoMedio] [int] NULL,
	[IdRegistro] [bigint] IDENTITY(-9223372036854775808,1) NOT NULL,
 CONSTRAINT [PK_WaitsCDiscount] PRIMARY KEY CLUSTERED 
(
	[DataHora] ASC,
	[session_id] ASC,
	[IdRegistro] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO

/****** Object:  Table [dbo].[WaitsCDiscountSecundario]    Script Date: 28/11/2017 19:09:58 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[WaitsCDiscountSecundario](
	[session_id] [smallint] NOT NULL,
	[wait_duration_ms] [bigint] NULL,
	[wait_type] [nvarchar](60) NULL,
	[Query] [nvarchar](max) NULL,
	[hostname] [nchar](128) NULL,
	[loginame] [nchar](128) NULL,
	[blocked] [smallint] NULL,
	[Query2] [nvarchar](max) NULL,
	[LoginQ2] [nchar](128) NULL,
	[HostQ2] [nchar](128) NULL,
	[BlockQ2] [smallint] NULL,
	[WaitQ2] [nchar](32) NULL,
	[Query3] [nvarchar](max) NULL,
	[LoginQ3] [nchar](128) NULL,
	[HostQ3] [nchar](128) NULL,
	[BlockQ3] [smallint] NULL,
	[WaitQ3] [nchar](32) NULL,
	[Query4] [nvarchar](max) NULL,
	[LoginQ4] [nchar](128) NULL,
	[HostQ4] [nchar](128) NULL,
	[BlockQ4] [smallint] NULL,
	[WaitQ4] [nchar](32) NULL,
	[DataHora] [datetime2](7) NOT NULL,
	[TempoMedio] [int] NULL,
	[IdRegistro] [bigint] IDENTITY(-9223372036854775808,1) NOT NULL,
 CONSTRAINT [PK_WaitsCDiscountSecundario] PRIMARY KEY CLUSTERED 
(
	[DataHora] ASC,
	[session_id] ASC,
	[IdRegistro] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO

/****** Object:  Table [dbo].[WaitsCORPPrimario]    Script Date: 28/11/2017 19:09:58 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[WaitsCORPPrimario](
	[session_id] [smallint] NOT NULL,
	[wait_duration_ms] [bigint] NULL,
	[wait_type] [nvarchar](60) NULL,
	[Query] [nvarchar](max) NULL,
	[hostname] [nchar](128) NULL,
	[loginame] [nchar](128) NULL,
	[blocked] [smallint] NULL,
	[Query2] [nvarchar](max) NULL,
	[LoginQ2] [nchar](128) NULL,
	[HostQ2] [nchar](128) NULL,
	[BlockQ2] [smallint] NULL,
	[WaitQ2] [nchar](32) NULL,
	[Query3] [nvarchar](max) NULL,
	[LoginQ3] [nchar](128) NULL,
	[HostQ3] [nchar](128) NULL,
	[BlockQ3] [smallint] NULL,
	[WaitQ3] [nchar](32) NULL,
	[Query4] [nvarchar](max) NULL,
	[LoginQ4] [nchar](128) NULL,
	[HostQ4] [nchar](128) NULL,
	[BlockQ4] [smallint] NULL,
	[WaitQ4] [nchar](32) NULL,
	[DataHora] [datetime2](7) NOT NULL,
	[TempoMedio] [int] NULL,
	[IdRegistro] [bigint] IDENTITY(-9223372036854775808,1) NOT NULL,
 CONSTRAINT [PK_WaitsCORPPrimario] PRIMARY KEY CLUSTERED 
(
	[DataHora] ASC,
	[session_id] ASC,
	[IdRegistro] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO

/****** Object:  Table [dbo].[WaitsCORPSecundario]    Script Date: 28/11/2017 19:09:58 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[WaitsCORPSecundario](
	[session_id] [smallint] NOT NULL,
	[wait_duration_ms] [bigint] NULL,
	[wait_type] [nvarchar](60) NULL,
	[Query] [nvarchar](max) NULL,
	[hostname] [nchar](128) NULL,
	[loginame] [nchar](128) NULL,
	[blocked] [smallint] NULL,
	[Query2] [nvarchar](max) NULL,
	[LoginQ2] [nchar](128) NULL,
	[HostQ2] [nchar](128) NULL,
	[BlockQ2] [smallint] NULL,
	[WaitQ2] [nchar](32) NULL,
	[Query3] [nvarchar](max) NULL,
	[LoginQ3] [nchar](128) NULL,
	[HostQ3] [nchar](128) NULL,
	[BlockQ3] [smallint] NULL,
	[WaitQ3] [nchar](32) NULL,
	[Query4] [nvarchar](max) NULL,
	[LoginQ4] [nchar](128) NULL,
	[HostQ4] [nchar](128) NULL,
	[BlockQ4] [smallint] NULL,
	[WaitQ4] [nchar](32) NULL,
	[DataHora] [datetime2](7) NOT NULL,
	[TempoMedio] [int] NULL,
 CONSTRAINT [PK_WaitsCORPSecundario] PRIMARY KEY CLUSTERED 
(
	[DataHora] ASC,
	[session_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO

/****** Object:  Table [dbo].[WaitsEXPrimario]    Script Date: 28/11/2017 19:09:58 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[WaitsEXPrimario](
	[session_id] [smallint] NOT NULL,
	[wait_duration_ms] [bigint] NULL,
	[wait_type] [nvarchar](60) NULL,
	[Query] [nvarchar](max) NULL,
	[hostname] [nchar](128) NULL,
	[loginame] [nchar](128) NULL,
	[blocked] [smallint] NULL,
	[Query2] [nvarchar](max) NULL,
	[LoginQ2] [nchar](128) NULL,
	[HostQ2] [nchar](128) NULL,
	[BlockQ2] [smallint] NULL,
	[WaitQ2] [nchar](32) NULL,
	[Query3] [nvarchar](max) NULL,
	[LoginQ3] [nchar](128) NULL,
	[HostQ3] [nchar](128) NULL,
	[BlockQ3] [smallint] NULL,
	[WaitQ3] [nchar](32) NULL,
	[Query4] [nvarchar](max) NULL,
	[LoginQ4] [nchar](128) NULL,
	[HostQ4] [nchar](128) NULL,
	[BlockQ4] [smallint] NULL,
	[WaitQ4] [nchar](32) NULL,
	[DataHora] [datetime2](7) NOT NULL,
	[TempoMedio] [int] NULL,
	[IdRegistro] [bigint] IDENTITY(-9223372036854775808,1) NOT NULL,
 CONSTRAINT [PK_WaitsEXPrimario] PRIMARY KEY CLUSTERED 
(
	[DataHora] ASC,
	[session_id] ASC,
	[IdRegistro] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO

/****** Object:  Table [dbo].[WaitsEXSecundario]    Script Date: 28/11/2017 19:09:58 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[WaitsEXSecundario](
	[session_id] [smallint] NOT NULL,
	[wait_duration_ms] [bigint] NULL,
	[wait_type] [nvarchar](60) NULL,
	[Query] [nvarchar](max) NULL,
	[hostname] [nchar](128) NULL,
	[loginame] [nchar](128) NULL,
	[blocked] [smallint] NULL,
	[Query2] [nvarchar](max) NULL,
	[LoginQ2] [nchar](128) NULL,
	[HostQ2] [nchar](128) NULL,
	[BlockQ2] [smallint] NULL,
	[WaitQ2] [nchar](32) NULL,
	[Query3] [nvarchar](max) NULL,
	[LoginQ3] [nchar](128) NULL,
	[HostQ3] [nchar](128) NULL,
	[BlockQ3] [smallint] NULL,
	[WaitQ3] [nchar](32) NULL,
	[Query4] [nvarchar](max) NULL,
	[LoginQ4] [nchar](128) NULL,
	[HostQ4] [nchar](128) NULL,
	[BlockQ4] [smallint] NULL,
	[WaitQ4] [nchar](32) NULL,
	[DataHora] [datetime2](7) NOT NULL,
	[TempoMedio] [int] NULL,
	[IdRegistro] [bigint] IDENTITY(-9223372036854775807,1) NOT NULL,
 CONSTRAINT [PK_WaitsEXSecundario] PRIMARY KEY CLUSTERED 
(
	[DataHora] ASC,
	[session_id] ASC,
	[IdRegistro] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO

/****** Object:  Table [dbo].[WaitsNikePrimario]    Script Date: 28/11/2017 19:09:58 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[WaitsNikePrimario](
	[session_id] [smallint] NOT NULL,
	[wait_duration_ms] [bigint] NULL,
	[wait_type] [nvarchar](60) NULL,
	[Query] [nvarchar](max) NULL,
	[hostname] [nchar](128) NULL,
	[loginame] [nchar](128) NULL,
	[blocked] [smallint] NULL,
	[Query2] [nvarchar](max) NULL,
	[LoginQ2] [nchar](128) NULL,
	[HostQ2] [nchar](128) NULL,
	[BlockQ2] [smallint] NULL,
	[WaitQ2] [nchar](32) NULL,
	[Query3] [nvarchar](max) NULL,
	[LoginQ3] [nchar](128) NULL,
	[HostQ3] [nchar](128) NULL,
	[BlockQ3] [smallint] NULL,
	[WaitQ3] [nchar](32) NULL,
	[Query4] [nvarchar](max) NULL,
	[LoginQ4] [nchar](128) NULL,
	[HostQ4] [nchar](128) NULL,
	[BlockQ4] [smallint] NULL,
	[WaitQ4] [nchar](32) NULL,
	[DataHora] [datetime2](7) NOT NULL,
	[TempoMedio] [int] NULL,
	[IdRegistro] [bigint] IDENTITY(-9223372036854775808,1) NOT NULL,
 CONSTRAINT [PK_WaitsNikePrimario] PRIMARY KEY CLUSTERED 
(
	[DataHora] ASC,
	[session_id] ASC,
	[IdRegistro] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO

/****** Object:  Table [dbo].[WaitsPFPrimario]    Script Date: 28/11/2017 19:09:58 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[WaitsPFPrimario](
	[session_id] [smallint] NOT NULL,
	[wait_duration_ms] [bigint] NULL,
	[wait_type] [nvarchar](60) NULL,
	[Query] [nvarchar](max) NULL,
	[hostname] [nchar](128) NULL,
	[loginame] [nchar](128) NULL,
	[blocked] [smallint] NULL,
	[Query2] [nvarchar](max) NULL,
	[LoginQ2] [nchar](128) NULL,
	[HostQ2] [nchar](128) NULL,
	[BlockQ2] [smallint] NULL,
	[WaitQ2] [nchar](32) NULL,
	[Query3] [nvarchar](max) NULL,
	[LoginQ3] [nchar](128) NULL,
	[HostQ3] [nchar](128) NULL,
	[BlockQ3] [smallint] NULL,
	[WaitQ3] [nchar](32) NULL,
	[Query4] [nvarchar](max) NULL,
	[LoginQ4] [nchar](128) NULL,
	[HostQ4] [nchar](128) NULL,
	[BlockQ4] [smallint] NULL,
	[WaitQ4] [nchar](32) NULL,
	[DataHora] [datetime2](7) NOT NULL,
	[TempoMedio] [int] NULL,
	[IdRegistro] [bigint] IDENTITY(-9223372036854775808,1) NOT NULL,
 CONSTRAINT [PK_WaitsPFPrimario] PRIMARY KEY CLUSTERED 
(
	[DataHora] ASC,
	[session_id] ASC,
	[IdRegistro] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO

/****** Object:  Table [dbo].[WaitsPFSecundario]    Script Date: 28/11/2017 19:09:58 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[WaitsPFSecundario](
	[session_id] [smallint] NOT NULL,
	[wait_duration_ms] [bigint] NULL,
	[wait_type] [nvarchar](60) NULL,
	[Query] [nvarchar](max) NULL,
	[hostname] [nchar](128) NULL,
	[loginame] [nchar](128) NULL,
	[blocked] [smallint] NULL,
	[Query2] [nvarchar](max) NULL,
	[LoginQ2] [nchar](128) NULL,
	[HostQ2] [nchar](128) NULL,
	[BlockQ2] [smallint] NULL,
	[WaitQ2] [nchar](32) NULL,
	[Query3] [nvarchar](max) NULL,
	[LoginQ3] [nchar](128) NULL,
	[HostQ3] [nchar](128) NULL,
	[BlockQ3] [smallint] NULL,
	[WaitQ3] [nchar](32) NULL,
	[Query4] [nvarchar](max) NULL,
	[LoginQ4] [nchar](128) NULL,
	[HostQ4] [nchar](128) NULL,
	[BlockQ4] [smallint] NULL,
	[WaitQ4] [nchar](32) NULL,
	[DataHora] [datetime2](7) NOT NULL,
	[TempoMedio] [int] NULL,
	[IdRegistro] [bigint] IDENTITY(-9223372036854775807,1) NOT NULL,
 CONSTRAINT [PK_WaitsPFSecundario] PRIMARY KEY CLUSTERED 
(
	[DataHora] ASC,
	[session_id] ASC,
	[IdRegistro] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO

ALTER TABLE [dbo].[WaitsAssaiPrimario] ADD  DEFAULT (getdate()) FOR [DataHora]
GO

ALTER TABLE [dbo].[WaitsAssaiSecundario] ADD  DEFAULT (GETDATE()) FOR [DataHora]
GO

ALTER TABLE [dbo].[WaitsAtacadoPrimario] ADD  DEFAULT (GETDATE()) FOR [DataHora]
GO

ALTER TABLE [dbo].[WaitsAtacadoSecundario] ADD  DEFAULT (GETDATE()) FOR [DataHora]
GO

ALTER TABLE [dbo].[WaitsB2B2CPrimario] ADD  DEFAULT (GETDATE()) FOR [DataHora]
GO

ALTER TABLE [dbo].[WaitsB2B2CSecundario] ADD  DEFAULT (GETDATE()) FOR [DataHora]
GO

ALTER TABLE [dbo].[WaitsCBPrimario] ADD  DEFAULT (GETDATE()) FOR [DataHora]
GO

ALTER TABLE [dbo].[WaitsCBSecundario] ADD  DEFAULT (GETDATE()) FOR [DataHora]
GO

ALTER TABLE [dbo].[WaitsCDiscountPrimario] ADD  DEFAULT (GETDATE()) FOR [DataHora]
GO

ALTER TABLE [dbo].[WaitsCDiscountSecundario] ADD  DEFAULT (GETDATE()) FOR [DataHora]
GO

ALTER TABLE [dbo].[WaitsCORPPrimario] ADD  DEFAULT (GETDATE()) FOR [DataHora]
GO

ALTER TABLE [dbo].[WaitsCORPSecundario] ADD  DEFAULT (GETDATE()) FOR [DataHora]
GO

ALTER TABLE [dbo].[WaitsEXPrimario] ADD  DEFAULT (GETDATE()) FOR [DataHora]
GO

ALTER TABLE [dbo].[WaitsEXSecundario] ADD  DEFAULT (GETDATE()) FOR [DataHora]
GO

ALTER TABLE [dbo].[WaitsNikePrimario] ADD  DEFAULT (GETDATE()) FOR [DataHora]
GO

ALTER TABLE [dbo].[WaitsPFPrimario] ADD  DEFAULT (GETDATE()) FOR [DataHora]
GO

ALTER TABLE [dbo].[WaitsPFSecundario] ADD  DEFAULT (GETDATE()) FOR [DataHora]
GO


