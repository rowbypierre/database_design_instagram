-- list of available books and author information
with x as (
	select 		--*,
			title as "Book Title",
			concat(fname,' ', mi, '. ', lname) as "Full Name"
	from 		book_authors  ba
			left join authors a on ba.author_id = a.id
			left join books b on ba.book_id = b.id 
			left join statuses s on b.status_id = s.id
	where 		status in ('Available')
	group by 	"Full Name", "Book Title"
	order by 	"Book Title"
)

select		x."Book Title",
		string_agg("Full Name", ', ') as Author			
from 		x 
group by 	x."Book Title"
order by 	x."Book Title"
