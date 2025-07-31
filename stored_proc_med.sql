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