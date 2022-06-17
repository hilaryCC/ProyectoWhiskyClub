USE MASTER
GO

CREATE DATABASE MasterBase
GO

USE MasterBase
GO

CREATE TABLE dbo.WhiskeyType(
	ID INT PRIMARY KEY IDENTITY(1,1) NOT NULL,
	TypeName VARCHAR(50) NOT NULL
);
GO

CREATE TABLE dbo.WhiskeyAge(
	ID INT PRIMARY KEY IDENTITY(1,1) NOT NULL,
	Age INT NOT NULL
);
GO

CREATE TABLE dbo.Supplier(
	ID INT PRIMARY KEY IDENTITY(1,1) NOT NULL,
	Supplier_name VARCHAR(50) NOT NULL,
	Features NVARCHAR(MAX)
);
GO

CREATE TABLE dbo.Club(
	Id INT PRIMARY KEY IDENTITY(1,1) NOT NULL,
	Club_name VARCHAR(50) NOT NULL,
	Price MONEY NOT NULL,
	Discount FLOAT NOT NULL,
	HaveExpress BIT NOT NULL,
	Express_discount FLOAT NOT NULL
);
GO

CREATE TABLE dbo.UsersXClub(
	Id INT PRIMARY KEY IDENTITY(1,1) NOT NULL,
	User_identification VARCHAR(50) NOT NULL,
	Active BIT NOT NULL,
	Id_club INT NOT NULL,
	Card VARCHAR(50) NOT NULL,
	Amount INT NOT NULL,
	FOREIGN KEY (Id_club) REFERENCES dbo.Club(Id)
);
GO

CREATE TABLE dbo.Whiskey(
	Id INT PRIMARY KEY IDENTITY(1,1) NOT NULL,
	--Code uniqueidentifier,
	Whiskey_name VARCHAR(50) NOT NULL,
	WhiskeyType_id INT NOT NULL,
	Age_id INT NOT NULL,
	Photo VARBINARY(MAX),
	Price MONEY NOT NULL,
	Supplier_id INT NOT NULL,
	IsSpecial BIT NOT NULL,
	FOREIGN KEY (WhiskeyType_id) REFERENCES dbo.WhiskeyType(Id),
	FOREIGN KEY (Age_id) REFERENCES dbo.WhiskeyAge(Id),
	FOREIGN KEY (Supplier_id) REFERENCES dbo.Supplier(Id)
);
GO

CREATE TABLE dbo.WhiskeyReviews(
	Id INT PRIMARY KEY IDENTITY(1,1) NOT NULL,
	User_id INT NOT NULL,
	Review VARCHAR(50) NOT NULL,
	Whiskey_id INT NOT NULL,
	FOREIGN KEY (Whiskey_id) REFERENCES dbo.Whiskey(Id)
);
GO

CREATE TABLE dbo.Credentials(
	Id INT PRIMARY KEY IDENTITY(1,1) NOT NULL,
	Username VARCHAR(50) NOT NULL,
	Pass_word VARBINARY(8000) NOT NULL, --insert into login(IdUsuario, contrasenia) values(‘buhoos’,PWDENCRYPT(‘12345678’))
	User_identification VARCHAR(50)
);
GO

CREATE PROCEDURE InsertCredentials
	@in_identification VARCHAR(50), @in_username VARCHAR(50), @in_password VARCHAR(50)
AS
	BEGIN TRY
		DECLARE @temporal AS TABLE 
		(id_tmp VARCHAR(50))
		DECLARE @tmp_id VARCHAR(50) = 'EMPTY', @tmp_username VARCHAR(50) = 'EMPTY'

		BEGIN TRANSACTION TS;
			INSERT INTO @temporal(id_tmp) SELECT * FROM openquery(SQLSERVER,' SELECT Identification FROM user.UserData;')
			SELECT @tmp_id = id_tmp FROM @temporal WHERE id_tmp = @in_identification
			SELECT @tmp_username = Username FROM dbo.Credentials WHERE User_identification=@tmp_id
			SELECT @tmp_id
			SELECT @tmp_username
			IF @tmp_id != 'EMPTY' AND @tmp_username = 'EMPTY'
			BEGIN
				 INSERT INTO dbo.Credentials(Username, Pass_word, User_identification) VALUES(@in_username, ENCRYPTBYPASSPHRASE('password', @in_password), @in_identification)
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

CREATE PROCEDURE SignIn 
	@in_user VARCHAR(64), @in_password VARCHAR(64)
AS
	DECLARE @tmp_username VARCHAR(50) = 'EMPTY',
			@tmp_password VARCHAR(50) = 'EMPTY'
	DECLARE @temporal AS TABLE 
		(pass_temporal VARCHAR(50))

	BEGIN TRY
	SET NOCOUNT ON
		SELECT @tmp_username = Username FROM dbo.Credentials WHERE Username=@in_user
		INSERT INTO @temporal SELECT DECRYPTBYPASSPHRASE('password', pass_word) FROM dbo.Credentials
		--SELECT @password =  ENCRYPTBYPASSPHRASE('password', @in_password)
		SELECT @tmp_password = pass_temporal FROM @temporal WHERE pass_temporal = @in_password
		IF @tmp_username != 'EMPTY' AND @tmp_password != 'EMPTY'
		BEGIN
			SELECT User_identification FROM dbo.Credentials WHERE Username=@in_user
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

CREATE PROCEDURE IsAdmin
	@in_user VARCHAR(64)
AS
	DECLARE @tmp_username VARCHAR(50) = 'EMPTY', @tmp_identification VARCHAR(50) = 'EMPTY', @tmp_isAdmin BIT
	DECLARE @temporal AS TABLE 
		(identification VARCHAR(50),
		isadmin BIT)

	BEGIN TRY
	SET NOCOUNT ON
		SELECT @tmp_username = Username FROM dbo.Credentials WHERE Username=@in_user
		SELECT @tmp_identification = User_identification FROM dbo.Credentials WHERE Username=@in_user
		INSERT INTO @temporal(identification, isadmin) SELECT * FROM openquery(SQLSERVER,' SELECT Identification, IsAdmin FROM user.UserData;')
		SET @tmp_isAdmin = (SELECT isadmin FROM @temporal WHERE identification = @tmp_identification)
		IF @tmp_username != 'EMPTY' AND @tmp_isAdmin = 1
		BEGIN
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

CREATE PROCEDURE CreateWhiskey
	@in_name VARCHAR(50), @in_WhiskeyType VARCHAR(50), @in_Age INT, @in_price MONEY, @in_supplier VARCHAR(50), @in_IsSpecial VARCHAR(50) --modificar en el sitio web
AS
	DECLARE @tmp_name VARCHAR(50) = 'EMPTY' 
	DECLARE @tmp_type INT = 0, @tmp_age INT = 0, @tmp_supplier INT = 0, @tmp_club INT = 0, @tmp_IsSpecial INT = 0
	BEGIN TRY
	SET NOCOUNT ON
		SELECT @tmp_name = Whiskey_name FROM dbo.Whiskey WHERE Whiskey_name = @in_name
		SELECT @tmp_type = Id FROM dbo.WhiskeyType WHERE TypeName = @in_WhiskeyType
		SELECT @tmp_age = Id FROM dbo.WhiskeyAge WHERE Age = @in_Age
		SELECT @tmp_supplier = Id FROM dbo.Supplier WHERE Supplier_name = @in_supplier
		SET @tmp_IsSpecial = (SELECT CAST(@in_IsSpecial AS INT))
		IF @tmp_name = 'EMPTY' AND @tmp_type != 0 AND @tmp_age != 0 AND @tmp_supplier != 0 AND @tmp_IsSpecial != 0
		BEGIN
			INSERT INTO dbo.Whiskey(Whiskey_name, WhiskeyType_id, Age_id, Price, Supplier_id, IsSpecial)
			VALUES(@in_name, @tmp_type, @tmp_age, @in_price, @tmp_supplier, 1)
			SELECT 1
		END
		ELSE IF @tmp_name = 'EMPTY' AND @tmp_type != 0 AND @tmp_age != 0 AND @tmp_supplier != 0 AND @tmp_IsSpecial = 0
		BEGIN
			INSERT INTO dbo.Whiskey(Whiskey_name, WhiskeyType_id, Age_id, Price, Supplier_id, IsSpecial)
			VALUES(@in_name, @tmp_type, @tmp_age, @in_price, @tmp_supplier, 0)
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

CREATE PROCEDURE CreateSupplier
	@in_name VARCHAR(50)
AS
	DECLARE @tmp_supplier INT = 0
	BEGIN TRY
	SET NOCOUNT ON
		SELECT @tmp_supplier = Id FROM dbo.Supplier WHERE Supplier_name = @in_name
		IF @tmp_supplier = 0
		BEGIN
			INSERT INTO dbo.Supplier(Supplier_name)
			VALUES(@in_name)
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

CREATE PROCEDURE ModifyWhiskeyAge
	@in_name VARCHAR(50), @in_age INT
AS
	DECLARE @tmp_age INT = 0
	BEGIN TRY
	SET NOCOUNT ON
		SELECT @tmp_age = Id FROM dbo.WhiskeyAge WHERE Age = @in_age
		IF @tmp_age != 0
		BEGIN
			UPDATE dbo.Whiskey
			SET Age_id = @tmp_age
			WHERE Whiskey_name = @in_name
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

CREATE PROCEDURE ModifyWhiskeySupplier
	@in_name VARCHAR(50), @in_supplier VARCHAR(50)
AS
	DECLARE @tmp_supplier INT = 0
	BEGIN TRY
	SET NOCOUNT ON
		SELECT @tmp_supplier = Id FROM dbo.Supplier WHERE Supplier_name = @in_supplier
		IF @tmp_supplier != 0
		BEGIN
			UPDATE dbo.Whiskey
			SET Supplier_id = @tmp_supplier
			WHERE Whiskey_name = @in_name
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

CREATE PROCEDURE ModifyWhiskeyType
	@in_name VARCHAR(50), @in_type VARCHAR(50)
AS
	DECLARE @tmp_type INT = 0
	BEGIN TRY
	SET NOCOUNT ON
		SELECT @tmp_type = Id FROM dbo.WhiskeyType WHERE TypeName = @in_type
		IF @tmp_type != 0
		BEGIN
			UPDATE dbo.Whiskey
			SET WhiskeyType_id = @tmp_type 
			WHERE Whiskey_name = @in_name
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

CREATE PROCEDURE InsertWhiskeyReview
	@in_name VARCHAR(50), @in_review VARCHAR(MAX), @in_clientID VARCHAR(50)
AS
	DECLARE @tmp_whiskeyID INT = 0, @tmp_userID INT = 0
	BEGIN TRY
	SET NOCOUNT ON
		SELECT @tmp_whiskeyID = Id FROM dbo.Whiskey WHERE Whiskey_name = @in_name
		SELECT @tmp_userID = Id FROM dbo.Credentials WHERE User_identification = @in_clientID
		IF @tmp_whiskeyID != 0 AND @tmp_userID != 0
		BEGIN
			INSERT INTO dbo.WhiskeyReviews(Whiskey_id, User_id, Review)
			VALUES(@tmp_whiskeyID, @tmp_userID, @in_review)
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

CREATE PROCEDURE SendEmail 
	@in_recipient Varchar(64), @in_body Varchar(63)
AS
    BEGIN 
        EXEC msdb.dbo.sp_send_dbmail
        @profile_name='Whiskey Club',
        @recipients=@in_recipient,
        @subject='Whiskey Club Receipt',
        @body =@in_body

	END
GO

CREATE PROCEDURE ObtainClientEmail
	@in_clientID VARCHAR(50)
AS
	DECLARE @temporal AS TABLE 
	(email_tmp VARCHAR(50),
	id_tmp VARCHAR(50))
	DECLARE @tmp_email VARCHAR(50) = 'EMPTY'
	BEGIN TRY
	SET NOCOUNT ON
		INSERT INTO @temporal(email_tmp, id_tmp) SELECT * FROM openquery(SQLSERVER,' SELECT Email, Identification FROM user.UserData;')
		SELECT @tmp_email = email_tmp FROM @temporal WHERE id_tmp = @in_clientID
		IF @tmp_email != 'EMPTY'
		BEGIN
			SELECT @tmp_email
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

CREATE PROCEDURE productsInfo @in_type VARCHAR(50) = NULL,
                            @in_age INT = NULL,
                            @in_supplier VARCHAR(50) = NULL,
                            @in_price VARCHAR(50) = NULL
AS
    BEGIN TRY
    SET NOCOUNT ON
        SELECT W.Photo, W.Id, W.Whiskey_name, WT.TypeName, WA.Age, W.Price, S.Supplier_name, S.Features FROM dbo.Whiskey W
            INNER JOIN dbo.WhiskeyType WT ON WT.ID = W.WhiskeyType_id
            INNER JOIN dbo.WhiskeyAge WA ON WA.ID = W.Age_id
            INNER JOIN dbo.Supplier S ON S.ID = W.Supplier_id
            WHERE WT.TypeName LIKE ISNULL(@in_type, WT.TypeName)
                AND WA.Age = ISNULL(@in_age, WA.Age)
                AND S.Supplier_name LIKE ISNULL(@in_supplier, S.Supplier_name)
                AND W.Price <= ISNULL(@in_price, W.Price)
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

CREATE PROCEDURE SuscribeClub
	@in_clubID VARCHAR(50), @in_card VARCHAR(50), @in_clientID VARCHAR(50)
AS
	BEGIN TRY
	DECLARE @int_clubID INT = 0, @exist VARCHAR(50) = 'EMPTY'
	SET NOCOUNT ON
		SET @int_clubID = (SELECT CAST(@in_clubID AS INT))
		SELECT @exist = User_identification FROM dbo.UsersXClub WHERE User_identification = @in_clientID AND Active = 1
		IF 0 < @int_clubID AND @exist = 'EMPTY'
		BEGIN
			INSERT INTO dbo.UsersXClub(User_identification, Active, Id_club, Card, Amount)
			VALUES(@in_clientID, 1, @in_clubID, @in_card, 0)
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

CREATE PROCEDURE UserHasClub
	@in_clientID VARCHAR(50), @exist INT OUTPUT
AS
	BEGIN TRY
	--DECLARE @exist INT = 0
	SET NOCOUNT ON
		SELECT @exist = Id_club FROM dbo.UsersXClub WHERE User_identification = @in_clientID -- Returns the club ID where this user is suscripted
		IF @exist != 0
		BEGIN
			SELECT @exist
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

CREATE PROCEDURE WhiskeyIsSpecial
	@in_whiskeyID INT, @out_result INT OUTPUT
AS
	BEGIN TRY
	DECLARE @exist BIT = 0
	SET NOCOUNT ON
		SELECT @exist = IsSpecial FROM dbo.Whiskey WHERE Id = @in_whiskeyID
		IF @exist = 1
		BEGIN
			SET @out_result = 1
			SELECT @out_result
		END
		ELSE
		BEGIN
			SET @out_result = 0
			SELECT @out_result
		END
		SELECT @exist
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

INSERT INTO dbo.WhiskeyAge(Age)
VALUES(50)
INSERT INTO dbo.WhiskeyAge(Age)
VALUES(40)
INSERT INTO dbo.WhiskeyAge(Age)
VALUES(30)
INSERT INTO dbo.WhiskeyType(TypeName)
VALUES('Dulce')
INSERT INTO dbo.WhiskeyType(TypeName)
VALUES('Amargo')
INSERT INTO dbo.Supplier(Supplier_name)
VALUES('Florida')
INSERT INTO dbo.Supplier(Supplier_name)
VALUES('Chivas Supplier')
INSERT INTO dbo.Club(Club_name, Price, Discount, HaveExpress, Express_discount)
VALUES('Tier Short Glass', 10, 0.05, 0, 1.0)
INSERT INTO dbo.Club(Club_name, Price, Discount, HaveExpress, Express_discount)
VALUES('Tier Gleincairn', 20, 0.1, 0, 0.2)
INSERT INTO dbo.Club(Club_name, Price, Discount, HaveExpress, Express_discount)
VALUES('Tier Master Distiller', 30, 0.3, 1, 1.0)

-- EXECUTE InsertCredentials '2020', 'hila123', 'soyhila' --IsSpecial