(SELECT [CountryID]
      ,[CountryName]
      ,[FormalName]
      ,[IsoAlpha3Code]
      ,[IsoNumericCode]
      ,[CountryType]
      ,[LatestRecordedPopulation]
      ,[Continent]
      ,[Region]
      ,[SubRegion]
      ,[Border]
      ,[LastEditedBy]
      ,CAST([ValidFrom] AS VARCHAR(30)) AS [ValidFrom]
      ,CAST([ValidTo] AS VARCHAR(30)) AS [ValidTo]
FROM [WideWorldImporters].[Application].[Countries_Archive]
WHERE ValidFrom <> ValidTo)
union all
(SELECT [CountryID]
      ,[CountryName]
      ,[FormalName]
      ,[IsoAlpha3Code]
      ,[IsoNumericCode]
      ,[CountryType]
      ,[LatestRecordedPopulation]
      ,[Continent]
      ,[Region]
      ,[SubRegion]
      ,[Border]
      ,[LastEditedBy]
      ,CAST([ValidFrom] AS VARCHAR(30)) AS [ValidFrom]
      ,CAST([ValidTo] AS VARCHAR(30)) AS [ValidTo]
FROM [WideWorldImporters].[Application].[Countries]
WHERE ValidFrom <> ValidTo)