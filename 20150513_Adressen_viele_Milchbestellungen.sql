/****** Skript für SelectTopNRows-Befehl aus SSMS ******/


with
debitoren as
(SELECT 
  [No_] as DNR
  ,[Name] as Name
  ,[Address] as Adresse
  ,[City] as Stadt
    
  FROM [Urban_NAV600_SL].[dbo].[Urban-Brand GmbH$Customer] with (nolock)
   where ([Address] like '%allaswiesen%' and [Address] like '%18%' and [City] like '%armstadt') 
  or ([Address] like 'Oeser%' and [Address] like '%120'and [City] like '%rankfurt')
 or ([Address] like 'Münz%' and [Address] like '%5%'and [City] like '%uisburg')
  or [Address] like '%Stahl%' and [City] like '%rankfurt'
  or [Address] like '%lnkreuz%' and [City] like '%eckenheim' 
  or [Address] like '%oschetsrieder%' and [Address] like '%51%' and [City] like '%nchen' 
  or [Address] like '%lner%'  and [City] like '%uppertal' 
   or [Address] like '%nerweg%' and [Address] like '%59%'  and [City] like '%armstadt')
   Select
   d.DNR
   ,d.Name
   ,d.Adresse
   ,d.Stadt
   ,ffsh.[No_] as aufträge
   ,p.[T&T-Id] as Lieferung
   ,ffsl.[No_] as Artikel
   ,ffsl.Description as Beschreibung
   --,count(distinct ffsh.[No_]) as Anzahl_Aufträge
   ,cast(ffsl.[Quantity] as int) as Menge
   ,case when d.Adresse like '%allaswiesen%' and d.Stadt like '%armstadt' then 'Pallaswiesenstraße 180 62493 Darmstadt' 
         when d.Adresse like 'Oeser%' and d.Stadt like '%rankfurt%' then 'Oeserstraße 120 65934 Frankfurt'
		 when d.Adresse like 'Münz%' and d.Stadt like '%uisburg%' then 'Münzstraße 50 47051 Duisburg'
		 when d.Adresse like '%Stahl%' and d.Stadt like '%rankfurt' then 'Heinrich-Stahl-Straße 12 65934 Frankfurt'
		 when d.Adresse like '%lnkreuz%' and d.Stadt like '%eckenheim' then 'Am Kölnkreuz 43 53340 Meckenheim'
		 when d.Adresse like '%oschetsrieder%' and d.Stadt like '%nchen' then 'Boschetsrieder Straße 51 B 81379 München'
		 when d.Adresse like '%lner%' and d.Stadt like '%uppertal' then 'Köner Straße 15B 42119 Wuppertal'
		 when d.Adresse like '%nerweg%'  and d.Stadt like '%armstadt' then 'Meissnerweg 59 64289 Darmstadt' end as Richtige_Adresse


	
	from debitoren d with (nolock)
	left join [Urban_NAV600_SL].[dbo].[Urban-Brand GmbH$eBayFFSalesHeader] ffsh with (nolock)
	  on d.DNR=ffsh.[Sell-to Customer No_] collate Latin1_General_CI_AS
	  left join [Urban_NAV600_SL].[dbo].[Urban-Brand GmbH$eBayFFSalesLine] ffsl with (nolock)
	   on (ffsh.[No_]=ffsl.[Document No_] and ffsh.[Entry No_]=ffsl.[Document Entry No_]) 
	   left join [Urban_NAV600_SL].[dbo].[Urban-Brand GmbH$eBayParcel] p
	    on p.[Order No_]=ffsl.[Document No_] collate Latin1_General_CI_AS
	   where ffsl.[Type]=2
	   and ffsh.[Type]=1
	   and ffsl.Description not like '%Willkommensbrief%'
	   and ffsl.Description not like '%Gewinnspiel%'
	 group by 
    d.Adresse
   ,d.Stadt,d.DNR
   ,d.Name 
   ,ffsh.[No_]
   ,ffsl.[No_]
   ,ffsl.[Description]
   ,ffsl.[Quantity]
   ,p.[T&T-Id]
   order by d.DNR,d.Adresse