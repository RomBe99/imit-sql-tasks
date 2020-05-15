DROP DATABASE IF EXISTS hospitalTest;
CREATE DATABASE hospitalTest;
USE hospitalTest;

# Индексы для primary key, foreign key и unique key MySql создаёт автоматически, пожтому далее их будем игнорировать.
# В таблице user необходимо создать индексы для атрибутов password, firstName, lastName и patronymic,
# так как при лоигне будет БД будет часто обращаться к атрибуту password.
# Также будет часто происходить частое обращение firstName, lastName и patronymic при различного рода выборках, join и тд.
# Ко всему прочему, пользователей может быть огромное количество + это родительская таблица для всех типов пользователей.

CREATE TABLE user
(
    id         INT         NOT NULL AUTO_INCREMENT,

    login      VARCHAR(30) NOT NULL,
    password   VARCHAR(30) NOT NULL,

    firstName  VARCHAR(30) NOT NULL,
    lastName   VARCHAR(30) NOT NULL,
    patronymic VARCHAR(30) DEFAULT NULL,

    PRIMARY KEY (id),
    UNIQUE KEY (login),
    KEY firstName (firstName),
    KEY lastName (lastName),
    KEY patronymic (patronymic),
    KEY password (password)
) ENGINE = INNODB
  DEFAULT CHARSET = utf8;

CREATE TABLE administrator
(
    userId   INT          NOT NULL,
    position VARCHAR(200) NOT NULL,

    PRIMARY KEY (userId),
    FOREIGN KEY (userId) REFERENCES user (id) ON DELETE CASCADE
) ENGINE = INNODB
  DEFAULT CHARSET = utf8;

CREATE TABLE cabinet
(
    id   INT         NOT NULL AUTO_INCREMENT,
    name VARCHAR(30) NOT NULL,

    PRIMARY KEY (id),
    UNIQUE KEY (name)
) ENGINE = INNODB
  DEFAULT CHARSET = utf8;

CREATE TABLE doctor_specialty
(
    id   INT         NOT NULL AUTO_INCREMENT,
    name VARCHAR(30) NOT NULL,

    PRIMARY KEY (id),
    UNIQUE KEY (name)
) ENGINE = INNODB
  DEFAULT CHARSET = utf8;

CREATE TABLE doctor
(
    userId      INT NOT NULL,

    specialtyId INT NOT NULL,
    cabinetId   INT DEFAULT NULL,

    PRIMARY KEY (userId),
    FOREIGN KEY (userId) REFERENCES user (id) ON DELETE CASCADE,
    FOREIGN KEY (specialtyId) REFERENCES doctor_specialty (id) ON DELETE CASCADE,
    FOREIGN KEY (cabinetId) REFERENCES cabinet (id) ON DELETE SET NULL
) ENGINE = INNODB
  DEFAULT CHARSET = utf8;

CREATE TABLE patient
(
    userId  INT          NOT NULL,
    email   VARCHAR(320) NOT NULL,
    address VARCHAR(200) NOT NULL,
    phone   VARCHAR(12)  NOT NULL,

    PRIMARY KEY (userId),
    FOREIGN KEY (userId) REFERENCES user (id) ON DELETE CASCADE
) ENGINE = INNODB
  DEFAULT CHARSET = utf8;

# Атрибут date также очень часто возникает в выборке,
# к тому же, расписание может быть огромным, поэтому индексируя этот атрибут мы выйгрываем в скорости.

CREATE TABLE schedule_cell
(
    id       INT  NOT NULL AUTO_INCREMENT,
    doctorId INT  NOT NULL,
    date     DATE NOT NULL,

    PRIMARY KEY (id),
    FOREIGN KEY (doctorId) REFERENCES doctor (userId) ON DELETE CASCADE,
    KEY date (date)
) ENGINE = INNODB
  DEFAULT CHARSET = utf8;

# Атрибут ticketTine также очень часто возникает в выборке,
# к тому же, расписание может быть огромным, поэтому индексируя этот атрибут мы выйгрываем в скорости.

CREATE TABLE time_cell
(
    ticketTime     TIME NOT NULL,
    scheduleCellId INT  NOT NULL,
    patientId      INT DEFAULT NULL,
    duration       INT  NOT NULL,

    PRIMARY KEY (ticketTime, scheduleCellId),
    FOREIGN KEY (scheduleCellId) REFERENCES schedule_cell (id) ON DELETE CASCADE,
    FOREIGN KEY (patientId) REFERENCES patient (userId) ON DELETE SET NULL,
    KEY ticketTime (ticketTime)
) ENGINE = INNODB
  DEFAULT CHARSET = utf8;

# Insert doctors specialities

INSERT INTO doctor_specialty
VALUES (0, 'Dentist');

INSERT INTO doctor_specialty
VALUES (0, 'Surgeon');

INSERT INTO doctor_specialty
VALUES (0, 'Therapist');

INSERT INTO doctor_specialty
VALUES (0, 'Traumatologist');

# Insert hospital cabinets

INSERT INTO cabinet
VALUES (0, '104');

INSERT INTO cabinet
VALUES (0, '205');

INSERT INTO cabinet
VALUES (0, '306');

INSERT INTO cabinet
VALUES (0, '407');

# Insert root admin

INSERT INTO user
VALUES (0, 'admin', 'admin', 'Roman', 'Belinsky', NULL);
INSERT INTO administrator
VALUES (last_insert_id(), 'Root admin');

# Insert doctors

INSERT INTO user
VALUES (0, 'ZvezdnyiyAakesh182', 'CqjJHHZRd4ao', 'Аакеш', 'Звездный', NULL);
INSERT INTO doctor
VALUES (last_insert_id(),
        (SELECT id FROM doctor_specialty WHERE name = 'Traumatologist'),
        (SELECT id FROM cabinet WHERE name = '205'));

INSERT INTO user
VALUES (0, 'FeDOSEEVAMeldra296', 'CqjJHHZRd4ao', 'Мелдра', 'Федосеева', 'Геннадиевна');
INSERT INTO doctor
VALUES (last_insert_id(),
        (SELECT id FROM doctor_specialty WHERE name = 'Surgeon'),
        (SELECT id FROM cabinet WHERE name = '306'));

INSERT INTO user
VALUES (0, 'FedOsEEva228', 'e0Dp4LCkx3ye', 'Анулик', 'Федосеева', 'Геннадиевна');
INSERT INTO doctor
VALUES (last_insert_id(),
        (SELECT id FROM doctor_specialty WHERE name = 'Surgeon'),
        (SELECT id FROM cabinet WHERE name = '407'));

# Insert patients

INSERT INTO user
VALUES (0, 'Fedoseev', 'e0Dp4LCkx3ye', 'Алик', 'Федосеев', NULL);
INSERT INTO patient
VALUES (last_insert_id(), 'disotoh476@box4mls.com', '404510, г. Шербакуль, ул. Взлетная  (Московский), дом 63, квартира 60', '79555367518');

INSERT INTO user
VALUES (0, 'TarskiyZoid401', 'xck26nN9GZ5P', 'Зоид', 'Тарский', 'Викторович');
INSERT INTO patient
VALUES (last_insert_id(), 'kegetob726@jupiterm.com', '665385, г. Ртищево, ул. Дорожная, дом 15, квартира 337', '79338786879');

# Insert schedule for traumatologist

INSERT INTO schedule_cell
VALUES (0, (SELECT id FROM user WHERE login = 'ZvezdnyiyAakesh182'), '2020-01-23');

INSERT INTO time_cell
VALUES ('11:30:00', last_insert_id(), NULL, 15);

INSERT INTO time_cell
VALUES ('11:45:00', last_insert_id(), NULL, 40);

INSERT INTO time_cell
VALUES ('12:25:00', last_insert_id(), NULL, 60);

INSERT INTO schedule_cell
VALUES (0, (SELECT id FROM user WHERE login = 'ZvezdnyiyAakesh182'), '2020-01-24');

INSERT INTO time_cell
VALUES ('11:30:00', last_insert_id(), NULL, 15);

INSERT INTO time_cell
VALUES ('11:45:00', last_insert_id(), NULL, 40);

INSERT INTO time_cell
VALUES ('12:25:00', last_insert_id(), NULL, 60);

INSERT INTO schedule_cell
VALUES (0, (SELECT id FROM user WHERE login = 'ZvezdnyiyAakesh182'), '2020-01-25');

INSERT INTO time_cell
VALUES ('11:30:00', last_insert_id(), NULL, 15);

INSERT INTO time_cell
VALUES ('11:45:00', last_insert_id(), NULL, 40);

INSERT INTO time_cell
VALUES ('12:25:00', last_insert_id(), NULL, 60);

# Insert schedule for surgeon

INSERT INTO schedule_cell
VALUES (0, (SELECT id FROM user WHERE login = 'FeDOSEEVAMeldra296'), '2020-01-23');

INSERT INTO time_cell
VALUES ('11:30:00', last_insert_id(), NULL, 90);

INSERT INTO time_cell
VALUES ('12:00:00', last_insert_id(), NULL, 45);

INSERT INTO schedule_cell
VALUES (0, (SELECT id FROM user WHERE login = 'FeDOSEEVAMeldra296'), '2020-01-24');

INSERT INTO time_cell
VALUES ('11:30:00', last_insert_id(), NULL, 15);

INSERT INTO time_cell
VALUES ('11:45:00', last_insert_id(), NULL, 40);

INSERT INTO time_cell
VALUES ('12:25:00', last_insert_id(), NULL, 60);

INSERT INTO schedule_cell
VALUES (0, (SELECT id FROM user WHERE login = 'FeDOSEEVAMeldra296'), '2020-01-25');

INSERT INTO time_cell
VALUES ('13:30:00', last_insert_id(), NULL, 120);

# Update time cell

SET @scId = (SELECT id FROM schedule_cell AS sc JOIN time_cell tc ON sc.id = tc.scheduleCellId
          WHERE date = '2020-01-24'
            AND ticketTime = '11:45:00'
            AND doctorId = (SELECT id FROM user JOIN doctor d ON user.id = d.userId WHERE login = 'ZvezdnyiyAakesh182'));

UPDATE time_cell SET patientId = (SELECT id FROM user JOIN patient p ON user.id = p.userId WHERE login = 'TarskiyZoid401')
WHERE scheduleCellId = @scId AND ticketTime = '11:45:00';


SET @scId = (SELECT id FROM schedule_cell AS sc JOIN time_cell tc ON sc.id = tc.scheduleCellId
          WHERE date = '2020-01-25'
            AND ticketTime = '13:30:00'
            AND doctorId = (SELECT id FROM user JOIN doctor d ON user.id = d.userId WHERE login = 'FeDOSEEVAMeldra296'));

UPDATE time_cell SET patientId = (SELECT id FROM user JOIN patient p ON user.id = p.userId WHERE login = 'TarskiyZoid401')
WHERE scheduleCellId = @scId AND ticketTime = '13:30:00';


SET @scId = (SELECT id FROM schedule_cell AS sc JOIN time_cell tc ON sc.id = tc.scheduleCellId
          WHERE date = '2020-01-23'
            AND ticketTime = '11:30:00'
            AND doctorId = (SELECT id FROM user JOIN doctor d ON user.id = d.userId WHERE login = 'ZvezdnyiyAakesh182'));

UPDATE time_cell SET patientId = (SELECT id FROM user JOIN patient p ON user.id = p.userId WHERE login = 'Fedoseev')
WHERE scheduleCellId = @scId AND ticketTime = '11:30:00';