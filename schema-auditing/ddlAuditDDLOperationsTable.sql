USE [dba] --DATABASE where the info about changes will be stored
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[AuditDDLOperations](
	[DatabaseLogID] [int] IDENTITY(1,1) NOT NULL,
	[DatabaseName] [nvarchar](50) NULL,
	[LoginName] [nvarchar](50) NULL,
	[PostTime] [datetime] NOT NULL,
	[DatabaseUser] [sysname] NOT NULL,
	[Event] [sysname] NOT NULL,
	[Schema] [sysname] NULL,
	[Object] [sysname] NULL,
	[TSQL] [nvarchar](max) NOT NULL,
	[XmlEvent] [xml] NOT NULL,
 CONSTRAINT [PK_AuditDDLOperations_DatabaseLogID] PRIMARY KEY NONCLUSTERED 
(
	[DatabaseLogID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
