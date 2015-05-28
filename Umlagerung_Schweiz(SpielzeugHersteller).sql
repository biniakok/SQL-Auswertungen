Select 
  cast(sh.[Order Date] as date) as Datum
  ,cast(sl.[Quantity] as Int) as Menge
  ,sh.[No_] as AuftrgsNr
  ,sl.[No_] as ArtikelNr
  ,i.[Vendor No_] as KreditorenNr
  ,cast(sl.[Unit Cost (LCY)] as Decimal(10,2)) as EK_Warenwert
  , i.[attribute 2]

  FROM [Urban_NAV600_SL].[dbo].[Urban-Brand GmbH$eBayFFSalesHeader] sh
	join [Urban_NAV600_SL].[dbo].[Urban-Brand GmbH$eBayFFSalesLine] sl
		on (sh.No_=sl.[Document No_] and sh.[Entry No_]=sl.[Document Entry No_])
		join [Urban_NAV600_SL].[dbo].[Urban-Brand GmbH$Item] i
		on sl.[No_]=i.[No_]
where  cast(sh.[Order Date] as date) between '2014-11-01' and '2014-12-31'
and sh.[Sell-to Customer No_]='D1563736'
and sh.[Location Code]='BER_FIEGE'
and sh.[Type]=1
and (i.[Attribute 2] between 'B00' and 'B43' or i.[Attribute 2] between '175' and '179')
order by cast(sh.[Order Date] as date)
