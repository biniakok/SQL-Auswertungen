
select 
trans_nav.Externe_BelegNr
,trans_fiege.AuftragsNr
--,DHL_Kunde.Sendungsnummer
--,case 
--    when trans_fiege.ArtikelNr in (
--							 Select 
--								distinct [EAN] collate Latin1_General_CI_AS as ArtikelNr 
--								 FROM [BI_Data].[dbo].[OPS_Fiege_Morphologie]
--								 where ([Hoehe]>1200 or [Laenge]>1200 or [Breite]>1200) or ([Laenge] > 600 and [Breite] > 600) or (Breite > 600 and Hoehe > 600) or ([Laenge] > 600 and Hoehe > 600) or [Volumen_L]>128 
--								) then 1 else 0 end as Sperrgut_BigItem
,trans_fiege.Zahlungsmethode
,trans_fiege.LänderCode
,trans_fiege.Name
,trans_fiege.PLZ
,trans_nav.Status_NAV
,trans_nav.Betrugsfall
,trans_nav.Warteliste
,trans_nav.Webshop_Auftrag
,cast(trans_nav.Webshop_Auftrag as date) as Datum
,datename(mm,trans_nav.Webshop_Auftrag) as Monat
,trans_nav.Verkaufsbeleg_erstellt
,trans_fiege.Übergabe_Fiege
,max(rückmeldung_fiege.Rückmeldung_Fiege) as Rückmedung_Fiege
,DHL_Kunde.DHL_Eingang
,DHL_Kunde.Auftrag_Kunde
,DHL_Kunde.Geliefert
,cast(datediff(hour,trans_nav.Webshop_Auftrag,trans_fiege.Übergabe_Fiege) as Numeric)/24 Bruttotage_Webshop_Fiege
,cast(datediff(hour,trans_fiege.Übergabe_Fiege, DHL_Kunde.DHL_Eingang) as Numeric)/24 as Bruttotage_Fiege_DHL
,cast(datediff(hour,DHL_Kunde.DHL_Eingang, DHL_Kunde.Auftrag_Kunde) as Numeric)/24 as Bruttotage_DHL_Kunde
,cast(datediff(hour,trans_nav.Webshop_Auftrag, DHL_Kunde.Auftrag_Kunde) as Numeric)/24 Bruttotage_Webshop_Kunde
,BI_Data.dbo.networkdays_dec(trans_nav.Webshop_Auftrag,max(rückmeldung_fiege.Rückmeldung_Fiege)) as Nettotage_Webshop_Fiege
,BI_Data.dbo.networkdays_dec(DHL_Kunde.DHL_Eingang,DHL_Kunde.Auftrag_Kunde) as Nettotage_DHL_kunde 
,BI_Data.dbo.networkdays_dec(trans_nav.Webshop_Auftrag,DHL_Kunde.Auftrag_Kunde) as Nettotage_Webshop_kunde
,BI_Data.dbo.networkdays_dec(trans_fiege.Übergabe_Fiege, DHL_Kunde.Auftrag_Kunde) as Nettotage_Fiege_DHL
 from  
 /*1.Tabelle*/
 (
 select  
 cdh.[Order Created at] as Webshop_Auftrag
 , BI_Data.dbo.ToUTCDate(nvws.[Sales Document rendered at]) as Verkaufsbeleg_erstellt
, nvws.[No_] as Verkaufsrechnung
,nvws.[Status] as Status_NAV
, nvws.[Sales Document No_] as AuftragsNr
, cdh.[ExternalDocumentNo] as Externe_BelegNr
, cdh.[FraudInfo] as Betrugsfall
,cdh.[Wait] as Warteliste
  FROM [Urban_NAV600_SL].[dbo].[Urban-Brand GmbH$CreateDocumentHeader] cdh with (nolock)                                
	left join [Urban_NAV600_SL].[dbo].[Urban-Brand GmbH$eBayNavCSalesHeader] nvws with (nolock)
	 on cdh.[ExternalDocumentNo]=nvws.[External Document No_] collate Latin1_General_CI_AS
  where  nvws.[Shop Code]='WINDELN_DE'
    --and nvws.[Sales Document rendered at] between '2015-01-01' and getdate()
	) as trans_nav
/*2. Tabelle*/
left join ( Select 
   BI_Data.dbo.ToUTCDate(ffp.[Timestamp Upload_Download]) as Übergabe_Fiege
   ,ffsh.[No_] as AuftragsNr
   --,ffsl.[No_] as ArtikelNr
   ,ffsh.[External Document No_] as Externe_BelegNr 
   ,ffsh.[Payment Method Code] as Zahlungsmethode
   ,ffsh.[Ship-to Country_Region Code] as LänderCode
   ,cr.[Name]as Name
   ,ffsh.[Ship-to Post Code] as PLZ
   FROM [Urban_NAV600_SL].[dbo].[Urban-Brand GmbH$eBayFFSalesHeader] ffsh with (nolock)
	join [Urban_NAV600_SL].[dbo].[Urban-Brand GmbH$eBayFFProtocol] ffp with (nolock)
		on ffsh.[File No_]=ffp.[File No_] collate Latin1_General_CI_AS
		join [Urban_NAV600_SL].[dbo].[Urban-Brand GmbH$eBayFFSalesLine] ffsl  
	    on (ffsh.[No_]=ffsl.[Document No_]
		and ffsh.[Entry No_]=ffsl.[Document Entry No_]) 
	join [Urban_NAV600_SL].[dbo].[Urban-Brand GmbH$Country_Region] cr with (nolock)
		on cr.[Code]=ffsh.[Ship-to Country_Region Code]
	where ffsh.[Location Code]='BER_FIEGE'
	--and BI_Data.dbo.ToUTCDate(ffp.[Timestamp Upload_Download]) between '2015-01-01' and getdate() 
	and ffsh.[Type]=0
	and ffsh.[Entry No_]=1
	--and ffsl.[Type]=2
	) as trans_fiege
		on trans_nav.Externe_BelegNr=trans_fiege.Externe_BelegNr collate Latin1_General_CI_AS 
/*3.Tabelle*/		
		join (Select 
   BI_Data.dbo.ToUTCDate(ffp.[Timestamp Upload_Download]) as Rückmeldung_Fiege
   , ffsh.[No_] as AuftragsNr
   , ffsh.[External Document No_]
     FROM [Urban_NAV600_SL].[dbo].[Urban-Brand GmbH$eBayFFSalesHeader] ffsh with (nolock)
	join [Urban_NAV600_SL].[dbo].[Urban-Brand GmbH$eBayFFProtocol] ffp with (nolock)
		on ffsh.[File No_]=ffp.[File No_] collate Latin1_General_CI_AS
	where ffsh.[Location Code]='BER_FIEGE'
	--and BI_Data.dbo.ToUTCDate(ffp.[Timestamp Upload_Download]) between '2015-01-01' and getdate() 
	and ffsh.[Type]=1) rückmeldung_fiege
		on trans_fiege.AuftragsNr=rückmeldung_fiege.AuftragsNr collate Latin1_General_CI_AS

/*4.Tabelle*/
join(select 
--pst.[TrackingID] as Sendungsnummer
		 pst.[OrderID] as AuftragsNr
		, pst.[OrderTimestamp]
		,pst.[isDelivered] as Geliefert
		, case 
			when (pst.[KnownToPostalServiceTimestamp] > pst.[PostalServiceTimestamp] or pst.[KnownToPostalServiceTimestamp] is Null)  then pst.[PostalServiceTimestamp]
			else pst.[KnownToPostalServiceTimestamp] end as DHL_Eingang
 , pst.[DeliveryTimestamp] as Auftrag_Kunde
 FROM [BI_Data].[dbo].[PostalServiceTracking] pst  with (nolock)
 where pst.[isKnownToPostalService]=1
 --where pst.[OrderTimestamp] between '2015-01-01' and getdate() 
 --and pst.[DeliveryTimestamp] between '2015-01-01' and getdate()
 ) as DHL_Kunde
	on rückmeldung_fiege.AuftragsNr=DHL_Kunde.AuftragsNr collate Latin1_General_CI_AS
where trans_nav.Webshop_Auftrag>= '2015-01-01' 
--	and trans_nav.Webshop_Auftrag<= getdate() 

group by 
trans_nav.Externe_BelegNr
,trans_fiege.AuftragsNr
--,DHL_Kunde.Sendungsnummer
--,trans_fiege.ArtikelNr
,trans_fiege.Zahlungsmethode
,trans_fiege.LänderCode
,trans_fiege.Name
,trans_fiege.PLZ
,trans_nav.Betrugsfall
,trans_nav.Warteliste
,trans_nav.Webshop_Auftrag
,trans_nav.Verkaufsbeleg_erstellt
,trans_fiege.Übergabe_Fiege
,DHL_Kunde.DHL_Eingang
,DHL_Kunde.Auftrag_Kunde
,DHL_Kunde.Geliefert
,datename(mm,trans_nav.Webshop_Auftrag)
,trans_nav.Status_NAV
