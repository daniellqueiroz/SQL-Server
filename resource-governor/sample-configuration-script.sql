CREATE RESOURCE POOL pSlow
WITH (MAX_CPU_PERCENT = 30)
 
CREATE RESOURCE POOL pFast
WITH (MAX_CPU_PERCENT = 70)
 
CREATE WORKLOAD GROUP gSlow
USING pSlow
 
CREATE WORKLOAD GROUP gFast
USING pFast
GO

CREATE FUNCTION f1()
RETURNS SYSNAME WITH SCHEMABINDING
BEGIN
      DECLARE @val sysname
      if 'UserSlow' = SUSER_SNAME()
            SET @val = 'gSlow';
      else if 'UserFast' = SUSER_SNAME()
            SET @val = 'gFast';
      return @val;
END
GO

CREATE LOGIN UserFast WITH PASSWORD = 'UserFastPwd', CHECK_POLICY = OFF
CREATE LOGIN UserSlow WITH PASSWORD = 'UserSlowPwd', CHECK_POLICY = OFF
GO
 
ALTER RESOURCE GOVERNOR WITH (CLASSIFIER_FUNCTION = dbo.f1)
GO
 
ALTER RESOURCE GOVERNOR RECONFIGURE



set nocount on
declare @i int
declare @s varchar(100)
 
set @i = 100000000
 
while @i > 0
begin
       select @s = @@version;
       set @i = @i - 1;
end