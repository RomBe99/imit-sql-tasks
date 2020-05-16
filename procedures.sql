USE hospitalTest;

# Процедуры

# Вставка врача в базу данных (IN)

DELIMITER |
CREATE PROCEDURE insertDoctor(newLogin VARCHAR(30), pass VARCHAR(30),
                              fName  VARCHAR(30), lName VARCHAR(30), newPatronymic VARCHAR(30),
                              cabinetName VARCHAR(30), specialityName VARCHAR(30))
BEGIN
    INSERT INTO user
    SET login=newLogin, password=pass, firstName=fName, lastName=lName, patronymic=newPatronymic;

    SET @uId = last_insert_id();
    SET @cabId = (SELECT id FROM cabinet WHERE name=cabinetName);
    SET @specId = (SELECT id FROM doctor_specialty WHERE name=specialityName);

    INSERT INTO doctor
    SET userId=@uId, specialtyId=@specId, cabinetId=@cabId;
END;
|

CALL insertDoctor('ChaurinKazak16', 'VRBdDtwIFiab',
    'Joseph', 'Aidan', 'Price', '104', 'Therapist');

# Подсчёт средней продолжительности приёмов врачей

DELIMITER |
CREATE PROCEDURE calculateAverageDoctorVisit(OUT average INT)
BEGIN 
    SET average = (SELECT AVG(duration) FROM time_cell);
END;
|

SET @averageDuration = NULL;

CALL calculateAverageDoctorVisit(@averageDuration);

SELECT @averageDuration;

# Получение специальности доктора по его логину (INOUT)

DELIMITER |
CREATE PROCEDURE getDoctorSpeciality(INOUT login VARCHAR(30))
BEGIN
    SET login = (SELECT name FROM user u
                 JOIN doctor d ON u.id = d.userId
                 JOIN doctor_specialty ds ON d.specialtyId = ds.id
                 WHERE u.login = login);
END;
|

SET @result = 'ChaurinKazak16';

CALL getDoctorSpeciality(@result);

SELECT @result;