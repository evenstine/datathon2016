-- used to identify duplicate entries in classified jobs.

create temp table dupe_jobs as select job_id, title, subclasses, salary_type, raw_job_type, segment, hat, count(1) as count from classified_jobs group by job_id, title, subclasses, salary_type, raw_job_type, segment, hat having count(1) > 1 order by count desc;

select j.* from classified_jobs j join dupe_jobs d on j.job_id = d.job_id and j.title = d.title and j.subclasses=d.subclasses and j.salary_type=d.salary_type and j.segment=d.segment and j.hat=d.hat;
