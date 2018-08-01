USE [Monitoria]
GO

/****** Object:  View [dbo].[MonRealTime]    Script Date: 28/11/2017 19:15:31 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO



ALTER VIEW	 [dbo].[MonRealTime]
AS 

WITH cte AS
(
SELECT  
session_id, [Database], Query, TM, TempoTotal, wait_time, waittype, blksid, start_time, IsolamentoVit, PLANOVITIMA, IsolamentoVilao, PLANOVILAO, QBlock, UserBlock, hostBlock,SnapTime,TieBraker,hostname, Usuario, wait_resource, statement_text
FROM dbo.RealTimeCORPPrim 
WHERE 1=1
--AND DataHora >= CONVERT(DATE,GETDATE())
--AND DataHora >= DATEADD(DAY,-3,CONVERT(DATE,GETDATE()))
--AND DataHora >= '2016-08-11 02:00:00'
--AND CONTAINS((Query,Query2,Query3,Query4), '"*PRodutoAlterarFicha*"')
--AND Query LIKE '%THOR_CompraExtrair%'



UNION

SELECT 
session_id, [Database], Query, TM, TempoTotal, wait_time, waittype, blksid, start_time, IsolamentoVit, PLANOVITIMA, IsolamentoVilao, PLANOVILAO, QBlock, UserBlock, hostBlock,SnapTime,TieBraker,hostname, Usuario, wait_resource, statement_text
FROM dbo.RealTimeCBPrim 
WHERE 1=1
--AND DataHora >= CONVERT(DATE,GETDATE())
--AND DataHora >= DATEADD(DAY,-3,CONVERT(DATE,GETDATE()))
--AND DataHora >= '2016-08-11 02:00:00'
--AND CONTAINS((Query,Query2,Query3,Query4), '"*PRodutoAlterarFicha*"')
--AND Query LIKE '%THOR_CompraExtrair%'


UNION

SELECT 
session_id, [Database], Query, TM, TempoTotal, wait_time, waittype, blksid, start_time, IsolamentoVit, PLANOVITIMA, IsolamentoVilao, PLANOVILAO, QBlock, UserBlock, hostBlock,SnapTime,TieBraker,hostname, Usuario, wait_resource, statement_text
FROM dbo.RealTimeEXPrim 
WHERE 1=1
--AND DataHora >= CONVERT(DATE,GETDATE())
--AND DataHora >= DATEADD(DAY,-3,CONVERT(DATE,GETDATE()))
--AND DataHora >= '2016-08-11 02:00:00'
--AND CONTAINS((Query,Query2,Query3,Query4), '"*PRodutoAlterarFicha*"')
--AND Query LIKE '%THOR_CompraExtrair%'


UNION

SELECT 
session_id, [Database], Query, TM, TempoTotal, wait_time, waittype, blksid, start_time, IsolamentoVit, PLANOVITIMA, IsolamentoVilao, PLANOVILAO, QBlock, UserBlock, hostBlock,SnapTime,TieBraker,hostname, Usuario, wait_resource, statement_text	   
FROM dbo.RealTimePFPrim 
WHERE 1=1
--AND DataHora >= CONVERT(DATE,GETDATE())
--AND DataHora >= DATEADD(DAY,-3,CONVERT(DATE,GETDATE()))
--AND DataHora >= '2016-08-11 02:00:00'
--AND CONTAINS((Query,Query2,Query3,Query4), '"*PRodutoAlterarFicha*"')
--AND Query LIKE '%THOR_CompraExtrair%'

)
SELECT * FROM cte

GO


