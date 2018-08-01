-- sample usage of the COLUMNS_UPDATE() function that can be exposed within a trigger to detect which columns were affected by a DML statement
-- this is specially useful when tracking changes on big tables

USE tempdb;

IF OBJECT_ID('dbo.T1', 'U') IS NOT NULL
	DROP TABLE dbo.T1;
GO

-- creating a big table with 100 columns
DECLARE @cmd AS NVARCHAR(4000)
	,@i AS INT;

SET @cmd = N'CREATE TABLE dbo.T1(keycol INT NOT NULL IDENTITY PRIMARY KEY';
SET @i = 1;

WHILE @i <= 100
BEGIN
	SET @cmd = @cmd + N',col' + CAST(@i AS NVARCHAR(10)) + N' INT NOT NULL DEFAULT 0';
	SET @i = @i + 1;
END

SET @cmd = @cmd + N');'

EXEC sp_executesql @cmd;

INSERT INTO dbo.T1 DEFAULT
VALUES;

SELECT *
FROM T1;

GO

-- creating an auxiliary table that contains numbers one to one milion
IF OBJECT_ID('dbo.Nums', 'U') IS NOT NULL
	DROP TABLE dbo.Nums;

CREATE TABLE dbo.Nums (n INT NOT NULL PRIMARY KEY);

DECLARE @max AS INT
	,@rc AS INT;

SET @max = 1000000;
SET @rc = 1;

INSERT INTO Nums
VALUES (1);

WHILE @rc * 2 <= @max
BEGIN
	INSERT INTO dbo.Nums
	SELECT n + @rc
	FROM dbo.Nums;

	SET @rc = @rc * 2;
END

INSERT INTO dbo.Nums
SELECT n + @rc
FROM dbo.Nums
WHERE n + @rc <= @max;
GO

-- creating trigger with a call to the COLUMNS_UPDATED() function
CREATE TRIGGER trg_T1_u_identify_updated_columns ON dbo.T1
FOR UPDATE
AS
SET NOCOUNT ON;

DECLARE @parent_object_id AS INT = (
		SELECT parent_object_id
		FROM sys.objects
		WHERE object_id = @@PROCID
		);

WITH UpdatedColumns (column_id)
AS (
	SELECT n
	FROM dbo.Nums
	WHERE n <=
		-- count of columns in trigger's parent table
		(
			SELECT COUNT(*)
			FROM sys.columns
			WHERE object_id = @parent_object_id
			)
		-- bit corresponding to nth column is turned on
		AND (SUBSTRING(COLUMNS_UPDATED(), (n - 1) / 8 + 1, 1)) & POWER(2, (n - 1) % 8) > 0
	)
SELECT C.NAME AS updated_column
FROM sys.columns AS C
JOIN UpdatedColumns AS U ON C.column_id = U.column_id
WHERE object_id = @parent_object_id
ORDER BY U.column_id;
GO

--testing the trigger. You should see the columns affected by the update
UPDATE dbo.T1 
SET col4 = 2, col8 = 2, col90 = 2, col6 = 2 
WHERE keycol = 1;
