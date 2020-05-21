DROP DATABASE IF EXISTS task5;
CREATE DATABASE task5;
USE task5;

CREATE TABLE idAB1(
    id INT NOT NULL AUTO_INCREMENT,
    a INT NOT NULL,
    b FLOAT NOT NULL,
    PRIMARY KEY (id)
);

INSERT INTO idAB1(a, b) VALUES
(RAND() * 10, b = a * 0.01),
(RAND() * 10, b = a * 0.01),
(RAND() * 10, b = a * 0.01),
(RAND() * 10, b = a * 0.01),
(RAND() * 10, b = a * 0.01),
(RAND() * 10, b = a * 0.01),
(RAND() * 10, b = a * 0.01),
(RAND() * 10, b = a * 0.01),
(RAND() * 10, b = a * 0.01),
(RAND() * 10, b = a * 0.01);

CREATE TABLE idAB2
(
    id INT NOT NULL AUTO_INCREMENT,
    a INT NOT NULL,
    b FLOAT NOT NULL,
    PRIMARY KEY (id)
);

DELIMITER //
CREATE PROCEDURE id_a_b_proc()
BEGIN
    DECLARE done INT DEFAULT false;

    DECLARE a INT;
    DECLARE b int;
    DECLARE cur CURSOR FOR SELECT idAB1.a, idAB1.b FROM idAB1;
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = true;

    OPEN cur;

    readLoop:LOOP
        FETCH cur INTO a, b;

        IF done THEN
	        LEAVE readLoop;
        END IF;
    INSERT INTO idAB2(a, b) VALUES (a, a * a);
    END LOOP;

    CLOSE cur;
END;
//

SELECT * FROM idAB1;
SELECT * FROM idAB2;

CALL id_a_b_proc();

# Среднее.
SELECT AVG(idAB1.a), AVG(idAB2.a), AVG(idAB1.b), AVG(idAB2.b) FROM idAB1,idAB2;
# Среднеквадратичное отклонение.
SELECT STD(idAB1.a), STD(idAB2.a), STD(idAB1.b), STD(idAB2.b) FROM idAB1, idAB2;