IF OBJECT_ID('dbo.T1', 'U') IS NOT NULL DROP TABLE dbo.T1; 
CREATE TABLE dbo.T1 
( 
keycol INT NOT NULL PRIMARY KEY, 
datacol VARCHAR(10) NOT NULL 
);
GO
CREATE TRIGGER trg_T1_iud ON dbo.T1 FOR INSERT, UPDATE, DELETE 
AS 
DECLARE @i AS INT = 
(SELECT COUNT(*) FROM (SELECT TOP (1) * FROM inserted) AS I);
DECLARE @d AS INT = 
(SELECT COUNT(*) FROM (SELECT TOP (1) * FROM deleted) AS D);
IF @i = 1 AND @d = 1
PRINT 'UPDATE of at least one row identified';
ELSE IF @i = 1 AND @d = 0
PRINT 'INSERT of at least one row identified';
ELSE IF @i = 0 AND @d = 1
PRINT 'DELETE of at least one row identified';
ELSE
PRINT 'No rows affected';
GO

INSERT INTO T1 SELECT 1, 'A' WHERE 1 = 0;

INSERT INTO T1 SELECT 1, 'A';

UPDATE T1 SET datacol = 'AA' WHERE keycol = 1;