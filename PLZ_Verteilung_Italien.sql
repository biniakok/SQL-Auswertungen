  Select 
  ffsh.[Ship-to Post Code] as PLZ
  ,cast(ffsh.[Order Date] as date) as Auftrags_Datum
    
  ,ffsh.[No_] as AuftragsNr
  ,ffsh.[External Document No_] as Externe_Belegnummer
     FROM [Urban_NAV600_SL].[dbo].[Urban-Brand GmbH$eBayFFSalesHeader] ffsh with (nolock)
		
	where ffsh.[Location Code]='BER_FIEGE'
	and ffsh.[Type]=1
	and ffsh.[Ship-to Country_Region Code]='IT'
	and ffsh.[Order Date]>='2014-01-01'
	and ffsh.[Order Date]<='2014-12-31'
	group by 
    ffsh.[No_] 
  ,ffsh.[Ship-to Post Code]
  ,ffsh.[Order Date]
  ,ffsh.[External Document No_]
  order by cast(ffsh.[Order Date] as date)


  
	