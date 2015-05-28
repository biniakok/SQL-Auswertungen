/*
Dies ist die Query zur Errechnung der Retourenquote.
*/

select * 

from

(Select 
max(si.PostingDate_SIH) as SalesDatum, 
si."External Document No_", 
max(si."Auftragsnummer") as Auftragsnummer,
si.Debitor,
si.Kundengruppe,
si.EAN, 
a.Item_Beschreibung_1, 
a.Item_Beschreibung_2, 
a.Kreditor, 
a.Kreditorname, 
a.Marke, 
a.Atikelklasse, 
a.Produktklasse_ABC, 
a.Kategorie_kurz, 
a.Kategorie_lang, 
SUM(si.Quantity) as SalesQty,
SUM(si.Amount) as SalesNettowert, 
SUM(si.LineMargin) as ProductMargin,
isnull(ret.ReturnQty,0) as ReturnQty, 
isnull(ReturnNettowert,0) as ReturnNettowert, 
ret."Return Reason Code", 
ret.ReturnReasonDescription, 
best.Auftragsstatus_shop, 
best."Shop Payment Method Code",
pim.Farbe,
pim.Windelgroesse,
pim.Saison, 
pim.Produkttyp, 
pim.Produkteigenschaft, 
pim.Groesse,
avg(post.Gesamt) as Gesamt

from BI_Data.item.salesinvoice si


left join
(
select 
distinct
h."External Document No_", 
l.No_ as EAN, 
max(l."Return Reason Code") as "Return Reason Code", 
max(rr."Description") as ReturnReasonDescription,
sum(l.Quantity) as ReturnQty, 
SUM(l.Amount) as ReturnNettowert

from Urban_NAV600_SL..[Urban-Brand GmbH$Sales Cr_Memo Header] h with(nolock)
inner join Urban_NAV600_SL..[Urban-Brand GmbH$Sales Cr_Memo Line] l  with(nolock)
on h.No_ = l."Document No_"

left join
Urban_NAV600_SL..[Urban-Brand GmbH$Return Reason] rr with(NOLOCK)
on l."Return Reason Code" = rr.Code

where h."Sell-to Customer No_" not in ('D1130991','D1486526','D1050291')

group by  
h."External Document No_", 
l.No_
) as Ret
on si."External Document No_" = ret."External Document No_"  collate Latin1_General_CI_AS and si.EAN = ret.EAN  collate Latin1_General_CI_AS

left join 
DWH_Staging.item.Artikelstammdaten a with(NOLOCK)
on si.EAN = a.EAN collate Latin1_General_CI_AS

left join
(     SELECT
      max(esh."External Document No_") as "External Document No_" ,
    esh."Order Date",
      ROW_NUMBER() OVER(PARTITION BY esh."Sell-to Account No_", esh."Shop Code" ORDER BY esh."Order Date") as Row_shop,
      case when (ROW_NUMBER() OVER(PARTITION BY esh."Sell-to Account No_", esh."Shop Code" ORDER BY esh."Order Date")) = 1 
      then 'new' else 'repeat' end Auftragsstatus_shop, 
      esh."Shop Payment Method Code"
      
      FROM  Urban_NAV600_SL..[Urban-Brand GmbH$eBayNavCSalesHeader] as esh
      where esh."Shop Code" = 'WINDELN_DE'
      Group by 
      esh."Sell-to Account No_", 
      esh."Order Date", 
      esh."Shop Code",
      esh."Shop Payment Method Code"
      ) best
      on best."External Document No_" = si."External Document No_" collate Latin1_General_CI_AS
      
left join 
            (select 
            distinct
            po.OrderID, 
            max(po.Gesamt) as Gesamt
      
            from mag_bi_import.dbo.dlz_malus po
            where po."Reason Code" = 'WINDELN_DE' and po.IsDelivered = 1
            group by 
            po.OrderID) post
            on si."Auftragsnummer" = post."OrderID" 

left join  openquery(DV,'select * from views.Biniakos_Product_groesse') pim
                              on si."EAN" = pim."ean" collate Latin1_General_100_CS_AS
      


where si.ReasonCode = 'WINDELN_DE'
and si.PostingDate_SIH between '2014-10-01' and getdate()

Group by 
si."External Document No_",
si.Debitor,
si.Kundengruppe,
si.EAN, 
a.Item_Beschreibung_1, 
a.Item_Beschreibung_2, 
a.Kreditor, 
a.Kreditorname, 
a.Marke, 
a.Atikelklasse, 
a.Produktklasse_ABC, 
a.Kategorie_kurz, 
a.Kategorie_lang,  
ret.ReturnQty, 
ReturnNettowert, 
ret."Return Reason Code", 
ret.ReturnReasonDescription,
best.Auftragsstatus_shop, 
best."Shop Payment Method Code",
pim.Farbe,
pim.Windelgroesse,
pim.Saison, 
pim.Produkttyp, 
pim.Produkteigenschaft, 
pim.Groesse
) as R
