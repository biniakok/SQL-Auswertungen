with 
top_adresse as
(
Select 
  ffsh.[Ship-to Post Code] as PLZ
 
 
  ,ffsh.[Ship-to Address] as Adresse
  ,ffsh.[Ship-to City] as Stadt  
  ,count(p.[T&T-Id]) as Anzahl_Pakete 
	 
 FROM [Urban_NAV600_SL].[dbo].[Urban-Brand GmbH$eBayFFSalesHeader] ffsh 
	join [Urban_NAV600_SL].[dbo].[Urban-Brand GmbH$eBayParcel] p
		on ffsh.[No_]=p.[Order No_]
	where ffsh.[Location Code]='BER_FIEGE'
	and ffsh.[Type]=1
	and ffsh.[Order Date]>='2014-10-01'
	and ffsh.[Order Date]<='2015-01-31'
	group by 
   ffsh.[Ship-to Post Code]
    ,ffsh.[Ship-to Address] 
  ,ffsh.[Ship-to City]


)
Select top 1000
top_adresse.PLZ
,top_adresse.Adresse
,top_adresse.Stadt
,sum(top_adresse.Anzahl_Pakete) as Summe_Pakete
from top_adresse
group by 
top_adresse.PLZ
,top_adresse.Adresse
,top_adresse.Stadt 
order by sum(top_adresse.Anzahl_Pakete) desc
	 




 