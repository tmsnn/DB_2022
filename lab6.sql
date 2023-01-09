-- create database assignment_6;
create table locations(
    location_id serial primary key,
    street_address varchar(255),
    postal_code varchar(12),
    city varchar(30),
    state_province varchar(12)
);
create table departments(
    department_id serial primary key,
    department_name varchar(50) unique,
    budget integer,
    location_id integer references locations
);
create table employees(
    employee_id serial primary key,
    first_name varchar(50),
    last_name varchar(50),
    email varchar(50),
    phone_number varchar(20),
    salary integer,
    department_id integer references departments
);
--3 INSERT 5 values rows to each table
INSERT INTO locations(location_id, street_address, postal_code, city, state_province)
VALUES(1,'Moscow', 415, 'Talgar', 'Kazakhstan');
INSERT INTO locations(location_id, street_address, postal_code, city, state_province)
VALUES(2, 'Gagarin', 316, 'Astana', 'USA');
INSERT INTO locations(location_id, street_address, postal_code, city, state_province)
VALUES(3, 'Satbayev', 517, 'New York', 'Hongary');
INSERT INTO locations(location_id, street_address, postal_code, city, state_province)
VALUES(4, 'Tole bi', 614, 'Los Angeles', 'France');
INSERT INTO locations(location_id, street_address, postal_code, city, state_province)
VALUES(5, 'Gogol', 813, 'Almaty', 'Italy');

INSERT INTO departments(department_id, department_name, budget, location_id)
VALUES(30, 'Finance', 100000, 1);
INSERT INTO departments(department_id, department_name, budget, location_id)
VALUES(50, 'SMM', 250000, 2);
INSERT INTO departments(department_id, department_name, budget, location_id)
VALUES(60, 'Develop', 170000, 3);
INSERT INTO departments(department_id, department_name, budget, location_id)
VALUES(70, 'health', 216000, 4);
INSERT INTO departments(department_id, department_name, budget, location_id)
VALUES(80, 'scientist', 348000, 5);

INSERT INTO employees(employee_id, first_name, last_name, email, phone_number, salary, department_id)
VALUES(100, 'Tomiris', 'Nyshanbek','t_nyshanbek@kbtu.kz', '87473037940', 1000000, 30);
INSERT INTO employees(employee_id, first_name, last_name, email, phone_number, salary, department_id)
VALUES(101, 'Aruzhan', 'Kakharmanova', 'coolgirl2004@gmail.com', '87470780038', 980000, 50);
INSERT INTO employees(employee_id, first_name, last_name, email, phone_number, salary, department_id)
VALUES(102, 'Dilyara', 'Muлhambetova', 'acmfeegirl@gmail.com', '87711768752', 1100000, 60);
INSERT INTO employees(employee_id, first_name, last_name, email, phone_number, salary, department_id)
VALUES(103, 'Nursultan', 'Kassymkhan', 'sabininamama@gmail.com', '87759315604', 500, 70);
INSERT INTO employees(employee_id, first_name, last_name, email, phone_number, salary, department_id)
VALUES(104, 'Bauyrzhan', 'Kilybay','toxicboy@gmail.com,', '87053072666',600000, 80);

--8
select first_name, last_name, employees.department_id, department_name from employees
left join departments d on employees.department_id = d.department_id;
