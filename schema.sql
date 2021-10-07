DROP TABLE IF EXISTS Athlete CASCADE;
DROP TABLE IF EXISTS Person CASCADE;
DROP TABLE IF EXISTS National_team CASCADE;
DROP TABLE IF EXISTS Team_contains;
DROP TABLE IF EXISTS Participates;
DROP TABLE IF EXISTS Sport_event CASCADE;
DROP TABLE IF EXISTS Location CASCADE;
DROP TABLE IF EXISTS Venue;
DROP TABLE IF EXISTS Accommodation;
--DROP TABLE IF EXISTS LivesIn;
DROP TABLE IF EXISTS Officials;
DROP TABLE IF EXISTS Information CASCADE;
DROP TABLE IF EXISTS Result CASCADE;
DROP TABLE IF EXISTS Records;
DROP TABLE IF EXISTS Info_contains;
DROP TABLE IF EXISTS Journeys CASCADE;
DROP TABLE IF EXISTS Vehicles CASCADE;
DROP TABLE IF EXISTS Scheduled;

CREATE TABLE Location(
	location_id INTEGER PRIMARY KEY,
	location_name varchar(10) NOT NULL,
	specific_address varchar(30) NOT NULL,
	suburb varchar(15) NOT NULL,
	latitude varchar(12) NOT NULL, 
	longtitude varchar(12) NOT NULL,
	
	CHECK (latitude LIKE ('%S')),
	CHECK (longtitude LIKE ('%E'))
);

INSERT INTO Location VALUES (001, 'location1', '1 bay st.', 'North Lakes', '27.2200° S', '153.0054° E');
INSERT INTO Location VALUES (002, 'location2', '55 Geroge st.', 'Chermside', '27.3858° S', '153.0310° E');
INSERT INTO Location VALUES (003, 'location3', '100 Huntingwood Rd.', 'Sunnybank', '27.5793° S', '153.0627° E');
INSERT INTO Location VALUES (004, 'location4', '78 Perrivllie Cres.', 'Browns Plains', '27.6624° S', '153.0528° E');
INSERT INTO Location VALUES (005, 'Venue 1', '1 front st.', 'North Lakes', '27.2200° S', '153.0054° E');
INSERT INTO Location VALUES (006, 'Venue 2', '1 Yorkville st.', 'Chermside', '27.3858° S', '153.0310° E');
INSERT INTO Location VALUES (007, 'Venue 3', '29 balmuto st.', 'Sunnybank', '27.5793° S', '153.0627° E');

CREATE TABLE Accommodation (
	acc_id INTEGER PRIMARY KEY,
	accm_name varchar(10) NOT NULL,
	location_id INTEGER NOT NULL,
	build_date DATE NOT NULL,
	build_cost decimal(15,2) NOT NULL,
	
	FOREIGN KEY (location_id) REFERENCES Location ON DELETE CASCADE,
	CHECK (build_cost > 0),
	CHECK (build_date < '2020-01-01')
);

INSERT INTO Accommodation VALUES (101, 'acc01', 001, '2005-06-07', '10000000.00');
INSERT INTO Accommodation VALUES (201, 'acc02', 002, '2015-10-07', '50000000.00');
INSERT INTO Accommodation VALUES (301, 'acc03', 003, '2015-01-07', '50000000.00');
INSERT INTO Accommodation VALUES (401, 'acc04', 004, '2008-08-07', '30000000.00');


CREATE TABLE Person (
	pid INTEGER PRIMARY KEY,
	name varchar(30) NOT NULL,
	date_birth DATE NOT NULL,
	gender varchar(1) NOT NULL,
	home_country varchar(35) NOT NULL,
	email varchar(20) NOT NULL,
	
	check (gender IN ('F', 'M')),
	check (email LIKE ('%@%.%'))
);

INSERT INTO Person VALUES (20240001, 'Ning Lee', '2000-01-01', 'M', 'People s Republic of China', '123@gmail.com');
INSERT INTO Person VALUES (20240002, 'Sally Junior Waters', '1997-02-01', 'M', 'Australia', '456@gmail.com');
INSERT INTO Person VALUES (20240003, 'Sally Senior Waters', '1977-05-01', 'M', 'Australia', '789@gmail.com');
INSERT INTO Person VALUES (20240004, 'Pauline Winters', '1995-06-01', 'M', 'United States of America', '101@gmail.com');
INSERT INTO Person VALUES (20240005, 'Matthew Long', '1990-03-01', 'M', 'United States of America', '123@outlook.com');
INSERT INTO Person VALUES (20240006, 'Ming Yao', '1980-09-02', 'M', 'People s Republic of China', '123@qq.com');
INSERT INTO Person VALUES (20240007, 'AWJULA BELO Imelda', '2001-07-24', 'M', 'Democratic Republic of Timor-Leste', '1102@qq.com');
INSERT INTO Person VALUES (20240008, 'XIMENES BELO Imelda', '1998-10-24', 'F', 'Democratic Republic of Timor-Leste', '456@qq.com');
INSERT INTO Person VALUES (20240009, 'Taylor Ashley', '1998-10-24', 'F', 'Canada', '475@cic.org');


CREATE TABLE Athlete (
	player_id INTEGER PRIMARY KEY,
	weight DECIMAL(5,2) NOT NULL,
	birth_country varchar(35) NOT NULL,
	acc_id INTEGER NOT NULL,
	
	FOREIGN KEY (player_id) REFERENCES Person(pid) ON DELETE CASCADE,
	FOREIGN KEY (acc_id) REFERENCES Accommodation(acc_id),
	CHECK (weight > 0)
);

INSERT INTO Athlete VALUES (20240001, 80.00, 'People s Republic of China', 101);
INSERT INTO Athlete VALUES (20240002, 80.00, 'Australia', 201);
INSERT INTO Athlete VALUES (20240003, 75.00, 'Australia', 201);
INSERT INTO Athlete VALUES (20240004, 80.00, 'United States of America', 301);
INSERT INTO Athlete VALUES (20240005, 90.00, 'United States of America', 301);
INSERT INTO Athlete VALUES (20240006, 100.00, 'People s Republic of China', 101);
INSERT INTO Athlete VALUES (20240007, 65.00, 'Democratic Republic of Timor-Leste', 401);
INSERT INTO Athlete VALUES (20240008, 45, 'Democratic Republic of Timor-Leste', 401);
INSERT INTO Athlete VALUES (20240009, 48.00, 'Canada', 301);


CREATE TABLE National_team (		--
	team_id	INTEGER PRIMARY KEY,
	country	varchar(35)	NOT NULL,
	number_of_players INTEGER NOT NULL,
	
	check (number_of_players > 0)
);

INSERT INTO National_team VALUES (2401, 'CHN', 2);
INSERT INTO National_team VALUES (2402, 'AUS', 2);
INSERT INTO National_team VALUES (2403, 'USA', 2);

CREATE TABLE Sport_event (
	event_id INTEGER PRIMARY KEY,
	event_date DATE NOT NULL,
	event_time TIME(0) NOT NULL,
	event_name varchar(30) NOT NULL,
	event_stage varchar(10) NOT NULL,
	
	CHECK (event_stage IN ('GROUPS', 'QUARTER-FINALS', 'SEMI-FINALS', 'FINALS'))
);

INSERT INTO Sport_event VALUES (9010, '2024-08-10', '9:00', 'Mens 100m', 'GROUPS');
INSERT INTO Sport_event VALUES (9011, '2024-08-10', '10:00', 'Womens 100m Air Rifle', 'FINALS');
INSERT INTO Sport_event VALUES (9001, '2024-08-10', '18:00', 'Mens double diving', 'GROUPS');
INSERT INTO Sport_event VALUES (9002, '2024-08-11', '18:00', 'Mens double diving', 'FINALS');

CREATE TABLE Team_contains (
	player_id INTEGER,
	team_id INTEGER,		--这个relation table 还需要别的attributes吗
	sport_event varchar(30) NOT NULL,
	
	PRIMARY KEY (player_id, team_id),
	FOREIGN KEY (player_id) REFERENCES Athlete ON DELETE CASCADE,
	FOREIGN KEY (team_id) REFERENCES National_team ON DELETE CASCADE
);

INSERT INTO Team_contains VALUES (20240001, 2401, 'Mens double diving');
INSERT INTO Team_contains VALUES (20240006, 2401, 'Mens double diving');
INSERT INTO Team_contains VALUES (20240002, 2402, 'Mens double diving');
INSERT INTO Team_contains VALUES (20240003, 2402, 'Mens double diving');
INSERT INTO Team_contains VALUES (20240004, 2403, 'Mens double diving');
INSERT INTO Team_contains VALUES (20240005, 2403, 'Mens double diving');

CREATE TABLE Participates (
	participant_id INTEGER,
	event_id INTEGER,
	
	PRIMARY KEY (participant_id, event_id),
	FOREIGN KEY (event_id) REFERENCES Sport_event(event_id) ON DELETE CASCADE
);

INSERT INTO Participates VALUES (20240007, 9010);
INSERT INTO Participates VALUES (20240001, 9010);
INSERT INTO Participates VALUES (20240002, 9010);
INSERT INTO Participates VALUES (2401, 9001);
INSERT INTO Participates VALUES (2402, 9001);
INSERT INTO Participates VALUES (2403, 9001);


CREATE TABLE Venue (
	venue_id varchar(10),
	--event_time TIME(0),	我不是很理解这个event——time记录的是什么
	build_cost decimal(10,2) NOT NULL,
	build_date DATE NOT NULL,
	location_id INTEGER NOT NULL,
	
	PRIMARY KEY (venue_id),
	FOREIGN KEY (location_id) REFERENCES Location,
	CHECK (build_cost > 0),
	CHECK (build_date < '2020-01-01')
);

INSERT INTO Venue VALUES (105, '1000000.00', '2010-09-04', 005);
INSERT INTO Venue VALUES (205, '3000000.00', '2015-07-22', 006);
INSERT INTO Venue VALUES (305, '5000000.00', '2010-11-14', 007);

--CREATE TABLE LivesIn (
--	pid INTEGER,			--这里选用person 还是？
--	acc_id INTEGER,
	
--	PRIMARY KEY (pid, acc_id),
--	FOREIGN KEY (pid) REFERENCES Person,
--	FOREIGN KEY (acc_id) REFERENCES Accommodation
--);

CREATE TABLE Officials (		-- 还未完成
	official_id INTEGER,
	
	PRIMARY KEY (official_id)
);

CREATE TABLE Information (
	info_id INTEGER,
	event_name varchar(10) NOT NULL,
	
	PRIMARY KEY (info_id)
);

CREATE TABLE Result (					--- IS-A relation 未完成，会不会有更好的表达形式来描述时间或者分数
	result_id INTEGER,					-- 这个 result——details 这里记录什么信息
	result_details varchar(30) NOT NULL,
	
	PRIMARY KEY (result_id)
);

CREATE TABLE Records (
	event_id INTEGER,
	info_id INTEGER,
	
	PRIMARY KEY (event_id, info_id),
	FOREIGN KEY (event_id) REFERENCES Sport_event,
	FOREIGN KEY (info_id) REFERENCES Information
);

CREATE TABLE Info_contains (
	info_id INTEGER,
	result_id INTEGER,
	
	PRIMARY KEY (info_id, result_id),
	FOREIGN KEY (info_id) REFERENCES Information,
	FOREIGN KEY (result_id) REFERENCES Result
);

CREATE TABLE Journeys (
	booking_id INTEGER,
	car_id INTEGER,			--我觉得不应该放在这里 思考
	location_id INTEGER NOT NULL,	
	booking_date DATE NOT NULL,	--这里需要加上date吗 还是需要放在start 和 arrival 里
	start_time TIME(0) NOT NULL,
	arrival_time TIME (0) NOT NULL,
	start_location INTEGER NOT NULL,
	destination INTEGER NOT NULL,
	
	PRIMARY KEY (booking_id),
	FOREIGN KEY (location_id) REFERENCES Location
);


CREATE TABLE Vehicles (
	ve_code INTEGER,
	kind varchar(10) NOT NULL,
	capacity INTEGER,
	
	PRIMARY KEY (ve_code)
);

CREATE TABLE Scheduled (
	booking_id INTEGER,
	ve_code INTEGER,
	
	PRIMARY KEY (booking_id, ve_code),
	FOREIGN KEY (booking_id) REFERENCES Journeys,
	FOREIGN KEY (ve_code) REFERENCES vehicles
);

















