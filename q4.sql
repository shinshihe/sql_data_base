	

create or replace function Q7_a(name TEXT)
returns burger_id int as $$
	select pizza from likes where likes.person = (
	select people.id from people where people.name = name)

$$ language sql; 




create or replace function Q7(person TEXT)
	returns comments TEXT as $$
	selecy Q7_A
	
--	('%'|| item ||'%')
	
$$ language sql;
