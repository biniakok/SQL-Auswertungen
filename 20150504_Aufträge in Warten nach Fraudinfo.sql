/*Aufträge in Warten nach Fraudinfo*/

SELECT
FraudInfo /*, [Shop Payment Method Code]*/
,COUNT (sh.No_) AS NumberofOrders
FROM
[urban_NAV600_SL].[dbo].[Urban-Brand GmbH$eBayNavCSalesHeader] AS sh
WHERE
sh.Status = '0' /*Unbearbeitet*/
GROUP BY
FraudInfo 
--, [Shop Payment Method Code]
ORDER BY
COUNT (sh.No_) DESC



SELECT
FraudInfo /*, [Shop Payment Method Code]*/
,sh.No_ AS Aufträge
FROM
[urban_NAV600_SL].[dbo].[Urban-Brand GmbH$eBayNavCSalesHeader] AS sh
WHERE
sh.Status = '0' /*Unbearbeitet*/



