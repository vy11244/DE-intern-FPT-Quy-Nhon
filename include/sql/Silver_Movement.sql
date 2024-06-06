CREATE OR REPLACE TABLE MOVEMENT.MOVEMENT_SILVER.MOVEMENT (
    MOVEMENTKEY int identity(1,1),
    DATEKEY DATE,
    STOCKITEMKEY VARCHAR(50),
    CUSTOMERKEY VARCHAR(50),
    SUPPLIERKEY VARCHAR(50),
    TRANSACTIONTYPEKEY VARCHAR(50),
    WWISTOCKITEMTRANSACTIONID NUMBER,
    WWIINVOICEID NUMBER,
    WWIPURCHASEORDERID NUMBER,
    QUANTITY NUMBER,
    LINEAGEKEY INT DEFAULT NULL,
    PRIMARY KEY (MOVEMENTKEY)
);

INSERT INTO MOVEMENT.MOVEMENT_SILVER.MOVEMENT (
    DATEKEY,
    STOCKITEMKEY,
    CUSTOMERKEY,
    SUPPLIERKEY,
    TRANSACTIONTYPEKEY,
    WWISTOCKITEMTRANSACTIONID,
    WWIINVOICEID,
    WWIPURCHASEORDERID,
    QUANTITY
)
SELECT 
    A.LASTEDITEDWHEN AS MOVEMENT_DATE, 
    si.STOCKITEMKEY AS STOCKITEMKEY, 
    c.CUSTOMERKEY AS CUSTOMERKEY,
    s.SUPPLIERKEY AS SUPPLIERKEY,
    tt.TRANSACTIONTYPEKEY AS TRANSACTIONTYPEKEY, 
    A.STOCKITEMTRANSACTIONID AS WWISTOCKITEMTRANSACTIONID, 
    A.INVOICEID AS WWIINVOICEID, 
    A.PURCHASEORDERID AS WWIPURCHASEORDERID, 
    A.QUANTITY AS QUANTITY
FROM MOVEMENT.MOVEMENT_BRONZE.STOCKITEMTRANSACTIONS AS A
LEFT JOIN MOVEMENT.MOVEMENT_SILVER.CUSTOMER AS c ON c.WWICUSTOMERID = A.CUSTOMERID 
    AND A.LASTEDITEDWHEN > c.VALIDFROM
    AND A.LASTEDITEDWHEN <= c.VALIDTO
LEFT JOIN MOVEMENT.MOVEMENT_SILVER.STOCKITEM AS si ON si.WWISTOCKITEMID = A.STOCKITEMID
    AND A.LASTEDITEDWHEN > si.VALIDFROM
    AND A.LASTEDITEDWHEN <= si.VALIDTO
LEFT JOIN MOVEMENT.MOVEMENT_SILVER.TRANSACTIONTYPES AS tt ON tt.WWITRANSACTIONTYPEID = A.TRANSACTIONTYPEID
    AND A.LASTEDITEDWHEN > tt.VALIDFROM
    AND A.LASTEDITEDWHEN <= tt.VALIDTO
LEFT JOIN MOVEMENT.MOVEMENT_SILVER.SUPPLIER AS s ON s.WWISUPPLIERID = A.SUPPLIERID 
    AND A.LASTEDITEDWHEN > s.VALIDFROM
    AND A.LASTEDITEDWHEN <= s.VALIDTO
ORDER BY CUSTOMERKEY;


DELETE FROM MOVEMENT.MOVEMENT_SILVER.MOVEMENT