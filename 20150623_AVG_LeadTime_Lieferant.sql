with
cte1 as(
Select cte1.KreditorenNr
  ,cte1.KreditorName
  ,cte1.LänderCode
  ,cte1.Beschaffungszeit
    --,cte1.Bestellnummer
  --,cte1.EntryNo
  --,cte1.Bestelldatum
  ,cast(avg(cte1.Lieferdauer) as decimal(10,2)) as Durchschnittliche_Lieferzeit
  ,count(distinct cte1.Bestellnummer) as Anzahl_Bestellnummer_Gesamt
  from
  (SELECT 
 ffph.[Buy-from Vendor No_] as KreditorenNr
 ,v.[Name] as KreditorName
 ,v.[Country_Region Code] as LänderCode
,ffph.[No_] as Bestellnummer
,ffph.[Entry No_] as EntryNo
,cast(ffph.[Order Date] as date) as Bestelldatum
,cast(datediff(hour,ffph.[Order Date],ffph.[Posting Date]) as decimal(10,2))/24 as Lieferdauer
,v.[Lead Time Calculation] as Beschaffungszeit
,ROW_NUMBER() OVER ( PARTITION BY ffph.[No_] ORDER BY cast(datediff(hour,ffph.[Order Date],ffph.[Posting Date]) as decimal(10,2))/24 ) as seq
  FROM [Urban_NAV600_SL].[dbo].[Urban-Brand GmbH$eBayFFPurchaseHeader] ffph
  join [Urban_NAV600_SL].[dbo].[Urban-Brand GmbH$Vendor] v
  on v.[No_]=ffph.[Buy-from Vendor No_]
  where ffph.[Document Type]=1
  --and ffph.[Pay-to Name] not like '%Urban Brand GmbH%'
  and ffph.[Location Code]='BER_FIEGE'
  and cast(ffph.[Order Date] as date)>='2014-01-01'
  and ffph.[Type]=1
  --and cast(ffph.[Order Date] as date)<='2015-05-31'
  group by ffph.[Buy-from Vendor No_],v.[Name],ffph.[No_],ffph.[Order Date], ffph.[Posting Date],ffph.[Entry No_],v.[Lead Time Calculation],v.[Country_Region Code]) as cte1
 where cte1.seq=1
  group by cte1.KreditorenNr,cte1.KreditorName,cte1.LänderCode,cte1.Beschaffungszeit),
  cte2 as(
  Select 
  cte2.KreditorenNr
  --,cte2.KreditorName
  ,cast(avg(cte2.Lieferdauer) as decimal(10,2)) as Moving_Average_3Monate
  --,cte2.Beschaffungszeit
  ,count(distinct cte2.Bestellnummer) as Anzahl_Bestellnummer_MA
  from 
  (
SELECT 
 ffph.[Buy-from Vendor No_] as KreditorenNr
 ,ffph.[Pay-to Name] as KreditorName
,ffph.[No_] as Bestellnummer
,ffph.[Entry No_]
,cast(ffph.[Order Date] as date) as Bestelldatum
,cast(datediff(hour,ffph.[Order Date],ffph.[Posting Date]) as decimal(10,2))/24 as Lieferdauer
,ffph.[Lead Time Calculation] as Beschaffungszeit
,ROW_NUMBER() OVER ( PARTITION BY ffph.[No_] ORDER BY cast(datediff(hour,ffph.[Order Date],ffph.[Posting Date]) as decimal(10,2))/24 ) as seq
  FROM [Urban_NAV600_SL].[dbo].[Urban-Brand GmbH$eBayFFPurchaseHeader] ffph
  where ffph.[Document Type]=1
  --and ffph.[Pay-to Name] not like '%Urban Brand GmbH%'
  and ffph.[Location Code]='BER_FIEGE'
  and cast(ffph.[Order Date] as date)>='2014-01-01'
  and ffph.[Type]=1
  --and cast(ffph.[Order Date] as date)<='2015-05-31'
  group by ffph.[Buy-from Vendor No_],ffph.[Pay-to Name],ffph.[No_],ffph.[Order Date], ffph.[Posting Date],ffph.[Entry No_],ffph.[Lead Time Calculation]) as cte2
   where cte2.Bestelldatum between dateadd(month,-3,getdate()) and cte2.Bestelldatum
  and cte2.seq=1
  group by cte2.KreditorenNr)
  Select cte1.*
  ,cte2.Moving_Average_3Monate
  ,cte2.Anzahl_Bestellnummer_MA
  from cte1
  left join cte2
  on cte1.KreditorenNr=cte2.KreditorenNr
 






 