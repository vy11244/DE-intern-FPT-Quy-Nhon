/*
 The query is transformed from bronze data into silver data
 Database: WideWorldImporters
 Module: Purchase 
 Contributed Bronze Table: PURCHASEORDERS, PURCHASEORDERLINES, STOCKITEMS, PACKAGETYPES
 Contributed Silver Table: SUPPLIER, STOCKITEM
 Done by: TinTT31
 Last update when: 2024-03-26
 */


-- Delete then Insert
-- Delete
DELETE
FROM PURCHASE.PURCHASE_SILVER.PURCHASE AS p
WHERE p.WWIPURCHASEORDERID IN (SELECT PURCHASEORDERID FROM PURCHASE.PURCHASE_BRONZE.PURCHASEORDERS);

-- Insert the new one
INSERT INTO PURCHASE.PURCHASE_SILVER.PURCHASE (
        DATEKEY,
        SUPPLIERKEY,
        STOCKITEMKEY,
        WWIPURCHASEORDERID,
        ORDEREDOUTERS,
        ORDEREDQUANTITY,
        RECEIVEDOUTERS,
        PACKAGE,
        ISORDERFINALIZED
    ) WITH FACT_PURCHASE AS ( -- CTE - the same withabove
        SELECT p.ORDERDATE AS DATEKEY,
            p.PURCHASEORDERID AS WWIPURCHASEORDERID,
            pol.ORDEREDOUTERS,
            (pol.ORDEREDOUTERS * si.QUANTITYPEROUTER) AS ORDEREDQUANTITY,
            pol.RECEIVEDOUTERS,
            pt.PACKAGETYPENAME AS PACKAGE,
            p.ISORDERFINALIZED,
            p.SUPPLIERID AS WWISUPPLIERID,
            pol.STOCKITEMID AS WWISTOCKITEMID,
            CASE
                WHEN pol.LASTEDITEDWHEN > p.LASTEDITEDWHEN THEN pol.LASTEDITEDWHEN
                ELSE p.LASTEDITEDWHEN
            END AS LASTMODIFIEDWHEN
        FROM PURCHASE.PURCHASE_BRONZE.PURCHASEORDERS AS p
            LEFT JOIN PURCHASE.PURCHASE_BRONZE.PURCHASEORDERLINES AS pol ON p.PURCHASEORDERID = pol.PURCHASEORDERID
            LEFT JOIN PURCHASE.PURCHASE_BRONZE.STOCKITEMS AS si ON pol.STOCKITEMID = si.STOCKITEMID
            and LASTMODIFIEDWHEN > si.validfrom
            and LASTMODIFIEDWHEN < si.validto
            LEFT JOIN PURCHASE.PURCHASE_BRONZE.PACKAGETYPES AS pt ON pol.PACKAGETYPEID = pt.PACKAGETYPEID
            and LASTMODIFIEDWHEN > pt.validfrom
            and LASTMODIFIEDWHEN < pt.validto
    ),

    -- Join with silver tables
    -- Join with SUPPLIER table
    UPDATE_SUPPLIERKEY AS (
        SELECT f.DATEKEY,
            f.WWIPURCHASEORDERID,
            f.ORDEREDOUTERS,
            f.ORDEREDQUANTITY,
            f.RECEIVEDOUTERS,
            f.PACKAGE,
            f.ISORDERFINALIZED,
            f.WWISTOCKITEMID,
            f.LASTMODIFIEDWHEN,
            s.SUPPLIERKEY
        FROM FACT_PURCHASE AS f
            LEFT JOIN PURCHASE.PURCHASE_SILVER.SUPPLIER AS s ON f.WWISUPPLIERID = s.WWISUPPLIERID
            AND f.LASTMODIFIEDWHEN > s.VALIDFROM
            AND f.LASTMODIFIEDWHEN <= s.VALIDTO

    -- Join with STOCKITEM table
    ),
    COMPLETE_FACT_PURCHASE AS (
        SELECT us.DATEKEY,
            us.WWIPURCHASEORDERID,
            us.ORDEREDOUTERS,
            us.ORDEREDQUANTITY,
            us.RECEIVEDOUTERS,
            us.PACKAGE,
            us.ISORDERFINALIZED,
            us.SUPPLIERKEY,
            si.STOCKITEMKEY
        FROM UPDATE_SUPPLIERKEY AS us
            LEFT JOIN PURCHASE.PURCHASE_SILVER.STOCKITEM AS si ON us.WWISTOCKITEMID = si.WWISTOCKITEMID
            AND us.LASTMODIFIEDWHEN > si.VALIDFROM
            AND us.LASTMODIFIEDWHEN <= si.VALIDTO
    )
    -- Select the one to insert - the final table from CTE
SELECT DATEKEY,
    SUPPLIERKEY,
    STOCKITEMKEY,
    WWIPURCHASEORDERID,
    ORDEREDOUTERS,
    ORDEREDQUANTITY,
    RECEIVEDOUTERS,
    PACKAGE,
    ISORDERFINALIZED
FROM COMPLETE_FACT_PURCHASE