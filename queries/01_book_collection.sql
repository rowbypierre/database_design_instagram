-- General overview of the library's book collection.
select 		--*,
			title 		"Title"
			,ISBN 		"ISBN"
			,genre 		"Genre"
			,condition 	"Condition"
from		books b
left join 	genres g on g.id = b.genre_id 
left join 	conditions c on c.id = b.condition_id
left join 	statuses s on s.id = b.status_id
order by	Genre 
			,Title;
