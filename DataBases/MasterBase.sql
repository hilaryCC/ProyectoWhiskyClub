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
	Password VARBINARY(8000) NOT NULL, --insert into login(IdUsuario, contrasenia) values(‘buhoos’,PWDENCRYPT(‘12345678’))
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
				 INSERT INTO dbo.Credentials(Username, Password, User_identification) VALUES(@in_username, ENCRYPTBYPASSPHRASE('password', @in_password), @in_identification)
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

CREATE PROCEDURE [dbo].[SignIn] @in_user VARCHAR(64), @in_password VARCHAR(64)
AS
	DECLARE @i INT = 1, @hi INT, @user VARCHAR(64)='null', @password VARCHAR(64)='null'
	BEGIN TRY
	SET NOCOUNT ON
		SET @hi = (SELECT COUNT(*) FROM dbo.Credentials)
		print(@hi)
		WHILE @i <= @hi
		BEGIN
		SET @user = ISNULL((SELECT Username FROM dbo.Credentials WHERE id=@i and Username=@in_User),'null')
		SET @password = ISNULL( (SELECT Pass_word FROM dbo.Credentials WHERE id=@i and Pass_word = @in_password),'null')
		SET @i= @i + 1
		
		IF @user=@in_user and @password=@in_password
		BEGIN
			SELECT (1)
			BREAK;
		END
	
		END
		IF @user='null' OR @password='null'
		BEGIN
			SELECT(0)
		END

		BEGIN TRANSACTION TS;

			
		COMMIT TRANSACTION TS;
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
