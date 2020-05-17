DROP DATABASE IF EXISTS task2;
CREATE DATABASE task2;
USE task2;

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
CREATE PROCEDURE createTest(IN easy INT, IN `medium` INT, IN hard INT)
BEGIN
    DECLARE isEnd INT DEFAULT false;

    DECLARE easyC INT DEFAULT 0;
    DECLARE mediumC INT DEFAULT 0;
    DECLARE hardC INT DEFAULT 0;
    DECLARE mainC INT DEFAULT 100;

    # Временные переменные куда будем считывать данные из курсора.
    DECLARE questionTmp VARCHAR(100) DEFAULT NULL;
    DECLARE answer1Tmp VARCHAR(100) DEFAULT NULL;
    DECLARE answer2Tmp VARCHAR(100) DEFAULT NULL;
    DECLARE answer3Tmp VARCHAR(100) DEFAULT NULL;
    DECLARE difficultyTmp INT DEFAULT 0;

    # Создадим курсор.
    DECLARE cur CURSOR FOR SELECT * FROM question;

    DECLARE CONTINUE HANDLER FOR NOT FOUND SET isEnd = true;

    OPEN cur;

    readLoop:LOOP
        FETCH cur INTO questionTmp, answer1Tmp, answer2Tmp, answer3Tmp, difficultyTmp;

        # Здесь проверяем на какую задачу указывает курсор, далее определяем нужно ли её добавлять в конечный тест.
        IF easy <> 0 AND difficultyTmp = 1 THEN
            IF easyC = 0 OR mainC / (easyC + mediumC + hardC) * easyC < easy THEN
                INSERT INTO test VALUES (questionTmp, answer1Tmp, answer2Tmp, answer3Tmp, difficultyTmp);
                SET easyC = easyC + 1;
            END IF;
        END IF;

        IF medium <> 0 AND difficultyTmp = 2 THEN
            IF mediumC = 0 OR mainC / (easyC + mediumC + hardC) * mediumC < medium THEN
                INSERT INTO test VALUES (questionTmp, answer1Tmp, answer2Tmp, answer3Tmp, difficultyTmp);
                SET mediumC = mediumC + 1;
            END IF;
        END IF;

        IF hard <> 0 AND difficultyTmp = 3 THEN
            IF hardC = 0 OR mainC / (easyC + mediumC + hardC) * hardC < hard THEN
                INSERT INTO test VALUES (questionTmp, answer1Tmp, answer2Tmp, answer3Tmp, difficultyTmp);
                SET hardC = hardC + 1;
            END IF;
        END IF;

        IF isEnd THEN
            LEAVE readLoop;
        END IF;
    END LOOP;

    CLOSE cur;
END;
//

CALL createTest(45, 45, 10);

SELECT * FROM test;