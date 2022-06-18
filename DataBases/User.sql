CREATE DATABASE User; -- MYSQL

USE User;

CREATE TABLE UserData(
	Id INT NOT NULL AUTO_INCREMENT,
	NameC VARCHAR(50) NOT NULL,
	Adress VARCHAR(50) NOT NULL,
	Identification VARCHAR(50) NOT NULL,
	Phone VARCHAR(50) NOT NULL,
	Email VARCHAR(50) NOT NULL,
	IsAdmin BIT NOT NULL,
	PRIMARY KEY(Id),
	UNIQUE(Identification)
); 

use user;
-- drop procedure InsertClient;
DELIMITER //
CREATE PROCEDURE InsertClient(
	IN in_name VARCHAR(50),
    IN in_adress VARCHAR(50), 
    IN in_identification VARCHAR(50), 
    IN in_phone VARCHAR(50), 
    IN in_email VARCHAR(50))
BEGIN

    DROP TABLE IF EXISTS temporal;
	CREATE TEMPORARY TABLE temporal(
      in_name2 VARCHAR(50), 
      in_adress2 VARCHAR(50),
      in_id2 VARCHAR(50),
      in_phone2 VARCHAR(50),
      in_email2 VARCHAR(50),
      var2 INT
    );
    SET @tmp_id = 'NULL';
    SET @exist = 0;

	SET @tmp_id = (select Identification FROM UserData WHERE Identification = in_identification);
    SET @exist = (SELECT ISNULL(@tmp_id));
    -- SELECT @exist;
	INSERT INTO temporal(in_name2, in_adress2, in_id2, in_phone2, in_email2, var2) VALUES(in_name, in_adress, in_identification, in_phone, in_email, @exist);

	INSERT INTO UserData(NameC, Adress, Identification, Phone, Email, IsAdmin) 
	SELECT in_name2, in_adress2, in_id2, in_phone2, in_email2, 0
	FROM temporal
	WHERE var2 = 1;

	SELECT @exist;

END//

	
DELIMITER ;

--CALL InsertClient('Kevin', 'Guadalupe', '118300155', '83822700', 'kevinrodriguezthome@gmail.com');
--CALL InsertClient('Gabriel', 'Escazu', '118301122', '87678767', 'g.moraestribi@gmail.com')