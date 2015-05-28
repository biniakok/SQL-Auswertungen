with nps_daten as 
(
SELECT
	sih.[Order No_],
	CAST (nps.[last_update] AS DATE) AS last_update,
	score,
	nps.Kommentar,
	case when Urban_NAV600_SL.dbo.RegExIsMatch('[Nn]eutral.*[Kk]arton',nps.Kommentar,1) = 1
			or Urban_NAV600_SL.dbo.RegExIsMatch('[Nn]eutral.*[Vv]erpack',nps.Kommentar,1) = 1
			then 1 else Null End as Neutrale_Kartonage,
	case when Urban_NAV600_SL.dbo.RegExIsMatch('[^Hh][Ll]iefer',nps.Kommentar,1) = 1 
			or Urban_NAV600_SL.dbo.RegExIsMatch('[Ll]ang',nps.Kommentar,1) = 1 
			or Urban_NAV600_SL.dbo.RegExIsMatch('[Dd]auer',nps.Kommentar,1) = 1
			or Urban_NAV600_SL.dbo.RegExIsMatch('[Dd]elay',nps.Kommentar,1) = 1
			or Urban_NAV600_SL.dbo.RegExIsMatch('[Vv]erz',nps.Kommentar,1) = 1
			or Urban_NAV600_SL.dbo.RegExIsMatch('[Ss]pät',nps.Kommentar,1) = 1
			or Urban_NAV600_SL.dbo.RegExIsMatch('[Ww]arte',nps.Kommentar,1) = 1
			or Urban_NAV600_SL.dbo.RegExIsMatch('[Ee]rhalt',nps.Kommentar,1) = 1
			or Urban_NAV600_SL.dbo.RegExIsMatch('[Aa]ngekommen',nps.Kommentar,1) = 1
			or Urban_NAV600_SL.dbo.RegExIsMatch('[Ss]low',nps.Kommentar,1) = 1
			then 1 else Null end as Lieferzeit,
	case when Urban_NAV600_SL.dbo.RegExIsMatch('[Vv]erpack',nps.Kommentar,1) = 1 
			or Urban_NAV600_SL.dbo.RegExIsMatch('[Mm]aterial',nps.Kommentar,1) = 1
			then 1 else Null end as Verpackung,
	case when Urban_NAV600_SL.dbo.RegExIsMatch('[Be]ezahl',nps.Kommentar,1) = 1 
			then 1 else Null End as Bezahlung,
	case when Urban_NAV600_SL.dbo.RegExIsMatch('[Kk]omplet',nps.Kommentar,1) = 1 
			or Urban_NAV600_SL.dbo.RegExIsMatch('[Ff]ehl',nps.Kommentar,1) = 1 
			then 1 else Null End as Unvollständig,
	case when Urban_NAV600_SL.dbo.RegExIsMatch('[Bb]esch[^Ww]',nps.Kommentar,1) = 1 
			or Urban_NAV600_SL.dbo.RegExIsMatch('[Kk]aput',nps.Kommentar,1) = 1 
			or Urban_NAV600_SL.dbo.RegExIsMatch('[Zz]erbroch',nps.Kommentar,1) = 1 
			or Urban_NAV600_SL.dbo.RegExIsMatch('[Dd]amag',nps.Kommentar,1) = 1
			or Urban_NAV600_SL.dbo.RegExIsMatch('[Dd]efekt',nps.Kommentar,1) = 1
			or Urban_NAV600_SL.dbo.RegExIsMatch('[Bb]roke',nps.Kommentar,1) = 1
			then 1 else Null End as Schaden,
	case when Urban_NAV600_SL.dbo.RegExIsMatch('[Aa]ntwort',nps.Kommentar,1) = 1 
			or Urban_NAV600_SL.dbo.RegExIsMatch('[Rr]ück[^Ss]',nps.Kommentar,1) = 1
			or Urban_NAV600_SL.dbo.RegExIsMatch('[Tt]elefon',nps.Kommentar,1) = 1
			or Urban_NAV600_SL.dbo.RegExIsMatch('[Ii]nfo',nps.Kommentar,1) = 1
			or Urban_NAV600_SL.dbo.RegExIsMatch('[Ss]upport',nps.Kommentar,1) = 1
			or Urban_NAV600_SL.dbo.RegExIsMatch('[Kk]undendienst',nps.Kommentar,1) = 1
			or Urban_NAV600_SL.dbo.RegExIsMatch('[Cc]ust.*[Ss]erv',nps.Kommentar,1) = 1
			or Urban_NAV600_SL.dbo.RegExIsMatch('[Rr]eaction',nps.Kommentar,1) = 1
			or Urban_NAV600_SL.dbo.RegExIsMatch('[Rr]eagier',nps.Kommentar,1) = 1
			then 1 else Null End as Kommunikation,
	case when Urban_NAV600_SL.dbo.RegExIsMatch('[Tt]euer',nps.Kommentar,1) = 1 
			then 1 else Null End as Produkt,
	case when Urban_NAV600_SL.dbo.RegExIsMatch('[Ll]ieferbar',nps.Kommentar,1) = 1 
			or Urban_NAV600_SL.dbo.RegExIsMatch('[Ll]ieferbar',nps.Kommentar,1) = 1 
			or Urban_NAV600_SL.dbo.RegExIsMatch('[Vv]erfügbar',nps.Kommentar,1) = 1 
			then 1 else Null End as Oversold
	
FROM
	[MAG_BI_Import].[dbo].[mage_nps] nps
LEFT JOIN Urban_NAV600_SL.dbo.[Urban-Brand GmbH$Sales Invoice Header] sih ON nps.vkr = sih.No_ COLLATE Latin1_General_100_CS_AS
WHERE
	nps.score < 8
AND nps.[Reason Code] = 'WINDELN_DE'
AND last_update between '2014-01-01' and getdate()
-- AND DATEDIFF(week, last_update, GETDATE()) = 1
AND Kommentar <> ''
)

select	year(n.last_update) as Jahr
		, datename(month, n.last_update) as Monat
		, sum(n.Neutrale_Kartonage) as Neutrale_Kartonage
		, sum(n.Lieferzeit) as Lieferzeit
		, sum(n.Verpackung) as Verpackung
		, sum(n.Bezahlung) as Bezahlung
		, sum(n.Unvollständig) as Unvollständig
		, sum(n.Schaden) as Schaden
		, sum(n.Kommunikation) as Kommunikation
		, sum(n.Produkt) as Produkt
		, sum(n.Oversold) as Oversold
from nps_daten n
group by year(n.last_update)
		, month(n.last_update) 
		, datename(month, n.last_update) 
order by year(n.last_update)
		, month(n.last_update) 
