USE hospitalTest;

# Выборка с помощью CASE.

# Здесь по названию специальности врача опредляется id его специальности.
# Если id соответствует определённой специальности, то в колонку whoIsIt выводится соответствующее сообщение,
# также выводится полная информация о враче.

SELECT *,
CASE
    WHEN specialtyId = (SELECT id FROM doctor_specialty WHERE name = 'Dentist')
        THEN 'This is dentist'
    WHEN specialtyId = (SELECT id FROM doctor_specialty WHERE name = 'Surgeon')
        THEN 'This is surgeon'
    WHEN specialtyId = (SELECT id FROM doctor_specialty WHERE name = 'Therapist')
        THEN 'This is therapist'
    WHEN specialtyId = (SELECT id FROM doctor_specialty WHERE name = 'Traumatologist')
        THEN 'This is traumatologist'
END AS whoIsIt
FROM doctor;

# Выборка с использованием с использованием ключевых слов.

# Вывести данные всех пользователей у которых нет отчества.

SELECT * FROM user
WHERE patronymic IS NULL;

# Вывести данные всех пользовавателей у которых пароли != 'CqjJHHZRd4ao' или 'admin'.

SELECT * FROM user
WHERE password NOT IN ('CqjJHHZRd4ao', 'admin');

# Вывод данных пользователей у которых логин, переведённый в нижний регистр функцией LOWER, начинается со строки 'fedoseev'.

SELECT * FROM user
WHERE LOWER(login) LIKE 'fedoseev%';

# Вывод данных пользователей у которых id = 9000
# Оператор EXISTS проверяет, возвращает ли подзапрос какое-либо значение.
# Как правило, этот оператор используется для индикации того, что как минимум одна строка в таблице удовлетворяет некоторому условию.

SELECT * FROM user
WHERE EXISTS(SELECT * FROM user WHERE id = 9000);

# Вывод талонов длительеость приёма которых варьируется в диапозоне от 30 до 60 минут.

SELECT * FROM time_cell
WHERE duration BETWEEN 30 AND 60;

# Выборка с помощью order by, asc, desc.

# Вывод данных пользоватлей в лексикографическом порядке по возрастанию логина.

SELECT * FROM user
ORDER BY login ASC;

# Вывод данных пользоватлей в лексикографическом порядке по убыванию логина.

SELECT * FROM user
ORDER BY login DESC;

# Агрегатные SQL-функции.

# Вывод количества талонов на приём, продолжительность котороых больше 60.

SELECT COUNT(*) FROM time_cell WHERE duration > 60;

# Вывод максимальной продолжительности приёма.

SELECT MAX(duration) FROM time_cell;

# Вывод минимальной продолжительности приёма.

SELECT MIN(duration) FROM time_cell;

# Вывод средней продолжительности приёма.

SELECT AVG(duration) FROM time_cell;

# Вывод общего количества минут выделенного на приёмы.

SELECT SUM(duration) FROM time_cell;

# Агрегирование баз данных с помощью фраз group by и having.

# Подсчёт вывод специальности врачей количество которых по данной специальности > 2.

SELECT name, COUNT(*) AS doctors_count
FROM doctor
JOIN doctor_specialty ds on doctor.specialtyId = ds.id
GROUP BY name
HAVING doctors_count > 1;