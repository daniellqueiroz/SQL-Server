SELECT * FROM MSDB.dbo.sysmail_profile
SELECT * FROM MSDB.dbo.sysmail_profileaccount


EXECUTE msdb.dbo.sysmail_add_profile_sp @profile_name = 'DBA',@description = '' --CREATING DATABASE MAIL PROFILE

EXECUTE msdb.dbo.sysmail_add_account_sp 
    @account_name = 'MailReps',
    @description = 'DEFAULT MAIL ACCOUNT',
    @email_address = 'gooroo@mail.com',
    @replyto_address = '',
    @display_name = 'Reports',
    @mailserver_name = 'YOUR MAIL SERVER' ; --CREATING DATABASE MAIL ACCOUNT


EXEC msdb.dbo.sysmail_add_profileaccount_sp @profile_name = 'DBA', @account_name = 'Relatorio', @sequence_number = '1' -- associating accounts to profiles
EXECUTE msdb.dbo.sysmail_add_principalprofile_sp @profile_name = 'DBA',@principal_name = 'public',@is_default = 1 ; -- associating principals to profile

