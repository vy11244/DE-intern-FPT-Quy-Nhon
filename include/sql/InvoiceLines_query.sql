SELECT [InvoiceLineID]
      ,[InvoiceID]
      ,[StockItemID]
      ,[Description]
      ,[PackageTypeID]
      ,[Quantity]
      ,[UnitPrice]
      ,[TaxRate]
      ,[TaxAmount]
      ,[LineProfit]
      ,[ExtendedPrice]
      ,[LastEditedBy]
      ,CAST([LastEditedWhen] AS VARCHAR(30)) AS [LastEditedWhen] 
FROM {table_name};