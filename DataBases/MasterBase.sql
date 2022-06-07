USE MASTER
GO

CREATE DATABASE MasterBase
GO

USE MasterBase
GO

CREATE TABLE dbo.WhiskeyType(
	ID INT PRIMARY KEY IDENTITY(1,1) NOT NULL,
	Name VARCHAR(50) NOT NULL
);
GO

CREATE TABLE dbo.Age(
	ID INT PRIMARY KEY IDENTITY(1,1) NOT NULL,
	Age INT NOT NULL
);
GO

CREATE TABLE dbo.Supplier(
	ID INT PRIMARY KEY IDENTITY(1,1) NOT NULL,
	Name VARCHAR(50) NOT NULL,
	Features NVARCHAR(MAX)
);
GO

CREATE TABLE dbo.Whiskey(
	Id INT PRIMARY KEY IDENTITY(1,1) NOT NULL,
	Code uniqueidentifier,
	Name VARCHAR(50) NOT NULL,
	WhiskeyType_id INT NOT NULL,
	Age_id INT NOT NULL,
	Photo VARBINARY(MAX) NOT NULL,
	Price MONEY NOT NULL,
	Supplier_id INT NOT NULL,
	
	FOREIGN KEY (WhiskeyType_id) REFERENCES dbo.WhiskeyType(Id),
	FOREIGN KEY (Age_id) REFERENCES dbo.Age(Id),
	FOREIGN KEY (Supplier_id) REFERENCES dbo.Supplier(Id)
);
GO

CREATE TABLE WhiskeyReviews(
	Id INT PRIMARY KEY IDENTITY(1,1) NOT NULL,
	User_id INT NOT NULL,
	Review VARCHAR(50) NOT NULL,
	Whiskey_id INT NOT NULL,
	FOREIGN KEY (Whiskey_id) REFERENCES dbo.Whiskey(Id)
);
GO

CREATE TABLE dbo.Credentials(
	Id INT PRIMAY KEY IDENTITY(1,1) NOT NULL,
	Username VARCHAR(50) NOT NULL,
	Password VARCHAR(50) NOT NULL, --insert into login(IdUsuario, contrasenia) values(‘buhoos’,PWDENCRYPT(‘12345678’))
	User_identification VARCHAR(50)
);
GO
