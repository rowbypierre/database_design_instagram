-- Number of days a book has been checked out.
with x as (
	select	*,
			case 
				when r.date is not null 
					then r.date 
					else current_date 
			end as 							"Return Date",
			case 
				when c.date is not null 
					then c.date
					else current_date
			end as 							"Checkout Date"
	from		books b
	left join 	loans l  on b.id = l.book_id 
	left join 	returns r on r.id = l.return_id
	left join 	checkouts c on c.id = l.checkout_id
) 

select 		title 									"Book Title"
			,("Return Date" - "Checkout Date") as 	"Days Loaned" 
from		x
order by	2 desc;