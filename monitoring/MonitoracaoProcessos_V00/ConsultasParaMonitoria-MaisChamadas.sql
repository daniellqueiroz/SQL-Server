USE Monitoria
--SELECT TOP 10 * FROM dbo.MaisChamadasB2B2C

SELECT * FROM (SELECT * FROM dbo.MaisChamadasCB WHERE DataHora = (SELECT TOP 1 DataHora FROM dbo.MaisChamadasCB ORDER BY DataHora DESC) ) AS a
union
SELECT * FROM (SELECT * FROM dbo.MaisChamadasPF WHERE DataHora = (SELECT TOP 1 DataHora FROM dbo.MaisChamadasPF ORDER BY DataHora DESC) ) AS b
union
SELECT * FROM (SELECT * FROM dbo.MaisChamadasEX WHERE DataHora = (SELECT TOP 1 DataHora FROM dbo.MaisChamadasEX ORDER BY DataHora DESC) ) AS c
union
SELECT * FROM (SELECT * FROM dbo.MaisChamadasB2B2C WHERE DataHora = (SELECT TOP 1 DataHora FROM dbo.MaisChamadasB2B2C ORDER BY DataHora DESC) ) AS d
union
SELECT * FROM (SELECT * FROM dbo.MaisChamadasCorp WHERE DataHora = (SELECT TOP 1 DataHora FROM dbo.MaisChamadasCorp ORDER BY DataHora DESC) ) AS e
UNION
SELECT * FROM (SELECT * FROM dbo.MaisChamadasNike WHERE DataHora = (SELECT TOP 1 DataHora FROM dbo.MaisChamadasNIke ORDER BY DataHora DESC) ) AS e