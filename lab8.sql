-- 1.Create a function that:
-- a. Increments given values by 1 and returns it.
CREATE FUNCTION inc(val integer) RETURNS integer AS
$$
BEGIN
    RETURN val + 1;
END;
$$
    LANGUAGE plpgsql;

select inc(4);
-- b. Returns sum of 2 numbers.
CREATE FUNCTION sum_of_two_integers(a integer, b integer)
    RETURNS integer AS
$$
BEGIN
    RETURN a + b;
END;
$$
    language plpgsql;
select sum_of_two_integers(3, 4);
-- c. Returns true or false if numbers are divisible by 2.
CREATE or replace FUNCTION is_even(val integer) returns boolean as
$$
begin
    return 1 - val % 2;
end;
$$
    LANGUAGE plpgsql;
select is_even(6);
-- d. Checks some password for validity.


CREATE or replace FUNCTION check_password(password text) returns boolean as
$$
BEGIN
    if (password like 'A%') then
        return true;
        --Minimum eight characters, at least one letter and one number
    else
        return false;
    end if;
end;
$$ LANGUAGE plpgsql;

select check_password('Tomik');

drop FUNCTION two_outputs;
-- e. Returns two outputs, but has one input.

CREATE or replace FUNCTION two_outputs(val integer, out a integer, out b integer)
as
$$
begin
    a = val + 2;
    b = val * 10;
end;
$$ language plpgsql;

select two_outputs(2);

create schema task4

    create table my_table(
        id             integer primary key not null,
        name           varchar             not null,
        date_of_birth  timestamp           not null,
        age            integer             not null,
        salary         integer,
        workexperience integer,
        discount       integer
    );

create table my_table_history
(
    id                 serial primary key not null,
    operation_name     varchar            not null,
    operation_datetime timestamp          not null

);
insert into my_table
values (1, 'Tomiris', '2003-05-11', 19, 500000, 1, 0);
insert into my_table
values (2, 'Aruzhan', '2001-07-01', 21, 800000, 3, 10);
insert into my_table
values (3, 'Diliyara', '2003-07-11', 19, 600000, 2, 15);
-- drop table my_table;
drop function get_date_of_birth;
create or replace function get_date_of_birth(current_year integer)
    returns table
            (
                name_of_people varchar,
                year_of_birth  integer
            )
as
$get_date_of_birth$

begin
    RETURN QUERY SELECT name, current_year - age from my_table;
end;
$get_date_of_birth$ language plpgsql;

select *
from get_date_of_birth(2022);
--
-- 2. Create a trigger that:
-- a.Return timestamp of the occured action within the database.
create or replace function schema_update() returns trigger as
$schema_update$
declare
    operation_date timestamp;
begin
    if (tg_op = 'DELETE') then
        insert into my_table_history (operation_name, operation_datetime)
        values (tg_op, now());
        return old;

    ELSE
        INSERT INTO my_table_history (operation_name, operation_datetime)
        VALUES (TG_OP, now());

        RETURN NEW;
    end if;

end;
$schema_update$ LANGUAGE plpgsql;

-- select current_timestamp
drop trigger date_trigger on my_table;
create trigger date_trigger
    after INSERT OR UPDATE OR DELETE
    on my_table
    for each row
execute function schema_update();

alter table my_table
    enable trigger date_trigger;
select *
from my_table;
insert into my_table
values (15, 'bA', '2003-03-04', 12, 12333, 1, 3);

SELECT *
FROM my_table_history

-- b.Computes the age of a person when persons’ date of birth is inserted.

create table persons_age
(
    age integer
);

create or replace function insert_birthday() returns trigger as
$insert_birthday$

begin
    raise notice '%', date_part('year', now()) - date_part('year', new.date_of_birth);
    return new;
end;
$insert_birthday$ language plpgsql;

create trigger birth_date_trigger
    before insert
    on my_table
    for each row
execute procedure insert_birthday();

alter table my_table
    enable trigger birth_date_trigger;

select *
from my_table;

select *
from persons_age;

insert into my_table
values (53, 'Damir', '2011-03-12', 12, 100000, 1, 3);
-- c.Adds 12% tax on the price of the inserted item.
create table market
(
    tovar_id    integer primary key,
    tovar       varchar(40),
    total_price integer not null
);


create or replace function add_tax() returns trigger as
$$
begin
    update market set total_price = total_price * 1.12 where total_price = total_price;
    return new;
end;
$$ language plpgsql;

create trigger add_tax_trigger
    after insert
    on market
execute procedure add_tax();

alter table market
    enable trigger add_tax_trigger;
insert into market
values (1, 'Burger', 100);
insert into market
values (2, 'Cola', 200);
select *
from market
-- d.Prevents deletion of any row from only one table.
create function prevent_deleting() returns trigger as
$$
begin
    raise exception 'Delete prevented';
end;
$$ language plpgsql;

create trigger prevent_deleting_trigger
    before delete
    on market
    for each row
execute function prevent_deleting();
alter table market
    enable trigger prevent_deleting_trigger
delete
from market
where tovar_id = 2;


-- e.Launches functions  1.d and 1.e.

create table accounts
(

    id       integer,
    username varchar(10),
    password varchar(10)
);

create or replace function launch_functions() returns trigger as
$$
begin
    raise notice '%', check_password(new.password);
    raise notice '%', two_outputs(new.id);
    return new;
end;
$$ LANGUAGE plpgsql;
create trigger launch_trigger
    before insert
    on accounts
    for each row
execute procedure launch_functions();
alter table accounts
    enable trigger launch_trigger;
insert into accounts
values (1, 'Bakha', 'Aakytzhan');
-- 3.Create procedures that:
-- a)Increases salary by 10% for every 2 years of work experience and provides
-- 10% discount and after 5 years adds 1% to the discount.
create or replace procedure increase_and_provide_features(experience integer)
    language plpgsql
as
    $$
    declare cnt int;
begin
        cnt = experience / 2;
        for i in 0..cnt
        loop
            update my_table set discount = discount * 1.01;
            end loop;
        commit ;
end;
    $$;


--
-- b)After reaching 40 years, increase salary by 15%. If work experience is more
-- than 8 years, increase salary for 15% of the already increased value for work
-- experience and provide a constant 20% discount.
create procedure increase_and_provide(experience integer)
language plpgsql
as
    $$
    declare
        cnt int;
begin
    cnt = experience/40;
    for i in 0..cnt
        loop
        update my_table set salary = salary * 1.15 where salary = salary;
        end loop;
    cnt = experience/5;
    if(experience > 8) then update my_table set salary = salary * 1.15, discount = 20 where salary = salary;
    end if;
    commit ;
end;
    $$;
-- Consider the following schema for the task4:

