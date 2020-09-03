create database body;

CREATE TABLE v2.lines (
    id numeric(10,0),
    name character varying(20),
    applications text,
    effect_time time without time zone,
    description text,
    pingying character varying(20)
);

CREATE TABLE v2.points (
    id numeric(10,0),
    name character varying(20),
    line_name character varying(20),
    pingying character varying(20),
    name_explained character varying(80),
    applications character varying(220),
    description character varying(240)
);

