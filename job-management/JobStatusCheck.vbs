'Remarks:
'Use this script to monitor job executions. In case of a job failure, a window will pop up with a warning.
'I created this to monitor job executions on testing and/or development environments. When an alert popped up on my screen, I knew I had to do something about the failing job.
'There are better monitoring solutions out there, but since I had to create something fast and given my database permissions and privileges, I decided to create this simple solution

Const adOpenStatic = 3
Const adLockOptimistic = 3

Dim objFSO, objFSOText

Set objConnection = CreateObject("ADODB.Connection")
Set objRecordSet = CreateObject("ADODB.Recordset")

objConnection.Open "Provider=SQLOLEDB;Data Source=10.128.132.115;Trusted_Connection=YES;Initial Catalog=db_hom_extra_swat"
objRecordSet.Open "SELECT TOP 1 a.name FROM ( SELECT TOP 100  sj.name,sjh.step_name , sjh.run_status , sjh.message , sjh.run_duration ,CONVERT(DATETIME2(0),CONVERT(VARCHAR(10),CONVERT(DATE,CONVERT(CHAR(8), sjh.run_date, 112))) + ' ' + STUFF(STUFF(REPLACE(STR(sjh.run_time, 6), ' ', '0'), 3, 0, ':'), 6, 0, ':'))  AS runtime FROM msdb.dbo.sysjobhistory sjh INNER JOIN msdb.dbo.sysjobs sj ON sj.job_id = sjh.job_id WHERE 1=1 AND sjh.step_name='(Job outcome)' AND sjh.run_status=0 ORDER BY sjh.instance_id desc ) AS a WHERE a.runtime > CONVERT(DATE,GETDATE()) AND NOT EXISTS (  	SELECT TOP 1 1 	FROM msdb.dbo.sysjobhistory sjhb 	INNER JOIN msdb.dbo.sysjobs sjb ON sjb.job_id = sjhb.job_id 	WHERE 1=1 	AND sjhb.step_name='(Job outcome)' 	AND sjhb.run_status=1 	AND sjb.name = a.name 	AND CONVERT(DATETIME2(0),CONVERT(VARCHAR(10),CONVERT(DATE,CONVERT(CHAR(8), sjhb.run_date, 112))) + ' ' + STUFF(STUFF(REPLACE(STR(sjhb.run_time, 6), ' ', '0'), 3, 0, ':'), 6, 0, ':'))  >= a.runtime ) ",objConnection, adOpenStatic, adLockOptimistic

Dim campos
campos = ""

If Not objRecordSet.EOF Then 
	do until objRecordSet.EOF
		for each x in objRecordSet.Fields
	   		campos = campos & ", " & x.name & " = " & x.value 
		Next
		MsgBox campos,0,"Monitoria Jobs SWAT"
		campos = ""
		objRecordSet.MoveNext
	Loop
	'Wscript.Echo "Erro na replicação transacional do servidor 115 (SWAT)"
End if

objRecordSet.Close
objConnection.Close 

objConnection.Open "Provider=SQLOLEDB;Data Source=10.128.132.167,1167;Trusted_Connection=YES;Initial Catalog=master"
objRecordSet.Open "SELECT TOP 1 a.name FROM ( SELECT TOP 100  sj.name,sjh.step_name , sjh.run_status , sjh.message , sjh.run_duration ,CONVERT(DATETIME2(0),CONVERT(VARCHAR(10),CONVERT(DATE,CONVERT(CHAR(8), sjh.run_date, 112))) + ' ' + STUFF(STUFF(REPLACE(STR(sjh.run_time, 6), ' ', '0'), 3, 0, ':'), 6, 0, ':'))  AS runtime FROM msdb.dbo.sysjobhistory sjh INNER JOIN msdb.dbo.sysjobs sj ON sj.job_id = sjh.job_id WHERE 1=1 AND sjh.step_name='(Job outcome)' AND sjh.run_status=0 ORDER BY sjh.instance_id desc ) AS a WHERE a.runtime > CONVERT(DATE,GETDATE()) AND NOT EXISTS (  	SELECT TOP 1 1 	FROM msdb.dbo.sysjobhistory sjhb 	INNER JOIN msdb.dbo.sysjobs sjb ON sjb.job_id = sjhb.job_id 	WHERE 1=1 	AND sjhb.step_name='(Job outcome)' 	AND sjhb.run_status=1 	AND sjb.name = a.name 	AND CONVERT(DATETIME2(0),CONVERT(VARCHAR(10),CONVERT(DATE,CONVERT(CHAR(8), sjhb.run_date, 112))) + ' ' + STUFF(STUFF(REPLACE(STR(sjhb.run_time, 6), ' ', '0'), 3, 0, ':'), 6, 0, ':'))  >= a.runtime ) ",objConnection, adOpenStatic, adLockOptimistic

campos = ""

If Not objRecordSet.EOF Then 
	do until objRecordSet.EOF
		for each x in objRecordSet.Fields
	   		campos = campos & ", " & x.name & " = " & x.value 
		Next
		MsgBox campos,0,"Monitoria Jobs Homologacao"
		campos = ""
		objRecordSet.MoveNext
	Loop
	'Wscript.Echo "Erro na replicação transacional do servidor 115 (SWAT)"
End if

objRecordSet.Close
objConnection.Close 