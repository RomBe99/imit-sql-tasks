USE hospitalTest;

# Реализация intersect (пересечение).

# Выборка данных всех пользователей из таблицы user которые ЯВЛЯЮТСЯ пациентами.

SELECT * FROM user
WHERE id IN (SELECT userId FROM patient);

# Реализация except (разность).

# Выборка данных всех пользователей из таблицы user которые НЕ ЯВЛЯЮТСЯ врачами.

SELECT * FROM user
WHERE id NOT IN (SELECT userId FROM doctor);

# Union (объединение).

# Выборка расписания путём объединения по таблице doctor.

SELECT * FROM schedule_cell UNION SELECT * FROM doctor;

# Объединение без join.

SELECT * FROM user, doctor, schedule_cell, time_cell;

# Выборка данных о врачах из таблицы user и получение полного расписания.

SELECT * FROM user, doctor, schedule_cell, time_cell
WHERE userId = user.id AND userId = schedule_cell.doctorId AND time_cell.scheduleCellId = schedule_cell.id;

# Получение данных о докторах, их приёмах и пациентах записанных на эти приёмы.
# Различия inner join и outer join:
# Inner Join объединяет строки из дух таблиц при соответствии условию.
# Если одна из таблиц содержит строки, которые не соответствуют этому условию, то данные строки не включаются в выходную выборку.
# Left Join выбирает все строки первой таблицы и затем присоединяет к ним строки правой таблицы.
#
# В приведённом ниже запросе есть несколько "деликатных" моментов:
# Во-первых, у врача может быть не назначен кабинет, в таком случае inner join не включит его в выборку, что недопустимо для данного запроса.
# Во-вторых, врач заболел и его расписание на некоторое время попросту убрали. Inner join проигнорирует его, а это плохо.
# В-третьих, у врача всё хорошо, а у пациентов и подавно, они не болеют и им попросту не нужны талоны. Опять возникла та же ситуация что и в пунктах выше.

SELECT user.id AS doctorId,
  login,
  password,
  firstName,
  lastName,
  patronymic,
  ds.name    AS specialty,
  c.name     AS cabinet,
  sc.id      AS scheduleCellId,
  date,
  ticketTime AS time,
  duration,
  firstName  AS patientFirstName,
  lastName   AS patientLastName,
  patronymic AS patientPatronymic,
  email      AS patientEmail,
  address    AS patientAddress,
  phone      AS patientPhone
FROM user
  JOIN doctor d ON user.id = d.userId
  JOIN doctor_specialty ds ON d.specialtyId = ds.id
  LEFT JOIN cabinet c ON d.cabinetId = c.id
  LEFT JOIN schedule_cell sc ON d.userId = sc.doctorId
  JOIN time_cell tc ON sc.id = tc.scheduleCellId
  LEFT JOIN patient p ON tc.patientId = p.userId;

# Тета-соединение.
# Запрос надуманный, но хорошо отражает необходимую ситуацю.

SELECT * FROM user, doctor_specialty
WHERE login > name;

# CROSS JOIN формирует таблицу перекрестным соединением (декартовым произведением) двух таблиц.
# При использовании оператора SQL CROSS JOIN каждая строка левой таблицы сцепляется с каждой строкой правой таблицы.
# В результате получается таблица со всеми возможными сочетаниями строк обеих таблиц.

# Выборка данных о всех врачах.

SELECT user.id, login, password, firstName, lastName, patronymic, ds.name AS specialityName, c.name AS cabinetName FROM user
    CROSS JOIN doctor d ON user.id = d.userId
    CROSS JOIN doctor_specialty ds ON d.specialtyId = ds.id
    CROSS JOIN cabinet c ON d.cabinetId = c.id;

# Соединение таблицы с самой собой.
# Увы, MySql слишком умный и ситуацию описанную в учебнике не даёт воссоздать.
# Я даже создал точную копию таблицы, но это не помогло :(.

CREATE TABLE userTest (
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

INSERT INTO userTest (id, login, password, firstName, lastName, patronymic) SELECT * FROM user;

SELECT DISTINCT * FROM user
    JOIN userTest AS u ON user.id = u.id
    AND user.login = u.login
    AND user.password = u.password
    AND user.firstName = u.firstName
    AND user.lastName = u.lastName
    AND user.patronymic = u.patronymic;

DROP TABLE userTest;