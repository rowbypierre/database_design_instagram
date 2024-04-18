-- General overview of the library's book collection.
select 		--*,
			b.title 		            "Book Title"
			,b.ISBN 		            "Book ISBN"
            ,string_agg(concat(a.fname,
                             ' ',
                             upper(mi),
                             '. ',
                             a.lname) 
                        ,', ')          "Book Author(s)"
			,g.genre 		            "Genre"
			,c.condition 	            "Condition"
from		books b
left join   book_authors ba ON ba.book_id = b.id 
left join   authors a on ba.author_id = a.id
left join 	genres g on g.id = b.genre_id 
left join 	conditions c on c.id = b.condition_id
left join 	statuses s on s.id = b.status_id
group by    1, 2, 4, 5
order by	1;