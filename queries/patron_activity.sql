-- Patron activity report. 
select 		l.patron_id "ID", concat(p.fname, ' ', p.lname) "Name"
			, round(avg(fine), 2) 							"Fines (AVG)"
			, count(comments_neg.id) 						"# Negative Comments"
			, count(comments_pos.id) 						"# Positive Comments"
			, count(overdue.id) 							"# Overdue Returns"
			, count(early_returns.id) 						"# Early Returns"
			, fav.genre 									"Favorite Genre"
from 		loans l
left join 	patrons p on l.patron_id = p.id
left join 	( select 	fine, id from 	returns ) 
			fines on fines.id = l.return_id
left join 	( select 	 id, comment
			from 		returns 
			where 		comment like '%late%'
			or 			comment like '%damage%'
			or 			comment like 'lost'
			or 			comment like '%missing%' ) 
			comments_neg  on comments_neg.id = l.return_id
left join 	( select 	id, comment
			from 	returns 
			where 	comment not like '%late%'
			and 	comment not like '%damage%'
			and 	comment not like '%lost%'
			and 	comment not like '%missing%' ) 
			comments_pos on comments_pos.id = l.return_id		
left join 	( select 	id, overdue 
			from 		returns 
			where 		overdue = true) 
			overdue on overdue.id = l.return_id	
left join 	( select  		id 
			from 			returns 
			where 			comment like '%early%' ) 
			early_returns on early_returns.id = l.return_id	
left join 	( select 	patron_id, genre		
			from		(select 	*, row_number() over(partition by patron_id, genre order by count desc) "copy"
						from 		(select 	count(*) "count", patron_id, genre
									from 		loans l
									join 		books b on b.id = l.book_id
									join 		genres g on g.id = b.genre_id 	
									group by 	patron_id, genre) x) y
						where 		copy = 1 )
			fav on fav.patron_id = l.patron_id				
group by  	l.patron_id
			,concat(p.fname, ' ', p.lname)	
			,fav.genre 
order by 	"Favorite Genre"
			,"ID";




