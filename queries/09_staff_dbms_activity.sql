-- Staff count of records creations in database system. 
with x as (
	select		created_staff_id "ID", 
				case when 1=1 then 'Books' end as 	"Record Type"
	from		books
	union
	select		created_staff_id "ID", 
				case when 1=1 then 'Checkouts' end	"Record Type"
	from		checkouts
	union
	select		created_staff_id "ID", 
				case when 1=1 then 'Loans' end		"Record Type"
	from		loans
	union
	select		created_staff_id "ID", 
				case when 1=1 then 'Patrons' end  	"Record Type"
	from		patrons
	union
	select		created_staff_id "ID", 
				case when 1=1 then 'Returns' end  	"Record Type"
	from		returns
	union
	select		created_staff_id "ID", 
				case when 1=1 then 'Staff' end		"Record Type"
	from		staff 			
)

select 		concat(s.fname, ' ', s.lname) "Name"
			,count("Record Type") "Count"
from		x
join 		staff s on s.id = x."ID" 
group by 	"Name"
order by 	"Name";
