DROP DATABASE IF EXISTS task1;
CREATE DATABASE task1;
USE task1;

CREATE TABLE season
(
    id INT NOT NULL AUTO_INCREMENT,
    matchDate DATE,
    rival VARCHAR(50) NOT NULL,
    result INT NOT NULL,

    PRIMARY KEY (id)
) ENGINE = INNODB
  DEFAULT CHARSET = utf8;

INSERT INTO season(matchDate, rival, result) VALUES
('2001-12-20', 'Авангард', 1),
('2003-11-26', 'Авангард', 0),
('2006-11-17', 'Авангард', 0),
('2008-01-17', 'Авангард', -1),
('2008-08-04', 'Авангард', 1),
('2009-08-04', 'Авангард', 1),
('2012-04-23', 'Авангард', 1),
('2013-09-11', 'Авангард', -1);

DELIMITER //
CREATE PROCEDURE maxStreaks(OUT maxWinStreak INT, OUT maxDrawStreak INT, OUT maxLoseStreak INT)
BEGIN
    # Флаг цикла
    DECLARE isEnd INT DEFAULT false;

    # Переменные для результатов

    DECLARE winMax INT DEFAULT 0;
    DECLARE loseMax INT DEFAULT 0;
    DECLARE drawMax INT DEFAULT 0;

    # Временные переменные

    DECLARE winMaxTmp INT DEFAULT 0;
    DECLARE loseMaxTmp INT DEFAULT 0;
    DECLARE drawMaxTmp INT DEFAULT 0;
    DECLARE curPos INT DEFAULT 0;
    DECLARE prevPos INT DEFAULT 0;

    DECLARE cur CURSOR FOR SELECT result FROM season;

    DECLARE CONTINUE HANDLER FOR NOT FOUND SET isEnd = true;

    OPEN cur;

    # Начинаем перебор таблицы.
    readLoop:LOOP
        SET prevPos = curPos;
        FETCH cur INTO curPos;

        IF isEnd THEN
            LEAVE readLoop;
        END IF;

        IF curPos <> prevPos THEN
            SET winMaxTmp = 0, loseMaxTmp = 0, drawMaxTmp = 0;
        END IF;

        # Проверяем, указывает ли курсор на победу.
        IF curPos = 1 THEN
            SET winMaxTmp = winMaxTmp + 1;

            # Если временная серия победа больше результирующей, временная становится результирующей.
            IF winMaxTmp > winMax THEN
                SET winMax = winMaxTmp;
            END IF;
        END IF;

        # Проверяем, указывает ли курсор на ничью.
        IF curPos = 0 THEN
            SET drawMaxTmp = drawMaxTmp + 1;

            # Если временная серия ничьих больше результирующей, временная становится результирующей.
            IF drawMaxTmp > drawMax THEN
                SET drawMax = drawMaxTmp;
            END IF;
        END IF;

        # Проверяем, указывает ли курсор на поражение.
        IF curPos = -1 THEN
            SET loseMaxTmp = loseMaxTmp + 1;

            # Если временная серия поражений больше результирующей, временная становится результирующей.
            IF loseMaxTmp > loseMax THEN
                SET loseMax = loseMaxTmp;
            END IF;
        END IF;

        SET maxWinStreak = winMax, maxDrawStreak = drawMax, maxLoseStreak = loseMax;
    END LOOP;

    CLOSE cur;
END;
//

SET @maxWinStreak = 0;
SET @maxDrawStreak = 0;
SET @maxLoseStreak = 0;

CALL maxStreaks(@maxWinStreak, @maxDrawStreak, @maxLoseStreak);

SELECT @maxLoseStreak, @maxDrawStreak, @maxWinStreak;