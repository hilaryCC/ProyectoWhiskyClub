USE [master]
GO
/****** Object:  Database [MasterBase]    Script Date: 6/9/2022 5:40:04 PM ******/
CREATE DATABASE [MasterBase]
 CONTAINMENT = NONE
 ON  PRIMARY 
( NAME = N'MasterBase', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL15.MSSQLSERVER\MSSQL\DATA\MasterBase.mdf' , SIZE = 8192KB , MAXSIZE = UNLIMITED, FILEGROWTH = 65536KB )
 LOG ON 
( NAME = N'MasterBase_log', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL15.MSSQLSERVER\MSSQL\DATA\MasterBase_log.ldf' , SIZE = 8192KB , MAXSIZE = 2048GB , FILEGROWTH = 65536KB )
 WITH CATALOG_COLLATION = DATABASE_DEFAULT
GO
ALTER DATABASE [MasterBase] SET COMPATIBILITY_LEVEL = 150
GO
IF (1 = FULLTEXTSERVICEPROPERTY('IsFullTextInstalled'))
begin
EXEC [MasterBase].[dbo].[sp_fulltext_database] @action = 'enable'
end
GO
ALTER DATABASE [MasterBase] SET ANSI_NULL_DEFAULT OFF 
GO
ALTER DATABASE [MasterBase] SET ANSI_NULLS OFF 
GO
ALTER DATABASE [MasterBase] SET ANSI_PADDING OFF 
GO
ALTER DATABASE [MasterBase] SET ANSI_WARNINGS OFF 
GO
ALTER DATABASE [MasterBase] SET ARITHABORT OFF 
GO
ALTER DATABASE [MasterBase] SET AUTO_CLOSE OFF 
GO
ALTER DATABASE [MasterBase] SET AUTO_SHRINK OFF 
GO
ALTER DATABASE [MasterBase] SET AUTO_UPDATE_STATISTICS ON 
GO
ALTER DATABASE [MasterBase] SET CURSOR_CLOSE_ON_COMMIT OFF 
GO
ALTER DATABASE [MasterBase] SET CURSOR_DEFAULT  GLOBAL 
GO
ALTER DATABASE [MasterBase] SET CONCAT_NULL_YIELDS_NULL OFF 
GO
ALTER DATABASE [MasterBase] SET NUMERIC_ROUNDABORT OFF 
GO
ALTER DATABASE [MasterBase] SET QUOTED_IDENTIFIER OFF 
GO
ALTER DATABASE [MasterBase] SET RECURSIVE_TRIGGERS OFF 
GO
ALTER DATABASE [MasterBase] SET  ENABLE_BROKER 
GO
ALTER DATABASE [MasterBase] SET AUTO_UPDATE_STATISTICS_ASYNC OFF 
GO
ALTER DATABASE [MasterBase] SET DATE_CORRELATION_OPTIMIZATION OFF 
GO
ALTER DATABASE [MasterBase] SET TRUSTWORTHY OFF 
GO
ALTER DATABASE [MasterBase] SET ALLOW_SNAPSHOT_ISOLATION OFF 
GO
ALTER DATABASE [MasterBase] SET PARAMETERIZATION SIMPLE 
GO
ALTER DATABASE [MasterBase] SET READ_COMMITTED_SNAPSHOT OFF 
GO
ALTER DATABASE [MasterBase] SET HONOR_BROKER_PRIORITY OFF 
GO
ALTER DATABASE [MasterBase] SET RECOVERY FULL 
GO
ALTER DATABASE [MasterBase] SET  MULTI_USER 
GO
ALTER DATABASE [MasterBase] SET PAGE_VERIFY CHECKSUM  
GO
ALTER DATABASE [MasterBase] SET DB_CHAINING OFF 
GO
ALTER DATABASE [MasterBase] SET FILESTREAM( NON_TRANSACTED_ACCESS = OFF ) 
GO
ALTER DATABASE [MasterBase] SET TARGET_RECOVERY_TIME = 60 SECONDS 
GO
ALTER DATABASE [MasterBase] SET DELAYED_DURABILITY = DISABLED 
GO
ALTER DATABASE [MasterBase] SET ACCELERATED_DATABASE_RECOVERY = OFF  
GO
EXEC sys.sp_db_vardecimal_storage_format N'MasterBase', N'ON'
GO
ALTER DATABASE [MasterBase] SET QUERY_STORE = OFF
GO
USE [MasterBase]
GO
/****** Object:  Table [dbo].[Age]    Script Date: 6/9/2022 5:40:04 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Age](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[Age] [int] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Credentials]    Script Date: 6/9/2022 5:40:05 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Credentials](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Username] [varchar](50) NOT NULL,
	[Pass_word] [varchar](50) NOT NULL,
	[User_identification] [varchar](50) NULL,
PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Supplier]    Script Date: 6/9/2022 5:40:05 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Supplier](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[Name] [varchar](50) NOT NULL,
	[Features] [nvarchar](max) NULL,
PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Whiskey]    Script Date: 6/9/2022 5:40:05 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Whiskey](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Code] [uniqueidentifier] NULL,
	[Name] [varchar](50) NOT NULL,
	[WhiskeyType_id] [int] NOT NULL,
	[Age_id] [int] NOT NULL,
	[Photo] [varbinary](max) NOT NULL,
	[Price] [money] NOT NULL,
	[Supplier_id] [int] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[WhiskeyReviews]    Script Date: 6/9/2022 5:40:05 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[WhiskeyReviews](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[User_id] [int] NOT NULL,
	[Review] [varchar](50) NOT NULL,
	[Whiskey_id] [int] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[WhiskeyType]    Script Date: 6/9/2022 5:40:05 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[WhiskeyType](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[Name] [varchar](50) NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Whiskey]  WITH CHECK ADD FOREIGN KEY([Age_id])
REFERENCES [dbo].[Age] ([ID])
GO
ALTER TABLE [dbo].[Whiskey]  WITH CHECK ADD FOREIGN KEY([Supplier_id])
REFERENCES [dbo].[Supplier] ([ID])
GO
ALTER TABLE [dbo].[Whiskey]  WITH CHECK ADD FOREIGN KEY([WhiskeyType_id])
REFERENCES [dbo].[WhiskeyType] ([ID])
GO
ALTER TABLE [dbo].[WhiskeyReviews]  WITH CHECK ADD FOREIGN KEY([Whiskey_id])
REFERENCES [dbo].[Whiskey] ([Id])
GO
/****** Object:  StoredProcedure [dbo].[InsertCredentials]    Script Date: 6/9/2022 5:40:05 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[InsertCredentials]
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
/****** Object:  StoredProcedure [dbo].[PruebaBackend]    Script Date: 6/9/2022 5:40:05 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[PruebaBackend] @in_PruebaParametro varchar(64),@prueba varchar(65)

AS
	BEGIN
		DECLARE @total INT =2



		SELECT (@prueba)


		return 1
END;
GO
/****** Object:  StoredProcedure [dbo].[SignIn]    Script Date: 6/9/2022 5:40:05 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
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
USE [master]
GO
ALTER DATABASE [MasterBase] SET  READ_WRITE 
GO
