--USE dba;
IF OBJECT_ID('dbo.Workload', 'U') IS NOT NULL DROP TABLE dbo.Workload;
GO

SELECT CAST(TextData AS NVARCHAR(MAX)) AS tsql_code,
Duration AS duration
INTO dbo.Workload
FROM sys.fn_trace_gettable('c:\Dropbox\DBA\tuning\BuscaExecutaNoFullText - NIKE\chamadas_antes.trc', NULL) AS T
WHERE 1=0

INSERT workload
SELECT CAST(TextData AS NVARCHAR(MAX)) AS tsql_code,
Duration AS duration
--INTO dbo.Workload
FROM sys.fn_trace_gettable('c:\Dropbox\DBA\tuning\BuscaExecutaNoFullText - NIKE\chamadas_antes.trc', NULL) AS T
WHERE Duration > 0
--AND ObjectName='spColecaoListar'
--AND EventClass IN(41, 45);

ALTER TABLE dbo.Workload ADD cs AS CHECKSUM(dbo.RegexReplace(tsql_code,
N'([\s,(=<>!](?![^\]]+[\]]))(?:(?:(?:(?# expression coming
)(?:([N])?('')(?:[^'']|'''')*(''))(?# character
)|(?:0x[\da-fA-F]*)(?# binary
)|(?:[-+]?(?:(?:[\d]*\.[\d]*|[\d]+)(?# precise number
)(?:[eE]?[\d]*)))(?# imprecise number
)|(?:[~]?[-+]?(?:[\d]+))(?# integer
))(?:[\s]?[\+\-\*\/\%\&\|\^][\s]?)?)+(?# operators
))',
N'$1$2$3#$4')) PERSISTED;

CREATE CLUSTERED INDEX idx_cl_cs ON dbo.Workload(cs);


IF OBJECT_ID('tempdb..#AggQueries', 'U') IS NOT NULL DROP TABLE #AggQueries; 
SELECT cs, SUM(duration) AS total_duration, 
100. * SUM(duration) / SUM(SUM(duration)) OVER() AS pct, 
ROW_NUMBER() OVER(ORDER BY SUM(duration) DESC) AS rn 
INTO #AggQueries 
FROM dbo.Workload 
GROUP BY cs; 
CREATE CLUSTERED INDEX idx_cl_cs ON #AggQueries(cs);




WITH RunningTotals AS
(
SELECT AQ1.cs,
CAST(AQ1.total_duration / 1000000.
AS NUMERIC(12, 2)) AS total_s, 
CAST(SUM(AQ2.total_duration) / 1000000.
AS NUMERIC(12, 2)) AS running_total_s, 
CAST(AQ1.pct AS NUMERIC(12, 2)) AS pct, 
CAST(SUM(AQ2.pct) AS NUMERIC(12, 2)) AS run_pct, 
AQ1.rn
FROM #AggQueries AS AQ1
JOIN #AggQueries AS AQ2
ON AQ2.rn <= AQ1.rn
GROUP BY AQ1.cs, AQ1.total_duration, AQ1.pct, AQ1.rn
HAVING SUM(AQ2.pct) - AQ1.pct <= 100 -- percentage threshold
)

SELECT RT.rn, RT.pct, S.sig, S.tsql_code AS sample_query
FROM RunningTotals AS RT
CROSS APPLY
(SELECT TOP(1) tsql_code, dbo.RegexReplace(tsql_code,
N'([\s,(=<>!](?![^\]]+[\]]))(?:(?:(?:(?# expression coming
)(?:([N])?('')(?:[^'']|'''')*(''))(?# character
)|(?:0x[\da-fA-F]*)(?# binary
)|(?:[-+]?(?:(?:[\d]*\.[\d]*|[\d]+)(?# precise number
)(?:[eE]?[\d]*)))(?# imprecise number
)|(?:[~]?[-+]?(?:[\d]+))(?# integer
))(?:[\s]?[\+\-\*\/\%\&\|\^][\s]?)?)+(?# operators
))',
N'$1$2$3#$4') AS sig
FROM dbo.Workload AS W
WHERE W.cs = RT.cs) AS S
ORDER BY RT.rn;



--SELECT * FROM sys.traces;