(SELECT [PersonID]
      ,[FullName]
      ,[PreferredName]
      ,[SearchName]
      ,[IsPermittedToLogon]
      ,[LogonName]
      ,[IsExternalLogonProvider]
      ,[HashedPassword]
      ,[IsSystemUser]
      ,[IsEmployee]
      ,[IsSalesPerson]
      ,[UserPreferences]
      ,[PhoneNumber]
      ,[FaxNumber]
      ,[EmailAddress]
      ,[Photo]
      ,[CustomFields]
      ,[OtherLanguages]
      ,[LastEditedBy]
      ,CAST([ValidFrom] AS VARCHAR(30)) AS ValidFrom
      ,CAST([ValidTo] AS VARCHAR(30)) AS ValidTo
FROM [WideWorldImporters].[Application].[People_Archive]
WHERE ValidFrom <> ValidTo)
union all
(SELECT [PersonID]
      ,[FullName]
      ,[PreferredName]
      ,[SearchName]
      ,[IsPermittedToLogon]
      ,[LogonName]
      ,[IsExternalLogonProvider]
      ,[HashedPassword]
      ,[IsSystemUser]
      ,[IsEmployee]
      ,[IsSalesPerson]
      ,[UserPreferences]
      ,[PhoneNumber]
      ,[FaxNumber]
      ,[EmailAddress]
      ,[Photo]
      ,[CustomFields]
      ,[OtherLanguages]
      ,[LastEditedBy]
      ,CAST([ValidFrom] AS VARCHAR(30)) AS ValidFrom
      ,CAST([ValidTo] AS VARCHAR(30)) AS ValidTo
  FROM [WideWorldImporters].[Application].[People]
  WHERE ValidFrom <> ValidTo)