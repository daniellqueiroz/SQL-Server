'use this script to return very long strings from the database. Make sure to change the connection properties
'you can direct the output to a file if you want

Const adOpenStatic = 3
Const adLockOptimistic = 3

'Set args = WScript.Arguments
'arg1 = args.Item(0)

Dim objFSO, objFSOText

Set objConnection = CreateObject("ADODB.Connection")
Set objRecordSet = CreateObject("ADODB.Recordset")

'objConnection.Open "Provider=SQLOLEDB;Data Source=10.128.132.18,1145;Trusted_Connection=NO;Initial Catalog=db_hom_extra;User ID=rafael.bahia;Password=alucard__535"
objConnection.Open "Provider=SQLOLEDB;Data Source=ASPIREVXRBL;Trusted_Connection=YES;Initial Catalog=db_prd_loja"

'objRecordSet.Open "select " & arg1 & " from dadosrecursos WHERE nome = 'textoResumoGarantia'", objConnection, adOpenStatic, adLockOptimistic
'objRecordSet.Open "DECLARE @cmd VARCHAR(max) SELECT @cmd = replace (	(	SELECT 'drop index ' + name + ' on ' + object_name(object_id) + ' | ' FROM sys.indexes WHERE name LIKE '_dta%'	FOR XML PATH('')	),'|',';') select @cmd", objConnection, adOpenStatic, adLockOptimistic
objRecordSet.Open "SELECT TOP 1 CONVERT(VARCHAR(max),valor,1) FROM DadosConfiguracao", objConnection, adOpenStatic, adLockOptimistic
Dim campos
campos = ""

If objRecordSet.EOF Then 
	WScript.Echo "Vazio" 
else
	do until objRecordSet.EOF
		for each x in objRecordSet.Fields
	   		'campos = campos & ", " & x.name & " = '" & replace(x.value,"'","''") & "'"
	   		campos = x.value
		Next
		Wscript.Echo campos
		campos = ""
		objRecordSet.MoveNext
	Loop
End if