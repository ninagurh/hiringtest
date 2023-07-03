-- SQLize Online Link: https://sqlize.online/s/Ky

DROP TABLE IF EXISTS departments CASCADE;
DROP TABLE IF EXISTS employees CASCADE;
DROP TABLE IF EXISTS cars CASCADE;
DROP TABLE IF EXISTS customers CASCADE;
DROP TABLE IF EXISTS sales CASCADE;

-- schema
CREATE TABLE departments (
    id SERIAL NOT NULL,
    Name VARCHAR(25) NOT NULL,
    PRIMARY KEY(id)
);

CREATE TABLE employees (
    id INT NOT NULL,
    FName VARCHAR(35) NOT NULL,
    LName VARCHAR(35) NOT NULL,
    PhoneNumber VARCHAR(11),
    ManagerId INT,
    DepartmentId INT NOT NULL,
    Salary INT NOT NULL,
    HireDate timestamp NOT NULL,
    PRIMARY KEY(id),
    FOREIGN KEY (ManagerId) REFERENCES Employees(id),
    FOREIGN KEY (DepartmentId) REFERENCES Departments(id)
);

CREATE TABLE customers (
    id SERIAL NOT NULL,
    FName VARCHAR(35) NOT NULL,
    LName VARCHAR(35) NOT NULL,
    Email varchar(100) NOT NULL,
    PhoneNumber VARCHAR(11),
    PreferredContact VARCHAR(5) NOT NULL,
    PRIMARY KEY(id)
);

CREATE TABLE cars (
    id SERIAL NOT NULL,
    Model varchar(50) NOT NULL,
    Color varchar(50) NOT NULL,
    TotalCost INT NOT NULL,
    PRIMARY KEY(id)
);

-- data
INSERT INTO departments
    (id, Name)
VALUES
    (1, 'HR'),
    (2, 'Sales'),
    (3, 'Tech')
;

INSERT INTO employees
    (id, FName, LName, PhoneNumber, ManagerId, DepartmentId, Salary, HireDate)
VALUES
    (1, 'James', 'Smith', 1234567890, NULL, 1, 1000, '01-01-2002'::timestamp without time zone),
    (2, 'John', 'Johnson', 2468101214, '1', 1, 400, '03-03-2005'::timestamp without time zone),
    (3, 'Michael', 'Williams', 1357911131, '1', 2, 600, '12-05-2009'::timestamp without time zone),
    (4, 'Johnathon', 'Smith', 1212121212, '2', 1, 500, '07-07-2016'::timestamp without time zone),
    (5, 'William', 'Morris', 5555555555, '1', 2, 800, '08-05-2009'::timestamp without time zone);

INSERT INTO customers
    (id, FName, LName, Email, PhoneNumber, PreferredContact)
VALUES
    (1, 'William', 'Jones', 'william.jones@example.com', '3347927472', 'PHONE'),
    (2, 'David', 'Miller', 'dmiller@example.net', '2137921892', 'EMAIL'),
    (3, 'Richard', 'Davis', 'richard0123@example.com', NULL, 'EMAIL'),
    (4, 'Elon', 'Musk', 'bigrocketguy@twitter.com', NULL, 'EMAIL'),
    (5, 'John', 'Dutton', 'yellowstoneranch@paramount.com', NULL, 'EMAIL')
;

INSERT INTO cars
    (id, Model, Color, TotalCost)
VALUES
    ('1', 'Ford F-150', 'Black', '230'),
    ('2', 'Ford F-150', 'Silver', '200'),
    ('3', 'Ford Mustang', 'Red', '350'),
    ('4', 'Tesla Model 3', 'Blue', '325'),
    ('5', 'Ford F-350', 'Brown', '500')
;

-- DEPARTMENTS
SELECT * FROM departments;
-- EMPLOYEES
SELECT * FROM employees;
-- CUSTOMERS
SELECT * FROM customers;
-- CARS
SELECT * FROM cars;

-- TASK 1 GOAL: 
--      The car dealership owner wants to set a markup and commission 
--          percentages on the TotalCost of cars and sales employees.
--      
--      The markup percentage per model should be as follows:
--          Ford F series (any size) = 15%    Ford Mustang = 25%  Toyota Prius = 10%
--      A markup percentage is required to be defined per vehicle after your changes
--
--      Any salesperson should have a commission percentage of: 5%
--      
--      Write the required SQL Commands to ALTER the above tables and insert/update 
--          data to support the new requirements.

ALTER TABLE cars ADD COLUMN markup_percent double precision not null default .10;
UPDATE cars SET markup_percent = 0.15 where model like 'Ford F%';
UPDATE cars SET markup_percent = 0.25 where model = 'Ford Mustang';


ALTER TABLE employees ADD COLUMN commission_percent double precision null;
UPDATE employees SET commission_percent = .05 
    where departmentid = (SELECT id from departments d where d.name = 'Sales');

SELECT * FROM employees;
SELECT * FROM cars;

-- TASK 2 GOAL:
--      Define a new table called Sales that will track all sales of vehicles including:
--          What vehicle they bought, who bought it, how much it cost the customer, who sold the car,
--          and what their commission for the sale was (in dollars)
--
--      The result of this task should be an empty table that is ready to track sales data and an
--      example of one insert statement used to populate a row in the table

CREATE TABLE sales (
    id SERIAL NOT NULL,
    carModel varchar(50) NOT NULL,
    customerName varchar(70) NOT NULL,
    salesPrice double precision NOT NULL,
    salesPerson varchar(70) NOT NULL,
    commissionAmount double precision NOT NULL,
    PRIMARY KEY(id)
);

INSERT INTO sales
values (default,
        (SELECT Model from cars where id = 1),
        (SELECT c.Fname || ' ' || c.Lname from customers c where id = 1),
        (SELECT cars.TotalCost * (1 + cars.markup_percent) from cars where id = 1),
        (SELECT e.Fname || ' ' || e.Lname from employees e where id = 5),
        (SELECT cars.TotalCost * (1 + cars.markup_percent) from cars where id = 1) * (SELECT commission_percent from employees where id = 5)
        );

INSERT INTO sales
values (default,
        (SELECT Model from cars where id = 2),
        (SELECT c.Fname || ' ' || c.Lname from customers c where id = 2),
        (SELECT cars.TotalCost * (1 + cars.markup_percent) from cars where id = 2),
        (SELECT e.Fname || ' ' || e.Lname from employees e where id = 3),
        (SELECT cars.TotalCost * (1 + cars.markup_percent) from cars where id = 2) * (SELECT commission_percent from employees where id = 3)
        );

INSERT INTO sales
values (default,
        (SELECT Model from cars where id = 3),
        (SELECT c.Fname || ' ' || c.Lname from customers c where id = 3),
        (SELECT cars.TotalCost * (1 + cars.markup_percent) from cars where id = 3),
        (SELECT e.Fname || ' ' || e.Lname from employees e where id = 5),
        (SELECT cars.TotalCost * (1 + cars.markup_percent) from cars where id = 3) * (SELECT commission_percent from employees where id = 5)
        );

INSERT INTO sales
values (default,
        (SELECT Model from cars where id = 4),
        (SELECT c.Fname || ' ' || c.Lname from customers c where id = 4),
        (SELECT cars.TotalCost * (1 + cars.markup_percent) from cars where id = 4),
        (SELECT e.Fname || ' ' || e.Lname from employees e where id = 5),
        (SELECT cars.TotalCost * (1 + cars.markup_percent) from cars where id = 4) * (SELECT commission_percent from employees where id = 5)
        );

INSERT INTO sales
values (default,
        (SELECT Model from cars where id = 5),
        (SELECT c.Fname || ' ' || c.Lname from customers c where id = 5),
        (SELECT cars.TotalCost * (1 + cars.markup_percent) from cars where id = 5),
        (SELECT e.Fname || ' ' || e.Lname from employees e where id = 3),
        (SELECT cars.TotalCost * (1 + cars.markup_percent) from cars where id = 5) * (SELECT commission_percent from employees where id = 3)
        );

SELECT * FROM sales;


-- TASK 3 GOAL:
--      Discuss and outline how you would build a star schema 
--      data warehousing structure based on the dealership's data
--
--      Be sure to talk about: Facts, Dimensions, Table Structure
--
