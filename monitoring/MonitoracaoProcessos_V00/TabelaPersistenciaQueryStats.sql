SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[WaitsCBPrimario]') AND type in (N'U'))
BEGIN
CREATE TABLE dbo.WaitsCBPrimario(
	session_id smallint NOT NULL,
	wait_duration_ms bigint NULL,
	wait_type nvarchar(60) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	Query nvarchar(max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	hostname nchar(128) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	loginame nchar(128) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	blocked smallint NULL,
	Query2 nvarchar(max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	LoginQ2 nchar(128) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	HostQ2 nchar(128) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	BlockQ2 smallint NULL,
	WaitQ2 nchar(32) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	Query3 nvarchar(max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	LoginQ3 nchar(128) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	HostQ3 nchar(128) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	BlockQ3 smallint NULL,
	WaitQ3 nchar(32) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	Query4 nvarchar(max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	LoginQ4 nchar(128) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	HostQ4 nchar(128) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	BlockQ4 smallint NULL,
	WaitQ4 nchar(32) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	DataHora datetime2(7) NOT NULL DEFAULT (getdate()),
	TempoMedio int NULL,
	IdRegistro bigint IDENTITY(-9223372036854775808,1) NOT NULL,
 CONSTRAINT PK_WaitsCBPrimario PRIMARY KEY CLUSTERED 
(
	DataHora ASC,
	session_id ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
END
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[WaitsCBSecundario]') AND type in (N'U'))
BEGIN
CREATE TABLE dbo.WaitsCBSecundario(
	session_id smallint NOT NULL,
	wait_duration_ms bigint NULL,
	wait_type nvarchar(60) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	Query nvarchar(max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	hostname nchar(128) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	loginame nchar(128) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	blocked smallint NULL,
	Query2 nvarchar(max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	LoginQ2 nchar(128) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	HostQ2 nchar(128) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	BlockQ2 smallint NULL,
	WaitQ2 nchar(32) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	Query3 nvarchar(max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	LoginQ3 nchar(128) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	HostQ3 nchar(128) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	BlockQ3 smallint NULL,
	WaitQ3 nchar(32) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	Query4 nvarchar(max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	LoginQ4 nchar(128) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	HostQ4 nchar(128) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	BlockQ4 smallint NULL,
	WaitQ4 nchar(32) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	DataHora datetime2(7) NOT NULL DEFAULT (getdate()),
	TempoMedio int NULL,
	IdRegistro bigint IDENTITY(-9223372036854775807,1) NOT NULL,
 CONSTRAINT PK_WaitsCBSecundario PRIMARY KEY CLUSTERED 
(
	DataHora ASC,
	session_id ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
END
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[WaitsCORPPrimario]') AND type in (N'U'))
BEGIN
CREATE TABLE dbo.WaitsCORPPrimario(
	session_id smallint NOT NULL,
	wait_duration_ms bigint NULL,
	wait_type nvarchar(60) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	Query nvarchar(max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	hostname nchar(128) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	loginame nchar(128) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	blocked smallint NULL,
	Query2 nvarchar(max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	LoginQ2 nchar(128) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	HostQ2 nchar(128) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	BlockQ2 smallint NULL,
	WaitQ2 nchar(32) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	Query3 nvarchar(max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	LoginQ3 nchar(128) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	HostQ3 nchar(128) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	BlockQ3 smallint NULL,
	WaitQ3 nchar(32) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	Query4 nvarchar(max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	LoginQ4 nchar(128) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	HostQ4 nchar(128) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	BlockQ4 smallint NULL,
	WaitQ4 nchar(32) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	DataHora datetime2(7) NOT NULL DEFAULT (getdate()),
	TempoMedio int NULL,
	IdRegistro bigint IDENTITY(-9223372036854775808,1) NOT NULL,
 CONSTRAINT PK_WaitsCORPPrimario PRIMARY KEY CLUSTERED 
(
	DataHora ASC,
	session_id ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
END
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[WaitsCORPSecundario]') AND type in (N'U'))
BEGIN
CREATE TABLE dbo.WaitsCORPSecundario(
	session_id smallint NOT NULL,
	wait_duration_ms bigint NULL,
	wait_type nvarchar(60) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	Query nvarchar(max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	hostname nchar(128) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	loginame nchar(128) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	blocked smallint NULL,
	Query2 nvarchar(max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	LoginQ2 nchar(128) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	HostQ2 nchar(128) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	BlockQ2 smallint NULL,
	WaitQ2 nchar(32) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	Query3 nvarchar(max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	LoginQ3 nchar(128) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	HostQ3 nchar(128) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	BlockQ3 smallint NULL,
	WaitQ3 nchar(32) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	Query4 nvarchar(max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	LoginQ4 nchar(128) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	HostQ4 nchar(128) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	BlockQ4 smallint NULL,
	WaitQ4 nchar(32) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	DataHora datetime2(7) NOT NULL DEFAULT (getdate()),
	TempoMedio int NULL,
 CONSTRAINT PK_WaitsCORPSecundario PRIMARY KEY CLUSTERED 
(
	DataHora ASC,
	session_id ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
END
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[WaitsEXPrimario]') AND type in (N'U'))
BEGIN
CREATE TABLE dbo.WaitsEXPrimario(
	session_id smallint NOT NULL,
	wait_duration_ms bigint NULL,
	wait_type nvarchar(60) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	Query nvarchar(max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	hostname nchar(128) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	loginame nchar(128) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	blocked smallint NULL,
	Query2 nvarchar(max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	LoginQ2 nchar(128) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	HostQ2 nchar(128) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	BlockQ2 smallint NULL,
	WaitQ2 nchar(32) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	Query3 nvarchar(max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	LoginQ3 nchar(128) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	HostQ3 nchar(128) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	BlockQ3 smallint NULL,
	WaitQ3 nchar(32) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	Query4 nvarchar(max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	LoginQ4 nchar(128) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	HostQ4 nchar(128) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	BlockQ4 smallint NULL,
	WaitQ4 nchar(32) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	DataHora datetime2(7) NOT NULL DEFAULT (getdate()),
	TempoMedio int NULL,
	IdRegistro bigint IDENTITY(-9223372036854775808,1) NOT NULL,
 CONSTRAINT PK_WaitsEXPrimario PRIMARY KEY CLUSTERED 
(
	DataHora ASC,
	session_id ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
END
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[WaitsEXSecundario]') AND type in (N'U'))
BEGIN
CREATE TABLE dbo.WaitsEXSecundario(
	session_id smallint NOT NULL,
	wait_duration_ms bigint NULL,
	wait_type nvarchar(60) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	Query nvarchar(max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	hostname nchar(128) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	loginame nchar(128) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	blocked smallint NULL,
	Query2 nvarchar(max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	LoginQ2 nchar(128) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	HostQ2 nchar(128) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	BlockQ2 smallint NULL,
	WaitQ2 nchar(32) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	Query3 nvarchar(max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	LoginQ3 nchar(128) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	HostQ3 nchar(128) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	BlockQ3 smallint NULL,
	WaitQ3 nchar(32) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	Query4 nvarchar(max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	LoginQ4 nchar(128) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	HostQ4 nchar(128) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	BlockQ4 smallint NULL,
	WaitQ4 nchar(32) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	DataHora datetime2(7) NOT NULL DEFAULT (getdate()),
	TempoMedio int NULL,
	IdRegistro bigint IDENTITY(-9223372036854775807,1) NOT NULL,
 CONSTRAINT PK_WaitsEXSecundario PRIMARY KEY CLUSTERED 
(
	DataHora ASC,
	session_id ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
END
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[WaitsPFPrimario]') AND type in (N'U'))
BEGIN
CREATE TABLE dbo.WaitsPFPrimario(
	session_id smallint NOT NULL,
	wait_duration_ms bigint NULL,
	wait_type nvarchar(60) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	Query nvarchar(max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	hostname nchar(128) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	loginame nchar(128) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	blocked smallint NULL,
	Query2 nvarchar(max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	LoginQ2 nchar(128) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	HostQ2 nchar(128) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	BlockQ2 smallint NULL,
	WaitQ2 nchar(32) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	Query3 nvarchar(max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	LoginQ3 nchar(128) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	HostQ3 nchar(128) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	BlockQ3 smallint NULL,
	WaitQ3 nchar(32) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	Query4 nvarchar(max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	LoginQ4 nchar(128) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	HostQ4 nchar(128) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	BlockQ4 smallint NULL,
	WaitQ4 nchar(32) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	DataHora datetime2(7) NOT NULL DEFAULT (getdate()),
	TempoMedio int NULL,
	IdRegistro bigint IDENTITY(-9223372036854775808,1) NOT NULL,
 CONSTRAINT PK_WaitsPFPrimario PRIMARY KEY CLUSTERED 
(
	DataHora ASC,
	session_id ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
END
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[WaitsPFSecundario]') AND type in (N'U'))
BEGIN
CREATE TABLE dbo.WaitsPFSecundario(
	session_id smallint NOT NULL,
	wait_duration_ms bigint NULL,
	wait_type nvarchar(60) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	Query nvarchar(max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	hostname nchar(128) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	loginame nchar(128) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	blocked smallint NULL,
	Query2 nvarchar(max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	LoginQ2 nchar(128) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	HostQ2 nchar(128) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	BlockQ2 smallint NULL,
	WaitQ2 nchar(32) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	Query3 nvarchar(max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	LoginQ3 nchar(128) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	HostQ3 nchar(128) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	BlockQ3 smallint NULL,
	WaitQ3 nchar(32) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	Query4 nvarchar(max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	LoginQ4 nchar(128) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	HostQ4 nchar(128) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	BlockQ4 smallint NULL,
	WaitQ4 nchar(32) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	DataHora datetime2(7) NOT NULL DEFAULT (getdate()),
	TempoMedio int NULL,
	IdRegistro bigint IDENTITY(-9223372036854775807,1) NOT NULL,
 CONSTRAINT PK_WaitsPFSecundario PRIMARY KEY CLUSTERED 
(
	DataHora ASC,
	session_id ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
END
GO

IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[WaitsB2B2CSecundario]') AND type in (N'U'))
BEGIN
CREATE TABLE dbo.WaitsB2B2CSecundario(
	session_id smallint NOT NULL,
	wait_duration_ms bigint NULL,
	wait_type nvarchar(60) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	Query nvarchar(max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	hostname nchar(128) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	loginame nchar(128) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	blocked smallint NULL,
	Query2 nvarchar(max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	LoginQ2 nchar(128) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	HostQ2 nchar(128) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	BlockQ2 smallint NULL,
	WaitQ2 nchar(32) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	Query3 nvarchar(max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	LoginQ3 nchar(128) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	HostQ3 nchar(128) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	BlockQ3 smallint NULL,
	WaitQ3 nchar(32) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	Query4 nvarchar(max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	LoginQ4 nchar(128) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	HostQ4 nchar(128) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	BlockQ4 smallint NULL,
	WaitQ4 nchar(32) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	DataHora datetime2(7) NOT NULL DEFAULT (getdate()),
	TempoMedio int NULL,
	IdRegistro bigint IDENTITY(-9223372036854775807,1) NOT NULL,
 CONSTRAINT PK_WaitsB2B2CSecundario PRIMARY KEY CLUSTERED 
(
	DataHora ASC,
	session_id ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
END
GO

IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[WaitsB2B2CPrimario]') AND type in (N'U'))
BEGIN
CREATE TABLE dbo.WaitsB2B2CPrimario(
	session_id smallint NOT NULL,
	wait_duration_ms bigint NULL,
	wait_type nvarchar(60) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	Query nvarchar(max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	hostname nchar(128) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	loginame nchar(128) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	blocked smallint NULL,
	Query2 nvarchar(max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	LoginQ2 nchar(128) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	HostQ2 nchar(128) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	BlockQ2 smallint NULL,
	WaitQ2 nchar(32) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	Query3 nvarchar(max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	LoginQ3 nchar(128) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	HostQ3 nchar(128) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	BlockQ3 smallint NULL,
	WaitQ3 nchar(32) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	Query4 nvarchar(max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	LoginQ4 nchar(128) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	HostQ4 nchar(128) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	BlockQ4 smallint NULL,
	WaitQ4 nchar(32) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	DataHora datetime2(7) NOT NULL DEFAULT (getdate()),
	TempoMedio int NULL,
	IdRegistro bigint IDENTITY(-9223372036854775807,1) NOT NULL,
 CONSTRAINT PK_WaitsB2B2CPrimario PRIMARY KEY CLUSTERED 
(
	DataHora ASC,
	session_id ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
END
GO


IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[WaitsAtacadoSecundario]') AND type in (N'U'))
BEGIN
CREATE TABLE dbo.WaitsAtacadoSecundario(
	session_id smallint NOT NULL,
	wait_duration_ms bigint NULL,
	wait_type nvarchar(60) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	Query nvarchar(max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	hostname nchar(128) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	loginame nchar(128) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	blocked smallint NULL,
	Query2 nvarchar(max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	LoginQ2 nchar(128) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	HostQ2 nchar(128) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	BlockQ2 smallint NULL,
	WaitQ2 nchar(32) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	Query3 nvarchar(max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	LoginQ3 nchar(128) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	HostQ3 nchar(128) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	BlockQ3 smallint NULL,
	WaitQ3 nchar(32) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	Query4 nvarchar(max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	LoginQ4 nchar(128) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	HostQ4 nchar(128) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	BlockQ4 smallint NULL,
	WaitQ4 nchar(32) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	DataHora datetime2(7) NOT NULL DEFAULT (getdate()),
	TempoMedio int NULL,
	IdRegistro bigint IDENTITY(-9223372036854775807,1) NOT NULL,
 CONSTRAINT PK_WaitsAtacadoSecundario PRIMARY KEY CLUSTERED 
(
	DataHora ASC,
	session_id ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
END
GO

IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[WaitsAtacadoPrimario]') AND type in (N'U'))
BEGIN
CREATE TABLE dbo.WaitsAtacadoPrimario(
	session_id smallint NOT NULL,
	wait_duration_ms bigint NULL,
	wait_type nvarchar(60) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	Query nvarchar(max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	hostname nchar(128) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	loginame nchar(128) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	blocked smallint NULL,
	Query2 nvarchar(max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	LoginQ2 nchar(128) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	HostQ2 nchar(128) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	BlockQ2 smallint NULL,
	WaitQ2 nchar(32) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	Query3 nvarchar(max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	LoginQ3 nchar(128) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	HostQ3 nchar(128) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	BlockQ3 smallint NULL,
	WaitQ3 nchar(32) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	Query4 nvarchar(max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	LoginQ4 nchar(128) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	HostQ4 nchar(128) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	BlockQ4 smallint NULL,
	WaitQ4 nchar(32) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	DataHora datetime2(7) NOT NULL DEFAULT (getdate()),
	TempoMedio int NULL,
	IdRegistro bigint IDENTITY(-9223372036854775807,1) NOT NULL,
 CONSTRAINT PK_WaitsAtacadoPrimario PRIMARY KEY CLUSTERED 
(
	DataHora ASC,
	session_id ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
END
GO

IF NOT EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[WaitsAtacadoPrimario]') AND name = N'IX_Unique_Waits')
CREATE UNIQUE NONCLUSTERED INDEX IX_Unique_Waits ON dbo.WaitsAtacadoPrimario
(
	IdRegistro ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO

IF NOT EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[WaitsAtacadoSecundario]') AND name = N'IX_Unique_Waits')
CREATE UNIQUE NONCLUSTERED INDEX IX_Unique_Waits ON dbo.WaitsAtacadoSecundario
(
	IdRegistro ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO

IF NOT EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[WaitsB2B2CPrimario]') AND name = N'IX_Unique_Waits')
CREATE UNIQUE NONCLUSTERED INDEX IX_Unique_Waits ON dbo.WaitsB2B2CPrimario
(
	IdRegistro ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO

IF NOT EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[WaitsB2B2CSecundario]') AND name = N'IX_Unique_Waits')
CREATE UNIQUE NONCLUSTERED INDEX IX_Unique_Waits ON dbo.WaitsB2B2CSecundario
(
	IdRegistro ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO

IF NOT EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[WaitsCBPrimario]') AND name = N'IX_Unique_Waits')
CREATE UNIQUE NONCLUSTERED INDEX IX_Unique_Waits ON dbo.WaitsCBPrimario
(
	IdRegistro ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO

IF NOT EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[WaitsCBSecundario]') AND name = N'IX_Unique_Waits')
CREATE UNIQUE NONCLUSTERED INDEX IX_Unique_Waits ON dbo.WaitsCBSecundario
(
	IdRegistro ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO

IF NOT EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[WaitsCORPPrimario]') AND name = N'IX_Unique_Waits')
CREATE UNIQUE NONCLUSTERED INDEX IX_Unique_Waits ON dbo.WaitsCORPPrimario
(
	IdRegistro ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO

IF NOT EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[WaitsEXPrimario]') AND name = N'IX_Unique_Waits')
CREATE UNIQUE NONCLUSTERED INDEX IX_Unique_Waits ON dbo.WaitsEXPrimario
(
	IdRegistro ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO

IF NOT EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[WaitsEXSecundario]') AND name = N'IX_Unique_Waits')
CREATE UNIQUE NONCLUSTERED INDEX IX_Unique_Waits ON dbo.WaitsEXSecundario
(
	IdRegistro ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO

IF NOT EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[WaitsPFPrimario]') AND name = N'IX_Unique_Waits')
CREATE UNIQUE NONCLUSTERED INDEX IX_Unique_Waits ON dbo.WaitsPFPrimario
(
	IdRegistro ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO

IF NOT EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[WaitsPFSecundario]') AND name = N'IX_Unique_Waits')
CREATE UNIQUE NONCLUSTERED INDEX IX_Unique_Waits ON dbo.WaitsPFSecundario
(
	IdRegistro ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO

