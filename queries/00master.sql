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


-- Patron activity report. 
select 		l.patron_id                                     "Patron ID" 
            ,concat(p.fname, ' ', p.lname)                  "Patron Name"
			,round(avg(fine), 2) 							"Fines (AVG)"
			,count(comments_neg.id) 						"# Negative Comments"
			,count(comments_pos.id) 						"# Positive Comments"
			,count(overdue.id) 							    "# Overdue Returns"
			,count(early_returns.id) 						"# Early Returns"
			, fav.genre 									"Favorite Genre"
from 		loans l
left join 	patrons p on l.patron_id = p.id
left join 	(select fine, id from 	returns) 
			fines on fines.id = l.return_id
left join 	(select id, comment
			from 	returns 
			where 	comment like '%late%'
			or 		comment like '%damage%'
			or 		comment like 'lost'
			or 		comment like '%missing%' ) 
			comments_neg  on comments_neg.id = l.return_id
left join 	(select id, comment
			from 	returns 
			where 	comment not like '%late%'
			and 	comment not like '%damage%'
			and 	comment not like '%lost%'
			and 	comment not like '%missing%') 
			comments_pos on comments_pos.id = l.return_id		
left join 	(select id, overdue 
			from 	returns 
			where 	overdue = true) 
			overdue on overdue.id = l.return_id	
left join 	(select	id 
			from 	returns 
			where 	comment like '%early%' ) 
			early_returns on early_returns.id = l.return_id	
left join 	(select patron_id, genre		
			from	(select *, row_number() over(partition by patron_id, genre order by count desc) "copy"
					from 	(select 	count(*) "count", patron_id, genre
							from 		loans l
							join 		books b on b.id = l.book_id
							join 		genres g on g.id = b.genre_id 	
							group by 	2, 3) x) y
					where 	copy = 1 )
			fav on fav.patron_id = l.patron_id				
group by  	1, 2, 8
order by 	8, 2;

-- Time series analysis: # of loans per month & growth % from previous month.
with x as (
	select 		date_part('year', c.date)                           "Year", 
				date_part('month', c.date)                          "Month #", 
				to_char(c.date, 'Month')                            "Month",
				date_part('month', (c.date - interval '1 month'))   "Previous Month #",
				count(*) as                                         "Loans"
	from 		loans
	join 		returns r on r.id = loans.return_id
	join 		checkouts c on c.id = loans.checkout_id
	group by 	1, 2, 4, 3
	order by	1, 2 desc
)

select 		 	    "Year"
				    ,"Month"
		,"Loans"    "# of Loans"
		,case
			 when x2."Loans" - (select x."Loans" from x where x."Month #" = x2."Previous Month #") is null 
				 then '0.00 %'
			 else   
				 concat(
					cast (((
						round(((
							cast(x2."Loans" 
								- 
								(select x."Loans" from x where x."Month #" = x2."Previous Month #") as numeric)) 
								/ 
								x2."Loans"), 2) 
								* 
								100)) as text), ' %')
		end 	"Growth (Prev. Month)"
from	x x2 ; 

-- List of available books and author information.
with x as (
	select 		--*,
				title as "Book Title",
				concat(fname,' ', mi, '. ', lname) as "Full Name"
	from 		book_authors  ba
	left join 	authors a on ba.author_id = a.id
	left join 	books b on ba.book_id = b.id 
	left join 	statuses s on b.status_id = s.id
	where 		status in ('Available')
	group by 	"Full Name", "Book Title"
	order by 	"Book Title"
)

select		                                x."Book Title",
			string_agg("Full Name", ', ')   "Author(s)"			
from 		x 
group by 	1
order by 	1;
	

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
			string_agg("Full Name", ', ')  	"Author(s)"			
from 		x 
group by 	1
order by 	1;

-- Average condition of all books collection.
select 		condition                                               "Condition"
			,count(*)                                               "Count"
			,concat((count(*) 
					* 
					100
					/
					(select count(*) from books)) , '% of Books')   "Percent"
from		books b
left join 	conditions c on c.id = b.condition_id
group by 	1
order by	2 desc, 1;

-- Number of days a book has been checked out.
with x as (
	select	*,
			case 
				when r.date is not null 
					then r.date 
					else current_date 
			end as 							"Return Date",
			case 
				when c.date is not null 
					then c.date
					else current_date
			end as 							"Checkout Date"
	from		books b
	left join 	loans l  on b.id = l.book_id 
	left join 	returns r on r.id = l.return_id
	left join 	checkouts c on c.id = l.checkout_id
) 

select 		title 									"Book Title"
			,("Return Date" - "Checkout Date")  	"Days Loaned" 
            ,("Return Date" - "Checkout Date")/30   "Months Loaned"
from		x
order by	2 desc;

-- Average cost of fines by book genre.
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
group by	1
order by	2 desc;

-- Staff count of records creations in database system. 
with x as (
	select		created_staff_id                    "ID", 
				case when 1=1 then 'Books' end 		"Record Type"
	from		books
	union
	select		created_staff_id                    "ID", 
				case when 1=1 then 'Checkouts' end	"Record Type"
	from		checkouts
	union
	select		created_staff_id                    "ID", 
				case when 1=1 then 'Loans' end		"Record Type"
	from		loans
	union
	select		created_staff_id                    "ID", 
				case when 1=1 then 'Patrons' end  	"Record Type"
	from		patrons
	union
	select		created_staff_id                    "ID", 
				case when 1=1 then 'Returns' end  	"Record Type"
	from		returns
	union
	select		created_staff_id                    "ID", 
				case when 1=1 then 'Staff' end		"Record Type"
	from		staff 			
)

select 		concat(s.fname, ' ', s.lname) 	"Staff Name"
            ,r.role                         "Position/ Title"
            ,count(2) 			            "Record(s) Created"
            ,s.hire                         "Onboard Date"
            from		x
join 		staff s on s.id = x."ID" 
join        roles r on r.id = s.role_id
group by 	1, 2, 4
order by 	3 desc, 1;

-- Overdue returns. 
with x as ( 
	select 	concat(p.fname, ' ', p.lname)  		"Patron",
			b.title 							"Book",
			c.date 								"Checkout Date",
			l.due 								"Due Date",
			r.date 								"Return Date",
			(r.date - l.due) 					"Days Overdue",
			concat('$',r.fine) 					"Fine"
	from 	loans l
	join 	checkouts c on c.id = l.checkout_id
	join 	returns r on r.id = l.return_id
	join 	books b on b.id = l.book_id
	join 	patrons p on p.id = l. patron_id
)

select 		* 
from 		x 
where 		"Days Overdue" > 0
order by	6 desc;


