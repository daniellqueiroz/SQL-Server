'Use this script to verify errors on the given server. This can be useful to timely identify issues, acting before the replicatioin expires
'It will display a message box telling the error ocurred
'Use this only if you do not other more sophisticated monitoring solution
Const adOpenStatic = 3
Const adLockOptimistic = 3

Dim objFSO, objFSOText

Set objConnection = CreateObject("ADODB.Connection")
Set objRecordSet = CreateObject("ADODB.Recordset")

objConnection.Open "Provider=SQLOLEDB;Data Source=10.128.132.115;Trusted_Connection=YES;Initial Catalog=db_hom_extra_swat"
objRecordSet.Open "SELECT TOP 1 error_text FROM distribution.dbo.MSrepl_errors WHERE [time] > DATEADD(MINUTE,-15,GETDATE())",objConnection, adOpenStatic, adLockOptimistic

Dim campos
campos = ""

If Not objRecordSet.EOF Then 
	do until objRecordSet.EOF
		for each x in objRecordSet.Fields
	   		campos = campos & ", " & x.name & " = " & x.value 
		Next
		MsgBox campos,0,"Monitoria Replicação SWAT"
		campos = ""
		objRecordSet.MoveNext
	Loop
	'Wscript.Echo "Erro na replicação transacional do servidor 115 (SWAT)"
End if

objRecordSet.Close
objConnection.Close 


objConnection.Open "Provider=SQLOLEDB;Data Source=10.128.132.167,1167;Trusted_Connection=YES;Initial Catalog=master"
objRecordSet.Open "SELECT TOP 1 error_text FROM distribution.dbo.MSrepl_errors WHERE [time] > DATEADD(MINUTE,-15,GETDATE())",objConnection, adOpenStatic, adLockOptimistic

campos = ""

If Not objRecordSet.EOF Then 
	do until objRecordSet.EOF
		for each x in objRecordSet.Fields
	   		campos = campos & ", " & x.name & " = " & x.value 
		Next
		MsgBox campos,0,"Monitoria Replicação Homologacao"
		campos = ""
		objRecordSet.MoveNext
	Loop
	'Wscript.Echo "Erro na replicação transacional do servidor 115 (SWAT)"
End if

objRecordSet.Close
objConnection.Close 


objConnection.Open "Provider=SQLOLEDB;Data Source=sql-b2b-hlg01.dc.nova\b2b;Trusted_Connection=YES;Initial Catalog=master"
objRecordSet.Open "SELECT TOP 1 error_text FROM distribution.dbo.MSrepl_errors WHERE [time] > DATEADD(MINUTE,-15,GETDATE())",objConnection, adOpenStatic, adLockOptimistic

campos = ""

If Not objRecordSet.EOF Then 
	do until objRecordSet.EOF
		for each x in objRecordSet.Fields
	   		campos = campos & ", " & x.name & " = " & x.value 
		Next
		MsgBox campos,0,"Monitoria Replicação Ambiente B2b"
		campos = ""
		objRecordSet.MoveNext
	Loop
	'Wscript.Echo "Erro na replicação transacional do servidor 115 (SWAT)"
End if

objRecordSet.Close
objConnection.Close 