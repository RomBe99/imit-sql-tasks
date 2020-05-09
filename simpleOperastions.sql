USE hospitalTest;

# Выборка с помощью CASE

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

# Выборка с использованием с использованием ключевых слов

SELECT * FROM user
WHERE patronymic IS NULL;

SELECT * FROM user
WHERE password NOT IN ('CqjJHHZRd4ao', 'admin');

SELECT * FROM user
WHERE LOWER(login) LIKE 'fedoseev%';

SELECT * FROM user
WHERE EXISTS(SELECT * FROM user WHERE id = 9000);

SELECT * FROM time_cell
WHERE duration BETWEEN 30 AND 60;

# Выборка с помощью order by, asc, desc

SELECT * FROM user
ORDER BY lastName ASC, login DESC;

# Агрегатные SQL-функции

SELECT COUNT(*) FROM time_cell WHERE duration > 60;

SELECT MAX(duration) FROM time_cell;

SELECT MIN(duration) FROM time_cell;

SELECT AVG(duration) FROM time_cell;

SELECT SUM(duration) FROM time_cell;

# Агрегирование баз данных с помощью фраз group by и having

SELECT name, COUNT(*) AS doctors_count
FROM doctor
JOIN doctor_specialty ds on doctor.specialtyId = ds.id
GROUP BY name
HAVING doctors_count > 1;