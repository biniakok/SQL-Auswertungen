
/****** orders in transfer not processed ******/
SELECT cast(max(bsl.[Transaction Date]) as DATE) as LetzergebuchterAuszug, bsl.[Bank Account No_], ba.[Name]
FROM [urban_NAV600_SL].[dbo].[Urban-Brand GmbH$Bank Account Statement Line] as bsl with (NOLOCK)
Left Join [urban_NAV600_SL].[dbo].[Urban-Brand GmbH$Bank Account] as ba with (NOLOCK) 
on ba.[No_] = bsl.[Bank Account No_]
group by bsl.[Bank Account No_], ba.[Name]
order by cast(max(bsl.[Transaction Date]) as DATE) asc
