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
            from		x
join 		staff s on s.id = x."ID" 
join        roles r on r.id = s.role_id
group by 	1, 2
order by 	3 desc, 1;