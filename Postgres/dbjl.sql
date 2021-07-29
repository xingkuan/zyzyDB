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