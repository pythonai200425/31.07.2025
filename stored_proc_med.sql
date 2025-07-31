drop procedure if exists prepare_db_movies;

create or replace procedure prepare_db_movies()
LANGUAGE plpgsql
AS $$
BEGIN
    -- Create countries table
        CREATE TABLE IF NOT EXISTS countries (
            id   BIGSERIAL PRIMARY KEY,
            name TEXT NOT NULL UNIQUE
        );

    -- Create movies table
        CREATE TABLE IF NOT EXISTS movies (
            id           BIGSERIAL PRIMARY KEY,
            title        TEXT,
            release_date TIMESTAMP NOT NULL,
            price        DOUBLE PRECISION DEFAULT 0 NOT NULL,
            country_id   BIGINT REFERENCES countries(id)
        );


    -- Insert countries
    INSERT INTO countries(name) VALUES ('Israel');
    INSERT INTO countries(name) VALUES ('USA');
    INSERT INTO countries(name) VALUES ('JAPAN');
    INSERT INTO countries(name) VALUES ('CANADA');

    -- Insert movies
    INSERT INTO movies (title, release_date, price, country_id)
    VALUES 
        ('batman returns', '2020-12-16 20:21:00', 45.5, 3),
        ('wonder woman', '2018-07-11 08:12:11', 125.5, 3),
        ('matrix resurrection', '2021-01-03 09:10:11', 38.7, 4);

END;
$$;

call prepare_db_movies();

-------------------------------------------
drop function sp_get_expensive_movie();

CREATE OR REPLACE FUNCTION sp_get_expensive_movie() returns double precision
LANGUAGE plpgsql AS
$$
DECLARE
  max_price double precision;
BEGIN
	select max(price) INTO max_price
	from movies;
	return max_price;
END;
$$;

select sp_get_expensive_movie();
---------------------------------------
drop function sp_get_expensive_movie2();

CREATE OR REPLACE FUNCTION sp_get_expensive_movie2(out max_price double precision)
LANGUAGE plpgsql AS
$$
BEGIN
	select max(price) INTO max_price
	from movies;
END;
$$;

select sp_get_expensive_movie2();


-- create sp_get_movies_stat -- return max price, min price, avg price, number of movies

---------------------------------------
-- create sp_get_movies_stat -- return max price, min price, avg price, number of movies

drop function sp_movies_stat();

CREATE or replace function sp_movies_stat(
    OUT min_price double precision,
    OUT max_price double precision,
    OUT avg_price double precision,
    out count_movies INTEGER)
language plpgsql AS
    $$
        BEGIN
            select min(price), max(price), avg(price)::numeric(5,2), count(*)
            into min_price, max_price, avg_price, count_movies
            from movies;
        end;
    $$;
select * from sp_movies_stat();

---------------------------------------
-- 1- select * from movies

drop function sp_get_all_movies();

CREATE or replace function sp_get_all_movies()
returns TABLE(id bigint,
            title TEXT,
            release_date TIMESTAMP,
            price DOUBLE PRECISION,
            country_id bigint)
language plpgsql AS
    $$
        BEGIN
			return QUERY
            select * from movies;
        end;
    $$;
select * from sp_get_all_movies();

---------------------------------------
-- 2- select * from movies join countries

drop function sp_get_all_movies_country_name();

CREATE or replace function sp_get_all_movies_country_name()
returns TABLE(id bigint,
            title TEXT,
            release_date TIMESTAMP,
            price DOUBLE PRECISION,
            country_name TEXT)
language plpgsql AS
    $$
        BEGIN
			return QUERY
            select m.id, m.title, m.release_date, m.price, c.name as country_name from movies m
            join countries c on m.country_id  = c.id;
        end;
    $$;
select * from sp_get_all_movies_country_name();

---------------------------------------
-- 3- select * from movies join countreis price range

drop function sp_get_all_movies_country_name_range();

CREATE or replace function sp_get_all_movies_country_name_range(_min double precision,
							_max double precision)
returns TABLE(id bigint,
            title TEXT,
            release_date TIMESTAMP,
            price DOUBLE PRECISION,
            country_name TEXT)
language plpgsql AS
    $$
        BEGIN
			return QUERY
            select m.id, m.title, m.release_date, m.price, c.name as country_name from movies m
            join countries c on m.country_id  = c.id
			where m.price between _min and _max;
        end;
    $$;
select * from sp_get_all_movies_country_name_range(40, 130);
