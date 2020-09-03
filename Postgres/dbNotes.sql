CREATE FUNCTION update_modified_column() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    NEW.updated_ts = now();                                                          
    RETURN NEW;   
END;
$$;

CREATE SEQUENCE node_seq
    START WITH 5
    INCREMENT BY 5
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;

CREATE TABLE node (
    name character varying(50) NOT NULL,
    template_name character varying(20),
    val character varying(12000),
    created_ts timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    updated_ts timestamp without time zone,
    meta character varying(500),
    seq integer DEFAULT nextval(node_seq::regclass),
    ver int default 0
--CONSTRAINT node_pkey PRIMARY KEY (seq, ver);
);
create unique index node_name_uix on node(name, ver) ;

CREATE TABLE node_dup (
    name character varying(500),
    template_name character varying(20),
    val character varying(12000),
    created_ts timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    updated_ts timestamp without time zone,
    meta character varying(500),
    seq integer
);


CREATE TABLE relation (
    s_name character varying(50) NOT NULL,
    t_name character varying(50) NOT NULL,
    relation character varying(30) NOT NULL,
    val character varying(500),
    created_ts timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    updated_ts timestamp without time zone,
CONSTRAINT relation_pk PRIMARY KEY (s_name, t_name, relation);
);


CREATE TABLE relation_dup (
    s_name character varying(50) NOT NULL,
    t_name character varying(50) NOT NULL,
    relation character varying(30) NOT NULL,
    val character varying(500),
    created_ts timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    updated_ts timestamp without time zone
);


CREATE TABLE relation_list (
    val character varying(30) NOT NULL,
    text character varying(30),
CONSTRAINT relation_list_pkey PRIMARY KEY (val);
);

CREATE TABLE public.template (
    name character varying(20) NOT NULL,
    template character varying(500),
    created_ts timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    updated_ts timestamp without time zone,
CONSTRAINT template_pkey PRIMARY KEY (name);
);

CREATE TRIGGER node_updated AFTER UPDATE ON node 
FOR EACH ROW EXECUTE PROCEDURE update_modified_column();

