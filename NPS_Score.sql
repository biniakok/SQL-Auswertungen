with
rowdaten as
(SELECT
cast([last_update] as date) as Datum
,vkr as VKR
,score as Punktzahl
,Kommentar as Kommenatr
,case 
     when [score] in ('10','9') then 2
	 when [score] in ('7','8') then 1
	 when [score] in ('0','1','2','3','4','5','6') then 0
	 end as NPS
--,sum(NPS-1)*100/count(NPS) as rel_NPS
  FROM [MAG_BI_Import].[dbo].[mage_nps]
  where last_update >= '2015-03-01'
  and [Reason Code]= 'WINDELN_DE'
 )
SELECT Datum
		, SUM(r.NPS-1) * 100 / COUNT(r.NPS) as Net_Promoter_Score
		, COUNT(r.NPS) as Anzahl_NPS
		--where count(r.NPS)>30
FROM rowdaten r
GROUP BY Datum
order by Datum



SELECT *
FROM [MAG_BI_Import].[dbo].[mage_nps]
where last_update >= '2015-04-13' and [Reason Code] = 'WINDELN_DE'
order by
last_update desc
