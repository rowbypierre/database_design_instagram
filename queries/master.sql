-- general overview of library's book collection
select 		--*,
			title "Title", isbn "ISBN", genre "Genre", condition "Condition"
from		books b
			left join genres g on g.id = b.genre_id 
			left join conditions c on c.id = b.condition_id
			left join statuses s on s.id = b.status_id
order by	Genre, Title;

-- list of available books and author information
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

-- average condition of all books in collection
select 		condition "Condition",
			count(*) "Count",
			concat((count(*) * 100/(select count(*) from books)) , '% of Books') "Percent"
from		books b
			left join conditions c on c.id = b.condition_id
group by 	condition
order by	"Count" desc, condition;

-- number of days a book has been checked out for
with x as (
	select		*,
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
				left join checkouts c on c.id = l.checkout_id
) 

select 		title "Book Title",
			("Return Date" - "Checkout Date") as "Days Loaned" 
from		x
order by	"Days Loaned" desc;
			
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

-- average number fines by book genre
with x as ( 
	select 	*,
			(r.date - l.due) "Days Overdue"
	from 	loans l
			join returns r on r.id = l.return_id
			join books b on b.id = l.book_id
			join genres g on g.id = b.genre_id
)

select 		genre "Genre",
			concat('$', round(avg (fine), 2)) "Fine (AVG)"
from 		x 
where 		"Days Overdue" > 0
group by	"Genre"
order by	"Genre";

-- staff record creation count in database system
with x as (
	select		created_staff_id "ID", case when 1=1 then 'Books' end as "Record Type"
	from		books
	union
	select		created_staff_id "ID", case when 1=1 then 'Checkouts' end  "Record Type"
	from		checkouts
	union
	select		created_staff_id "ID", case when 1=1 then 'Loans' end  "Record Type"
	from		loans
	union
	select		created_staff_id "ID", case when 1=1 then 'Patrons' end  "Record Type"
	from		patrons
	union
	select		created_staff_id "ID", case when 1=1 then 'Returns' end  "Record Type"
	from		returns
	union
	select		created_staff_id "ID", case when 1=1 then 'Staff' end  "Record Type"
	from		staff 			
)

select 		concat(s.fname, ' ', s.lname) "Name", count("Record Type") "Count"
from		x
			join staff s on s.id = x."ID" 
group by 	"Name"
order by 	"Name";
