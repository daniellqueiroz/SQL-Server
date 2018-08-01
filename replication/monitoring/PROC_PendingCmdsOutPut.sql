/*
use this procedure to return the number of pending comands for a given replication. Run everything on the distribution database

usage is as below:

DECLARE @ret INT

EXEC dbo.sp_replmonitorsubscriptionpendingcmds_output @publisher = 'ASPIREVXRBL', -- sysname
  @publisher_db = 'db_prd_corp', -- sysname
  @publication = 'corp_outros_npc', -- sysname
  @subscriber = 'ASPIREVXRBL', -- sysname
  @subscriber_db = 'db_prd_loja', -- sysname
  @subscription_type = 0, -- int
  @retorno = @ret OUTPUT -- int

  SELECT @ret

*/

IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].sp_replmonitorsubscriptionpendingcmds_output') AND type IN (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].sp_replmonitorsubscriptionpendingcmds_output AS' 
END
GO
ALTER PROCEDURE dbo.sp_replmonitorsubscriptionpendingcmds_output   

(  

    @publisher sysname -- cannot be null  

    ,@publisher_db sysname -- cannot be null  

    ,@publication sysname -- cannot be null  

    ,@subscriber sysname -- cannot be null  

    ,@subscriber_db sysname -- cannot be null  

    ,@subscription_type INT ,

   @retorno INT OUTPUT  

)  

AS  

BEGIN  

    SET NOCOUNT ON  

    DECLARE @retcode INT  

                ,@agent_id INT  

                ,@publisher_id INT  

                ,@subscriber_id INT  

                ,@lastrunts TIMESTAMP  

                ,@avg_rate FLOAT  

                ,@xact_seqno VARBINARY(16)  

    ,@inactive INT = 1  

    ,@virtual INT = -1  

  

    -- get the server ids for publisher and subscriber  

    --  

    SELECT @publisher_id = server_id FROM sys.servers WHERE UPPER(name) = UPPER(@publisher)  

    IF (@publisher_id IS NULL)  

    BEGIN  

        RAISERROR(21618, 16, -1, @publisher)  

        RETURN 1  

    END  

    SELECT @subscriber_id = server_id FROM sys.servers WHERE UPPER(name) = UPPER(@subscriber)  

    IF (@subscriber_id IS NULL)  

    BEGIN  

        RAISERROR(20032, 16, -1, @subscriber, @publisher)  

        RETURN 1  

    END  

    --  

    -- get the agent id  

    --  

    SELECT @agent_id = id  

    FROM dbo.MSdistribution_agents   

    WHERE publisher_id = @publisher_id   

        AND publisher_db = @publisher_db  

        AND publication IN (@publication, 'ALL')  

        AND subscriber_id = @subscriber_id  

        AND subscriber_db = @subscriber_db  

        AND subscription_type = @subscription_type  

    IF (@agent_id IS NULL)  

    BEGIN  

        RAISERROR(14055, 16, -1)  

        RETURN (1)  

    END;  

    --  

    -- Compute timestamp for latest run  

    --  

    WITH dist_sessions (start_time, runstatus, timestamp)  

    AS  

    (  

        SELECT start_time, MAX(runstatus), MAX(timestamp)   

        FROM dbo.MSdistribution_history  

        WHERE agent_id = @agent_id  

        GROUP BY start_time   

    )  

    SELECT @lastrunts = MAX(timestamp)  

    FROM dist_sessions  

    WHERE runstatus IN (2,3,4);  

    IF (@lastrunts IS NULL)  

    BEGIN  

        --  

        -- Distribution agent has not run successfully even once  

        -- and virtual subscription of immediate sync publication is inactive (snapshot has not run), no point of returning any counts  

        -- see SQLBU#320752, orig fix SD#881433, and regression bug VSTS# 140179 before you attempt to fix it differently :)  

        IF EXISTS (SELECT *  

                    FROM dbo.MSpublications p JOIN dbo.MSsubscriptions s ON p.publication_id = s.publication_id  

                    WHERE p.publisher_id = @publisher_id   

                        AND p.publisher_db = @publisher_db  

                        AND p.publication = @publication  

                        AND p.immediate_sync = 1  

       AND s.status = @inactive AND s.subscriber_id = @virtual)   

        BEGIN  

      SELECT 'pendingcmdcount' = 0, N'estimatedprocesstime' = 0  

   RETURN 0  

        END  

        --  

        -- Grab the max timestamp  

        --  

        SELECT @lastrunts = MAX(timestamp)  

        FROM dbo.MSdistribution_history  

        WHERE agent_id = @agent_id  

    END  

    --  

    -- get delivery rate for the latest completed run  

    -- get the latest sequence number  

    --  

    SELECT @xact_seqno = xact_seqno  

            ,@avg_rate = delivery_rate  

    FROM dbo.MSdistribution_history  

    WHERE agent_id = @agent_id  

        AND timestamp = @lastrunts  

    --  

    -- if no rows are selected in last query      -- explicitly initialize these variables  

    --  

    SELECT @xact_seqno = ISNULL(@xact_seqno, 0x0)  

            ,@avg_rate = ISNULL(@avg_rate, 0.0)  

    --  

    -- if we do not have completed run  

    -- get the average for the agent in all runs  

    --  

 IF (@avg_rate = 0.0)  

    BEGIN  

        SELECT @avg_rate = ISNULL(AVG(delivery_rate),0.0)  

        FROM dbo.MSdistribution_history  

        WHERE agent_id = @agent_id  

    END  

    --  

    -- get the count of undelivered commands  

    -- PAL check done inside  

    --  

    DECLARE @countab TABLE ( pendingcmdcount INT )  

    INSERT INTO @countab (pendingcmdcount)  

        EXEC @retcode = sys.sp_MSget_repl_commands   

                                    @agent_id = @agent_id  

                                    ,@last_xact_seqno = @xact_seqno  

                                    ,@get_count = 2  

                                    ,@compatibility_level = 9000000  

    IF (@retcode != 0 OR @@error != 0)  

        RETURN 1  

    --  

    -- compute the time to process  

    -- return the resultset  

    --  

    SELECT   

        @retorno = pendingcmdcount    

    FROM @countab  

    --  

    -- all done  

    --  

    RETURN 0  

END  




