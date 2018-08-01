USE Monitoria

--ALTER TABLE dbo.RealTimeCBprim		DROP CONSTRAINT pk_rtcbprim
--ALTER TABLE dbo.RealTimeCORPPrim	DROP CONSTRAINT pk_rtcorpprim
--ALTER TABLE dbo.RealTimeExPrim		DROP CONSTRAINT pk_rtexprim
--ALTER TABLE dbo.RealTimePFPrim		DROP CONSTRAINT pk_rtpfprim

--ALTER TABLE dbo.RealTimeCBprim		ADD CONSTRAINT pk_rtcbprim PRIMARY KEY (start_time,session_id,SnapTime,TieBraker) 
--ALTER TABLE dbo.RealTimeCORPPrim	ADD CONSTRAINT pk_rtcorpprim PRIMARY KEY  (start_time,session_id,SnapTime,TieBraker) 
--ALTER TABLE dbo.RealTimeExPrim		ADD CONSTRAINT pk_rtexprim PRIMARY KEY  (start_time,session_id,SnapTime,TieBraker) 
--ALTER TABLE dbo.RealTimePFPrim		ADD CONSTRAINT pk_rtpfprim PRIMARY KEY  (start_time,session_id,SnapTime,TieBraker) 

--ALTER TABLE dbo.RealTimeCBprim	ADD TieBraker TINYINT
--ALTER TABLE dbo.RealTimeCORPPrim ADD TieBraker TINYINT
--ALTER TABLE dbo.RealTimeExPrim	ADD TieBraker TINYINT
--ALTER TABLE dbo.RealTimePFPrim	ADD TieBraker TINYINT


WITH cte AS(

SELECT *
,(ROW_NUMBER() OVER(PARTITION BY start_time,session_id,SnapTime ORDER BY session_id)) tb
FROM RealTimePFPrim
)
UPDATE dbo.RealTimePFPrim SET tieBraker = tb
--SELECT c.session_id,c.start_time,c.tb,c.Query,c.statement_text 
FROM RealTimePFPrim r INNER JOIN cte c ON c.start_time = r.start_time AND c.session_id = r.session_id


--ALTER TABLE dbo.RealTimeCBprim	ALTER COLUMN TieBraker TINYINT NOT NULL
--ALTER TABLE dbo.RealTimeCORPPrim ALTER COLUMN TieBraker TINYINT NOT NULL
--ALTER TABLE dbo.RealTimeExPrim	ALTER COLUMN TieBraker TINYINT NOT NULL
--ALTER TABLE dbo.RealTimePFPrim	ALTER COLUMN TieBraker TINYINT NOT NULL
