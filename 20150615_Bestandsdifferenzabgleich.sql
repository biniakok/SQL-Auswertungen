
/*Negative Differenz*/
select 
   fi.[Item No_] as EAN
	   ,it.[Description] as Beschreibung
	   ,it.[Description 2] as Beschreibung2
	   ,cast(fi.[Reporting Date] as date) as Datum
      ,cast(fi.[Qty_ (Phys_ Inventory)] as int) as Fiege_Menge
      ,cast(fi.[Quantity] as int) as Differenz
      ,cast(fi.[Qty_ at Creation (Calculated)] as int) as Navision_Menge
  FROM [Urban_NAV600_SL].[dbo].[Urban-Brand GmbH$Fulfillment Inventory] fi
	 join [Urban_NAV600_SL].[dbo].[Urban-Brand GmbH$Item] it
		on fi.[Item No_]=it.[No_]
  where fi.[Reporting Date] = '2015-07-07'
  --and it.[Attribute 2]='201'
  and fi.[Quantity]<0.00
  --and cast(fi.[Qty_ at Creation (Calculated)] as int)<0
  and fi.[Fulfillment Setup Code]='BER_FIEGE'
  --order by cast(fi.[Qty_ at Creation (Calculated)] as int) asc
  order by fi.[Quantity] asc

/*Positive Differenz*/
select 
   fi.[Item No_] as EAN
	   ,it.[Description] as Beschreibung
	   ,it.[Description 2] as Beschreibung2
	   ,cast(fi.[Reporting Date] as date) as Datum
      ,cast(fi.[Qty_ (Phys_ Inventory)] as int) as Fiege_Menge
      ,cast(fi.[Quantity] as int) as Differenz
      ,cast(fi.[Qty_ at Creation (Calculated)] as int) as Navision_Menge
  FROM [Urban_NAV600_SL].[dbo].[Urban-Brand GmbH$Fulfillment Inventory] fi
	 join [Urban_NAV600_SL].[dbo].[Urban-Brand GmbH$Item] it
		on fi.[Item No_]=it.[No_]
  where fi.[Reporting Date] = '2015-06-24'
  --and it.[Attribute 2]='201'
  and fi.[Quantity]>0.00
  --and cast(fi.[Qty_ at Creation (Calculated)] as int)<0
  and fi.[Fulfillment Setup Code]='BER_FIEGE'
  order by fi.[Quantity] desc









  --Select max(fi.[Reporting Date])
  --FROM [Urban_NAV600_SL].[dbo].[Urban-Brand GmbH$Fulfillment Inventory] fi
  