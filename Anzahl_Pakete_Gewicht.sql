Select 
    ffsh.[Ship-to Country_Region Code]
  ,cr.[Name]
  ,ffsh.[Ship-to Post Code] as PLZ
  ,ffsh.[Shipping Agent Code]
  ,count(distinct p.[T&T-ID]) as Anzahl_Pakete
  ,cast(sum(ffsl.[Quantity]*ofm.[Volumen_L]) as decimal(10,2)) as GesamtVolumen 
      ,cast(sum(p.Weight) as decimal (10,2)) as Gesamtgewicht
  
 FROM [Urban_NAV600_SL].[dbo].[Urban-Brand GmbH$eBayFFSalesHeader] ffsh 
	join [Urban_NAV600_SL].[dbo].[Urban-Brand GmbH$eBayFFSalesLine] ffsl  
	    on (ffsh.[No_]=ffsl.[Document No_] and ffsh.[Entry No_]=ffsl.[Document Entry No_]) 
	join [BI_Data].[dbo].[OPS_Fiege_Morphologie] ofm 
	    on ofm.[EAN]=ffsl.[No_] collate Latin1_General_CI_AS
		join [Urban_NAV600_SL].[dbo].[Urban-Brand GmbH$Country_Region] cr
	 on ffsh.[Ship-to Country_Region Code]=cr.[Code] collate Latin1_General_CI_AS
	join [Urban_NAV600_SL].[dbo].[Urban-Brand GmbH$eBayParcel] p
		on ffsh.[No_]=p.[Order No_] collate Latin1_General_CI_AS

	where ffsh.[Location Code]='BER_FIEGE'
	and ffsh.[Entry No_] = 1
		and ffsh.[Order Date]>='2014-10-01'
	and ffsh.[Order Date]<='2014-12-31'
	--and ffsh.[Ship-to Post Code]='14979'
	and ffsh.[Shipping Agent Code]='DHL' 
	group by 
    ffsh.[Ship-to Post Code],ffsh.[Ship-to Country_Region Code],cr.[Name],ffsh.[Shipping Agent Code]
	order by ffsh.[Ship-to Post Code]



  