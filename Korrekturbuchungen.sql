with
ve_ekpreis as
(
select      
            ve.[Item No_] as EAN 
            
            , cast(sum(ve.[Item Ledger Entry Quantity]) as Decimal(10,2)) as Bestand
            , cast(sum(ve.[Cost Amount (Expected)]) as Decimal(10,2)) as Cost_Amount_Expected
            , cast(sum(ve.[Cost Amount (Actual)]) as decimal(10,2)) as Cost_Amount_Actual
            , cast(sum(ve.[Cost Amount (Actual)]) + sum(ve.[Cost Amount (Expected)]) as decimal(10,2)) as Total_Cost_Amount
            , cast((sum(ve.[Cost Amount (Actual)]) + sum(ve.[Cost Amount (Expected)])) / sum(ve.[Item Ledger Entry Quantity]) as decimal(10,2)) as Cost_per_Unit
from [Urban_NAV600_SL].[dbo].[Urban-Brand GmbH$Value Entry] ve with (nolock)
where ve.[Location Code] = 'BER_FIEGE'
      and ve.[Posting Date] < cast(getdate() as date)
group by ve.[Item No_]
having sum(ve.[Item Ledger Entry Quantity]) <> 0

),
ile_rrc as
(
Select 
       cast(ile.[Posting Date] as date) as Datum
      ,ile.[Item No_] as EAN
      ,ile.[Document No_] as Belegnr
      ,ile.[Source No_] as HerkunftsNr
      ,ile.[Location Code] as Location_Code
      
      ,ile.[Return Reason Code] as RR_Code
      ,rrc.[Description] as Beschreibung
	  ,rrc.[Negative Import] as Neg_Import
	  ,cast(sku.[Unit Cost] as decimal (10,2)) sku_UnitCost
      ,cast(ile.[Quantity] as decimal(10,2)) as ile_Menge
      from [Urban_NAV600_SL].[dbo].[Urban-Brand GmbH$Item Ledger Entry] ile with (nolock)
 	  join [Urban_NAV600_SL].[dbo].[Urban-Brand GmbH$Stockkeeping Unit] sku with (nolock)
		on sku.[Item No_]=ile.[Item No_]
      join [Urban_NAV600_SL].[dbo].[Urban-Brand GmbH$Return Reason] rrc with (nolock)
            on rrc.[Code]=ile.[Return Reason Code]
	  
      where ile.[Posting Date]>='2015-03-30'
      and ile.[Posting Date]<='2015-04-05'
      and ile.[Location Code]='BER_FIEGE'
	  and sku.[Location Code]='BER_FIEGE' 
      and ile.[Return Reason Code] in ('K05','K08','K09','K10')
	  and ile.[Source No_]='70748'
)
	Select 
   ile_rrc.Datum as Datum
   ,ile_rrc.EAN as ArtikelNr
   ,ile_rrc.RR_Code as ReklamationsCode_ile
   ,ile_rrc.Beschreibung as Beschreibung_ile
   ,ile_rrc.ile_Menge as Menge_ile
   ,ile_rrc.Belegnr as Belegnummer
   ,ile_rrc.Neg_Import
   ,ile_rrc.sku_UnitCost
   ,ve_ekpreis.Cost_per_Unit as EK_WW_ve_Unit
   ,cast(case when ve_ekpreis.Cost_per_Unit is Null then ile_rrc.sku_UnitCost else ve_ekpreis.Cost_per_Unit end as Decimal(10,2)) as WW_Unit
   , cast(case when (ile_rrc.Neg_Import =1 and ve_ekpreis.Cost_per_Unit is not null)   then -abs(ile_rrc.ile_Menge)*ve_ekpreis.Cost_per_Unit
				when (ile_rrc.Neg_Import =1 and  ve_ekpreis.Cost_per_Unit is null) then -abs(ile_rrc.ile_Menge)*ile_rrc.sku_UnitCost
				when (ile_rrc.Neg_Import =0 and  ve_ekpreis.Cost_per_Unit is not null) then abs(ile_rrc.ile_Menge)*ve_ekpreis.Cost_per_Unit 
			when (ile_rrc.Neg_Import =0 and ve_ekpreis.Cost_per_Unit is null) then abs(ile_rrc.ile_Menge)*ile_rrc.sku_UnitCost
			end as Decimal(10,2)) as EK_Warenwert
    from ile_rrc with (nolock)
   left join ve_ekpreis with (nolock)
   on ve_ekpreis.EAN=ile_rrc.EAN 
   where ile_rrc.Datum >='2015-03-30'
   and ile_rrc.Datum<='2015-04-05'
   group by  ile_rrc.Datum, ile_rrc.EAN, ile_rrc.RR_Code, ile_rrc.Beschreibung, ile_rrc.ile_Menge, ile_rrc.Belegnr, ile_rrc.Neg_Import, ve_ekpreis.Cost_per_Unit,ile_rrc.sku_UnitCost
 order by  ile_rrc.Datum,ile_rrc.EAN
