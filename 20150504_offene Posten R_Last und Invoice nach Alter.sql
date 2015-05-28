/****** offene Posten R_Last und Invoice nach Alter ******/
SELECT year([Posting Date]) as Jahr, month([Posting Date]) as Monat, [Payment Method Code] , count([Entry No_]) as AnzahlOffenePosten
FROM [urban_NAV600_SL].[dbo].[Urban-Brand GmbH$Cust_ Ledger Entry] with (NOLOCK)
Where [Open] = 1 AND [Document Type] = 2 AND [Payment Method Code] in ('R_LAST')
Group by [Payment Method Code], year([Posting Date]), month([Posting Date])
order by year([Posting Date]), month([Posting Date]) asc

SELECT year([Posting Date]) as Jahr, month([Posting Date]) as Monat, [Payment Method Code] , count([Entry No_]) as AnzahlOffenePosten
FROM [urban_NAV600_SL].[dbo].[Urban-Brand GmbH$Cust_ Ledger Entry] with (NOLOCK)
Where [Open] = 1 AND [Document Type] = 2 AND [Payment Method Code] in ('INVOICE')
Group by [Payment Method Code], year([Posting Date]), month([Posting Date])
order by year([Posting Date]), month([Posting Date]) asc




Select
cast([Posting Date] as Date) as Datum
,[Entry No_] as Eintragsnummer
,[Payment Method Code] as Zahlungsmethode
FROM [urban_NAV600_SL].[dbo].[Urban-Brand GmbH$Cust_ Ledger Entry] with (NOLOCK)
Where [Open] = 1 AND [Document Type] = 2 AND [Payment Method Code] in ('R_LAST','INVOICE')
