
**timescaledb**

`SELECT * FROM timescaledb_information.hypertables;

`SELECT show_chunks('history', older_than => (EXTRACT(epoch FROM NOW()) - (60 * 60 * 24 * 1))::integer);

[https://chat.openai.com/share/c720a5b0-941e-4a3b-8fff-10ccaeb7aa9f](https://chat.openai.com/share/c720a5b0-941e-4a3b-8fff-10ccaeb7aa9f)


**pid removing**

`ps aux | grep “SELECT waiting” | awk ‘{print $2}’ | sed ‘s/^/SELECT pg_cancel_backend(/g’ | sed ‘s/$/);/g’

`SELECT pg_cancel_backend(1737628);

**pqactivity**

```
psql -h pgb-tcrm-customer.pgsql.tcsbank.ru -p 6432 -d database -U user -a -f 1.sql -o result_1.txt

psql -h pgb-tcrm-registry.tcsbank.ru -p 6432 -U tcrm_acl -d database -c 'select * from acl.rule r inner join acl.group g on r.id = g.rule_id where http_methods && '{"POST", "DELETE", "PUT"}' and entry_points && '{"wo-lb"}';' -o result_1.csv

psql -h pgb-tcrm-registry.tcsbank.ru -p 5432 -d database -U tcrm -c «select id, last_update, expiration_date, md5sum, access_mode, size, alias, file_path, owner, original_file_name, media_type, edit_mode, http_link, watermark, http_link_auth_code FROM file_storage.file_metadata WHERE expiration_date > '2023-05-01 00:00:00' and last_update > '2023-02-20 00:00:00’»

psql -h  [pgb-tcrm-customer.pgsql.tcsbank.ru](http://pgb-tcrm-customer.pgsql.tcsbank.ru) -p 6432  -d database -U tcrm_customer -c ‘select * from public.customer_disability;’ -o customer_prod_disability.csv
```


**Creating user and schema**

```
CREATE ROLE new_role WITH

LOGIN

NOSUPERUSER

NOCREATEDB

NOCREATEROLE

INHERIT

NOREPLICATION

CONNECTION LIMIT -1

PASSWORD ‘****’;


CREATE SCHEMA "schemaname"

    AUTHORIZATION twork_entity;

GRANT ALL ON SCHEMA "ufebs_letters" TO new_role;

###GRANT ALL ON DATABASE db_name TO save_vars_from_background;

GRANT CONNECT ON DATABASE db_name TO new_role;

CREATE ROLE "user_role" WITH

LOGIN

NOSUPERUSER

NOCREATEDB

NOCREATEROLE

INHERIT

NOREPLICATION

CONNECTION LIMIT -1

PASSWORD 'passwd';

GRANT CONNECT ON DATABASE dbname TO "user";

GRANT USAGE ON SCHEMA schemaname TO "user";

ALTER DEFAULT PRIVILEGES IN SCHEMA schemaname

GRANT SELECT ON TABLES TO "user";

GRANT USAGE ON SCHEMA schemaname TO "user";

ALTER DEFAULT PRIVILEGES IN SCHEMA schemaname

GRANT SELECT ON TABLES TO "user";
```

Select on all table in schema

```
GRANT SELECT ON ALL TABLES IN SCHEMA schemaname TO "username"; 
```

Session removing

```
select pid from pg_stat_activity where state = 'idle';

SELECT pg_terminate_backend(22779);
```

Dump

```
pg_dump -Fd --no-owner --host=hostname -p 6432 --username=username --dbname=dbname --schema=schema -j 1 --verbose -f /dumps/dump_file  
  
pg_restore -Fd --host=hostname -p 6432 --username=username --dbname=dbname -j 4 --verbose /dumps/dump_file

pg_restore --host=hostname -p 6432 --username=username --dbname=dbname -j 1 --verbose /dumps/dump_file  

```


Detect invalid indexes

```
SELECT * FROM pg_class, pg_index WHERE pg_index.indisvalid = false AND pg_index.indexrelid = pg_class.oid;
```

Create index

Show progress:

https://dba.stackexchange.com/questions/11329/monitoring-progress-of-index-construction-in-postgresql  

```
SELECT

  now()::TIME(0),

  a.query,

  p.phase,

  round(p.blocks_done / p.blocks_total::numeric * 100, 2) AS "% done",

  p.blocks_total,

  p.blocks_done,

  p.tuples_total,

  p.tuples_done,

  ai.schemaname,

  ai.relname,

  ai.indexrelname

FROM pg_stat_progress_create_index p

JOIN pg_stat_activity a ON p.pid = a.pid

LEFT JOIN pg_stat_all_indexes ai on ai.relid = p.relid AND ai.indexrelid = p.index_relid;
```
  
Create index

```
CREATE INDEX CONCURRENTLY IF NOT EXISTS rev_info_revision_dttm_idx

ON rev_info(revision_dttm);
```

Get number of string in table

```
SELECT reltuples::bigint

FROM pg_catalog.pg_class

WHERE relname = ‘table_name;
```

Table size

```
SELECT pg_size_pretty( pg_relation_size( ‘table_name’ ) );
```

