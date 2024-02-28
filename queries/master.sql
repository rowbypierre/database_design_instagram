-- general overview of library's book collection
select 		--*,
		title "Title", isbn "ISBN", genre "Genre", condition "Condition"
from		books b
		left join genres g on g.id = b.genre_id 
		left join conditions c on c.id = b.condition_id
		left join statuses s on s.id = b.status_id
order by	Genre, Title;

-- patron activity report 
select 		l.patron_id "ID", concat(p.fname, ' ', p.lname) "Name"
		, round(avg(fine), 2) "Fines (AVG)"
		, count(comments_neg.id) "# Negative Comments"
		, count(comments_pos.id) "# Positive Comments"
		, count(overdue.id) "# Overdue Returns"
		, count(early_returns.id) "# Early Returns"
		, fav.genre "Favorite Genre"
from 		loans l
		left join 	patrons p on l.patron_id = p.id
		left join 	( select 	fine, id from 	returns ) fines on fines.id = l.return_id
		left join 	( select 	 id, comment
				from 	returns 
				where 	comment like '%late%'
					or comment like '%damage%'
					or comment like 'lost'
					or comment like '%missing%' ) comments_neg  on comments_neg.id = l.return_id
		left join 	( select 	id, comment
				from 	returns 
				where 	comment not like '%late%'
					and comment not like '%damage%'
					and comment not like '%lost%'
					and comment not like '%missing%' ) comments_pos on comments_pos.id = l.return_id		
		left join 	( select 	id, overdue from 	returns where 	overdue = true) overdue on overdue.id = l.return_id	
		left join 	( select  id from returns where 	comment like '%early%' ) early_returns on early_returns.id = l.return_id	
		left join 	( select 	patron_id, genre		
				from		(select 	*, row_number() over(partition by patron_id, genre order by count desc) "copy"
						from 		(select 	count(*) "count", patron_id, genre
								from 		loans l
										join books b on b.id = l.book_id
										join genres g on g.id = b.genre_id 	
								group by 	patron_id, genre) x) y
where 		copy = 1 )fav on fav.patron_id = l.patron_id				
group by  	l.patron_id, concat(p.fname, ' ', p.lname), fav.genre 
order by 	"Favorite Genre", "ID";

-- time series analysis: # of loans per month & growth % from previous month
with x as (
	select 			date_part('year', c.date) "Year", 
				date_part('month', c.date) "Month #", 
				to_char(c.date, 'Month') "Month",
				date_part('month', (c.date - interval '1 month')) "Previous Month #",
				count(*) as "Loans"
	from 			loans
				join returns r on r.id = loans.return_id
				join checkouts c on c.id = loans.checkout_id
	group by 		date_part('year', c.date), date_part('month', c.date), 
				date_part('month', (c.date - interval '1 month')), 
				to_char(c.date, 'Month')
	order by		"Year", "Month #" desc
)

select 	  "Year"
	, "Month"
	, "Loans" as "# of Loans"
	, case
		 when x2."Loans" - (select x."Loans" from x where x."Month #" = x2."Previous Month #") is null 
			 then '0.00 %'
		 else   
			 concat(
				cast (((
					round(((
						cast(x2."Loans" - (select x."Loans" from x where x."Month #" = x2."Previous Month #") as numeric)) / x2."Loans"), 2) * 100)) as text), ' %')
	end as "Growth (Prev. Month)"
from	x as x2 
; 

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
order by 	x."Book Title";
	
-- list of books to have never been loaned out
with x as (
	select 		--*,
				title as "Book Title",
				concat(fname,' ', mi, '. ', lname) as "Full Name"
	from 		book_authors  ba
				left join authors a on ba.author_id = a.id
				left join books b on ba.book_id = b.id 
				left join statuses s on b.status_id = s.id
	where 		b.id not in (select book_id from loans)
	order by 	"Book Title"
)

select		x."Book Title",
			string_agg("Full Name", ', ') as Author			
from 		x 
group by 	x."Book Title"
order by 	x."Book Title"

-- average condition of all books in collection
select 		condition "Condition",
			count(*) "Count",
			concat((count(*) * 100/(select count(*) from books)) , '% of Books') "Percent"
from		books b
			left join conditions c on c.id = b.condition_id
group by 	condition
order by	"Count" desc, condition;

-- number of days a book has been checked out
with x as (
	select		*,
				case 
					when r.date is not null then r.date 
					else current_date 
				end as "Return Date",
				case 
					when c.date is not null then c.date
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

-- average cost of fines by book genre
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
