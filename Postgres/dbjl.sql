--2021.07.29
jl=# \d points
                        Table "public.points"
   Column   |         Type          | Collation | Nullable | Default 
------------+-----------------------+-----------+----------+---------
 id         | integer               |           |          | 
 name       | character varying(20) |           | not null | 
 line_name  | character varying(20) |           | not null | 
 coor       | json                  |           |          | 
 seq        | integer               |           |          | 
 isxw       | boolean               |           |          | 
 model_name | character varying(50) |           | not null | 
Indexes:
    "points_pkey" PRIMARY KEY, btree (model_name, line_name, name)
    
2021.08.02: add column sub_lines for multiple paths of a single JingLuo:
alter table points add column sub_lines int[] default value '{0}';
==>
 sub_lines  | integer[]             |           |          | '{0}'::integer[]

 --add an element:
 update points set sub_lines[1]=1;
 --select:
 select * from points where 0= any(sub_lines) ;
 --unnest:
 select name, unnest(sub_lines) from points;
 --find all the sub_lines:
 select distinct unnest(sub_lines) from points;
 --filter by sub_line
 select * from points where 0=any(sub_lines) ;
 --remove element:
 update points set sub_lines=array_remove(sub_lines, null);
 update points set sub_lines[1]=1 where line_name='足太阳膀胱经' and name='合阳';
 update points set sub_lines='{0,1,2}' where line_name='足太阳膀胱经' and name='合阳';
 select name, array_to_string(sub_lines,',') from points where line_name='足太阳膀胱经'and name='合阳';
 update points set sub_lines=array_remove(sub_lines, 1) where line_name='足太阳膀胱经' and name='合阳';
 
 2021.08.29:
 alter table points add seqs jsonb;
 with aa as (select name, line_name,seq,'{"'||name||'":'||seq||'}' jstr from points) update points b set seqs=jstr::json from aa where aa.name=b.name and aa.seq=b.seq aa.line_name=b.line_name;
 ;
 select name, seqs->name seqj from points;
update testj set col2=col2 || '{"c3":30}' where col1='test2';
 
with aa as 
(select name, line_name,seq,'{"'||line_name||'":'||seq||'}' jstr from points) 
update points b set seqs=jstr::json from aa where aa.name=b.name and aa.seq=b.seq;
 
alter table points drop column seq;
 
alter table points drop constraint points_pkey;
alter table points add constraint points_pkey PRIMARY KEY (model_name, name);

alter table points add constraint points_pkey PRIMARY KEY, btree (model_name, name);

2021.08.30:
   Column   |         Type          | Collation | Nullable |     Default      
------------+-----------------------+-----------+----------+------------------
 id         | integer               |           |          | 
 name       | character varying(20) |           | not null | 
>line_name  | character varying(20) |           | not null |                   <<< not needed 2021.08.30
 coor       | json                  |           |          | 
>seq        | integer               |           |          |                    <<<<<<<<<<<<<<<< 
 isxw       | boolean               |           |          | 
 model_name | character varying(50) |           | not null | 
>sub_lines  | integer[]             |           |          | '{0}'::integer[]   <<<<
 facing     | json                  |           |          | 
 seqs       | jsonb                 |           |          | <<<< {"足太阴脾经": {"seq":60, "sub_lines":[0]}}
Indexes:
    "points_pkey" PRIMARY KEY, btree (model_name, name)

select name, seqs->line_name->'seq' as seq, json_array_elements((seqs->line_name->'sub_lines')::json) from points;   
    
with aa as 
(select name, line_name,seq,'{"'||line_name||'":{"seq":'||seq||',"sub_lines":'||array_to_json(sub_lines)||'}}' jstr from points) 
update points b set seqs=jstr::json from aa where aa.name=b.name and aa.seq=b.seq;
 