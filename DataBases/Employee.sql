CREATE DATABASE Employee; -- MYSQL

USE Employee;

CREATE TABLE EmployeePosition(
	Id INT PRIMARY KEY NOT NULL auto_increment,
	Name VARCHAR(50) NOT NULL
);

CREATE TABLE EmployeesData(
	Id INT PRIMARY KEY NOT NULL auto_increment,
	Name VARCHAR(50) NOT NULL,
	Shop_id INT NOT NULL,
	Adress VARCHAR(50) NOT NULL,
	Identification VARCHAR(50) NOT NULL,
	Phone VARCHAR(50) NOT NULL,
	Email VARCHAR(50) NOT NULL,
	Salary DECIMAL NOT NULL, -- MONEY TYPE DOESN'T EXIST, SO WE USE DECIMAL INSTEAD
	Position_id INT NOT NULL, 
	FOREIGN KEY (Position_id) REFERENCES EmployeePosition(Id)
); 

CREATE TABLE EmployeesReviews(
	Id INT PRIMARY KEY NOT NULL auto_increment,
	User_id INT NOT NULL,
	Review VARCHAR(50) NOT NULL,
	Employee_id INT NOT NULL,
	FOREIGN KEY (Employee_id) REFERENCES EmployeesData(Id)
);