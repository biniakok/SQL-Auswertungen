/* Orders with XX Products*/

SELECT count ( distinct sh.No_)
FROM [Urban_NAV600_SL].[dbo].[Urban-Brand GmbH$Sales Line] as sl with (NOLOCK)
Left Join [urban_NAV600_SL].[dbo].[Urban-Brand GmbH$Sales Header] as sh with (NOLOCK)
on sl.[Document No_] = sh.No_
Where sl.No_ like '%X%'



SELECT sh.No_ as A
FROM [Urban_NAV600_SL].[dbo].[Urban-Brand GmbH$Sales Line] as sl with (NOLOCK)
Left Join [urban_NAV600_SL].[dbo].[Urban-Brand GmbH$Sales Header] as sh with (NOLOCK)
on sl.[Document No_] = sh.No_
Where sl.No_ like '%X%'
