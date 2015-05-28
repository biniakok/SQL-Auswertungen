 with
 dimension550 as
 (select 
 ofm.[EAN] as EAN
 ,it.[Description] as Beschreibung
 ,it.[Description 2] as Beschreibung2
 ,dv.[Code] as KategorieCode
 ,dv.[Name] as KategorieName
 ,ofm.[Laenge] as Länge
 ,ofm.[Hoehe] as Höhe
 ,ofm.[Breite] as Breite
 ,ofm.[Volumen_L] as Volumen
 ,ilea.[InStock] as Bestand
 ,ilea.[Location Code] as Lagerort
 ,Rank() 
  over (Partition by ilea.[EAN]
		order by ilea.[DateValue] desc) as Rankordnung
 ,cast(ofm.[Gewicht] as decimal(10,2)) as Gewicht
 ,case
	when ((ofm.[Laenge]>=ofm.[Hoehe]) and (ofm.[Laenge]>=ofm.[Breite])) then ofm.[Laenge]
	when ((ofm.[Hoehe]>=ofm.[Laenge]) and (ofm.[Hoehe]>=ofm.[Breite])) then ofm.[Hoehe]
	when ((ofm.[Breite]>=ofm.[Hoehe]) and (ofm.[Breite]>=ofm.[Laenge])) then ofm.[Breite] end as Längste_Dimension
FROM [BI_Data].[dbo].[OPS_Fiege_Morphologie] ofm with (nolock)
join [BI_Data].[dbo].[ItemLedgerEntryAggr] ilea with (nolock)
	on ilea.[EAN]=ofm.[EAN] collate Latin1_General_100_CS_AS 
join [Urban_NAV600_SL].[dbo].[Urban-Brand GmbH$Item] it with (nolock)
	on ofm.[EAN]=it.[No_] collate Latin1_General_100_CS_AS
join [Urban_NAV600_SL].[dbo].[Urban-Brand GmbH$Dimension Value] dv with (nolock)
	on dv.[Code]=it.[Attribute 2] collate Latin1_General_100_CS_AS) 
Select 
dimension550.EAN
,dimension550.Beschreibung
,dimension550.Beschreibung2
,dimension550.KategorieCode
,dimension550.KategorieName
,dimension550.Länge
,dimension550.Höhe
,dimension550.Breite
,dimension550.Volumen
,dimension550.Gewicht
,dimension550.Bestand
from dimension550
where dimension550.Rankordnung=1
and dimension550.Lagerort='FIEGE'
group by 
dimension550.EAN
,dimension550.Beschreibung
,dimension550.Beschreibung2
,dimension550.KategorieCode
,dimension550.KategorieName
,dimension550.Länge
,dimension550.Höhe
,dimension550.Breite
,dimension550.Volumen
,dimension550.Gewicht
,dimension550.Bestand 



