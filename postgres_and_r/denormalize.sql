select 
	j.job_id,
	j.title,
	j.abstract,
	j.hat,
	j.salary_min,
	j.salary_max,
	j.raw_job_type,
	ji.session_id,
	js.search_id,
	js.user_id, 
	js.query,
	jc.user_id,
	ji.search_ranking,
	js.raw_location as job_search_location,
	j.raw_location as job_location,
	jclass.class_id,
	jclass.class_description,
	jclass.sub_class_description,
	js.mobile_user,
	j.segment,
	js.created_at as job_search_created,
	ji.created_at as job_impression_created,
	jc.created_at as job_click_created
from
	jobs_all j,
	jobs_impressions_all ji,
	job_searches_all js,
	job_clicks_all jc,
	job_classification jclass
where
	j.job_id = ji.job_id
	and jc.job_id = j.job_id
	and jc.user_id = js.user_id
	and jc.search_id = js.search_id
	and (j.subclasses = -1 or j.subclasses = jclass.sub_class_id)
