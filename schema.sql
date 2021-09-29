DROP TABLE IF EXISTS Athlete;
DROP TABLE IF EXISTS Person;

CREATE TABLE Person (
	pid INTEGER,
	first_name varchar(10) NOT NULL,
	middle_name varchar(10),
	last_name varchar(10) NOT NULL,
	date_birth varchar(10) NOT NULL,
	gender varchar(1) NOT NULL,
	home_country varchar(35) NOT NULL,
	email varchar(20),
	PRIMARY KEY (pid)
);

CREATE TABLE Athlete (
	player_id INTEGER,
	weight DECIMAL(5,2),
	birth_country varchar(35) NOT NULL,
	
	PRIMARY KEY (player_id),
	FOREIGN KEY (player_id) REFERENCES Person(pid)
);

INSERT INTO Person VALUES (20240001, 'John', '', 'Smith', '2000-01-01', 'M', 'Australia');
INSERT INTO Person VALUES (20240002, 'Sally', 'Junior', 'Waters', '1997-02-01', 'M', 'Australia');
INSERT INTO Person VALUES (20240003, 'Sally', 'Senior', 'Waters', '1977-05-01', 'M', 'Australia');
INSERT INTO Person VALUES (20240004, 'Pauline', '', 'Winters', '1995-06-01', 'M', 'Australia');
INSERT INTO Person VALUES (20240005, 'Matthew', '', 'Long', '1990-03-01', 'M', 'United States of America');
INSERT INTO Person VALUES (20240006, 'Ming', '', 'Yao', '1980-09-02', 'M', 'People s Republic of China');
INSERT INTO Person VALUES (20240008, 'XIMENES', 'BELO', 'Imelda', '1998-10-24', 'F', 'Democratic Republic of Timor-Leste');

INSERT INTO Athlete VALUES (20240001, 80.00, 'People s Republic of China');
INSERT INTO Athlete VALUES (20240002, 80.00, 'Australia');
INSERT INTO Athlete VALUES (20240003, 75.00, 'Australia');
INSERT INTO Athlete VALUES (20240004, 80.00, 'United States of America');
INSERT INTO Athlete VALUES (20240005, 100.00, 'People s Republic of China');
INSERT INTO Athlete VALUES (20240008, 45, 'Democratic Republic of Timor-Leste')

