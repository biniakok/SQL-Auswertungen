select 	
		ve.[Item No_]
		, cast(sum(ve.[Item Ledger Entry Quantity]) as Decimal(10,2)) as Bestand
		, cast(sum(ve.[Cost Amount (Expected)]) as Decimal(10,2)) as Cost_Amount_Expected
		, cast(sum(ve.[Cost Amount (Actual)]) as decimal(10,2)) as Cost_Amount_Actual
		, cast(sum(ve.[Cost Amount (Actual)]) + sum(ve.[Cost Amount (Expected)]) as decimal(10,2)) as Total_Cost_Amount
		, cast((sum(ve.[Cost Amount (Actual)]) + sum(ve.[Cost Amount (Expected)])) / sum(ve.[Item Ledger Entry Quantity]) as decimal(10,2)) as Cost_per_Unit
from Urban_Nav600_SL.dbo.[Urban-Brand GmbH$Value Entry] ve
where ve.[Location Code] = 'BER_FIEGE'
	and ve.[Posting Date] < cast(getdate() as date)
group by ve.[Item No_]
having sum(ve.[Item Ledger Entry Quantity]) <> 0
