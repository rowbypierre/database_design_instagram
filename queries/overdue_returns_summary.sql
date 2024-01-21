-- overdue returns 
with x as ( 
	select 	concat(p.fname, ' ', p.lname) as "Patron",
		b.title "Book",
		c.date "Checkout",
		l.due "Due",
		r.date "Returned",
		(r.date - l.due) "Days Overdue",
		concat('$',r.fine) "Fine"
	from 	loans l
		join checkouts c on c.id = l.checkout_id
		join returns r on r.id = l.return_id
		join books b on b.id = l.book_id
		join patrons p on p.id = l. patron_id
)

select 		* 
from 		x 
where 		"Days Overdue" > 0
order by	"Days Overdue" desc;
