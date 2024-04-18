-- Time series analysis: # of loans per month & growth % from previous month.
with x as (
	select 		date_part('year', c.date)                           "Year", 
				date_part('month', c.date)                          "Month #", 
				to_char(c.date, 'Month')                            "Month",
				date_part('month', (c.date - interval '1 month'))   "Previous Month #",
				count(*) as                                         "Loans"
	from 		loans
	join 		returns r on r.id = loans.return_id
	join 		checkouts c on c.id = loans.checkout_id
	group by 	1, 2, 4, 3
	order by	1, 2 desc
)

select 		 	    "Year"
				    ,"Month"
		,"Loans"    "# of Loans"
		,case
			 when x2."Loans" - (select x."Loans" from x where x."Month #" = x2."Previous Month #") is null 
				 then '0.00 %'
			 else   
				 concat(
					cast (((
						round(((
							cast(x2."Loans" 
								- 
								(select x."Loans" from x where x."Month #" = x2."Previous Month #") as numeric)) 
								/ 
								x2."Loans"), 2) 
								* 
								100)) as text), ' %')
		end 	"Growth (Prev. Month)"
from	x x2 
; 