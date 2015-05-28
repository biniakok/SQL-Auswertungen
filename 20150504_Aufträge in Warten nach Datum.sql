/*****Aufträge in Warten nach Datum*****/
SELECT
sh.[Shop Code],
COUNT (sh.No_) AS Anzahl_Aufträge,
CAST (sh.[Order Date] AS DATE) AS Auftragsdatum
FROM
[urban_NAV600_SL].[dbo].[Urban-Brand GmbH$eBayNavCSalesHeader] AS sh
WHERE
sh.Status = '0' /*Status Offen*/
GROUP BY
sh.[Shop Code],
CAST (sh.[Order Date] AS DATE)
ORDER BY
sh.[Shop Code],
CAST (sh.[Order Date] AS DATE) DESC 




SELECT
sh.[Shop Code]
,sh.No_ AS Aufträge
,CAST (sh.[Order Date] AS DATE) AS Auftragsdatum
FROM
[urban_NAV600_SL].[dbo].[Urban-Brand GmbH$eBayNavCSalesHeader] AS sh
WHERE
sh.Status = '0' /*Status Offen*/
 
