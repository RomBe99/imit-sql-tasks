DROP DATABASE IF EXISTS task4;
CREATE DATABASE task4;
USE task4;

CREATE TABLE idA1
(
    id INT NOT NULL AUTO_INCREMENT,
    a INT NOT NULL,

    PRIMARY KEY (id)
) ENGINE = INNODB
  DEFAULT CHARSET = utf8;

INSERT INTO idA1(a)VALUES
(RAND() * 10),
(RAND() * 10),
(RAND() * 10),
(RAND() * 10),
(RAND() * 10),
(RAND() * 10),
(RAND() * 10),
(RAND() * 10),
(RAND() * 10);

CREATE TABLE idA2
(
    id INT NOT NULL AUTO_INCREMENT,
    a INT NOT NULL,

    PRIMARY KEY (id)
) ENGINE = INNODB
  DEFAULT CHARSET = utf8;

DELIMITER //
CREATE PROCEDURE f1(IN avgIdA INT, IN minIdA INT, IN maxIdA INT)
BEGIN
    DECLARE isEnd INT DEFAULT false;

    DECLARE a INT;
    DECLARE cur CURSOR FOR SELECT idA1.a FROM idA1;

    DECLARE CONTINUE HANDLER FOR NOT FOUND SET isEnd = true;

    OPEN cur;

    readLoop:LOOP
        FETCH cur INTO a;

        IF isEnd THEN
            LEAVE readLoop;
        END IF;

        IF a > avgIdA THEN
            INSERT INTO idA2(a) VALUES (minIdA);
            ELSE INSERT INTO idA2(a) VALUES (maxIdA);
        END IF;
    END LOOP;

    CLOSE cur;
end;
//

CALL f1((SELECT AVG(a) FROM idA1), (SELECT MIN(a) FROM idA1), (SELECT MAX(a) FROM idA1));

# Среднее
SELECT AVG(idA1.a) AS 'average a', AVG(idA2.a) AS 'average a\'' FROM idA1, idA2;

# Среднеквдратичное отклонение
SELECT STD(idA1.a) AS 'std a', STD(idA2.a) AS 'std a\'' FROM idA1, idA2;

# Найдём медиану для idA1
SET @rowIndex = -1;
SELECT AVG(idAA) FROM (
    SELECT @rowIndex = @rowIndex + 1 AS rIndex, a AS idAA FROM idA1
    ORDER BY a) AS tmp
WHERE tmp.rIndex IN (FLOOR(@rowIndex/2), CEIL(@rowIndex/2));

# Найдём медиану для idA2
SET @rowIndex = -1;
SELECT AVG(idAA) FROM (
    SELECT @rowIndex = @rowIndex + 1 AS rIndex, a AS idAA FROM idA2
    ORDER BY a) AS tmp
WHERE tmp.rIndex IN (FLOOR(@rowIndex/2), CEIL(@rowIndex/2));