'This script will connect to an instance of your database (in this case SQL Server) and extract the code of the given stored procedure

Const adOpenStatic = 3
Const adLockOptimistic = 3

Set args = WScript.Arguments
arg1 = args.Item(0)

Dim objFSO, objFSOText, objFolder, objFile
Dim strDirectory, strFile
strDirectory = "c:\Dropbox\DBA\ScriptWH\PROCEDURES\backup"
strFile = "\" & arg1 & ".sql"

nomeproc = arg1

Set objConnection = CreateObject("ADODB.Connection")
Set objRecordSet = CreateObject("ADODB.Recordset")

'change the conection properties below
objConnection.Open _
    "Provider=SQLOLEDB;Data Source=10.128.65.27,1103;" & _
        "Trusted_Connection=NO;Initial Catalog=db_prd_extra;" & _
             "User ID=user;Password=pass"

objRecordSet.Open "SELECT ISNULL(smsp.definition, ssmsp.definition) AS [Definition] FROM sys.all_objects AS sp LEFT OUTER JOIN sys.sql_modules AS smsp ON smsp.object_id = sp.object_id LEFT OUTER JOIN sys.system_sql_modules AS ssmsp ON ssmsp.object_id = sp.object_id WHERE 1=1 /*(sp.type = N'P' OR sp.type = N'RF' OR sp.type='PC')*/ and(sp.name=N'"& nomeproc & "' and SCHEMA_NAME(sp.schema_id)=N'dbo')", _
        objConnection, adOpenStatic, adLockOptimistic

result = objRecordSet.fields("Definition").value

'Uncomment the section below to export the procedure code to a separated file
'Set objFSO = CreateObject("Scripting.FileSystemObject")
'Set objFolder = objFSO.GetFolder(strDirectory)

'If objFSO.FileExists(strDirectory & strFile) Then
'	objFSO.DeleteFile(strDirectory & strFile)
'End If 

'Set objFile = objFSO.CreateTextFile(strDirectory & strFile)


'Set objTextFile = objFSO.OpenTextFile(strFile, 8, True)


'objTextFile.WriteLine (result)
'objTextFile.Close


Wscript.Echo result

	