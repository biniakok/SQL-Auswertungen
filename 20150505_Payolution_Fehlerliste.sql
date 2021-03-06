/****** Skript für SelectTopNRows-Befehl aus SSMS ******/

  Select 
  p.[Source No_] as Verkaufsrechnung
  ,p.[Shop Code] as Shop
  ,pr.[Generated at] as Zeitstempel
  ,case when BI_Data.dbo.networkdays_dec(pr.[Generated at],getdate())<=1 then 1 else 0 end as bis_1
 ,case when BI_Data.dbo.networkdays_dec(pr.[Generated at],getdate())>1 and BI_Data.dbo.networkdays_dec(pr.[Generated at],getdate())<=2  then 1 else 0 end as zwischen_1_bis_2
 ,case when BI_Data.dbo.networkdays_dec(pr.[Generated at],getdate())>2 then 1 else 0 end as grösser_2

  from [Urban_NAV600_SL].[dbo].[Urban-Brand GmbH$Payment] p
  join [Urban_NAV600_SL].[dbo].[Urban-Brand GmbH$PaymentResponse] pr
	on p.[Entry No_]=pr.[Entry No_]
	where p.[Payment Method Code]='PAYOLUTION'
	and pr.[Is Error]=1
	and p.[manually processed]<>1
	


	Select 
   p.[Shop Code] as Shop
  ,count(distinct p.[Source No_]) as Verkaufsrechnung
  --,pr.[Generated at] as Zeitstempel
  ,sum(case when BI_Data.dbo.networkdays_dec(pr.[Generated at],getdate())<=1 then 1 else 0 end) as bis_1
 ,sum(case when BI_Data.dbo.networkdays_dec(pr.[Generated at],getdate())>1 and BI_Data.dbo.networkdays_dec(pr.[Generated at],getdate())<=2  then 1 else 0 end) as zwischen_1_bis_2
 ,sum(case when BI_Data.dbo.networkdays_dec(pr.[Generated at],getdate())>2 then 1 else 0 end) as grösser_2

  from [Urban_NAV600_SL].[dbo].[Urban-Brand GmbH$Payment] p
  join [Urban_NAV600_SL].[dbo].[Urban-Brand GmbH$PaymentResponse] pr
	on p.[Entry No_]=pr.[Entry No_]
	where p.[Payment Method Code]='PAYOLUTION'
	and pr.[Is Error]=1
	and p.[manually processed]<>1
	group by p.[Shop Code]


