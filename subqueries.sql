DROP DATABASE IF EXISTS subqueriesTest;
CREATE DATABASE subqueriesTest;
USE subqueriesTest;

# Таблица команды - тренеры

CREATE TABLE teams_and_coaches
(
    teamName VARCHAR(50) NOT NULL,
    coachName VARCHAR(50) NOT NULL,

    PRIMARY KEY (teamName, coachName)
) ENGINE = INNODB
  DEFAULT CHARSET = utf8;

# Таблица писатели - жанры

CREATE TABLE writers_and_genres
(
    id INT NOT NULL AUTO_INCREMENT,
    genre VARCHAR(50) NOT NULL,
    writerName VARCHAR(50) NOT NULL,

    PRIMARY KEY (id)
) ENGINE = INNODB
  DEFAULT CHARSET = utf8;

# Таблица место - очки - команда - тренер

CREATE TABLE high_score_table
(
    id INT NOT NULL AUTO_INCREMENT,
    place INT NOT NULL,
    teamName VARCHAR(50) NOT NULL,
    coachName VARCHAR(50) NOT NULL,
    score INT NOT NULL,

    PRIMARY KEY (id)
) ENGINE = INNODB
  DEFAULT CHARSET = utf8;

# Заполним таблицы выше

INSERT INTO teams_and_coaches VALUES ('Авангард', 'Каменский');
INSERT INTO teams_and_coaches VALUES ('Куеда', 'Каменский');
INSERT INTO teams_and_coaches VALUES ('Ольовка', 'Киселёв');
INSERT INTO teams_and_coaches VALUES ('Тербуны', 'Киселёв');
INSERT INTO teams_and_coaches VALUES ('Авангард', 'Киселёв');
INSERT INTO teams_and_coaches VALUES ('Солнечная Долина', 'Иванов');
INSERT INTO teams_and_coaches VALUES ('Куеда', 'Аверин');
INSERT INTO teams_and_coaches VALUES ('Тербуны', 'Андреева');

INSERT INTO writers_and_genres VALUES (0, 'Детектив', 'Кириллов');
INSERT INTO writers_and_genres VALUES (0, 'Ужасы', 'Кириллов');
INSERT INTO writers_and_genres VALUES (0, 'Научная фантастика', 'Кириллов');
INSERT INTO writers_and_genres VALUES (0, 'Приключения', 'Кириллов');
INSERT INTO writers_and_genres VALUES (0, 'Фантастика', 'Кириллов');
INSERT INTO writers_and_genres VALUES (0, 'Комедия', 'Кириллов');
INSERT INTO writers_and_genres VALUES (0, 'Приключения', 'Громов');
INSERT INTO writers_and_genres VALUES (0, 'Фантастика', 'Громов');
INSERT INTO writers_and_genres VALUES (0, 'Комедия', 'Громов');
INSERT INTO writers_and_genres VALUES (0, 'Фантастика', 'Берестов');
INSERT INTO writers_and_genres VALUES (0, 'Детектив', 'Берестов');
INSERT INTO writers_and_genres VALUES (0, 'Научная фантастика', 'Берестов');
INSERT INTO writers_and_genres VALUES (0, 'Комедия', 'Берестов');
INSERT INTO writers_and_genres VALUES (0, 'Ужасы', 'Берестов');
INSERT INTO writers_and_genres VALUES (0, 'Приключения', 'Берестов');
INSERT INTO writers_and_genres VALUES (0, 'Ужасы', 'Козлов');
INSERT INTO writers_and_genres VALUES (0, 'Комедия', 'Козлов');
INSERT INTO writers_and_genres VALUES (0, 'Комедия', 'Лебедева');

INSERT INTO high_score_table VALUES (0, 2, 'Куеда', 'Каменский', 11);
INSERT INTO high_score_table VALUES (0, 3, 'Ольовка', 'Киселёв', 9);
INSERT INTO high_score_table VALUES (0, 1, 'Тербуны', 'Андреева', 15);
INSERT INTO high_score_table VALUES (0, 1, 'Тербуны', 'Киселёв', 13);
INSERT INTO high_score_table VALUES (0, 1, 'Авангард', 'Иванов', 13);
INSERT INTO high_score_table VALUES (0, 1, 'Авангард', 'Каменский', 13);
INSERT INTO high_score_table VALUES (0, 4, 'Авангард', 'Киселёв', 8);
INSERT INTO high_score_table VALUES (0, 5, 'Солнечная Долина', 'Иванов', 4);
INSERT INTO high_score_table VALUES (0, 1, 'Солнечная Долина', 'Иванов', 4);

# 1) команды, которые тренировал более чем один тренер.

SELECT * FROM (
    SELECT teamName, COUNT(coachName) AS coachCount FROM teams_and_coaches
    GROUP BY teamName) AS tmp
WHERE coachCount > 1;

# 2) писателей, которые писали во всех жанрах, представленных в таблице.

SELECT * FROM (
    SELECT writerName, COUNT(genre) AS genresCount FROM writers_and_genres
    GROUP BY writerName) AS tmp
WHERE genresCount = (SELECT COUNT(DISTINCT genre) FROM writers_and_genres);

# 3) жанры, в которых писали все.

SELECT * FROM (
              SELECT genre, COUNT(writerName) AS writersCount FROM writers_and_genres
              GROUP BY genre) AS tmp
WHERE writersCount = (SELECT COUNT(DISTINCT writerName) FROM writers_and_genres);

# 4) тренеров, которые не тренировали заданную команду.

SELECT DISTINCT coachName FROM teams_and_coaches AS tc1
WHERE coachName NOT IN (
    SELECT coachName FROM teams_and_coaches tc2
    WHERE tc2.teamName = 'Тербуны');

# 5) тренеров, для которых среднее количество очков команд, которые они тренировали, больше среднего значения по всем тренерам из таблицы.

SELECT coachName FROM high_score_table
GROUP BY coachName
HAVING AVG(score) > (SELECT AVG(score) FROM high_score_table);

# 6) команды, становившиеся чемпионами с разными тренерами.

SELECT DISTINCT teamName FROM high_score_table AS hst1
WHERE place > 1 AND EXISTS(
    SELECT * FROM high_score_table AS hst2
    WHERE hst2.place = 1 AND hst1.teamName = hst2.teamName AND hst1.coachName <> hst2.coachName);

# 7) команды, которые тренировали тренеры, выигравшие чемпионат не с этой, а с другими командами.

SELECT DISTINCT teamName FROM high_score_table AS hst1
WHERE place > 1 AND EXISTS(
    SELECT * FROM high_score_table AS hst2
    WHERE hst2.place = 1 AND hst1.teamName <> hst2.teamName AND hst1.coachName = hst2.coachName);