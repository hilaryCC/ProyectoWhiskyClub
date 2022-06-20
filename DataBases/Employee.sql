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
	Calification_average FLOAT,
	FOREIGN KEY (Position_id) REFERENCES EmployeePosition(Id)
); 

CREATE TABLE EmployeesReviews(
	Id INT PRIMARY KEY NOT NULL auto_increment,
	User_id INT NOT NULL,
	Review VARCHAR(100) NOT NULL,
	Employee_id INT NOT NULL,
	Calification INT NOT NULL,
	FOREIGN KEY (Employee_id) REFERENCES EmployeesData(Id)
);

------------------------------------------CRUD EMPLOYEE-----------------------------------------------

USE Employee;

DELIMITER //
CREATE PROCEDURE InsertEmployee(
	IN in_name VARCHAR(50),
	IN in_shop INT,
	IN in_adress VARCHAR(50),
	IN in_identification VARCHAR(50),
	IN in_phone VARCHAR(50),
	IN in_email VARCHAR(50),
	IN in_salary DECIMAL, -- MONEY TYPE DOESN'T EXIST, SO WE USE DECIMAL INSTEAD
	IN position_id INT)
BEGIN

    DROP TABLE IF EXISTS temporal;
	CREATE TEMPORARY TABLE temporal(
		in_name2 VARCHAR(50),
		in_shop2 INT,
		in_adress2 VARCHAR(50),
		in_identification2 VARCHAR(50),
		in_phone2 VARCHAR(50),
		in_email2 VARCHAR(50),
		in_salary2 DECIMAL, -- MONEY TYPE DOESN'T EXIST, SO WE USE DECIMAL INSTEAD
		position_id2 INT,
		var2 INT
    );
    SET @tmp_id = 'NULL';
    SET @exist = 0;

	SET @tmp_id = (select Id FROM employeeposition WHERE Id = position_id);
    SET @exist = (SELECT ISNULL(@tmp_id));
    -- SELECT @tmp_id;
	INSERT INTO temporal(in_name2, in_shop2, in_adress2, in_identification2, in_phone2, in_email2, in_salary2, position_id2, var2)
    VALUES(in_name, in_shop, in_adress, in_identification, in_phone, in_email, in_salary, position_id, @exist);

	INSERT INTO employeesdata(Name, Shop_id, Adress, Identification, Phone, Email, Salary, Position_id) 
	SELECT in_name2, in_shop2, in_adress2, in_identification2, in_phone2, in_email2, in_salary2, position_id2
	FROM temporal
	WHERE var2 = 0;

	SELECT @exist;

END//

	
DELIMITER ;

USE Employee;

DELIMITER //
CREATE PROCEDURE ModifyEmployee( -- Change configuration in the preferences of mysql in the safe mode of updates
	IN in_name VARCHAR(50),
	IN in_shop INT,
	IN in_adress VARCHAR(50),
	IN in_identification VARCHAR(50),
	IN in_phone VARCHAR(50),
	IN in_email VARCHAR(50),
	IN in_salary DECIMAL, 
	IN position_id INT)
BEGIN
	DECLARE tmp_name VARCHAR(50);
    DECLARE tmp_shop INT;
    DECLARE tmp_adress VARCHAR(50);
    DECLARE tmp_identification VARCHAR(50);
    DECLARE tmp_phone VARCHAR(50);
    DECLARE tmp_email VARCHAR(50);
    DECLARE tmp_salary DECIMAL;
    DECLARE tmp_position INT;
    DROP TABLE IF EXISTS temporal;
	CREATE TEMPORARY TABLE temporal(
		in_name2 VARCHAR(50),
		in_shop2 INT,
		in_adress2 VARCHAR(50),
		in_identification2 VARCHAR(50),
		in_phone2 VARCHAR(50),
		in_email2 VARCHAR(50),
		in_salary2 DECIMAL, 
		position_id2 INT,
		var2 INT
    );
    SET @tmp_id = 'NULL';
    SET @exist = 0;
    SET @tmp_identification = 'NULL';
    SET @exist2 = 0;

	SET @tmp_id = (select Id FROM employeeposition WHERE Id = position_id);
    SET @exist = (SELECT ISNULL(@tmp_id));
    
    SET @tmp_identification = (select Identification FROM employeesdata WHERE Identification = in_identification);
    SET @exist = (SELECT ISNULL(@tmp_identification));
    -- SELECT @tmp_id;
	-- INSERT INTO temporal(in_name2, in_shop2, in_adress2, in_identification2, in_phone2, in_email2, in_salary2, position_id2, var2)
    -- VALUES(in_name, in_shop, in_adress, in_identification, in_phone, in_email, in_salary, position_id, @exist);
    
    -- SELECT tmp_name, tmp_shop, tmp_adress, tmp_phone, tmp_email, tmp_salary, tmp_position = in_name2, in_shop2, in_adress2, in_phone2, in_email2, in_salary2, position_id2 FROM temporal WHERE var2 = 0;

	UPDATE employeesdata
    SET Name = in_name,
    Shop_id = in_shop,
    Adress = in_adress,
    Phone = in_phone,
    Email = in_email,
    Salary = in_salary,
    Position_id = position_id
	WHERE Identification = in_identification AND @exist = 0 AND @exist2 = 0;

	SELECT @exist2;

END//

	
DELIMITER ;

USE Employee;

DELIMITER //
CREATE PROCEDURE DeleteEmployee(
	IN in_identification VARCHAR(50))
BEGIN
	SET @tmp_id = 'NULL';
    SET @exist = 0;
    
    SET @tmp_id = (select Identification FROM employeesdata WHERE Identification = in_identification);
    SET @exist = (SELECT ISNULL(@tmp_id));
    
    DELETE FROM employeesdata WHERE Identification = in_identification AND @exist = 0;
    
    SELECT @exist;
	

END//

	
DELIMITER ;

-----------------------------------------------------------------------------------------------------------

DELIMITER //
CREATE PROCEDURE InsertEmployeeReview( 
	IN in_user VARCHAR(50),
    IN in_employee VARCHAR(50), 
    IN in_review VARCHAR(100),
    IN in_calification INT)
BEGIN
	DROP TABLE IF EXISTS temporal;
	CREATE TEMPORARY TABLE temporal(
		in_user2 VARCHAR(50),
		in_employee2 VARCHAR(50),
		in_review2 VARCHAR(100),
		in_exist1 INT,
        in_exist2 INT
    );
    SET @tmp_id = 'NULL';
    SET @exist = 0;
    SET @tmp_id2 = 0;
    SET @exist2 = 0;

	SET @tmp_id = (select Identification FROM user.userdata WHERE Identification = in_user);
    SET @exist = (SELECT ISNULL(@tmp_id));
    
    
    SET @tmp_id2 = (select Id FROM employeesdata WHERE Identification = in_employee);
    SET @exist2 = (SELECT ISNULL(@tmp_id2));
    
    IF @exist = 0 AND @exist2 = 0 AND in_calification < 6 THEN
		INSERT INTO employeesreviews(User_id, Review, Employee_id, Calification)
		VALUES(in_user, in_review, @tmp_id2, in_calification);
        SELECT 0;

   ELSE
      SELECT 1;
	END IF;

END//

	
DELIMITER ;

-- CALL InsertEmployee('Horacio', 1, 'Washington', '2030', '12344321', 'horacio@gmail.com', 50, 1);
-- CALL ModifyEmployee('Horacio', 1, 'Washington', '2030', '12344321', 'horacio@gmail.com', 50, 2);
-- CALL DeleteEmployee('2030')