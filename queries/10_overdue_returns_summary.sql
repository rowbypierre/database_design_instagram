-- Overdue returns. 
with x as ( 
	select 	concat(p.fname, ' ', p.lname)  		"Patron",
			b.title 							"Book",
			c.date 								"Checkout Date",
			l.due 								"Due Date",
			r.date 								"Return Date",
			(r.date - l.due) 					"Days Overdue",
			concat('$',r.fine) 					"Fine"
	from 	loans l
	join 	checkouts c on c.id = l.checkout_id
	join 	returns r on r.id = l.return_id
	join 	books b on b.id = l.book_id
	join 	patrons p on p.id = l. patron_id
)

select 		* 
from 		x 
where 		"Days Overdue" > 0
order by	6 desc;