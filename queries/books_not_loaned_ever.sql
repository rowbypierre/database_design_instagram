-- list of books to have never been loaned out
select 		--*,
		title as "Book Title",
		fname as "Author First Name",
		lname as "Author Last Name",
		mi as "Author MI"
from 		book_authors  ba
		left join authors a on ba.author_id = a.id
		left join books b on ba.book_id = b.id 
		left join statuses s on b.status_id = s.id
where 		b.id not in (select book_id from loans)
order by 	title, fname, lname;
