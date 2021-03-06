/****** Script for SelectTopNRows command from SSMS  ******/
with
cte as
(SELECT
      cle.[Customer No_] as KundenNr
      --,cast(cle.[Posting Date] as date) as Datum
      --,cle.[Document No_] as DocumentNo
      --,cle.[Description] as Beschreibung
      --,cast(dcle.[Amount] as decimal (10,2)) as Betrag
	  ,sum(case when (cle.[Open]=1 and cle.[Document Type]=0) then 1 else 0 end) as Mahnung0
	  ,sum(case when (cle.[Open]=1 and cle.[Document Type]=1) then 1 else 0 end) as Mahnung1
	  ,sum(case when (cle.[Open]=1 and cle.[Document Type]=2) then 1 else 0 end) as Mahnung2
      ,sum(case when (cle.[Open]=1 and cle.[Document Type]=3) then 1 else 0 end) as Mahnung3
	  ,sum(case when (cle.[Open]=1 and cle.[Document Type]=4) then 1 else 0 end) as Mahnung4
	  ,sum(case when (cle.[Open]=1 and cle.[Document Type]=5) then 1 else 0 end) as Mahnung5
	  ,sum(case when (cle.[Open]=1 and cle.[Document Type]=6) then 1 else 0 end) as Mahnung6
  FROM [Urban_NAV600_SL].[dbo].[Urban-Brand GmbH$Cust_ Ledger Entry] cle
 -- join [Urban_NAV600_SL].[dbo].[Urban-Brand GmbH$Detailed Cust_ Ledg_ Entry] dcle with (nolock)
	--on cle.[Entry No_] = dcle.[Cust_ Ledger Entry No_]
	where cle.[Open]=1
	and cle.[Customer No_] in (SELECT distinct cle.[Customer No_] as KundenNr FROM [Urban_NAV600_SL].[dbo].[Urban-Brand GmbH$Cust_ Ledger Entry] cle
   where cle.[Open]=1 and cle.[Document Type]='5')
   group by cle.[Customer No_]
     ),
	 cte2 as
	 (SELECT
      cle.[Customer No_] as KundenNr
      ,cast(cle.[Posting Date] as date) as Datum
      ,cle.[Document No_]
      ,cle.[Description] as Beschreibung
      ,cast(dcle.[Amount] as decimal (10,2)) as Betrag
  FROM [Urban_NAV600_SL].[dbo].[Urban-Brand GmbH$Cust_ Ledger Entry] cle
  join [Urban_NAV600_SL].[dbo].[Urban-Brand GmbH$Detailed Cust_ Ledg_ Entry] dcle with (nolock)
	on cle.[Entry No_] = dcle.[Cust_ Ledger Entry No_]
  where cle.[Open]=1
  and cle.[Document Type]='5'
 )
   Select cte.KundenNr
   ,cte2.Datum
   ,cte2.[Document No_]
   ,cte2.Beschreibung
   ,cte2.Betrag
   from cte
   join cte2
   on cte.KundenNr=cte2.KundenNr
where Mahnung0=0
and Mahnung1=0
and Mahnung2=0
and Mahnung3=0
and Mahnung4=0
and Mahnung6=0
  group by cte.KundenNr 
  ,cte2.Datum
   ,cte2.[Document No_]
   ,cte2.Beschreibung
   ,cte2.Betrag
   order by cte.KundenNr 

  