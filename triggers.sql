USE hospitalTest;

# Создадим таблицу в которую будем логировать действия с помощью тирггеров.
# Безусловно, пример является надуманным, но для демонстрации работы триггеров отлично подойдёт.

DROP TABLE IF EXISTS hospital_log;

CREATE TABLE hospital_log
(
    id INT NOT NULL AUTO_INCREMENT,
    msg VARCHAR(255) NOT NULL,

    PRIMARY KEY (id)
) ENGINE = INNODB
  DEFAULT CHARSET = utf8;

# Немного о синтаксисе тирггеров:
# CREATE TRIGGER trigger_name trigger_time trigger_event ON tbl_name
#     FOR EACH ROW BEGIN
#         trigger_stmt
# END;
#
# trigger_name — название триггера.
# trigger_time — Время срабатывания триггера. BEFORE — перед событием. AFTER — после события..
# trigger_event — Событие:.
# insert — событие возбуждается операторами insert, data load, replace.
# update — событие возбуждается оператором update.
# delete — событие возбуждается операторами delete, replace. Операторы DROP TABLE и TRUNCATE не активируют выполнение триггера.
# tbl_name — название таблицы.
# trigger_stmt выражение, которое выполняется при активации триггера.

# Создадим тирггеры для логирования действий которые происходят с таблицей user.

# insert тирггеры

DELIMITER |
CREATE TRIGGER before_insert_hospital_db_log BEFORE INSERT ON user
    FOR EACH ROW BEGIN
    INSERT INTO hospital_log SET msg = 'Сейчас будет вставлен новый user';
END;
|

DELIMITER |
CREATE TRIGGER after_insert_hospital_db_log AFTER INSERT ON user
    FOR EACH ROW BEGIN
    INSERT INTO hospital_log SET msg = CONCAT('Новый user успешно вставлен с id = ', last_insert_id());
END;
|

# update тирггеры

DELIMITER |
CREATE TRIGGER before_update_hospital_db_log BEFORE UPDATE ON user
    FOR EACH ROW BEGIN
    INSERT INTO hospital_log SET msg = 'Сейчас будет обновлён user';
END;
|

DELIMITER |
CREATE TRIGGER after_update_hospital_db_log AFTER UPDATE ON user
    FOR EACH ROW BEGIN
    INSERT INTO hospital_log SET msg = 'user успешно обновлён';
END;
|

# delete тирггеры

DELIMITER |
CREATE TRIGGER before_delete_hospital_db_log BEFORE DELETE ON user
    FOR EACH ROW BEGIN
    INSERT INTO hospital_log SET msg = 'Сейчас будет удалён user';
END;
|

DELIMITER |
CREATE TRIGGER after_delete_hospital_db_log AFTER DELETE ON user
    FOR EACH ROW BEGIN
    INSERT INTO hospital_log SET msg = 'user успешно удалён';
END;
|

INSERT INTO user
VALUES (0, 'DidichenkoAbelina28', 'CqjJHHZRd4ao', 'Абелина', 'Дидиченко', 'Георгиевна');

UPDATE user SET password='tOHltzYJdvBs' WHERE login='DidichenkoAbelina28';

DELETE FROM user WHERE login='DidichenkoAbelina28';

# Посмотрим таблицу в которую логировали запросы выше.

SELECT * FROM hospital_log;