--INSERT INTO Person VALUES (20240009, 'XIMENES BELO Imelda', '1998-10-24', 'W', 'Democratic Republic of Timor-Leste', '456@qq.com');

DROP TABLE IF EXISTS Athlete;
DROP TABLE IF EXISTS Person;
DROP TABLE IF EXISTS National_team;
DROP TABLE IF EXISTS Team_contains;
DROP TABLE IF EXISTS Sport_event;
DROP TABLE IF EXISTS Location;
DROP TABLE IF EXISTS Venue;
DROP TABLE IF EXISTS Accomodation;
DROP TABLE IF EXISTS LivesIn;
DROP TABLE IF EXISTS Officials;
DROP TABLE IF EXISTS Information;
DROP TABLE IF EXISTS Result;
DROP TABLE IF EXISTS Records;
DROP TABLE IF EXISTS Info_contains;
DROP TABLE IF EXISTS Journeys;
DROP TABLE IF EXISTS Vehicles;
DROP TABLE IF EXISTS Scheduled;


CREATE TABLE Person (
	pid INTEGER PRIMARY KEY,
	name varchar(30) NOT NULL,
	date_birth DATE NOT NULL,
	gender varchar(1) NOT NULL,
	home_country varchar(35) NOT NULL,
	email varchar(20) NOT NULL,
	
	check (gender IN ('F', 'M'))
);

CREATE TABLE Athlete (
	player_id INTEGER PRIMARY KEY,
	weight DECIMAL(5,2),
	birth_country varchar(35) NOT NULL,
	
	FOREIGN KEY (player_id) REFERENCES Person(pid)
);

INSERT INTO Person VALUES (20240001, 'John Smith', '2000-01-01', 'M', 'Australia', '123@gmail.com');
INSERT INTO Person VALUES (20240002, 'Sally Junior Waters', '1997-02-01', 'M', 'Australia', '456@gmail.com');
INSERT INTO Person VALUES (20240003, 'Sally Senior Waters', '1977-05-01', 'M', 'Australia', '789@gmail.com');
INSERT INTO Person VALUES (20240004, 'Pauline Winters', '1995-06-01', 'M', 'Australia', '101@gmail.com');
INSERT INTO Person VALUES (20240005, 'Matthew Long', '1990-03-01', 'M', 'United States of America', '123@outlook.com');
INSERT INTO Person VALUES (20240006, 'Ming Yao', '1980-09-02', 'M', 'People s Republic of China', '123@qq.com');
INSERT INTO Person VALUES (20240008, 'XIMENES BELO Imelda', '1998-10-24', 'F', 'Democratic Republic of Timor-Leste', '456@qq.com');


INSERT INTO Athlete VALUES (20240001, 80.00, 'People s Republic of China');
INSERT INTO Athlete VALUES (20240002, 80.00, 'Australia');
INSERT INTO Athlete VALUES (20240003, 75.00, 'Australia');
INSERT INTO Athlete VALUES (20240004, 80.00, 'United States of America');
INSERT INTO Athlete VALUES (20240005, 100.00, 'People s Republic of China');
INSERT INTO Athlete VALUES (20240008, 45, 'Democratic Republic of Timor-Leste');

CREATE TABLE National_team (		--
	team_id	INTEGER PRIMARY KEY,
	country	varchar(35)	NOT NULL,
	number_of_players INTEGER NOT NULL,
	
	check (number_of_players > 0)
);

CREATE TABLE Team_contains (
	player_id INTEGER,
	team_id INTEGER,		--这个relation table 还需要别的attributes吗
	
	PRIMARY KEY (player_id, team_id),
	FOREIGN KEY (player_id) REFERENCES Athlete,
	FOREIGN KEY (team_id) REFERENCES National_team ON DELETE CASCADE
);

CREATE TABLE Sport_event (
	event_id INTEGER,
	event_time TIME(0) NOT NULL,
	event_name varchar(10) NOT NULL,
	
	PRIMARY KEY (event_id)
);

CREATE TABLE Location(
	location_id INTEGER,
	location_name varchar(10) NOT NULL,
	specific_address varchar(30) NOT NULL,
	suburb varchar(10) NOT NULL,
	latitude decimal(10, 6) NOT NULL, 	--如何记录经纬度
	longtitude decimal(10,6) NOT NULL,
	
	PRIMARY KEY (location_id)
);

CREATE TABLE Venue (
	venue_id varchar(10),
	--event_time TIME(0),	我不是很理解这个event——time记录的是什么
	build_cost decimal(10,2) NOT NULL,
	build_date DATE NOT NULL,
	location_id INTEGER NOT NULL,
	
	PRIMARY KEY (venue_id),
	FOREIGN KEY (location_id) REFERENCES Location
);

CREATE TABLE Accommodation (
	acc_id INTEGER,
	accm_name varchar(10) NOT NULL,
	location_id INTEGER,
	build_date DATE NOT NULL,
	build_cost decimal(10,2) NOT NULL,
	
	
	PRIMARY KEY (acc_id),
	FOREIGN KEY (location_id) REFERENCES Location
);

CREATE TABLE LivesIn (
	pid INTEGER,			--这里选用person 还是？
	acc_id INTEGER,
	
	PRIMARY KEY (pid, acc_id),
	FOREIGN KEY (pid) REFERENCES Person,
	FOREIGN KEY (acc_id) REFERENCES Accommodation
);

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

















