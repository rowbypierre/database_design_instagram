-- average condition of all books collection
select 		condition "Condition",
			count(*) "Count",
			concat((count(*) * 100/(select count(*) from books)) , '% of Books') "Percent"
from		books b
			left join conditions c on c.id = b.condition_id
group by 	condition
order by	"Count" desc, condition;
