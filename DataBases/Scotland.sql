USE MASTER
GO

CREATE DATABASE Scotland
GO

USE Scotland
GO

CREATE TABLE dbo.Location(
	Adress GEOMETRY,
	Figure GEOMETRY
);
GO

CREATE TABLE dbo.Coin(
	Id INT PRIMARY KEY IDENTITY(1,1) NOT NULL,
	Name varchar(50) NOT NULL,
	Symbol varchar(50) NOT NULL
);
GO

CREATE TABLE dbo.Exchange(
	Id INT PRIMARY KEY IDENTITY(1,1) NOT NULL,
	Buy MONEY NOT NULL,
	Sale MONEY NOT NULL,
	Coin1 INT NOT NULL,
	Coin2 INT NOT NULL,
	FOREIGN KEY (Coin1) REFERENCES dbo.Coin(Id),
	FOREIGN KEY (Coin2) REFERENCES dbo.Coin(Id)
);
GO

CREATE TABLE dbo.Shop(
	Id INT PRIMARY KEY IDENTITY(1,1) NOT NULL,
	Name varchar(50) NOT NULL,
	Adress GEOMETRY,
	Figure GEOMETRY,
	Direction VARCHAR(50)
);
GO

CREATE TABLE dbo.Stock(
	Id INT PRIMARY KEY IDENTITY(1,1) NOT NULL,
	Shop_id INT NOT NULL,
	Whiskey_code VARCHAR(50),
	Amount INT NOT NULL
	FOREIGN KEY (Shop_id) REFERENCES dbo.Shop(Id)
);
GO

CREATE TABLE dbo.Level(
	Id INT PRIMARY KEY IDENTITY(1,1) NOT NULL,
	Name varchar(50) NOT NULL,
	Discount DECIMAL NOT NULL
);
GO

CREATE TABLE dbo.Club(
	Id INT PRIMARY KEY IDENTITY(1,1) NOT NULL,
	Price MONEY NOT NULL,
	Level_id INT NOT NULL,
	Shop_id INT NOT NULL,
	FOREIGN KEY (Level_id) REFERENCES dbo.Level(Id),
	FOREIGN KEY (Shop_id) REFERENCES dbo.Shop(Id)
);
GO

CREATE TABLE dbo.UsersXClub(
	Id INT PRIMARY KEY IDENTITY(1,1) NOT NULL,
	User_identification VARCHAR(50),
	Club_id INT NOT NULL,
	FOREIGN KEY (Club_id) REFERENCES dbo.Club(Id)
);
GO

CREATE TABLE dbo.Purchase(
	Id INT PRIMARY KEY IDENTITY(1,1) NOT NULL,
	User_identification INT NOT NULL,
	Total MONEY NOT NULL,
	Employee_identification INT NOT NULL,
	Express MONEY NOT NULL
);
GO

CREATE TABLE dbo.ProductsXPurchase(
	Id INT PRIMARY KEY IDENTITY(1,1) NOT NULL,
	Stock_id INT NOT NULL,
	Amount INT NOT NULL,
	Purchase_id INT NOT NULL,
	Subtotal MONEY NOT NULL
	FOREIGN KEY (Stock_id) REFERENCES dbo.Stock(Id),
	FOREIGN KEY (Purchase_id) REFERENCES dbo.Purchase(Id)
);
GO

