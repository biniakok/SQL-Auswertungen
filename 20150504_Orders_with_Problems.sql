/****** Script for SelectTopNRows command from SSMS ******/
SELECT count ( distinct No_) as Anzahl_Aufträge
,[Reason Code]
FROM [urban_NAV600_SL].[dbo].[Urban-Brand GmbH$Sales Header]
Where [Fulfillment Comment] != 'Bestandsproblem' 
AND [Reason Code] in ('WINDELN_DE','WINDELN_CH') 
AND [Payment Method Code] != 'VORKASSE' 
AND [Document Type] = 1
group by [Reason Code]



Select 
No_ as Aufträge
,[Reason Code] as ReasonCode
,[Payment Method Code] as Zahlungsmethode
FROM [urban_NAV600_SL].[dbo].[Urban-Brand GmbH$Sales Header]
Where [Fulfillment Comment] != 'Bestandsproblem' 
AND [Reason Code] in ('WINDELN_DE','WINDELN_CH') 
AND [Payment Method Code] not in ('VORKASSE','VORKHYPO') 
AND [Document Type] = 1