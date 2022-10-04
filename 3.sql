CREATE TYPE gender as ENUM('M', 'F');
-- a
CREATE TABLE IF NOT EXISTS student(
    full_name       VARCHAR(50),
    age             INT check(Age > 18),
    birth_date      DATE,
    gender          gender,
    average_grade   DOUBLE PRECISION,
    nationality     VARCHAR(50),
    phone_number    VARCHAR(50),
    social_category VARCHAR(50)
    );

-- b
CREATE TABLE IF NOT EXISTS instructors(
    full_name   VARCHAR(50) NULL,
    speak_lang  VARCHAR(50),
    work_exp    VARCHAR(50),
    possibility VARCHAR(50)
);
-- c
CREATE TABLE IF NOT EXISTS relatives(
    full_name    VARCHAR(50) NULL,
    address      VARCHAR(50),
    phone_number VARCHAR(50),
    position     VARCHAR(50)
);
-- d
CREATE TABLE student_soc(
    school     VARCHAR(50),
    graduation DATE,
    address    VARCHAR(50),
    region     VARCHAR(50),
    country    VARCHAR(50) check (country != 'Ala'),
    gpa        DOUBLE PRECISION check (gpa > 2.5),
    honors     VARCHAR(50)
);
CREATE database new_db; /* DDL */
DROP database new_db;
CREATE table Persons (
 PersonID varchar(255),
 LastName varchar(255),
 FirstName varchar(255),
 Address varchar(255),
 City varchar(255)
);
ALTER TABLE Persons rename to Student;
/* DML */
INSERT INTO Student (PersonID, LastName, FirstName, Address, City)
VALUES ('21B030889', 'Nyshanbek','Tomiris','Talgar','Almaty');
UPDATE Student SET city = 'Astana' WHERE PersonID = '21B030889';
DELETE FROM Student WHERE LastName = 'Nyshanbek';
SELECT * FROM Student;
