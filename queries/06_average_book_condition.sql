-- Average condition of all books collection.
select 		condition                                               "Condition"
			,count(*)                                               "Count"
			,concat((count(*) 
					* 
					100
					/
					(select count(*) from books)) , '% of Books')   "Percentage"
from		books b
left join 	conditions c on c.id = b.condition_id
group by 	1
order by	2 desc, 1;