USE master;
GO

IF EXISTS(SELECT 1 FROM sys.server_event_sessions WHERE name = 'GetLiveQueryPlan')  
BEGIN
    DROP EVENT SESSION GetLiveQueryPlan ON SERVER;  
END
GO
 
CREATE EVENT SESSION GetLiveQueryPlan 
ON SERVER
ADD EVENT sqlserver.query_post_execution_showplan
(
    ACTION (sqlserver.database_name) WHERE (database_name = N'AdventureWorks2017')
)
ADD TARGET package0.event_file
(
    SET filename = N'GetLiveQueryPlan', max_file_size = (5)
)
WITH
(
    STARTUP_STATE = OFF
);
GO

-- Start the event session  
ALTER EVENT SESSION GetLiveQueryPlan ON SERVER STATE = START;  
GO  

-- Stop the event session  
ALTER EVENT SESSION GetLiveQueryPlan ON SERVER STATE = STOP;  
GO

-- Drop the event session
IF EXISTS(SELECT 1 FROM sys.server_event_sessions WHERE name = 'GetLiveQueryPlan')  
BEGIN
    DROP EVENT SESSION GetLiveQueryPlan ON SERVER;  
END
GO

-- Event's description
SELECT 
    name, 
    description 
FROM 
    sys.dm_xe_objects 
WHERE 
    name = 'query_post_execution_showplan';
GO
