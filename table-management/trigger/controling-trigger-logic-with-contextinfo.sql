USE tempdb
go


USE tempdb; 
IF OBJECT_ID('dbo.T1', 'U') IS NOT NULL DROP TABLE dbo.T1; 
CREATE TABLE dbo.T1(col1 INT);
GO

IF OBJECT_ID('dbo.TrgSignal_Set', 'P') IS NOT NULL
	DROP PROC dbo.TrgSignal_Set;
GO

CREATE PROC dbo.TrgSignal_Set @guid AS BINARY (16)
	,@pos AS INT
AS
DECLARE @ci AS VARBINARY(128);

SET @ci = ISNULL(SUBSTRING(CONTEXT_INFO(), 1, @pos - 1), CAST(REPLICATE(0x00, @pos - 1) AS VARBINARY(128))) + @guid + ISNULL(SUBSTRING(CONTEXT_INFO(), @pos + 16, 128 - 16 - @pos + 1), 0x);
SET CONTEXT_INFO @ci;
GO

IF OBJECT_ID('dbo.TrgSignal_Clear', 'P') IS NOT NULL
	DROP PROC dbo.TrgSignal_Clear;
GO

CREATE PROC dbo.TrgSignal_Clear @pos AS INT
AS
DECLARE @ci AS VARBINARY(128);

SET @ci = ISNULL(SUBSTRING(CONTEXT_INFO(), 1, @pos - 1), CAST(REPLICATE(0x00, @pos - 1) AS VARBINARY(128))) + CAST(REPLICATE(0x00, 16) AS VARBINARY(128)) + ISNULL(SUBSTRING(CONTEXT_INFO(), @pos + 16, 128 - 16 - @pos + 1), 0x);
SET CONTEXT_INFO @ci;
GO

IF OBJECT_ID('dbo.TrgSignal_Get', 'P') IS NOT NULL
	DROP PROC dbo.TrgSignal_Get;
GO

CREATE PROC dbo.TrgSignal_Get @guid AS BINARY (16) OUTPUT
	,@pos AS INT
AS
SET @guid = SUBSTRING(CONTEXT_INFO(), @pos, 16);
GO

CREATE TRIGGER trg_T1_i ON dbo.T1
FOR INSERT
AS
DECLARE @signal AS BINARY (16);

EXEC dbo.TrgSignal_Get @guid = @signal OUTPUT
	,@pos = 1;

IF @signal = 0x7EDBCEC5E165E749BF1261A655F52C48
	RETURN;

PRINT 'trg_T1_i in action...';
GO

INSERT INTO dbo.T1
VALUES (1);

EXEC dbo.TrgSignal_Set @guid = 0x7EDBCEC5E165E749BF1261A655F52C48
	,@pos = 1;

INSERT INTO T1
VALUES (2);

EXEC dbo.TrgSignal_Clear @pos = 1;

INSERT INTO T1
VALUES (3);