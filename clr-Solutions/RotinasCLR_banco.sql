/*
Remarks:

1. This script will create the structure necessary for you to perform regex within SQL Server using CLR, which is way faster than other TSQL construts
2. Note that you can create this only after generating the .dll file with Visual Studio. For more information on the C# code/class, look the other files within this same folder in the repository
3. This script uses a database called CLRUtilities. 
4. Note that the default security option used for the assembly is not the most secure one. In the script, It is provided an alternative to make the usage of the assembly more secure. I recommend using this assembly on non-production environments unless you correctly set the security options.
5. At the end of the code, there are some samples showing how to use the regex search functions

*/

USE CLRUtilities;
GO
-- Create assembly 
CREATE ASSEMBLY CLRUtilities
FROM 'C:\CLRUtilities\CLRUtilities\bin\Debug\CLRUtilities.dll' -- change the path to the .dll file 
WITH PERMISSION_SET = SAFE;
-- If no Debug folder, use instead:
-- FROM 'C:\CLRUtilities\CLRUtilities\bin\CLRUtilities.dll'
GO
----------------------------------------------------------------------- Scalar Function: RegexIsMatch
----------------------------------------------------------------------- Create RegexIsMatch function
CREATE FUNCTION dbo.RegexIsMatch
(@inpstr AS NVARCHAR(MAX), @regexstr AS NVARCHAR(MAX)) 
RETURNS BIT
WITH RETURNS NULL ON NULL INPUT
EXTERNAL NAME CLRUtilities.CLRUtilities.RegexIsMatch;
GO
-- Note: By default, automatic deployment with VS will create functions
-- with the option CALLED ON NULL INPUT
-- and not with RETURNS NULL ON NULL INPUT 
-- Test RegexIsMatch function

----------------------------------------------------------------------- Scalar Function: RegexReplace
----------------------------------------------------------------------- Create RegexReplace function 
CREATE FUNCTION dbo.RegexReplace(
@input AS NVARCHAR(MAX),
@pattern AS NVARCHAR(MAX),
@replacement AS NVARCHAR(MAX))
RETURNS NVARCHAR(MAX)
WITH RETURNS NULL ON NULL INPUT 
EXTERNAL NAME CLRUtilities.CLRUtilities.RegexReplace;
GO
----------------------------------------------------------------------- Scalar Function: FormatDatetime
---------------------------------------------------------------------

-- Create FormatDatetime function
CREATE FUNCTION dbo.FormatDatetime
(@dt AS DATETIME, @formatstring AS NVARCHAR(500)) 
RETURNS NVARCHAR(500)
WITH RETURNS NULL ON NULL INPUT 
EXTERNAL NAME CLRUtilities.CLRUtilities.FormatDatetime;
GO

----------------------------------------------------------------------- Scalar Functions: ImpCast, ExpCast
----------------------------------------------------------------------- Create ImpCast function
CREATE FUNCTION dbo.ImpCast(@inpstr AS NVARCHAR(4000)) 
RETURNS NVARCHAR(4000)
EXTERNAL NAME CLRUtilities.CLRUtilities.ImpCast;
GO
-- Create ExpCast function
CREATE FUNCTION dbo.ExpCast(@inpstr AS NVARCHAR(4000)) 
RETURNS NVARCHAR(4000)
EXTERNAL NAME CLRUtilities.CLRUtilities.ExpCast;
GO

----------------------------------------------------------------------- Scalar Function: SQLSigCLR
----------------------------------------------------------------------- Create SQLSigCLR function
CREATE FUNCTION dbo.SQLSigCLR
(@rawstring AS NVARCHAR(MAX), @parselength AS INT) 
RETURNS NVARCHAR(MAX)
EXTERNAL NAME CLRUtilities.CLRUtilities.SQLSigCLR;
GO

----------------------------------------------------------------------- Table Function: SplitCLR
----------------------------------------------------------------------- Create SplitCLR function
CREATE FUNCTION dbo.SplitCLR
(@string AS NVARCHAR(4000), @separator AS NCHAR(1)) 
RETURNS TABLE(pos INT, element NVARCHAR(4000))
EXTERNAL NAME CLRUtilities.CLRUtilities.SplitCLR;
GO

-- Create SplitCLR_OrderByPos function
CREATE FUNCTION dbo.SplitCLR_OrderByPos
(@string AS NVARCHAR(4000), @separator AS NCHAR(1)) 
RETURNS TABLE(pos INT, element NVARCHAR(4000))
ORDER(pos) -- new in SQL Server 2008
EXTERNAL NAME CLRUtilities.CLRUtilities.SplitCLR;
GO

----------------------------------------------------------------------- Stored Procedure: GetEnvInfo
----------------------------------------------------------------------- Database option TRUSTWORTHY needs to be ON for EXTERNAL_ACCESS
ALTER DATABASE CLRUtilities SET TRUSTWORTHY ON;
GO
-- Alter assembly with PERMISSION_SET = EXTERNAL_ACCESS
ALTER ASSEMBLY CLRUtilities
WITH PERMISSION_SET = EXTERNAL_ACCESS;
GO

/*
-- Safer alternative:
-- Create an asymmetric key from the signed assembly
-- Note: you have to sign the assembly using a strong name key file
USE master;
GO
CREATE ASYMMETRIC KEY CLRUtilitiesKey
FROM EXECUTABLE FILE =
'C:\CLRUtilities\CLRUtilities\bin\Debug\CLRUtilities.dll';
-- Create login and grant it with external access permission level
CREATE LOGIN CLRUtilitiesLogin FROM ASYMMETRIC KEY CLRUtilitiesKey;
GRANT EXTERNAL ACCESS ASSEMBLY TO CLRUtilitiesLogin;
GO
*/

/**** BEGINING OF TEST CODE ****/

-- Create GetEnvInfo stored procedure
CREATE PROCEDURE dbo.GetEnvInfo
AS EXTERNAL NAME CLRUtilities.CLRUtilities.GetEnvInfo;
GO

-- Test GetEnvInfo stored procedure

----------------------------------------------------------------------- Stored Procedure: GetAssemblyInfo
----------------------------------------------------------------------- Create GetAssemblyInfo stored procedure
CREATE PROCEDURE GetAssemblyInfo
@asmName AS sysname
AS EXTERNAL NAME CLRUtilities.CLRUtilities.GetAssemblyInfo;
GO
-- Test GetAssemblyInfo stored procedure

----------------------------------------------------------------------- Trigger: trg_GenericDMLAudit
---------------------------------------------------------------------IF OBJECT_ID('dbo.T1', 'U') IS NOT NULL DROP TABLE dbo.T1;
CREATE TABLE dbo.T1
(
keycol INT NOT NULL PRIMARY KEY,
datacol VARCHAR(10) NOT NULL
);
GO


-- Create trg_T1_iud_GenericDMLAudit trigger
USE CLRUtilities;
GO
CREATE TRIGGER trg_T1_iud_GenericDMLAudit
ON dbo.T1 FOR INSERT, UPDATE, DELETE
AS
EXTERNAL NAME CLRUtilities.CLRUtilities.trg_GenericDMLAudit;
GO

----------------------------------------------------------------------- Stored Procedure: SalesRunningSum
----------------------------------------------------------------------- Create and populate Sales table
IF OBJECT_ID('dbo.Sales', 'U') IS NOT NULL DROP TABLE dbo.Sales;
CREATE TABLE dbo.Sales
(
empid INT NOT NULL, -- partitioning column
dt DATETIME NOT NULL, -- ordering column
qty INT NOT NULL DEFAULT (1), -- measure 1
val MONEY NOT NULL DEFAULT (1.00), -- measure 2
CONSTRAINT PK_Sales PRIMARY KEY(empid, dt)
);
GO
-- Create SalesRunningSum procedure
CREATE PROCEDURE dbo.SalesRunningSum
AS EXTERNAL NAME CLRUtilities.CLRUtilities.SalesRunningSum;
GO
-- Test SalesRunningSum procedure

/*************************************************************/
SELECT dbo.RegexIsMatch(
N'dejan@solidq.com',
N'^([\w-]+\.)*?[\w-]+@[\w-]+\.([\w-]+\.)*?[\w]+$');
GO

-- Test RegexReplace function
SELECT dbo.RegexReplace('(123)-456-789', '[^0-9]', '');
GO

-- Test FormatDatetime function
SELECT dbo.FormatDatetime(GETDATE(), 'dd/MM/yyyy');
GO

-- Test ImpCast and ExpCast functions
SELECT dbo.ImpCast(N'123456'), dbo.ExpCast(N'123456');
GO

-- Test SQLSigCLR function
SELECT dbo.SQLSigCLR
(N'SELECT * FROM dbo.T1 WHERE col1 = 3 AND col2 > 78', 4000);
GO

-- Test SplitCLR function
SELECT pos, element FROM dbo.SplitCLR(N'a,b,c', N',');
GO

-- Test SplitCLR_OrderByPos function
SELECT *
FROM dbo.SplitCLR_OrderByPos(N'a,b,c,d,e,f,g,h,i,j,k,l,m,n,o,p,q,r,s,t,u,v,
w,x,y,z', N',')
ORDER BY pos;
GO
EXEC dbo.GetEnvInfo;
GO
EXEC GetAssemblyInfo N'CLRUtilities';
GO

-- Test trg_GenericDMLAudit trigger
INSERT INTO dbo.T1(keycol, datacol) VALUES(1, N'A');
UPDATE dbo.T1 SET datacol = N'B' WHERE keycol = 1;
DELETE FROM dbo.T1 WHERE keycol = 1;

-- Examine Windows Application Log
GO
INSERT INTO dbo.Sales(empid, dt, qty, val) VALUES
(1, '20100212', 10, 100.00),
(1, '20100213', 30, 330.00),
(1, '20100214', 20, 200.00),
(2, '20100212', 40, 450.00),
(2, '20100213', 10, 100.00),
(2, '20100214', 50, 560.00);
GO
EXEC dbo.SalesRunningSum;
GO


/**** END OF TEST CODE ****/