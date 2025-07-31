-- SELECT * FROM USERS;

drop function hello_world();

CREATE or replace function hello_world() returns varchar
language plpgsql AS
    $$
        BEGIN
            return CONCAT('hello', ' world', ' !! ', current_timestamp);
        end;
    $$;


select * from hello_world()	;

-----------------------------------------------------------------------

drop procedure create_demo_table();

CREATE or replace procedure create_demo_table()
language plpgsql AS
    $$
        BEGIN
			CREATE TABLE IF NOT EXISTS demo (
			            id SERIAL PRIMARY KEY,
			            name TEXT NOT NULL,
			            email TEXT UNIQUE NOT NULL
			        );
        end;
    $$;

CALL create_demo_table();

-----------------------------------------------------------------------
-- Write a query that takes two numbers of type double precision, adds them, and returns the sum.

CREATE OR REPLACE FUNCTION sp_sum(m DOUBLE PRECISION, n DOUBLE PRECISION)
RETURNS DOUBLE PRECISION
LANGUAGE plpgsql AS
$$
DECLARE
    x INTEGER := 0;
BEGIN
	--
    RETURN m + n + x;
END;
$$;

select sp_sum(2.2, 3.5);

-----------------------------------------------------------------------
-- Write a query that multiplies two numbers and also
-- divides the first number by the second
-- The function should return both results

CREATE OR REPLACE FUNCTION sp_product(x DOUBLE PRECISION, y DOUBLE PRECISION,
    OUT prod DOUBLE PRECISION,
    OUT div_res DOUBLE PRECISION)
LANGUAGE plpgsql AS
$$
DECLARE
    z DOUBLE PRECISION := 1.0;
BEGIN
    prod = x * y * z;
    div_res = x / y;
END;
$$;

select * from sp_product(8, 2);

-- create function that gets 2 numbers
-- return sum, diff, num1 power 2, num2 power 3
-- (8, 4) ==> 12, 4, 64, 64




