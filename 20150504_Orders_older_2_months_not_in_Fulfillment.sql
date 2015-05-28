
/*Orders older 2 months not in Fulfillment*/

SELECT count ( distinct sh.No_)
  FROM [Urban_NAV600_SL].[dbo].[Urban-Brand GmbH$Sales Header] as sh with (NOLOCK)
  Where datediff(day,sh.[Order Date],GETDATE()) > 60 and sh.[Document Type] = 1
 
SELECT sh.[Reason Code] 
,Month(sh.[Order Date]) as Monatszahl
,count ( distinct sh.No_) as Anzahl_aufträge 
  FROM [Urban_NAV600_SL].[dbo].[Urban-Brand GmbH$Sales Header] as sh with (NOLOCK)
  Where datediff(day,sh.[Order Date],GETDATE()) > 60 and sh.[Document Type] = 1
  Group by sh.[Reason Code], Month(sh.[Order Date])
  order by sh.[Reason Code], Month(sh.[Order Date])

  SELECT  
  sh.No_ as Aufträge
  ,cast (sh.[Order Date] as Date) as Datum
  --,year(sh.[Order Date]) as Jahr
  --,month(sh.[Order Date]) as Monatszahl
  ,datename(month,sh.[Order Date]) as Monat 
  ,sh.[Reason Code]
  FROM [Urban_NAV600_SL].[dbo].[Urban-Brand GmbH$Sales Header] as sh with (NOLOCK)
  Where datediff(day,sh.[Order Date],GETDATE()) > 60 and sh.[Document Type] = 1
  order by sh.[Order Date] asc