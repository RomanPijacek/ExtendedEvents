USE master;
GO

IF EXISTS(SELECT 1 FROM sys.server_event_sessions WHERE name = 'DetectImplicitConversions')  
BEGIN
    DROP EVENT SESSION DetectImplicitConversions ON SERVER;  
END
GO
 
CREATE EVENT SESSION DetectImplicitConversions 
ON SERVER
ADD EVENT sqlserver.plan_affecting_convert
(
    ACTION 
    (
        sqlserver.client_app_name,
        sqlserver.database_name,
        sqlserver.sql_text,
        sqlserver.plan_handle
    ) 
    WHERE (sqlserver.database_name = N'AdventureWorks2017')
)
ADD TARGET package0.event_file
(
    SET filename = N'DetectImplicitConversions', max_file_size = (5)
)
WITH
(
    STARTUP_STATE = OFF
);
GO

-- Start the event session  
ALTER EVENT SESSION DetectImplicitConversions ON SERVER STATE = START;  
GO  

-- Stop the event session  
ALTER EVENT SESSION DetectImplicitConversions ON SERVER STATE = STOP;  
GO

-- Drop the event session
IF EXISTS(SELECT 1 FROM sys.server_event_sessions WHERE name = 'DetectImplicitConversions')  
BEGIN
    DROP EVENT SESSION DetectImplicitConversions ON SERVER;  
END
GO
