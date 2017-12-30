/*
Pre-requisites:

1. Define the name of the database where the information about the schema changes will be stored. In this case, I'm assuming the database will be on the same instance as the audited database.
2. Define the indexes needed based on the queries you will do against the table. In this case, I created no indexes to avoid unecessary overhead.
3. Try to put the destination database in a separate disk, if possible. This will allow you more flexibility at the same time eliminating disk concurrency.

*/

USE [dba] 
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
