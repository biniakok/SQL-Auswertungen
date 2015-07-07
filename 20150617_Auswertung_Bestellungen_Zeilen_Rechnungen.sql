with
cte as
(SELECT 
cast (ffph.[Posting Date] as Date) as Datum 
,ffph.[No_] as Bestellnummer
,count(distinct ffph.[File No_]) as Anzahl_DateiNr
,count(distinct ffpl.[No_]) as Bestellzeilen
,case when ffph.[Type]=0 then count(distinct ffph.[File No_]) else 0  end as Anzahl_Meldungen
,case when ffph.[Type]=1 then count(distinct ffph.[File No_]) else 0 end as Anzahl_Rückmeldungen
,case when ffph.[Type]=2 then count(distinct ffph.[File No_]) else 0 end as Anzahl_Stornos
,count(distinct pih.[Order No_]) as Anzahl_Purchase
FROM [Urban_NAV600_SL].[dbo].[Urban-Brand GmbH$eBayFFPurchaseHeader] ffph with (nolock)
join [Urban_NAV600_SL].[dbo].[Urban-Brand GmbH$eBayFFPurchaseLine] ffpl with (nolock)
	on (ffpl.[Document Entry No_] = ffph.[Entry No_] and  ffpl.[Document No_] = ffph.[No_]) 
left join [Urban_NAV600_SL].[dbo].[Urban-Brand GmbH$Purch_ Inv_ Header] pih with (nolock)
	on pih.[Order No_]=ffph.[No_] collate Latin1_General_100_CS_AS 
where cast(ffph.[Posting Date] as date) between '2014-06-01' and getdate()
and ffph.[Document Type]=1
and ffpl.[Type]=2
and ffph.[Setup Code]='BER_FIEGE'
and ffph.[Location Code]='BER_FIEGE'
group by cast (ffph.[Posting Date] as Date),ffph.[No_],ffph.[Type] 
--order by ffph.[No_],cast (ffph.[Posting Date] as Date)
)
Select
Week = cast(DateAdd(day, -1 * datepart(dw, cte.Datum), cte.Datum) as date) 
,cte.Bestellnummer
,sum(cte.Anzahl_DateiNr) as Anzahl_DateiNr
,sum(cte.Bestellzeilen) as Anzahl_Bestellzeilen
,sum(cte.Anzahl_Meldungen) as Anzahl_Meldungen
,sum(cte.Anzahl_Rückmeldungen) as Anzahl_Rückmeldungen
,sum(cte.Anzahl_Stornos) as Anzahl_Stornos
,sum(cte.Anzahl_Purchase) as Anzahl_Purchase
from cte
group by DateAdd(day, -1 * datepart(dw, cte.Datum),cte.Datum),cte.Bestellnummer
order by Week,cte.Bestellnummer




	