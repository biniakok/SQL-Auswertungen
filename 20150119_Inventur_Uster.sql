with 

eans as

(
SELECT 

distinct ile.[Item No_] as EAN
  FROM [Urban_NAV600_SL].[dbo].[Urban-Brand GmbH$Item Ledger Entry] ile
  where ile.[Location Code] = 'USTER'
)

, end_inv as
(SELECT 

ile.[Item No_] as EAN
--,cast(count(ile.[Quantity]) as int) as Bestand_Jan
,cast(sum(ile.[Quantity]) as int) as Summe_Jan
  FROM [Urban_NAV600_SL].[dbo].[Urban-Brand GmbH$Item Ledger Entry] ile
  where ile.[Location Code] = 'USTER'
--and left(ile.[Document No_], 3) = 'INV'
and ile.[Posting Date] < '2015-01-18'
group by ile.[Item No_]
),
beg_inv as
(SELECT 
ile.[Item No_] as EAN
--,cast(count(ile.[Quantity]) as int)  as Bestand_Dez
,cast(sum(ile.[Quantity]) as int) as Summe_Dez
  FROM [Urban_NAV600_SL].[dbo].[Urban-Brand GmbH$Item Ledger Entry] ile
  where ile.[Location Code] = 'USTER'
--and left(ile.[Document No_], 3) = 'INV'
and ile.[Posting Date] <= '2014-12-31'
group by ile.[Item No_]
), 
diff_inv as
(
SELECT 

ile.[Item No_] as EAN
--,cast(count(ile.[Quantity]) as int) as Bestand_Jan
,cast(sum(ile.[Quantity]) as int) as Summe_Jan
  FROM [Urban_NAV600_SL].[dbo].[Urban-Brand GmbH$Item Ledger Entry] ile
  where ile.[Location Code] = 'USTER'
--and left(ile.[Document No_], 3) = 'INV'
and ile.[Posting Date] between '2015-01-01' and '2015-01-17'
group by ile.[Item No_]
)

select eans.EAN
		, isnull(beg_inv.Summe_Dez,0) as Anfangs_Inv
		, isnull(end_inv.Summe_Jan,0) as End_Inv
		, isnull(end_inv.Summe_Jan,0) - isnull(beg_inv.Summe_Dez,0) as Diff_Errechnet
		, isnull(diff_inv.Summe_Jan,0) as Diff_Posten
		, case when (isnull(end_inv.Summe_Jan,0) - isnull(beg_inv.Summe_Dez,0)) = isnull(diff_inv.Summe_Jan,0)
			then 'True'
			else 'False'
			end as Check_Field
from eans
full outer join beg_inv
	on eans.EAN = beg_inv.EAN
full outer join end_inv
	on eans.EAN = end_inv.EAN
full outer join diff_inv
	on diff_inv.EAN = eans.EAN


