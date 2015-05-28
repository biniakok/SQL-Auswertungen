
  Select 
  ffsh.[Ship-to Post Code] as PLZ
  ,cdh.[Order Created at] as Bestell_Uhrzeit
  , case when cast(cdh.[Order Created at] as time) between '00:00' and '14:59' then 1 else 0 end as Zwischen00_15
  , case when cast(cdh.[Order Created at] as time) between '15:00' and '23:59' then 1 else 0 end as Zwischen15_00
  ,CAST(FLOOR(CAST(cdh.[Order Created at] AS FLOAT)) + (FLOOR((CAST(cdh.[Order Created at] AS FLOAT) - FLOOR(CAST(cdh.[Order Created at] AS FLOAT))) * 24.0) + (3.0/86400000.0)) / 24.0 AS DATETIME) as Untergrenze
  ,CAST(ceiling(CAST(cdh.[Order Created at] AS FLOAT)) + (ceiling((CAST(cdh.[Order Created at] AS FLOAT) - ceiling(CAST(cdh.[Order Created at] AS FLOAT))) * 24.0) + (3.0/86400000.0)) / 24.0 AS DATETIME) as Obergrenze
  ,ffsh.[No_] as AuftragsNr
  ,ffsh.[External Document No_] as Externe_Belegnummer
     FROM [Urban_NAV600_SL].[dbo].[Urban-Brand GmbH$eBayFFSalesHeader] ffsh with (nolock)
	join [Urban_NAV600_SL].[dbo].[Urban-Brand GmbH$CreateDocumentHeader] cdh 
		on cdh.[ExternalDocumentNo]=ffsh.[External Document No_]
	join [Urban_NAV600_SL].[dbo].[Urban-Brand GmbH$Country_Region] cr with (nolock)
		on cr.[Code]=ffsh.[Ship-to Country_Region Code]
	where ffsh.[Location Code]='BER_FIEGE'
	and ffsh.[Type]=0
	and ffsh.[Ship-to Country_Region Code]='IT'
	and ffsh.[Order Date]>='2014-01-01'
	and ffsh.[Order Date]<='2014-12-31'
	group by 
    ffsh.[No_] 
  ,ffsh.[Ship-to Post Code]
  ,cdh.[Order Created at] 
  ,ffsh.[External Document No_]
	




Select	
  ffsh.[Ship-to Post Code] as PLZ
 
  , sum(case when cast(cdh.[Order Created at] as time) between '00:00' and '14:59' then 1 else 0 end) as Zwischen00_15
  , sum(case when cast(cdh.[Order Created at] as time) between '15:00' and '23:59' then 1 else 0 end) as Zwischen15_00
       FROM [Urban_NAV600_SL].[dbo].[Urban-Brand GmbH$eBayFFSalesHeader] ffsh with (nolock)
	join [Urban_NAV600_SL].[dbo].[Urban-Brand GmbH$CreateDocumentHeader] cdh 
		on cdh.[ExternalDocumentNo]=ffsh.[External Document No_]
	join [Urban_NAV600_SL].[dbo].[Urban-Brand GmbH$Country_Region] cr with (nolock)
		on cr.[Code]=ffsh.[Ship-to Country_Region Code]
	where ffsh.[Location Code]='BER_FIEGE'
	and ffsh.[Type]=0
	and ffsh.[Ship-to Country_Region Code]='DE'
	and ffsh.[Order Date]>='2014-10-01'
	and ffsh.[Order Date]<='2014-12-31'
	group by 
    ffsh.[Ship-to Post Code]
  
	
	