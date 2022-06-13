USE MASTER
GO

CREATE DATABASE USA
GO

USE USA
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
	Whiskey_code INT NOT NULL,
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
	User_identification VARCHAR(50) NOT NULL,
	Total MONEY NOT NULL,
	Employee_identification VARCHAR(50) NOT NULL,
	Express MONEY NOT NULL,
	Purchase_date DATE
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

CREATE PROCEDURE GeneratePurchase
	@in_clientID varchar(50)
AS
	BEGIN TRY
		DECLARE @temporal AS TABLE 
		(id_tmp VARCHAR(50))
		DECLARE @temporal2 AS TABLE 
		(id_tmp VARCHAR(50))
		DECLARE @tmp_id VARCHAR(50) = 'EMPTY', @tmp_id2 VARCHAR(50) = 'EMPTY'
		BEGIN TRANSACTION TS;
			INSERT INTO @temporal(id_tmp) SELECT * FROM openquery(SQLSERVER,' SELECT Identification FROM user.UserData;')
			SELECT @tmp_id = id_tmp FROM @temporal WHERE id_tmp = @in_clientID
			INSERT INTO @temporal2(id_tmp) SELECT * FROM openquery(SQLSERVER,' SELECT Identification FROM employee.employeesdata WHERE Position_id = 1;') --corregir empleados depende del pais y tienda donde trabajen
			SET @tmp_id2 = (SELECT TOP(1) id_tmp FROM @temporal2 ORDER BY NEWID())
			IF @tmp_id != 'EMPTY'
			BEGIN
				INSERT INTO dbo.Purchase(Purchase_date, User_identification, Total, Employee_identification, Express)
				VALUES(GETDATE(), @in_clientID, 0, @tmp_id2, 0)
			END
		COMMIT TRANSACTION TS;
		RETURN 200;
	END TRY
	BEGIN CATCH
		IF @@Trancount>0 BEGIN
			ROLLBACK TRANSACTION TS;
			SELECT
				SUSER_SNAME(),
				ERROR_NUMBER(),
				ERROR_STATE(),
				ERROR_SEVERITY(),
				ERROR_LINE(),
				ERROR_PROCEDURE(),
				ERROR_MESSAGE(),
				GETDATE()
			RETURN 500;
		END
	END CATCH
GO

CREATE PROCEDURE AddKart
	@in_whiskeyID INT, @in_amount INT, @in_shopID INT
AS
	BEGIN TRY
		DECLARE @tmp_purchaseID INT, @tmp_amount INT, @tmp_stockID INT, @tmp_subtotal MONEY
		BEGIN TRANSACTION TS;
			SET @tmp_purchaseID = (SELECT TOP(1) id FROM dbo.Purchase ORDER BY Id DESC)
			SELECT @tmp_amount = Amount FROM dbo.Stock WHERE Whiskey_code = @in_whiskeyID
			SET @tmp_amount = @tmp_amount - @in_amount
			IF @tmp_amount >= 0
			BEGIN
				SELECT @tmp_stockID = Id from dbo.Stock WHERE Shop_id=@in_shopID
				SELECT @tmp_subtotal = Price FROM MasterBase.dbo.Whiskey WHERE Id = @in_whiskeyID
				SET @tmp_subtotal = @tmp_subtotal * @in_amount
				INSERT INTO dbo.ProductsXPurchase(Stock_id, Purchase_id, Amount, Subtotal)
				VALUES(@tmp_stockID, @tmp_purchaseID, @in_amount, @tmp_subtotal)
				UPDATE dbo.Stock
				SET Amount = Amount - @in_amount
				WHERE Id = @tmp_stockID
			END
		COMMIT TRANSACTION TS;
		RETURN 200;
	END TRY
	BEGIN CATCH
		IF @@Trancount>0 BEGIN
			ROLLBACK TRANSACTION TS;
			SELECT
				SUSER_SNAME(),
				ERROR_NUMBER(),
				ERROR_STATE(),
				ERROR_SEVERITY(),
				ERROR_LINE(),
				ERROR_PROCEDURE(),
				ERROR_MESSAGE(),
				GETDATE()
			RETURN 500;
		END
	END CATCH
GO

CREATE PROCEDURE FinishPurchase
AS
	BEGIN TRY
		DECLARE @temporal AS TABLE 
		(sub_total MONEY)
		DECLARE @total MONEY, @id_purchase INT
		BEGIN TRANSACTION TS;
			SET @id_purchase = (SELECT TOP(1) id FROM dbo.Purchase ORDER BY Id DESC)
			INSERT INTO @temporal SELECT Subtotal 
			FROM dbo.ProductsXPurchase 
			WHERE Purchase_id = @id_purchase
			SELECT @total = SUM(sub_total) FROM @temporal
			UPDATE dbo.Purchase
			SET Total = @total
			WHERE Id = @id_purchase
		COMMIT TRANSACTION TS;
		RETURN 200;
	END TRY
	BEGIN CATCH
		IF @@Trancount>0 BEGIN
			ROLLBACK TRANSACTION TS;
			SELECT
				SUSER_SNAME(),
				ERROR_NUMBER(),
				ERROR_STATE(),
				ERROR_SEVERITY(),
				ERROR_LINE(),
				ERROR_PROCEDURE(),
				ERROR_MESSAGE(),
				GETDATE()
			RETURN 500;
		END
	END CATCH
GO




