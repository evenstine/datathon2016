#!/bin/sh

psql -d datathone2016 -f ./sql/load_data_to_postgres.sql
psql -d datathone2016 -f ./sql/denormalize.sql
