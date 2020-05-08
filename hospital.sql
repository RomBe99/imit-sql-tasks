DROP DATABASE IF EXISTS hospitalTest;
CREATE DATABASE hospitalTest;
USE hospitalTest;

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
    KEY patronymic (patronymic)
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
    FOREIGN KEY (cabinetId) REFERENCES cabinet (id) ON DELETE SET NULL,
    KEY specialtyName (specialtyId),
    KEY cabinetId (cabinetId)
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

CREATE TABLE schedule_cell
(
    id       INT  NOT NULL AUTO_INCREMENT,
    doctorId INT  NOT NULL,
    date     DATE NOT NULL,

    PRIMARY KEY (id),
    UNIQUE KEY (date),
    FOREIGN KEY (doctorId) REFERENCES doctor (userId) ON DELETE CASCADE,
    KEY doctorId (doctorId)
) ENGINE = INNODB
  DEFAULT CHARSET = utf8;

CREATE TABLE time_cell
(
    ticketTime     TIME NOT NULL,
    scheduleCellId INT  NOT NULL,
    patientId      INT DEFAULT NULL,
    duration       INT  NOT NULL,

    PRIMARY KEY (ticketTime),
    FOREIGN KEY (scheduleCellId) REFERENCES schedule_cell (id) ON DELETE CASCADE,
    FOREIGN KEY (patientId) REFERENCES patient (userId) ON DELETE SET NULL
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
VALUES (0, 'ZvezdnyiyAakesh182', 'CqjJHHZRd4ao', 'Звездный', 'Аакеш', NULL);
INSERT INTO doctor
VALUES (last_insert_id(),
        (SELECT id FROM doctor_specialty WHERE name = 'Traumatologist'),
        (SELECT id FROM cabinet WHERE name = '205'));

INSERT INTO user
VALUES (0, 'FedoseevaMeldra296', 'CqjJHHZRd4ao', 'Федосеева', 'Мелдра', 'Геннадиевна');
INSERT INTO doctor
VALUES (last_insert_id(),
        (SELECT id FROM doctor_specialty WHERE name = 'Surgeon'),
        (SELECT id FROM cabinet WHERE name = '306'));

INSERT INTO user
VALUES (0, 'Fedoseeva228', 'e0Dp4LCkx3ye', 'Федосеева', 'Анулик', 'Геннадиевна');
INSERT INTO doctor
VALUES (last_insert_id(),
        (SELECT id FROM doctor_specialty WHERE name = 'Surgeon'),
        (SELECT id FROM cabinet WHERE name = '407'));

# Insert patients

INSERT INTO user
VALUES (0, 'Fedoseev', 'e0Dp4LCkx3ye', 'Федосеев', 'Алик', NULL);
INSERT INTO patient
VALUES (last_insert_id(), 'disotoh476@box4mls.com', '404510, г. Шербакуль, ул. Взлетная  (Московский), дом 63, квартира 60', '79555367518');

INSERT INTO user
VALUES (0, 'TarskiyZoid401', 'xck26nN9GZ5P', 'Тарский', 'Зоид', 'Викторович');
INSERT INTO patient
VALUES (last_insert_id(), 'kegetob726@jupiterm.com', '665385, г. Ртищево, ул. Дорожная, дом 15, квартира 337', '79338786879');