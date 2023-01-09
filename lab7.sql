create database lab7;
create table dealer (
    id integer primary key ,
    name varchar(255),
    location varchar(255),
    commission float
);
-- drop table dealer;

INSERT INTO dealer (id, name, location, commission) VALUES (101, 'Oleg', 'Astana', 0.15);
INSERT INTO dealer (id, name, location, commission) VALUES (102, 'Amirzhan', 'Almaty', 0.13);
INSERT INTO dealer (id, name, location, commission) VALUES (105, 'Ademi', 'Taldykorgan', 0.11);
INSERT INTO dealer (id, name, location, commission) VALUES (106, 'Azamat', 'Kyzylorda', 0.14);
INSERT INTO dealer (id, name, location, commission) VALUES (107, 'Rahat', 'Satpayev', 0.13);
INSERT INTO dealer (id, name, location, commission) VALUES (103, 'Damir', 'Aktobe', 0.12);

create table client (
    id integer primary key ,
    name varchar(255),
    city varchar(255),
    priority integer,
    dealer_id integer references dealer(id)
);

INSERT INTO client (id, name, city, priority, dealer_id) VALUES (802, 'Bekzat', 'Satpayev', 100, 101);
INSERT INTO client (id, name, city, priority, dealer_id) VALUES (807, 'Aruzhan', 'Almaty', 200, 101);
INSERT INTO client (id, name, city, priority, dealer_id) VALUES (805, 'Али', 'Almaty', 200, 102);
INSERT INTO client (id, name, city, priority, dealer_id) VALUES (808, 'Yerkhan', 'Taraz', 300, 102);
INSERT INTO client (id, name, city, priority, dealer_id) VALUES (804, 'Aibek', 'Kyzylorda', 300, 106);
INSERT INTO client (id, name, city, priority, dealer_id) VALUES (809, 'Arsen', 'Taldykorgan', 100, 103);
INSERT INTO client (id, name, city, priority, dealer_id) VALUES (803, 'Alen', 'Shymkent', 200, 107);
INSERT INTO client (id, name, city, priority, dealer_id) VALUES (801, 'Zhandos', 'Astana', null, 105);

create table sell (
    id integer primary key,
    amount float,
    date timestamp,
    client_id integer references client(id),
    dealer_id integer references dealer(id)
);

INSERT INTO sell (id, amount, date, client_id, dealer_id) VALUES (201, 150.5, '2021-10-05 00:00:00.000000', 805, 102);
INSERT INTO sell (id, amount, date, client_id, dealer_id) VALUES (209, 270.65, '2021-09-10 00:00:00.000000', 801, 105);
INSERT INTO sell (id, amount, date, client_id, dealer_id) VALUES (202, 65.26, '2021-10-05 00:00:00.000000', 802, 101);
INSERT INTO sell (id, amount, date, client_id, dealer_id) VALUES (204, 110.5, '2021-08-17 00:00:00.000000', 809, 103);
INSERT INTO sell (id, amount, date, client_id, dealer_id) VALUES (207, 948.5, '2021-09-10 00:00:00.000000', 805, 102);
INSERT INTO sell (id, amount, date, client_id, dealer_id) VALUES (205, 2400.6, '2021-07-27 00:00:00.000000', 807, 101);
INSERT INTO sell (id, amount, date, client_id, dealer_id) VALUES (208, 5760, '2021-09-10 00:00:00.000000', 802, 101);
INSERT INTO sell (id, amount, date, client_id, dealer_id) VALUES (210, 1983.43, '2021-10-10 00:00:00.000000', 804, 106);
INSERT INTO sell (id, amount, date, client_id, dealer_id) VALUES (203, 2480.4, '2021-10-10 00:00:00.000000', 809, 103);
INSERT INTO sell (id, amount, date, client_id, dealer_id) VALUES (212, 250.45, '2021-06-27 00:00:00.000000', 808, 102);
INSERT INTO sell (id, amount, date, client_id, dealer_id) VALUES (211, 75.29, '2021-08-17 00:00:00.000000', 803, 107);
INSERT INTO sell (id, amount, date, client_id, dealer_id) VALUES (213, 3045.6, '2021-04-25 00:00:00.000000', 802, 101);

-- drop table client;
-- drop table dealer;
-- drop table sell;

--1
-- a. find those clients with a priority less than 300
select * from client where priority < 300;

-- b. combine each row of dealer table with each row of client table
select * from dealer
inner join client c on dealer.id = c.dealer_id;

-- c. find all dealers along with client name, city, priority, sell number, date, and amount
select a.name as "Client Name", a.city as "Client City", a.priority, b.id as "Sell ID", b.date, b.amount
from client a
left outer join sell b on a.id = b.client_id
order by b.date;

-- d. find the dealer and client who reside in the same city
select dealer.name as "Dealer", client.name as "Client", city
from client, dealer
where dealer.location = client.city;

-- e. find sell id, amount, client name, city those sells where sell amount exists between
-- 200 and 500
select a.id, a.amount, b.name as "Client Name", b.city as "Client City"
from sell a, client b
where a.client_id = b.id and
      a.amount between 200 and 500;

-- f. find dealers who works either for one or more client or not yet join under any of
-- the clients
select * from dealer d
    left join client c on d.id = c.dealer_id;

-- g. find the dealers and the clients he service, return client name, city, dealer name,
-- commission.
select a.name as "Client Name", a.city, b.name as "Dealer Name", b.commission
from client a, dealer b where b.location = a.city;

-- h. find client name, client city, dealer, commission those dealers who received a
-- commission from the sell more than 13%
SELECT a.name AS "Client Name", a.city, b.name AS "Dealer", b.commission
FROM client a
INNER JOIN dealer b
ON a.dealer_id = b.id
WHERE b.commission > 0.13;

-- i. make a report with client name, city, sell id, sell date, sell amount, dealer name
-- and commission to find that either any of the existing clients haven’t made a
-- purchase(sell) or made one or more purchase(sell) by their dealer or by own.
select a.name, a.city, b.id, b.date, b.amount, c.name, c.commission
from client a left outer join sell b on a.id = b.client_id
left outer join dealer c on c.id = b.dealer_id

-- j. find dealers who either work for one or more clients. The client may have made,
-- either one or more purchases, or purchase amount above 2000 and must have a
-- priority, or he may not have made any purchase to the associated dealer. Print
-- client name, client priority, dealer name, sell id, sell amount
select a.name, a.city, a.priority, b.name as "Dealer Name", c.id as "Order ID", c.date, c.amount
from client a
    right join dealer b on b.id = a.dealer_id
left outer join sell c on c.client_id = a.id
where c.amount >= 2000 and a.priority is not null;

-- 2
-- a. count the number of unique clients, compute average and total purchase
-- amount of client orders by each date.
create view unique_clients as
select count(distinct client_id), avg(amount), sum(amount)
from sell
group by date;
select *
from unique_clients;

-- b. find top 5 dates with the greatest total sell amount
create view top_5
as select date ,amount from sell
order by date limit 5;
select * from top_5;
drop view top_5;

-- c. count the number of sales, compute average and total amount of all
-- sales of each dealer
create view report_dealer_sales
as select a.name, avg(amount), sum(amount)
from dealer a, sell where sell.dealer_id = a.id
group by name;
select * from report_dealer_sales;

-- d. compute how much all dealers earned from commission (total sell
-- amount *commission) in each location
create view local_commission as
select sum(comms.total_commision), location
from dealer inner join (select s.total_sum * d.commission as total_commision, d.id as dealer_id
from dealer d inner join (select sum(amount) as total_sum, sell.dealer_id
from sell group by sell.dealer_id) s on d.id = s.dealer_id) comms on comms.dealer_id = dealer.id
group by location;
select *
from local_commission;

-- e. compute number of sales, average and total amount of all sales dealers
-- made in each location
create view local_sales as
select location, sum(s.cnt) as number_of_sales, sum(sums) / sum(s.cnt) as average, sum(sums) as total_amount
from dealer
         inner join (select dealer_id, count(*) as cnt, sum(amount) as sums from sell group by sell.dealer_id) s
                    on dealer.id = s.dealer_id
group by location;
select *
from local_sales;

-- f. compute number of sales, average and total amount of expenses in
-- each city clients made.
create view city_sales as
select city, sum(s.cnt) as number_of_sales, sum(sums) / sum(s.cnt) as average, sum(sums) as total_amount
from client
         inner join (select client_id, count(*) as cnt, sum(amount) as sums from sell group by client_id) s
                    on s.client_id = client.id
group by city;
select *
from city_sales;

-- g. find cities where total expenses more than total amount of sales in
-- locations
create view expensed_cities as
select c.city from (select distinct client.city as city from client) c
         inner join local_sales on c.city = local_sales.location
         inner join city_sales on c.city = city_sales.city
where city_sales.total_amount > local_sales.total_amount;
select *
from expensed_cities;