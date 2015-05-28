with
trans_fiege as
(
select 
  BI_Data.dbo.ToUTCDate(ffp.[Timestamp Upload_Download]) as Zeitstempel
  ,sh.[No_] as Aufträge
  ,sh.[File No_]
  ,sh.[Shipping Agent Service Code] as Transportcode
  --,dateadd(dd,0,getdate()) as Now
  --,dateadd(hh, 15, cast(dateadd(dd, -1, cast(dateadd(dd,0,BI_Data.dbo.ToUTCDate(ffp.[Timestamp Upload_Download])) as date)) as datetime)) as Von_15_Uhr_Vortag
  --,dateadd(hh, 15,cast(cast(dateadd(dd,0,BI_Data.dbo.ToUTCDate(ffp.[Timestamp Upload_Download])) as date) as datetime)) as Bis_15_Uhr_Tag
  --,dateadd(hh, 6,cast(cast(dateadd(dd,0,BI_Data.dbo.ToUTCDate(ffp.[Timestamp Upload_Download])) as date) as datetime)) as Bis_6
  --,dateadd(hh, 10,cast(cast(dateadd(dd,0,BI_Data.dbo.ToUTCDate(ffp.[Timestamp Upload_Download])) as date) as datetime)) as Bis_10
  --,dateadd(hh, 14,cast(cast(dateadd(dd,0,BI_Data.dbo.ToUTCDate(ffp.[Timestamp Upload_Download])) as date) as datetime)) as Bis_14
 ,cast (
			case 
				when cast (BI_DATA.dbo.ToUTCDate(ffp.[Timestamp Upload_Download]) as time) > '15:00' 
					then dateadd(dd, 1, BI_DATA.dbo.ToUTCDate(ffp.[Timestamp Upload_Download])) 
					else BI_DATA.dbo.ToUTCDate(ffp.[Timestamp Upload_Download]) end as date) as Uebertragen_am 
 
 , case 
			when (BI_DATA.dbo.ToUTCDate(ffp.[Timestamp Upload_Download]) > dateadd(hh, 15, cast(dateadd(dd, -1, cast(dateadd(dd,0,BI_Data.dbo.ToUTCDate(ffp.[Timestamp Upload_Download])) as date)) as datetime)) and BI_DATA.dbo.ToUTCDate(ffp.[Timestamp Upload_Download]) <= dateadd(hh, 6,cast(cast(dateadd(dd,0,BI_Data.dbo.ToUTCDate(ffp.[Timestamp Upload_Download])) as date) as datetime))) then 6
			when (BI_DATA.dbo.ToUTCDate(ffp.[Timestamp Upload_Download])  > dateadd(hh, 6,cast(cast(dateadd(dd,0,BI_Data.dbo.ToUTCDate(ffp.[Timestamp Upload_Download])) as date) as datetime)) and BI_DATA.dbo.ToUTCDate(ffp.[Timestamp Upload_Download])  <= dateadd(hh, 10,cast(cast(dateadd(dd,0,BI_Data.dbo.ToUTCDate(ffp.[Timestamp Upload_Download])) as date) as datetime))) then 10
			when (BI_DATA.dbo.ToUTCDate(ffp.[Timestamp Upload_Download])  > dateadd(hh, 10,cast(cast(dateadd(dd,0,BI_Data.dbo.ToUTCDate(ffp.[Timestamp Upload_Download])) as date) as datetime)) and BI_DATA.dbo.ToUTCDate(ffp.[Timestamp Upload_Download]) <= dateadd(hh, 14,cast(cast(dateadd(dd,0,BI_Data.dbo.ToUTCDate(ffp.[Timestamp Upload_Download])) as date) as datetime))) then 14
			when (BI_DATA.dbo.ToUTCDate(ffp.[Timestamp Upload_Download])  > dateadd(hh, 14,cast(cast(dateadd(dd,0,BI_Data.dbo.ToUTCDate(ffp.[Timestamp Upload_Download])) as date) as datetime)) and BI_DATA.dbo.ToUTCDate(ffp.[Timestamp Upload_Download]) <= dateadd(hh, 15,cast(cast(dateadd(dd,0,BI_Data.dbo.ToUTCDate(ffp.[Timestamp Upload_Download])) as date) as datetime))) then 15
		else 0 end as Gruppe
    from [Urban_NAV600_SL].[dbo].[Urban-Brand GmbH$eBayFFSalesHeader] sh with (nolock)
   join [Urban_NAV600_SL].[dbo].[Urban-Brand GmbH$eBayFFProtocol] ffp with (nolock)
	on sh.[File No_]=ffp.[File No_] collate Latin1_General_CI_AS
	where left(sh.[File No_],2)='A6'
	and BI_Data.dbo.ToUTCDate(ffp.[Timestamp Upload_Download]) >= '2015-04-30 15:00:00:000'
	
	),
	verladen as
	(Select 
      cast(ffsh.[Posting Date] as date) as Datum
   , count(distinct ffsh.[No_]) as Anzahl_Aufträge
        FROM [Urban_NAV600_SL].[dbo].[Urban-Brand GmbH$eBayFFSalesHeader] ffsh with (nolock)
	join [Urban_NAV600_SL].[dbo].[Urban-Brand GmbH$eBayFFProtocol] ffp with (nolock)
		on ffsh.[File No_]=ffp.[File No_] collate Latin1_General_CI_AS
	where ffsh.[Location Code]='BER_FIEGE'
	and cast(ffsh.[Posting Date] as date)>= '2015-05-01' 
	and ffsh.[Type]=1 /*Rückmeldung*/
	group by cast(ffsh.[Posting Date] as date)
	)
 select 
 tf.Uebertragen_am
	, sum (case when (tf.Gruppe='0' or tf.Gruppe='6')  then 1 else 0 end) as Bis_6
	,sum (case when tf.Gruppe='10' then 1 else 0 end) as Bis_10
	,sum (case when  tf.Gruppe='14' then 1 else 0 end) as Bis_14
	,sum (case when tf.Gruppe='15' then 1 else 0 end) as Bis_15
	,sum (case when tf.Gruppe in ('0','6','10','14','15') then 1 else 0 end) as Gesamt_IST
	,ffh.Forecast as Gesamt_Soll
	, cast(sum(case when tf.Gruppe in ('0','6','10','14','15')  then 1 else 0 end) / ffh.Forecast * 100 as decimal(10,2)) as Prozent_v_Forecast
	, cast (sum(case when (tf.Gruppe='0' or tf.Gruppe='6')  then 1 else 0 end) * 1.00 / sum(case when tf.Gruppe in ('0','6','10','14','15')  then 1 else 0 end) * 100 as decimal (10,2)) as Vert_6
	, cast (sum(case when tf.Gruppe in ('0','6','10') then 1 else 0 end) * 1.00 / sum(case when tf.Gruppe in ('0','6','10','14','15')  then 1 else 0 end) * 100 as decimal (10,2)) as Vert_10
	, cast (sum(case when tf.Gruppe in ('0','6','10','14') then 1 else 0 end) * 1.00 / sum(case when tf.Gruppe in ('0','6','10','14','15') then 1 else 0 end) * 100 as decimal (10,2)) as Vert_14
	, cast (sum(case when tf.Gruppe in ('0','6','10','14','15') then 1 else 0 end) * 1.00 / sum(case when tf.Gruppe in ('0','6','10','14','15') then 1 else 0 end) * 100 as decimal (10,2)) as Vert_15
	, isnull(v.Anzahl_Aufträge,0) as Verladen
	 from trans_fiege tf with (nolock)
 join BI_Data.dbo.ForecastFiege_History ffh with (nolock)
	on ffh.[Date]=tf.Uebertragen_am 
left join verladen v
	on v.Datum=tf.Uebertragen_am 
where tf.Uebertragen_am >='2015-05-01'
 group by tf.Uebertragen_am, ffh.Forecast, v.Anzahl_Aufträge
 order by tf.Uebertragen_am