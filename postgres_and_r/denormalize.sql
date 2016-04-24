drop table if exists classified_jobs;

create table classified_jobs as 
	select 
		j.*, 
		c.class_description, 
		c.sub_class_description 
	from 
		jobs_all as j 
	left join 
		job_classification as c 
	on 
		c.sub_class_id = j.subclasses;

create index classified_jobs_job_id_index on classified_jobs (job_id);
analyse classified_jobs;

select
	s.user_id,
	s.search_id,
	s.raw_location,
	s.location_id,
	s.latitude,
	s.longitude,
	s.query,
	s.mobile_user,
	s.created_at as time_of_search,
	'impression' as event_type,
	i.job_id,
	i.session_id,
	i.search_ranking,
	i.created_at as time_of_impresion
from
	job_searches_all as s
left join
	job_impressions_all as i
on
	s.search_id = i.search_id and s.user_id = i.user_id
union
select
	s.user_id,
	s.search_id,
	s.raw_location,
	s.location_id,
	s.latitude,
	s.longitude,
	s.query,
	s.mobile_user,
	s.created_at as time_of_search,
	'click' as event_type,
	c.job_id,
	c.session_id,
	null as search_ranking,
	c.created_at as time_of_click
from
	job_searches_all as s
left join
	job_clicks_all as c
on
	s.search_id = c.search_id and s.user_id = c.user_id
