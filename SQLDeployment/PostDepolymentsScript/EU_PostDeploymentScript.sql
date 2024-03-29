IF NOT EXISTS (SELECT 1 FROM INFORMATION_SCHEMA.SCHEMATA WHERE SCHEMA_NAME = 'Common')
BEGIN
    EXEC('CREATE SCHEMA Common;');
END

go
IF NOT EXISTS (SELECT 1 FROM INFORMATION_SCHEMA.SCHEMATA WHERE SCHEMA_NAME = 'Config')
BEGIN
    EXEC('CREATE SCHEMA Config;');
END
go
IF NOT EXISTS (SELECT 1 FROM INFORMATION_SCHEMA.SCHEMATA WHERE SCHEMA_NAME = 'EU_Stg')
BEGIN
    EXEC('CREATE SCHEMA EU_Stg;');
END
go
IF NOT EXISTS (SELECT 1 FROM INFORMATION_SCHEMA.SCHEMATA WHERE SCHEMA_NAME = 'stgtmp')
BEGIN
    EXEC('CREATE SCHEMA stgtmp;');
END
go
IF NOT EXISTS (SELECT 1 FROM INFORMATION_SCHEMA.SCHEMATA WHERE SCHEMA_NAME = 'Temp')
BEGIN
    EXEC('CREATE SCHEMA Temp;');
END
go

/****** Object:  Table [config].[EU_Connection]    Script Date: 13-12-2023 18:35:23 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [config].[EU_Connection](
	[ConnectionKey] [int] IDENTITY(1,1) NOT NULL,
	[ConnectionFriendlyName] [varchar](500) NULL,
	[ConnectionParam] [varchar](max) NULL,
	[ConnectionType] [varchar](500) NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [common].[EU_RDBMSControlTable]    Script Date: 13-12-2023 18:35:23 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [common].[EU_RDBMSControlTable](
	[ControlID] [int] IDENTITY(1,1) NOT NULL,
	[BusinessArea] [varchar](500) NULL,
	[SrcConnectionFriendlyName] [varchar](500) NULL,
	[SrcTableSchema] [varchar](100) NULL,
	[SrcTableName] [varchar](500) NULL,
	[TgtConnectionFriendlyName] [varchar](500) NULL,
	[TgtTableSchema] [varchar](100) NULL,
	[TgtTableName] [varchar](500) NULL,
	[TgtRootContainer] [varchar](2000) NULL,
	[TgtFileName] [varchar](500) NULL,
	[ColumnList] [varchar](max) NULL,
	[Query] [varchar](max) NULL,
	[PrimaryKeyList] [varchar](max) NULL,
	[IncRefreshColumn] [varchar](max) NULL,
	[LastRefreshDate] [datetime2](7) NULL,
	[LastRefreshStatus] [varchar](500) NULL,
	[IsActive] [int] NULL,
	[Tag] [varchar](max) NULL,
	[RefreshStartDate] [datetime2](7) NULL,
	[IncRefreshMaxDate] [datetime] NULL,
	[latest_file_path] [nvarchar](max) NULL,
	[AdditionalFilterConditions] [nvarchar](max) NULL,
	[IsDelete] [bit] NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  View [common].[vw_EU_RDBMSControlTable]    Script Date: 13-12-2023 18:35:23 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE VIEW [common].[vw_EU_RDBMSControlTable]
AS SELECT RD.ControlID AS ControlID
, ISNULL(RD.BusinessArea,'') AS BusinessArea
, ISNULL(RD.SrcConnectionFriendlyName,'') AS SrcConnectionFriendlyName
, ISNULL(SC.ConnectionParam,'') AS SrcConnectionParam
, ISNULL(SC.ConnectionType,'') AS SrcConnectionType
, ISNULL(RD.SrcTableSchema,'') AS SrcTableSchema
, ISNULL(RD.SrcTableName,'') AS SrcTableName
, ISNULL(RD.TgtConnectionFriendlyName,'') AS TgtConnectionFriendlyName
, ISNULL(TC.ConnectionParam,'') AS TgtConnectionParam
, ISNULL(TC.ConnectionType,'') AS TgtConnectionType
, ISNULL(RD.TgtTableSchema,'') AS TgtTableSchema
, ISNULL(RD.TgtTableName,'') AS TgtTableName
, ISNULL(RD.TgtRootContainer,'') AS TgtRootContainer
, ISNULL(RD.TgtFileName,'') AS TgtFileName
, ISNULL(RD.ColumnList,'*') AS ColumnList
, ISNULL(RD.Query,'') AS Query
, ISNULL(RD.PrimaryKeyList,'') AS PrimaryKeyList
, ISNULL(RD.IncRefreshColumn,'') AS IncRefreshColumn
, RD.IncRefreshMaxDate AS IncRefreshMaxDate
, ISNULL(RD.LastRefreshDate,'1900-01-01') AS LastRefreshDate
, ISNULL(RD.LastRefreshStatus,'') AS LastRefreshStatus
, ISNULL(RD.IsActive,0) AS IsActive
, ISNULL(RD.Tag,'') AS Tag
, 'SELECT '+ISNULL(RD.ColumnList,'*')+' FROM '+QUOTENAME(SrcTableSchema)+'.'+QUOTENAME(SrcTableName)+IIF(RD.AdditionalFilterConditions<>'' AND RD.AdditionalFilterConditions IS NOT NULL,CONCAT(' WHERE (',RD.AdditionalFilterConditions,') AND _lmdcclause_'), ' WHERE _lmdcclause_') 
  AS CreatedQuery
, RD.RefreshStartDate AS RefreshStartDate
,ISNULL(RD.latest_file_path,'') AS latest_file_path
, ISNULL(RD.IsDelete,'') AS IsDelete
FROM Common.EU_RDBMSControlTable AS RD WITH (NOLOCK)INNER JOIN Config.EU_Connection AS SC WITH (NOLOCK) ON SC.ConnectionFriendlyName=RD.SrcConnectionFriendlyName
INNER JOIN Config.EU_Connection AS TC WITH (NOLOCK) ON TC.ConnectionFriendlyName=RD.TgtConnectionFriendlyName
GO
/****** Object:  Table [common].[EU_ValidationResultHistory]    Script Date: 13-12-2023 18:35:23 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [common].[EU_ValidationResultHistory](
	[ID] [int] NOT NULL,
	[BatchID] [int] NULL,
	[SourceMeasureName] [varchar](100) NULL,
	[SourceResult] [varchar](max) NULL,
	[SourceType] [varchar](200) NULL,
	[TargetMeasureName] [varchar](100) NULL,
	[TargetResult] [varchar](max) NULL,
	[CompletionTime] [datetime] NULL,
	[Tag] [varchar](200) NULL,
	[SysStartTime] [datetime2](7) NOT NULL,
	[SysEndTime] [datetime2](7) NOT NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [common].[EU_ValidationResult]    Script Date: 13-12-2023 18:35:24 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [common].[EU_ValidationResult](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[BatchID] [int] NULL,
	[SourceMeasureName] [varchar](100) NULL,
	[SourceResult] [varchar](max) NULL,
	[SourceType] [varchar](200) NULL,
	[TargetMeasureName] [varchar](100) NULL,
	[TargetResult] [varchar](max) NULL,
	[CompletionTime] [datetime] NULL,
	[Tag] [varchar](200) NULL,
	[SysStartTime] [datetime2](7) GENERATED ALWAYS AS ROW START HIDDEN NOT NULL,
	[SysEndTime] [datetime2](7) GENERATED ALWAYS AS ROW END HIDDEN NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY],
	PERIOD FOR SYSTEM_TIME ([SysStartTime], [SysEndTime])
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
WITH
(
SYSTEM_VERSIONING = ON (HISTORY_TABLE = [common].[EU_ValidationResultHistory])
)
GO
/****** Object:  Table [common].[EU_ValidationControlTable]    Script Date: 13-12-2023 18:35:24 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [common].[EU_ValidationControlTable](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[MeasureName] [varchar](100) NULL,
	[SourceConnection] [varchar](max) NULL,
	[SourceQuery] [varchar](max) NULL,
	[TargetConnection] [varchar](max) NULL,
	[TargetQuery] [varchar](max) NULL,
	[IsActive] [int] NULL,
	[Tag] [varchar](500) NULL,
	[Status] [varchar](100) NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  View [config].[vw_EU_ValidationControlTable]    Script Date: 13-12-2023 18:35:24 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO




CREATE VIEW [config].[vw_EU_ValidationControlTable] AS 
Select 
 Isnull(V.ID,'') AS ID
,Isnull(V.MeasureName,'') AS MeasureName
,Isnull(V.SourceConnection,'') AS SourceConnection
,Isnull(V.SourceQuery,'') AS SourceQuery
,Isnull(V.TargetConnection,'') As TargetConnection
,Isnull(V.TargetQuery,'') AS TargetQuery
,Isnull(V.IsActive,'') AS IsActive
,Isnull(V.Tag,'') AS Tag
,Isnull(V.Status,'') AS Status
,Isnull(C_sr.ConnectionParam,'') as Src_ConnectionParam
,Isnull(C_sr.ConnectionType,'') as Src_ConnectionType
,Isnull(C_tgt.ConnectionParam,'') as Tgt_ConnectionParam
,Isnull(C_tgt.ConnectionType,'') as Tgt_ConnectionType
from common.EU_ValidationControlTable V
Left join Config.EU_Connection C_sr on V.SourceConnection = C_sr.ConnectionFriendlyName
Left join Config.EU_Connection C_tgt on V.TargetConnection = C_tgt.ConnectionFriendlyName

GO
/****** Object:  Table [common].[EU_ADFLogs]    Script Date: 13-12-2023 18:35:24 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [common].[EU_ADFLogs](
	[LogID] [int] IDENTITY(1,1) NOT NULL,
	[BatchID] [bigint] NULL,
	[customidentifier] [varchar](500) NULL,
	[activityRunEnd] [nvarchar](max) NULL,
	[activityName] [nvarchar](max) NULL,
	[activityRunStart] [nvarchar](max) NULL,
	[activityType] [nvarchar](max) NULL,
	[durationInMs] [nvarchar](max) NULL,
	[retryAttempt] [nvarchar](max) NULL,
	[error] [nvarchar](max) NULL,
	[activityRunId] [nvarchar](max) NULL,
	[iterationHash] [nvarchar](max) NULL,
	[input] [nvarchar](max) NULL,
	[linkedServiceName] [nvarchar](max) NULL,
	[output] [nvarchar](max) NULL,
	[userProperties] [nvarchar](max) NULL,
	[pipelineName] [nvarchar](max) NULL,
	[pipelineRunId] [nvarchar](max) NULL,
	[status] [nvarchar](max) NULL,
	[recoveryStatus] [nvarchar](max) NULL,
	[integrationRuntimeNames] [nvarchar](max) NULL,
	[executionDetails] [nvarchar](max) NULL,
	[id] [nvarchar](max) NULL,
	[errorCode] [nvarchar](max) NULL,
	[message] [nvarchar](max) NULL,
	[failureType] [nvarchar](max) NULL,
	[target] [nvarchar](max) NULL,
	[details] [nvarchar](max) NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [common].[EU_BatchDetails]    Script Date: 13-12-2023 18:35:24 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [common].[EU_BatchDetails](
	[BatchID] [int] IDENTITY(1,1) NOT NULL,
	[CreatedDateTime] [datetime] NULL,
	[Comments] [varchar](2000) NULL,
	[NotebookRefresh] [bit] NULL,
	[CopyToSynapse] [bit] NULL,
	[MergeToSynapse] [bit] NULL,
	[PublishLogs] [bit] NULL,
	[rversion] [timestamp] NOT NULL,
	[ISCompleted] [bit] NULL
) ON [PRIMARY]
GO
/****** Object:  Table [common].[EU_DatamartcontrolTable]    Script Date: 13-12-2023 18:35:24 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [common].[EU_DatamartcontrolTable](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[MartName] [varchar](50) NULL,
	[ProcedureName] [varchar](255) NULL,
	[StoredProcedure] [varchar](512) NULL,
	[TableSchema] [varchar](100) NULL,
	[TableName] [varchar](400) NULL,
	[CustomField] [varchar](max) NULL,
	[DependsOn] [varchar](max) NULL,
	[IsActive] [bit] NULL,
	[Tag] [varchar](max) NULL,
	[PublishFlag] [bit] NULL,
	[CreatedBy] [varchar](200) NULL,
	[CreatedDateTime] [datetime] NULL,
	[UpdatedBy] [varchar](200) NULL,
	[UpdatedDateTime] [datetime] NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [common].[EU_DQSummaryTable]    Script Date: 13-12-2023 18:35:24 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [common].[EU_DQSummaryTable](
	[TableName] [varchar](50) NULL,
	[SourceCount] [varchar](20) NULL,
	[TargetCount] [varchar](20) NULL,
	[TargetDuplicates] [varchar](10) NULL,
	[RunID] [varchar](50) NULL,
	[Status] [varchar](100) NULL,
	[Timestamp] [datetime] NULL
) ON [PRIMARY]
GO
/****** Object:  Table [common].[EU_JobSequence]    Script Date: 13-12-2023 18:35:24 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [common].[EU_JobSequence](
	[MartName] [varchar](50) NULL,
	[ProcedureName] [varchar](100) NULL,
	[StoredProcedure] [varchar](500) NULL,
	[LevelNo] [int] NULL
) ON [PRIMARY]
GO
/****** Object:  Table [common].[EU_ProcessLogs]    Script Date: 13-12-2023 18:35:24 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [common].[EU_ProcessLogs](
	[ID] [bigint] IDENTITY(1,1) NOT NULL,
	[ProcessName] [varchar](400) NULL,
	[Summary] [varchar](400) NULL,
	[Status] [varchar](100) NULL,
	[ErrorInfo] [nvarchar](max) NULL,
	[RunId] [varchar](100) NULL,
	[LoggedTime] [datetime] NULL,
	[RecordsInSource] [bigint] NULL,
	[RecordsCopiedToDest] [bigint] NULL,
	[SkippedRecordsToMove] [bigint] NULL,
	[CopyDuration(Seconds)] [bigint] NULL,
PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [common].[EU_ValidationStatus]    Script Date: 13-12-2023 18:35:24 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [common].[EU_ValidationStatus](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[MeasureName] [varchar](200) NULL,
	[Source] [varchar](200) NULL,
	[Source_result] [varchar](200) NULL,
	[Target] [varchar](200) NULL,
	[Target_result] [varchar](200) NULL,
	[Status] [varchar](100) NULL,
	[Tag] [varchar](200) NULL
) ON [PRIMARY]
GO
/****** Object:  StoredProcedure [common].[usp_EU_ADFPipelineLogger]    Script Date: 13-12-2023 18:35:24 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
     /********************************      
  Purpose: Log ADF Pipeline Run Details  
  Usage: EXEC common.usp_ADFPipelineLogger @json_value = N''      
 *********************************/      
  
CREATE   PROCEDURE [common].[usp_EU_ADFPipelineLogger]      
 @json_value Nvarchar(MAX)      
 ,@batch_id bigint      
 ,@custom_identifier Nvarchar(MAX)      
AS      
BEGIN      
      
 
  -- Insert the processed data into the common.EU_ADFLogs table  
 INSERT INTO common.EU_ADFLogs      
 SELECT DISTINCT @batch_id,@custom_identifier,a.*,err.*      
 FROM OPENJSON(@json_value)       
 WITH (      
    [value] NVARCHAR(MAX) '$.value' AS JSON,      
    [Actions] nvarchar(max) '$.ADFWebActivityResponseHeaders' AS JSON      
 ) AS i      
 CROSS APPLY (      
    SELECT *      
    FROM OPENJSON(i.[value])      
    WITH (      
   [activityRunEnd] nvarchar(max) '$.activityRunEnd',      
   [activityName] nvarchar(max) '$.activityName',      
   [activityRunStart] nvarchar(max) '$.activityRunStart',      
   [activityType] nvarchar(max) '$.activityType',      
   [durationInMs] nvarchar(max) '$.durationInMs',      
   [retryAttempt] nvarchar(max) '$.retryAttempt',      
   [error] nvarchar(max) '$.error' AS JSON,      
   [activityRunId] nvarchar(max) '$.activityRunId',      
   [iterationHash] nvarchar(max) '$.iterationHash',      
   [input] nvarchar(max) '$.input' AS JSON,      
   [linkedServiceName] nvarchar(max) '$.linkedServiceName',      
   [output] nvarchar(max) '$.output' AS JSON,      
   [userProperties] nvarchar(max) '$.userProperties' AS JSON,      
   [pipelineName] nvarchar(max) '$.pipelineName',      
   [pipelineRunId] nvarchar(max) '$.pipelineRunId',      
   [status] nvarchar(max) '$.status',      
   [recoveryStatus] nvarchar(max) '$.recoveryStatus',      
   [integrationRuntimeNames] nvarchar(max) '$.integrationRuntimeNames',      
   [executionDetails] nvarchar(max) '$.executionDetails',      
   [id] nvarchar(max) '$.id'      
    )      
 ) a      
 CROSS APPLY (      
    SELECT *      
    FROM OPENJSON(a.[error])      
    WITH (      
   [errorCode] nvarchar(max) '$.errorCode',      
   [message] nvarchar(max) '$.message',      
   [failureType] nvarchar(max) '$.failureType',      
   [target] nvarchar(max) '$.target',      
   [details] nvarchar(max) '$.details'      
      
    )      
 ) err      
      
END 
GO
/****** Object:  StoredProcedure [common].[usp_EU_DQCheck]    Script Date: 13-12-2023 18:35:24 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO




CREATE PROCEDURE [common].[usp_EU_DQCheck] 
                                       @targettable  VARCHAR(50) NULL,   
                                       @targetschema VARCHAR(10) NULL,   
                                       @keys         VARCHAR(100) NULL,   
                                       @RunID        VARCHAR(50) NULL  ,
									   @batchID  VARCHAR(50) NULL
									   ,@Source  VARCHAR(100) NULL
AS  
    BEGIN  
       
                DECLARE @duplicates TABLE(CNT INT NOT NULL);  
                DECLARE @dupstatement VARCHAR(1000);  
                DECLARE @msg VARCHAR(100);  
                DECLARE @statement VARCHAR(MAX);  
                DECLARE @status VARCHAR(10);  
                DECLARE @valexists INT;  
                SET @status = 'ERROR';  
  
                IF @keys IS NOT NULL and @keys <> ''  -- Need to check for dups  
     BEGIN  
      
	  SET @dupstatement = 'SELECT COUNT(*) CNT FROM ' + @targetschema + '.' + @targettable + ' GROUP BY ' + @keys + ' HAVING COUNT(*)>1';  
      PRINT(@dupstatement);  
      INSERT INTO @duplicates  
      EXEC (@dupstatement);  
      INSERT INTO @duplicates  
        SELECT 0;  
      SET @valexists =  
      (  
       SELECT TOP 1 *  

       FROM @duplicates  
       ORDER BY CNT DESC  
      );  
      IF @valexists <> 0  
       BEGIN
        SELECT @valexists as DupCount  -- if we return the resultset before RAISERROR, ADF Lookup won't fail (which is what we want)  
        SET @status = 'YES';  
        SET @msg = 'DUPLICATES FOUND';  
        SET @statement = 'INSERT INTO common.EU_DQSummaryTable VALUES(''' + @targettable + ''', Null,Null,''' + @status + ''',''' + @RunID + ''',''' + @msg + ''',GETUTCDATE()) ;
		Insert into common.EU_validationresult Values(''' + @batchID + ''',Null,Null,''' + @Source + ''',''' + @targettable  + '_Dup'',''Not Matched'',GETUTCDATE(),''Staging'' )';  
        PRINT(@statement);  
        EXEC (@statement);  
       -- RAISERROR('Duplicates Found', 11, 1);  
        RETURN  
       END 
	    Else
	  BEGIN  
        SELECT @valexists as DupCount  -- if we return the resultset before RAISERROR, ADF Lookup won't fail (which is what we want)  
        SET @status = 'No';  
        SET @msg = 'DUPLICATES Not FOUND';  
        SET @statement = 'INSERT INTO common.EU_DQSummaryTable VALUES(''' + @targettable + ''', Null,Null,''' + @status + ''',''' + @RunID + ''',''' + @msg + ''',GETUTCDATE()) ;
		Insert into common.EU_validationresult Values(''' + @batchID + ''',Null,Null,''' + @Source + ''',''' + @targettable  + '_Dup'',''Matched'',GETUTCDATE(),''Staging'' )';  
        PRINT(@statement);  
        EXEC (@statement);  
       -- RAISERROR('Duplicates Found', 11, 1);  
        RETURN  
       END; 

     END  
	 
     
     -- Now that no dups were found for tables with keys, check for count mismatch  
    
  
     IF @keys IS NULL  or @keys = ''
      SET @statement = 'INSERT INTO [common].[EU_DQSummaryTable] VALUES(''' + @targettable + ''',''' + ''', Null,Null,''' + ''',  NULL  ,''' + @RunID + ''',''' + @msg + ''',GETUTCDATE())';  
     ELSE  
      SET @statement = 'INSERT INTO common.EU_DQSummaryTable VALUES(''' + @targettable + ''',''' + ''', Null,Null,''' + 'NO' + ''',''' + @RunID + ''',''' + @msg + ''',GETUTCDATE())';  
       
     PRINT(@statement);  
     EXEC (@statement);  
  
     
  
   SELECT 0 as DupCount -- Must always return resultset or ADF lookup will error out  
    END;
GO
/****** Object:  StoredProcedure [common].[usp_EU_JobSequence_INS]    Script Date: 13-12-2023 18:35:24 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
  
/****
 Purpose: This stored procedure inserts job sequencing information into the [common.EU_JobSequence] table.
         The job sequence defines the order of execution for procedures in a data mart.


***/
CREATE PROCEDURE [common].[usp_EU_JobSequence_INS] @MartName VARCHAR(max) ,       
                                             @where_cond  VARCHAR(max) = NULL   
AS      
    BEGIN      
    
 
  -- If the optional WHERE condition is not provided, set it to '1=1'.
    if @where_cond = ''  
        set @where_cond = '1=1'  
 
 
 /*
  -- CTE  to  Recursive CTE to calculate levels of procedure dependencies.
  and CTE with level information filtered based on provided WHERE condition.
  */
    declare @sql_query varchar(max) = '  
     DELETE  
    FROM common.EU_JobSequence  
    WHERE MartName = '''+@MartName+''';  
  
         
  
    WITH cte_RAW  
    AS (  
        SELECT DISTINCT ProcedureName  
            ,StoredProcedure  
            ,TRIM(s.value) AS dependsOn  
            --,DBSNotebookParams  
   
        FROM common.EU_DataMartControlTable  
        OUTER APPLY string_split(dependsOn, '','') s  
        WHERE MartName = '''+@MartName+'''  
              
        )  
        ,CTE_CLEAN  
    AS (  
        SELECT DISTINCT r.ProcedureName  
            ,r.StoredProcedure  
            ,c.ProcedureName AS DependsOn  
            --,r.DBSNotebookParams  
   
        FROM CTE_RAW r  
        LEFT JOIN cte_raw c ON r.DependsOn = c.ProcedureName  
        ) 
		
        ,rcte  
    AS (  
        SELECT ProcedureName  
            ,StoredProcedure  
            ,dependsOn  
            ,1 AS levelno  
            --,DBSNotebookParams  
  
        FROM cte_clean  
        WHERE dependsOn IS NULL  
      
        UNION ALL  
      
        SELECT b.ProcedureName  
            ,b.StoredProcedure  
            ,b.dependsOn  
            ,r.levelno + 1 AS levelno  
            --,b.DBSNotebookParams  
   
  
        FROM cte_clean b  
        INNER JOIN rcte r ON b.dependsOn = r.ProcedureName  
        )  
    ,final_cte  
    AS (  
        SELECT DISTINCT '''+@MartName+''' AS MartName  
            ,ProcedureName  
            ,StoredProcedure  
            ,max(levelno) AS levelno  
            --,DBSNotebookParams  
  
  
        FROM rcte  
        GROUP BY ProcedureName  
            ,StoredProcedure  
   
            --,DBSNotebookParams  
        UNION ALL  
  
        (  
            SELECT '''+@MartName+''' AS MartName  
                ,ProcedureName  
                ,StoredProcedure  
                ,(  
                    (  
                        SELECT isnull(MAX(levelno), 0)  
                        FROM rcte  
                        )  
                    ) + 1 AS MaxLevel  
                    --,DBSNotebookParams  
   
            FROM CTE_CLEAN  
            WHERE ProcedureName NOT IN (  
                    SELECT ProcedureName  
                    FROM rcte  
                    )  
        )  
    ),final_cte_level  
    AS (  
        SELECT fc.*  
        FROM final_cte fc  
        INNER JOIN (select * from common.EU_DataMartControlTable WHERE '+ isnull(@where_cond,'1=1') +' and  IsActive=1) dc ON fc.ProcedureName = dc.ProcedureName  
            AND dc.martname = fc.martname  
      
        )  
    insert into common.EU_JobSequence(MartName,ProcedureName,StoredProcedure,LevelNo)  
    SELECT Martname  
        ,ProcedureName  
        ,StoredProcedure  
        ,dense_rank() OVER (  
            ORDER BY (levelno)  
            ) AS levelno  
            --,DBSNotebookParams  
   
    FROM final_cte_level  
    ORDER BY levelno   ;  
  
'  
  
  
  --  select @sql_query;  
  
    exec(@sql_query)  
  
END  
GO
/****** Object:  StoredProcedure [common].[usp_EU_Logger]    Script Date: 13-12-2023 18:35:24 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE Procedure [common].[usp_EU_Logger](@ProcessName VARCHAR(400), @Summary VARCHAR(400), @Status Varchar(100), @ErrorInfo NVarchar(Max),@RunId Varchar(100),@RecordsInSource bigint,@RecordsCopiedToDest bigint,@SkippedRecordsToMove bigint,@CopyDuration bigint)
AS
BEGIN

Insert Into common.EU_ProcessLogs(ProcessName,Summary,Status,ErrorInfo,RunId,LoggedTime,RecordsInSource,RecordsCopiedToDest,SkippedRecordsToMove,[CopyDuration(Seconds)])
Values(@ProcessName,@Summary,@Status,@ErrorInfo,@RunId,GetUTCDATE(),@RecordsInSource,@RecordsCopiedToDest,@SkippedRecordsToMove,@CopyDuration)


END
GO
/****** Object:  StoredProcedure [common].[usp_EU_Main_PopulateMart]    Script Date: 13-12-2023 18:35:24 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
 
 /*
  Purpose: The stored procedure Common.[USP_EU_Main_PopulateMart] is designed to populate a data mart based on information provided in a JSON format.
 The procedure processes this JSON input,
 extracts the relevant information, and uses it to populate the data mart by invoking another stored procedure (common.usp_EU_PopulateMart).
 
 */
CREATE Procedure [common].[usp_EU_Main_PopulateMart](@json_value Varchar(max))    
as    
Begin    
SELECT DISTINCT [ProcedureName],[LoadType]into #temp    
 FROM OPENJSON(@json_value)     
 WITH (    
    [value] NVARCHAR(MAX) '$.value' AS JSON    
 ) AS i    
 CROSS APPLY (    
    SELECT *    
    FROM OPENJSON(i.[value])    
    WITH (    
   [ProcedureName] nvarchar(max) '$.ProcedureName',    
   [LoadType] nvarchar(max) '$.LoadType')    
 ) a    
    
    
 Declare @tablename Varchar(200)    
 Declare @loatype varchar(100)    
 DECLARE cusrsor_merge CURSOR FOR Select * from #temp    
 open cusrsor_merge    
 FETCH cusrsor_merge INTO @tablename,@loatype;    
 WHILE @@FETCH_STATUS = 0      
 begin    
  Declare @loatype_final varchar(200)    
 /*  
 Declare @primarykeylist varchar(200)    
  
 Select @primarykeylist = PrimaryKeyList from common.EU_DataMartControlTable where TableName  = @tablename    
    
 if @loatype = 'inc' and @primarykeylist <> ''    
 set @loatype_final = 'inc'    
 else   
 set @loatype_final = 'ftl'    
 */  
 set @loatype_final = 'ftl'    
    
 Exec common.usp_EU_PopulateMart  @loatype_final, @tablename     
     
    
 Fetch next from cusrsor_merge into @tablename,@loatype    
 end    
 CLOSE cusrsor_merge;    
    
 Deallocate cusrsor_merge;    
    
    
    
 END 
GO
/****** Object:  StoredProcedure [common].[usp_EU_PopulateMart]    Script Date: 13-12-2023 18:35:24 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*
 Purpose: This stored procedure is designed to populate a data mart table based on different load types (Full or Incremental).
          It uses dynamic SQL for handling various aspects like dropping/recreating the table, identifying primary keys, and executing the merge statement.
Exec  [common].[usp_EU_PopulateMart] Null,'EU_DimCustomer'

*/
CREATE PROCEDURE [common].[usp_EU_PopulateMart] (
	@loadtype VARCHAR(3)
	,@tablename VARCHAR(256)
	)
AS
BEGIN
	IF (
			@tablename IS NULL
			OR @loadtype IS NULL
			)
	BEGIN
		RAISERROR (
				'TableName/loadtype cannot be NULL'
				,16
				,1
				)
	END
	ELSE
	BEGIN
		-- Log the start of the process  
		DECLARE @processsummary VARCHAR(MAX) = 'Process Started For ' + @tablename;

		EXEC [common].[usp_EU_Logger] 'common.usp_EU_PopulateMart'
			,@processsummary
			,'INFO'
			,NULL
			,NULL
			,NULL
			,NULL
			,NULL
			,NULL;

		-- Check the load type and execute corresponding logic      
		IF @loadtype = 'ftl'
		BEGIN
			-- Logic for Full Load (ftl)  
			-- Dynamic SQL to drop and recreate the table  
			DECLARE @sqlQuery NVARCHAR(max)

			SET @sqlQuery = 'DROP TABLE IF EXISTS dbo.' + @tablename + ';      
                ALTER SCHEMA dbo ' + ' TRANSFER temp.' + @tablename

			PRINT (@sqlQuery)

			EXEC (@sqlQuery)
		END
		ELSE IF @loadtype = 'inc'
		BEGIN
			-- Logic for Incremental Load (inc)  
			DECLARE @pk VARCHAR(MAX);
			DECLARE @colnamesquery VARCHAR(MAX);
			DECLARE @pkquery VARCHAR(MAX);
			DECLARE @IdentitycolumnQuery NVARCHAR(Max)
			DECLARE @IdentityColummn VARCHAR(200)
			DECLARE @pktable TABLE (
				id INT NULL
				,value VARCHAR(MAX) NULL
				);
			DECLARE @temptable TABLE (pk VARCHAR(MAX) NULL);
			DECLARE @query VARCHAR(MAX);
			DECLARE @colnamesquerytable TABLE (query VARCHAR(MAX));

			-- Query to identify the identity column of the table    
			SET @IdentitycolumnQuery = '    
  SELECT @IdentityColummn = isnull(COLUMN_NAME,'''')    
  FROM INFORMATION_SCHEMA.COLUMNS    
  WHERE TABLE_NAME = ' + '''' + @tablename + '''    
  AND COLUMNPROPERTY(object_id(''dbo'' + ''.'' +' + '''' + @tablename + '''), COLUMN_NAME, ''IsIdentity'') = 1;'

			PRINT (@IdentitycolumnQuery)

			EXEC sp_executesql @IdentitycolumnQuery
				,N'@IdentityColummn varchar(100) OUTPUT'
				,@IdentityColummn OUTPUT

			SELECT @IdentityColummn AS 'IdentityColummn'

			SET @pkquery = 'select PrimaryKeyList from [common].[EU_DataMartControlTable] where TableName=' + '''' + @tablename + '''';

			PRINT (@pkquery);

			INSERT INTO @temptable
			EXEC (@pkquery);

			SET @pk = (
					SELECT *
					FROM @temptable
					);

			PRINT ('Prinmary Keys are - ' + @pk);

			INSERT INTO @pktable
			SELECT *
			FROM [dbo].[fn_split](@pk, ',');

			DECLARE @pkcolnames VARCHAR(MAX) = (
					SELECT STRING_AGG(CONCAT (
								''''
								,value
								,''''
								), ', ')
					FROM @pktable
					);

			SET @colnamesquery = 'select STRING_AGG(CONCAT(''T.'',cast(cast(COLUMN_NAME as nvarchar(max)) as nvarchar(max)),''=S.'',cast(COLUMN_NAME as nvarchar(max))),'', '') FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME=''' + @tablename + ''' AND TABLE_SCHEMA=
  
    
''temp''       
AND COLUMN_NAME NOT IN (' + @pkcolnames + ',''' + @IdentityColummn + ''')';

			PRINT (@colnamesquery)

			INSERT INTO @colnamesquerytable
			EXEC (@colnamesquery);

			DECLARE @updateclause VARCHAR(MAX);

			SET @updateclause = (
					SELECT *
					FROM @colnamesquerytable
					);

			DECLARE @colnamesquery2 VARCHAR(MAX) = 'select STRING_AGG(CONCAT(''S.'',cast(COLUMN_NAME as nvarchar(max))),'', '') FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME=''' + @tablename + ''' AND TABLE_SCHEMA=''temp'' and column_name <> ''' + @IdentityColummn + '''';
			DECLARE @colnamesquerytable2 TABLE (query VARCHAR(MAX));

			INSERT INTO @colnamesquerytable2
			EXEC (@colnamesquery2);

			DECLARE @insertclause VARCHAR(MAX);

			SET @insertclause = (
					SELECT *
					FROM @colnamesquerytable2
					);

			--print(1)      
			DECLARE @colnamesquery3 VARCHAR(MAX) = 'select STRING_AGG(cast(COLUMN_NAME as nvarchar(max)),'', '') FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME=''' + @tablename + ''' AND TABLE_SCHEMA=''temp'' and column_name <> ''' + @IdentityColummn + ''' ';
			DECLARE @colnamesquerytable3 TABLE (query VARCHAR(MAX));

			INSERT INTO @colnamesquerytable3
			EXEC (@colnamesquery3);

			DECLARE @insertcols VARCHAR(MAX);

			SET @insertcols = (
					SELECT *
					FROM @colnamesquerytable3
					);

			DECLARE @colnamesquery4 VARCHAR(MAX) = 'select STRING_AGG(CONCAT(''T.'',cast(COLUMN_NAME as nvarchar(max)),''=S.'',cast(COLUMN_NAME as nvarchar(max))),'' AND '') FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME=''' + @tablename + ''' AND TABLE_SCHE
MA=''temp''       
AND COLUMN_NAME IN (' + @pkcolnames + ')';
			DECLARE @colnamesquerytable4 TABLE (query VARCHAR(MAX));

			INSERT INTO @colnamesquerytable4
			EXEC (@colnamesquery4);

			DECLARE @mergecols VARCHAR(MAX);

			SET @mergecols = (
					SELECT *
					FROM @colnamesquerytable4
					);

			--print(2)      
			--DECLARE @sourceschemaquery VARCHAR(MAX)= 'stgtmp'      
			--'select TgtTableSchema from config.EU_RDBMSControlTable where TgtTableName=' + '''' + @tablename + '''';      
			--DECLARE @sourceschematable TABLE(sourceschema VARCHAR(100));      
			--INSERT INTO @sourceschematable      
			--EXEC (@sourceschemaquery);      
			DECLARE @sourceschema VARCHAR(MAX) = 'temp'

			--(      
			--   SELECT sourceschema      
			--   FROM @sourceschematable      
			--);      
			PRINT ('Source schema - ' + @sourceschema);

			DECLARE @targetschema VARCHAR(MAX) = 'dbo'

			PRINT ('Target Schema - ' + @targetschema);

			DECLARE @mergestatement NVARCHAR(MAX);

			SET @mergestatement = 'MERGE INTO ' + @targetschema + '.' + @tablename + ' T USING ' + @sourceschema + '.' + @tablename + ' S ON (' + @mergecols + ')      
WHEN MATCHED      
THEN UPDATE SET ' + @updateclause + '      
WHEN NOT MATCHED BY TARGET THEN      
INSERT (' + @insertcols + ') VALUES(' + @insertclause + ');';

			PRINT (@mergestatement);

			EXEC (@mergestatement);
		END;
		ELSE
			-- Handle other load types  
			PRINT ('Load Type is not ftl/inc')

		-- Log the end of the process  
		SET @processsummary = 'Process Ended For ' + @tablename;

		EXEC [common].[usp_EU_Logger] 'common.EU_usp_PopulateSTG_Inc'
			,@processsummary
			,'INFO'
			,NULL
			,NULL
			,NULL
			,NULL
			,NULL
			,NULL;
	END
END
GO
/****** Object:  StoredProcedure [common].[usp_EU_PopulateSTG]    Script Date: 13-12-2023 18:35:24 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


/*
 Purpose: This stored procedure is designed to initiate a Staging data population process for a specified table based on the provided copy type (full or incremental).
 The procedure logs the start and end of the process using a logging mechanism.
 Exec  [common].[usp_EU_PopulateSTG] 'Customer',Null

*/
CREATE Procedure [common].[usp_EU_PopulateSTG]  @tablename VARCHAR(256) , @copy_type VARCHAR(3)    ,@tgtschema VARCHAR(256)    
AS    
Begin     
-- Log the start of the process

IF (@tablename is null or @copy_type is null )
begin

 RAISERROR('TableName/copy_type cannot be NULL', 16, 1)
       
end 

DECLARE @processsummary VARCHAR(MAX)= 'Process Started For ' + @tablename;    
EXEC [common].[usp_EU_Logger]     
             'common.usp_EU_PopulateSTG',     
             @processsummary,     
             'INFO',     
             NULL,     
             NULL,     
             NULL,     
             NULL,     
             NULL,     
             NULL;    
  
-- Check the copy type and execute corresponding logic  
if @copy_type = 'ftl'    
Begin     
    
 EXEC Common.[usp_EU_PopulateSTG_Full] @tablename  ,@tgtschema  
end     
    
else if(@copy_type = 'inc')    
Begin     
 EXEC Common.[usp_EU_PopulateSTG_INC] @tablename    ,@tgtschema
end     
    
else     
Print('Copy Type is not ftl/inc')    
  
-- Log the end of the process  
SET @processsummary = 'Process Ended For ' + @tablename;    
        EXEC [common].[usp_EU_Logger]     
             'common.usp_EU_PopulateSTG',     
             @processsummary,     
             'INFO',     
             NULL,     
             NULL,     
             NULL,     
             NULL,     
             NULL,     
             NULL;    
End 
GO
/****** Object:  StoredProcedure [common].[usp_EU_PopulateSTG_Full]    Script Date: 13-12-2023 18:35:24 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


/*
 Purpose: This stored procedure initiates a full data population process for a specified table.
 It logs the start and end of the process using a logging mechanism and drops/recreates the target table.

*/
CREATE Procedure [common].[usp_EU_PopulateSTG_Full]  @tablename VARCHAR(256),@tgtschema VARCHAR(256)    
AS    
Begin     
-- Log the start of the process  
DECLARE @processsummary VARCHAR(MAX)= 'Process Started For ' + @tablename;    
EXEC [common].[usp_EU_Logger]     
             'common.usp_EU_PopulateSTG_FUll',     
             @processsummary,     
             'INFO',     
             NULL,     
             NULL,     
             NULL,     
             NULL,     
             NULL,     
             NULL;    
   
-- Declare variables for SQL query, target schema, and a dynamic query to retrieve the target schema   
Declare @sqlQuery nvarchar(max)    


/*    
declare @tgtschema varchar(max)    
declare @query nvarchar(max) = 'select @tgtschema =  TgtTableSchema from Common.EU_RDBMSControlTable  where TgtTableName = '''+@tablename+''''    
    
exec sp_executesql @query , N'@tgtschema varchar(100) OUTPUT',@tgtschema OUTPUT    
--Select @tgtschema    
  */  
 -- Declare a variable to store the DROP and ALTER SCHEMA SQL statements   
set @sqlQuery = 'DROP TABLE IF EXISTS '+@tgtschema+'.'+@tablename+';    
                ALTER SCHEMA '+@tgtschema+' TRANSFER stgtmp.'+@tablename    
    

print(@sqlQuery)    
    
exec (@sqlQuery)    
   
-- Log the end of the process   
SET @processsummary = 'Process Ended For ' + @tablename;    
        EXEC [common].[usp_EU_Logger]     
             'common.usp_EU_PopulateSTG_FUll',     
             @processsummary,     
             'INFO',     
             NULL,     
             NULL,     
             NULL,     
             NULL,     
             NULL,     
             NULL;    
End 
GO
/****** Object:  StoredProcedure [common].[usp_EU_PopulateSTG_Inc]    Script Date: 13-12-2023 18:35:24 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



/***  
  
Purpose: This stored procedure initiates an incremental Staging data population process for a specified table.  
It logs the start and end of the process using a logging mechanism, compares the schema, and updates the target table accordingly.  
  
***/
CREATE PROC [common].[usp_EU_PopulateSTG_Inc] @tablename VARCHAR(256), @tgtschema VARCHAR(256) 
AS
BEGIN
	-- Log the start of the process             
	DECLARE @processsummary VARCHAR(MAX) = 'Process Started For ' + @tablename;

	EXEC [common].[usp_EU_Logger] 'common.EU_usp_PopulateSTG_Inc'
		,@processsummary
		,'INFO'
		,NULL
		,NULL
		,NULL
		,NULL
		,NULL
		,NULL;

	-- Declare variables for primary keys and column names    
	DECLARE @pk VARCHAR(MAX);
	DECLARE @colnamesquery VARCHAR(MAX);
	DECLARE @pkquery VARCHAR(MAX);
	DECLARE @pktable TABLE (
		id INT NULL
		,value VARCHAR(MAX) NULL
		);
	DECLARE @temptable TABLE (pk VARCHAR(MAX) NULL);
	DECLARE @query VARCHAR(MAX);
	-- Compare schema and add newly added columns to the table     
	DECLARE @sourceschema VARCHAR(MAX) = 'stgtmp'

	--(        
	--   SELECT sourceschema        
	--   FROM @sourceschematable        
	--);        
	PRINT ('Source schema - ' + @sourceschema);
	PRINT ('Target Schema - ' + @tgtschema);

	DECLARE @SqlStatement NVARCHAR(max)

	SELECT @SqlStatement = COALESCE(@SqlStatement + '; ', '') + 'Alter table EU_Stg.' + t1.TABLE_NAME + ' Add ' + t1.COLUMN_NAME + '  ' + CASE 
			WHEN t1.DATA_TYPE LIKE '%char%'
				THEN t1.DATA_TYPE + '(' + cast(t1.CHARACTER_MAXIMUM_LENGTH AS VARCHAR(100)) + ')'
			WHEN t1.DATA_TYPE LIKE 'Decimal'
				THEN t1.DATA_TYPE + '(' + cast(t1.NUMERIC_PRECISION AS VARCHAR(100)) + ',' + cast(t1.NUMERIC_SCALE AS VARCHAR(100)) + ')'
			ELSE t1.DATA_TYPE
			END
	FROM (
		SELECT *
		FROM INFORMATION_SCHEMA.COLUMNS
		WHERE TABLE_NAME = @tablename
			AND TABLE_SCHEMA = 'stgtmp'
		) t1
	LEFT JOIN (
		SELECT *
		FROM INFORMATION_SCHEMA.COLUMNS
		WHERE TABLE_NAME = @tablename
			AND TABLE_SCHEMA = @tgtschema
		) t2 ON t1.COLUMN_NAME = t2.COLUMN_NAME
	WHERE t2.TABLE_NAME IS NULL;

	PRINT (@SqlStatement)

	EXEC (@SqlStatement)

	--Exec(@SqlStatement2)
	-- Compare schema and add newly added columns to the table    
	-- Retrieve primary key information from control table     
	SELECT @pk = PrimaryKeyList
	FROM Common.EU_RDBMSControlTable
	WHERE TgtTableName = @tablename
		AND TgtTableSchema = @tgtschema

	PRINT ('Prinmary Keys are - ' + @pk);

	DECLARE @pkcolnames VARCHAR(MAX)

	SELECT @pkcolnames = STRING_AGG(CONCAT (
				''''
				,value
				,''''
				), ', ')
	FROM [dbo].[fn_split](@pk, ',');

	--  update clause for matching columns    
	DECLARE @updateclause VARCHAR(MAX);
	DECLARE @updatequery NVARCHAR(max);

	SET @updatequery = 'select @updateclause=  STRING_AGG(CONCAT(''T.'',cast(cast(COLUMN_NAME as nvarchar(max)) as nvarchar(max)),''=S.'',cast(COLUMN_NAME as nvarchar(max))),'', '') 
	FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME=''' + @tablename + ''' AND TABLE_SCHEMA=''stgtmp'' 
AND COLUMN_NAME NOT IN (' + @pkcolnames + ',''SysRevID''' + ')';

	EXEC sp_executesql @updatequery
		,N'@updateclause varchar(max) OUTPUT'
		,@updateclause OUTPUT

	--column names for INSERT clause    
	DECLARE @insertclause VARCHAR(MAX);

	SELECT @insertclause = STRING_AGG(CONCAT (
				'S.'
				,cast(COLUMN_NAME AS NVARCHAR(max))
				), ', ')
	FROM INFORMATION_SCHEMA.COLUMNS
	WHERE TABLE_NAME = @tablename
		AND TABLE_SCHEMA = 'stgtmp'
		AND column_name <> 'SysRevID';

	DECLARE @insertcols VARCHAR(MAX);

	SELECT @insertcols = STRING_AGG(cast(COLUMN_NAME AS NVARCHAR(max)), ', ')
	FROM INFORMATION_SCHEMA.COLUMNS
	WHERE TABLE_NAME = @tablename
		AND TABLE_SCHEMA = 'stgtmp'
		AND column_name <> 'SysRevID'

	DECLARE @mergecols VARCHAR(MAX);

	PRINT (@insertcols)

	DECLARE @mergecolumnquery NVARCHAR(max) = '

	select @mergecols =  STRING_AGG(CONCAT(''T.'',cast(COLUMN_NAME as nvarchar(max)),''=S.'',cast(COLUMN_NAME as nvarchar(max))),'' AND '') FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME=''' + @tablename + ''' AND TABLE_SCHEMA=''stgtmp''         
AND COLUMN_NAME IN (' + @pkcolnames + ')';

	EXEC sp_executesql @mergecolumnquery
		,N'@mergecols varchar(max) OUTPUT'
		,@mergecols OUTPUT

	-- Construct merge condition for matching primary key columns    
	DECLARE @mergestatement NVARCHAR(MAX);

	PRINT ('@mergecols')
	PRINT (@pk)
	PRINT (@pkcolnames)
	PRINT (@tablename)

	SET @mergestatement = 'MERGE INTO ' + @tgtschema + '.' + @tablename + ' T USING ' + @sourceschema + '.' + @tablename + ' S ON (' + @mergecols + ')        
WHEN MATCHED        
THEN UPDATE SET ' + @updateclause + '        
WHEN NOT MATCHED BY TARGET THEN        
INSERT (' + @insertcols + ') VALUES(' + @insertclause + ');';

	PRINT (@mergestatement);

	EXEC (@mergestatement);

	---Code to Handle Deletes 
	
	if object_id('stgtmp.PK_'+@tablename) is not null
	Begin
		Declare @merge_handleDelete varchar(max)
		print('PK Table Exists')
		
		set @merge_handleDelete = 'Merge into '+@tgtschema+'.'+@tablename+' T  Using stgtmp.PK_'+@tablename +' S ON (' + @mergecols + ')  
		When Not Matched By Source 
		Then Delete ;

		Drop table stgtmp.PK_'+@tablename+' ;'
		
		print(@merge_handleDelete)
		Exec(@merge_handleDelete)

		

	End
	
	SET @processsummary = 'Process Ended For ' + @tablename;





	EXEC [common].[usp_EU_Logger] 'common.EU_usp_PopulateSTG_Inc'
		,@processsummary
		,'INFO'
		,NULL
		,NULL
		,NULL
		,NULL
		,NULL
		,NULL;
END;
GO
/****** Object:  StoredProcedure [common].[usp_EU_ResultTableUpdate]    Script Date: 13-12-2023 18:35:24 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO






CREATE   PROCEDURE [common].[usp_EU_ResultTableUpdate]
	@json_value Nvarchar(MAX)
	,@batch_id bigint
	,@QueryType Varchar(max)
	,@tag Varchar(100)
	
AS
BEGIN

SELECT DISTINCT @batch_id as BatchID,MeasureName,@QueryType as SourceType,MeasureValue,getdate() as CompletionTime,@tag as tag 
into #temp
	FROM OPENJSON(@json_value) 
	WITH (
	   [value] NVARCHAR(MAX) '$.value' AS JSON
	) AS i
	CROSS APPLY (
	   SELECT *
	   FROM OPENJSON(i.[value])
	   WITH (
			[MeasureName] nvarchar(max) '$.MeasureName',
			[MeasureValue] nvarchar(max) '$.MeasureValue')
	) a
	Where [MeasureName] is not null




	if @QueryType = 'Source'
	Begin
	Merge into Common.[EU_ValidationResult] r
	using #temp t on r.Batchid = t.Batchid and r.TargetMeasureName = t.MeasureName
	When Matched 
	Then 
	Update Set R.SourceMeasureName = t.MeasureName,r.SourceResult = t.MeasureValue
	,r.CompletionTime = Getdate(),
	r.tag = t.tag,r.SourceType = t.SourceType
	when not matched then
	Insert(Batchid,SourceMeasureName,SourceResult,SourceType,CompletionTime,tag)
	values( t.Batchid,t.MeasureName,t.MeasureValue,t.SourceType,t.CompletionTime,t.tag)
	;
	
	end


	if @QueryType = 'Target'
	Begin
	Merge into Common.[EU_ValidationResult] r
	using #temp t on r.Batchid = t.Batchid and r.SourceMeasureName = t.MeasureName
	When Matched 
	Then 
	Update Set R.TargetMeasureName = t.MeasureName,r.TargetResult = t.MeasureValue
	,r.CompletionTime = Getdate(),
	r.tag = t.tag,r.SourceType = t.SourceType
	when not matched then
	Insert(Batchid,TargetMeasureName,TargetResult,SourceType,CompletionTime,tag)
	values( t.Batchid,t.MeasureName,t.MeasureValue,t.SourceType,t.CompletionTime,t.tag)
	;
	
	end


	END

	
GO
/****** Object:  StoredProcedure [common].[USP_EU_ValiadationStatus]    Script Date: 13-12-2023 18:35:24 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO





CREATE Procedure [common].[USP_EU_ValiadationStatus](@tag varchar(200)
)
as
Begin
	
Delete from common.eu_validationstatus where tag = @tag

Declare @source varchar(100)
Declare @Target varchar(100)

if @tag = 'Staging'
Begin
	Set @source = 'OnPrem'
	Set @Target = 'Staging'

End
else if @tag = 'Mart'
Begin
	Set @source = 'Staging'
	Set @Target = 'Mart'

End
else 
Begin
	Set @source = 'adhoc'
	Set @Target = 'adhoc'

End

Insert into common.EU_ValidationStatus
Select isnull(SourceMeasureName,TargetMeasureName),@source,SourceResult,@Target,TargetResult
,Case when (isnull(cast(SourceResult as decimal(18,4)),0) - isnull(cast(TargetResult as decimal(18,4)),0) < 100  and isnull(cast(SourceResult as decimal(18,4)),0) - isnull(cast(TargetResult as decimal(18,4)),0) >=0 )then 'Matched' 
else 'Not Matched' End,@tag
from common.EU_ValidationResult
where SourceMeasureName is not null and TargetMeasureName is not null 
Union all
Select isnull(SourceMeasureName,TargetMeasureName),@source,SourceResult,@Target,TargetResult
,Case
when SourceMeasureName is null or TargetMeasureName is null then Isnull(SourceResult,TargetResult) 
else 'Not Matched' End,@tag
from common.EU_ValidationResult
where SourceMeasureName is null or TargetMeasureName is null 

	END
GO
/****** Object:  StoredProcedure [dbo].[USP_EU_DimCurrency]    Script Date: 13-12-2023 18:35:24 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

  
  
  
  
CREATE  Procedure [dbo].[USP_EU_DimCurrency] 
as  
Begin  


if object_id('temp.EU_DimCurrency') is  not null
	Drop Table temp.EU_DimCurrency

if object_id('temp.EU_DimCurrency') is null
	 Create Table temp.EU_DimCurrency  
 (EffectiveDate date, SourceCurrCode Varchar(4), CurrentRate decimal(16,6), EntryPerson varchar(75), Reference varchar(30), TargetCurrCode Varchar(4)  
, refcode Varchar(4), Expr1 varchar(100), Currencycode Varchar(4)  
 ,DWHCreatedBy Varchar(200),DWHCreatedate datetime,DWHLastModifiedBy Varchar(200),DWHLastmodifiedDate datetime)  
  
;





  
Insert into temp.EU_DimCurrency(EffectiveDate, SourceCurrCode, CurrentRate, EntryPerson, Reference, TargetCurrCode   
, refcode, Expr1, Currencycode ,DWHCreatedBy,DWHCreatedate,DWHLastModifiedBy,DWHLastmodifiedDate)  
Select  EffectiveDate, SourceCurrCode, CurrentRate, EntryPerson, Reference, TargetCurrCode   
, SourceCurrCode AS refcode, CONVERT(CHAR(4), EffectiveDate, 100) + CONVERT(CHAR(4), EffectiveDate, 120) AS Expr1  
, TargetCurrCode AS Currencycode   
,user_name(),getdate(),user_name(),getdate()  
from EU_Stg.CurrExRate    

  
  
End  
GO
/****** Object:  StoredProcedure [dbo].[USP_EU_DIMCustomer]    Script Date: 13-12-2023 18:35:24 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


      
/***      
 Purpose: This stored procedure is designed to populate a temporary dimension table [temp.EU_DimCustomer] 
          from the staging tables [EU_Stg.Customer] and [EU_Stg.Customer_UD].
***/    
CREATE Procedure [dbo].[USP_EU_DIMCustomer]  
as      
Begin      

-- Check if the temporary dimension table [temp.EU_DimCustomer] already exists, drop it if it does.      
 if object_id('temp.EU_DimCustomer') is  not null      
  Drop Table temp.EU_DIMCustomer      

-- Create the temporary dimension table [temp.EU_DimCustomer].      
if object_id('temp.EU_DimCustomer') is null      
 Create Table temp.EU_DimCustomer      
 (DimCustomerID Int identity(1,1),CustID Varchar(20),Name Varchar(100),TerritoryID Int,Country Varchar(100), SalesRep Varchar(16),CustNum int,ShortChar01 Varchar(100)      
 ,CustomerEstablishedDate Date,	BillingStreet Varchar(300),	BillingCity varchar(50),	BillingState varchar(50),
 BillingZip	varchar(10),
 BillingCountry varchar(50),	CustomerCurrencyCode varchar(4),
 CustomerLanguageCode varchar(10)	,CustomerLanguage varchar(20),	SalesForceIDNK varchar(40) 

 ,DWHCreatedBy Varchar(200),DWHCreatedate datetime,DWHLastModifiedBy Varchar(200),DWHLastmodifiedDate datetime)      
      
;      
  
      
-- Insert data into the temporary dimension table [temp.EU_DimCustomer]      
Insert into temp.EU_DimCustomer(CustID,Name,TerritoryID,Country,SalesRep,CustNum,ShortChar01
,CustomerEstablishedDate	,BillingStreet	,BillingCity	,BillingState	,BillingZip	,BillingCountry	,
CustomerCurrencyCode	,CustomerLanguageCode	,CustomerLanguage	,SalesForceIDNK

,DWHCreatedBy,DWHCreatedate,DWHLastModifiedBy,DWHLastmodifiedDate)      
Select C.CustID, c.Name, c.TerritoryID, c.Country, CONVERT(nvarchar(15), c.SalesRepCode) AS SalesRep,C.CustNum,d.ShortChar01      
,EstDate                 as CustomerEstablishedDate
,CONCAT(BTAddress1, BTAddress2,BTAddress3)      as BillingStreet
,BTCity                    as BillingCity
,BTState                   as BillingState
,BTZip                      as BillingZip
,BTCountry                 as BillingCountry
,CurrencyCode            as CustomerCurrencyCode
,LangNameID              as CustomerLanguageCode
,CASE   WHEN LangNameID='deu' THEN 'German'
              WHEN LangNameID='nld' THEN 'Dutch'
              WHEN LangNameID='eng' THEN 'English'
              WHEN LangNameID='fra' THEN 'French'
              WHEN LangNameID='esp' THEN 'Spanish'
              ELSE 'Other'
END as CustomerLanguage
,SalesForceId_c          as SalesForceIDNK
,suser_id(),getdate(),suser_id(),getdate()      
from EU_Stg.Customer c      
Left join EU_Stg.Customer_UD d on c.SysRowID = d.ForeignSysRowID      
      
      
End   
GO
/****** Object:  StoredProcedure [dbo].[USP_EU_DimInvoice]    Script Date: 13-12-2023 18:35:24 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE Procedure [dbo].[USP_EU_DimInvoice](@LoadType varchar(100))
as
Begin

Declare @maxincrefreshdate date

Select  @maxincrefreshdate   = IncRefreshMaxDate
 from common.[EU_DataMartControlTable]
where TableName = 'EU_DIMInvoice'


Select @maxincrefreshdate

if @LoadType = 'ftl'
	if object_id('dbo.EU_DimInvoice') is  not null
	begin
		Drop Table dbo.EU_DimInvoice
		set @maxincrefreshdate = '1900-01-01'
	end

if object_id('dbo.EU_DimInvoice') is null
	Create Table dbo.EU_DimInvoice
	(DimCurrencyID Int identity(1,1),InvoiceNum int,InvoiceSuffix varchar(2),OrderNum INT,InvoiceDate date,CurrencyCode varchar(4)
	,CustNum	int,DWHCreatedBy Varchar(200),DWHCreatedate datetime,DWHLastModifiedBy Varchar(200),DWHLastmodifiedDate datetime)

;




--Insert into EU_DimInvoice(InvoiceNum,InvoiceSuffix,OrderNum,InvoiceDate,CurrencyCode,CustNum,DWHCreatedBy,DWHCreatedate,DWHLastModifiedBy,DWHLastmodifiedDate)

Select @maxincrefreshdate
Drop table if exists EU_DimInvoice_temp
Select InvoiceNum,InvoiceSuffix,OrderNum,InvoiceDate,CurrencyCode,CustNum
,user_name() as DWHCreatedBy,getdate() as DWHCreatedate,user_name() as DWHLastModifiedBy,getdate() as DWHLastmodifiedDate
Into EU_DimInvoice_temp
from EU_Stg.invchead
where changedate > Dateadd(DD,-5,@maxincrefreshdate)


Merge into EU_DimInvoice d
Using EU_DimInvoice_temp t on d.InvoiceNum = t.InvoiceNum
when matched 
then update set
d.InvoiceNum = t.InvoiceNum,
d.InvoiceSuffix = t.InvoiceSuffix,
d.OrderNum = t.OrderNum,
d.InvoiceDate = t.InvoiceDate,
d.CurrencyCode = t.CurrencyCode,
d.CustNum = t.CustNum,
DWHLastModifiedBy = suser_sname(),
DWHLastmodifiedDate = getdate()
When not matched then
Insert (InvoiceNum,InvoiceSuffix,OrderNum,InvoiceDate,CurrencyCode,CustNum,DWHCreatedBy,DWHCreatedate,DWHLastModifiedBy,DWHLastmodifiedDate)
values(t.InvoiceNum,t.InvoiceSuffix,t.OrderNum,t.InvoiceDate,t.CurrencyCode,t.CustNum,suser_sname(),Getdate(),suser_sname(),getdate())

;

Select @maxincrefreshdate = max(changedate) from EU_Stg.invchead;

update common.[EU_DataMartControlTable]
set IncRefreshMaxDate= @maxincrefreshdate
where TableName = 'EU_DIMInvoice'

End

GO
/****** Object:  StoredProcedure [dbo].[USP_EU_DimOrder]    Script Date: 13-12-2023 18:35:24 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



    
    
    
    
CREATE Procedure [dbo].[USP_EU_DimOrder]   
as    
Begin    
    
   
 if object_id('temp.EU_DimOrder') is  not null    
  Drop Table temp.EU_DimOrder    
    
if object_id('temp.EU_DimOrder') is null    
 Create Table temp.EU_DimOrder    
 (DimOrderID Int identity(1,1),OrderNum Int,OrderDate DateTime,CurrencyCode Varchar(4),custnum Int,
 PONum Varchar(50),EntryPerson Varchar(75),ShipToNum Varchar(14),RequestDate Date,TermsCode Varchar(4),NeedByDate Date
 ,ExchangeRate Decimal(18,4),TotalCharges Decimal(18,4),TotalMisc decimal(18,4),DocTotalCharges decimal(18,4)
,DocTotalMisc decimal(18,4),DocTotalDiscount decimal(18,4),OrderAmt decimal(18,4),DocOrderAmt decimal(18,4),
Date05 Datetime,FinishLocation_c Varchar(10),ShipLocation_c Varchar(10)
 ,DWHCreatedBy Varchar(200),DWHCreatedate datetime,DWHLastModifiedBy Varchar(200),DWHLastmodifiedDate datetime)    
    
;    

    
Insert into temp.EU_DimOrder(OrderNum,OrderDate,CurrencyCode,custnum,PONum,EntryPerson,ShipToNum,RequestDate,TermsCode,NeedByDate,ExchangeRate,TotalCharges,TotalMisc,DocTotalCharges
,DocTotalMisc,DocTotalDiscount,OrderAmt,DocOrderAmt,Date05,FinishLocation_c,ShipLocation_c

,DWHCreatedBy,DWHCreatedate,DWHLastModifiedBy,DWHLastmodifiedDate)    
Select O.OrderNum,cast(OrderDate as datetime) as OrderDate,o.CurrencyCode,O.custnum
, O.PONum, O.EntryPerson, O.ShipToNum, O.RequestDate, O.TermsCode, O.NeedByDate, O.ExchangeRate, 
              O.TotalCharges, O.TotalMisc, O.DocTotalCharges, O.DocTotalMisc, O.DocTotalDiscount, O.OrderAmt, O.DocOrderAmt, UD.Date05, 
             UD.FinishLocation_c, UD.ShipLocation_c
,user_id(),getdate(),user_id(),getdate()    
from EU_Stg.orderhed O
Left join EU_Stg.OrderHed_UD  UD on O.SysRowID = UD.ForeignSysRowID
    
    
End 
GO
/****** Object:  StoredProcedure [dbo].[USP_EU_DIMProduct]    Script Date: 13-12-2023 18:35:24 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


  
  
  
  
CREATE Procedure [dbo].[USP_EU_DIMProduct]  
as  
Begin  
  
if object_id('temp.EU_DimProduct') is not null   
 Drop Table temp.EU_DimProduct  
  
if object_id('temp.EU_DimProduct') is null  
 Create Table temp.EU_DimProduct  
 (DimProductID Int identity(1,1),PartNum Varchar(100),part Varchar(100)
 ,ProductIsActive Varchar(10),
-- ProductSource	Varchar(10),
 FlexID	Varchar(max),ProductFormat	Varchar(max),
 ProductDescription Varchar(max),	
 ProductMarket	Varchar(max),
 ProductSegment	Varchar(max),
 ProductClass Varchar(10),	
 ProductSearchWord	Varchar(10)
 ,ProductInventoryUoM Varchar(10)
 ,	ProductPurchasingUoM	Varchar(10),ProductSalesUoM	Varchar(6)
 ,ProductBornOnDate	Datetime2(7),ProductCreatedBy	Varchar(75)
 ,ProductSource	Varchar(100),	Trademark Varchar(50),	
 Film	Varchar(50),Hand	Varchar(50),Topcoat	Varchar(50),Adhesive	Varchar(50),Liner	Varchar(50),
 Color	Varchar(50),Adhesive2	Varchar(50),Liner2	Varchar(50),Remarks	Varchar(50),
 ProductRecognition	Varchar(50)

 ,DWHCreatedBy Varchar(200),DWHCreatedate datetime,DWHLastModifiedBy Varchar(200),DWHLastmodifiedDate datetime)  
  
;  

  
Insert into temp.EU_DimProduct  
Select PartNum, CASE WHEN partnum LIKE '%-%-_____/___-%' THEN CAST(partnum AS VARCHAR(18)) WHEN partnum LIKE '%-%-%/_-%' THEN CAST(partnum AS VARCHAR(16))                             WHEN partnum LIKE '%-%-______/___-%' THEN CAST(partnum AS VARCHAR(19)) 
WHEN partnum LIKE '%-%-______/__-%' THEN CAST(partnum AS VARCHAR(18))                             WHEN partnum LIKE '%-%-%/%-%' THEN CAST(partnum AS VARCHAR(17)) WHEN partnum LIKE '%-%-%-%' THEN CAST(partnum AS VARCHAR(14)) ELSE partnum END AS part  
 --, InActive                                           as ProductIsActive
  ,CASE WHEN InActive='0' THEN 'Y'
       ELSE 'N'
  END as ProductIsActive

,U.Character09                                as FlexID
,U.Character10                               as ProductFormat
,PartDescription                             as ProductDescription   
,U.Market_c                                    as ProductMarket
,U.Segment_c                                  as ProductSegment
,ClassID                                            as ProductClass
,SearchWord                                   as ProductSearchWord
,IUM                                                  as ProductInventoryUoM
,PUM                                                 as ProductPurchasingUoM
,SalesUM                                          as ProductSalesUoM
,CreatedOn                                      as ProductBornOnDate
,CreatedBy                                       as ProductCreatedBy
--,TypeCode                                       as ProductSource 
,  CASE WHEN TypeCode='P' THEN 'Purchased'
       WHEN TypeCode='M' THEN 'Manufactured'
       ELSE 'Unknown'
  END as ProductSource
,U.ShortChar01                               as Trademark
,U.ShortChar02                               as Film
,U.ShortChar03                               as Hand
,U.ShortChar04                               as Topcoat
,U.ShortChar05                               as Adhesive
,U.ShortChar06                               as Liner
,U.ShortChar07                               as Color
,U.ShortChar08                               as Adhesive2
,U.ShortChar09                               as Liner2
,U.ShortChar10                               as Remarks
,U.Character06                                as ProductRecognition
     
	   
	   ,user_id(),getdate(),user_id(),getdate()  
   from EU_STG.Part  p
  LEFT JOIN EU_STG.[Part_UD] U on P.SysRowID=U.ForeignSysRowID

  
End  
GO
/****** Object:  StoredProcedure [dbo].[USP_EU_FactInvoiceOpenOrders]    Script Date: 13-12-2023 18:35:24 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


/***
 Purpose: This stored procedure creates and populates a temporary fact table [temp.EU_FactInvoiceOpenOrders]
          with open order-related data, including both Euro and USD currency amounts.

***/
CREATE Procedure [dbo].[USP_EU_FactInvoiceOpenOrders]       
as        
Begin        
        
       
 if object_id('temp.EU_FactInvoiceOpenOrders') is  not null        
  Drop Table temp.EU_FactInvoiceOpenOrders        
        
if object_id('temp.EU_FactInvoiceOpenOrders') is null        
Create Table temp.EU_FactInvoiceOpenOrders(  
FactOrderID Int identity(1,1),OrderNum Int,OrderDate DateTime,CurrencyCode Varchar(4),custnum Int,  
 PONum Varchar(50),EntryPerson Varchar(75),ShipToNum Varchar(14),RequestDate Date,TermsCode Varchar(4)  
 ,NeedByDate Date  
 ,ExchangeRate Decimal(18,4),  
 Euro_TotalCharges Decimal(18,4),  
 Euro_TotalMisc Decimal(18,4),Euro_DocTotalCharges Decimal(18,4),Euro_DocTotalMisc Decimal(18,4) ,Euro_DocTotalDiscount Decimal(18,4) ,  
 Euro_OrderAmt Decimal(18,4) ,Euro_DocOrderAmt Decimal(18,4) ,Euro_UnitPrice Decimal(18,4) ,Euro_DocUnitPrice Decimal(18,4) ,  
 Euro_OrderQty Decimal(18,4) ,Euro_SellingQuantity Decimal(18,4),   
 USD_TotalCharges     Decimal(18,4),  
 USD_TotalMisc      Decimal(18,4),  
 USD_DocTotalCharges    Decimal(18,4),  
 USD_DocTotalMisc     Decimal(18,4),  
 USD_DocTotalDiscount    Decimal(18,4),  
 USD_OrderAmt      Decimal(18,4),  
 USD_DocOrderAmt     Decimal(18,4),  
 USD_UnitPrice      Decimal(18,4),  
 USD_DocUnitPrice     Decimal(18,4),  
 USD_OrderQty      Decimal(18,4),  
 USD_SellingQuantity       Decimal(18,4),  
  
Date05 Datetime,FinishLocation_c Varchar(10),ShipLocation_c Varchar(10),Part Varchar(100)  
 ,DWHCreatedBy Varchar(200),DWHCreatedate datetime,DWHLastModifiedBy Varchar(200),DWHLastmodifiedDate datetime  
  
 )  
 ;  
  
with cte as (   
--4679  
Select O.OrderNum, O.CustNum, O.PONum, O.EntryPerson, O.ShipToNum, O.RequestDate, O.OrderDate, O.TermsCode, O.NeedByDate, O.ExchangeRate,   
             O.CurrencyCode  
    , isnull(Case when O.CurrencyCode = 'EURO' then   Sum(O.TotalCharges)  
else SUM( O.TotalCharges * CR.CurrentRate) end,0)  as Euro_TotalCharges  
    , isnull(Case when O.CurrencyCode = 'EURO' then   Sum(O.TotalMisc)  
else SUM( O.TotalMisc * CR.CurrentRate) end,0)  as Euro_TotalMisc  
   , isnull(Case when O.CurrencyCode = 'EURO' then   Sum(O.DocTotalCharges)  
else SUM( O.DocTotalCharges * CR.CurrentRate) end,0)  as Euro_DocTotalCharges  
   , isnull(Case when O.CurrencyCode = 'EURO' then   Sum(O.DocTotalMisc)  
else SUM( O.DocTotalMisc * CR.CurrentRate) end,0)  as Euro_DocTotalMisc  
   , isnull(Case when O.CurrencyCode = 'EURO' then   Sum(O.DocTotalDiscount)  
else SUM( O.DocTotalDiscount * CR.CurrentRate) end,0)  as Euro_DocTotalDiscount  
   , isnull(Case when O.CurrencyCode = 'EURO' then   Sum(O.OrderAmt)  
else SUM( O.OrderAmt * CR.CurrentRate) end,0)  as Euro_OrderAmt  
   , isnull(Case when O.CurrencyCode = 'EURO' then   Sum(O.DocOrderAmt)  
else SUM( O.DocOrderAmt * CR.CurrentRate) end,0)  as Euro_DocOrderAmt  
   , isnull(Case when O.CurrencyCode = 'EURO' then   Sum(D.UnitPrice)  
else SUM( D.UnitPrice * CR.CurrentRate) end,0)  as Euro_UnitPrice  
  , isnull(Case when O.CurrencyCode = 'EURO' then   Sum(D.DocUnitPrice)  
else SUM( D.DocUnitPrice * CR.CurrentRate) end,0)  as Euro_DocUnitPrice  
  , isnull(Case when O.CurrencyCode = 'EURO' then   Sum(D.OrderQty)  
else SUM( D.OrderQty * CR.CurrentRate) end,0)  as Euro_OrderQty  
, isnull(Case when O.CurrencyCode = 'EURO' then   Sum(D.SellingQuantity)  
else SUM( D.SellingQuantity * CR.CurrentRate) end,0)  as Euro_SellingQuantity  
   , isnull(Case O.CurrencyCode  when 'USD' then   Sum(O.TotalCharges)  
when 'STG' then   Sum(O.TotalCharges * Cru.CurrentRate)  
else SUM( O.TotalCharges * 1/Cru.CurrentRate) end,0)  as USD_TotalCharges    
  
 , isnull(Case O.CurrencyCode  when 'USD' then   Sum(O.TotalMisc)  
when 'STG' then   Sum(O.TotalMisc * Cru.CurrentRate)  
else SUM( O.TotalMisc * 1/Cru.CurrentRate) end,0)  as USD_TotalMisc    
  
 , isnull(Case O.CurrencyCode  when 'USD' then   Sum(O.DocTotalCharges)  
when 'STG' then   Sum(O.DocTotalCharges * Cru.CurrentRate)  
else SUM( O.DocTotalCharges * 1/Cru.CurrentRate) end,0)  as USD_DocTotalCharges    
  
 , isnull(Case O.CurrencyCode  when 'USD' then   Sum(O.DocTotalMisc)  
when 'STG' then   Sum(O.DocTotalMisc * Cru.CurrentRate)  
else SUM( O.DocTotalMisc * 1/Cru.CurrentRate) end,0)  as USD_DocTotalMisc    
  
 , isnull(Case O.CurrencyCode  when 'USD' then   Sum(O.DocTotalDiscount)  
when 'STG' then   Sum(O.DocTotalDiscount * Cru.CurrentRate)  
else SUM( O.DocTotalDiscount * 1/Cru.CurrentRate) end,0)  as USD_DocTotalDiscount   
 , isnull(Case O.CurrencyCode  when 'USD' then   Sum(O.OrderAmt)  
when 'STG' then   Sum(O.OrderAmt * Cru.CurrentRate)  
else SUM( O.OrderAmt * 1/Cru.CurrentRate) end,0)  as USD_OrderAmt    
 , isnull(Case O.CurrencyCode  when 'USD' then   Sum(O.DocOrderAmt)  
when 'STG' then   Sum(O.DocOrderAmt * Cru.CurrentRate)  
else SUM( O.DocOrderAmt * 1/Cru.CurrentRate) end,0)  as USD_DocOrderAmt    
 , isnull(Case O.CurrencyCode  when 'USD' then   Sum(D.UnitPrice)  
when 'STG' then   Sum(D.UnitPrice * Cru.CurrentRate)  
else SUM( D.UnitPrice * 1/Cru.CurrentRate) end,0)  as USD_UnitPrice    
  
 , isnull(Case O.CurrencyCode  when 'USD' then   Sum(D.DocUnitPrice)  
when 'STG' then   Sum(D.DocUnitPrice * Cru.CurrentRate)  
else SUM( D.DocUnitPrice * 1/Cru.CurrentRate) end,0)  as USD_DocUnitPrice    
  
 , isnull(Case O.CurrencyCode  when 'USD' then   Sum(D.OrderQty)  
when 'STG' then   Sum(D.OrderQty * Cru.CurrentRate)  
else SUM( D.OrderQty * 1/Cru.CurrentRate) end,0)  as USD_OrderQty   
  
 , isnull(Case O.CurrencyCode  when 'USD' then   Sum(D.SellingQuantity)  
when 'STG' then   Sum(D.SellingQuantity * Cru.CurrentRate)  
else SUM( D.SellingQuantity * 1/Cru.CurrentRate) end,0)  as USD_SellingQuantity   
  
    , Ud.Date05,   
             UD.FinishLocation_c, UD.ShipLocation_c, p.Part  
      
    
--from dbo.EU_Dimorder o   
from EU_Stg.orderhed O  
Left join EU_Stg.OrderHed_UD  UD on O.SysRowID = UD.ForeignSysRowID  
  
left join eu_stg.invchead h on o.ordernum = h.ordernum   
  
Inner join EU_STG.orderdtl d on o.ordernum = d.ordernum and kitflag <> 'C' --5930   
  
Left join temp.EU_DimCurrency  Cr ON o.CurrencyCode = cr.SourceCurrCode    
AND MONTH(o.Orderdate) = MONTH(cr.EffectiveDate) AND YEAR(o.Orderdate) = YEAR(cr.EffectiveDate)     
and (CR.TargetCurrCode <> 'USD')  and CR.EntryPerson <> N'WMitchell'  
  
  
Left join temp.EU_DimCurrency  Cru ON o.CurrencyCode = Cru.SourceCurrCode    
AND MONTH(o.Orderdate) = MONTH(Cru.EffectiveDate) AND YEAR(o.Orderdate) = YEAR(Cru.EffectiveDate)     
and ((Cru.SourceCurrCode='STG' and Cru.TargetCurrCode = 'USD') or (Cru.SourceCurrCode='USD' and Cru.TargetCurrCode = 'EURO') )  and Cru.EntryPerson <> N'WMitchell'  
  
  
  
Inner join temp.EU_Dimcustomer c on c.custnum = o.custnum   

Left join  (
Select dtl.PartNum,hed.ordernum
From EU_stg.[OrderHed] hed
Inner join EU_STG.[OrderDtl]  dtl on hed.ordernum = dtl.ordernum
 and dtl.orderline =1  
)idp on o.ordernum = idp.ordernum
left join temp.EU_DimProduct p on idp.PartNum = p.PartNum

where h.invoicenum is null   
  
Group by o.ordernum,O.OrderNum, O.CustNum, O.PONum, O.EntryPerson, O.ShipToNum, O.RequestDate, O.OrderDate, O.TermsCode, O.NeedByDate, O.ExchangeRate,   
             O.CurrencyCode  
    --, O.TotalCharges  
    --, O.TotalMisc, O.DocTotalCharges, O.DocTotalMisc, O.DocTotalDiscount, O.OrderAmt, O.DocOrderAmt  
    , UD.Date05,   
             UD.FinishLocation_c, UD.ShipLocation_c, P.Part  
    --, D.UnitPrice, D.DocUnitPrice, D.OrderQty, D.SellingQuantity  
  
)   
Insert into temp.EU_FactInvoiceOpenOrders(OrderNum,CustNum,PONum,EntryPerson,ShipToNum,RequestDate,OrderDate,TermsCode,NeedByDate,ExchangeRate,CurrencyCode,Euro_TotalCharges,Euro_TotalMisc,  
Euro_DocTotalCharges,Euro_DocTotalMisc,Euro_DocTotalDiscount,Euro_OrderAmt,Euro_DocOrderAmt,Euro_UnitPrice,Euro_DocUnitPrice,Euro_OrderQty,Euro_SellingQuantity,  
USD_TotalCharges,USD_TotalMisc,USD_DocTotalCharges,USD_DocTotalMisc,USD_DocTotalDiscount,USD_OrderAmt,USD_DocOrderAmt,USD_UnitPrice,USD_DocUnitPrice,USD_OrderQty,  
USD_SellingQuantity,Date05,FinishLocation_c,ShipLocation_c,Part,DWHCreatedBy ,DWHCreatedate ,DWHLastModifiedBy ,DWHLastmodifiedDate)  
Select OrderNum,CustNum,PONum,EntryPerson,ShipToNum,RequestDate,OrderDate,TermsCode,NeedByDate,ExchangeRate,CurrencyCode,Euro_TotalCharges,Euro_TotalMisc,  
Euro_DocTotalCharges,Euro_DocTotalMisc,Euro_DocTotalDiscount,Euro_OrderAmt,Euro_DocOrderAmt,Euro_UnitPrice,Euro_DocUnitPrice,Euro_OrderQty,Euro_SellingQuantity,  
USD_TotalCharges,USD_TotalMisc,USD_DocTotalCharges,USD_DocTotalMisc,USD_DocTotalDiscount,USD_OrderAmt,USD_DocOrderAmt,USD_UnitPrice,USD_DocUnitPrice,USD_OrderQty,  
USD_SellingQuantity,Date05,FinishLocation_c,ShipLocation_c,Part   
,SUSER_NAME() ,Getdate() ,SUSER_NAME() ,Getdate()  
from cte   
  
  
  
End  
  
  
GO
/****** Object:  StoredProcedure [dbo].[USP_EU_FactInvoiceSalesOrders]    Script Date: 13-12-2023 18:35:24 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

            
        
        
/***
Purpose: This stored procedure populates a temporary fact table [temp.EU_FactInvoiceSalesOrders]
         from various staging tables with sales and invoice-related data.

***/
CREATE Procedure [dbo].[USP_EU_FactInvoiceSalesOrders]       
as        
Begin        
        
       
 if object_id('temp.EU_FactInvoiceSalesOrders') is  not null        
  Drop Table temp.EU_FactInvoiceSalesOrders        

-- Create the temporary fact table [temp.EU_FactInvoiceSalesOrders].

if object_id('temp.EU_FactInvoiceSalesOrders') is null        
Create Table temp.EU_FactInvoiceSalesOrders(FactInvoiceID Int Identity(1,1), InvoiceNum   Varchar(100),InvoiceSuffix  Varchar(2) ,DimCustomerID  Int,OrderNum   INT  
,M2Qty    Decimal(17,10),CustServiceRep  Varchar(100),STGtoEURORate  Decimal(17,10),SalesRepName  Varchar(60)  
,InvoiceDate   Date,OrderDate   Date,TargetCurrCode  Varchar(4),Euro_TotalCost  Decimal(17,10)  
,LM     Decimal(17,10),Currencycode  Varchar(4),Expr1    Varchar(4),part    Varchar(100)  
,CurrentRate   Decimal(17,10),STG_TotalCost  Decimal(17,10),DWHCreatedBy Varchar(200),DWHCreatedate datetime,DWHLastModifiedBy Varchar(200),DWHLastmodifiedDate datetime)     
  
;  
  
with cte as  
(  
SELECT   ih.InvoiceNum,ih.InvoiceSuffix,C.DimCustomerID  
, ih.OrderNum, SUM(id.SellingShipQty) AS M2Qty,sr.ShortChar03 AS CustServiceRep,Cr.CurrentRate as STGtoEURORate, slr.Name AS SalesRepName,ih.InvoiceDate,count(*) as cnt   
,o.OrderDate  
,cr.TargetCurrCode  
, isnull(Case when ih.CurrencyCode = 'EURO' then  SUM(((id.DocExtPrice + id.DocTotalMiscChrg) - (id.DocAdvanceBillCredit + id.DocDiscount)))  
else SUM(((id.DocExtPrice + id.DocTotalMiscChrg) - (id.DocAdvanceBillCredit + id.DocDiscount))* CR.CurrentRate)   
end,0)  AS Euro_TotalCost  
, SUM(id.OurShipQty) AS LM  
,Cr.Currencycode  
, ih.CurrencyCode AS Expr1  
,p.part  
,Cr.CurrentRate  
,SUM(((id.DocExtPrice + id.DocTotalMiscChrg) - (id.DocAdvanceBillCredit + id.DocDiscount))) AS STG_TotalCost  
  
FROM   
EU_stg.Invchead  Ih   
Inner join temp.EU_DimCustomer C on c.CustNum = ih.CustNum  
Left join EU_stg.UD21 sr on sr.Key1 = C.ShortChar01   
Left join temp.EU_DimCurrency  Cr ON IH.CurrencyCode = cr.SourceCurrCode    
AND MONTH(IH.InvoiceDate) = MONTH(cr.EffectiveDate) AND YEAR(IH.InvoiceDate) = YEAR(cr.EffectiveDate)     
and (CR.TargetCurrCode <> 'USD')  and CR.EntryPerson <> N'WMitchell'  
LEFT OUTER JOIN EU_STG.[OrderHed] o ON ih.OrderNum = o.OrderNum    
Left OUTER JOIN EU_STG.SalesRep AS slr ON slr.SalesRepCode = c.SalesRep  
Left join  EU_STG.InvcDtl AS id ON ih.InvoiceNum = id.InvoiceNum  
--Left join  EU_STG.InvcDtl AS idp ON ih.InvoiceNum = idp.InvoiceNum  
Left join  (
Select dtl.PartNum,hed.InvoiceNum
From EU_stg.Invchead hed
Inner join EU_STG.InvcDtl  dtl on hed.InvoiceNum = dtl.InvoiceNum
 and dtl.invoiceline =1  
)idp on ih.InvoiceNum = idp.InvoiceNum
left join temp.EU_DimProduct p on idp.PartNum = p.PartNum
WHERE        (NOT (CONVERT(nvarchar(MAX), id.LineDesc) LIKE N'%Startup%')) OR    
                         (NOT (CONVERT(nvarchar(MAX), id.LineDesc) LIKE N'%Startup%'))    
GROUP BY ih.InvoiceNum,ih.InvoiceSuffix,C.DimCustomerID  
--,P.part  
, ih.OrderNum  
, sr.ShortChar03  
,Cr.CurrentRate  
, slr.Name    
,ih.InvoiceDate  
,o.OrderDate  
,cr.TargetCurrCode  
,ih.CurrencyCode  
,cr.Currencycode  
,p.part  
  --                       dbo.FLX_EXCHANGERATE_BASE_TO_EURO.CurrentRate, dbo.MasterPart_forSalesAnalysis_view.part, CAST(ih.InvoiceDate AS datetime), dbo.FLX_EXCHANGERATE_BASE_TO_EURO.Currencycode,     
    --                     CAST(EU_STG.OrderHed.OrderDate AS datetime), cr.TargetCurrCode, ih.CurrencyCode, cr.SourceCurrCode, cr.CurrentRate, dbo.MasterPart_forSalesAnalysis_view.InvoiceNum    
HAVING        (ih.InvoiceSuffix <> 'UR')    
)  
Insert into temp.EU_FactInvoiceSalesOrders(InvoiceNum,InvoiceSuffix,DimCustomerID,OrderNum,M2Qty,CustServiceRep,STGtoEURORate,SalesRepName,InvoiceDate,OrderDate,TargetCurrCode,Euro_TotalCost,LM,Currencycode,Expr1,part,CurrentRate  
,STG_TotalCost,DWHCreatedBy ,DWHCreatedate ,DWHLastModifiedBy ,DWHLastmodifiedDate)   
select   InvoiceNum,InvoiceSuffix,DimCustomerID,OrderNum,M2Qty,CustServiceRep,STGtoEURORate,SalesRepName,InvoiceDate,OrderDate,TargetCurrCode,Euro_TotalCost,LM,Currencycode,Expr1,part,CurrentRate  
,STG_TotalCost,SUSER_NAME() ,Getdate() ,SUSER_NAME() ,Getdate()  From CTE  
  
End  
  
  
  
GO
GO

Print('Schema Creation Successfully Completed')
go
SET IDENTITY_INSERT [common].[EU_DatamartcontrolTable] ON 
GO
INSERT [common].[EU_DatamartcontrolTable] ([Id], [MartName], [ProcedureName], [StoredProcedure], [TableSchema], [TableName], [CustomField], [DependsOn], [IsActive], [Tag], [PublishFlag], [CreatedBy], [CreatedDateTime], [UpdatedBy], [UpdatedDateTime]) VALUES (1, N'Mart', N'EU_DIMInvoice', N'dbo.USP_EU_DimInvoice', N'dbo', N'EU_DIMInvoice', NULL, NULL, 0, N'Mart', 1, N'sqladmin', CAST(N'2023-11-17T05:40:31.033' AS DateTime), N'sqladmin', CAST(N'2023-11-17T05:40:31.033' AS DateTime))
GO
INSERT [common].[EU_DatamartcontrolTable] ([Id], [MartName], [ProcedureName], [StoredProcedure], [TableSchema], [TableName], [CustomField], [DependsOn], [IsActive], [Tag], [PublishFlag], [CreatedBy], [CreatedDateTime], [UpdatedBy], [UpdatedDateTime]) VALUES (2, N'Mart', N'EU_DIMOrder', N'dbo.USP_EU_DimOrder', N'dbo', N'EU_DIMOrder', NULL, NULL, 0, N'Mart', 1, N'sqladmin', CAST(N'2023-11-17T05:40:31.037' AS DateTime), N'sqladmin', CAST(N'2023-11-17T05:40:31.037' AS DateTime))
GO
INSERT [common].[EU_DatamartcontrolTable] ([Id], [MartName], [ProcedureName], [StoredProcedure], [TableSchema], [TableName], [CustomField], [DependsOn], [IsActive], [Tag], [PublishFlag], [CreatedBy], [CreatedDateTime], [UpdatedBy], [UpdatedDateTime]) VALUES (3, N'Mart', N'EU_DIMCustomer', N'dbo.USP_EU_DIMCustomer', N'dbo', N'EU_DIMCustomer', NULL, NULL, 1, N'Mart', 1, N'sqladmin', CAST(N'2023-11-17T05:40:31.040' AS DateTime), N'sqladmin', CAST(N'2023-11-17T05:40:31.040' AS DateTime))
GO
INSERT [common].[EU_DatamartcontrolTable] ([Id], [MartName], [ProcedureName], [StoredProcedure], [TableSchema], [TableName], [CustomField], [DependsOn], [IsActive], [Tag], [PublishFlag], [CreatedBy], [CreatedDateTime], [UpdatedBy], [UpdatedDateTime]) VALUES (4, N'Mart', N'EU_DIMProduct', N'dbo.USP_EU_DIMProduct', N'dbo', N'EU_DIMProduct', NULL, NULL, 1, N'Mart', 1, N'sqladmin', CAST(N'2023-11-17T05:40:31.060' AS DateTime), N'sqladmin', CAST(N'2023-11-17T05:40:31.060' AS DateTime))
GO
INSERT [common].[EU_DatamartcontrolTable] ([Id], [MartName], [ProcedureName], [StoredProcedure], [TableSchema], [TableName], [CustomField], [DependsOn], [IsActive], [Tag], [PublishFlag], [CreatedBy], [CreatedDateTime], [UpdatedBy], [UpdatedDateTime]) VALUES (5, N'Mart', N'EU_DimCurrency', N'dbo.USP_EU_DIMCurrency', N'dbo', N'EU_DimCurrency', NULL, NULL, 1, N'Mart', 1, N'sqladmin', CAST(N'2023-11-17T05:40:31.060' AS DateTime), N'sqladmin', CAST(N'2023-11-17T05:40:31.060' AS DateTime))
GO
INSERT [common].[EU_DatamartcontrolTable] ([Id], [MartName], [ProcedureName], [StoredProcedure], [TableSchema], [TableName], [CustomField], [DependsOn], [IsActive], [Tag], [PublishFlag], [CreatedBy], [CreatedDateTime], [UpdatedBy], [UpdatedDateTime]) VALUES (6, N'Mart', N'EU_FactInvoiceSalesOrders', N'dbo.USP_EU_FactInvoiceSalesOrders', N'dbo', N'EU_FactInvoiceSalesOrders', NULL, N'EU_DimCurrency,EU_DIMCustomer', 1, N'Mart', 1, N'sqladmin', CAST(N'2023-11-23T10:46:04.033' AS DateTime), N'sqladmin', CAST(N'2023-11-23T10:46:04.033' AS DateTime))
GO
INSERT [common].[EU_DatamartcontrolTable] ([Id], [MartName], [ProcedureName], [StoredProcedure], [TableSchema], [TableName], [CustomField], [DependsOn], [IsActive], [Tag], [PublishFlag], [CreatedBy], [CreatedDateTime], [UpdatedBy], [UpdatedDateTime]) VALUES (7, N'Mart', N'EU_FactInvoiceOpenOrders', N'dbo.USP_EU_FactInvoiceOpenOrders', N'dbo', N'EU_FactInvoiceOpenOrders', NULL, N'EU_DimCurrency,EU_DIMCustomer', 1, N'Mart', 1, N'sqladmin', CAST(N'2023-11-23T10:46:27.493' AS DateTime), N'sqladmin', CAST(N'2023-11-23T10:46:27.493' AS DateTime))
GO
SET IDENTITY_INSERT [common].[EU_DatamartcontrolTable] OFF
GO
SET IDENTITY_INSERT [common].[EU_RDBMSControlTable] ON 
GO
INSERT [common].[EU_RDBMSControlTable] ([ControlID], [BusinessArea], [SrcConnectionFriendlyName], [SrcTableSchema], [SrcTableName], [TgtConnectionFriendlyName], [TgtTableSchema], [TgtTableName], [TgtRootContainer], [TgtFileName], [ColumnList], [Query], [PrimaryKeyList], [IncRefreshColumn], [LastRefreshDate], [LastRefreshStatus], [IsActive], [Tag], [RefreshStartDate], [IncRefreshMaxDate], [latest_file_path], [AdditionalFilterConditions], [IsDelete]) VALUES (1, N'EpicorERP', N'STG_OnPremConnection', N'erp', N'Customer', N'TGT_AzureSQLConnection', N'EU_stg', N'Customer', N'raw', NULL, N'Company, CustID, CustNum, Name, Address1, Address2, Address3, City, State, Zip, Country, ResaleID, SalesRepCode, TerritoryID, ShipToNum, TermsCode, ShipViaCode, PrintStatements, PrintLabels, PrintAck, FinCharges, CreditHold, GroupCode, DiscountPercent, PrimPCon, PrimBCon, PrimSCon, Comment, EstDate, FaxNum, PhoneNum, TaxExempt, MarkUpID, BillDay, OneInvPerPS, DefaultFOB, CreditIncludeOrders, CreditReviewDate, CreditHoldDate, CreditHoldSource, CreditClearUserID, CreditClearDate, CreditClearTime, EDICode, CurrencyCode, CountryNum, LangNameID, BorderCrossing, FormatStr, BTName, BTAddress1, BTAddress2, BTAddress3, BTCity, BTState, BTZip, BTCountryNum, BTCountry, BTPhoneNum, BTFaxNum, BTFormatStr, ParentCustNum, TaxRegionCode, ICCust, ContBillDay, EMailAddress, ShippingQualifier, AllocPriorityCode, ReservePriorityCode, LinkPortNum, WebCustomer, CustomerType, NoContact, TerritoryLock, CustURL, PendingTerritoryID, ExtID, ConsolidateSO, BillFrequency, CreditIncludePI, GlobalCust, ICTrader, TaxAuthorityCode, ExternalDeliveryNote, GlobalCredIncOrd, GlobalCredIncPI, GlobalCurrencyCode, ExternalID, GlobalCreditHold, GlobalLock, CheckDuplicatePO, CreditLimit, CustPILimit, GlobalCreditLimit, GlobalPILimit, DocGlobalCreditLimit, DocGlobalPILimit, RfqAttachAllow, DiscountQualifier, AllowAltBillTo, DemandDeliveryDays, DemandDateType, DemandAddLeadTime, DemandAddAction, DemandChangeLeadTime, DemandChangeAction, DemandCancelLeadTime, DemandCancelAction, DemandNewLineLeadTime, DemandNewLineAction, DemandQtyChangeLeadTime, DemandQtyChangeAction, DemandChangeDateLeadTime, DemandChangeDateAction, TradingPartnerName, ResDelivery, SatDelivery, SatPickup, Hazmat, DocOnly, RefNotes, ApplyChrg, ChrgAmount, COD, CODFreight, CODCheck, CODAmount, GroundType, NotifyFlag, NotifyEMail, DeclaredIns, DeclaredAmt, PeriodicityCode, ServSignature, ServAlert, ServHomeDel, DeliveryType, ServDeliveryDate, ServPhone, ServInstruct, ServRelease, ServAuthNum, ServRef1, ServRef2, ServRef3, ServRef4, ServRef5, EarlyBuffer, LateBuffer, DemandUnitPriceDiff, DemandUnitPriceDiffAction, ExcFromVal, AddressVal, RebateVendorNum, RebateForm, CreditCardOrder, DemandCheckForPart, DemandCheckForPartAction, ChangedBy, ChangeDate, ChangeTime, ChargeCode, IndividualPackIDs, IntrntlShip, CertOfOrigin, CommercialInvoice, ShipExprtDeclartn, LetterOfInstr, FFID, FFCompName, FFAddress1, FFAddress2, FFAddress3, FFCity, FFState, FFZip, FFCountry, FFCountryNum, FFPhoneNum, NonStdPkg, DeliveryConf, AddlHdlgFlag, UPSQuantumView, UPSQVShipFromName, UPSQVMemo, UPSQVEmailType, FFContact, ETCAddrChg, TaxRoundRule, TaxMethod, ValidPayer, ValidSoldTo, ValidShipTo, OverrideRlsClass, AcrossNatAcc, NAParentCreditIsUsed, NACreditIsShare, NACreditPreferenceList, NAParentCreditPrc, NACreditSharedPrc, AllowOTS, ThirdPLCust, ManagedVendID, ManagedVendNum, NARlsClassCode, DirectDebiting, ReminderCode, GlbNAParentCreditIsUsed, GlbNACreditIsShare, GlbNAParentCreditPrc, GlbNACreditSharedPrc, AllowShipTo3, OTSSaveAs, CustPartOpts, HasBank, PMUID, DemandCheckForRev, OrderHoldForReview, DemandCheckForRevAction, ShipToTerrList, AcctRefNumber, LegalName, TaxRegReason, InvPerPackLine, OrgRegCode, DemandCloseRejSkd, OurBankCode, DemandCloseNoMatch, DmdCheckPartialShip, DmdCheckShipAction, DemandCheckCUMM, DemandCheckCUMMAction, DemandPricing, PriceTolerance, PreferredBank, CheckDateCapPromise, CheckConfirmCapPromise, CheckUpdateCapPromise, DemandCapPromiseDate, DemandCapPromiseAction, DemandCapPromiseUpdate, PeriodicBilling, DueDateCriteria, PBTerms, ERSOrder, DemandSplitSched, OTSmartString, DeferredRev, RACode, DemandCheckConfig, DemandCheckCfgAction, AllowAsAltRemitTo, FederalID, WIApplication, WICustomer, WIShippingCosts, LOQBookPCFinishing, LOQBookPCPaper, LOQBookPCPress, LOQBookPCPlates, Variations, OversPct, UndersPct, DefaultLOQstyle, DefaultOrderAcknowledgement, DefaultPackSlip, DefaultOversPricing, LOQPrepressStyle, CSR, LOQBookCaFinishing, LOQBookCapaper, LOQBookCaPress, LOQBookCatPlates, LOQVariations, DefaultInvoicestyle, AEPLOQType, BusinessCust, SysRevID, SysRowID, THBranchID, CustPricingSchema, ParamCode, AGAFIPResponsibilityCode, AGBillToProvinceCode, AGGrossIncomeTaxID, AGIDDocTypeCode, AGIDDocumentNumber, AGProvinceCode, AGUseGoodDefaultMark, Collections, CollectionsDate, DateCollectionPosted, MXMunicipio, PEIdentityDocType, PEDocumentID, PEGoodsContributor, PEWithholdAgent, PECollectionAgent, PENotFound, PENoAddress, EntityUseCode, InvcOrderCmpDflt, EInvoice, RegistrationCode, EAddress, DemandCheckForRunOutPart, DemandCheckForRunOutPartAction, EInvCompanyIDAttr, INCSTNumber, INPANNumber, COOneTimeID, COIsOneTimeCust, DEOrgType, PEGuaranteeName, PEGuaranteeAddress1, PEGuaranteeAddress2, PEGuaranteeAddress3, PEGuaranteeCity, PEGuaranteeState, PEGuaranteeZip, PEGuaranteeCountry, PEGuaranteePhoneNum, PEGuaranteeTaxID, OurSupplierCode, ECCType, MYIndustryCode, SyncToExternalCRM, ExternalCRMCustomerID, ExternalCRMCustomerType, ExternalCRMLastSync, ExternalCRMSyncRequired, Ownership, Industry, AnnualRevenue, NumberOfEmployees, TickerLocation, TickerSymbol, Rating, TWGUIRegNum, MXAccountNumber, ConsolidateLinesPerPart, TWTaxPayerType, TWDeductGUIFormatCode, MXCURP, PEAddressID, PEPerceptionRegime, TaxEntityType, INGSTComplianceRate, INTaxRegistrationID, MXPurchaseType, SendToFSA, MXGeneralPublic, AgingCreditHold, AgingCreditHoldDate, AgingCreditHoldSource, AgingCreditClearUserID, AgingCreditClearDate, AgingCreditCode, ImporterOfRecord, SEC, EInvEndpointIDAttr, UseBlindShipping, ELIEinvoice, ELIDefReportID, ELIDefStyleNum, ELIDefToMail, ELIDefCCMail, ELIDefMailTempID, ELISendMail, COFiscalResp1, COFiscalResp2, COFiscalResp3, COOperType, CentralCollection, NettingVendorNum, EORINumber, AGIsElectronicCreditInvEligible, TaxValidationStatus, TaxValidationDate, HMRCTaxValidationLog, Inactive, ExternalSchemeID, ELIOperatorCode, ELISendingOption, ELIOperatorID, EInvExternalID, MXTaxRegime', NULL, N'Company,CustNum', N'ChangeDate', CAST(N'2023-12-13T05:31:48.3966667' AS DateTime2), N'Succeeded', 1, N'RDBMS', CAST(N'2023-12-13T05:30:55.2133333' AS DateTime2), CAST(N'2023-12-12T00:00:00.000' AS DateTime), N'', NULL, 1)
GO
INSERT [common].[EU_RDBMSControlTable] ([ControlID], [BusinessArea], [SrcConnectionFriendlyName], [SrcTableSchema], [SrcTableName], [TgtConnectionFriendlyName], [TgtTableSchema], [TgtTableName], [TgtRootContainer], [TgtFileName], [ColumnList], [Query], [PrimaryKeyList], [IncRefreshColumn], [LastRefreshDate], [LastRefreshStatus], [IsActive], [Tag], [RefreshStartDate], [IncRefreshMaxDate], [latest_file_path], [AdditionalFilterConditions], [IsDelete]) VALUES (2, N'EpicorERP', N'STG_OnPremConnection', N'erp', N'CurrExRate', N'TGT_AzureSQLConnection', N'EU_stg', N'CurrExRate', N'raw', NULL, N'Company, SourceCurrCode, EffectiveDate, CurrentRate, SysDate, SysTime, EntryPerson, Reference, TargetCurrCode, RateGrpCode, SysRevID, SysRowID', NULL, N'Company,RateGrpCode,SourceCurrCode,TargetCurrCode,EffectiveDate', NULL, CAST(N'2023-12-13T05:31:47.4766667' AS DateTime2), N'Succeeded', 1, N'RDBMS', CAST(N'2023-12-13T05:30:55.2133333' AS DateTime2), CAST(N'1900-01-01T00:00:00.000' AS DateTime), N'', NULL, NULL)
GO
INSERT [common].[EU_RDBMSControlTable] ([ControlID], [BusinessArea], [SrcConnectionFriendlyName], [SrcTableSchema], [SrcTableName], [TgtConnectionFriendlyName], [TgtTableSchema], [TgtTableName], [TgtRootContainer], [TgtFileName], [ColumnList], [Query], [PrimaryKeyList], [IncRefreshColumn], [LastRefreshDate], [LastRefreshStatus], [IsActive], [Tag], [RefreshStartDate], [IncRefreshMaxDate], [latest_file_path], [AdditionalFilterConditions], [IsDelete]) VALUES (4, N'EpicorERP', N'STG_OnPremConnection', N'erp', N'CustCnt_UD', N'TGT_AzureSQLConnection', N'EU_stg', N'CustCnt_UD', N'raw', NULL, N'*', NULL, NULL, NULL, CAST(N'2023-12-13T05:31:50.9233333' AS DateTime2), N'Succeeded', 1, N'RDBMS', CAST(N'2023-12-13T05:30:55.2133333' AS DateTime2), CAST(N'1900-01-01T00:00:00.000' AS DateTime), N'', NULL, NULL)
GO
INSERT [common].[EU_RDBMSControlTable] ([ControlID], [BusinessArea], [SrcConnectionFriendlyName], [SrcTableSchema], [SrcTableName], [TgtConnectionFriendlyName], [TgtTableSchema], [TgtTableName], [TgtRootContainer], [TgtFileName], [ColumnList], [Query], [PrimaryKeyList], [IncRefreshColumn], [LastRefreshDate], [LastRefreshStatus], [IsActive], [Tag], [RefreshStartDate], [IncRefreshMaxDate], [latest_file_path], [AdditionalFilterConditions], [IsDelete]) VALUES (7, N'EpicorERP', N'STG_OnPremConnection', N'erp', N'CustomerPriceLst', N'TGT_AzureSQLConnection', N'EU_stg', N'CustomerPriceLst', N'raw', NULL, N'Company, CustNum, ShipToNum, SeqNum, ListCode, SysRevID, SysRowID', NULL, N'Company,CustNum,ShipToNum,SeqNum', NULL, CAST(N'2023-12-13T05:31:44.8700000' AS DateTime2), N'Succeeded', 1, N'RDBMS', CAST(N'2023-12-13T05:30:55.2133333' AS DateTime2), CAST(N'1900-01-01T00:00:00.000' AS DateTime), N'', NULL, NULL)
GO
INSERT [common].[EU_RDBMSControlTable] ([ControlID], [BusinessArea], [SrcConnectionFriendlyName], [SrcTableSchema], [SrcTableName], [TgtConnectionFriendlyName], [TgtTableSchema], [TgtTableName], [TgtRootContainer], [TgtFileName], [ColumnList], [Query], [PrimaryKeyList], [IncRefreshColumn], [LastRefreshDate], [LastRefreshStatus], [IsActive], [Tag], [RefreshStartDate], [IncRefreshMaxDate], [latest_file_path], [AdditionalFilterConditions], [IsDelete]) VALUES (10, N'EpicorERP', N'STG_OnPremConnection', N'erp', N'InvcDtl_UD', N'TGT_AzureSQLConnection', N'EU_stg', N'InvcDtl_UD', N'raw', NULL, N'*', NULL, NULL, NULL, CAST(N'2023-12-13T05:32:09.3166667' AS DateTime2), N'Succeeded', 1, N'RDBMS', CAST(N'2023-12-13T05:30:55.2133333' AS DateTime2), CAST(N'1900-01-01T00:00:00.000' AS DateTime), N'', NULL, NULL)
GO
INSERT [common].[EU_RDBMSControlTable] ([ControlID], [BusinessArea], [SrcConnectionFriendlyName], [SrcTableSchema], [SrcTableName], [TgtConnectionFriendlyName], [TgtTableSchema], [TgtTableName], [TgtRootContainer], [TgtFileName], [ColumnList], [Query], [PrimaryKeyList], [IncRefreshColumn], [LastRefreshDate], [LastRefreshStatus], [IsActive], [Tag], [RefreshStartDate], [IncRefreshMaxDate], [latest_file_path], [AdditionalFilterConditions], [IsDelete]) VALUES (22, N'EpicorERP', N'STG_OnPremConnection', N'erp', N'PartWhse_UD', N'TGT_AzureSQLConnection', N'EU_stg', N'PartWhse_UD', N'raw', NULL, N'*', NULL, NULL, NULL, CAST(N'2023-12-13T05:31:48.7466667' AS DateTime2), N'Succeeded', 1, N'RDBMS', CAST(N'2023-12-13T05:30:55.2133333' AS DateTime2), CAST(N'1900-01-01T00:00:00.000' AS DateTime), N'', NULL, NULL)
GO
INSERT [common].[EU_RDBMSControlTable] ([ControlID], [BusinessArea], [SrcConnectionFriendlyName], [SrcTableSchema], [SrcTableName], [TgtConnectionFriendlyName], [TgtTableSchema], [TgtTableName], [TgtRootContainer], [TgtFileName], [ColumnList], [Query], [PrimaryKeyList], [IncRefreshColumn], [LastRefreshDate], [LastRefreshStatus], [IsActive], [Tag], [RefreshStartDate], [IncRefreshMaxDate], [latest_file_path], [AdditionalFilterConditions], [IsDelete]) VALUES (23, N'EpicorERP', N'STG_OnPremConnection', N'erp', N'PLPartBrk', N'TGT_AzureSQLConnection', N'EU_stg', N'PLPartBrk', N'raw', NULL, N'Company, ListCode, PartNum, Quantity, DiscountPercent, UnitPrice, UOMCode, GlobalPLPartBrk, GlobalLock, SysRevID, SysRowID', NULL, N'Company,ListCode,PartNum,UOMCode,Quantity', NULL, CAST(N'2023-12-13T05:31:55.4300000' AS DateTime2), N'Succeeded', 1, N'RDBMS', CAST(N'2023-12-13T05:30:55.2133333' AS DateTime2), CAST(N'1900-01-01T00:00:00.000' AS DateTime), N'', NULL, NULL)
GO
INSERT [common].[EU_RDBMSControlTable] ([ControlID], [BusinessArea], [SrcConnectionFriendlyName], [SrcTableSchema], [SrcTableName], [TgtConnectionFriendlyName], [TgtTableSchema], [TgtTableName], [TgtRootContainer], [TgtFileName], [ColumnList], [Query], [PrimaryKeyList], [IncRefreshColumn], [LastRefreshDate], [LastRefreshStatus], [IsActive], [Tag], [RefreshStartDate], [IncRefreshMaxDate], [latest_file_path], [AdditionalFilterConditions], [IsDelete]) VALUES (3, N'EpicorERP', N'STG_OnPremConnection', N'erp', N'CustCnt', N'TGT_AzureSQLConnection', N'EU_stg', N'CustCnt', N'raw', NULL, N'Company, CustNum, ShipToNum, ConNum, Name, Func, FaxNum, PhoneNum, SpecialAddress, Address1, Address2, Address3, City, State, Zip, Country, CorpName, EMailAddress, CountryNum, SFPortalPassword, SFUser, PortalUser, RoleCode, CellPhoneNum, PagerNum, HomeNum, AltNum, ContactTitle, ReportsTo, Comment, NoContact, CreateDate, CreateDcdUserID, ChangeDate, ChangeDcdUserID, Inactive, FirstName, MiddleName, LastName, Prefix, Suffix, Initials, ExternalID, GlobalLock, ShowInputPrice, ChangeTime, ChangedBy, MasterCustNum, MasterShipToNum, MasterConNum, PerConID, SyncNameToPerCon, SyncAddressToPerCon, SyncPhoneToPerCon, SyncEmailToPerCon, SyncLinksToPerCon, WebSite, IM, Twitter, LinkedIn, FaceBook, WebLink1, WebLink2, WebLink3, WebLink4, WebLink5, PerConAddress, SysRevID, SysRowID, SyncToExternalCRM, ExternalCRMCustomerID, ExternalCRMContactID', NULL, N'Company,CustNum,ShipToNum,ConNum', N'ChangeDate', CAST(N'2023-12-13T05:31:50.9000000' AS DateTime2), N'Succeeded', 1, N'RDBMS', CAST(N'2023-12-13T05:30:55.2133333' AS DateTime2), CAST(N'2023-12-12T00:00:00.000' AS DateTime), N'', NULL, 1)
GO
INSERT [common].[EU_RDBMSControlTable] ([ControlID], [BusinessArea], [SrcConnectionFriendlyName], [SrcTableSchema], [SrcTableName], [TgtConnectionFriendlyName], [TgtTableSchema], [TgtTableName], [TgtRootContainer], [TgtFileName], [ColumnList], [Query], [PrimaryKeyList], [IncRefreshColumn], [LastRefreshDate], [LastRefreshStatus], [IsActive], [Tag], [RefreshStartDate], [IncRefreshMaxDate], [latest_file_path], [AdditionalFilterConditions], [IsDelete]) VALUES (6, N'EpicorERP', N'STG_OnPremConnection', N'erp', N'Customer_UD', N'TGT_AzureSQLConnection', N'EU_stg', N'Customer_UD', N'raw', NULL, N'*', NULL, NULL, NULL, CAST(N'2023-12-13T05:32:47.5900000' AS DateTime2), N'Succeeded', 1, N'RDBMS', CAST(N'2023-12-13T05:30:55.2133333' AS DateTime2), CAST(N'1900-01-01T00:00:00.000' AS DateTime), N'', NULL, NULL)
GO
INSERT [common].[EU_RDBMSControlTable] ([ControlID], [BusinessArea], [SrcConnectionFriendlyName], [SrcTableSchema], [SrcTableName], [TgtConnectionFriendlyName], [TgtTableSchema], [TgtTableName], [TgtRootContainer], [TgtFileName], [ColumnList], [Query], [PrimaryKeyList], [IncRefreshColumn], [LastRefreshDate], [LastRefreshStatus], [IsActive], [Tag], [RefreshStartDate], [IncRefreshMaxDate], [latest_file_path], [AdditionalFilterConditions], [IsDelete]) VALUES (8, N'EpicorERP', N'STG_OnPremConnection', N'erp', N'CustXPrt', N'TGT_AzureSQLConnection', N'EU_stg', N'CustXPrt', N'raw', NULL, N'Company, PartNum, CustNum, XPartNum, XRevisionNum, PartDescription, SourceDBRecid, BasePartNum, BaseRevisionNum, ChangedBy, ChangeDate, ChangeTime, SNMask, SNMaskExample, SNMaskSuffix, SNMaskPrefix, SNLastUsedSeq, SNOverride, GlobalCustXPrt, GlobalLock, WIApplication, SysRevID, SysRowID, EDIContainerType, ProductionPartNum, ProductionPartNumIsValid, ServicePartNum, ServicePartNumIsValid', NULL, N'Company,PartNum,CustNum,XPartNum,SysRowID', N'ChangeDate', CAST(N'2023-12-13T05:32:49.9900000' AS DateTime2), N'Succeeded', 1, N'RDBMS', CAST(N'2023-12-13T05:30:55.2133333' AS DateTime2), CAST(N'2023-12-12T00:00:00.000' AS DateTime), N'', NULL, 1)
GO
INSERT [common].[EU_RDBMSControlTable] ([ControlID], [BusinessArea], [SrcConnectionFriendlyName], [SrcTableSchema], [SrcTableName], [TgtConnectionFriendlyName], [TgtTableSchema], [TgtTableName], [TgtRootContainer], [TgtFileName], [ColumnList], [Query], [PrimaryKeyList], [IncRefreshColumn], [LastRefreshDate], [LastRefreshStatus], [IsActive], [Tag], [RefreshStartDate], [IncRefreshMaxDate], [latest_file_path], [AdditionalFilterConditions], [IsDelete]) VALUES (12, N'EpicorERP', N'STG_OnPremConnection', N'erp', N'OrderDtl', N'TGT_AzureSQLConnection', N'EU_stg', N'OrderDtl', N'raw', NULL, N'VoidLine, OpenLine, Company, OrderNum, OrderLine, LineType, PartNum, LineDesc, Reference, IUM, RevisionNum, POLine, Commissionable, DiscountPercent, UnitPrice, DocUnitPrice, OrderQty, Discount, DocDiscount, RequestDate, ProdCode, XPartNum, XRevisionNum, PricePerCode, OrderComment, ShipComment, InvoiceComment, PickListComment, TaxCatID, AdvanceBillBal, DocAdvanceBillBal, QuoteNum, QuoteLine, TMBilling, OrigWhyNoTax, NeedByDate, CustNum, Rework, RMANum, RMALine, ProjectID, ContractNum, ContractCode, BasePartNum, Warranty, WarrantyCode, MaterialDuration, LaborDuration, MiscDuration, MaterialMod, LaborMod, WarrantyComment, Onsite, MatCovered, LabCovered, MiscCovered, SalesUM, SellingFactor, SellingQuantity, SalesCatID, ShipLineComplete, CumeQty, CumeDate, MktgCampaignID, MktgEvntSeq, LockQty, Linked, ICPONum, ICPOLine, ExtCompany, LastConfigDate, LastConfigTime, LastConfigUserID, ConfigUnitPrice, ConfigBaseUnitPrice, PriceListCode, BreakListCode, PricingQty, LockPrice, ListPrice, DocListPrice, OrdBasedPrice, DocOrdBasedPrice, PriceGroupCode, OverridePriceList, BaseRevisionNum, PricingValue, DisplaySeq, KitParentLine, KitAllowUpdate, KitShipComplete, KitBackFlush, KitPrintCompsPS, KitPrintCompsInv, KitPricing, KitQtyPer, SellingFactorDirection, RepRate1, RepRate2, RepRate3, RepRate4, RepRate5, RepSplit1, RepSplit2, RepSplit3, RepSplit4, RepSplit5, DemandContractLine, CreateNewJob, DoNotShipBeforeDate, GetDtls, DoNotShipAfterDate, SchedJob, RelJob, EnableCreateNewJob, EnableGetDtls, EnableSchedJob, EnableRelJob, CounterSaleWarehouse, CounterSaleBinNum, CounterSaleLotNum, CounterSaleDimCode, DemandDtlRejected, KitFlag, KitsLoaded, DemandContractNum, DemandHeadSeq, DemandDtlSeq, ChangedBy, ChangeDate, ChangeTime, ReverseCharge, TotalReleases, Rpt1UnitPrice, Rpt2UnitPrice, Rpt3UnitPrice, Rpt1Discount, Rpt2Discount, Rpt3Discount, Rpt1AdvanceBillBal, Rpt2AdvanceBillBal, Rpt3AdvanceBillBal, Rpt1ListPrice, Rpt2ListPrice, Rpt3ListPrice, Rpt1OrdBasedPrice, Rpt2OrdBasedPrice, Rpt3OrdBasedPrice, ExtPriceDtl, DocExtPriceDtl, Rpt1ExtPriceDtl, Rpt2ExtPriceDtl, Rpt3ExtPriceDtl, LineStatus, InUnitPrice, DocInUnitPrice, InDiscount, DocInDiscount, InListPrice, DocInListPrice, InOrdBasedPrice, DocInOrdBasedPrice, Rpt1InUnitPrice, Rpt2InUnitPrice, Rpt3InUnitPrice, Rpt1InDiscount, Rpt2InDiscount, Rpt3InDiscount, Rpt1InListPrice, Rpt2InListPrice, Rpt3InListPrice, Rpt1InOrdBasedPrice, Rpt2InOrdBasedPrice, Rpt3InOrdBasedPrice, InExtPriceDtl, DocInExtPriceDtl, Rpt1InExtPriceDtl, Rpt2InExtPriceDtl, Rpt3InExtPriceDtl, OldOurOpenQty, OldSellingOpenQty, OldOpenValue, OldProdCode, PrevSellQty, PrevPartNum, PrevXPartNum, KitCompOrigSeq, KitCompOrigPart, SmartStringProcessed, SmartString, RenewalNbr, DiscBreakListCode, DiscListPrice, LockDisc, OverrideDiscPriceList, GroupSeq, ECCOrderNum, ECCOrderLine, DupOnJobCrt, UndersPct, Overs, Unders, OversUnitPrice, PlanUserID, PlanGUID, MOMsourceType, MOMsourceEst, DefaultOversPricing, ECCPlant, ECCQuoteNum, ECCQuoteLine, SysRevID, SysRowID, MfgJobType, ProFormaInvComment, CreateJob, ContractID, LinkToContract, DocInAdvanceBillBal, InAdvanceBillBal, Rpt1InAdvanceBillBal, Rpt2InAdvanceBillBal, Rpt3InAdvanceBillBal, PCLinkRemoved, CommodityCode, MSRP, DocMSRP, Rpt1MSRP, Rpt2MSRP, Rpt3MSRP, EndCustomerPrice, DocEndCustomerPrice, Rpt1EndCustomerPrice, Rpt2EndCustomerPrice, Rpt3EndCustomerPrice, PromotionalPrice, DocPromotionalPrice, Rpt1PromotionalPrice, Rpt2PromotionalPrice, Rpt3PromotionalPrice, OrderLineStatusCode, AttributeSetID, KBConfigProdID, KBOriginalConfigProdID', NULL, N'Company,OrderLine,OrderNum', N'ChangeDate', CAST(N'2023-12-13T05:32:58.0466667' AS DateTime2), N'Succeeded', 1, N'RDBMS', CAST(N'2023-12-13T05:30:55.2133333' AS DateTime2), CAST(N'2023-12-12T00:00:00.000' AS DateTime), N'', NULL, 1)
GO
INSERT [common].[EU_RDBMSControlTable] ([ControlID], [BusinessArea], [SrcConnectionFriendlyName], [SrcTableSchema], [SrcTableName], [TgtConnectionFriendlyName], [TgtTableSchema], [TgtTableName], [TgtRootContainer], [TgtFileName], [ColumnList], [Query], [PrimaryKeyList], [IncRefreshColumn], [LastRefreshDate], [LastRefreshStatus], [IsActive], [Tag], [RefreshStartDate], [IncRefreshMaxDate], [latest_file_path], [AdditionalFilterConditions], [IsDelete]) VALUES (13, N'EpicorERP', N'STG_OnPremConnection', N'erp', N'OrderDtl_UD', N'TGT_AzureSQLConnection', N'EU_stg', N'OrderDtl_UD', N'raw', NULL, N'*', NULL, NULL, NULL, CAST(N'2023-12-13T05:33:58.4933333' AS DateTime2), N'Succeeded', 1, N'RDBMS', CAST(N'2023-12-13T05:30:55.2133333' AS DateTime2), CAST(N'1900-01-01T00:00:00.000' AS DateTime), N'', NULL, NULL)
GO
INSERT [common].[EU_RDBMSControlTable] ([ControlID], [BusinessArea], [SrcConnectionFriendlyName], [SrcTableSchema], [SrcTableName], [TgtConnectionFriendlyName], [TgtTableSchema], [TgtTableName], [TgtRootContainer], [TgtFileName], [ColumnList], [Query], [PrimaryKeyList], [IncRefreshColumn], [LastRefreshDate], [LastRefreshStatus], [IsActive], [Tag], [RefreshStartDate], [IncRefreshMaxDate], [latest_file_path], [AdditionalFilterConditions], [IsDelete]) VALUES (33, N'EpicorERP', N'STG_OnPremConnection', N'dbo', N'FLEX_SalesAnalysisInvoiceSTGTotals', N'TGT_AzureSQLConnection', N'EU_STG', N'FLEX_SalesAnalysisInvoiceSTGTotals', N'raw', NULL, N'*', NULL, NULL, NULL, CAST(N'2023-11-27T06:51:28.1500000' AS DateTime2), N'Succeeded', 0, N'RDBMS', CAST(N'2023-11-27T06:50:31.0433333' AS DateTime2), CAST(N'1900-01-01T00:00:00.000' AS DateTime), N'', NULL, NULL)
GO
INSERT [common].[EU_RDBMSControlTable] ([ControlID], [BusinessArea], [SrcConnectionFriendlyName], [SrcTableSchema], [SrcTableName], [TgtConnectionFriendlyName], [TgtTableSchema], [TgtTableName], [TgtRootContainer], [TgtFileName], [ColumnList], [Query], [PrimaryKeyList], [IncRefreshColumn], [LastRefreshDate], [LastRefreshStatus], [IsActive], [Tag], [RefreshStartDate], [IncRefreshMaxDate], [latest_file_path], [AdditionalFilterConditions], [IsDelete]) VALUES (15, N'EpicorERP', N'STG_OnPremConnection', N'erp', N'OrderHed_UD', N'TGT_AzureSQLConnection', N'EU_stg', N'OrderHed_UD', N'raw', NULL, N'*', NULL, NULL, NULL, CAST(N'2023-12-13T05:33:23.1966667' AS DateTime2), N'Succeeded', 1, N'RDBMS', CAST(N'2023-12-13T05:30:55.2133333' AS DateTime2), CAST(N'1900-01-01T00:00:00.000' AS DateTime), N'', NULL, NULL)
GO
INSERT [common].[EU_RDBMSControlTable] ([ControlID], [BusinessArea], [SrcConnectionFriendlyName], [SrcTableSchema], [SrcTableName], [TgtConnectionFriendlyName], [TgtTableSchema], [TgtTableName], [TgtRootContainer], [TgtFileName], [ColumnList], [Query], [PrimaryKeyList], [IncRefreshColumn], [LastRefreshDate], [LastRefreshStatus], [IsActive], [Tag], [RefreshStartDate], [IncRefreshMaxDate], [latest_file_path], [AdditionalFilterConditions], [IsDelete]) VALUES (9, N'EpicorERP', N'STG_OnPremConnection', N'erp', N'InvcDtl', N'TGT_AzureSQLConnection', N'EU_stg', N'InvcDtl', N'raw', NULL, N'Company, InvoiceNum, InvoiceLine, LineType, ContractNum, XPartNum, XRevisionNum, PartNum, LineDesc, IUM, RevisionNum, POLine, TaxExempt, TaxCatID, Commissionable, DiscountPercent, UnitPrice, DocUnitPrice, PricePerCode, OurOrderQty, ExtPrice, DocExtPrice, Discount, DocDiscount, TotalMiscChrg, DocTotalMiscChrg, ProdCode, OurShipQty, PackNum, PackLine, OrderNum, OrderLine, OrderRelNum, ShipToCustNum, ShipToNum, ShipDate, ShipViaCode, AdvanceBillCredit, DocAdvanceBillCredit, CustNum, InvoiceComment, ShpConNum, MtlUnitCost, LbrUnitCost, BurUnitCost, SubUnitCost, MtlBurUnitCost, COSPostingReqd, COSPosted, ContractCode, CallNum, CallCode, RMANum, RMALine, SalesCatID, FiscalYear, FiscalPeriod, JournalCode, JournalNum, SellingOrderQty, SellingShipQty, SalesUM, SellingFactor, ProjectID, MilestoneID, ListPrice, DocListPrice, OrdBasedPrice, DocOrdBasedPrice, AdvGainLoss, SellingFactorDirection, RepRate1, RepRate2, RepRate3, RepRate4, RepRate5, RepSplit1, RepSplit2, RepSplit3, RepSplit4, RepSplit5, BTCustNum, JCMtlUnitCost, JCLbrUnitCost, JCBurUnitCost, JCSubUnitCost, JCMtlBurUnitCost, ChangedBy, ChangeDate, ChangeTime, RevChargeMethod, OverrideReverseCharge, RevChargeApplied, TaxConnectCalc, GetDfltTaxIds, Rpt1AdvanceBillCredit, Rpt2AdvanceBillCredit, Rpt3AdvanceBillCredit, Rpt1Discount, Rpt2Discount, Rpt3Discount, Rpt1ExtPrice, Rpt2ExtPrice, Rpt3ExtPrice, Rpt1ListPrice, Rpt2ListPrice, Rpt3ListPrice, Rpt1OrdBasedPrice, Rpt2OrdBasedPrice, Rpt3OrdBasedPrice, Rpt1TotalMiscChrg, Rpt2TotalMiscChrg, Rpt3TotalMiscChrg, Rpt1UnitPrice, Rpt2UnitPrice, Rpt3UnitPrice, Rpt1AdvGainLoss, Rpt2AdvGainLoss, Rpt3AdvGainLoss, FiscalYearSuffix, FiscalCalendarID, TaxRegionCode, UseOTS, OTSName, OTSAddress1, OTSAddress2, OTSAddress3, OTSCity, OTSState, OTSZIP, OTSResaleID, OTSTaxRegionCode, OTSContact, OTSFaxNum, OTSPhoneNum, OTSCountryNum, Plant, WarehouseCode, CallLine, DropShipPackLine, DropShipPackSlip, FinChargeCode, ABTUID, InUnitPrice, DocInUnitPrice, InExtPrice, DocInExtPrice, InDiscount, DocInDiscount, InTotalMiscChrg, DocInTotalMiscChrg, InListPrice, DocInListPrice, InOrdBasedPrice, DocInOrdBasedPrice, Rpt1InDiscount, Rpt2InDiscount, Rpt3InDiscount, Rpt1InExtPrice, Rpt2InExtPrice, Rpt3InExtPrice, Rpt1InListPrice, Rpt2InListPrice, Rpt3InListPrice, Rpt1InOrdBasedPrice, Rpt2InOrdBasedPrice, Rpt3InOrdBasedPrice, Rpt1InTotalMiscChrg, Rpt2InTotalMiscChrg, Rpt3InTotalMiscChrg, Rpt1InUnitPrice, Rpt2InUnitPrice, Rpt3InUnitPrice, CorrectionDtl, AssetNum, DisposalNum, PBLineType, InvoiceLineRef, InvoiceRef, LotNum, PBInvoiceLine, RAID, RADtlID, DeferredRev, RACode, DefRevStart, ChargeDefRev, RenewalNbr, SysRevID, SysRowID, DefRevPosted, LinkedInvcUnitPrice, DspWithholdAmt, DocDspWithholdAmt, Rpt1DspWithholdAmt, Rpt2DspWithholdAmt, Rpt3DspWithholdAmt, LinkedCurrencyCode, PhaseID, PEBOEHeadNum, MXSellingShipQty, MXUnitPrice, DocMXUnitPrice, Rpt1MXUnitPrice, Rpt2MXUnitPrice, Rpt3MXUnitPrice, CustCostCenter, DEIsServices, DEIsSecurityFinancialDerivative, DEInternationalSecuritiesID, DEIsInvestment, DEPayStatCode, DefRevEndDate, EntityUseCode, Reclassified, PartiallyDefer, DeferredPercent, Reclass, DeferredOnly, ReclassCodeID, ReclassReasonCode, ReclassComments, DeferredRevAmt, DocDeferredRevAmt, Rpt1DeferredRevAmt, Rpt2DeferredRevAmt, Rpt3DeferredRevAmt, ChargeReclass, DEDenomination, DropShipPONum, DocInAdvanceBillCredit, InAdvanceBillCredit, Rpt1InAdvanceBillCredit, Rpt2InAdvanceBillCredit, Rpt3InAdvanceBillCredit, MYIndustryCode, DockingStation, ConsolidateLines, MXCustomsDuty, CommodityCode, MXProdServCode, QuoteNum, QuoteLine, EpicorFSA, MXCustomsUMFrom, PEDetrGoodServiceCode, PETaxExempt, CColOrderNum, CColOrderLine, CColOrderRel, CColInvoiceLineRef, CColPackNum, CColPackLine, CColDropShipPackSlip, CColDropShipPackSlipLine, CColShipToCustID, CColShipToNum, AttributeSetID, AttributeSetDescription, AttributeSetShortDescription, ExemptReasonCode, JobNum, ServiceSource, OTSTaxValidationStatus, OTSTaxValidationDate, AssemblySeq, MtlSeq, OprSeq, LaborType, BillableLaborHrs, BillableLaborRate, ServiceSourceType', NULL, N'Company,InvoiceLine,InvoiceNum', N'ChangeDate', CAST(N'2023-12-13T05:33:03.6400000' AS DateTime2), N'Succeeded', 1, N'RDBMS', CAST(N'2023-12-13T05:30:55.2133333' AS DateTime2), CAST(N'2023-12-12T00:00:00.000' AS DateTime), N'', NULL, 1)
GO
INSERT [common].[EU_RDBMSControlTable] ([ControlID], [BusinessArea], [SrcConnectionFriendlyName], [SrcTableSchema], [SrcTableName], [TgtConnectionFriendlyName], [TgtTableSchema], [TgtTableName], [TgtRootContainer], [TgtFileName], [ColumnList], [Query], [PrimaryKeyList], [IncRefreshColumn], [LastRefreshDate], [LastRefreshStatus], [IsActive], [Tag], [RefreshStartDate], [IncRefreshMaxDate], [latest_file_path], [AdditionalFilterConditions], [IsDelete]) VALUES (17, N'EpicorERP', N'STG_OnPremConnection', N'erp', N'Part_UD', N'TGT_AzureSQLConnection', N'EU_stg', N'Part_UD', N'raw', NULL, N'*', NULL, NULL, NULL, CAST(N'2023-12-13T05:33:13.3366667' AS DateTime2), N'Succeeded', 1, N'RDBMS', CAST(N'2023-12-13T05:30:55.2133333' AS DateTime2), CAST(N'1900-01-01T00:00:00.000' AS DateTime), N'', NULL, NULL)
GO
INSERT [common].[EU_RDBMSControlTable] ([ControlID], [BusinessArea], [SrcConnectionFriendlyName], [SrcTableSchema], [SrcTableName], [TgtConnectionFriendlyName], [TgtTableSchema], [TgtTableName], [TgtRootContainer], [TgtFileName], [ColumnList], [Query], [PrimaryKeyList], [IncRefreshColumn], [LastRefreshDate], [LastRefreshStatus], [IsActive], [Tag], [RefreshStartDate], [IncRefreshMaxDate], [latest_file_path], [AdditionalFilterConditions], [IsDelete]) VALUES (18, N'EpicorERP', N'STG_OnPremConnection', N'erp', N'PartBin', N'TGT_AzureSQLConnection', N'EU_stg', N'PartBin', N'raw', NULL, N'Company, PartNum, WarehouseCode, BinNum, OnhandQty, LotNum, DimCode, AllocatedQty, SalesAllocatedQty, SalesPickingQty, SalesPickedQty, JobAllocatedQty, JobPickingQty, JobPickedQty, TFOrdAllocatedQty, TFOrdPickingQty, TFOrdPickedQty, ShippingQty, PackedQty, SysRevID, SysRowID, PCID, SendToFSA, AttributeSetID, CountedDate, QtyPerPiece, RevisionNum', NULL, N'AttributeSetID,BinNum,Company,DimCode,LotNum,PartNum,PCID,WarehouseCode', NULL, CAST(N'2023-12-13T05:33:05.6900000' AS DateTime2), N'Succeeded', 1, N'RDBMS', CAST(N'2023-12-13T05:30:55.2133333' AS DateTime2), CAST(N'1900-01-01T00:00:00.000' AS DateTime), N'', NULL, 1)
GO
INSERT [common].[EU_RDBMSControlTable] ([ControlID], [BusinessArea], [SrcConnectionFriendlyName], [SrcTableSchema], [SrcTableName], [TgtConnectionFriendlyName], [TgtTableSchema], [TgtTableName], [TgtRootContainer], [TgtFileName], [ColumnList], [Query], [PrimaryKeyList], [IncRefreshColumn], [LastRefreshDate], [LastRefreshStatus], [IsActive], [Tag], [RefreshStartDate], [IncRefreshMaxDate], [latest_file_path], [AdditionalFilterConditions], [IsDelete]) VALUES (19, N'EpicorERP', N'STG_OnPremConnection', N'erp', N'PartCost', N'TGT_AzureSQLConnection', N'EU_stg', N'PartCost', N'raw', NULL, N'Company, PartNum, CostID, AvgLaborCost, AvgBurdenCost, AvgMaterialCost, AvgSubContCost, AvgMtlBurCost, StdLaborCost, StdBurdenCost, StdMaterialCost, StdSubContCost, StdMtlBurCost, LastLaborCost, LastBurdenCost, LastMaterialCost, LastSubContCost, LastMtlBurCost, FIFOAvgLaborCost, FIFOAvgBurdenCost, FIFOAvgMaterialCost, FIFOAvgSubContCost, FIFOAvgMtlBurCost, SysRevID, SysRowID, TotalQtyAvg, ExternalMESSyncRequired, ExternalMESLastSync', NULL, N'Company,CostID,PartNum', NULL, CAST(N'2023-12-13T05:34:12.7333333' AS DateTime2), N'Succeeded', 1, N'RDBMS', CAST(N'2023-12-13T05:30:55.2133333' AS DateTime2), CAST(N'1900-01-01T00:00:00.000' AS DateTime), N'', NULL, NULL)
GO
INSERT [common].[EU_RDBMSControlTable] ([ControlID], [BusinessArea], [SrcConnectionFriendlyName], [SrcTableSchema], [SrcTableName], [TgtConnectionFriendlyName], [TgtTableSchema], [TgtTableName], [TgtRootContainer], [TgtFileName], [ColumnList], [Query], [PrimaryKeyList], [IncRefreshColumn], [LastRefreshDate], [LastRefreshStatus], [IsActive], [Tag], [RefreshStartDate], [IncRefreshMaxDate], [latest_file_path], [AdditionalFilterConditions], [IsDelete]) VALUES (21, N'EpicorERP', N'STG_OnPremConnection', N'erp', N'PartWhse', N'TGT_AzureSQLConnection', N'EU_stg', N'PartWhse', N'raw', NULL, N'Company, PartNum, WarehouseCode, DemandQty, ReservedQty, AllocatedQty, PickingQty, PickedQty, CountedDate, OnHandQty, NonNettableQty, BuyToOrderQty, SalesDemandQty, SalesReservedQty, SalesAllocatedQty, SalesPickingQty, SalesPickedQty, JobDemandQty, JobReservedQty, JobAllocatedQty, JobPickingQty, JobPickedQty, UnfirmJobDemandQty, TFOrdDemandQty, TFOrdReservedQty, TFOrdAllocatedQty, TFOrdPickingQty, TFOrdPickedQty, KBCode, MinimumQty, MaximumQty, SafetyQty, KBPONUM, KBPOLine, KBWarehouseCode, KBBinNum, KBPlant, KBQty, PcntTolerance, CalcPcnt, CalcQty, CalcValue, QtyAdjTolerance, CalcQtyAdj, MinAbc, SystemAbc, ManualABC, LastCCDate, OvrrideCountFreq, CountFreq, QtyTolerance, ValueTolerance, SysRevID, SysRowID', NULL, N'Company,PartNum,WarehouseCode', N'LastCCDate', CAST(N'2023-12-13T05:33:50.1400000' AS DateTime2), N'Succeeded', 1, N'RDBMS', CAST(N'2023-12-13T05:30:55.2133333' AS DateTime2), CAST(N'2023-12-12T00:00:00.000' AS DateTime), N'', NULL, 1)
GO
INSERT [common].[EU_RDBMSControlTable] ([ControlID], [BusinessArea], [SrcConnectionFriendlyName], [SrcTableSchema], [SrcTableName], [TgtConnectionFriendlyName], [TgtTableSchema], [TgtTableName], [TgtRootContainer], [TgtFileName], [ColumnList], [Query], [PrimaryKeyList], [IncRefreshColumn], [LastRefreshDate], [LastRefreshStatus], [IsActive], [Tag], [RefreshStartDate], [IncRefreshMaxDate], [latest_file_path], [AdditionalFilterConditions], [IsDelete]) VALUES (11, N'EpicorERP', N'STG_OnPremConnection', N'erp', N'Invchead', N'TGT_AzureSQLConnection', N'EU_stg', N'Invchead', N'raw', NULL, N'Company, OpenInvoice, ClosedDate, CreditMemo, UnappliedCash, CheckRef, InvoiceSuffix, GroupID, Posted, InvoiceNum, InvoiceType, DeferredRevenue, OrderNum, CustNum, PONum, EntryPerson, FOB, TermsCode, InvoiceDate, DueDate, FiscalYear, FiscalPeriod, GLPosted, InvoiceComment, InvoiceAmt, DocInvoiceAmt, InvoiceBal, DocInvoiceBal, UnpostedBal, DocUnpostedBal, DepositCredit, DocDepositCredit, SalesRepList, InvoiceRef, RefCancelled, RefCancelledBy, StartUp, PayDates, PayAmounts, DocPayAmounts, PayDiscDate, PayDiscAmt, DocPayDiscAmt, BillConNum, InvoiceHeld, CurrencyCode, ExchangeRate, LockRate, JournalNum, JournalCode, LineType, RMANum, Plant, CardMemberName, CardNumber, CardType, ExpirationMonth, ExpirationYear, CardID, CardmemberReference, LegalNumber, ExternalID, XRefInvoiceNum, DepGainLoss, DNComments, DNCustNbr, DebitNote, SoldToCustNum, Consolidated, BillToInvoiceAddress, SoldToInvoiceAddress, ProcessCard, RepComm1, RepComm2, RepComm3, RepComm4, RepComm5, RepRate1, RepRate2, RepRate3, RepRate4, RepRate5, RepSales1, RepSales2, RepSales3, RepSales4, RepSales5, RepSplit1, RepSplit2, RepSplit3, RepSplit4, RepSplit5, CMType, CCStreetAddr, CCZip, ChangedBy, ChangeDate, ChangeTime, ReadyToCalc, AutoPrintReady, EDIReady, RecalcBeforePost, Rounding, DocRounding, Rpt1DepositCredit, Rpt2DepositCredit, Rpt3DepositCredit, Rpt1InvoiceAmt, Rpt2InvoiceAmt, Rpt3InvoiceAmt, Rpt1InvoiceBal, Rpt2InvoiceBal, Rpt3InvoiceBal, Rpt1PayAmounts, Rpt2PayAmounts, Rpt3PayAmounts, Rpt1PayDiscAmt, Rpt2PayDiscAmt, Rpt3PayDiscAmt, Rpt1Rounding, Rpt2Rounding, Rpt3Rounding, Rpt1UnpostedBal, Rpt2UnpostedBal, Rpt3UnpostedBal, RateGrpCode, DocDepApplied, Rpt1DepGainLoss, Rpt2DepGainLoss, Rpt3DepGainLoss, ApplyDate, FiscalYearSuffix, FiscalCalendarID, TaxPoint, TaxRateDate, TaxRegionCode, LastChrgCalcDate, TranDocTypeID, TotFinChrg, DocumentPrinted, PayDiscDays, PayDiscPer, BlockedFinChrg, BlockedFinChrgReason, WithholdAmt, DocWithholdAmt, Rpt1WithholdAmt, Rpt2WithholdAmt, Rpt3WithholdAmt, BlockedRemLetters, PayDiscPartPay, BlockedRemLettersReason, ShipDate, CurrRateDate, PIPayment, PMUID, UseAltBillTo, InPrice, CorrectionInv, TaxRateGrpCode, LockTaxRate, SEBankRef, GUITaxTypeCode, GUIFormatCode, GUIDeductCode, ReversalDocAmount, OrigDueDate, HeadNum, ARLOCID, ContractRef, OurBank, ContractDate, PBProjectID, DepositAmt, GUIExportBillNumber, DocDepositAmt, GUIDateOfExport, Rpt1DepositAmt, GUIExportType, Rpt2DepositAmt, GUIExportMark, Rpt3DepositAmt, GUIExportBillType, DepUnallocatedAmt, SummarizationDate, DocDepUnallocatedAmt, BillingDate, Rpt1DepUnallocatedAmt, BillingNumber, Rpt2DepUnallocatedAmt, ReadyToBill, Rpt3DepUnallocatedAmt, OvrDefTaxDate, XRefContractNum, XRefContractDate, MainSite, SiteCode, BranchID, CustAgentName, CustAgentTaxRegNo, ExportType, ExportReportNo, RealEstateNo, Excluded, Deferred, CycleCode, Duration, EndDate, MaxValueAmt, DocMaxValueAmt, Rpt1MaxValueAmt, Rpt2MaxValueAmt, Rpt3MaxValueAmt, HoldInvoice, CopyLatestInvoice, OverrideEndDate, CycleInactive, RecurSource, InstanceNum, RecurBalance, DocRecurBalance, Rpt1RecurBalance, Rpt2RecurBalance, Rpt3RecurBalance, LastDate, RecurringState, IsRecurring, InvoiceNumList, IsAddedToGTI, SysRevID, SysRowID, CHISRCodeLine, CMReason, THIsImmatAdjustment, AGAuthorizationCode, AGAuthorizationDate, AGUseGoodDefaultMark, AGDocumentLetter, AGInvoicingPoint, AGLegalNumber, AGPrintingControlType, RevisionDate, RevisionNum, TWDeclareYear, TWDeclarePeriod, TWGenerationType, TWGUIGroup, TWPeriodPrefix, InvInCollections, CollectionsCust, CounterARForm, PostedRecog, CNConfirmDate, MXSATSeal, MXSerie, MXTaxRcptType, MXFiscalFolio, MXTotalPayments, MXFolio, MXCertifiedTimestamp, MXSATCertificateSN, MXDigitalSeal, MXPostedTimeStamp, MXCertificate, MXApprovalYear, MXCBB, MXApprovalNum, MXOriginalStringTFD, MXPaymentNum, MXPaidAs, MXCertificateSN, MXOriginalAmount, MXAccountNumber, MXOriginalDate, MXOriginalSeries, MXOriginalFolio, MXTaxRegime, MXOriginalString, MXPaymentName, EInvoice, EInvStatus, EInvTimestamp, EInvUpdatedBy, EInvException, WithTaxConfirm, UseAltBillToID, MXCancelledDate, Overpaid, OrdExchangeRate, PEAPPayNum, PEBankNumber, PECharges, PECommissions, PEDetTaxAmt, PEDetTaxCurrencyCode, PEDischargeAmt, PEDischargeDate, PEInterest, PENoPayPenalty, PESUNATDepAmt, PESUNATDepDate, PESUNATDepNum, PEBOEPosted, DocPEInterest, DocPECommissions, DocPECharges, DocPENoPayPenalty, DocPEDischargeAmt, DocPEDetTaxAmt, Rpt1PEInterest, Rpt1PECommissions, Rpt1PECharges, Rpt1PENoPayPenalty, Rpt1PEDischargeAmt, Rpt2PEInterest, Rpt2PECommissions, Rpt2PECharges, Rpt2PENoPayPenalty, Rpt2PEDischargeAmt, Rpt3PEInterest, Rpt3PECommissions, Rpt3PECharges, Rpt3PENoPayPenalty, Rpt3PEDischargeAmt, OurSupplierCode, PEGuaranteeName, PEGuaranteeAddress1, PEGuaranteeAddress2, PEGuaranteeAddress3, PEGuaranteeCity, PEGuaranteeState, PEGuaranteeZip, PEGuaranteeCountry, PEGuaranteeTaxID, PEGuaranteePhoneNum, PEBOEStatus, PEBOEIsMultiGen, PERefDocID, PEReasonCode, PEReasonDesc, TWGUIRegNumSeller, TWGUIRegNumBuyer, TWGUIExportDocumentName, TWGUIExportRemarks, TWGUIExportVerification, PEDebitNoteReasonCode, PEDebitNote, MXPartPmt, CNTaxInvoiceType, MXExportOperationType, MXExportCustDocCode, MXExportCertOriginNum, MXExportConfNum, MXExportCertOrigin, MXIncoterm, AGDocConcept, EInvRefNum, ExportDocRefNum, ExportDocDate, INTaxTransactionID, MXMovingReasonFlag, MXMovingReason, MXNumRegIdTrib, MXResidenCountryNum, MXPurchaseType, MXConfirmationCode, MXExternalCode, ServiceInvoice, MXDomesticTransfer, MXCancellationMode, INShippingPortCode, INExportProcedure, CreatedOn, DigitalSignature, SignedOn, SignedBy, FirstPrintDate, DocCopyNum, DepositBalance, DocDepositBalance, Rpt1DepositBalance, Rpt2DepositBalance, Rpt3DepositBalance, QuoteNum, HDCaseNum, CreditOverride, CreditOverrideDate, CreditOverrideUserID, CreditHold, PEXMLType, COCreditMemoReasonCode, CODebitMemoReasonCode, COReasonDesc, CODebitNote, PEDetractionTranNum, PEProductCode, PECollectionGroupID, PECaptionCode, PECaption, PERefDocumentType, PERefDocumentNumber, PEDetrGoodServiceCode, PERefDocumentType2, PERefDocumentType3, PERefDocumentType4, PERefDocumentType5, PERefDocumentNumber2, PERefDocumentNumber3, PERefDocumentNumber4, PERefDocumentNumber5, ELIEInvoice, ELIEInvStatus, ELIEInvUpdatedBy, ELIEInvException, ELIEInvUpdatedOn, COOperType, CentralCollection, CColChildCompany, CColParentCompany, CColOrderNum, CColChildInvoiceNum, CColInvoiceNum, CColChildLegalNumber, CColLegalNumber, CColInvoiceRef, CColInvBal, DocCColInvBal, CColInvAmt, DocCColInvAmt, Rpt1CColInvBal, Rpt2CColInvBal, Rpt3CColInvBal, Rpt1CColInvAmt, Rpt2CColInvAmt, Rpt3CColInvAmt, NettingID, ELIEInvTerminalName, ELIEInvTerminalIP, Description, WithholdAcctToInterim, CColOpenInvoice, AGQRCodeData, ExemptReasonCode, ELIEInvID, CallNum, CallLine, JobNum, MXCancelReasonCode, MXSubstInvoiceNum, MXExportType, MXGlobalInvoicePeriod, MXGlobalInvoiceMonth', NULL, N'Company,InvoiceNum', N'ChangeDate', CAST(N'2023-12-13T05:34:05.9800000' AS DateTime2), N'Succeeded', 1, N'RDBMS', CAST(N'2023-12-13T05:30:55.2133333' AS DateTime2), CAST(N'2023-12-12T00:00:00.000' AS DateTime), N'', NULL, 1)
GO
INSERT [common].[EU_RDBMSControlTable] ([ControlID], [BusinessArea], [SrcConnectionFriendlyName], [SrcTableSchema], [SrcTableName], [TgtConnectionFriendlyName], [TgtTableSchema], [TgtTableName], [TgtRootContainer], [TgtFileName], [ColumnList], [Query], [PrimaryKeyList], [IncRefreshColumn], [LastRefreshDate], [LastRefreshStatus], [IsActive], [Tag], [RefreshStartDate], [IncRefreshMaxDate], [latest_file_path], [AdditionalFilterConditions], [IsDelete]) VALUES (14, N'EpicorERP', N'STG_OnPremConnection', N'erp', N'OrderHed', N'TGT_AzureSQLConnection', N'EU_stg', N'OrderHed', N'raw', NULL, N'OpenOrder, VoidOrder, Company, OrderNum, CustNum, PONum, OrderHeld, EntryPerson, ShipToNum, RequestDate, OrderDate, FOB, ShipViaCode, TermsCode, DiscountPercent, PrcConNum, ShpConNum, SalesRepList, OrderComment, ShipComment, InvoiceComment, PickListComment, DepositBal, DocDepositBal, NeedByDate, CreditOverride, CreditOverrideUserID, CreditOverrideDate, CreditOverrideTime, CreditOverrideLimit, SndAlrtShp, ExchangeRate, CurrencyCode, LockRate, CardMemberName, CardNumber, CardType, ExpirationMonth, ExpirationYear, CardID, CardmemberReference, AllocPriorityCode, ReservePriorityCode, ShipOrderComplete, WebOrder, CCApprovalNum, EDIOrder, EDIAck, Linked, ICPONum, ExtCompany, WebEntryPerson, AckEmailSent, ApplyOrderBasedDisc, AutoOrderBasedDisc, EntryMethod, HDCaseNum, CounterSale, CreateInvoice, CreatePackingSlip, LockQty, ProcessCard, CCAmount, CCFreight, CCTax, CCTotal, CCDocAmount, CCDocFreight, CCDocTax, CCDocTotal, CCStreetAddr, CCZip, BTCustNum, BTConNum, RepRate4, RepRate5, RepSplit1, RepSplit2, RepSplit3, RepSplit4, RepSplit5, RepRate1, RepRate2, RepRate3, OutboundSalesDocCtr, OutboundShipDocsCtr, DemandContractNum, DoNotShipBeforeDate, ResDelivery, DoNotShipAfterDate, SatDelivery, SatPickup, Hazmat, DocOnly, RefNotes, ApplyChrg, ChrgAmount, COD, CODFreight, CODCheck, CODAmount, GroundType, NotifyFlag, NotifyEMail, DeclaredIns, DeclaredAmt, CancelAfterDate, DemandRejected, OverrideCarrier, OverrideService, CreditCardOrder, DemandHeadSeq, PayFlag, PayAccount, PayBTAddress1, PayBTAddress2, PayBTCity, PayBTState, PayBTZip, PayBTCountry, DropShip, CommercialInvoice, ShipExprtDeclartn, CertOfOrigin, LetterOfInstr, FFID, FFAddress1, FFAddress2, FFCity, FFState, FFZip, FFCountry, FFContact, FFCompName, FFPhoneNum, IntrntlShip, ChangedBy, ChangeDate, ChangeTime, AutoPrintReady, EDIReady, IndividualPackIDs, FFAddress3, DeliveryConf, AddlHdlgFlag, NonStdPkg, ServSignature, ServAlert, ServHomeDel, DeliveryType, ServDeliveryDate, ServInstruct, ServRef1, ServRef2, ServRef3, ServRef4, ServRef5, FFCountryNum, ServPhone, ServRelease, ServAuthNum, PayBTAddress3, PayBTCountryNum, PayBTPhone, UPSQuantumView, UPSQVShipFromName, UPSQVMemo, ReadyToCalc, TotalCharges, TotalMisc, TotalDiscount, TotalComm, TotalAdvBill, TotalLines, TotalReleases, TotalRelDates, DocTotalCharges, DocTotalMisc, DocTotalDiscount, DocTotalComm, TotalTax, DocTotalTax, DocTotalAdvBill, TotalShipped, TotalInvoiced, TotalCommLines, SRCommAmt1, SRCommAmt2, SRCommAmt3, SRCommAmt4, SRCommAmt5, SRCommableAmt1, SRCommableAmt2, SRCommableAmt3, SRCommableAmt4, SRCommableAmt5, Rounding, Rpt1DepositBal, DocRounding, Rpt2DepositBal, Rpt3DepositBal, Rpt1TotalCharges, Rpt2TotalCharges, Rpt3TotalCharges, Rpt1TotalAdvBill, Rpt2TotalAdvBill, Rpt3TotalAdvBill, Rpt1TotalMisc, Rpt2TotalMisc, Rpt3TotalMisc, Rpt1TotalDiscount, Rpt2TotalDiscount, Rpt3TotalDiscount, Rpt1TotalComm, Rpt2TotalComm, Rpt3TotalComm, Rpt1TotalTax, Rpt2TotalTax, Rpt1Rounding, Rpt2Rounding, Rpt3Rounding, RateGrpCode, Rpt3TotalTax, Rpt1CCAmount, Rpt2CCAmount, Rpt3CCAmount, Rpt1CCFreight, Rpt2CCFreight, Rpt3CCFreight, Rpt1CCTax, Rpt2CCTax, Rpt3CCTax, Rpt1CCTotal, Rpt2CCTotal, Rpt3CCTotal, OrderAmt, DocOrderAmt, Rpt1OrderAmt, Rpt2OrderAmt, Rpt3OrderAmt, TaxPoint, TaxRateDate, TaxRegionCode, UseOTS, OTSName, OTSAddress1, OTSAddress2, OTSAddress3, OTSCity, OTSState, OTSZIP, OTSResaleID, OTSContact, OTSFaxNum, OTSPhoneNum, OTSCountryNum, TotalWHTax, DocTotalWHTax, Rpt1TotalWHTax, Rpt2TotalWHTax, Rpt3TotalWHTax, TotalSATax, DocTotalSATax, Rpt1TotalSATax, Rpt2TotalSATax, Rpt3TotalSATax, OTSSaveAs, OTSSaveCustID, OTSCustSaved, ShipToCustNum, OrderStatus, HoldSetByDemand, InPrice, InTotalCharges, InTotalMisc, InTotalDiscount, DocInTotalCharges, DocInTotalMisc, DocInTotalDiscount, Rpt1InTotalCharges, Rpt2InTotalCharges, Rpt3InTotalCharges, Rpt1InTotalMisc, Rpt2InTotalMisc, Rpt3InTotalMisc, Rpt1InTotalDiscount, Rpt2InTotalDiscount, Rpt3InTotalDiscount, ARLOCID, OurBank, ERSOrder, LOCHold, PSCurrCode, InvCurrCode, LegalNumber, TranDocTypeID, XRefContractNum, XRefContractDate, DemandProcessDate, DemandProcessTime, LastScheduleNumber, LastTCtrlNum, LastBatchNum, ECCOrderNum, ECCPONum, WIOrder, WIApplication, WIUsername, WIUserID, WICreditCardorder, OrderCSR, UserChar1, UserChar2, UserChar3, UserChar4, UserDate1, UserDate2, UserDate3, UserDate4, UserDecimal1, UserDecimal2, UserInteger1, UserInteger2, SysRevID, SysRowID, IsCSRSet, ECCPaymentMethod, AGUseGoodDefaultMark, OTSShipToNum, ProFormaInvComment, ccToken, InvcOrderCmp, ReprintSOAck, CounterSOAck, DispatchReason, Plant, ReadyToFulfill, ShipByTime, TWFiscalYear, TWFiscalYearSuffix, TWFiscalPeriod, TWGUIGroup, TWGUIRegNumSeller, TWGUIRegNumBuyer, OrderOpenCredit, ClosedNotShipped, InvCurrDepositBal, PLArticle106c, PLInvIssuedByTaxpayer, PLInvIssuedBySecondTaxpayer, PLTouristService, PLSecondHandOrArts, PLLegalArticleAct, PLLegalArticleWEDirective, PLLegalArticleOther, PLEnforcementAuthName, PLEnforcementAuthAddr, PLTaxRepresentativeName, PLTaxRepresentativeAddr, PLTaxRepresentativeTaxID, PLMarginScheme, PLGoodsOrServiceVATExempt, CCCity, CCState, ExtAOEUserID, ExtAOE, OTSTaxValidationStatus, OTSTaxValidationDate', NULL, N'Company,OrderNum', N'ChangeDate', CAST(N'2023-12-13T05:34:58.8566667' AS DateTime2), N'Succeeded', 1, N'RDBMS', CAST(N'2023-12-13T05:30:55.2133333' AS DateTime2), CAST(N'2023-12-12T00:00:00.000' AS DateTime), N'', NULL, 1)
GO
INSERT [common].[EU_RDBMSControlTable] ([ControlID], [BusinessArea], [SrcConnectionFriendlyName], [SrcTableSchema], [SrcTableName], [TgtConnectionFriendlyName], [TgtTableSchema], [TgtTableName], [TgtRootContainer], [TgtFileName], [ColumnList], [Query], [PrimaryKeyList], [IncRefreshColumn], [LastRefreshDate], [LastRefreshStatus], [IsActive], [Tag], [RefreshStartDate], [IncRefreshMaxDate], [latest_file_path], [AdditionalFilterConditions], [IsDelete]) VALUES (32, N'EpicorERP', N'STG_OnPremConnection', N'Ice', N'UD21', N'TGT_AzureSQLConnection', N'EU_stg', N'UD21', N'raw', NULL, N'Company,Key1,Key2,Key3,Key4,Key5,Character01,Character02,Character03,Character04,Character05,Character06,Character07,Character08,Character09,Character10,Number01,Number02,Number03,Number04,Number05,Number06,Number07,Number08,Number09,Number10,Number11,Number12,Number13,Number14,Number15,Number16,Number17,Number18,Number19,Number20,Date01,Date02,Date03,Date04,Date05,Date06,Date07,Date08,Date09,Date10,Date11,Date12,Date13,Date14,Date15,Date16,Date17,Date18,Date19,Date20,CheckBox01,CheckBox02,CheckBox03,CheckBox04,CheckBox05,CheckBox06,CheckBox07,CheckBox08,CheckBox09,CheckBox10,CheckBox11,CheckBox12,CheckBox13,CheckBox14,CheckBox15,CheckBox16,CheckBox17,CheckBox18,CheckBox19,CheckBox20,ShortChar01,ShortChar02,ShortChar03,ShortChar04,ShortChar05,ShortChar06,ShortChar07,ShortChar08,ShortChar09,ShortChar10,ShortChar11,ShortChar12,ShortChar13,ShortChar14,ShortChar15,ShortChar16,ShortChar17,ShortChar18,ShortChar19,ShortChar20,GlobalUD21,GlobalLock,SysRevID,SysRowID', NULL, N'Company,Key1,Key2,Key3,Key4,Key5', NULL, CAST(N'2023-12-13T05:34:20.7766667' AS DateTime2), N'Succeeded', 1, N'RDBMS', CAST(N'2023-12-13T05:30:55.2133333' AS DateTime2), CAST(N'1900-01-01T00:00:00.000' AS DateTime), N'', NULL, NULL)
GO
INSERT [common].[EU_RDBMSControlTable] ([ControlID], [BusinessArea], [SrcConnectionFriendlyName], [SrcTableSchema], [SrcTableName], [TgtConnectionFriendlyName], [TgtTableSchema], [TgtTableName], [TgtRootContainer], [TgtFileName], [ColumnList], [Query], [PrimaryKeyList], [IncRefreshColumn], [LastRefreshDate], [LastRefreshStatus], [IsActive], [Tag], [RefreshStartDate], [IncRefreshMaxDate], [latest_file_path], [AdditionalFilterConditions], [IsDelete]) VALUES (16, N'EpicorERP', N'STG_OnPremConnection', N'erp', N'Part', N'TGT_AzureSQLConnection', N'EU_stg', N'Part', N'raw', NULL, N'Company, PartNum, SearchWord, PartDescription, ClassID, IUM, PUM, TypeCode, NonStock, PurchasingFactor, UnitPrice, PricePerCode, InternalUnitPrice, InternalPricePerCode, ProdCode, MfgComment, PurComment, CostMethod, UserChar1, UserChar2, UserChar3, UserChar4, UserDate1, UserDate2, UserDate3, UserDate4, UserDecimal1, UserDecimal2, UserDecimal3, UserDecimal4, UserInteger1, UserInteger2, TaxCatID, InActive, LowLevelCode, Method, TrackLots, TrackDimension, DefaultDim, TrackSerialNum, CommodityCode, WarrantyCode, PhantomBOM, SalesUM, SellingFactor, MtlBurRate, NetWeight, UsePartRev, PartsPerContainer, PartLength, PartWidth, PartHeight, LotShelfLife, WebPart, RunOut, SubPart, Diameter, Gravity, OnHold, OnHoldDate, OnHoldReasonCode, AnalysisCode, GlobalPart, MtlAnalysisCode, GlobalLock, ISSuppUnitsFactor, PDMObjID, ImageFileName, ISOrigCountry, SNPrefix, SNFormat, SNBaseDataType, Constrained, UPCCode1, UPCCode2, UPCCode3, EDICode, WebInStock, ConsolidatedPurchasing, PurchasingFactorDirection, SellingFactorDirection, RecDocReq, MDPV, ShipDocReq, ReturnableContainer, NetVolume, QtyBearing, NAFTAOrigCountry, NAFTAProd, NAFTAPref, ExpLicType, ExpLicNumber, ECCNNumber, AESExp, HTS, UseHTSDesc, SchedBcode, HazItem, HazTechName, HazClass, HazSub, HazGvrnmtID, HazPackInstr, RevChargeMethod, RCUnderThreshold, RCOverThreshold, OwnershipStatus, UOMClassID, SNMask, SNMaskExample, SNMaskSuffix, SNMaskPrefix, SNLastUsedSeq, UseMaskSeq, NetWeightUOM, NetVolumeUOM, LotBatch, LotMfgBatch, LotMfgLot, LotHeat, LotFirmware, LotBeforeDt, LotMfgDt, LotCureDt, LotExpDt, LotPrefix, LotUseGlobalSeq, LotSeqID, LotNxtNum, LotDigits, LotLeadingZeros, LotAppendDate, BuyToOrder, DropShip, IsConfigured, ExtConfig, RefCategory, CSFCJ5, CSFLMW, GrossWeight, GrossWeightUOM, BasePartNum, FSAssetClassCode, FSSalesUnitPrice, FSPricePerCode, RcvInspectionReq, EstimateID, EstimateOrPlan, DiffPrc2PrchUOM, DupOnJobCrt, PricingFactor, PricingUOM, MobilePart, SysRevID, SysRowID, AGUseGoodMark, AGProductMark, ISRegion, INChapterID, PESUNATType, PESUNATUOM, DEIsServices, DEIsSecurityFinancialDerivative, DEInternationalSecuritiesID, LinkToContract, DEIsInvestment, DEPayStatCode, DEDenomination, PartLengthWidthHeightUM, DiameterUM, DiameterInside, DiameterOutside, ThicknessUM, Thickness, ThicknessMax, Durometer, Specification, EngineeringAlert, Condition, IsCompliant, IsRestricted, IsSafetyItem, CommercialBrand, CommercialSubBrand, CommercialCategory, CommercialSubCategory, CommercialStyle, CommercialSize1, CommercialSize2, CommercialColor, IsGiftCard, PhotoFile, PartPhotoExists, CommentText, PartSpecificPackingUOM, ImageID, CNSpecification, SyncToExternalCRM, ExternalCRMPartID, ExternalCRMLastSync, ExternalCRMSyncRequired, PESUNATTypeCode, PESUNATUOMCode, CNCodeVersion, CNTaxCategoryCode, CNHasPreferentialTreatment, CNPreferentialTreatmentContent, CNZeroTaxRateMark, SubLevelCode, CreatedBy, CreatedOn, AttBatch, AttMfgBatch, AttMfgLot, AttHeat, AttFirmware, AttBeforeDt, AttMfgDt, AttCureDt, AttExpDt, DeferManualEntry, DeferPurchaseReceipt, DeferJobReceipt, DeferInspection, DeferQtyAdjustment, DeferInventoryMove, DeferShipments, DeferInventoryCounts, DeferAssetDisposal, DeferReturnMaterials, MXProdServCode, ChangedOn, MXCustomsDuty, SendToFSA, ExternalMESSyncRequired, ExternalMESLastSync, FSAItem, FSAEquipment, BOLClass, FairMarketValue, SAFTProdCategory, AttrClassID, LocationIDNumReq, LocationTrackInv, LocationMtlView, LCNRVReporting, LCNRVEstimatedUnitPrice, MXCustomsUMFrom, LocationFormatID, IsServices, PEDetrGoodServiceCode, PEProductServiceCode, DualUOMClassID, CNProductName, CNWeight, CNWeightUOM, CNBonded, TrackInventoryAttributes, DefaultAttributeSetID, AttISOrigCountry, ExternalSchemeID, ExternalID, CommoditySchemeID, CommoditySchemeVersion, TrackInventoryByRevision, PlanningByRevision', NULL, N'Company,PartNum', N'changedon', CAST(N'2023-12-13T05:33:57.4533333' AS DateTime2), N'Succeeded', 1, N'RDBMS', CAST(N'2023-12-13T05:30:55.2133333' AS DateTime2), CAST(N'2023-12-12T16:23:32.697' AS DateTime), N'', NULL, 1)
GO
INSERT [common].[EU_RDBMSControlTable] ([ControlID], [BusinessArea], [SrcConnectionFriendlyName], [SrcTableSchema], [SrcTableName], [TgtConnectionFriendlyName], [TgtTableSchema], [TgtTableName], [TgtRootContainer], [TgtFileName], [ColumnList], [Query], [PrimaryKeyList], [IncRefreshColumn], [LastRefreshDate], [LastRefreshStatus], [IsActive], [Tag], [RefreshStartDate], [IncRefreshMaxDate], [latest_file_path], [AdditionalFilterConditions], [IsDelete]) VALUES (20, N'EpicorERP', N'STG_OnPremConnection', N'erp', N'PartTran', N'TGT_AzureSQLConnection', N'EU_stg', N'PartTran', N'raw', NULL, N'Company, SysDate, SysTime, TranNum, PartNum, WareHouseCode, BinNum, TranClass, TranType, InventoryTrans, TranDate, TranQty, UM, MtlUnitCost, LbrUnitCost, BurUnitCost, SubUnitCost, MtlBurUnitCost, ExtCost, CostMethod, JobNum, AssemblySeq, JobSeqType, JobSeq, PackType, PackNum, PackLine, PONum, POLine, PORelNum, WareHouse2, BinNum2, OrderNum, OrderLine, OrderRelNum, EntryPerson, TranReference, PartDescription, RevisionNum, VendorNum, PurPoint, POReceiptQty, POUnitCost, PackSlip, InvoiceNum, InvoiceLine, InvAdjSrc, InvAdjReason, LotNum, DimCode, DUM, DimConvFactor, LotNum2, DimCode2, DUM2, DimConvFactor2, GLTrans, PostedToGL, FiscalYear, FiscalPeriod, JournalNum, Costed, DMRNum, ActionNum, RMANum, COSPostingReqd, JournalCode, Plant, Plant2, CallNum, CallLine, MatNum, JobNum2, AssemblySeq2, JobSeq2, CustNum, RMALine, RMAReceipt, RMADisp, OtherDivValue, PlantTranNum, NonConfID, MtlMtlUnitCost, MtlLabUnitCost, MtlSubUnitCost, MtlBurdenUnitCost, RefType, RefCode, LegalNumber, BeginQty, AfterQty, BegBurUnitCost, BegLbrUnitCost, BegMtlBurUnitCost, BegMtlUnitCost, BegSubUnitCost, AfterBurUnitCost, AfterLbrUnitCost, AfterMtlBurUnitCost, AfterMtlUnitCost, AfterSubUnitCost, PlantCostValue, EmpID, ReconcileNum, CostID, FIFODate, FIFOSeq, ActTranQty, ActTransUOM, InvtyUOM, InvtyUOM2, FIFOAction, FiscalYearSuffix, FiscalCalendarID, BinType, CCYear, CCMonth, CycleSeq, ABTUID, BaseCostMethod, RevertStatus, RevertID, DropShipPackSlip, VarTarget, FIFOSubSeq, AltMtlUnitCost, AltLbrUnitCost, AltBurUnitCost, AltSubUnitCost, AltMtlBurUnitCost, AltExtCost, AltMtlMtlUnitCost, AltMtlLabUnitCost, AltMtlSubUnitCost, AltMtlBurdenUnitCost, TranDocTypeID, PBInvNum, LoanFlag, AssetNum, AdditionNum, DisposalNum, ProjProcessed, AsOfDate, AsOfSeq, MscNum, ODCUnitCost, SysRevID, SysRowID, TranRefType, PCID, PCIDCollapseCounter, PCID2, ContractID, LCFlag, ExtMtlCost, ExtLbrCost, ExtBurCost, ExtSubCost, ExtMtlBurCost, ExtMtlMtlCost, ExtMtlLabCost, ExtMtlSubCost, ExtMtlBurdenCost, MYImportNum, AutoReverse, RevTranNum, RevSysDate, RevSysTime, ExtNonRecoverableCost, EpicorFSA, AttributeSetID, AttributeSetDescription, AttributeSetShortDescription, NumberOfPieces, WIPPCID, WIPPCID2', NULL, N'Company,SysDate,SysTime,TranNum', N'SysDate', CAST(N'2023-12-13T05:35:16.5333333' AS DateTime2), N'Succeeded', 1, N'RDBMS', CAST(N'2023-12-13T05:30:55.2133333' AS DateTime2), CAST(N'2023-12-13T00:00:00.000' AS DateTime), N'', NULL, 0)
GO
INSERT [common].[EU_RDBMSControlTable] ([ControlID], [BusinessArea], [SrcConnectionFriendlyName], [SrcTableSchema], [SrcTableName], [TgtConnectionFriendlyName], [TgtTableSchema], [TgtTableName], [TgtRootContainer], [TgtFileName], [ColumnList], [Query], [PrimaryKeyList], [IncRefreshColumn], [LastRefreshDate], [LastRefreshStatus], [IsActive], [Tag], [RefreshStartDate], [IncRefreshMaxDate], [latest_file_path], [AdditionalFilterConditions], [IsDelete]) VALUES (24, N'EpicorERP', N'STG_OnPremConnection', N'erp', N'PODetail', N'TGT_AzureSQLConnection', N'EU_stg', N'PODetail', N'raw', NULL, N'Company, OpenLine, VoidLine, PONUM, POLine, LineDesc, IUM, UnitCost, DocUnitCost, OrderQty, XOrderQty, Taxable, PUM, CostPerCode, PartNum, VenPartNum, CommentText, ClassID, RevisionNum, RcvInspectionReq, VendorNum, AdvancePayBal, DocAdvancePayBal, Confirmed, DateChgReq, QtyChgReq, PartNumChgReq, RevisionNumChgReq, ConfirmDate, ConfirmVia, PrcChgReq, PurchCode, OrderNum, OrderLine, Linked, ExtCompany, GlbCompany, ContractActive, ContractQty, ContractUnitCost, ContractDocUnitCost, Rpt1AdvancePayBal, Rpt2AdvancePayBal, Rpt3AdvancePayBal, Rpt1UnitCost, Rpt2UnitCost, Rpt3UnitCost, ContractQtyUOM, Rpt1ContractUnitCost, Rpt2ContractUnitCost, Rpt3ContractUnitCost, BaseQty, BaseUOM, BTOOrderNum, BTOOrderLine, VendorPartOpts, MfgPartOpts, SubPartOpts, MfgNum, MfgPartNum, SubPartNum, SubPartType, ConfigUnitCost, ConfigBaseUnitCost, ConvOverRide, BasePartNum, BaseRevisionNum, Direction, Per, MaintainPricingUnits, OverrideConversion, RowsManualFactor, KeepRowsManualFactorTmp, ShipToSupplierDate, Factor, PricingQty, PricingUnitPrice, UOM, SysRevID, SysRowID, GroupSeq, DocPricingUnitPrice, OverridePriceList, QtyOption, OrigComment, SmartString, SmartStringProcessed, DueDate, ContractID, LinkToContract, SelCurrPricingUnitPrice, ChangedBy, ChangeDate, PCLinkRemoved, TaxCatID, NoTaxRecalc, InUnitCost, DocInUnitCost, Rpt1InUnitCost, Rpt2InUnitCost, Rpt3InUnitCost, InAdvancePayBal, DocInAdvancePayBal, Rpt1InAdvancePayBal, Rpt2InAdvancePayBal, Rpt3InAdvancePayBal, InContractUnitCost, DocInContractUnitCost, Rpt1InContractUnitCost, Rpt2InContractUnitCost, Rpt3InContractUnitCost, DocExtCost, ExtCost, Rpt1ExtCost, Rpt2ExtCost, Rpt3ExtCost, DocMiscCost, MiscCost, Rpt1MiscCost, Rpt2MiscCost, Rpt3MiscCost, TotalTax, DocTotalTax, Rpt1TotalTax, Rpt2TotalTax, Rpt3TotalTax, TotalSATax, DocTotalSATax, Rpt1TotalSATax, Rpt2TotalSATax, Rpt3TotalSATax, TotalDedTax, DocTotalDedTax, Rpt1TotalDedTax, Rpt2TotalDedTax, Rpt3TotalDedTax, CommodityCode', NULL, N'Company,PONUM,POLine', N'ChangeDate', CAST(N'2023-12-13T05:33:57.8700000' AS DateTime2), N'Succeeded', 1, N'RDBMS', CAST(N'2023-12-13T05:30:55.2133333' AS DateTime2), CAST(N'2023-12-12T17:14:56.157' AS DateTime), N'', NULL, 1)
GO
INSERT [common].[EU_RDBMSControlTable] ([ControlID], [BusinessArea], [SrcConnectionFriendlyName], [SrcTableSchema], [SrcTableName], [TgtConnectionFriendlyName], [TgtTableSchema], [TgtTableName], [TgtRootContainer], [TgtFileName], [ColumnList], [Query], [PrimaryKeyList], [IncRefreshColumn], [LastRefreshDate], [LastRefreshStatus], [IsActive], [Tag], [RefreshStartDate], [IncRefreshMaxDate], [latest_file_path], [AdditionalFilterConditions], [IsDelete]) VALUES (25, N'EpicorERP', N'STG_OnPremConnection', N'erp', N'POHeader', N'TGT_AzureSQLConnection', N'EU_stg', N'POHeader', N'raw', NULL, N'Company, OpenOrder, VoidOrder, PONum, EntryPerson, OrderDate, FOB, ShipViaCode, TermsCode, ShipName, ShipAddress1, ShipAddress2, ShipAddress3, ShipCity, ShipState, ShipZIP, ShipCountry, BuyerID, FreightPP, PrcConNum, VendorNum, PurPoint, CommentText, OrderHeld, ShipToConName, ReadyToPrint, PrintAs, CurrencyCode, ExchangeRate, LockRate, ShipCountryNum, LogChanges, ApprovedDate, ApprovedBy, Approve, ApprovalStatus, ApprovedAmount, PostToWeb, PostDate, VendorRefNum, ConfirmReq, Confirmed, ConfirmVia, OrderNum, LegalNumber, Linked, ExtCompany, XRefPONum, ConsolidatedPO, GlbCompany, ContractOrder, ContractStartDate, ContractEndDate, PrintHeaderAddress, RateGrpCode, POType, APLOCID, TranDocTypeID, AutoPrintReady, ICPOLocked, SysRevID, SysRowID, DueDate, PromiseDate, ChangedBy, ChangeDate, POTaxReadyToProcess, TaxRegionCode, TaxPoint, TaxRateDate, TotalTax, DocTotalTax, Rpt1TotalTax, Rpt2TotalTax, Rpt3TotalTax, TotalWhTax, DocTotalWhTax, Rpt1TotalWhTax, Rpt2TotalWhTax, Rpt3TotalWhTax, TotalSATax, DocTotalSATax, Rpt1TotalSATax, Rpt2TotalSATax, Rpt3TotalSATax, InPrice, HdrTaxNoUpdt, TaxRateGrpCode, TotalDedTax, DocTotalDedTax, Rpt1TotalDedTax, Rpt2TotalDedTax, Rpt3TotalDedTax, TotalCharges, TotalMiscCharges, TotalOrder, DocTotalCharges, DocTotalMisc, DocTotalOrder, Rpt1TotalCharges, Rpt2TotalCharges, Rpt3TotalCharges, Rpt1TotalMiscCharges, Rpt2TotalMiscCharges, Rpt3TotalMiscCharges, Rpt1TotalOrder, Rpt2TotalOrder, Rpt3TotalOrder, APTaxRoundOption', NULL, N'Company,PONum', N'ChangeDate', CAST(N'2023-12-13T05:35:10.2566667' AS DateTime2), N'Succeeded', 1, N'RDBMS', CAST(N'2023-12-13T05:30:55.2133333' AS DateTime2), CAST(N'2023-12-12T17:15:16.320' AS DateTime), N'', NULL, 1)
GO
INSERT [common].[EU_RDBMSControlTable] ([ControlID], [BusinessArea], [SrcConnectionFriendlyName], [SrcTableSchema], [SrcTableName], [TgtConnectionFriendlyName], [TgtTableSchema], [TgtTableName], [TgtRootContainer], [TgtFileName], [ColumnList], [Query], [PrimaryKeyList], [IncRefreshColumn], [LastRefreshDate], [LastRefreshStatus], [IsActive], [Tag], [RefreshStartDate], [IncRefreshMaxDate], [latest_file_path], [AdditionalFilterConditions], [IsDelete]) VALUES (26, N'EpicorERP', N'STG_OnPremConnection', N'erp', N'PriceLst', N'TGT_AzureSQLConnection', N'EU_stg', N'PriceLst', N'raw', NULL, N'Company, ListCode, CurrencyCode, ListDescription, StartDate, EndDate, WarehouseList, GlobalPriceLst, GlobalLock, ListType, SysRevID, SysRowID, UseZeroPrice', NULL, N'Company,ListCode', NULL, CAST(N'2023-12-13T05:35:06.2400000' AS DateTime2), N'Succeeded', 1, N'RDBMS', CAST(N'2023-12-13T05:30:55.2133333' AS DateTime2), CAST(N'1900-01-01T00:00:00.000' AS DateTime), N'', NULL, NULL)
GO
INSERT [common].[EU_RDBMSControlTable] ([ControlID], [BusinessArea], [SrcConnectionFriendlyName], [SrcTableSchema], [SrcTableName], [TgtConnectionFriendlyName], [TgtTableSchema], [TgtTableName], [TgtRootContainer], [TgtFileName], [ColumnList], [Query], [PrimaryKeyList], [IncRefreshColumn], [LastRefreshDate], [LastRefreshStatus], [IsActive], [Tag], [RefreshStartDate], [IncRefreshMaxDate], [latest_file_path], [AdditionalFilterConditions], [IsDelete]) VALUES (27, N'EpicorERP', N'STG_OnPremConnection', N'erp', N'PriceLstParts', N'TGT_AzureSQLConnection', N'EU_stg', N'PriceLstParts', N'raw', NULL, N'Company, ListCode, PartNum, BasePrice, DiscountPercent1, DiscountPercent2, DiscountPercent3, DiscountPercent4, DiscountPercent5, QtyBreak1, QtyBreak2, QtyBreak3, QtyBreak4, QtyBreak5, UnitPrice1, UnitPrice2, UnitPrice3, UnitPrice4, UnitPrice5, CommentText, UOMCode, GlobalPriceLstParts, GlobalLock, SysRevID, SysRowID', NULL, N'Company,ListCode,PartNum,UOMCode', NULL, CAST(N'2023-12-13T05:35:10.1900000' AS DateTime2), N'Succeeded', 1, N'RDBMS', CAST(N'2023-12-13T05:30:55.2133333' AS DateTime2), CAST(N'1900-01-01T00:00:00.000' AS DateTime), N'', NULL, NULL)
GO
INSERT [common].[EU_RDBMSControlTable] ([ControlID], [BusinessArea], [SrcConnectionFriendlyName], [SrcTableSchema], [SrcTableName], [TgtConnectionFriendlyName], [TgtTableSchema], [TgtTableName], [TgtRootContainer], [TgtFileName], [ColumnList], [Query], [PrimaryKeyList], [IncRefreshColumn], [LastRefreshDate], [LastRefreshStatus], [IsActive], [Tag], [RefreshStartDate], [IncRefreshMaxDate], [latest_file_path], [AdditionalFilterConditions], [IsDelete]) VALUES (28, N'EpicorERP', N'STG_OnPremConnection', N'erp', N'PriceLstParts_UD', N'TGT_AzureSQLConnection', N'EU_stg', N'PriceLstParts_UD', N'raw', NULL, N'*', NULL, NULL, NULL, CAST(N'2023-12-13T05:36:01.6700000' AS DateTime2), N'Succeeded', 1, N'RDBMS', CAST(N'2023-12-13T05:30:55.2133333' AS DateTime2), CAST(N'1900-01-01T00:00:00.000' AS DateTime), N'', NULL, NULL)
GO
INSERT [common].[EU_RDBMSControlTable] ([ControlID], [BusinessArea], [SrcConnectionFriendlyName], [SrcTableSchema], [SrcTableName], [TgtConnectionFriendlyName], [TgtTableSchema], [TgtTableName], [TgtRootContainer], [TgtFileName], [ColumnList], [Query], [PrimaryKeyList], [IncRefreshColumn], [LastRefreshDate], [LastRefreshStatus], [IsActive], [Tag], [RefreshStartDate], [IncRefreshMaxDate], [latest_file_path], [AdditionalFilterConditions], [IsDelete]) VALUES (29, N'EpicorERP', N'STG_OnPremConnection', N'erp', N'SalesRep', N'TGT_AzureSQLConnection', N'EU_stg', N'SalesRep', N'raw', NULL, N'InActive,Company,SalesRepCode,Name,CommissionPercent,CommissionEarnedAt,AlertFlag,Address1,Address2,Address3,City,State,Zip,Country,CountryNum,OfficePhoneNum,FaxPhoneNum,CellPhoneNum,PagerNum,HomePhoneNum,EMailAddress,SalesRepTitle,RepReportsTo,Comment,SalesMgrConfidence,RoleCode,ViewAllTer,ViewCompPipe,WebSaleGetsCommission,CnvEmpID,PerConID,SyncNameToPerCon,SyncAddressToPerCon,SyncPhoneToPerCon,SyncEmailToPerCon,SyncLinksToPerCon,WebSite,IM,Twitter,LinkedIn,FaceBook,WebLink1,WebLink2,WebLink3,WebLink4,WebLink5,MgrWorstCsPct,MgrBestCsPct,SysRevID,SysRowID,WebSalesRep,ECCSalesRepCode', NULL, N'Company,Name', NULL, CAST(N'2023-12-13T05:35:27.7700000' AS DateTime2), N'Succeeded', 1, N'RDBMS', CAST(N'2023-12-13T05:30:55.2133333' AS DateTime2), CAST(N'1900-01-01T00:00:00.000' AS DateTime), N'', NULL, NULL)
GO
INSERT [common].[EU_RDBMSControlTable] ([ControlID], [BusinessArea], [SrcConnectionFriendlyName], [SrcTableSchema], [SrcTableName], [TgtConnectionFriendlyName], [TgtTableSchema], [TgtTableName], [TgtRootContainer], [TgtFileName], [ColumnList], [Query], [PrimaryKeyList], [IncRefreshColumn], [LastRefreshDate], [LastRefreshStatus], [IsActive], [Tag], [RefreshStartDate], [IncRefreshMaxDate], [latest_file_path], [AdditionalFilterConditions], [IsDelete]) VALUES (31, N'EpicorERP', N'STG_OnPremConnection', N'erp', N'Vendcnt', N'TGT_AzureSQLConnection', N'EU_stg', N'Vendcnt', N'raw', NULL, N'Company, VendorNum, PurPoint, ConNum, Name, Func, FaxNum, PhoneNum, EmailAddress, WebPassword, WebUser, RoleCode, CellPhoneNum, PagerNum, HomeNum, AltNum, ContactTitle, ReportsTo, Comment, NoContact, CreateDate, CreateDcdUserID, ChangeDate, ChangeDcdUserID, Inactive, FirstName, MiddleName, LastName, Prefix, Suffix, Initials, ExternalId, GlobalLock, PerConID, SyncEmailToPerCon, SyncLinksToPerCon, SyncNameToPerCon, SyncPhoneToPerCon, WebSite, IM, Twitter, LinkedIn, FaceBook,WebLink1, WebLink2, WebLink3, WebLink4, WebLink5, SysRevID, SysRowID', NULL, N'Company,VendorNum,PurPoint,ConNum,SysRowID', N'ChangeDate', CAST(N'2023-12-13T05:34:58.0366667' AS DateTime2), N'Succeeded', 1, N'RDBMS', CAST(N'2023-12-13T05:30:55.2133333' AS DateTime2), CAST(N'1900-01-01T00:00:00.000' AS DateTime), N'', NULL, NULL)
GO
INSERT [common].[EU_RDBMSControlTable] ([ControlID], [BusinessArea], [SrcConnectionFriendlyName], [SrcTableSchema], [SrcTableName], [TgtConnectionFriendlyName], [TgtTableSchema], [TgtTableName], [TgtRootContainer], [TgtFileName], [ColumnList], [Query], [PrimaryKeyList], [IncRefreshColumn], [LastRefreshDate], [LastRefreshStatus], [IsActive], [Tag], [RefreshStartDate], [IncRefreshMaxDate], [latest_file_path], [AdditionalFilterConditions], [IsDelete]) VALUES (30, N'EpicorERP', N'STG_OnPremConnection', N'erp', N'Vendor', N'TGT_AzureSQLConnection', N'EU_stg', N'Vendor', N'raw', NULL, N'Inactive, Company, VendorID, Name, VendorNum, Address1, Address2, Address3, City, State, ZIP, Country, TaxPayerID, PurPoint, TermsCode, GroupCode, Print1099, OneCheck, PrintLabels, FaxNum, PhoneNum, Comment, PayHold, PrimPCon, AccountRef, DefaultFOB, RcvInspectionReq, CurrencyCode, TaxRegionCode, CountryNum, LangNameID, BorderCrossing, FormatStr, ElecPayment, PrimaryBankID, Approved, ICVend, EMailAddress, WebVendor, VendURL, EarlyBuffer, LateBuffer, OnTimeRating, QualityRating, PriceRating, ServiceRating, ExternalId, VendPILimit, GlobalVendor, ICTrader, TaxAuthorityCode, GlobalLock, MinOrderValue, CalendarID, EDICode, ConsolidatedPurchasing, LocalPurchasing, ResDelivery, SatDelivery, SatPickup, Hazmat, DocOnly, RefNotes, ApplyChrg, ChrgAmount, COD, CODFreight, CODCheck, CODAmount, GroundType, NotifyFlag, NotifyEMail, DeclaredIns, DeclaredAmt, ServSignature, ServAlert, ServHomeDel, DeliveryType, ServDeliveryDate, ServPhone, ServInstruct, ServRelease, ServAuthNum, ServRef1, ServRef2, ServRef3, ServRef4, ServRef5, CPay, IndividualPackIDs, IntrntlShip, CertOfOrigin, CommercialInvoice, ShipExprtDeclartn, LetterOfInstr, FFID, FFCompName, FFContact, FFAddress1, FFAddress2, FFAddress3, FFCity, FFState, FFZip, FFCountry, NonStdPkg, DeliveryConf, AddlHdlgFlag, UPSQuantumView, UPSQVShipFromName, UPSQVMemo, FFPhoneNum, FFCountryNum, RevChargeMethod, ManagedCust, ManagedCustID, ManagedCustNum, PMUID, HasBank, PmtAcctRef, LegalName, TaxRegReason, OrgRegCode, AdvTaxInv, AllowAsAltRemitTo, SysRevID, SysRowID, THBranchID, ParamCode, AGAFIPResponsibilityCode, AGGrossIncomeTaxID, AGIDDocumentTypeCode, AGProvinceCode, AGUseGoodDefaultMark, AGApartment, AGExtraStreetNumber, AGFloor, AGLocationCode, AGNeighborhood, AGStreet, AGStreetNumber, COOneTimeID, NoBankingReference, PEGoodsContributor, PEWithholdAgent, PECollectionAgent, PENotFound, PENoAddress, PEIdentityDocType, COIsOneTimeVend, PEDocumentID, MaxLateDaysPORel, Code1099ID, TIN, TINType, SecondTINNotice, NameControl, ShipViaCode, NonUS, FormTypeID, INSupplierType, INCSTNumber, INPANNumber, DEOrgType, PaymentReporting, ExternalPurchasing, MXRetentionCode, Reporting1099Name, Reporting1099Name2, FATCA, AccountNum, TWGUIRegNum, MXTARCode, PEAddressID, PERetentionRegime, TaxEntityType, INGSTComplianceRate, INTaxRegistrationID, TINValidationStatus, ImporterOfRecord, PLAutomaticAPInvoiceNum, SEC, MXDIOTTranType, US1099KMerchCatCode, MXTaxpayerType, MXLegalRepRFC, MXLegalRepCURP, MXLegalRepName, MXLegalRepTaxpayerType, US1099State, TaxValidationStatus, TaxValidationDate, HMRCTaxValidationLog, ExternalSchemeID, MXMunicipio, EInvoice', NULL, N'Company,VendorNum', NULL, CAST(N'2023-12-13T05:36:21.0633333' AS DateTime2), N'Succeeded', 1, N'RDBMS', CAST(N'2023-12-13T05:30:55.2133333' AS DateTime2), CAST(N'1900-01-01T00:00:00.000' AS DateTime), N'', NULL, NULL)
GO
SET IDENTITY_INSERT [common].[EU_RDBMSControlTable] OFF
GO
SET IDENTITY_INSERT [common].[EU_ValidationControlTable] ON 
GO
INSERT [common].[EU_ValidationControlTable] ([ID], [MeasureName], [SourceConnection], [SourceQuery], [TargetConnection], [TargetQuery], [IsActive], [Tag], [Status]) VALUES (1, N'All_RowCounts', N'STG_OnPremConnection', N'Select count(*) as MeasureValue , ''Customer'' as MeasureName from ERP.Customer  Union all 
Select count(*) as MeasureValue , ''CurrExRate'' as MeasureName from ERP.CurrExRate  Union all 
Select count(*) as MeasureValue , ''CustCnt_UD'' as MeasureName from ERP.CustCnt_UD  Union all 
Select count(*) as MeasureValue , ''CustomerPriceLst'' as MeasureName from ERP.CustomerPriceLst  Union all 
Select count(*) as MeasureValue , ''InvcDtl_UD'' as MeasureName from ERP.InvcDtl_UD  Union all 
Select count(*) as MeasureValue , ''PartWhse_UD'' as MeasureName from ERP.PartWhse_UD  Union all 
Select count(*) as MeasureValue , ''PLPartBrk'' as MeasureName from ERP.PLPartBrk  Union all 
Select count(*) as MeasureValue , ''CustCnt'' as MeasureName from ERP.CustCnt  Union all 
Select count(*) as MeasureValue , ''Customer_UD'' as MeasureName from ERP.Customer_UD  Union all 
Select count(*) as MeasureValue , ''CustXPrt'' as MeasureName from ERP.CustXPrt  Union all 
Select count(*) as MeasureValue , ''OrderDtl'' as MeasureName from ERP.OrderDtl  Union all 
Select count(*) as MeasureValue , ''OrderDtl_UD'' as MeasureName from ERP.OrderDtl_UD  Union all 
Select count(*) as MeasureValue , ''OrderHed_UD'' as MeasureName from ERP.OrderHed_UD  Union all 
Select count(*) as MeasureValue , ''InvcDtl'' as MeasureName from ERP.InvcDtl  Union all 
Select count(*) as MeasureValue , ''Part_UD'' as MeasureName from ERP.Part_UD  Union all 
Select count(*) as MeasureValue , ''PartBin'' as MeasureName from ERP.PartBin  Union all 
Select count(*) as MeasureValue , ''PartCost'' as MeasureName from ERP.PartCost  Union all 
Select count(*) as MeasureValue , ''PartWhse'' as MeasureName from ERP.PartWhse  Union all 
Select count(*) as MeasureValue , ''Invchead'' as MeasureName from ERP.Invchead  Union all 
Select count(*) as MeasureValue , ''OrderHed'' as MeasureName from ERP.OrderHed  Union all 
Select count(*) as MeasureValue , ''UD21'' as MeasureName from ICE.UD21  Union all 
Select count(*) as MeasureValue , ''Part'' as MeasureName from ERP.Part  Union all 
Select count(*) as MeasureValue , ''PartTran'' as MeasureName from ERP.PartTran  Union all 
Select count(*) as MeasureValue , ''PODetail'' as MeasureName from ERP.PODetail  Union all 
Select count(*) as MeasureValue , ''POHeader'' as MeasureName from ERP.POHeader  Union all 
Select count(*) as MeasureValue , ''PriceLst'' as MeasureName from ERP.PriceLst  Union all 
Select count(*) as MeasureValue , ''PriceLstParts'' as MeasureName from ERP.PriceLstParts  Union all 
Select count(*) as MeasureValue , ''PriceLstParts_UD'' as MeasureName from ERP.PriceLstParts_UD  Union all 
Select count(*) as MeasureValue , ''SalesRep'' as MeasureName from ERP.SalesRep  Union all 
Select count(*) as MeasureValue , ''Vendcnt'' as MeasureName from ERP.Vendcnt  Union all 
Select count(*) as MeasureValue , ''Vendor'' as MeasureName from ERP.Vendor', N'TGT_AzureSQLConnection', N'Select count(*) as MeasureValue , ''Customer'' as MeasureName from EU_STG.Customer  Union all 
Select count(*) as MeasureValue , ''CurrExRate'' as MeasureName from EU_STG.CurrExRate  Union all 
Select count(*) as MeasureValue , ''CustCnt_UD'' as MeasureName from EU_STG.CustCnt_UD  Union all 
Select count(*) as MeasureValue , ''CustomerPriceLst'' as MeasureName from EU_STG.CustomerPriceLst  Union all 
Select count(*) as MeasureValue , ''InvcDtl_UD'' as MeasureName from EU_STG.InvcDtl_UD  Union all 
Select count(*) as MeasureValue , ''PartWhse_UD'' as MeasureName from EU_STG.PartWhse_UD  Union all 
Select count(*) as MeasureValue , ''PLPartBrk'' as MeasureName from EU_STG.PLPartBrk  Union all 
Select count(*) as MeasureValue , ''CustCnt'' as MeasureName from EU_STG.CustCnt  Union all 
Select count(*) as MeasureValue , ''Customer_UD'' as MeasureName from EU_STG.Customer_UD  Union all 
Select count(*) as MeasureValue , ''CustXPrt'' as MeasureName from EU_STG.CustXPrt  Union all 
Select count(*) as MeasureValue , ''OrderDtl'' as MeasureName from EU_STG.OrderDtl  Union all 
Select count(*) as MeasureValue , ''OrderDtl_UD'' as MeasureName from EU_STG.OrderDtl_UD  Union all 
Select count(*) as MeasureValue , ''OrderHed_UD'' as MeasureName from EU_STG.OrderHed_UD  Union all 
Select count(*) as MeasureValue , ''InvcDtl'' as MeasureName from EU_STG.InvcDtl  Union all 
Select count(*) as MeasureValue , ''Part_UD'' as MeasureName from EU_STG.Part_UD  Union all 
Select count(*) as MeasureValue , ''PartBin'' as MeasureName from EU_STG.PartBin  Union all 
Select count(*) as MeasureValue , ''PartCost'' as MeasureName from EU_STG.PartCost  Union all 
Select count(*) as MeasureValue , ''PartWhse'' as MeasureName from EU_STG.PartWhse  Union all 
Select count(*) as MeasureValue , ''Invchead'' as MeasureName from EU_STG.Invchead  Union all 
Select count(*) as MeasureValue , ''OrderHed'' as MeasureName from EU_STG.OrderHed  Union all 
Select count(*) as MeasureValue , ''UD21'' as MeasureName from EU_STG.UD21  Union all 
Select count(*) as MeasureValue , ''Part'' as MeasureName from EU_STG.Part  Union all 
Select count(*) as MeasureValue , ''PartTran'' as MeasureName from EU_STG.PartTran  Union all 
Select count(*) as MeasureValue , ''PODetail'' as MeasureName from EU_STG.PODetail  Union all 
Select count(*) as MeasureValue , ''POHeader'' as MeasureName from EU_STG.POHeader  Union all 
Select count(*) as MeasureValue , ''PriceLst'' as MeasureName from EU_STG.PriceLst  Union all 
Select count(*) as MeasureValue , ''PriceLstParts'' as MeasureName from EU_STG.PriceLstParts  Union all 
Select count(*) as MeasureValue , ''PriceLstParts_UD'' as MeasureName from EU_STG.PriceLstParts_UD  Union all 
Select count(*) as MeasureValue , ''SalesRep'' as MeasureName from EU_STG.SalesRep  Union all 
Select count(*) as MeasureValue , ''Vendcnt'' as MeasureName from EU_STG.Vendcnt  Union all 
Select count(*) as MeasureValue , ''Vendor'' as MeasureName from EU_STG.Vendor', 1, N'Staging', N'Completed')
GO
INSERT [common].[EU_ValidationControlTable] ([ID], [MeasureName], [SourceConnection], [SourceQuery], [TargetConnection], [TargetQuery], [IsActive], [Tag], [Status]) VALUES (2, N'Duplicates', NULL, NULL, N'TGT_AzureSQLConnection', N'
Exec [common].[usp_EU_DQCheck] ''Customer'',''EU_stg'',''Company,CustNum'',''_RunID''  ,''_BatchID'',''Staging'' ;
Exec [common].[usp_EU_DQCheck] ''CurrExRate'',''EU_stg'',''Company,RateGrpCode,SourceCurrCode,TargetCurrCode,EffectiveDate'',''_RunID''  ,''_BatchID'',''Staging'' ;
Exec [common].[usp_EU_DQCheck] ''CustomerPriceLst'',''EU_stg'',''Company,CustNum,ShipToNum,SeqNum'',''_RunID''  ,''_BatchID'',''Staging'' ;
Exec [common].[usp_EU_DQCheck] ''PLPartBrk'',''EU_stg'',''Company,ListCode,PartNum,UOMCode,Quantity'',''_RunID''  ,''_BatchID'',''Staging'' ;
Exec [common].[usp_EU_DQCheck] ''CustCnt'',''EU_stg'',''Company,CustNum,ShipToNum,ConNum'',''_RunID''  ,''_BatchID'',''Staging'' ;
Exec [common].[usp_EU_DQCheck] ''CustXPrt'',''EU_stg'',''Company,PartNum,CustNum,XPartNum,SysRowID'',''_RunID''  ,''_BatchID'',''Staging'' ;
Exec [common].[usp_EU_DQCheck] ''OrderDtl'',''EU_stg'',''Company,OrderLine,OrderNum'',''_RunID''  ,''_BatchID'',''Staging'' ;
Exec [common].[usp_EU_DQCheck] ''InvcDtl'',''EU_stg'',''Company,InvoiceLine,InvoiceNum'',''_RunID''  ,''_BatchID'',''Staging'' ;
Exec [common].[usp_EU_DQCheck] ''PartBin'',''EU_stg'',''AttributeSetID,BinNum,Company,DimCode,LotNum,PartNum,PCID,WarehouseCode'',''_RunID''  ,''_BatchID'',''Staging'' ;
Exec [common].[usp_EU_DQCheck] ''PartCost'',''EU_stg'',''Company,CostID,PartNum'',''_RunID''  ,''_BatchID'',''Staging'' ;
Exec [common].[usp_EU_DQCheck] ''PartWhse'',''EU_stg'',''Company,PartNum,WarehouseCode'',''_RunID''  ,''_BatchID'',''Staging'' ;
Exec [common].[usp_EU_DQCheck] ''Invchead'',''EU_stg'',''Company,InvoiceNum'',''_RunID''  ,''_BatchID'',''Staging'' ;
Exec [common].[usp_EU_DQCheck] ''OrderHed'',''EU_stg'',''Company,OrderNum'',''_RunID''  ,''_BatchID'',''Staging'' ;
Exec [common].[usp_EU_DQCheck] ''UD21'',''EU_stg'',''Company,Key1,Key2,Key3,Key4,Key5'',''_RunID''  ,''_BatchID'',''Staging'' ;
Exec [common].[usp_EU_DQCheck] ''Part'',''EU_stg'',''Company,PartNum'',''_RunID''  ,''_BatchID'',''Staging'' ;
Exec [common].[usp_EU_DQCheck] ''PartTran'',''EU_stg'',''Company,SysDate,SysTime,TranNum'',''_RunID''  ,''_BatchID'',''Staging'' ;
Exec [common].[usp_EU_DQCheck] ''PODetail'',''EU_stg'',''Company,PONUM,POLine'',''_RunID''  ,''_BatchID'',''Staging'' ;
Exec [common].[usp_EU_DQCheck] ''POHeader'',''EU_stg'',''Company,PONum'',''_RunID''  ,''_BatchID'',''Staging'' ;
Exec [common].[usp_EU_DQCheck] ''PriceLst'',''EU_stg'',''Company,ListCode'',''_RunID''  ,''_BatchID'',''Staging'' ;
Exec [common].[usp_EU_DQCheck] ''PriceLstParts'',''EU_stg'',''Company,ListCode,PartNum,UOMCode'',''_RunID''  ,''_BatchID'',''Staging'' ;
Exec [common].[usp_EU_DQCheck] ''SalesRep'',''EU_stg'',''Company,Name'',''_RunID''  ,''_BatchID'',''Staging'' ;
Exec [common].[usp_EU_DQCheck] ''Vendcnt'',''EU_stg'',''Company,VendorNum,PurPoint,ConNum,SysRowID'',''_RunID''  ,''_BatchID'',''Staging'' ;
Exec [common].[usp_EU_DQCheck] ''Vendor'',''EU_stg'',''Company,VendorNum'',''_RunID''  ,''_BatchID'',''Staging'' ;', 1, N'Staging,DupCheck', N'Completed')
GO
INSERT [common].[EU_ValidationControlTable] ([ID], [MeasureName], [SourceConnection], [SourceQuery], [TargetConnection], [TargetQuery], [IsActive], [Tag], [Status]) VALUES (3, N'All_RowCounts', N'TGT_AzureSQLConnection', N'Select count(*) as MeasureValue , ''Customer'' as MeasureName from EU_STG.Customer  Union all Select count(*) as MeasureValue , ''Part'' as MeasureName from EU_STG.Part', N'TGT_AzureSQLConnection', N'Select count(*) as MeasureValue , ''Customer'' as MeasureName from dbo.EU_DImCustomer  Union all Select count(*) as MeasureValue , ''Part'' as MeasureName from dbo.EU_DimProduct', 1, N'Mart', N'Completed')
GO
SET IDENTITY_INSERT [common].[EU_ValidationControlTable] OFF
GO


GO
SET IDENTITY_INSERT [common].[EU_DatamartcontrolTable] ON 
GO
INSERT [common].[EU_DatamartcontrolTable] ([Id], [MartName], [ProcedureName], [StoredProcedure], [TableSchema], [TableName], [CustomField], [DependsOn], [IsActive], [Tag], [PublishFlag], [CreatedBy], [CreatedDateTime], [UpdatedBy], [UpdatedDateTime]) VALUES (1, N'Mart', N'EU_DIMInvoice', N'dbo.USP_EU_DimInvoice', N'dbo', N'EU_DIMInvoice', NULL, NULL, 0, N'Mart', 1, N'sqladmin', CAST(N'2023-11-17T05:40:31.033' AS DateTime), N'sqladmin', CAST(N'2023-11-17T05:40:31.033' AS DateTime))
GO
INSERT [common].[EU_DatamartcontrolTable] ([Id], [MartName], [ProcedureName], [StoredProcedure], [TableSchema], [TableName], [CustomField], [DependsOn], [IsActive], [Tag], [PublishFlag], [CreatedBy], [CreatedDateTime], [UpdatedBy], [UpdatedDateTime]) VALUES (2, N'Mart', N'EU_DIMOrder', N'dbo.USP_EU_DimOrder', N'dbo', N'EU_DIMOrder', NULL, NULL, 0, N'Mart', 1, N'sqladmin', CAST(N'2023-11-17T05:40:31.037' AS DateTime), N'sqladmin', CAST(N'2023-11-17T05:40:31.037' AS DateTime))
GO
INSERT [common].[EU_DatamartcontrolTable] ([Id], [MartName], [ProcedureName], [StoredProcedure], [TableSchema], [TableName], [CustomField], [DependsOn], [IsActive], [Tag], [PublishFlag], [CreatedBy], [CreatedDateTime], [UpdatedBy], [UpdatedDateTime]) VALUES (3, N'Mart', N'EU_DIMCustomer', N'dbo.USP_EU_DIMCustomer', N'dbo', N'EU_DIMCustomer', NULL, NULL, 1, N'Mart', 1, N'sqladmin', CAST(N'2023-11-17T05:40:31.040' AS DateTime), N'sqladmin', CAST(N'2023-11-17T05:40:31.040' AS DateTime))
GO
INSERT [common].[EU_DatamartcontrolTable] ([Id], [MartName], [ProcedureName], [StoredProcedure], [TableSchema], [TableName], [CustomField], [DependsOn], [IsActive], [Tag], [PublishFlag], [CreatedBy], [CreatedDateTime], [UpdatedBy], [UpdatedDateTime]) VALUES (4, N'Mart', N'EU_DIMProduct', N'dbo.USP_EU_DIMProduct', N'dbo', N'EU_DIMProduct', NULL, NULL, 1, N'Mart', 1, N'sqladmin', CAST(N'2023-11-17T05:40:31.060' AS DateTime), N'sqladmin', CAST(N'2023-11-17T05:40:31.060' AS DateTime))
GO
INSERT [common].[EU_DatamartcontrolTable] ([Id], [MartName], [ProcedureName], [StoredProcedure], [TableSchema], [TableName], [CustomField], [DependsOn], [IsActive], [Tag], [PublishFlag], [CreatedBy], [CreatedDateTime], [UpdatedBy], [UpdatedDateTime]) VALUES (5, N'Mart', N'EU_DimCurrency', N'dbo.USP_EU_DIMCurrency', N'dbo', N'EU_DimCurrency', NULL, NULL, 1, N'Mart', 1, N'sqladmin', CAST(N'2023-11-17T05:40:31.060' AS DateTime), N'sqladmin', CAST(N'2023-11-17T05:40:31.060' AS DateTime))
GO
INSERT [common].[EU_DatamartcontrolTable] ([Id], [MartName], [ProcedureName], [StoredProcedure], [TableSchema], [TableName], [CustomField], [DependsOn], [IsActive], [Tag], [PublishFlag], [CreatedBy], [CreatedDateTime], [UpdatedBy], [UpdatedDateTime]) VALUES (6, N'Mart', N'EU_FactInvoiceSalesOrders', N'dbo.USP_EU_FactInvoiceSalesOrders', N'dbo', N'EU_FactInvoiceSalesOrders', NULL, N'EU_DimCurrency,EU_DIMCustomer', 1, N'Mart', 1, N'sqladmin', CAST(N'2023-11-23T10:46:04.033' AS DateTime), N'sqladmin', CAST(N'2023-11-23T10:46:04.033' AS DateTime))
GO
INSERT [common].[EU_DatamartcontrolTable] ([Id], [MartName], [ProcedureName], [StoredProcedure], [TableSchema], [TableName], [CustomField], [DependsOn], [IsActive], [Tag], [PublishFlag], [CreatedBy], [CreatedDateTime], [UpdatedBy], [UpdatedDateTime]) VALUES (7, N'Mart', N'EU_FactInvoiceOpenOrders', N'dbo.USP_EU_FactInvoiceOpenOrders', N'dbo', N'EU_FactInvoiceOpenOrders', NULL, N'EU_DimCurrency,EU_DIMCustomer', 1, N'Mart', 1, N'sqladmin', CAST(N'2023-11-23T10:46:27.493' AS DateTime), N'sqladmin', CAST(N'2023-11-23T10:46:27.493' AS DateTime))
GO
SET IDENTITY_INSERT [common].[EU_DatamartcontrolTable] OFF
GO
SET IDENTITY_INSERT [common].[EU_RDBMSControlTable] ON 
GO
INSERT [common].[EU_RDBMSControlTable] ([ControlID], [BusinessArea], [SrcConnectionFriendlyName], [SrcTableSchema], [SrcTableName], [TgtConnectionFriendlyName], [TgtTableSchema], [TgtTableName], [TgtRootContainer], [TgtFileName], [ColumnList], [Query], [PrimaryKeyList], [IncRefreshColumn], [LastRefreshDate], [LastRefreshStatus], [IsActive], [Tag], [RefreshStartDate], [IncRefreshMaxDate], [latest_file_path], [AdditionalFilterConditions], [IsDelete]) VALUES (1, N'EpicorERP', N'STG_OnPremConnection', N'erp', N'Customer', N'TGT_AzureSQLConnection', N'EU_stg', N'Customer', N'raw', NULL, N'Company, CustID, CustNum, Name, Address1, Address2, Address3, City, State, Zip, Country, ResaleID, SalesRepCode, TerritoryID, ShipToNum, TermsCode, ShipViaCode, PrintStatements, PrintLabels, PrintAck, FinCharges, CreditHold, GroupCode, DiscountPercent, PrimPCon, PrimBCon, PrimSCon, Comment, EstDate, FaxNum, PhoneNum, TaxExempt, MarkUpID, BillDay, OneInvPerPS, DefaultFOB, CreditIncludeOrders, CreditReviewDate, CreditHoldDate, CreditHoldSource, CreditClearUserID, CreditClearDate, CreditClearTime, EDICode, CurrencyCode, CountryNum, LangNameID, BorderCrossing, FormatStr, BTName, BTAddress1, BTAddress2, BTAddress3, BTCity, BTState, BTZip, BTCountryNum, BTCountry, BTPhoneNum, BTFaxNum, BTFormatStr, ParentCustNum, TaxRegionCode, ICCust, ContBillDay, EMailAddress, ShippingQualifier, AllocPriorityCode, ReservePriorityCode, LinkPortNum, WebCustomer, CustomerType, NoContact, TerritoryLock, CustURL, PendingTerritoryID, ExtID, ConsolidateSO, BillFrequency, CreditIncludePI, GlobalCust, ICTrader, TaxAuthorityCode, ExternalDeliveryNote, GlobalCredIncOrd, GlobalCredIncPI, GlobalCurrencyCode, ExternalID, GlobalCreditHold, GlobalLock, CheckDuplicatePO, CreditLimit, CustPILimit, GlobalCreditLimit, GlobalPILimit, DocGlobalCreditLimit, DocGlobalPILimit, RfqAttachAllow, DiscountQualifier, AllowAltBillTo, DemandDeliveryDays, DemandDateType, DemandAddLeadTime, DemandAddAction, DemandChangeLeadTime, DemandChangeAction, DemandCancelLeadTime, DemandCancelAction, DemandNewLineLeadTime, DemandNewLineAction, DemandQtyChangeLeadTime, DemandQtyChangeAction, DemandChangeDateLeadTime, DemandChangeDateAction, TradingPartnerName, ResDelivery, SatDelivery, SatPickup, Hazmat, DocOnly, RefNotes, ApplyChrg, ChrgAmount, COD, CODFreight, CODCheck, CODAmount, GroundType, NotifyFlag, NotifyEMail, DeclaredIns, DeclaredAmt, PeriodicityCode, ServSignature, ServAlert, ServHomeDel, DeliveryType, ServDeliveryDate, ServPhone, ServInstruct, ServRelease, ServAuthNum, ServRef1, ServRef2, ServRef3, ServRef4, ServRef5, EarlyBuffer, LateBuffer, DemandUnitPriceDiff, DemandUnitPriceDiffAction, ExcFromVal, AddressVal, RebateVendorNum, RebateForm, CreditCardOrder, DemandCheckForPart, DemandCheckForPartAction, ChangedBy, ChangeDate, ChangeTime, ChargeCode, IndividualPackIDs, IntrntlShip, CertOfOrigin, CommercialInvoice, ShipExprtDeclartn, LetterOfInstr, FFID, FFCompName, FFAddress1, FFAddress2, FFAddress3, FFCity, FFState, FFZip, FFCountry, FFCountryNum, FFPhoneNum, NonStdPkg, DeliveryConf, AddlHdlgFlag, UPSQuantumView, UPSQVShipFromName, UPSQVMemo, UPSQVEmailType, FFContact, ETCAddrChg, TaxRoundRule, TaxMethod, ValidPayer, ValidSoldTo, ValidShipTo, OverrideRlsClass, AcrossNatAcc, NAParentCreditIsUsed, NACreditIsShare, NACreditPreferenceList, NAParentCreditPrc, NACreditSharedPrc, AllowOTS, ThirdPLCust, ManagedVendID, ManagedVendNum, NARlsClassCode, DirectDebiting, ReminderCode, GlbNAParentCreditIsUsed, GlbNACreditIsShare, GlbNAParentCreditPrc, GlbNACreditSharedPrc, AllowShipTo3, OTSSaveAs, CustPartOpts, HasBank, PMUID, DemandCheckForRev, OrderHoldForReview, DemandCheckForRevAction, ShipToTerrList, AcctRefNumber, LegalName, TaxRegReason, InvPerPackLine, OrgRegCode, DemandCloseRejSkd, OurBankCode, DemandCloseNoMatch, DmdCheckPartialShip, DmdCheckShipAction, DemandCheckCUMM, DemandCheckCUMMAction, DemandPricing, PriceTolerance, PreferredBank, CheckDateCapPromise, CheckConfirmCapPromise, CheckUpdateCapPromise, DemandCapPromiseDate, DemandCapPromiseAction, DemandCapPromiseUpdate, PeriodicBilling, DueDateCriteria, PBTerms, ERSOrder, DemandSplitSched, OTSmartString, DeferredRev, RACode, DemandCheckConfig, DemandCheckCfgAction, AllowAsAltRemitTo, FederalID, WIApplication, WICustomer, WIShippingCosts, LOQBookPCFinishing, LOQBookPCPaper, LOQBookPCPress, LOQBookPCPlates, Variations, OversPct, UndersPct, DefaultLOQstyle, DefaultOrderAcknowledgement, DefaultPackSlip, DefaultOversPricing, LOQPrepressStyle, CSR, LOQBookCaFinishing, LOQBookCapaper, LOQBookCaPress, LOQBookCatPlates, LOQVariations, DefaultInvoicestyle, AEPLOQType, BusinessCust, SysRevID, SysRowID, THBranchID, CustPricingSchema, ParamCode, AGAFIPResponsibilityCode, AGBillToProvinceCode, AGGrossIncomeTaxID, AGIDDocTypeCode, AGIDDocumentNumber, AGProvinceCode, AGUseGoodDefaultMark, Collections, CollectionsDate, DateCollectionPosted, MXMunicipio, PEIdentityDocType, PEDocumentID, PEGoodsContributor, PEWithholdAgent, PECollectionAgent, PENotFound, PENoAddress, EntityUseCode, InvcOrderCmpDflt, EInvoice, RegistrationCode, EAddress, DemandCheckForRunOutPart, DemandCheckForRunOutPartAction, EInvCompanyIDAttr, INCSTNumber, INPANNumber, COOneTimeID, COIsOneTimeCust, DEOrgType, PEGuaranteeName, PEGuaranteeAddress1, PEGuaranteeAddress2, PEGuaranteeAddress3, PEGuaranteeCity, PEGuaranteeState, PEGuaranteeZip, PEGuaranteeCountry, PEGuaranteePhoneNum, PEGuaranteeTaxID, OurSupplierCode, ECCType, MYIndustryCode, SyncToExternalCRM, ExternalCRMCustomerID, ExternalCRMCustomerType, ExternalCRMLastSync, ExternalCRMSyncRequired, Ownership, Industry, AnnualRevenue, NumberOfEmployees, TickerLocation, TickerSymbol, Rating, TWGUIRegNum, MXAccountNumber, ConsolidateLinesPerPart, TWTaxPayerType, TWDeductGUIFormatCode, MXCURP, PEAddressID, PEPerceptionRegime, TaxEntityType, INGSTComplianceRate, INTaxRegistrationID, MXPurchaseType, SendToFSA, MXGeneralPublic, AgingCreditHold, AgingCreditHoldDate, AgingCreditHoldSource, AgingCreditClearUserID, AgingCreditClearDate, AgingCreditCode, ImporterOfRecord, SEC, EInvEndpointIDAttr, UseBlindShipping, ELIEinvoice, ELIDefReportID, ELIDefStyleNum, ELIDefToMail, ELIDefCCMail, ELIDefMailTempID, ELISendMail, COFiscalResp1, COFiscalResp2, COFiscalResp3, COOperType, CentralCollection, NettingVendorNum, EORINumber, AGIsElectronicCreditInvEligible, TaxValidationStatus, TaxValidationDate, HMRCTaxValidationLog, Inactive, ExternalSchemeID, ELIOperatorCode, ELISendingOption, ELIOperatorID, EInvExternalID, MXTaxRegime', NULL, N'Company,CustNum', N'ChangeDate', CAST(N'2023-12-14T05:31:38.1833333' AS DateTime2), N'Succeeded', 1, N'RDBMS', CAST(N'2023-12-14T05:30:40.7800000' AS DateTime2), CAST(N'2023-12-13T00:00:00.000' AS DateTime), N'', NULL, 1)
GO
INSERT [common].[EU_RDBMSControlTable] ([ControlID], [BusinessArea], [SrcConnectionFriendlyName], [SrcTableSchema], [SrcTableName], [TgtConnectionFriendlyName], [TgtTableSchema], [TgtTableName], [TgtRootContainer], [TgtFileName], [ColumnList], [Query], [PrimaryKeyList], [IncRefreshColumn], [LastRefreshDate], [LastRefreshStatus], [IsActive], [Tag], [RefreshStartDate], [IncRefreshMaxDate], [latest_file_path], [AdditionalFilterConditions], [IsDelete]) VALUES (2, N'EpicorERP', N'STG_OnPremConnection', N'erp', N'CurrExRate', N'TGT_AzureSQLConnection', N'EU_stg', N'CurrExRate', N'raw', NULL, N'Company, SourceCurrCode, EffectiveDate, CurrentRate, SysDate, SysTime, EntryPerson, Reference, TargetCurrCode, RateGrpCode, SysRevID, SysRowID', NULL, N'Company,RateGrpCode,SourceCurrCode,TargetCurrCode,EffectiveDate', NULL, CAST(N'2023-12-14T05:31:48.2600000' AS DateTime2), N'Succeeded', 1, N'RDBMS', CAST(N'2023-12-14T05:30:40.7800000' AS DateTime2), CAST(N'1900-01-01T00:00:00.000' AS DateTime), N'', NULL, NULL)
GO
INSERT [common].[EU_RDBMSControlTable] ([ControlID], [BusinessArea], [SrcConnectionFriendlyName], [SrcTableSchema], [SrcTableName], [TgtConnectionFriendlyName], [TgtTableSchema], [TgtTableName], [TgtRootContainer], [TgtFileName], [ColumnList], [Query], [PrimaryKeyList], [IncRefreshColumn], [LastRefreshDate], [LastRefreshStatus], [IsActive], [Tag], [RefreshStartDate], [IncRefreshMaxDate], [latest_file_path], [AdditionalFilterConditions], [IsDelete]) VALUES (4, N'EpicorERP', N'STG_OnPremConnection', N'erp', N'CustCnt_UD', N'TGT_AzureSQLConnection', N'EU_stg', N'CustCnt_UD', N'raw', NULL, N'*', NULL, NULL, NULL, CAST(N'2023-12-14T05:31:41.9600000' AS DateTime2), N'Succeeded', 1, N'RDBMS', CAST(N'2023-12-14T05:30:40.7800000' AS DateTime2), CAST(N'1900-01-01T00:00:00.000' AS DateTime), N'', NULL, NULL)
GO
INSERT [common].[EU_RDBMSControlTable] ([ControlID], [BusinessArea], [SrcConnectionFriendlyName], [SrcTableSchema], [SrcTableName], [TgtConnectionFriendlyName], [TgtTableSchema], [TgtTableName], [TgtRootContainer], [TgtFileName], [ColumnList], [Query], [PrimaryKeyList], [IncRefreshColumn], [LastRefreshDate], [LastRefreshStatus], [IsActive], [Tag], [RefreshStartDate], [IncRefreshMaxDate], [latest_file_path], [AdditionalFilterConditions], [IsDelete]) VALUES (7, N'EpicorERP', N'STG_OnPremConnection', N'erp', N'CustomerPriceLst', N'TGT_AzureSQLConnection', N'EU_stg', N'CustomerPriceLst', N'raw', NULL, N'Company, CustNum, ShipToNum, SeqNum, ListCode, SysRevID, SysRowID', NULL, N'Company,CustNum,ShipToNum,SeqNum', NULL, CAST(N'2023-12-14T05:31:35.1633333' AS DateTime2), N'Succeeded', 1, N'RDBMS', CAST(N'2023-12-14T05:30:40.7800000' AS DateTime2), CAST(N'1900-01-01T00:00:00.000' AS DateTime), N'', NULL, NULL)
GO
INSERT [common].[EU_RDBMSControlTable] ([ControlID], [BusinessArea], [SrcConnectionFriendlyName], [SrcTableSchema], [SrcTableName], [TgtConnectionFriendlyName], [TgtTableSchema], [TgtTableName], [TgtRootContainer], [TgtFileName], [ColumnList], [Query], [PrimaryKeyList], [IncRefreshColumn], [LastRefreshDate], [LastRefreshStatus], [IsActive], [Tag], [RefreshStartDate], [IncRefreshMaxDate], [latest_file_path], [AdditionalFilterConditions], [IsDelete]) VALUES (10, N'EpicorERP', N'STG_OnPremConnection', N'erp', N'InvcDtl_UD', N'TGT_AzureSQLConnection', N'EU_stg', N'InvcDtl_UD', N'raw', NULL, N'*', NULL, NULL, NULL, CAST(N'2023-12-14T05:32:07.5200000' AS DateTime2), N'Succeeded', 1, N'RDBMS', CAST(N'2023-12-14T05:30:40.7800000' AS DateTime2), CAST(N'1900-01-01T00:00:00.000' AS DateTime), N'', NULL, NULL)
GO
INSERT [common].[EU_RDBMSControlTable] ([ControlID], [BusinessArea], [SrcConnectionFriendlyName], [SrcTableSchema], [SrcTableName], [TgtConnectionFriendlyName], [TgtTableSchema], [TgtTableName], [TgtRootContainer], [TgtFileName], [ColumnList], [Query], [PrimaryKeyList], [IncRefreshColumn], [LastRefreshDate], [LastRefreshStatus], [IsActive], [Tag], [RefreshStartDate], [IncRefreshMaxDate], [latest_file_path], [AdditionalFilterConditions], [IsDelete]) VALUES (22, N'EpicorERP', N'STG_OnPremConnection', N'erp', N'PartWhse_UD', N'TGT_AzureSQLConnection', N'EU_stg', N'PartWhse_UD', N'raw', NULL, N'*', NULL, NULL, NULL, CAST(N'2023-12-14T05:32:00.2833333' AS DateTime2), N'Succeeded', 1, N'RDBMS', CAST(N'2023-12-14T05:30:40.7800000' AS DateTime2), CAST(N'1900-01-01T00:00:00.000' AS DateTime), N'', NULL, NULL)
GO
INSERT [common].[EU_RDBMSControlTable] ([ControlID], [BusinessArea], [SrcConnectionFriendlyName], [SrcTableSchema], [SrcTableName], [TgtConnectionFriendlyName], [TgtTableSchema], [TgtTableName], [TgtRootContainer], [TgtFileName], [ColumnList], [Query], [PrimaryKeyList], [IncRefreshColumn], [LastRefreshDate], [LastRefreshStatus], [IsActive], [Tag], [RefreshStartDate], [IncRefreshMaxDate], [latest_file_path], [AdditionalFilterConditions], [IsDelete]) VALUES (23, N'EpicorERP', N'STG_OnPremConnection', N'erp', N'PLPartBrk', N'TGT_AzureSQLConnection', N'EU_stg', N'PLPartBrk', N'raw', NULL, N'Company, ListCode, PartNum, Quantity, DiscountPercent, UnitPrice, UOMCode, GlobalPLPartBrk, GlobalLock, SysRevID, SysRowID', NULL, N'Company,ListCode,PartNum,UOMCode,Quantity', NULL, CAST(N'2023-12-14T05:31:59.7033333' AS DateTime2), N'Succeeded', 1, N'RDBMS', CAST(N'2023-12-14T05:30:40.7800000' AS DateTime2), CAST(N'1900-01-01T00:00:00.000' AS DateTime), N'', NULL, NULL)
GO
INSERT [common].[EU_RDBMSControlTable] ([ControlID], [BusinessArea], [SrcConnectionFriendlyName], [SrcTableSchema], [SrcTableName], [TgtConnectionFriendlyName], [TgtTableSchema], [TgtTableName], [TgtRootContainer], [TgtFileName], [ColumnList], [Query], [PrimaryKeyList], [IncRefreshColumn], [LastRefreshDate], [LastRefreshStatus], [IsActive], [Tag], [RefreshStartDate], [IncRefreshMaxDate], [latest_file_path], [AdditionalFilterConditions], [IsDelete]) VALUES (3, N'EpicorERP', N'STG_OnPremConnection', N'erp', N'CustCnt', N'TGT_AzureSQLConnection', N'EU_stg', N'CustCnt', N'raw', NULL, N'Company, CustNum, ShipToNum, ConNum, Name, Func, FaxNum, PhoneNum, SpecialAddress, Address1, Address2, Address3, City, State, Zip, Country, CorpName, EMailAddress, CountryNum, SFPortalPassword, SFUser, PortalUser, RoleCode, CellPhoneNum, PagerNum, HomeNum, AltNum, ContactTitle, ReportsTo, Comment, NoContact, CreateDate, CreateDcdUserID, ChangeDate, ChangeDcdUserID, Inactive, FirstName, MiddleName, LastName, Prefix, Suffix, Initials, ExternalID, GlobalLock, ShowInputPrice, ChangeTime, ChangedBy, MasterCustNum, MasterShipToNum, MasterConNum, PerConID, SyncNameToPerCon, SyncAddressToPerCon, SyncPhoneToPerCon, SyncEmailToPerCon, SyncLinksToPerCon, WebSite, IM, Twitter, LinkedIn, FaceBook, WebLink1, WebLink2, WebLink3, WebLink4, WebLink5, PerConAddress, SysRevID, SysRowID, SyncToExternalCRM, ExternalCRMCustomerID, ExternalCRMContactID', NULL, N'Company,CustNum,ShipToNum,ConNum', N'ChangeDate', CAST(N'2023-12-14T05:31:41.9333333' AS DateTime2), N'Succeeded', 1, N'RDBMS', CAST(N'2023-12-14T05:30:40.7800000' AS DateTime2), CAST(N'2023-12-13T00:00:00.000' AS DateTime), N'', NULL, 1)
GO
INSERT [common].[EU_RDBMSControlTable] ([ControlID], [BusinessArea], [SrcConnectionFriendlyName], [SrcTableSchema], [SrcTableName], [TgtConnectionFriendlyName], [TgtTableSchema], [TgtTableName], [TgtRootContainer], [TgtFileName], [ColumnList], [Query], [PrimaryKeyList], [IncRefreshColumn], [LastRefreshDate], [LastRefreshStatus], [IsActive], [Tag], [RefreshStartDate], [IncRefreshMaxDate], [latest_file_path], [AdditionalFilterConditions], [IsDelete]) VALUES (6, N'EpicorERP', N'STG_OnPremConnection', N'erp', N'Customer_UD', N'TGT_AzureSQLConnection', N'EU_stg', N'Customer_UD', N'raw', NULL, N'*', NULL, NULL, NULL, CAST(N'2023-12-14T05:33:42.0166667' AS DateTime2), N'Succeeded', 1, N'RDBMS', CAST(N'2023-12-14T05:30:40.7800000' AS DateTime2), CAST(N'1900-01-01T00:00:00.000' AS DateTime), N'', NULL, NULL)
GO
INSERT [common].[EU_RDBMSControlTable] ([ControlID], [BusinessArea], [SrcConnectionFriendlyName], [SrcTableSchema], [SrcTableName], [TgtConnectionFriendlyName], [TgtTableSchema], [TgtTableName], [TgtRootContainer], [TgtFileName], [ColumnList], [Query], [PrimaryKeyList], [IncRefreshColumn], [LastRefreshDate], [LastRefreshStatus], [IsActive], [Tag], [RefreshStartDate], [IncRefreshMaxDate], [latest_file_path], [AdditionalFilterConditions], [IsDelete]) VALUES (8, N'EpicorERP', N'STG_OnPremConnection', N'erp', N'CustXPrt', N'TGT_AzureSQLConnection', N'EU_stg', N'CustXPrt', N'raw', NULL, N'Company, PartNum, CustNum, XPartNum, XRevisionNum, PartDescription, SourceDBRecid, BasePartNum, BaseRevisionNum, ChangedBy, ChangeDate, ChangeTime, SNMask, SNMaskExample, SNMaskSuffix, SNMaskPrefix, SNLastUsedSeq, SNOverride, GlobalCustXPrt, GlobalLock, WIApplication, SysRevID, SysRowID, EDIContainerType, ProductionPartNum, ProductionPartNumIsValid, ServicePartNum, ServicePartNumIsValid', NULL, N'Company,PartNum,CustNum,XPartNum,SysRowID', N'ChangeDate', CAST(N'2023-12-14T05:32:53.5900000' AS DateTime2), N'Succeeded', 1, N'RDBMS', CAST(N'2023-12-14T05:30:40.7800000' AS DateTime2), CAST(N'2023-12-13T00:00:00.000' AS DateTime), N'', NULL, 1)
GO
INSERT [common].[EU_RDBMSControlTable] ([ControlID], [BusinessArea], [SrcConnectionFriendlyName], [SrcTableSchema], [SrcTableName], [TgtConnectionFriendlyName], [TgtTableSchema], [TgtTableName], [TgtRootContainer], [TgtFileName], [ColumnList], [Query], [PrimaryKeyList], [IncRefreshColumn], [LastRefreshDate], [LastRefreshStatus], [IsActive], [Tag], [RefreshStartDate], [IncRefreshMaxDate], [latest_file_path], [AdditionalFilterConditions], [IsDelete]) VALUES (12, N'EpicorERP', N'STG_OnPremConnection', N'erp', N'OrderDtl', N'TGT_AzureSQLConnection', N'EU_stg', N'OrderDtl', N'raw', NULL, N'VoidLine, OpenLine, Company, OrderNum, OrderLine, LineType, PartNum, LineDesc, Reference, IUM, RevisionNum, POLine, Commissionable, DiscountPercent, UnitPrice, DocUnitPrice, OrderQty, Discount, DocDiscount, RequestDate, ProdCode, XPartNum, XRevisionNum, PricePerCode, OrderComment, ShipComment, InvoiceComment, PickListComment, TaxCatID, AdvanceBillBal, DocAdvanceBillBal, QuoteNum, QuoteLine, TMBilling, OrigWhyNoTax, NeedByDate, CustNum, Rework, RMANum, RMALine, ProjectID, ContractNum, ContractCode, BasePartNum, Warranty, WarrantyCode, MaterialDuration, LaborDuration, MiscDuration, MaterialMod, LaborMod, WarrantyComment, Onsite, MatCovered, LabCovered, MiscCovered, SalesUM, SellingFactor, SellingQuantity, SalesCatID, ShipLineComplete, CumeQty, CumeDate, MktgCampaignID, MktgEvntSeq, LockQty, Linked, ICPONum, ICPOLine, ExtCompany, LastConfigDate, LastConfigTime, LastConfigUserID, ConfigUnitPrice, ConfigBaseUnitPrice, PriceListCode, BreakListCode, PricingQty, LockPrice, ListPrice, DocListPrice, OrdBasedPrice, DocOrdBasedPrice, PriceGroupCode, OverridePriceList, BaseRevisionNum, PricingValue, DisplaySeq, KitParentLine, KitAllowUpdate, KitShipComplete, KitBackFlush, KitPrintCompsPS, KitPrintCompsInv, KitPricing, KitQtyPer, SellingFactorDirection, RepRate1, RepRate2, RepRate3, RepRate4, RepRate5, RepSplit1, RepSplit2, RepSplit3, RepSplit4, RepSplit5, DemandContractLine, CreateNewJob, DoNotShipBeforeDate, GetDtls, DoNotShipAfterDate, SchedJob, RelJob, EnableCreateNewJob, EnableGetDtls, EnableSchedJob, EnableRelJob, CounterSaleWarehouse, CounterSaleBinNum, CounterSaleLotNum, CounterSaleDimCode, DemandDtlRejected, KitFlag, KitsLoaded, DemandContractNum, DemandHeadSeq, DemandDtlSeq, ChangedBy, ChangeDate, ChangeTime, ReverseCharge, TotalReleases, Rpt1UnitPrice, Rpt2UnitPrice, Rpt3UnitPrice, Rpt1Discount, Rpt2Discount, Rpt3Discount, Rpt1AdvanceBillBal, Rpt2AdvanceBillBal, Rpt3AdvanceBillBal, Rpt1ListPrice, Rpt2ListPrice, Rpt3ListPrice, Rpt1OrdBasedPrice, Rpt2OrdBasedPrice, Rpt3OrdBasedPrice, ExtPriceDtl, DocExtPriceDtl, Rpt1ExtPriceDtl, Rpt2ExtPriceDtl, Rpt3ExtPriceDtl, LineStatus, InUnitPrice, DocInUnitPrice, InDiscount, DocInDiscount, InListPrice, DocInListPrice, InOrdBasedPrice, DocInOrdBasedPrice, Rpt1InUnitPrice, Rpt2InUnitPrice, Rpt3InUnitPrice, Rpt1InDiscount, Rpt2InDiscount, Rpt3InDiscount, Rpt1InListPrice, Rpt2InListPrice, Rpt3InListPrice, Rpt1InOrdBasedPrice, Rpt2InOrdBasedPrice, Rpt3InOrdBasedPrice, InExtPriceDtl, DocInExtPriceDtl, Rpt1InExtPriceDtl, Rpt2InExtPriceDtl, Rpt3InExtPriceDtl, OldOurOpenQty, OldSellingOpenQty, OldOpenValue, OldProdCode, PrevSellQty, PrevPartNum, PrevXPartNum, KitCompOrigSeq, KitCompOrigPart, SmartStringProcessed, SmartString, RenewalNbr, DiscBreakListCode, DiscListPrice, LockDisc, OverrideDiscPriceList, GroupSeq, ECCOrderNum, ECCOrderLine, DupOnJobCrt, UndersPct, Overs, Unders, OversUnitPrice, PlanUserID, PlanGUID, MOMsourceType, MOMsourceEst, DefaultOversPricing, ECCPlant, ECCQuoteNum, ECCQuoteLine, SysRevID, SysRowID, MfgJobType, ProFormaInvComment, CreateJob, ContractID, LinkToContract, DocInAdvanceBillBal, InAdvanceBillBal, Rpt1InAdvanceBillBal, Rpt2InAdvanceBillBal, Rpt3InAdvanceBillBal, PCLinkRemoved, CommodityCode, MSRP, DocMSRP, Rpt1MSRP, Rpt2MSRP, Rpt3MSRP, EndCustomerPrice, DocEndCustomerPrice, Rpt1EndCustomerPrice, Rpt2EndCustomerPrice, Rpt3EndCustomerPrice, PromotionalPrice, DocPromotionalPrice, Rpt1PromotionalPrice, Rpt2PromotionalPrice, Rpt3PromotionalPrice, OrderLineStatusCode, AttributeSetID, KBConfigProdID, KBOriginalConfigProdID', NULL, N'Company,OrderLine,OrderNum', N'ChangeDate', CAST(N'2023-12-14T05:33:07.7633333' AS DateTime2), N'Succeeded', 1, N'RDBMS', CAST(N'2023-12-14T05:30:40.7800000' AS DateTime2), CAST(N'2023-12-13T00:00:00.000' AS DateTime), N'', NULL, 1)
GO
INSERT [common].[EU_RDBMSControlTable] ([ControlID], [BusinessArea], [SrcConnectionFriendlyName], [SrcTableSchema], [SrcTableName], [TgtConnectionFriendlyName], [TgtTableSchema], [TgtTableName], [TgtRootContainer], [TgtFileName], [ColumnList], [Query], [PrimaryKeyList], [IncRefreshColumn], [LastRefreshDate], [LastRefreshStatus], [IsActive], [Tag], [RefreshStartDate], [IncRefreshMaxDate], [latest_file_path], [AdditionalFilterConditions], [IsDelete]) VALUES (13, N'EpicorERP', N'STG_OnPremConnection', N'erp', N'OrderDtl_UD', N'TGT_AzureSQLConnection', N'EU_stg', N'OrderDtl_UD', N'raw', NULL, N'*', NULL, NULL, NULL, CAST(N'2023-12-14T05:35:59.2033333' AS DateTime2), N'Succeeded', 1, N'RDBMS', CAST(N'2023-12-14T05:30:40.7800000' AS DateTime2), CAST(N'1900-01-01T00:00:00.000' AS DateTime), N'', NULL, NULL)
GO
INSERT [common].[EU_RDBMSControlTable] ([ControlID], [BusinessArea], [SrcConnectionFriendlyName], [SrcTableSchema], [SrcTableName], [TgtConnectionFriendlyName], [TgtTableSchema], [TgtTableName], [TgtRootContainer], [TgtFileName], [ColumnList], [Query], [PrimaryKeyList], [IncRefreshColumn], [LastRefreshDate], [LastRefreshStatus], [IsActive], [Tag], [RefreshStartDate], [IncRefreshMaxDate], [latest_file_path], [AdditionalFilterConditions], [IsDelete]) VALUES (33, N'EpicorERP', N'STG_OnPremConnection', N'dbo', N'FLEX_SalesAnalysisInvoiceSTGTotals', N'TGT_AzureSQLConnection', N'EU_STG', N'FLEX_SalesAnalysisInvoiceSTGTotals', N'raw', NULL, N'*', NULL, NULL, NULL, CAST(N'2023-11-27T06:51:28.1500000' AS DateTime2), N'Succeeded', 0, N'RDBMS', CAST(N'2023-11-27T06:50:31.0433333' AS DateTime2), CAST(N'1900-01-01T00:00:00.000' AS DateTime), N'', NULL, NULL)
GO
INSERT [common].[EU_RDBMSControlTable] ([ControlID], [BusinessArea], [SrcConnectionFriendlyName], [SrcTableSchema], [SrcTableName], [TgtConnectionFriendlyName], [TgtTableSchema], [TgtTableName], [TgtRootContainer], [TgtFileName], [ColumnList], [Query], [PrimaryKeyList], [IncRefreshColumn], [LastRefreshDate], [LastRefreshStatus], [IsActive], [Tag], [RefreshStartDate], [IncRefreshMaxDate], [latest_file_path], [AdditionalFilterConditions], [IsDelete]) VALUES (15, N'EpicorERP', N'STG_OnPremConnection', N'erp', N'OrderHed_UD', N'TGT_AzureSQLConnection', N'EU_stg', N'OrderHed_UD', N'raw', NULL, N'*', NULL, NULL, NULL, CAST(N'2023-12-14T05:33:19.0700000' AS DateTime2), N'Succeeded', 1, N'RDBMS', CAST(N'2023-12-14T05:30:40.7800000' AS DateTime2), CAST(N'1900-01-01T00:00:00.000' AS DateTime), N'', NULL, NULL)
GO
INSERT [common].[EU_RDBMSControlTable] ([ControlID], [BusinessArea], [SrcConnectionFriendlyName], [SrcTableSchema], [SrcTableName], [TgtConnectionFriendlyName], [TgtTableSchema], [TgtTableName], [TgtRootContainer], [TgtFileName], [ColumnList], [Query], [PrimaryKeyList], [IncRefreshColumn], [LastRefreshDate], [LastRefreshStatus], [IsActive], [Tag], [RefreshStartDate], [IncRefreshMaxDate], [latest_file_path], [AdditionalFilterConditions], [IsDelete]) VALUES (9, N'EpicorERP', N'STG_OnPremConnection', N'erp', N'InvcDtl', N'TGT_AzureSQLConnection', N'EU_stg', N'InvcDtl', N'raw', NULL, N'Company, InvoiceNum, InvoiceLine, LineType, ContractNum, XPartNum, XRevisionNum, PartNum, LineDesc, IUM, RevisionNum, POLine, TaxExempt, TaxCatID, Commissionable, DiscountPercent, UnitPrice, DocUnitPrice, PricePerCode, OurOrderQty, ExtPrice, DocExtPrice, Discount, DocDiscount, TotalMiscChrg, DocTotalMiscChrg, ProdCode, OurShipQty, PackNum, PackLine, OrderNum, OrderLine, OrderRelNum, ShipToCustNum, ShipToNum, ShipDate, ShipViaCode, AdvanceBillCredit, DocAdvanceBillCredit, CustNum, InvoiceComment, ShpConNum, MtlUnitCost, LbrUnitCost, BurUnitCost, SubUnitCost, MtlBurUnitCost, COSPostingReqd, COSPosted, ContractCode, CallNum, CallCode, RMANum, RMALine, SalesCatID, FiscalYear, FiscalPeriod, JournalCode, JournalNum, SellingOrderQty, SellingShipQty, SalesUM, SellingFactor, ProjectID, MilestoneID, ListPrice, DocListPrice, OrdBasedPrice, DocOrdBasedPrice, AdvGainLoss, SellingFactorDirection, RepRate1, RepRate2, RepRate3, RepRate4, RepRate5, RepSplit1, RepSplit2, RepSplit3, RepSplit4, RepSplit5, BTCustNum, JCMtlUnitCost, JCLbrUnitCost, JCBurUnitCost, JCSubUnitCost, JCMtlBurUnitCost, ChangedBy, ChangeDate, ChangeTime, RevChargeMethod, OverrideReverseCharge, RevChargeApplied, TaxConnectCalc, GetDfltTaxIds, Rpt1AdvanceBillCredit, Rpt2AdvanceBillCredit, Rpt3AdvanceBillCredit, Rpt1Discount, Rpt2Discount, Rpt3Discount, Rpt1ExtPrice, Rpt2ExtPrice, Rpt3ExtPrice, Rpt1ListPrice, Rpt2ListPrice, Rpt3ListPrice, Rpt1OrdBasedPrice, Rpt2OrdBasedPrice, Rpt3OrdBasedPrice, Rpt1TotalMiscChrg, Rpt2TotalMiscChrg, Rpt3TotalMiscChrg, Rpt1UnitPrice, Rpt2UnitPrice, Rpt3UnitPrice, Rpt1AdvGainLoss, Rpt2AdvGainLoss, Rpt3AdvGainLoss, FiscalYearSuffix, FiscalCalendarID, TaxRegionCode, UseOTS, OTSName, OTSAddress1, OTSAddress2, OTSAddress3, OTSCity, OTSState, OTSZIP, OTSResaleID, OTSTaxRegionCode, OTSContact, OTSFaxNum, OTSPhoneNum, OTSCountryNum, Plant, WarehouseCode, CallLine, DropShipPackLine, DropShipPackSlip, FinChargeCode, ABTUID, InUnitPrice, DocInUnitPrice, InExtPrice, DocInExtPrice, InDiscount, DocInDiscount, InTotalMiscChrg, DocInTotalMiscChrg, InListPrice, DocInListPrice, InOrdBasedPrice, DocInOrdBasedPrice, Rpt1InDiscount, Rpt2InDiscount, Rpt3InDiscount, Rpt1InExtPrice, Rpt2InExtPrice, Rpt3InExtPrice, Rpt1InListPrice, Rpt2InListPrice, Rpt3InListPrice, Rpt1InOrdBasedPrice, Rpt2InOrdBasedPrice, Rpt3InOrdBasedPrice, Rpt1InTotalMiscChrg, Rpt2InTotalMiscChrg, Rpt3InTotalMiscChrg, Rpt1InUnitPrice, Rpt2InUnitPrice, Rpt3InUnitPrice, CorrectionDtl, AssetNum, DisposalNum, PBLineType, InvoiceLineRef, InvoiceRef, LotNum, PBInvoiceLine, RAID, RADtlID, DeferredRev, RACode, DefRevStart, ChargeDefRev, RenewalNbr, SysRevID, SysRowID, DefRevPosted, LinkedInvcUnitPrice, DspWithholdAmt, DocDspWithholdAmt, Rpt1DspWithholdAmt, Rpt2DspWithholdAmt, Rpt3DspWithholdAmt, LinkedCurrencyCode, PhaseID, PEBOEHeadNum, MXSellingShipQty, MXUnitPrice, DocMXUnitPrice, Rpt1MXUnitPrice, Rpt2MXUnitPrice, Rpt3MXUnitPrice, CustCostCenter, DEIsServices, DEIsSecurityFinancialDerivative, DEInternationalSecuritiesID, DEIsInvestment, DEPayStatCode, DefRevEndDate, EntityUseCode, Reclassified, PartiallyDefer, DeferredPercent, Reclass, DeferredOnly, ReclassCodeID, ReclassReasonCode, ReclassComments, DeferredRevAmt, DocDeferredRevAmt, Rpt1DeferredRevAmt, Rpt2DeferredRevAmt, Rpt3DeferredRevAmt, ChargeReclass, DEDenomination, DropShipPONum, DocInAdvanceBillCredit, InAdvanceBillCredit, Rpt1InAdvanceBillCredit, Rpt2InAdvanceBillCredit, Rpt3InAdvanceBillCredit, MYIndustryCode, DockingStation, ConsolidateLines, MXCustomsDuty, CommodityCode, MXProdServCode, QuoteNum, QuoteLine, EpicorFSA, MXCustomsUMFrom, PEDetrGoodServiceCode, PETaxExempt, CColOrderNum, CColOrderLine, CColOrderRel, CColInvoiceLineRef, CColPackNum, CColPackLine, CColDropShipPackSlip, CColDropShipPackSlipLine, CColShipToCustID, CColShipToNum, AttributeSetID, AttributeSetDescription, AttributeSetShortDescription, ExemptReasonCode, JobNum, ServiceSource, OTSTaxValidationStatus, OTSTaxValidationDate, AssemblySeq, MtlSeq, OprSeq, LaborType, BillableLaborHrs, BillableLaborRate, ServiceSourceType', NULL, N'Company,InvoiceLine,InvoiceNum', N'ChangeDate', CAST(N'2023-12-14T05:33:39.2233333' AS DateTime2), N'Succeeded', 1, N'RDBMS', CAST(N'2023-12-14T05:30:40.7800000' AS DateTime2), CAST(N'2023-12-13T00:00:00.000' AS DateTime), N'', NULL, 1)
GO
INSERT [common].[EU_RDBMSControlTable] ([ControlID], [BusinessArea], [SrcConnectionFriendlyName], [SrcTableSchema], [SrcTableName], [TgtConnectionFriendlyName], [TgtTableSchema], [TgtTableName], [TgtRootContainer], [TgtFileName], [ColumnList], [Query], [PrimaryKeyList], [IncRefreshColumn], [LastRefreshDate], [LastRefreshStatus], [IsActive], [Tag], [RefreshStartDate], [IncRefreshMaxDate], [latest_file_path], [AdditionalFilterConditions], [IsDelete]) VALUES (17, N'EpicorERP', N'STG_OnPremConnection', N'erp', N'Part_UD', N'TGT_AzureSQLConnection', N'EU_stg', N'Part_UD', N'raw', NULL, N'*', NULL, NULL, NULL, CAST(N'2023-12-14T05:33:22.5533333' AS DateTime2), N'Succeeded', 1, N'RDBMS', CAST(N'2023-12-14T05:30:40.7800000' AS DateTime2), CAST(N'1900-01-01T00:00:00.000' AS DateTime), N'', NULL, NULL)
GO
INSERT [common].[EU_RDBMSControlTable] ([ControlID], [BusinessArea], [SrcConnectionFriendlyName], [SrcTableSchema], [SrcTableName], [TgtConnectionFriendlyName], [TgtTableSchema], [TgtTableName], [TgtRootContainer], [TgtFileName], [ColumnList], [Query], [PrimaryKeyList], [IncRefreshColumn], [LastRefreshDate], [LastRefreshStatus], [IsActive], [Tag], [RefreshStartDate], [IncRefreshMaxDate], [latest_file_path], [AdditionalFilterConditions], [IsDelete]) VALUES (18, N'EpicorERP', N'STG_OnPremConnection', N'erp', N'PartBin', N'TGT_AzureSQLConnection', N'EU_stg', N'PartBin', N'raw', NULL, N'Company, PartNum, WarehouseCode, BinNum, OnhandQty, LotNum, DimCode, AllocatedQty, SalesAllocatedQty, SalesPickingQty, SalesPickedQty, JobAllocatedQty, JobPickingQty, JobPickedQty, TFOrdAllocatedQty, TFOrdPickingQty, TFOrdPickedQty, ShippingQty, PackedQty, SysRevID, SysRowID, PCID, SendToFSA, AttributeSetID, CountedDate, QtyPerPiece, RevisionNum', NULL, N'AttributeSetID,BinNum,Company,DimCode,LotNum,PartNum,PCID,WarehouseCode', NULL, CAST(N'2023-12-14T05:32:45.2066667' AS DateTime2), N'Succeeded', 1, N'RDBMS', CAST(N'2023-12-14T05:30:40.7800000' AS DateTime2), CAST(N'1900-01-01T00:00:00.000' AS DateTime), N'', NULL, 1)
GO
INSERT [common].[EU_RDBMSControlTable] ([ControlID], [BusinessArea], [SrcConnectionFriendlyName], [SrcTableSchema], [SrcTableName], [TgtConnectionFriendlyName], [TgtTableSchema], [TgtTableName], [TgtRootContainer], [TgtFileName], [ColumnList], [Query], [PrimaryKeyList], [IncRefreshColumn], [LastRefreshDate], [LastRefreshStatus], [IsActive], [Tag], [RefreshStartDate], [IncRefreshMaxDate], [latest_file_path], [AdditionalFilterConditions], [IsDelete]) VALUES (19, N'EpicorERP', N'STG_OnPremConnection', N'erp', N'PartCost', N'TGT_AzureSQLConnection', N'EU_stg', N'PartCost', N'raw', NULL, N'Company, PartNum, CostID, AvgLaborCost, AvgBurdenCost, AvgMaterialCost, AvgSubContCost, AvgMtlBurCost, StdLaborCost, StdBurdenCost, StdMaterialCost, StdSubContCost, StdMtlBurCost, LastLaborCost, LastBurdenCost, LastMaterialCost, LastSubContCost, LastMtlBurCost, FIFOAvgLaborCost, FIFOAvgBurdenCost, FIFOAvgMaterialCost, FIFOAvgSubContCost, FIFOAvgMtlBurCost, SysRevID, SysRowID, TotalQtyAvg, ExternalMESSyncRequired, ExternalMESLastSync', NULL, N'Company,CostID,PartNum', NULL, CAST(N'2023-12-14T05:34:56.2433333' AS DateTime2), N'Succeeded', 1, N'RDBMS', CAST(N'2023-12-14T05:30:40.7800000' AS DateTime2), CAST(N'1900-01-01T00:00:00.000' AS DateTime), N'', NULL, NULL)
GO
INSERT [common].[EU_RDBMSControlTable] ([ControlID], [BusinessArea], [SrcConnectionFriendlyName], [SrcTableSchema], [SrcTableName], [TgtConnectionFriendlyName], [TgtTableSchema], [TgtTableName], [TgtRootContainer], [TgtFileName], [ColumnList], [Query], [PrimaryKeyList], [IncRefreshColumn], [LastRefreshDate], [LastRefreshStatus], [IsActive], [Tag], [RefreshStartDate], [IncRefreshMaxDate], [latest_file_path], [AdditionalFilterConditions], [IsDelete]) VALUES (21, N'EpicorERP', N'STG_OnPremConnection', N'erp', N'PartWhse', N'TGT_AzureSQLConnection', N'EU_stg', N'PartWhse', N'raw', NULL, N'Company, PartNum, WarehouseCode, DemandQty, ReservedQty, AllocatedQty, PickingQty, PickedQty, CountedDate, OnHandQty, NonNettableQty, BuyToOrderQty, SalesDemandQty, SalesReservedQty, SalesAllocatedQty, SalesPickingQty, SalesPickedQty, JobDemandQty, JobReservedQty, JobAllocatedQty, JobPickingQty, JobPickedQty, UnfirmJobDemandQty, TFOrdDemandQty, TFOrdReservedQty, TFOrdAllocatedQty, TFOrdPickingQty, TFOrdPickedQty, KBCode, MinimumQty, MaximumQty, SafetyQty, KBPONUM, KBPOLine, KBWarehouseCode, KBBinNum, KBPlant, KBQty, PcntTolerance, CalcPcnt, CalcQty, CalcValue, QtyAdjTolerance, CalcQtyAdj, MinAbc, SystemAbc, ManualABC, LastCCDate, OvrrideCountFreq, CountFreq, QtyTolerance, ValueTolerance, SysRevID, SysRowID', NULL, N'Company,PartNum,WarehouseCode', N'LastCCDate', CAST(N'2023-12-14T05:34:01.1933333' AS DateTime2), N'Succeeded', 1, N'RDBMS', CAST(N'2023-12-14T05:30:40.7800000' AS DateTime2), CAST(N'2023-12-13T00:00:00.000' AS DateTime), N'', NULL, 0)
GO
INSERT [common].[EU_RDBMSControlTable] ([ControlID], [BusinessArea], [SrcConnectionFriendlyName], [SrcTableSchema], [SrcTableName], [TgtConnectionFriendlyName], [TgtTableSchema], [TgtTableName], [TgtRootContainer], [TgtFileName], [ColumnList], [Query], [PrimaryKeyList], [IncRefreshColumn], [LastRefreshDate], [LastRefreshStatus], [IsActive], [Tag], [RefreshStartDate], [IncRefreshMaxDate], [latest_file_path], [AdditionalFilterConditions], [IsDelete]) VALUES (11, N'EpicorERP', N'STG_OnPremConnection', N'erp', N'Invchead', N'TGT_AzureSQLConnection', N'EU_stg', N'Invchead', N'raw', NULL, N'Company, OpenInvoice, ClosedDate, CreditMemo, UnappliedCash, CheckRef, InvoiceSuffix, GroupID, Posted, InvoiceNum, InvoiceType, DeferredRevenue, OrderNum, CustNum, PONum, EntryPerson, FOB, TermsCode, InvoiceDate, DueDate, FiscalYear, FiscalPeriod, GLPosted, InvoiceComment, InvoiceAmt, DocInvoiceAmt, InvoiceBal, DocInvoiceBal, UnpostedBal, DocUnpostedBal, DepositCredit, DocDepositCredit, SalesRepList, InvoiceRef, RefCancelled, RefCancelledBy, StartUp, PayDates, PayAmounts, DocPayAmounts, PayDiscDate, PayDiscAmt, DocPayDiscAmt, BillConNum, InvoiceHeld, CurrencyCode, ExchangeRate, LockRate, JournalNum, JournalCode, LineType, RMANum, Plant, CardMemberName, CardNumber, CardType, ExpirationMonth, ExpirationYear, CardID, CardmemberReference, LegalNumber, ExternalID, XRefInvoiceNum, DepGainLoss, DNComments, DNCustNbr, DebitNote, SoldToCustNum, Consolidated, BillToInvoiceAddress, SoldToInvoiceAddress, ProcessCard, RepComm1, RepComm2, RepComm3, RepComm4, RepComm5, RepRate1, RepRate2, RepRate3, RepRate4, RepRate5, RepSales1, RepSales2, RepSales3, RepSales4, RepSales5, RepSplit1, RepSplit2, RepSplit3, RepSplit4, RepSplit5, CMType, CCStreetAddr, CCZip, ChangedBy, ChangeDate, ChangeTime, ReadyToCalc, AutoPrintReady, EDIReady, RecalcBeforePost, Rounding, DocRounding, Rpt1DepositCredit, Rpt2DepositCredit, Rpt3DepositCredit, Rpt1InvoiceAmt, Rpt2InvoiceAmt, Rpt3InvoiceAmt, Rpt1InvoiceBal, Rpt2InvoiceBal, Rpt3InvoiceBal, Rpt1PayAmounts, Rpt2PayAmounts, Rpt3PayAmounts, Rpt1PayDiscAmt, Rpt2PayDiscAmt, Rpt3PayDiscAmt, Rpt1Rounding, Rpt2Rounding, Rpt3Rounding, Rpt1UnpostedBal, Rpt2UnpostedBal, Rpt3UnpostedBal, RateGrpCode, DocDepApplied, Rpt1DepGainLoss, Rpt2DepGainLoss, Rpt3DepGainLoss, ApplyDate, FiscalYearSuffix, FiscalCalendarID, TaxPoint, TaxRateDate, TaxRegionCode, LastChrgCalcDate, TranDocTypeID, TotFinChrg, DocumentPrinted, PayDiscDays, PayDiscPer, BlockedFinChrg, BlockedFinChrgReason, WithholdAmt, DocWithholdAmt, Rpt1WithholdAmt, Rpt2WithholdAmt, Rpt3WithholdAmt, BlockedRemLetters, PayDiscPartPay, BlockedRemLettersReason, ShipDate, CurrRateDate, PIPayment, PMUID, UseAltBillTo, InPrice, CorrectionInv, TaxRateGrpCode, LockTaxRate, SEBankRef, GUITaxTypeCode, GUIFormatCode, GUIDeductCode, ReversalDocAmount, OrigDueDate, HeadNum, ARLOCID, ContractRef, OurBank, ContractDate, PBProjectID, DepositAmt, GUIExportBillNumber, DocDepositAmt, GUIDateOfExport, Rpt1DepositAmt, GUIExportType, Rpt2DepositAmt, GUIExportMark, Rpt3DepositAmt, GUIExportBillType, DepUnallocatedAmt, SummarizationDate, DocDepUnallocatedAmt, BillingDate, Rpt1DepUnallocatedAmt, BillingNumber, Rpt2DepUnallocatedAmt, ReadyToBill, Rpt3DepUnallocatedAmt, OvrDefTaxDate, XRefContractNum, XRefContractDate, MainSite, SiteCode, BranchID, CustAgentName, CustAgentTaxRegNo, ExportType, ExportReportNo, RealEstateNo, Excluded, Deferred, CycleCode, Duration, EndDate, MaxValueAmt, DocMaxValueAmt, Rpt1MaxValueAmt, Rpt2MaxValueAmt, Rpt3MaxValueAmt, HoldInvoice, CopyLatestInvoice, OverrideEndDate, CycleInactive, RecurSource, InstanceNum, RecurBalance, DocRecurBalance, Rpt1RecurBalance, Rpt2RecurBalance, Rpt3RecurBalance, LastDate, RecurringState, IsRecurring, InvoiceNumList, IsAddedToGTI, SysRevID, SysRowID, CHISRCodeLine, CMReason, THIsImmatAdjustment, AGAuthorizationCode, AGAuthorizationDate, AGUseGoodDefaultMark, AGDocumentLetter, AGInvoicingPoint, AGLegalNumber, AGPrintingControlType, RevisionDate, RevisionNum, TWDeclareYear, TWDeclarePeriod, TWGenerationType, TWGUIGroup, TWPeriodPrefix, InvInCollections, CollectionsCust, CounterARForm, PostedRecog, CNConfirmDate, MXSATSeal, MXSerie, MXTaxRcptType, MXFiscalFolio, MXTotalPayments, MXFolio, MXCertifiedTimestamp, MXSATCertificateSN, MXDigitalSeal, MXPostedTimeStamp, MXCertificate, MXApprovalYear, MXCBB, MXApprovalNum, MXOriginalStringTFD, MXPaymentNum, MXPaidAs, MXCertificateSN, MXOriginalAmount, MXAccountNumber, MXOriginalDate, MXOriginalSeries, MXOriginalFolio, MXTaxRegime, MXOriginalString, MXPaymentName, EInvoice, EInvStatus, EInvTimestamp, EInvUpdatedBy, EInvException, WithTaxConfirm, UseAltBillToID, MXCancelledDate, Overpaid, OrdExchangeRate, PEAPPayNum, PEBankNumber, PECharges, PECommissions, PEDetTaxAmt, PEDetTaxCurrencyCode, PEDischargeAmt, PEDischargeDate, PEInterest, PENoPayPenalty, PESUNATDepAmt, PESUNATDepDate, PESUNATDepNum, PEBOEPosted, DocPEInterest, DocPECommissions, DocPECharges, DocPENoPayPenalty, DocPEDischargeAmt, DocPEDetTaxAmt, Rpt1PEInterest, Rpt1PECommissions, Rpt1PECharges, Rpt1PENoPayPenalty, Rpt1PEDischargeAmt, Rpt2PEInterest, Rpt2PECommissions, Rpt2PECharges, Rpt2PENoPayPenalty, Rpt2PEDischargeAmt, Rpt3PEInterest, Rpt3PECommissions, Rpt3PECharges, Rpt3PENoPayPenalty, Rpt3PEDischargeAmt, OurSupplierCode, PEGuaranteeName, PEGuaranteeAddress1, PEGuaranteeAddress2, PEGuaranteeAddress3, PEGuaranteeCity, PEGuaranteeState, PEGuaranteeZip, PEGuaranteeCountry, PEGuaranteeTaxID, PEGuaranteePhoneNum, PEBOEStatus, PEBOEIsMultiGen, PERefDocID, PEReasonCode, PEReasonDesc, TWGUIRegNumSeller, TWGUIRegNumBuyer, TWGUIExportDocumentName, TWGUIExportRemarks, TWGUIExportVerification, PEDebitNoteReasonCode, PEDebitNote, MXPartPmt, CNTaxInvoiceType, MXExportOperationType, MXExportCustDocCode, MXExportCertOriginNum, MXExportConfNum, MXExportCertOrigin, MXIncoterm, AGDocConcept, EInvRefNum, ExportDocRefNum, ExportDocDate, INTaxTransactionID, MXMovingReasonFlag, MXMovingReason, MXNumRegIdTrib, MXResidenCountryNum, MXPurchaseType, MXConfirmationCode, MXExternalCode, ServiceInvoice, MXDomesticTransfer, MXCancellationMode, INShippingPortCode, INExportProcedure, CreatedOn, DigitalSignature, SignedOn, SignedBy, FirstPrintDate, DocCopyNum, DepositBalance, DocDepositBalance, Rpt1DepositBalance, Rpt2DepositBalance, Rpt3DepositBalance, QuoteNum, HDCaseNum, CreditOverride, CreditOverrideDate, CreditOverrideUserID, CreditHold, PEXMLType, COCreditMemoReasonCode, CODebitMemoReasonCode, COReasonDesc, CODebitNote, PEDetractionTranNum, PEProductCode, PECollectionGroupID, PECaptionCode, PECaption, PERefDocumentType, PERefDocumentNumber, PEDetrGoodServiceCode, PERefDocumentType2, PERefDocumentType3, PERefDocumentType4, PERefDocumentType5, PERefDocumentNumber2, PERefDocumentNumber3, PERefDocumentNumber4, PERefDocumentNumber5, ELIEInvoice, ELIEInvStatus, ELIEInvUpdatedBy, ELIEInvException, ELIEInvUpdatedOn, COOperType, CentralCollection, CColChildCompany, CColParentCompany, CColOrderNum, CColChildInvoiceNum, CColInvoiceNum, CColChildLegalNumber, CColLegalNumber, CColInvoiceRef, CColInvBal, DocCColInvBal, CColInvAmt, DocCColInvAmt, Rpt1CColInvBal, Rpt2CColInvBal, Rpt3CColInvBal, Rpt1CColInvAmt, Rpt2CColInvAmt, Rpt3CColInvAmt, NettingID, ELIEInvTerminalName, ELIEInvTerminalIP, Description, WithholdAcctToInterim, CColOpenInvoice, AGQRCodeData, ExemptReasonCode, ELIEInvID, CallNum, CallLine, JobNum, MXCancelReasonCode, MXSubstInvoiceNum, MXExportType, MXGlobalInvoicePeriod, MXGlobalInvoiceMonth', NULL, N'Company,InvoiceNum', N'ChangeDate', CAST(N'2023-12-14T05:34:11.3333333' AS DateTime2), N'Succeeded', 1, N'RDBMS', CAST(N'2023-12-14T05:30:40.7800000' AS DateTime2), CAST(N'2023-12-13T00:00:00.000' AS DateTime), N'', NULL, 1)
GO
INSERT [common].[EU_RDBMSControlTable] ([ControlID], [BusinessArea], [SrcConnectionFriendlyName], [SrcTableSchema], [SrcTableName], [TgtConnectionFriendlyName], [TgtTableSchema], [TgtTableName], [TgtRootContainer], [TgtFileName], [ColumnList], [Query], [PrimaryKeyList], [IncRefreshColumn], [LastRefreshDate], [LastRefreshStatus], [IsActive], [Tag], [RefreshStartDate], [IncRefreshMaxDate], [latest_file_path], [AdditionalFilterConditions], [IsDelete]) VALUES (14, N'EpicorERP', N'STG_OnPremConnection', N'erp', N'OrderHed', N'TGT_AzureSQLConnection', N'EU_stg', N'OrderHed', N'raw', NULL, N'OpenOrder, VoidOrder, Company, OrderNum, CustNum, PONum, OrderHeld, EntryPerson, ShipToNum, RequestDate, OrderDate, FOB, ShipViaCode, TermsCode, DiscountPercent, PrcConNum, ShpConNum, SalesRepList, OrderComment, ShipComment, InvoiceComment, PickListComment, DepositBal, DocDepositBal, NeedByDate, CreditOverride, CreditOverrideUserID, CreditOverrideDate, CreditOverrideTime, CreditOverrideLimit, SndAlrtShp, ExchangeRate, CurrencyCode, LockRate, CardMemberName, CardNumber, CardType, ExpirationMonth, ExpirationYear, CardID, CardmemberReference, AllocPriorityCode, ReservePriorityCode, ShipOrderComplete, WebOrder, CCApprovalNum, EDIOrder, EDIAck, Linked, ICPONum, ExtCompany, WebEntryPerson, AckEmailSent, ApplyOrderBasedDisc, AutoOrderBasedDisc, EntryMethod, HDCaseNum, CounterSale, CreateInvoice, CreatePackingSlip, LockQty, ProcessCard, CCAmount, CCFreight, CCTax, CCTotal, CCDocAmount, CCDocFreight, CCDocTax, CCDocTotal, CCStreetAddr, CCZip, BTCustNum, BTConNum, RepRate4, RepRate5, RepSplit1, RepSplit2, RepSplit3, RepSplit4, RepSplit5, RepRate1, RepRate2, RepRate3, OutboundSalesDocCtr, OutboundShipDocsCtr, DemandContractNum, DoNotShipBeforeDate, ResDelivery, DoNotShipAfterDate, SatDelivery, SatPickup, Hazmat, DocOnly, RefNotes, ApplyChrg, ChrgAmount, COD, CODFreight, CODCheck, CODAmount, GroundType, NotifyFlag, NotifyEMail, DeclaredIns, DeclaredAmt, CancelAfterDate, DemandRejected, OverrideCarrier, OverrideService, CreditCardOrder, DemandHeadSeq, PayFlag, PayAccount, PayBTAddress1, PayBTAddress2, PayBTCity, PayBTState, PayBTZip, PayBTCountry, DropShip, CommercialInvoice, ShipExprtDeclartn, CertOfOrigin, LetterOfInstr, FFID, FFAddress1, FFAddress2, FFCity, FFState, FFZip, FFCountry, FFContact, FFCompName, FFPhoneNum, IntrntlShip, ChangedBy, ChangeDate, ChangeTime, AutoPrintReady, EDIReady, IndividualPackIDs, FFAddress3, DeliveryConf, AddlHdlgFlag, NonStdPkg, ServSignature, ServAlert, ServHomeDel, DeliveryType, ServDeliveryDate, ServInstruct, ServRef1, ServRef2, ServRef3, ServRef4, ServRef5, FFCountryNum, ServPhone, ServRelease, ServAuthNum, PayBTAddress3, PayBTCountryNum, PayBTPhone, UPSQuantumView, UPSQVShipFromName, UPSQVMemo, ReadyToCalc, TotalCharges, TotalMisc, TotalDiscount, TotalComm, TotalAdvBill, TotalLines, TotalReleases, TotalRelDates, DocTotalCharges, DocTotalMisc, DocTotalDiscount, DocTotalComm, TotalTax, DocTotalTax, DocTotalAdvBill, TotalShipped, TotalInvoiced, TotalCommLines, SRCommAmt1, SRCommAmt2, SRCommAmt3, SRCommAmt4, SRCommAmt5, SRCommableAmt1, SRCommableAmt2, SRCommableAmt3, SRCommableAmt4, SRCommableAmt5, Rounding, Rpt1DepositBal, DocRounding, Rpt2DepositBal, Rpt3DepositBal, Rpt1TotalCharges, Rpt2TotalCharges, Rpt3TotalCharges, Rpt1TotalAdvBill, Rpt2TotalAdvBill, Rpt3TotalAdvBill, Rpt1TotalMisc, Rpt2TotalMisc, Rpt3TotalMisc, Rpt1TotalDiscount, Rpt2TotalDiscount, Rpt3TotalDiscount, Rpt1TotalComm, Rpt2TotalComm, Rpt3TotalComm, Rpt1TotalTax, Rpt2TotalTax, Rpt1Rounding, Rpt2Rounding, Rpt3Rounding, RateGrpCode, Rpt3TotalTax, Rpt1CCAmount, Rpt2CCAmount, Rpt3CCAmount, Rpt1CCFreight, Rpt2CCFreight, Rpt3CCFreight, Rpt1CCTax, Rpt2CCTax, Rpt3CCTax, Rpt1CCTotal, Rpt2CCTotal, Rpt3CCTotal, OrderAmt, DocOrderAmt, Rpt1OrderAmt, Rpt2OrderAmt, Rpt3OrderAmt, TaxPoint, TaxRateDate, TaxRegionCode, UseOTS, OTSName, OTSAddress1, OTSAddress2, OTSAddress3, OTSCity, OTSState, OTSZIP, OTSResaleID, OTSContact, OTSFaxNum, OTSPhoneNum, OTSCountryNum, TotalWHTax, DocTotalWHTax, Rpt1TotalWHTax, Rpt2TotalWHTax, Rpt3TotalWHTax, TotalSATax, DocTotalSATax, Rpt1TotalSATax, Rpt2TotalSATax, Rpt3TotalSATax, OTSSaveAs, OTSSaveCustID, OTSCustSaved, ShipToCustNum, OrderStatus, HoldSetByDemand, InPrice, InTotalCharges, InTotalMisc, InTotalDiscount, DocInTotalCharges, DocInTotalMisc, DocInTotalDiscount, Rpt1InTotalCharges, Rpt2InTotalCharges, Rpt3InTotalCharges, Rpt1InTotalMisc, Rpt2InTotalMisc, Rpt3InTotalMisc, Rpt1InTotalDiscount, Rpt2InTotalDiscount, Rpt3InTotalDiscount, ARLOCID, OurBank, ERSOrder, LOCHold, PSCurrCode, InvCurrCode, LegalNumber, TranDocTypeID, XRefContractNum, XRefContractDate, DemandProcessDate, DemandProcessTime, LastScheduleNumber, LastTCtrlNum, LastBatchNum, ECCOrderNum, ECCPONum, WIOrder, WIApplication, WIUsername, WIUserID, WICreditCardorder, OrderCSR, UserChar1, UserChar2, UserChar3, UserChar4, UserDate1, UserDate2, UserDate3, UserDate4, UserDecimal1, UserDecimal2, UserInteger1, UserInteger2, SysRevID, SysRowID, IsCSRSet, ECCPaymentMethod, AGUseGoodDefaultMark, OTSShipToNum, ProFormaInvComment, ccToken, InvcOrderCmp, ReprintSOAck, CounterSOAck, DispatchReason, Plant, ReadyToFulfill, ShipByTime, TWFiscalYear, TWFiscalYearSuffix, TWFiscalPeriod, TWGUIGroup, TWGUIRegNumSeller, TWGUIRegNumBuyer, OrderOpenCredit, ClosedNotShipped, InvCurrDepositBal, PLArticle106c, PLInvIssuedByTaxpayer, PLInvIssuedBySecondTaxpayer, PLTouristService, PLSecondHandOrArts, PLLegalArticleAct, PLLegalArticleWEDirective, PLLegalArticleOther, PLEnforcementAuthName, PLEnforcementAuthAddr, PLTaxRepresentativeName, PLTaxRepresentativeAddr, PLTaxRepresentativeTaxID, PLMarginScheme, PLGoodsOrServiceVATExempt, CCCity, CCState, ExtAOEUserID, ExtAOE, OTSTaxValidationStatus, OTSTaxValidationDate', NULL, N'Company,OrderNum', N'ChangeDate', CAST(N'2023-12-14T05:37:08.5566667' AS DateTime2), N'Succeeded', 1, N'RDBMS', CAST(N'2023-12-14T05:30:40.7800000' AS DateTime2), CAST(N'2023-12-13T00:00:00.000' AS DateTime), N'', NULL, 1)
GO
INSERT [common].[EU_RDBMSControlTable] ([ControlID], [BusinessArea], [SrcConnectionFriendlyName], [SrcTableSchema], [SrcTableName], [TgtConnectionFriendlyName], [TgtTableSchema], [TgtTableName], [TgtRootContainer], [TgtFileName], [ColumnList], [Query], [PrimaryKeyList], [IncRefreshColumn], [LastRefreshDate], [LastRefreshStatus], [IsActive], [Tag], [RefreshStartDate], [IncRefreshMaxDate], [latest_file_path], [AdditionalFilterConditions], [IsDelete]) VALUES (32, N'EpicorERP', N'STG_OnPremConnection', N'Ice', N'UD21', N'TGT_AzureSQLConnection', N'EU_stg', N'UD21', N'raw', NULL, N'Company,Key1,Key2,Key3,Key4,Key5,Character01,Character02,Character03,Character04,Character05,Character06,Character07,Character08,Character09,Character10,Number01,Number02,Number03,Number04,Number05,Number06,Number07,Number08,Number09,Number10,Number11,Number12,Number13,Number14,Number15,Number16,Number17,Number18,Number19,Number20,Date01,Date02,Date03,Date04,Date05,Date06,Date07,Date08,Date09,Date10,Date11,Date12,Date13,Date14,Date15,Date16,Date17,Date18,Date19,Date20,CheckBox01,CheckBox02,CheckBox03,CheckBox04,CheckBox05,CheckBox06,CheckBox07,CheckBox08,CheckBox09,CheckBox10,CheckBox11,CheckBox12,CheckBox13,CheckBox14,CheckBox15,CheckBox16,CheckBox17,CheckBox18,CheckBox19,CheckBox20,ShortChar01,ShortChar02,ShortChar03,ShortChar04,ShortChar05,ShortChar06,ShortChar07,ShortChar08,ShortChar09,ShortChar10,ShortChar11,ShortChar12,ShortChar13,ShortChar14,ShortChar15,ShortChar16,ShortChar17,ShortChar18,ShortChar19,ShortChar20,GlobalUD21,GlobalLock,SysRevID,SysRowID', NULL, N'Company,Key1,Key2,Key3,Key4,Key5', NULL, CAST(N'2023-12-14T05:34:24.2033333' AS DateTime2), N'Succeeded', 1, N'RDBMS', CAST(N'2023-12-14T05:30:40.7800000' AS DateTime2), CAST(N'1900-01-01T00:00:00.000' AS DateTime), N'', NULL, NULL)
GO
INSERT [common].[EU_RDBMSControlTable] ([ControlID], [BusinessArea], [SrcConnectionFriendlyName], [SrcTableSchema], [SrcTableName], [TgtConnectionFriendlyName], [TgtTableSchema], [TgtTableName], [TgtRootContainer], [TgtFileName], [ColumnList], [Query], [PrimaryKeyList], [IncRefreshColumn], [LastRefreshDate], [LastRefreshStatus], [IsActive], [Tag], [RefreshStartDate], [IncRefreshMaxDate], [latest_file_path], [AdditionalFilterConditions], [IsDelete]) VALUES (16, N'EpicorERP', N'STG_OnPremConnection', N'erp', N'Part', N'TGT_AzureSQLConnection', N'EU_stg', N'Part', N'raw', NULL, N'Company, PartNum, SearchWord, PartDescription, ClassID, IUM, PUM, TypeCode, NonStock, PurchasingFactor, UnitPrice, PricePerCode, InternalUnitPrice, InternalPricePerCode, ProdCode, MfgComment, PurComment, CostMethod, UserChar1, UserChar2, UserChar3, UserChar4, UserDate1, UserDate2, UserDate3, UserDate4, UserDecimal1, UserDecimal2, UserDecimal3, UserDecimal4, UserInteger1, UserInteger2, TaxCatID, InActive, LowLevelCode, Method, TrackLots, TrackDimension, DefaultDim, TrackSerialNum, CommodityCode, WarrantyCode, PhantomBOM, SalesUM, SellingFactor, MtlBurRate, NetWeight, UsePartRev, PartsPerContainer, PartLength, PartWidth, PartHeight, LotShelfLife, WebPart, RunOut, SubPart, Diameter, Gravity, OnHold, OnHoldDate, OnHoldReasonCode, AnalysisCode, GlobalPart, MtlAnalysisCode, GlobalLock, ISSuppUnitsFactor, PDMObjID, ImageFileName, ISOrigCountry, SNPrefix, SNFormat, SNBaseDataType, Constrained, UPCCode1, UPCCode2, UPCCode3, EDICode, WebInStock, ConsolidatedPurchasing, PurchasingFactorDirection, SellingFactorDirection, RecDocReq, MDPV, ShipDocReq, ReturnableContainer, NetVolume, QtyBearing, NAFTAOrigCountry, NAFTAProd, NAFTAPref, ExpLicType, ExpLicNumber, ECCNNumber, AESExp, HTS, UseHTSDesc, SchedBcode, HazItem, HazTechName, HazClass, HazSub, HazGvrnmtID, HazPackInstr, RevChargeMethod, RCUnderThreshold, RCOverThreshold, OwnershipStatus, UOMClassID, SNMask, SNMaskExample, SNMaskSuffix, SNMaskPrefix, SNLastUsedSeq, UseMaskSeq, NetWeightUOM, NetVolumeUOM, LotBatch, LotMfgBatch, LotMfgLot, LotHeat, LotFirmware, LotBeforeDt, LotMfgDt, LotCureDt, LotExpDt, LotPrefix, LotUseGlobalSeq, LotSeqID, LotNxtNum, LotDigits, LotLeadingZeros, LotAppendDate, BuyToOrder, DropShip, IsConfigured, ExtConfig, RefCategory, CSFCJ5, CSFLMW, GrossWeight, GrossWeightUOM, BasePartNum, FSAssetClassCode, FSSalesUnitPrice, FSPricePerCode, RcvInspectionReq, EstimateID, EstimateOrPlan, DiffPrc2PrchUOM, DupOnJobCrt, PricingFactor, PricingUOM, MobilePart, SysRevID, SysRowID, AGUseGoodMark, AGProductMark, ISRegion, INChapterID, PESUNATType, PESUNATUOM, DEIsServices, DEIsSecurityFinancialDerivative, DEInternationalSecuritiesID, LinkToContract, DEIsInvestment, DEPayStatCode, DEDenomination, PartLengthWidthHeightUM, DiameterUM, DiameterInside, DiameterOutside, ThicknessUM, Thickness, ThicknessMax, Durometer, Specification, EngineeringAlert, Condition, IsCompliant, IsRestricted, IsSafetyItem, CommercialBrand, CommercialSubBrand, CommercialCategory, CommercialSubCategory, CommercialStyle, CommercialSize1, CommercialSize2, CommercialColor, IsGiftCard, PhotoFile, PartPhotoExists, CommentText, PartSpecificPackingUOM, ImageID, CNSpecification, SyncToExternalCRM, ExternalCRMPartID, ExternalCRMLastSync, ExternalCRMSyncRequired, PESUNATTypeCode, PESUNATUOMCode, CNCodeVersion, CNTaxCategoryCode, CNHasPreferentialTreatment, CNPreferentialTreatmentContent, CNZeroTaxRateMark, SubLevelCode, CreatedBy, CreatedOn, AttBatch, AttMfgBatch, AttMfgLot, AttHeat, AttFirmware, AttBeforeDt, AttMfgDt, AttCureDt, AttExpDt, DeferManualEntry, DeferPurchaseReceipt, DeferJobReceipt, DeferInspection, DeferQtyAdjustment, DeferInventoryMove, DeferShipments, DeferInventoryCounts, DeferAssetDisposal, DeferReturnMaterials, MXProdServCode, ChangedOn, MXCustomsDuty, SendToFSA, ExternalMESSyncRequired, ExternalMESLastSync, FSAItem, FSAEquipment, BOLClass, FairMarketValue, SAFTProdCategory, AttrClassID, LocationIDNumReq, LocationTrackInv, LocationMtlView, LCNRVReporting, LCNRVEstimatedUnitPrice, MXCustomsUMFrom, LocationFormatID, IsServices, PEDetrGoodServiceCode, PEProductServiceCode, DualUOMClassID, CNProductName, CNWeight, CNWeightUOM, CNBonded, TrackInventoryAttributes, DefaultAttributeSetID, AttISOrigCountry, ExternalSchemeID, ExternalID, CommoditySchemeID, CommoditySchemeVersion, TrackInventoryByRevision, PlanningByRevision', NULL, N'Company,PartNum', N'changedon', CAST(N'2023-12-14T05:34:44.8666667' AS DateTime2), N'Succeeded', 1, N'RDBMS', CAST(N'2023-12-14T05:30:40.7800000' AS DateTime2), CAST(N'2023-12-13T15:34:50.370' AS DateTime), N'', NULL, 1)
GO
INSERT [common].[EU_RDBMSControlTable] ([ControlID], [BusinessArea], [SrcConnectionFriendlyName], [SrcTableSchema], [SrcTableName], [TgtConnectionFriendlyName], [TgtTableSchema], [TgtTableName], [TgtRootContainer], [TgtFileName], [ColumnList], [Query], [PrimaryKeyList], [IncRefreshColumn], [LastRefreshDate], [LastRefreshStatus], [IsActive], [Tag], [RefreshStartDate], [IncRefreshMaxDate], [latest_file_path], [AdditionalFilterConditions], [IsDelete]) VALUES (20, N'EpicorERP', N'STG_OnPremConnection', N'erp', N'PartTran', N'TGT_AzureSQLConnection', N'EU_stg', N'PartTran', N'raw', NULL, N'Company, SysDate, SysTime, TranNum, PartNum, WareHouseCode, BinNum, TranClass, TranType, InventoryTrans, TranDate, TranQty, UM, MtlUnitCost, LbrUnitCost, BurUnitCost, SubUnitCost, MtlBurUnitCost, ExtCost, CostMethod, JobNum, AssemblySeq, JobSeqType, JobSeq, PackType, PackNum, PackLine, PONum, POLine, PORelNum, WareHouse2, BinNum2, OrderNum, OrderLine, OrderRelNum, EntryPerson, TranReference, PartDescription, RevisionNum, VendorNum, PurPoint, POReceiptQty, POUnitCost, PackSlip, InvoiceNum, InvoiceLine, InvAdjSrc, InvAdjReason, LotNum, DimCode, DUM, DimConvFactor, LotNum2, DimCode2, DUM2, DimConvFactor2, GLTrans, PostedToGL, FiscalYear, FiscalPeriod, JournalNum, Costed, DMRNum, ActionNum, RMANum, COSPostingReqd, JournalCode, Plant, Plant2, CallNum, CallLine, MatNum, JobNum2, AssemblySeq2, JobSeq2, CustNum, RMALine, RMAReceipt, RMADisp, OtherDivValue, PlantTranNum, NonConfID, MtlMtlUnitCost, MtlLabUnitCost, MtlSubUnitCost, MtlBurdenUnitCost, RefType, RefCode, LegalNumber, BeginQty, AfterQty, BegBurUnitCost, BegLbrUnitCost, BegMtlBurUnitCost, BegMtlUnitCost, BegSubUnitCost, AfterBurUnitCost, AfterLbrUnitCost, AfterMtlBurUnitCost, AfterMtlUnitCost, AfterSubUnitCost, PlantCostValue, EmpID, ReconcileNum, CostID, FIFODate, FIFOSeq, ActTranQty, ActTransUOM, InvtyUOM, InvtyUOM2, FIFOAction, FiscalYearSuffix, FiscalCalendarID, BinType, CCYear, CCMonth, CycleSeq, ABTUID, BaseCostMethod, RevertStatus, RevertID, DropShipPackSlip, VarTarget, FIFOSubSeq, AltMtlUnitCost, AltLbrUnitCost, AltBurUnitCost, AltSubUnitCost, AltMtlBurUnitCost, AltExtCost, AltMtlMtlUnitCost, AltMtlLabUnitCost, AltMtlSubUnitCost, AltMtlBurdenUnitCost, TranDocTypeID, PBInvNum, LoanFlag, AssetNum, AdditionNum, DisposalNum, ProjProcessed, AsOfDate, AsOfSeq, MscNum, ODCUnitCost, SysRevID, SysRowID, TranRefType, PCID, PCIDCollapseCounter, PCID2, ContractID, LCFlag, ExtMtlCost, ExtLbrCost, ExtBurCost, ExtSubCost, ExtMtlBurCost, ExtMtlMtlCost, ExtMtlLabCost, ExtMtlSubCost, ExtMtlBurdenCost, MYImportNum, AutoReverse, RevTranNum, RevSysDate, RevSysTime, ExtNonRecoverableCost, EpicorFSA, AttributeSetID, AttributeSetDescription, AttributeSetShortDescription, NumberOfPieces, WIPPCID, WIPPCID2', NULL, N'Company,SysDate,SysTime,TranNum', N'SysDate', CAST(N'2023-12-14T05:35:29.3900000' AS DateTime2), N'Succeeded', 1, N'RDBMS', CAST(N'2023-12-14T05:30:40.7800000' AS DateTime2), CAST(N'2023-12-14T00:00:00.000' AS DateTime), N'', NULL, 0)
GO
INSERT [common].[EU_RDBMSControlTable] ([ControlID], [BusinessArea], [SrcConnectionFriendlyName], [SrcTableSchema], [SrcTableName], [TgtConnectionFriendlyName], [TgtTableSchema], [TgtTableName], [TgtRootContainer], [TgtFileName], [ColumnList], [Query], [PrimaryKeyList], [IncRefreshColumn], [LastRefreshDate], [LastRefreshStatus], [IsActive], [Tag], [RefreshStartDate], [IncRefreshMaxDate], [latest_file_path], [AdditionalFilterConditions], [IsDelete]) VALUES (24, N'EpicorERP', N'STG_OnPremConnection', N'erp', N'PODetail', N'TGT_AzureSQLConnection', N'EU_stg', N'PODetail', N'raw', NULL, N'Company, OpenLine, VoidLine, PONUM, POLine, LineDesc, IUM, UnitCost, DocUnitCost, OrderQty, XOrderQty, Taxable, PUM, CostPerCode, PartNum, VenPartNum, CommentText, ClassID, RevisionNum, RcvInspectionReq, VendorNum, AdvancePayBal, DocAdvancePayBal, Confirmed, DateChgReq, QtyChgReq, PartNumChgReq, RevisionNumChgReq, ConfirmDate, ConfirmVia, PrcChgReq, PurchCode, OrderNum, OrderLine, Linked, ExtCompany, GlbCompany, ContractActive, ContractQty, ContractUnitCost, ContractDocUnitCost, Rpt1AdvancePayBal, Rpt2AdvancePayBal, Rpt3AdvancePayBal, Rpt1UnitCost, Rpt2UnitCost, Rpt3UnitCost, ContractQtyUOM, Rpt1ContractUnitCost, Rpt2ContractUnitCost, Rpt3ContractUnitCost, BaseQty, BaseUOM, BTOOrderNum, BTOOrderLine, VendorPartOpts, MfgPartOpts, SubPartOpts, MfgNum, MfgPartNum, SubPartNum, SubPartType, ConfigUnitCost, ConfigBaseUnitCost, ConvOverRide, BasePartNum, BaseRevisionNum, Direction, Per, MaintainPricingUnits, OverrideConversion, RowsManualFactor, KeepRowsManualFactorTmp, ShipToSupplierDate, Factor, PricingQty, PricingUnitPrice, UOM, SysRevID, SysRowID, GroupSeq, DocPricingUnitPrice, OverridePriceList, QtyOption, OrigComment, SmartString, SmartStringProcessed, DueDate, ContractID, LinkToContract, SelCurrPricingUnitPrice, ChangedBy, ChangeDate, PCLinkRemoved, TaxCatID, NoTaxRecalc, InUnitCost, DocInUnitCost, Rpt1InUnitCost, Rpt2InUnitCost, Rpt3InUnitCost, InAdvancePayBal, DocInAdvancePayBal, Rpt1InAdvancePayBal, Rpt2InAdvancePayBal, Rpt3InAdvancePayBal, InContractUnitCost, DocInContractUnitCost, Rpt1InContractUnitCost, Rpt2InContractUnitCost, Rpt3InContractUnitCost, DocExtCost, ExtCost, Rpt1ExtCost, Rpt2ExtCost, Rpt3ExtCost, DocMiscCost, MiscCost, Rpt1MiscCost, Rpt2MiscCost, Rpt3MiscCost, TotalTax, DocTotalTax, Rpt1TotalTax, Rpt2TotalTax, Rpt3TotalTax, TotalSATax, DocTotalSATax, Rpt1TotalSATax, Rpt2TotalSATax, Rpt3TotalSATax, TotalDedTax, DocTotalDedTax, Rpt1TotalDedTax, Rpt2TotalDedTax, Rpt3TotalDedTax, CommodityCode', NULL, N'Company,PONUM,POLine', N'ChangeDate', CAST(N'2023-12-14T05:34:01.2200000' AS DateTime2), N'Succeeded', 1, N'RDBMS', CAST(N'2023-12-14T05:30:40.7800000' AS DateTime2), CAST(N'2023-12-13T17:26:06.513' AS DateTime), N'', NULL, 1)
GO
INSERT [common].[EU_RDBMSControlTable] ([ControlID], [BusinessArea], [SrcConnectionFriendlyName], [SrcTableSchema], [SrcTableName], [TgtConnectionFriendlyName], [TgtTableSchema], [TgtTableName], [TgtRootContainer], [TgtFileName], [ColumnList], [Query], [PrimaryKeyList], [IncRefreshColumn], [LastRefreshDate], [LastRefreshStatus], [IsActive], [Tag], [RefreshStartDate], [IncRefreshMaxDate], [latest_file_path], [AdditionalFilterConditions], [IsDelete]) VALUES (25, N'EpicorERP', N'STG_OnPremConnection', N'erp', N'POHeader', N'TGT_AzureSQLConnection', N'EU_stg', N'POHeader', N'raw', NULL, N'Company, OpenOrder, VoidOrder, PONum, EntryPerson, OrderDate, FOB, ShipViaCode, TermsCode, ShipName, ShipAddress1, ShipAddress2, ShipAddress3, ShipCity, ShipState, ShipZIP, ShipCountry, BuyerID, FreightPP, PrcConNum, VendorNum, PurPoint, CommentText, OrderHeld, ShipToConName, ReadyToPrint, PrintAs, CurrencyCode, ExchangeRate, LockRate, ShipCountryNum, LogChanges, ApprovedDate, ApprovedBy, Approve, ApprovalStatus, ApprovedAmount, PostToWeb, PostDate, VendorRefNum, ConfirmReq, Confirmed, ConfirmVia, OrderNum, LegalNumber, Linked, ExtCompany, XRefPONum, ConsolidatedPO, GlbCompany, ContractOrder, ContractStartDate, ContractEndDate, PrintHeaderAddress, RateGrpCode, POType, APLOCID, TranDocTypeID, AutoPrintReady, ICPOLocked, SysRevID, SysRowID, DueDate, PromiseDate, ChangedBy, ChangeDate, POTaxReadyToProcess, TaxRegionCode, TaxPoint, TaxRateDate, TotalTax, DocTotalTax, Rpt1TotalTax, Rpt2TotalTax, Rpt3TotalTax, TotalWhTax, DocTotalWhTax, Rpt1TotalWhTax, Rpt2TotalWhTax, Rpt3TotalWhTax, TotalSATax, DocTotalSATax, Rpt1TotalSATax, Rpt2TotalSATax, Rpt3TotalSATax, InPrice, HdrTaxNoUpdt, TaxRateGrpCode, TotalDedTax, DocTotalDedTax, Rpt1TotalDedTax, Rpt2TotalDedTax, Rpt3TotalDedTax, TotalCharges, TotalMiscCharges, TotalOrder, DocTotalCharges, DocTotalMisc, DocTotalOrder, Rpt1TotalCharges, Rpt2TotalCharges, Rpt3TotalCharges, Rpt1TotalMiscCharges, Rpt2TotalMiscCharges, Rpt3TotalMiscCharges, Rpt1TotalOrder, Rpt2TotalOrder, Rpt3TotalOrder, APTaxRoundOption', NULL, N'Company,PONum', N'ChangeDate', CAST(N'2023-12-14T05:36:15.7366667' AS DateTime2), N'Succeeded', 1, N'RDBMS', CAST(N'2023-12-14T05:30:40.7800000' AS DateTime2), CAST(N'2023-12-13T17:26:18.323' AS DateTime), N'', NULL, 1)
GO
INSERT [common].[EU_RDBMSControlTable] ([ControlID], [BusinessArea], [SrcConnectionFriendlyName], [SrcTableSchema], [SrcTableName], [TgtConnectionFriendlyName], [TgtTableSchema], [TgtTableName], [TgtRootContainer], [TgtFileName], [ColumnList], [Query], [PrimaryKeyList], [IncRefreshColumn], [LastRefreshDate], [LastRefreshStatus], [IsActive], [Tag], [RefreshStartDate], [IncRefreshMaxDate], [latest_file_path], [AdditionalFilterConditions], [IsDelete]) VALUES (26, N'EpicorERP', N'STG_OnPremConnection', N'erp', N'PriceLst', N'TGT_AzureSQLConnection', N'EU_stg', N'PriceLst', N'raw', NULL, N'Company, ListCode, CurrencyCode, ListDescription, StartDate, EndDate, WarehouseList, GlobalPriceLst, GlobalLock, ListType, SysRevID, SysRowID, UseZeroPrice', NULL, N'Company,ListCode', NULL, CAST(N'2023-12-14T05:35:06.2266667' AS DateTime2), N'Succeeded', 1, N'RDBMS', CAST(N'2023-12-14T05:30:40.7800000' AS DateTime2), CAST(N'1900-01-01T00:00:00.000' AS DateTime), N'', NULL, NULL)
GO
INSERT [common].[EU_RDBMSControlTable] ([ControlID], [BusinessArea], [SrcConnectionFriendlyName], [SrcTableSchema], [SrcTableName], [TgtConnectionFriendlyName], [TgtTableSchema], [TgtTableName], [TgtRootContainer], [TgtFileName], [ColumnList], [Query], [PrimaryKeyList], [IncRefreshColumn], [LastRefreshDate], [LastRefreshStatus], [IsActive], [Tag], [RefreshStartDate], [IncRefreshMaxDate], [latest_file_path], [AdditionalFilterConditions], [IsDelete]) VALUES (27, N'EpicorERP', N'STG_OnPremConnection', N'erp', N'PriceLstParts', N'TGT_AzureSQLConnection', N'EU_stg', N'PriceLstParts', N'raw', NULL, N'Company, ListCode, PartNum, BasePrice, DiscountPercent1, DiscountPercent2, DiscountPercent3, DiscountPercent4, DiscountPercent5, QtyBreak1, QtyBreak2, QtyBreak3, QtyBreak4, QtyBreak5, UnitPrice1, UnitPrice2, UnitPrice3, UnitPrice4, UnitPrice5, CommentText, UOMCode, GlobalPriceLstParts, GlobalLock, SysRevID, SysRowID', NULL, N'Company,ListCode,PartNum,UOMCode', NULL, CAST(N'2023-12-14T05:35:24.1066667' AS DateTime2), N'Succeeded', 1, N'RDBMS', CAST(N'2023-12-14T05:30:40.7800000' AS DateTime2), CAST(N'1900-01-01T00:00:00.000' AS DateTime), N'', NULL, NULL)
GO
INSERT [common].[EU_RDBMSControlTable] ([ControlID], [BusinessArea], [SrcConnectionFriendlyName], [SrcTableSchema], [SrcTableName], [TgtConnectionFriendlyName], [TgtTableSchema], [TgtTableName], [TgtRootContainer], [TgtFileName], [ColumnList], [Query], [PrimaryKeyList], [IncRefreshColumn], [LastRefreshDate], [LastRefreshStatus], [IsActive], [Tag], [RefreshStartDate], [IncRefreshMaxDate], [latest_file_path], [AdditionalFilterConditions], [IsDelete]) VALUES (28, N'EpicorERP', N'STG_OnPremConnection', N'erp', N'PriceLstParts_UD', N'TGT_AzureSQLConnection', N'EU_stg', N'PriceLstParts_UD', N'raw', NULL, N'*', NULL, NULL, NULL, CAST(N'2023-12-14T05:38:05.5933333' AS DateTime2), N'Succeeded', 1, N'RDBMS', CAST(N'2023-12-14T05:30:40.7800000' AS DateTime2), CAST(N'1900-01-01T00:00:00.000' AS DateTime), N'', NULL, NULL)
GO
INSERT [common].[EU_RDBMSControlTable] ([ControlID], [BusinessArea], [SrcConnectionFriendlyName], [SrcTableSchema], [SrcTableName], [TgtConnectionFriendlyName], [TgtTableSchema], [TgtTableName], [TgtRootContainer], [TgtFileName], [ColumnList], [Query], [PrimaryKeyList], [IncRefreshColumn], [LastRefreshDate], [LastRefreshStatus], [IsActive], [Tag], [RefreshStartDate], [IncRefreshMaxDate], [latest_file_path], [AdditionalFilterConditions], [IsDelete]) VALUES (29, N'EpicorERP', N'STG_OnPremConnection', N'erp', N'SalesRep', N'TGT_AzureSQLConnection', N'EU_stg', N'SalesRep', N'raw', NULL, N'InActive,Company,SalesRepCode,Name,CommissionPercent,CommissionEarnedAt,AlertFlag,Address1,Address2,Address3,City,State,Zip,Country,CountryNum,OfficePhoneNum,FaxPhoneNum,CellPhoneNum,PagerNum,HomePhoneNum,EMailAddress,SalesRepTitle,RepReportsTo,Comment,SalesMgrConfidence,RoleCode,ViewAllTer,ViewCompPipe,WebSaleGetsCommission,CnvEmpID,PerConID,SyncNameToPerCon,SyncAddressToPerCon,SyncPhoneToPerCon,SyncEmailToPerCon,SyncLinksToPerCon,WebSite,IM,Twitter,LinkedIn,FaceBook,WebLink1,WebLink2,WebLink3,WebLink4,WebLink5,MgrWorstCsPct,MgrBestCsPct,SysRevID,SysRowID,WebSalesRep,ECCSalesRepCode', NULL, N'Company,Name', NULL, CAST(N'2023-12-14T05:35:36.3600000' AS DateTime2), N'Succeeded', 1, N'RDBMS', CAST(N'2023-12-14T05:30:40.7800000' AS DateTime2), CAST(N'1900-01-01T00:00:00.000' AS DateTime), N'', NULL, NULL)
GO
INSERT [common].[EU_RDBMSControlTable] ([ControlID], [BusinessArea], [SrcConnectionFriendlyName], [SrcTableSchema], [SrcTableName], [TgtConnectionFriendlyName], [TgtTableSchema], [TgtTableName], [TgtRootContainer], [TgtFileName], [ColumnList], [Query], [PrimaryKeyList], [IncRefreshColumn], [LastRefreshDate], [LastRefreshStatus], [IsActive], [Tag], [RefreshStartDate], [IncRefreshMaxDate], [latest_file_path], [AdditionalFilterConditions], [IsDelete]) VALUES (31, N'EpicorERP', N'STG_OnPremConnection', N'erp', N'Vendcnt', N'TGT_AzureSQLConnection', N'EU_stg', N'Vendcnt', N'raw', NULL, N'Company, VendorNum, PurPoint, ConNum, Name, Func, FaxNum, PhoneNum, EmailAddress, WebPassword, WebUser, RoleCode, CellPhoneNum, PagerNum, HomeNum, AltNum, ContactTitle, ReportsTo, Comment, NoContact, CreateDate, CreateDcdUserID, ChangeDate, ChangeDcdUserID, Inactive, FirstName, MiddleName, LastName, Prefix, Suffix, Initials, ExternalId, GlobalLock, PerConID, SyncEmailToPerCon, SyncLinksToPerCon, SyncNameToPerCon, SyncPhoneToPerCon, WebSite, IM, Twitter, LinkedIn, FaceBook,WebLink1, WebLink2, WebLink3, WebLink4, WebLink5, SysRevID, SysRowID', NULL, N'Company,VendorNum,PurPoint,ConNum,SysRowID', N'ChangeDate', CAST(N'2023-12-14T05:35:55.1766667' AS DateTime2), N'Succeeded', 1, N'RDBMS', CAST(N'2023-12-14T05:30:40.7800000' AS DateTime2), CAST(N'1900-01-01T00:00:00.000' AS DateTime), N'', NULL, NULL)
GO
INSERT [common].[EU_RDBMSControlTable] ([ControlID], [BusinessArea], [SrcConnectionFriendlyName], [SrcTableSchema], [SrcTableName], [TgtConnectionFriendlyName], [TgtTableSchema], [TgtTableName], [TgtRootContainer], [TgtFileName], [ColumnList], [Query], [PrimaryKeyList], [IncRefreshColumn], [LastRefreshDate], [LastRefreshStatus], [IsActive], [Tag], [RefreshStartDate], [IncRefreshMaxDate], [latest_file_path], [AdditionalFilterConditions], [IsDelete]) VALUES (30, N'EpicorERP', N'STG_OnPremConnection', N'erp', N'Vendor', N'TGT_AzureSQLConnection', N'EU_stg', N'Vendor', N'raw', NULL, N'Inactive, Company, VendorID, Name, VendorNum, Address1, Address2, Address3, City, State, ZIP, Country, TaxPayerID, PurPoint, TermsCode, GroupCode, Print1099, OneCheck, PrintLabels, FaxNum, PhoneNum, Comment, PayHold, PrimPCon, AccountRef, DefaultFOB, RcvInspectionReq, CurrencyCode, TaxRegionCode, CountryNum, LangNameID, BorderCrossing, FormatStr, ElecPayment, PrimaryBankID, Approved, ICVend, EMailAddress, WebVendor, VendURL, EarlyBuffer, LateBuffer, OnTimeRating, QualityRating, PriceRating, ServiceRating, ExternalId, VendPILimit, GlobalVendor, ICTrader, TaxAuthorityCode, GlobalLock, MinOrderValue, CalendarID, EDICode, ConsolidatedPurchasing, LocalPurchasing, ResDelivery, SatDelivery, SatPickup, Hazmat, DocOnly, RefNotes, ApplyChrg, ChrgAmount, COD, CODFreight, CODCheck, CODAmount, GroundType, NotifyFlag, NotifyEMail, DeclaredIns, DeclaredAmt, ServSignature, ServAlert, ServHomeDel, DeliveryType, ServDeliveryDate, ServPhone, ServInstruct, ServRelease, ServAuthNum, ServRef1, ServRef2, ServRef3, ServRef4, ServRef5, CPay, IndividualPackIDs, IntrntlShip, CertOfOrigin, CommercialInvoice, ShipExprtDeclartn, LetterOfInstr, FFID, FFCompName, FFContact, FFAddress1, FFAddress2, FFAddress3, FFCity, FFState, FFZip, FFCountry, NonStdPkg, DeliveryConf, AddlHdlgFlag, UPSQuantumView, UPSQVShipFromName, UPSQVMemo, FFPhoneNum, FFCountryNum, RevChargeMethod, ManagedCust, ManagedCustID, ManagedCustNum, PMUID, HasBank, PmtAcctRef, LegalName, TaxRegReason, OrgRegCode, AdvTaxInv, AllowAsAltRemitTo, SysRevID, SysRowID, THBranchID, ParamCode, AGAFIPResponsibilityCode, AGGrossIncomeTaxID, AGIDDocumentTypeCode, AGProvinceCode, AGUseGoodDefaultMark, AGApartment, AGExtraStreetNumber, AGFloor, AGLocationCode, AGNeighborhood, AGStreet, AGStreetNumber, COOneTimeID, NoBankingReference, PEGoodsContributor, PEWithholdAgent, PECollectionAgent, PENotFound, PENoAddress, PEIdentityDocType, COIsOneTimeVend, PEDocumentID, MaxLateDaysPORel, Code1099ID, TIN, TINType, SecondTINNotice, NameControl, ShipViaCode, NonUS, FormTypeID, INSupplierType, INCSTNumber, INPANNumber, DEOrgType, PaymentReporting, ExternalPurchasing, MXRetentionCode, Reporting1099Name, Reporting1099Name2, FATCA, AccountNum, TWGUIRegNum, MXTARCode, PEAddressID, PERetentionRegime, TaxEntityType, INGSTComplianceRate, INTaxRegistrationID, TINValidationStatus, ImporterOfRecord, PLAutomaticAPInvoiceNum, SEC, MXDIOTTranType, US1099KMerchCatCode, MXTaxpayerType, MXLegalRepRFC, MXLegalRepCURP, MXLegalRepName, MXLegalRepTaxpayerType, US1099State, TaxValidationStatus, TaxValidationDate, HMRCTaxValidationLog, ExternalSchemeID, MXMunicipio, EInvoice', NULL, N'Company,VendorNum', NULL, CAST(N'2023-12-14T05:36:28.9700000' AS DateTime2), N'Succeeded', 1, N'RDBMS', CAST(N'2023-12-14T05:30:40.7800000' AS DateTime2), CAST(N'1900-01-01T00:00:00.000' AS DateTime), N'', NULL, NULL)
GO
SET IDENTITY_INSERT [common].[EU_RDBMSControlTable] OFF
GO
SET IDENTITY_INSERT [common].[EU_ValidationControlTable] ON 
GO
INSERT [common].[EU_ValidationControlTable] ([ID], [MeasureName], [SourceConnection], [SourceQuery], [TargetConnection], [TargetQuery], [IsActive], [Tag], [Status]) VALUES (1, N'All_RowCounts', N'STG_OnPremConnection', N'Select count(*) as MeasureValue , ''Customer'' as MeasureName from ERP.Customer  Union all 
Select count(*) as MeasureValue , ''CurrExRate'' as MeasureName from ERP.CurrExRate  Union all 
Select count(*) as MeasureValue , ''CustCnt_UD'' as MeasureName from ERP.CustCnt_UD  Union all 
Select count(*) as MeasureValue , ''CustomerPriceLst'' as MeasureName from ERP.CustomerPriceLst  Union all 
Select count(*) as MeasureValue , ''InvcDtl_UD'' as MeasureName from ERP.InvcDtl_UD  Union all 
Select count(*) as MeasureValue , ''PartWhse_UD'' as MeasureName from ERP.PartWhse_UD  Union all 
Select count(*) as MeasureValue , ''PLPartBrk'' as MeasureName from ERP.PLPartBrk  Union all 
Select count(*) as MeasureValue , ''CustCnt'' as MeasureName from ERP.CustCnt  Union all 
Select count(*) as MeasureValue , ''Customer_UD'' as MeasureName from ERP.Customer_UD  Union all 
Select count(*) as MeasureValue , ''CustXPrt'' as MeasureName from ERP.CustXPrt  Union all 
Select count(*) as MeasureValue , ''OrderDtl'' as MeasureName from ERP.OrderDtl  Union all 
Select count(*) as MeasureValue , ''OrderDtl_UD'' as MeasureName from ERP.OrderDtl_UD  Union all 
Select count(*) as MeasureValue , ''OrderHed_UD'' as MeasureName from ERP.OrderHed_UD  Union all 
Select count(*) as MeasureValue , ''InvcDtl'' as MeasureName from ERP.InvcDtl  Union all 
Select count(*) as MeasureValue , ''Part_UD'' as MeasureName from ERP.Part_UD  Union all 
Select count(*) as MeasureValue , ''PartBin'' as MeasureName from ERP.PartBin  Union all 
Select count(*) as MeasureValue , ''PartCost'' as MeasureName from ERP.PartCost  Union all 
Select count(*) as MeasureValue , ''PartWhse'' as MeasureName from ERP.PartWhse  Union all 
Select count(*) as MeasureValue , ''Invchead'' as MeasureName from ERP.Invchead  Union all 
Select count(*) as MeasureValue , ''OrderHed'' as MeasureName from ERP.OrderHed  Union all 
Select count(*) as MeasureValue , ''UD21'' as MeasureName from ICE.UD21  Union all 
Select count(*) as MeasureValue , ''Part'' as MeasureName from ERP.Part  Union all 
Select count(*) as MeasureValue , ''PartTran'' as MeasureName from ERP.PartTran  Union all 
Select count(*) as MeasureValue , ''PODetail'' as MeasureName from ERP.PODetail  Union all 
Select count(*) as MeasureValue , ''POHeader'' as MeasureName from ERP.POHeader  Union all 
Select count(*) as MeasureValue , ''PriceLst'' as MeasureName from ERP.PriceLst  Union all 
Select count(*) as MeasureValue , ''PriceLstParts'' as MeasureName from ERP.PriceLstParts  Union all 
Select count(*) as MeasureValue , ''PriceLstParts_UD'' as MeasureName from ERP.PriceLstParts_UD  Union all 
Select count(*) as MeasureValue , ''SalesRep'' as MeasureName from ERP.SalesRep  Union all 
Select count(*) as MeasureValue , ''Vendcnt'' as MeasureName from ERP.Vendcnt  Union all 
Select count(*) as MeasureValue , ''Vendor'' as MeasureName from ERP.Vendor', N'TGT_AzureSQLConnection', N'Select count(*) as MeasureValue , ''Customer'' as MeasureName from EU_STG.Customer  Union all 
Select count(*) as MeasureValue , ''CurrExRate'' as MeasureName from EU_STG.CurrExRate  Union all 
Select count(*) as MeasureValue , ''CustCnt_UD'' as MeasureName from EU_STG.CustCnt_UD  Union all 
Select count(*) as MeasureValue , ''CustomerPriceLst'' as MeasureName from EU_STG.CustomerPriceLst  Union all 
Select count(*) as MeasureValue , ''InvcDtl_UD'' as MeasureName from EU_STG.InvcDtl_UD  Union all 
Select count(*) as MeasureValue , ''PartWhse_UD'' as MeasureName from EU_STG.PartWhse_UD  Union all 
Select count(*) as MeasureValue , ''PLPartBrk'' as MeasureName from EU_STG.PLPartBrk  Union all 
Select count(*) as MeasureValue , ''CustCnt'' as MeasureName from EU_STG.CustCnt  Union all 
Select count(*) as MeasureValue , ''Customer_UD'' as MeasureName from EU_STG.Customer_UD  Union all 
Select count(*) as MeasureValue , ''CustXPrt'' as MeasureName from EU_STG.CustXPrt  Union all 
Select count(*) as MeasureValue , ''OrderDtl'' as MeasureName from EU_STG.OrderDtl  Union all 
Select count(*) as MeasureValue , ''OrderDtl_UD'' as MeasureName from EU_STG.OrderDtl_UD  Union all 
Select count(*) as MeasureValue , ''OrderHed_UD'' as MeasureName from EU_STG.OrderHed_UD  Union all 
Select count(*) as MeasureValue , ''InvcDtl'' as MeasureName from EU_STG.InvcDtl  Union all 
Select count(*) as MeasureValue , ''Part_UD'' as MeasureName from EU_STG.Part_UD  Union all 
Select count(*) as MeasureValue , ''PartBin'' as MeasureName from EU_STG.PartBin  Union all 
Select count(*) as MeasureValue , ''PartCost'' as MeasureName from EU_STG.PartCost  Union all 
Select count(*) as MeasureValue , ''PartWhse'' as MeasureName from EU_STG.PartWhse  Union all 
Select count(*) as MeasureValue , ''Invchead'' as MeasureName from EU_STG.Invchead  Union all 
Select count(*) as MeasureValue , ''OrderHed'' as MeasureName from EU_STG.OrderHed  Union all 
Select count(*) as MeasureValue , ''UD21'' as MeasureName from EU_STG.UD21  Union all 
Select count(*) as MeasureValue , ''Part'' as MeasureName from EU_STG.Part  Union all 
Select count(*) as MeasureValue , ''PartTran'' as MeasureName from EU_STG.PartTran  Union all 
Select count(*) as MeasureValue , ''PODetail'' as MeasureName from EU_STG.PODetail  Union all 
Select count(*) as MeasureValue , ''POHeader'' as MeasureName from EU_STG.POHeader  Union all 
Select count(*) as MeasureValue , ''PriceLst'' as MeasureName from EU_STG.PriceLst  Union all 
Select count(*) as MeasureValue , ''PriceLstParts'' as MeasureName from EU_STG.PriceLstParts  Union all 
Select count(*) as MeasureValue , ''PriceLstParts_UD'' as MeasureName from EU_STG.PriceLstParts_UD  Union all 
Select count(*) as MeasureValue , ''SalesRep'' as MeasureName from EU_STG.SalesRep  Union all 
Select count(*) as MeasureValue , ''Vendcnt'' as MeasureName from EU_STG.Vendcnt  Union all 
Select count(*) as MeasureValue , ''Vendor'' as MeasureName from EU_STG.Vendor', 1, N'Staging', N'Completed')
GO
INSERT [common].[EU_ValidationControlTable] ([ID], [MeasureName], [SourceConnection], [SourceQuery], [TargetConnection], [TargetQuery], [IsActive], [Tag], [Status]) VALUES (2, N'Duplicates', NULL, NULL, N'TGT_AzureSQLConnection', N'
Exec [common].[usp_EU_DQCheck] ''Customer'',''EU_stg'',''Company,CustNum'',''_RunID''  ,''_BatchID'',''Staging'' ;
Exec [common].[usp_EU_DQCheck] ''CurrExRate'',''EU_stg'',''Company,RateGrpCode,SourceCurrCode,TargetCurrCode,EffectiveDate'',''_RunID''  ,''_BatchID'',''Staging'' ;
Exec [common].[usp_EU_DQCheck] ''CustomerPriceLst'',''EU_stg'',''Company,CustNum,ShipToNum,SeqNum'',''_RunID''  ,''_BatchID'',''Staging'' ;
Exec [common].[usp_EU_DQCheck] ''PLPartBrk'',''EU_stg'',''Company,ListCode,PartNum,UOMCode,Quantity'',''_RunID''  ,''_BatchID'',''Staging'' ;
Exec [common].[usp_EU_DQCheck] ''CustCnt'',''EU_stg'',''Company,CustNum,ShipToNum,ConNum'',''_RunID''  ,''_BatchID'',''Staging'' ;
Exec [common].[usp_EU_DQCheck] ''CustXPrt'',''EU_stg'',''Company,PartNum,CustNum,XPartNum,SysRowID'',''_RunID''  ,''_BatchID'',''Staging'' ;
Exec [common].[usp_EU_DQCheck] ''OrderDtl'',''EU_stg'',''Company,OrderLine,OrderNum'',''_RunID''  ,''_BatchID'',''Staging'' ;
Exec [common].[usp_EU_DQCheck] ''InvcDtl'',''EU_stg'',''Company,InvoiceLine,InvoiceNum'',''_RunID''  ,''_BatchID'',''Staging'' ;
Exec [common].[usp_EU_DQCheck] ''PartBin'',''EU_stg'',''AttributeSetID,BinNum,Company,DimCode,LotNum,PartNum,PCID,WarehouseCode'',''_RunID''  ,''_BatchID'',''Staging'' ;
Exec [common].[usp_EU_DQCheck] ''PartCost'',''EU_stg'',''Company,CostID,PartNum'',''_RunID''  ,''_BatchID'',''Staging'' ;
Exec [common].[usp_EU_DQCheck] ''PartWhse'',''EU_stg'',''Company,PartNum,WarehouseCode'',''_RunID''  ,''_BatchID'',''Staging'' ;
Exec [common].[usp_EU_DQCheck] ''Invchead'',''EU_stg'',''Company,InvoiceNum'',''_RunID''  ,''_BatchID'',''Staging'' ;
Exec [common].[usp_EU_DQCheck] ''OrderHed'',''EU_stg'',''Company,OrderNum'',''_RunID''  ,''_BatchID'',''Staging'' ;
Exec [common].[usp_EU_DQCheck] ''UD21'',''EU_stg'',''Company,Key1,Key2,Key3,Key4,Key5'',''_RunID''  ,''_BatchID'',''Staging'' ;
Exec [common].[usp_EU_DQCheck] ''Part'',''EU_stg'',''Company,PartNum'',''_RunID''  ,''_BatchID'',''Staging'' ;
Exec [common].[usp_EU_DQCheck] ''PartTran'',''EU_stg'',''Company,SysDate,SysTime,TranNum'',''_RunID''  ,''_BatchID'',''Staging'' ;
Exec [common].[usp_EU_DQCheck] ''PODetail'',''EU_stg'',''Company,PONUM,POLine'',''_RunID''  ,''_BatchID'',''Staging'' ;
Exec [common].[usp_EU_DQCheck] ''POHeader'',''EU_stg'',''Company,PONum'',''_RunID''  ,''_BatchID'',''Staging'' ;
Exec [common].[usp_EU_DQCheck] ''PriceLst'',''EU_stg'',''Company,ListCode'',''_RunID''  ,''_BatchID'',''Staging'' ;
Exec [common].[usp_EU_DQCheck] ''PriceLstParts'',''EU_stg'',''Company,ListCode,PartNum,UOMCode'',''_RunID''  ,''_BatchID'',''Staging'' ;
Exec [common].[usp_EU_DQCheck] ''SalesRep'',''EU_stg'',''Company,Name'',''_RunID''  ,''_BatchID'',''Staging'' ;
Exec [common].[usp_EU_DQCheck] ''Vendcnt'',''EU_stg'',''Company,VendorNum,PurPoint,ConNum,SysRowID'',''_RunID''  ,''_BatchID'',''Staging'' ;
Exec [common].[usp_EU_DQCheck] ''Vendor'',''EU_stg'',''Company,VendorNum'',''_RunID''  ,''_BatchID'',''Staging'' ;', 1, N'Staging,DupCheck', N'Completed')
GO
INSERT [common].[EU_ValidationControlTable] ([ID], [MeasureName], [SourceConnection], [SourceQuery], [TargetConnection], [TargetQuery], [IsActive], [Tag], [Status]) VALUES (3, N'All_RowCounts', N'TGT_AzureSQLConnection', N'Select count(*) as MeasureValue , ''Customer'' as MeasureName from EU_STG.Customer  Union all Select count(*) as MeasureValue , ''Part'' as MeasureName from EU_STG.Part', N'TGT_AzureSQLConnection', N'Select count(*) as MeasureValue , ''Customer'' as MeasureName from dbo.EU_DImCustomer  Union all Select count(*) as MeasureValue , ''Part'' as MeasureName from dbo.EU_DimProduct', 1, N'Mart', N'Completed')
GO
SET IDENTITY_INSERT [common].[EU_ValidationControlTable] OFF
GO
SET IDENTITY_INSERT [config].[EU_Connection] ON 
GO
INSERT [config].[EU_Connection] ([ConnectionKey], [ConnectionFriendlyName], [ConnectionParam], [ConnectionType]) VALUES (2, N'TGT_AzureSQLConnection', N'{   "ServerName": "flex-sqlserver-datadev.database.windows.net",   "DatabaseName": "flex-sqldb-datadev",   "UserName": "sqladmin",   "AKVSecretName": "AzSQLPassword"  }', N'AzureSQL')
GO
INSERT [config].[EU_Connection] ([ConnectionKey], [ConnectionFriendlyName], [ConnectionParam], [ConnectionType]) VALUES (3, N'STG_OnPremConnection', N'{   "ServerName": "10.100.10.203",   "DatabaseName": "EpicorERP",   "UserName": "crystal2",   "AKVSecretName": "OnPremSQLPasswordEU"  }', N'OnPremSQL')
GO
SET IDENTITY_INSERT [config].[EU_Connection] OFF
GO



Update [EU_Connection]
Set [ConnectionParam] = '{   "ServerName": "flex-sqlserver-dataprd.database.windows.net",   "DatabaseName": "flex-sqldb-dataprd",   "UserName": "sqladmin",   "AKVSecretName": "AzSQLPassword"  }'
where ConnectionFriendlyName = 'TGT_AzureSQLConnection'

GO

Print('Schema and control Table Data Population Successfully Completed')


Go
