-------------------------------------------
-- JOBS_ALL

DROP TABLE IF EXISTS jobs_all; 

CREATE TABLE jobs_all
(
	job_id	bigint
,	title	varchar(238)
,	raw_location	varchar(255)
,	location_id	varchar(42)
,	subclasses	smallint
,	salary_type	varchar(1)
,	salary_min	bigint
,	salary_max	bigint
,	raw_job_type	varchar(217)
,	abstract	TEXT
,	Segment	varchar(7)
,	hat	smallint
);

COPY jobs_all FROM '/Users/juanestebanmonsalvetobon/Work/datathon/all/jobs_all.csv' DELIMITER E'\t' CSV HEADER ENCODING 'latin-1';
CREATE INDEX job_id_index ON jobs_all (job_id);
ANALYSE jobs_all;

DROP TABLE IF EXISTS job_impressions_all;

CREATE TABLE job_impressions_all
(
	job_id	bigint
,	user_id	bigint
,	session_id	bigint
,	search_id	bigint
,	search_ranking	smallint
,	mobile_user	smallint
,	created_at	timestamp
);

COPY job_impressions_all FROM '/Users/juanestebanmonsalvetobon/Work/datathon/all/job_impressions_all.csv' DELIMITER E'\t' CSV HEADER ENCODING 'latin-1';

CREATE INDEX job_impressions_job_id_index ON job_impressions_all (job_id);
CREATE INDEX job_impressions_user_id_index ON job_impressions_all (user_id);
ANALYSE job_impressions_all;

DROP TABLE IF EXISTS job_clicks_all;

CREATE TABLE job_clicks_all
(
	job_id	bigint
,	user_id	bigint
,	session_id	bigint
,	search_id	bigint
,	created_at	timestamp
);

COPY job_clicks_all FROM '/Users/juanestebanmonsalvetobon/Work/datathon/all/job_clicks_all.csv' DELIMITER E'\t' CSV HEADER ENCODING 'latin-1';

CREATE INDEX job_clicks_job_id_index ON job_clicks_all (job_id);
CREATE INDEX job_clicks_user_id_index ON job_clicks_all (user_id);
ANALYSE job_clicks_all;

DROP TABLE IF EXISTS job_searches_all;

CREATE TABLE job_searches_all
(
	user_id	bigint
,	search_id	bigint
,	raw_location	varchar(320)
,	location_id	varchar(13)
,	latitude	float
,	longitude	float
,	query	varchar(331)
,	mobile_user	smallint
,	created_at	timestamp
);

COPY job_searches_all FROM '/Users/juanestebanmonsalvetobon/Work/datathon/all/job_searches_all.csv' DELIMITER E'\t' CSV HEADER ENCODING 'latin-1';

CREATE INDEX job_searches_user_id_index ON job_searches_all (user_id);
CREATE INDEX job_searches_search_id_index ON job_searches_all (search_id);
ANALYSE job_searches_all;

DROP TABLE IF EXISTS job_classification;

CREATE TABLE job_classification
(
	class_id	bigint
,	class_description	text
,	sub_class_id	bigint
,	sub_class_description	text
);


COPY job_classification FROM '/Users/juanestebanmonsalvetobon/Work/datathon/all/job_classification.txt' DELIMITER E'\t' CSV HEADER ENCODING 'latin-1';

ANALYSE job_classification;

