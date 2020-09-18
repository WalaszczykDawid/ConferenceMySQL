DROP DATABASE lab4;
CREATE DATABASE lab4;
USE lab4;

CREATE TABLE participants (
    participant_id INT AUTO_INCREMENT PRIMARY KEY NOT NULL,
    name VARCHAR(100) NOT NULL,
    surname VARCHAR(100) NOT NULL,
    title VARCHAR(100),
    telephone INT NOT NULL,
    email VARCHAR(100) NOT NULL
);

DELIMITER $$

CREATE TRIGGER email_check
    BEFORE INSERT ON participants FOR EACH ROW
    BEGIN
        IF NEW.email NOT LIKE '%@%'
        THEN
            SIGNAL SQLSTATE '45000'
                SET MESSAGE_TEXT = 'Email adress is incorect.';
        END IF;
    END;
$$

DELIMITER ;


INSERT INTO participants(name, surname, title, telephone, email) VALUES 
    ('Mateusz', 'Stachniak', 'Magister Inzynier', 501600500, 'm.stachniak@yahoo.com' ),
    ('Anna', 'Zawadzka', 'Profesor', 852663409, 'zawadzka@ug.edu.pl'),
    ('Pawel', 'Pawlak', 'Doktor Habilitowany', 600400528, 'doktorpawlak@gmail.com'),
    ('Marcin', 'Stachura', 'Magister', 708405602, 'stachura@yahoo.com'),
    ('Darek','Sawici','Inzynier', 805630605, 'praca@pg.edu.pl'),
    ('Kamil','Zaslona','Magister', 805602740, 'zaslona@pg.edu.pl'),
    ('Piotr','Olejnik','Doktor', 500200740, 'olejnik.piotr@pg.edu.pl'),
    ('Ambrozy','Zatruski','Inzynier', 896524178, 'uczelnia@pg.edu.pl'),
    ('Janusz', 'Kowalewski', NULL, 900600500, 'student@gmail.com');

CREATE TABLE universities (
    university_id INT AUTO_INCREMENT PRIMARY KEY NOT NULL,
    university_name VARCHAR(100) NOT NULL,    
    university_street VARCHAR (50) NOT NULL,
    university_city VARCHAR (50) NOT NULL,
    university_code VARCHAR (10) NOT NULL,
    university_country VARCHAR (50) NOT NULL
);

INSERT INTO universities ( university_name, university_street, university_code, university_city, university_country) VALUES
('Uniwersytet Gdanski', 'Jana Bazynskiego 6', '80-840', 'Gdansk', 'Poland'),
('Politechnika Gdanska', 'Gabriela Narutowicza 11/12', '80-233', 'Gdansk', 'Poland'),
('Universitat de Barcelona', 'Gran Via de les Corts Catalanes 585', '08007', 'Barcelona', 'Spain'),
('University of Cambridge', 'The Old Schools, Trinity Ln.', 'CB2 1TN','Cambridge', 'Great Britain'),
('University College London', 'Gower St, Bloomsbury', 'WC1E 6BT','London','Great Britain');

CREATE TABLE departments(
    department_id INT AUTO_INCREMENT PRIMARY KEY NOT NULL,
    department_name VARCHAR(100) NOT NULL
);

INSERT INTO departments(department_name) VALUES
('Medical department'),
('Mathematic department'),
('Chemistry department'),
('Politology department'),
('Law Institute'),
('Sociology Institute'),
('IT department'),
('Mechanical department'),
('History department'),
('Criminology department'),
('Faculty of Art'),
('Faculty of Engineering Sciences');


CREATE TABLE participant_university(
    participant_university_id INT AUTO_INCREMENT PRIMARY KEY NOT NULL,
    participant_id INT NOT NULL,
    university_id INT NOT NULL,
    department_id INT NOT NULL,
    FOREIGN KEY(participant_id) REFERENCES participants(participant_id) ON DELETE CASCADE,
    FOREIGN KEY(university_id) REFERENCES universities(university_id) ON DELETE CASCADE,
    FOREIGN KEY(department_id) REFERENCES departments(department_id) ON DELETE CASCADE
);

INSERT INTO participant_university(participant_id, university_id, department_id) VALUES
    (1,1,12),
    (4,1,6),
    (8,2,4),
    (5,3,2),
    (2,3,10),
    (7,2,11),
    (6,4,7),
    (6,5,9),
    (8,5,4),
    (3,5,1),
    (5,4,5),
    (7,2,2),
    (6,4,8),
    (6,5,3),
    (8,5,3),
    (3,5,6),
    (5,4,12);


CREATE TABLE conference_dates(
    date_id INT AUTO_INCREMENT PRIMARY KEY NOT NULL,
    conference_date DATE NOT NULL
);

INSERT INTO conference_dates(conference_date) VALUES
    ('2020-06-01'),
    ('2020-06-02'),
    ('2020-06-03'),
    ('2020-06-04'),
    ('2020-06-05');
    

CREATE TABLE thesis(
    thesis_id INT AUTO_INCREMENT PRIMARY KEY NOT NULL,
    participant_id INT NOT NULL,
    thesis_title VARCHAR(200) NOT NULL,
    summary CHAR(1) NOT NULL,
    conference_date_id INT NOT NULL,
    FOREIGN KEY(participant_id) REFERENCES participants(participant_id) ON DELETE CASCADE,
    FOREIGN KEY(conference_date_id) REFERENCES conference_dates(date_id) ON DELETE CASCADE
);

DELIMITER $$

CREATE TRIGGER summary_check_y_or_n
    BEFORE INSERT ON thesis FOR EACH ROW
    BEGIN
        IF NEW.summary != 'Y' AND NEW.summary != 'N'
        THEN
            SIGNAL SQLSTATE '45000'
                    SET MESSAGE_TEXT = 'Choose Y(es) or N(o).';
        END IF;
    END;
$$

DELIMITER ;

INSERT INTO thesis (participant_id, thesis_title, summary, conference_date_id) VALUES
    (1, 'Helth and medicine: acos', 'Y', 1),
    (2, 'Nuclear medicine health', 'Y', 1),
    (3, 'Risk management', 'Y', 1),
    (4, 'IT: internet and aircraft', 'N', 1),
    (5, 'Technical, human and conceptual skills', 'N', 2),
    (6, 'English 313 technical writing projects', 'Y', 2),
    (7, 'Technical edge in the global marketplace', 'N', 2),
    (8, 'Art work in the mechnical age', 'Y', 3),
    (1, 'Mechanical autnomy', 'N', 3),
    (2, 'Quantum physics and consciousness', 'N', 3),
    (5, 'Radiography and tomography in medicine', 'Y', 4),
    (6, 'Electricy and magnetism reshape transportation', 'N', 4),
    (3, 'Nuclear waste', 'Y', 4),
    (4, 'Climatic change and nuclear energy', 'N', 5),
    (7, 'Modern dance bs. ballroom dance', 'N', 5),
    (8, 'Mergers and IT applications', 'N', 5);

    
CREATE TABLE meals (
    meal_id INT AUTO_INCREMENT PRIMARY KEY NOT NULL,
    participant_id INT NOT NULL,
    date_id INT NOT NULL,
    FOREIGN KEY(participant_id) REFERENCES participants(participant_id) ON DELETE CASCADE,
    FOREIGN KEY(date_id) REFERENCES conference_dates(date_id)
);

INSERT INTO meals(participant_id,date_id) VALUES
    (1,1),(1,2),(1,3),(1,4),
    (2,1),(2,2),(2,3),
    (3,1),(3,2),(3,3),(3,4),(3,5),
    (4,1),(4,2),
    (5,5),
    (6,1),(6,2),(6,3),(6,4),(6,5),
    (7,1),(7,2),
    (8,1),(8,2),(8,3),(8,4),(8,5);


CREATE TABLE hotel_rooms (
    room_id INT AUTO_INCREMENT PRIMARY KEY NOT NULL,
    room_type VARCHAR (6) NOT NULL
);

/* DELIMITER $$

CREATE TRIGGER hotel_room_max
    BEFORE INSERT ON hotel_rooms FOR EACH ROW
    BEGIN
        IF NEW.number_of_beds > 2
        THEN
            SIGNAL SQLSTATE '45000'
                    SET MESSAGE_TEXT = 'There could be only 2 beds in per room.';
        END IF;
    END;
$$

DELIMITER ; */

INSERT INTO hotel_rooms (room_type) VALUES 
    ('singe'),('double'),('single'),('double'),('single'),('single');

CREATE TABLE accommodations (
    accommodation_id INT AUTO_INCREMENT PRIMARY KEY NOT NULL,
    participant_id INT NOT NULL,
    date_id INT NOT NULL,
    room_id INT NOT NULL,
    FOREIGN KEY(participant_id) REFERENCES participants(participant_id),
    FOREIGN KEY(date_id) REFERENCES conference_dates(date_id),
    FOREIGN KEY(room_id) REFERENCES hotel_rooms(room_id)
);

INSERT INTO accommodations(participant_id, date_id, room_id) VALUES 
    (1, 1, 1),(1, 3, 1),(1, 4, 1),(1, 5, 1),
    (2, 1, 2),(2, 2, 2),(2, 3, 2),(2, 4, 2),(2, 5, 2),
    (3, 1, 2),(3, 5, 2),
    (4, 3, 3),(4, 4, 3),
    (5, 2, 3),(5, 3, 3),(5, 4, 3),
    (6, 1, 4),(6, 3, 4),(6, 5, 4),
    (7, 1, 5),(7, 2, 5),
    (8, 4, 6),(8, 3, 6);


SHOW TABLES;


DELIMITER $$

CREATE PROCEDURE p1(IN name VARCHAR(100), IN surname VARCHAR(100))        /* in/out/inout powinien byc podawany */
    BEGIN
        DECLARE total_cost INT;
        
        DECLARE meal_cost INT;
        DECLARE accommodation_cost_single INT;
        DECLARE accommodation_cost_double INT;
        DECLARE conference_fee_null INT;
        DECLARE conference_fee_plus INT;
        
        SET meal_cost = 20;
        SET accommodation_cost_single = 200;
        SET accommodation_cost_double = 150;
        SET conference_fee_null = 500;
        SET conference_fee_plus = 800;



    SELECT name,
           surname,
           (COUNT(*) * meal_cost) AS 'Costs of meals:',                
           IF
               
           

    FROM participants
        JOIN meals
            ON participants.participant_id=meals.participant_id
    
    GROUP BY name;





    END;
$$

DELIMITER ;

CALL p1('Ambrozy','Zatruski');

SELECT  name,
        surname,
        accommodations.room_id,
        room_type,
        CASE
            WHEN room_type LIKE 'single' THEN COUNT()
            ELSE 'podwojny'
        END AS 'Pokoik ten'
        
        
FROM participants

INNER JOIN accommodations
    ON participants.participant_id = accommodations.participant_id
    
INNER JOIN hotel_rooms
    ON accommodations.room_id = hotel_rooms.room_id
    
GROUP BY name;

