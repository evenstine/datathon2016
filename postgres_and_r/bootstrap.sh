#!/bin/sh

psql -d datathone2016 -f load_data_to_postgres.sql
psql -d datathone2016 -f denormalize.sql
