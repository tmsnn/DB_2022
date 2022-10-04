CREATE TYPE gender as ENUM('M', 'F');
CREATE TABLE IF NOT EXISTS employees(
    emp_no     INT PRIMARY KEY,
    birth_date DATE NOT NULL,
    first_name VARCHAR(14) NOT NULL,
    last_name  VARCHAR(16) NOT NULL,
    gender     gender,
    hire_date  DATE NOT NULL
);
CREATE TABLE IF NOT EXISTS departments(
    dept_no   CHAR(4) PRIMARY KEY,
    dept_name VARCHAR(40) NOT NULL
);
CREATE TABLE IF NOT EXISTS dept_manager(
    dept_no   CHAR(4) references departments(dept_no),
    emp_no    INT references employees(emp_no),
    from_name DATE NOT NULL,
    to_date   DATE NOT NULL
--     FOREIGN KEY(emp_no) references employees,
--     FOREIGN KEY(dept_no) references departments
);

CREATE TABLE IF NOT EXISTS dept_emp(
    emp_no    INT references employees(emp_no),
    dept_no   CHAR references departments(dept_no),
    from_date DATE NOT NULL,
    to_date   DATE NOT NULL
--     FOREIGN KEY(emp_no) references employees,
--     FOREIGN KEY(dept_no) references departments
);
CREATE TABLE IF NOT EXISTS salaries(
    emp_no    INT references employees(emp_no),
    salary    INT NOT NULL,
    from_date DATE PRIMARY KEY ,
    to_date   DATE NOT NULL
--     FOREIGN KEY(emp_no) references employees
);
CREATE TABLE IF NOT EXISTS titles(
    emp_no    INT references employees(emp_no),
    title     VARCHAR(50),
    from_date DATE PRIMARY KEY ,
    to_date   DATE NULL
--     FOREIGN KEY(emp_no) references employees
);
