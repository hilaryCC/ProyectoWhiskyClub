CREATE DATABASE Employee; --MYSQL

USE Employee;

CREATE TABLE Position(
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
	Salary MONEY NOT NULL,
	Position_id INT NOT NULL,
	FOREIGN KEY (Position_id) REFERENCES Position(Id)
); 

CREATE TABLE EmployeesReviews(
	Id INT PRIMARY KEY NOT NULL auto_increment,
	User_id INT NOT NULL,
	Review VARCHAR(50) NOT NULL,
	Employee_id INT NOT NULL,
	FOREIGN KEY (Employee_id) REFERENCES EmpoyeesData(Id)
);