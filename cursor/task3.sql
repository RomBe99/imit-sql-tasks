DROP DATABASE IF EXISTS task3;
CREATE DATABASE task3;
USE task3;

CREATE TABLE question
(
    question VARCHAR(100) NOT NULL,
    answer1 VARCHAR(100) NOT NULL,
    answer2 VARCHAR(100) NOT NULL,
    answer3 VARCHAR(100) NOT NULL,
    difficulty INT NOT NULL,

    PRIMARY KEY (question)
) ENGINE = INNODB
  DEFAULT CHARSET = utf8;

CREATE TABLE test
(
    question VARCHAR(100) NOT NULL,
    answer1 VARCHAR(100) NOT NULL,
    answer2 VARCHAR(100) NOT NULL,
    answer3 VARCHAR(100) NOT NULL,
    difficulty INT NOT NULL,

    PRIMARY KEY (question)
) ENGINE = INNODB
  DEFAULT CHARSET = utf8;

CREATE TABLE answer
(
    answer VARCHAR(100) NOT NULL,

    PRIMARY KEY (answer)
) ENGINE = INNODB
  DEFAULT CHARSET = utf8;

INSERT INTO question VALUES
('2 + 2 = ?', '4', '5', '10', 1),
('50 / 25 = ?', '5', '2', '10', 3),
('5 * 3 = ?', '25', '1', '15', 2),
('10 * 20 = ?', '100', '200', '20', 2),
('10 + 30 = ?', '40', '10', '-2', 1),
('45 / 5 = ?', '9', '10', '20', 3),
('2 + 5 = ?', '9', '3', '7', 1),
('25 + 60 = ?', '40', '25', '85', 2),
('3 / 2 = ?', '1.5', '1', '3', 3),
('2 - 3 = ?', '-1', '-3', '1', 1),
('22 + 3 = ?', '25', '5', '30', 1),
('0 / 5 = ?', '32', '2', '0', 3);

DELIMITER //
CREATE PROCEDURE randomSelect()
BEGIN
    DECLARE isEnd INT DEFAULT false;

    DECLARE questionTmp VARCHAR(100) DEFAULT NULL;
    DECLARE answer1Tmp VARCHAR(100) DEFAULT NULL;
    DECLARE answer2Tmp VARCHAR(100) DEFAULT NULL;
    DECLARE answer3Tmp VARCHAR(100) DEFAULT NULL;

    # Ответы получившиеся после рандома
    DECLARE result1 VARCHAR(100);
    DECLARE result2 VARCHAR(100);
    DECLARE result3 VARCHAR(100);

    DECLARE cur CURSOR FOR SELECT question, answer1, answer2, answer3 FROM question
    ORDER BY RAND() LIMIT 12;

    DECLARE CONTINUE HANDLER FOR NOT FOUND SET isEnd = true;

    OPEN cur;

    readLoop:LOOP
        FETCH cur INTO questionTmp, answer1Tmp, answer2Tmp, answer3Tmp;

        INSERT INTO answer VALUES
        (answer1Tmp),
        (answer2Tmp),
        (answer3Tmp);

        SET result1 = (SELECT answer FROM answer LIMIT 1);
        DELETE FROM answer LIMIT 1;
        SET result2 = (SELECT answer FROM answer LIMIT 1);
        DELETE FROM answer LIMIT 1;
        SET result3 = (SELECT answer FROM answer LIMIT 1);
        DELETE FROM answer LIMIT 1;

        SELECT questionTmp, result1, result2, result3;

        IF isEnd THEN
            LEAVE readLoop;
        END IF;
    END LOOP;

    CLOSE cur;
END;
//

SELECT * FROM question;
SELECT * FROM answer;

CALL randomSelect();
SELECT * FROM test;