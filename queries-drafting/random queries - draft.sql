-- general overview of libraries book collection
select 		--*,
			title "Title", isbn "ISBN", genre "Genre", condition "Condition"
from		books b
			left join genres g on g.id = b.genre_id 
			left join conditions c on c.id = b.condition_id
			left join statuses s on s.id = b.status_id

order by	Genre, Title;

-- list of available all books and authors 
select 		--*,
			title as "Book Title",
			fname as "Author First Name",
			lname as "Author Last Name",
			mi as "Author MI"
from 		book_authors  ba
			left join authors a on ba.author_id = a.id
			left join books b on ba.book_id = b.id 
			left join statuses s on b.status_id = s.id
where 		status in ('Available')
order by 	title, fname, lname;

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

-- average condition of all books collection
select 		condition "Condition",
			count(*) "Count",
			concat((count(*) * 100/(select count(*) from books)) , '% of Books') "Percent"
from		books b
			left join conditions c on c.id = b.condition_id
group by 	condition
order by	"Count" desc, condition;

-- number of days a book has been checked
select 		title "Book Title",
			("Return Date" - "Checkout Date") as "Days Loaned" 
from
			(select		*,
						case when r.date is not null 
						then r.date 
						else current_date 
						end as "Return Date",
						case when c.date is not null 
						then c.date
						else current_date
						end as "Checkout Date"
			
			from		books b
						left join loans l  on b.id = l.book_id 
						left join returns r on r.id = l.return_id
						left join checkouts c on c.id = l.checkout_id) x
order by	"Days Loaned" desc;
			
/*
Queries to be drafted:
-- loans with return dates past due date
-- average number fines by book genre
-- paton to have paid the most fines
-- library personnel 
-- personnel to have created the most records in database system
*/

