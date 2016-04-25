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

drop table if exists search_impressions_clicks;

create table search_impressions_clicks as
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
	case when i.job_id is null then 'no-results'::text else 'impression'::text end  as event_type,
	i.search_id as event_search_id,
	i.job_id,
	i.session_id,
	i.search_ranking,
	i.created_at as time_of_event
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
	case when c.job_id is null then 'no-results'::text else 'click'::text end  as event_type,
	c.search_id as event_search_id,
	c.job_id,
	c.session_id,
	null as search_ranking,
	c.created_at as time_of_event
from
	job_searches_all as s
left join
	job_clicks_all as c
on
	s.search_id = c.search_id and s.user_id = c.user_id
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
	'impression'::text as event_type,
	i.search_id as event_search_id,
	i.job_id,
	i.session_id,
	i.search_ranking,
	i.created_at as time_of_event
from
	job_searches_all as s
right join
	job_impressions_all as i
on
	s.search_id = i.search_id and s.user_id = i.user_id
where 
	s.search_id is null
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
	case when c.job_id is null then 'no-results'::text else 'click'::text end  as event_type,
	c.search_id as event_search_id,
	c.job_id,
	c.session_id,
	null as search_ranking,
	c.created_at as time_of_event
from
	job_searches_all as s
left join
	job_clicks_all as c
on
	s.search_id = c.search_id and s.user_id = c.user_id
where
	s.search_id is null;

create index search_impressions_clicks_search_id_index on search_impressions_clicks(search_id);
create index search_impressions_clicks_job_id_index on search_impressions_clicks(job_id);
create index search_impressions_clicks_event_type_index on search_impressions_clicks(event_type);

analyse search_impressions_clicks;

create table jobs_search_impressins_clicks as select
	s.user_id,
	s.search_id,
	s.raw_location as search_raw_location,
	s.location_id as sesarch_location_id,
	s.latitude as search_latitude,
	s.longitude as search_longitude,
	s.query as search_query,
	s.mobile_user,
	s.time_of_search,
	s.event_type,
	s.event_search_id,
	s.session_id,
	s.search_ranking,
	s.time_of_event,
	c.job_id,
	c.title as job_title,
	c.raw_location as job_raw_location,
	c.location_id as job_location_id,
	c.subclasses as job_subclasses,
	c.salary_type as job_salary_type,
	c.salary_min as job_salary_min,
	c.salary_max as job_salary_max,
	c.raw_job_type,
	c.abstract as job_abstract,
	c.segment as job_segment,
	c.hat,
	c.class_description as job_class_description,
	c.sub_class_description as job_sub_class_description
from
	search_impressions_clicks as s
left join
	classified_jobs as c
on
	s.job_id = c.job_id;

create index jobs_search_impressins_clicks_user_id_index on jobs_search_impressins_clicks(user_id);
create index jobs_search_impressins_clicks_search_id_index on jobs_search_impressins_clicks(search_id);
create index jobs_search_impressins_clicks_job_id_index on jobs_search_impressins_clicks(job_id);

analyse jobs_search_impressins_clicks;

