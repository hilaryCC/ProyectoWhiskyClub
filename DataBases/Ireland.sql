USE MASTER
GO

CREATE DATABASE Ireland
GO

USE Ireland
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
	Shop_name varchar(50) NOT NULL,
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

CREATE TABLE dbo.Purchase(
	Id INT PRIMARY KEY IDENTITY(1,1) NOT NULL,
	User_identification INT NOT NULL,
	Total MONEY NOT NULL,
	Employee_identification INT NOT NULL,
	Express MONEY NOT NULL,
	Purchase_date DATE,
	Active BIT NOT NULL,
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
				INSERT INTO dbo.Purchase(Purchase_date, User_identification, Total, Employee_identification, Express, Active)
				VALUES(GETDATE(), @in_clientID, 0, @tmp_id2, 0, 1)
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
	@in_whiskeyName VARCHAR(50), @in_amount VARCHAR(50), @in_shopID VARCHAR(50), @in_clientID VARCHAR(50)
AS
	BEGIN TRY
		SET NOCOUNT ON
		DECLARE @tmp_purchaseID INT = 0, @tmp_amount INT = 0, @tmp_stockID INT, @tmp_subtotal MONEY, @shop_int INT, @whiskey_id INT, @amount_int INT, @user_has_club INT = 0, @whiskeyIsSpecial INT = 0, @discount FLOAT = 0.0, @apply_discount MONEY, @exist_special BIT = 0, @tmp_buy MONEY
		BEGIN TRANSACTION TS;
			SET @shop_int = (SELECT CAST(@in_shopID AS INT))
			SELECT @tmp_purchaseID = id FROM dbo.Purchase WHERE User_identification = @in_clientID AND Active = 1
			SELECT @whiskey_id = Id FROM MasterBase.dbo.Whiskey WHERE Whiskey_name = @in_whiskeyName
			SELECT @tmp_amount = Amount FROM dbo.Stock WHERE Whiskey_code = @whiskey_id
			SELECT @user_has_club = Id_club FROM MasterBase.dbo.UsersXClub WHERE User_identification = @in_clientID -- Returns the club ID where this user is suscripted
			SELECT @exist_special = IsSpecial FROM MasterBase.dbo.Whiskey WHERE Id = @whiskey_id
			SET @amount_int = (SELECT CAST(@in_amount AS INT))
			SET @tmp_amount = @tmp_amount - @amount_int
			SELECT @tmp_stockID = Id from dbo.Stock WHERE Shop_id=@shop_int
			SELECT @tmp_subtotal = Price FROM MasterBase.dbo.Whiskey WHERE Id = @whiskey_id
			IF @tmp_amount >= 0 AND @tmp_purchaseID != 0 AND @exist_special = 1 --That amount is available in the stock AND Exist a generated purchase AND this whiskey is special
			BEGIN
				IF @user_has_club != 0 --The user is suscripted to a Club
				BEGIN
					SELECT @discount = Discount FROM MasterBase.dbo.Club WHERE Id = @user_has_club
					SET @tmp_subtotal = @tmp_subtotal * @amount_int
					SET @apply_discount = @tmp_subtotal * @discount
					SET @tmp_subtotal = @tmp_subtotal - @apply_discount
					SELECT @tmp_buy = buy from dbo.Exchange WHERE id = 1
					SET @tmp_buy = @tmp_buy * @tmp_subtotal
					INSERT INTO dbo.ProductsXPurchase(Stock_id, Purchase_id, Amount, Subtotal)
					VALUES(@tmp_stockID, @tmp_purchaseID, @amount_int, @tmp_buy)
					UPDATE dbo.Stock
					SET Amount = Amount - @in_amount
					WHERE Id = @tmp_stockID
					UPDATE MasterBase.dbo.UsersXClub
					SET Amount = Amount + @amount_int
					WHERE User_identification = @in_clientID AND Id_club = @user_has_club AND @user_has_club = 3 --We add to this user the amount of this special whiskey because of the benefit this club have.
		 			SELECT 1
		 		END
		 		ELSE
		 		BEGIN
		 			SELECT 0 --A normal user can't buy a special whiskey
		 		END
		 	END
		 	ELSE IF @tmp_amount >= 0 AND @tmp_purchaseID != 0 AND @exist_special = 0 --That amount is available in the stock AND Exist a generated purchase AND this whiskey is NOT special
		 	BEGIN
		 		IF @user_has_club != 0 --The user is suscripted to a Club
				BEGIN
					SELECT @discount = Discount FROM MasterBase.dbo.Club WHERE Id = @user_has_club
					SET @tmp_subtotal = @tmp_subtotal * @amount_int
					SET @apply_discount = @tmp_subtotal * @discount
					SET @tmp_subtotal = @tmp_subtotal - @apply_discount
					SELECT @tmp_buy = buy from dbo.Exchange WHERE id = 1
					SET @tmp_buy = @tmp_buy * @tmp_subtotal
					INSERT INTO dbo.ProductsXPurchase(Stock_id, Purchase_id, Amount, Subtotal)
					VALUES(@tmp_stockID, @tmp_purchaseID, @amount_int, @tmp_buy)
					UPDATE dbo.Stock
					SET Amount = Amount - @in_amount
					WHERE Id = @tmp_stockID
					-- UPDATE MasterBase.dbo.UsersXClub		--We omit this part because the whiskey is not special and this benefit is ONLY if the whiskey is special
					-- SET Amount = Amount + @amount_int
					-- WHERE User_identification = @in_clientID AND Id_club = @user_has_club AND @user_has_club = 3 --We add to this user the amount of this sphis club have.
		 			SELECT 1
		 		END
		 		ELSE
		 		BEGIN
		 			SET @tmp_subtotal = @tmp_subtotal * @amount_int --The user is not suscripted to a Club but he can buy a not special whiskey. We must omit the part of the discount.
					SELECT @tmp_buy = buy from dbo.Exchange WHERE id = 1
					SET @tmp_buy = @tmp_buy * @tmp_subtotal
					INSERT INTO dbo.ProductsXPurchase(Stock_id, Purchase_id, Amount, Subtotal)
					VALUES(@tmp_stockID, @tmp_purchaseID, @amount_int, @tmp_buy)
					UPDATE dbo.Stock
					SET Amount = Amount - @in_amount
					WHERE Id = @tmp_stockID
					SELECT 1
				END
		 	END
		 	ELSE --The stock doesn't have the amount the client want to buy or there is not a purchase generated of this client.
		 	BEGIN
		 		SELECT 0
		 	END
		COMMIT TRANSACTION TS;
		SET NOCOUNT OFF
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
	@in_clientID VARCHAR(50)
AS
	BEGIN TRY
		DECLARE @temporal AS TABLE 
		(sub_total MONEY)
		DECLARE @total MONEY, @id_purchase INT
		BEGIN TRANSACTION TS;
			SELECT @id_purchase = Id FROM dbo.Purchase WHERE User_identification = @in_clientID AND Active = 1
			INSERT INTO @temporal SELECT Subtotal 
			FROM dbo.ProductsXPurchase 
			WHERE Purchase_id = @id_purchase
			SELECT @total = SUM(sub_total) FROM @temporal
			UPDATE dbo.Purchase
			SET Total = @total, Active = 0
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

CREATE PROCEDURE ModifyAmountWhiskey
	@in_name VARCHAR(50), @in_amount INT, @in_shop VARCHAR(50)
AS
	DECLARE @tmp_whiskey INT = 0, @tmp_shop INT = 0
	BEGIN TRY
	SET NOCOUNT ON
		SELECT @tmp_whiskey = Id FROM MasterBase.dbo.Whiskey WHERE Whiskey_name = @in_name
		SELECT @tmp_shop = Id FROM dbo.Shop WHERE Shop_name = @in_shop
		IF @tmp_whiskey != 0 AND @tmp_shop != 0
		BEGIN
			UPDATE dbo.Stock
			SET Amount = @in_amount
			WHERE Whiskey_code = @tmp_whiskey AND Shop_id = @tmp_shop
			SELECT 1
		END
		ELSE
		BEGIN
			SELECT 0
		END
		RETURN 200;
		SET NOCOUNT OFF
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

--TEST INSERTS
INSERT INTO dbo.Shop(Shop_name, Direction)
VALUES('Ireland Liquor Store 1', 'Dublin')
INSERT INTO dbo.Shop(Shop_name, Direction)
VALUES('Ireland Liquor Store 2', 'Dublin')
INSERT INTO dbo.Shop(Shop_name, Direction)
VALUES('Ireland Liquor Store 3', 'Dublin')
INSERT INTO dbo.Stock(Shop_id, Whiskey_code, Amount)
VALUES(1, 1, 50)
INSERT INTO dbo.Stock(Shop_id, Whiskey_code, Amount)
VALUES(2, 1, 50)
INSERT INTO dbo.Stock(Shop_id, Whiskey_code, Amount)
VALUES(3, 1, 50)
INSERT INTO dbo.Coin(Name, Symbol)
VALUES('Dollar', '$')
INSERT INTO dbo.Coin(Name, Symbol)
VALUES('Euro', '%')
INSERT INTO dbo.Exchange(Coin1, Coin2, Buy, Sale)
VALUES(1, 2, 1.05, 1.05)