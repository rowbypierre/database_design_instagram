
-- average cost of fines by book genre
with x as ( 
	select 						*,
			(r.date - l.due) 	"Days Overdue"
	from 	loans l
	join 	returns r on r.id = l.return_id
	join 	books b on b.id = l.book_id
	join 	genres g on g.id = b.genre_id
)

select 		genre 								"Genre"
			,concat('$', round(avg (fine), 2)) 	"Fine (AVG)"
from 		x 
where 		"Days Overdue" > 0
group by	"Genre"
order by	"Genre";
