-- List of books never loaned out. 
with x as (
	select 		--*,
				title  									"Book Title",
				concat(fname,' ', mi, '. ', lname)  	"Full Name"
	from 		book_authors  ba
	left join 	authors a on ba.author_id = a.id
	left join 	books b on ba.book_id = b.id 
	left join 	statuses s on b.status_id = s.id
	where 		b.id not in (select book_id from loans)
	order by 	"Book Title"
)

select										x."Book Title",
			string_agg("Full Name", ', ')  	Author			
from 		x 
group by 	x."Book Title"
order by 	x."Book Title"

