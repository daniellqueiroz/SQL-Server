CREATE PROCEDURE ReturnBlockedSessions
AS
BEGIN
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;
	SET NOCOUNT ON;
	SET QUOTED_IDENTIFIER ON;

	DECLARE @blockingxml XML;
	SELECT  @blockingxml = N'$(ESCAPE_SQUOTE(WMI(TextData)))';

	DECLARE @Profile VARCHAR(100);    
	SET @Profile = (SELECT name FROM msdb.dbo.sysmail_profile);  

	CREATE TABLE #BlockingDetails
	(
	Nature				VARCHAR(100),
	waittime			VARCHAR(100),
	transactionname		VARCHAR(100),
	lockMode			VARCHAR(100),
	status				VARCHAR(100),
	clientapp			VARCHAR(100),
	hostname			VARCHAR(100),
	loginname			VARCHAR(100),
	currentdb			VARCHAR(100),
	inputbuf			VARCHAR(1000)
	);

	--Blocked process details
	INSERT INTO #BlockingDetails
	SELECT 
	Nature			= 'Blocked',
	waittime		= ISNULL(d.c.value('@waittime','varchar(100)'),''),
	transactionname = ISNULL(d.c.value('@transactionname','varchar(100)'),''),
	lockMode		= ISNULL(d.c.value('@lockMode','varchar(100)'),''),
	status			= ISNULL(d.c.value('@status','varchar(100)'),''),
	clientapp		= ISNULL(d.c.value('@clientapp','varchar(100)'),''),
	hostname		= ISNULL(d.c.value('@hostname','varchar(100)'),''),
	loginname		= ISNULL(d.c.value('@loginname','varchar(100)'),''),
	currentdb		= ISNULL(DB_NAME(d.c.value('@currentdb','varchar(100)')),''),
	inputbuf		= ISNULL(d.c.value('inputbuf[1]','varchar(max)'),'')
	FROM @blockingxml.nodes('TextData/blocked-process-report/blocked-process/process') d(c);

	--Blocking process details
	INSERT INTO #BlockingDetails
	SELECT 
	Nature			= 'BlockedBy',
	waittime		= '',
	transactionname = '',
	lockMode		= '',
	status			= ISNULL(d.c.value('@status','varchar(100)'),''),
	clientapp		= ISNULL(d.c.value('@clientapp','varchar(100)'),''),
	hostname		= ISNULL(d.c.value('@hostname','varchar(100)'),''),
	loginname		= ISNULL(d.c.value('@loginname','varchar(100)'),''),
	currentdb		= ISNULL(DB_NAME(d.c.value('@currentdb','varchar(100)')),''),
	inputbuf		= ISNULL(d.c.value('inputbuf[1]','varchar(max)'),'')
	FROM @blockingxml.nodes('TextData/blocked-process-report/blocking-process/process') d(c);


	IF EXISTS(SELECT TOP 1 * FROM #BlockingDetails)
	BEGIN
		DECLARE @body VARCHAR(MAX);
		SELECT @body =
		(
			SELECT td = 
			currentdb + '</td><td>'  +  Nature + '</td><td>' + waittime + '</td><td>' + transactionname + '</td><td>' + 
			lockMode + '</td><td>' + status + '</td><td>' + clientapp +  '</td><td>' + 
			hostname + '</td><td>' + loginname + '</td><td>' +  inputbuf
			FROM #BlockingDetails
			FOR XML PATH( 'tr' )     
		);  
		-- 'CPHQEXCH01',
		SELECT @body = '<table cellpadding="2" cellspacing="2" border="1">'    
					  + '<tr><th>currentdb</th><th>Nature</th><th>waittime</th><th>transactionname</th></th></th><th>lockMode</th></th>
					  </th><th>status</th></th></th><th>clientapp</th></th></th><th>hostname</th></th>
					  </th><th>loginname</th><th>inputbuf</th></tr>'    
					  + REPLACE( REPLACE( @body, '&lt;', '<' ), '&gt;', '>' )     
					  + '</table>'  +  '<table cellpadding="2" cellspacing="2" border="1"><tr><th>XMLData</th></tr><tr><td>' + REPLACE( REPLACE( CONVERT(VARCHAR(MAX),@blockingxml),  '<','&lt;' ),  '>','&gt;' )  
					  + '</td></tr></table>';

		DROP TABLE #BlockingDetails;

		--Sending Mail
		DECLARE @recipientsList VARCHAR(8000);
		SELECT @recipientsList ='CANPARDatabaseAdministratorsStaffList@canpar.com';
		EXEC msdb.dbo.sp_send_dbmail
		  @profile_name		= @Profile,
			@recipients			= @recipientsList,
			@body				= @body,
			@body_format		= 'HTML',
			@subject			= 'Alert! Blocking On HQVNOCSQL1 Server',
			@importance			= 'High' ;


		--Inserting into a table for further reference
		INSERT INTO DBAMonitor.dbo.BlockedEvents
						(AlertTime, BlockedReport)
						VALUES (GETDATE(), N'$(ESCAPE_SQUOTE(WMI(TextData)))');

		--Updating the SPID column
		UPDATE B
			SET B.SPID = B.BlockedReport.value('(/TextData/blocked-process-report/blocking-process/process/@spid)[1]','int')
			FROM DBAMonitor.dbo.BlockedEvents B 
			WHERE  B.Event_id = SCOPE_IDENTITY();
                
	END;
	ELSE
		DROP TABLE #BlockingDetails;
END