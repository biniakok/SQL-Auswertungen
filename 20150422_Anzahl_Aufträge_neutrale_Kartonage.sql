with
neutral as
(
select
distinct ffsl.[Document No_] as Auftrgasnummer
,p.[T&T-Id] as Sendungsnummer
,ffsl.[Description] as Kartonbeschreibung
,cast(ffsl.[Shipment Date] as date) as WA_Datum
from [Urban_NAV600_SL].[dbo].[Urban-Brand GmbH$eBayParcel] p
join  [Urban_NAV600_SL].[dbo].[Urban-Brand GmbH$eBayFFSalesLine] ffsl
	on p.[Order No_]=ffsl.[Document No_]
	where ffsl.[Shipment Date]>='2015-01-01'
	and ffsl.[Shipment Date]<=getdate()
	--and ffsl.[Document Entry No_]=1
	and ffsl.[Location Code]='BER_FIEGE'
	and ffsl.[Type]=3
	and ffsl.[Description] like '%Karton'
	and ffsl.[No_]='R000000003' 
	
	group by ffsl.[Document No_], p.[T&T-Id], ffsl.[Description],cast(ffsl.[Shipment Date] as date) 
--order by cast(ffsl.[Shipment Date] as date),ffsl.[Document No_] 
)
select 
month(neutral.WA_Datum) as Monatszahl
,datename(mm,neutral.WA_Datum) as Monat
,count(distinct neutral.Auftrgasnummer)
from neutral
group by month(neutral.WA_Datum),datename(mm,neutral.WA_Datum)
order by month(neutral.WA_Datum)