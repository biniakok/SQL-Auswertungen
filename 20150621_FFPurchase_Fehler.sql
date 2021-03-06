/****** Script for SelectTopNRows command from SSMS  ******/
--with 
--cte as(
--SELECT 
--      cast(ffph.[Posting Date] as date) as Buchungsdatum
--	  ,case when ffph.[Processing Status]=0 then 'Offen' else 'Geschlossen' end as Verarbeitungsstatus
--	  ,ffph.[No_] as BestNr
--	  ,ffph.[File No_] as DateiNr
--	 ,ffph.[Buy-from Vendor No_] as VendorNr
--	 ,ffph.[Buy-from Vendor Name] as VendorName
--	  ,ffl.[Description] as Beschreibung
--	  ,ffl.[Key Entry No_] as Key_Entry
--	  ,ffph.[Entry No_] as Entry_no
--	  ,ROW_NUMBER() OVER ( PARTITION BY ffph.[No_],ffl.[Key Entry No_] ORDER BY ffl.[Description] ) as seq
	    
--  FROM [Urban_NAV600_SL].[dbo].[Urban-Brand GmbH$eBayFFPurchaseHeader] ffph
--   join [Urban_NAV600_SL].[dbo].[Urban-Brand GmbH$eBayFFLog] ffl
--   on (ffph.[Entry No_]=ffl.[Key Entry No_] and ffl.[Key Code]=ffph.[No_])
--  WHERE ffph.[Processing error]=1
--  and ffph.[Location Code]='BER_FIEGE'
--  and ffl.[Key Type]=2
--  and ffl.[Is Cleared]=0
--  group by
--  ffph.[Posting Date] 
--	  ,ffph.[No_] 
--	  ,ffph.[File No_] 
--	 ,ffph.[Buy-from Vendor No_] 
--	 ,ffph.[Buy-from Vendor Name] 
--	  ,ffl.[Description] 
--	  ,ffl.[Key Entry No_]
--	,ffl.[Key Entry No_]
--	,ffph.[Entry No_]
--	,ffph.[Processing Status])
--	Select cte.Buchungsdatum
--	,cte.Verarbeitungsstatus
--	,cte.BestNr
--	,cte.DateiNr
--	,cte.VendorNr
--	,cte. VendorName
	
--,MAX( CASE seq WHEN 10 THEN cte.Beschreibung ELSE '' END ) +''+
--	MAX( CASE seq WHEN 9 THEN cte.Beschreibung ELSE '' END ) +''+
--	MAX( CASE seq WHEN 8 THEN cte.Beschreibung ELSE '' END ) +''+
--	MAX( CASE seq WHEN 7 THEN cte.Beschreibung ELSE '' END ) +''+
--	MAX( CASE seq WHEN 6 THEN cte.Beschreibung ELSE '' END ) +''+
--	MAX( CASE seq WHEN 5 THEN cte.Beschreibung ELSE '' END ) +''+
--	MAX( CASE seq WHEN 4 THEN cte.Beschreibung ELSE '' END ) +''+
--	MAX( CASE seq WHEN 3 THEN cte.Beschreibung ELSE '' END ) +''+
--	MAX( CASE seq WHEN 2 THEN cte.Beschreibung ELSE '' END ) +''+
--	MAX( CASE seq WHEN 1 THEN cte.Beschreibung ELSE '' END ) as FehlerMeldung

		   
--		   from cte
--		   group by
--		   cte.Buchungsdatum
--	,cte.BestNr
--	,cte.DateiNr
--	,cte.VendorNr
--	,cte. VendorName
--	,cte.Verarbeitungsstatus
--	,cte.Entry_no
--	order by cte.Buchungsdatum,cte.VendorName  
	  

/*Tablaeu-Version*/
Select cte.Buchungsdatum
	,cte.Verarbeitungsstatus
	,cte.BestNr
	,cte.DateiNr
	,cte.VendorNr
	,cte. VendorName
	,cte.Lagerort
	,MAX( CASE seq WHEN 10 THEN cte.Beschreibung ELSE '' END ) +''+
	MAX( CASE seq WHEN 9 THEN cte.Beschreibung ELSE '' END ) +''+
	MAX( CASE seq WHEN 8 THEN cte.Beschreibung ELSE '' END ) +''+
	MAX( CASE seq WHEN 7 THEN cte.Beschreibung ELSE '' END ) +''+
	MAX( CASE seq WHEN 6 THEN cte.Beschreibung ELSE '' END ) +''+
	MAX( CASE seq WHEN 5 THEN cte.Beschreibung ELSE '' END ) +''+
	MAX( CASE seq WHEN 4 THEN cte.Beschreibung ELSE '' END ) +''+
	MAX( CASE seq WHEN 3 THEN cte.Beschreibung ELSE '' END ) +''+
	MAX( CASE seq WHEN 2 THEN cte.Beschreibung ELSE '' END ) +''+
	MAX( CASE seq WHEN 1 THEN cte.Beschreibung ELSE '' END ) as Fehlermeldung

	from 
	(SELECT 
      cast(ffph.[Posting Date] as date) as Buchungsdatum
	  ,case when ffph.[Processing Status]=0 then 'Offen' else 'Geschlossen' end as Verarbeitungsstatus
	  ,ffph.[No_] as BestNr
	  ,ffph.[File No_] as DateiNr
	 ,ffph.[Buy-from Vendor No_] as VendorNr
	 ,ffph.[Buy-from Vendor Name] as VendorName
	 ,ffph.[Location Code] as Lagerort
	  ,ffl.[Description] as Beschreibung
	  ,ffl.[Key Entry No_] as Key_Entry
	  ,ffph.[Entry No_] as Entry_no
	  ,  ROW_NUMBER() OVER (PARTITION BY ffph.[No_],ffl.[Key Entry No_] ORDER BY ffl.[Description] asc)  as seq
	  , ROW_NUMBER() OVER (PARTITION BY ffph.[No_],ffl.[Key Entry No_] ORDER BY ffl.[Description] desc) as seq1  
  FROM [Urban_NAV600_SL].[dbo].[Urban-Brand GmbH$eBayFFPurchaseHeader] ffph
   join [Urban_NAV600_SL].[dbo].[Urban-Brand GmbH$eBayFFLog] ffl
   on (ffph.[Entry No_]=ffl.[Key Entry No_] and ffl.[Key Code]=ffph.[No_])
  WHERE ffph.[Processing error]=1
  and ffph.[Location Code] in ('BER_FIEGE','USTER')
  and ffl.[Key Type]=2
  and ffl.[Is Cleared]=0
  group by
  ffph.[Posting Date] 
	  ,ffph.[No_] 
	  ,ffph.[File No_] 
	 ,ffph.[Buy-from Vendor No_] 
	 ,ffph.[Buy-from Vendor Name] 
	  ,ffl.[Description] 
	  ,ffl.[Key Entry No_]
	,ffl.[Key Entry No_]
	,ffph.[Entry No_]
	,ffph.[Location Code]
	,ffph.[Processing Status]) as cte
	group by 
	cte.Buchungsdatum
	,cte.BestNr
	,cte.DateiNr
	,cte.VendorNr
	,cte. VendorName
	,cte.Verarbeitungsstatus 
	,cte.Lagerort

