DROP TABLE IF EXISTS "Location" CASCADE;
DROP TABLE IF EXISTS Accommodation CASCADE;
DROP TABLE IF EXISTS Person CASCADE;
DROP TABLE IF EXISTS Athlete CASCADE;
DROP TABLE IF EXISTS National_team CASCADE;
DROP TABLE IF EXISTS Venue CASCADE;
DROP TABLE IF EXISTS Information CASCADE;
DROP TABLE IF EXISTS Sport_event CASCADE;
DROP TABLE IF EXISTS Participates CASCADE;
DROP TABLE IF EXISTS "Result" CASCADE;
DROP TABLE IF EXISTS Scorebased_results CASCADE;
DROP TABLE IF EXISTS Timebased_results CASCADE;
DROP TABLE IF EXISTS Officials CASCADE;
DROP TABLE IF EXISTS Evaluate CASCADE;
DROP TABLE IF EXISTS judge_performance CASCADE;
DROP TABLE IF EXISTS referee_games CASCADE;
DROP TABLE IF EXISTS awarding_mentals CASCADE;
DROP TABLE IF EXISTS Journeys CASCADE;
DROP TABLE IF EXISTS Vehicles CASCADE;
DROP TABLE IF EXISTS Scheduled CASCADE;
DROP TABLE IF EXISTS booking CASCADE;


-- This location table stores geographical information of different places
-- such as Accommodation and Venue. Information includes location_ids, names
-- address, lattitudes and longtitudes
CREATE TABLE "Location" (
	location_id INTEGER PRIMARY KEY,
	location_name VARCHAR(50) NOT NULL,
	specific_address VARCHAR(80) NOT NULL,
	suburb VARCHAR(30) NOT NULL,
	latitude VARCHAR(30) NOT NULL,
	longtitude VARCHAR(30) NOT NULL,

	CHECK (latitude LIKE ('%S')),
	CHECK (longtitude LIKE ('%E'))
);	
INSERT INTO "Location" VALUES (001, 'location1', '1 bay st.', 'North Lakes', '27.2200° S', '153.0054° E');
INSERT INTO "Location" VALUES (002, 'location2', '55 Geroge st.', 'Chermside', '27.3858° S', '153.0310° E');
INSERT INTO "Location" VALUES (003, 'location3', '100 Huntingwood Rd.', 'Sunnybank', '27.5793° S', '153.0627° E');
INSERT INTO "Location" VALUES (004, 'location4', '78 Perrivllie Cres.', 'Browns Plains', '27.6624° S', '153.0528° E');
INSERT INTO "Location" VALUES (005, 'Venue 1', '1 front st.', 'North Lakes', '27.2569° S', '153.0801° E');
INSERT INTO "Location" VALUES (006, 'VENUE 2', '1 YORKVILLE ST.', 'CHERMSIDE', '27.3858° S', '153.0310° E');
INSERT INTO "Location" VALUES (007, 'VENUE 3', '29 BALMUTO ST.', 'SUNNYBANK', '27.5793° S', '153.0627° E');

-- This Accommodation table stores specific information about each places where
-- where officials and atheletes lives in. INformation includes ids, names, locations
-- build data and build cost
CREATE TABLE Accommodation (
	acc_id INTEGER PRIMARY KEY,
	accm_name varchar(10) NOT NULL,
	location_id INTEGER,
	build_date DATE NOT NULL,
	build_cost decimal(15,2) NOT NULL,	

	FOREIGN KEY (location_id) REFERENCES "Location" (location_id) ON DELETE CASCADE,
	CHECK (build_cost > 0),
	CHECK (build_date < '2023-01-01')
);
INSERT INTO Accommodation VALUES (201, 'ACC02', 005, '2015-10-07', '50000000.00');
INSERT INTO Accommodation VALUES (301, 'ACC03', 006, '2015-01-07', '50000000.00');
INSERT INTO Accommodation VALUES (401, 'ACC04', 007, '2008-08-07', '30000000.00');

-- This Person table is a object interface stores details information of each 
-- individuals includes athelets and officials. Information includes ids, names,
-- DOBs, gender, home country and emails. 
CREATE TABLE Person (
	pid INTEGER PRIMARY KEY,
	p_name varchar(30) NOT NULL,
	date_birth DATE NOT NULL,
	gender varchar(8) NOT NULL,
	home_country varchar(35) NOT NULL,
	email varchar(30) NOT NULL,

	UNIQUE (email),
	CHECK (gender = 'M' OR gender ='F')
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

-- This athlete table stores data of every atheletes involved in the 2024 brisbane
-- Olympic Games. Information includes ids, weights, represented country and
-- accommodation. The country is the represented coutry of an athlete, which could be different 
-- from the home country.
CREATE TABLE Athlete ( 
	player_id INTEGER PRIMARY KEY, 
	"weight" DECIMAL(5,2) NOT NULL, 
	country VARCHAR(35) NOT NULL, 
	--acc_name VARCHAR(30),
	acc_id INTEGER NOT NULL, 

	FOREIGN KEY (player_id) REFERENCES PERSON(pid) ON DELETE CASCADE
);
INSERT INTO Athlete VALUES (20240001, 80.00, 'People s Republic of China', 101);
INSERT INTO Athlete VALUES (20240002, 80.00, 'Australia', 201);
INSERT INTO Athlete VALUES (20240003, 75.00, 'Australia', 201);
INSERT INTO Athlete VALUES (20240004, 80.00, 'United States of America', 301);
INSERT INTO Athlete VALUES (20240005, 90.00, 'United States of America', 301);
INSERT INTO Athlete VALUES (20240006, 100.00, 'People s Republic of China', 101);

-- This national team table stores data for those players who groups together to 
-- participate in the goup games. Information includes team ids, represented country
-- and number of players
CREATE TABLE National_team (
	team_id	INTEGER PRIMARY KEY,
	country	varchar(35)	NOT NULL,
	number_of_players INTEGER NOT NULL,

	CHECK (number_of_players > 0)
);
INSERT INTO National_team VALUES (2401, 'CHN', 2);
INSERT INTO National_team VALUES (2402, 'AUS', 2);
INSERT INTO National_team VALUES (2403, 'USA', 2);

-- where athelets participates games. Information includes ids, names, locations
-- build data and build cost
CREATE TABLE Venue (
 	venue_id INTEGER PRIMARY KEY,
 	venue_name VARCHAR(30) NOT NULL, 
 	build_cost DECIMAL(10,2) NOT NULL, 
 	build_date DATE NOT NULL,
 	location_id INTEGER NOT NULL,

	FOREIGN KEY (location_id) REFERENCES "Location" (location_id) ON DELETE CASCADE,
	CHECK (build_cost > 0),
	CHECK (build_date < '2020-01-01')
);	
INSERT INTO VENUE VALUES (105, 'stamples Arena', '1000000.00', '2010-09-04', 005); 
INSERT INTO VENUE VALUES (205, 'Works swimming center', '3000000.00', '2015-07-22', 006);
INSERT INTO VENUE VALUES (305, 'Rogers ground', '5000000.00', '2010-11-14', 007);

					--Information is used to recording the sprts event details
CREATE TABLE Information (
	info_id INTEGER PRIMARY KEY,
	event_name varchar(50) NOT NULL,
    info_details varchar(100)
);	
INSERT INTO Information VALUES (123,'WOMENS 100M AIR RI','noboday violation');	
INSERT INTO Information VALUES (456,'Mens double diving');
INSERT INTO Information VALUES (789,'Mens double diving');
		
-- This sport event table stores data about the 2024 Brisbane Olympic Game sport events
-- holds. Also, there might be different stage in a game. Stages might vary in GROUPS, 
-- Quarter finals, Semi-finals and finals. Information includes event ids, event datas
-- event times, event names and event stages
CREATE TABLE Sport_event (
	event_id INTEGER PRIMARY KEY,
	event_date DATE NOT NULL,
	event_time TIME NOT NULL,
	event_name varchar(35)	NOT NULL,
	event_stage varchar(35)	NOT NULL,
	venue_id INTEGER NOT NULL,
	info_id INTEGER NOT NULL,

	FOREIGN KEY (venue_id) REFERENCES Venue(venue_id) ON DELETE CASCADE,
	FOREIGN KEY (info_id) REFERENCES Information(info_id) ON DELETE CASCADE,
	CHECK (event_stage IN ('GROUPS', 'QUARTER-FINALS', 'SEMI-FINALS', 'FINALS'))
);	
INSERT INTO SPORT_EVENT VALUES (9011, '2024-08-10', '10:00', 'WOMENS 100M AIR RI', 'SEMI-FINALS',105 ,123); 
INSERT INTO SPORT_EVENT VALUES (9001, '2024-08-10', '18:00', 'Mens double diving', 'GROUPS',205, 456); 
INSERT INTO SPORT_EVENT VALUES (9002, '2024-08-11', '18:00', 'Mens double diving', 'FINALS',305, 789);

-- This participates relation table stores data about the detail about every participants
-- in the games. Information includes participants ids and event ids
CREATE TABLE Participates (
	event_id INTEGER NOT NULL,
	pid INTEGER NOT NULL,
	team_id INTEGER NOT NULL,
	par_date DATE,
	par_time TIME, 

	FOREIGN KEY (pid) REFERENCES Person(pid) ON DELETE CASCADE,
	FOREIGN KEY (team_id) REFERENCES National_team(team_id) ON DELETE CASCADE,
	PRIMARY KEY (event_id, pid, team_id)
);
INSERT INTO Participates VALUES (9001, 20240002, 2401, '2024-08-10', '18:00');
INSERT INTO Participates VALUES (9001, 20240003, 2401);
					
--Results table is superclass table which is used for recoding the final sports results	
 CREATE TABLE "Result" (					
	result_id INTEGER NOT NULL,					
	final_scores  DECIMAL(10,2) NOT NULL,
	"rank" INTEGER,
	info_id INTEGER NOT NULL,

	PRIMARY KEY (Info_id, result_id),
	CHECK ("rank" > 0),
	CHECK (final_scores BETWEEN 0 and 100)
);
INSERT INTO "Result" VALUES (123,98.99,1,123);
INSERT INTO "Result" VALUES (456,98.99,1,789);
		
--Scorebased_results table is subclass table of Results					
CREATE TABLE Scorebased_results (
	result_id INTEGER NOT NULL,
	info_id INTEGER NOT NULL,
	total_score decimal(10,2) NOT NULL,
	score_record decimal(5,2) NOT NULL,
	PRIMARY KEY (Info_id, result_id),

	CHECK (total_score BETWEEN 0 and 100),
	CHECK (score_record BETWEEN 0 and 100)
);
INSERT INTO Scorebased_results VALUES (123,789,90.20,45.00);
INSERT INTO Scorebased_results VALUES (456,156,90.20,45.00);	
		
--Timebased_results table is subclass table of Results
CREATE TABLE Timebased_results (
	result_id INTEGER NOT NULL,
	info_id INTEGER NOT NULL,
	total_score decimal(10,2),
	score_record decimal(5,2),	

	PRIMARY KEY (Info_id, result_id),
	CHECK (total_score > 0),
	CHECK (score_record > 0)
);
INSERT INTO Timebased_results VALUES (456,123,90.20,80.00);
INSERT INTO Timebased_results VALUES (456,789,90.20,70.00);

--officials tale is superclass which used to record officials performance
CREATE TABLE Officials (
	official_id INTEGER PRIMARY KEY,
	acc_id INTEGER NOT NULL,
	accm_name VARCHAR(20),	

    FOREIGN KEY (official_id) REFERENCES PERSON(pid) ON DELETE CASCADE,
	FOREIGN KEY (acc_id) REFERENCES Accommodation(acc_id)
);
INSERT INTO Officials VALUES (20240007, 401,'H-apt');
INSERT INTO Officials VALUES (20240008, 401,'H-apt');
INSERT INTO Officials VALUES (20240009, 301,'D-apt');		
					
--evaluate table is used for connect officials with information of sport events
CREATE TABLE Evaluate(
	official_id INTEGER NOT NULL,
	info_id INTEGER NOT NULL,
	offcials_duty VARCHAR(30),

	PRIMARY KEY (official_id,Info_id),
	FOREIGN KEY (official_id) REFERENCES PERSON(pid) ON DELETE CASCADE,
	FOREIGN KEY (info_id) REFERENCES Information(info_id)ON DELETE CASCADE
);
INSERT INTO Evaluate VALUES (20240007,123,'judge_performance');
INSERT INTO Evaluate VALUES (20240008,456,'referee_games');	

--judge_performance is one of officials subclass
CREATE TABLE judge_performance (
	official_id INTEGER PRIMARY KEY,
	judge_id INTEGER NOT NULL,
	judge_retults VARCHAR(50),	
	judge_details VARCHAR(50),

    FOREIGN KEY (official_id) REFERENCES PERSON(pid) ON DELETE CASCADE,
	UNIQUE (judge_id)
);
INSERT INTO judge_performance VALUES (20240007, 123, '-1', 'violation');
INSERT INTO judge_performance VALUES (20240008, 456, '-2', 'over step the boundary');						

--rederee_games is one of officials subclass
CREATE TABLE referee_games (
	official_id INTEGER PRIMARY KEY,
	referee_games_id INTEGER NOT NULL,
	referee_results VARCHAR(50),
	referee_detrails VARCHAR(30),	

    FOREIGN KEY (official_id) REFERENCES PERSON(pid) ON DELETE CASCADE,
	UNIQUE (referee_games_id)
);
INSERT INTO referee_games VALUES (20240007,121,'red_card','violation');
INSERT INTO referee_games VALUES (20240008,131,'yellow_card','over step the boundary');

--awarding_mentals is one of officials subclass
CREATE TABLE awarding_mentals (
	official_id INTEGER PRIMARY KEY,
	awarding_id INTEGER NOT NULL,
	awarding_time TIME NOT NULL,	
	mentals_type VARCHAR(20),
	awarding_venue VARCHAR(30),	

    FOREIGN KEY (official_id) REFERENCES PERSON(pid) ON DELETE CASCADE,
	UNIQUE (awarding_id)
);
INSERT INTO awarding_mentals VALUES (20240007,321,'14:00:00', 'GOLD');
INSERT INTO awarding_mentals VALUES (20240008,654,'13:00:00', 'SILVER');
					
---Journeys table is used for recording persons transformation by vehicles				
CREATE TABLE Journeys (
	booking_id INTEGER PRIMARY KEY,	
	booking_date DATE NOT NULL,	
 	start_time TIME(0) NOT NULL,
	arrival_time TIME (0) NOT NULL,
	start_location INTEGER NOT NULL,
	destination INTEGER NOT NULL,

	FOREIGN KEY (start_location) REFERENCES "Location"(location_id) ON DELETE CASCADE,
	FOREIGN KEY (destination) REFERENCES "Location"(location_id) ON DELETE CASCADE,
	CHECK (start_time BETWEEN '6:00:00' and '22:00:00'),
	CHECK (start_time BETWEEN '6:00:00' and '24:00:00')
);
INSERT INTO Journeys VALUES (111, '2024-10-10', '14:00:00', '18:00:00', 001, 006);
INSERT INTO Journeys VALUES (121, '2024-10-11', '14:00:00', '18:00:00', 005, 002);

-- Vehicles table is information of transfered fleets
CREATE TABLE Vehicles (
	ve_code INTEGER PRIMARY KEY,
	kind varchar(10) NOT NULL,
	capacity INTEGER,
	CHECK (capacity > 0 AND capacity < 23 ),
	CHECK (kind = 'van' OR kind = 'minibus' OR kind = 'bus')
);
INSERT INTO Vehicles VALUES (111, 'van', 4);
INSERT INTO Vehicles VALUES (121, 'bus', 15);
					
-- Scheduled table is used to line vehicles and journeys tables
CREATE TABLE Scheduled (
	booking_id INTEGER,
 	ve_code INTEGER,
	p_name VARCHAR(30),
	PRIMARY KEY (booking_id, ve_code),
	FOREIGN KEY (booking_id) REFERENCES Journeys,
	FOREIGN KEY (ve_code) REFERENCES vehicles
);																			
INSERT INTO Scheduled VALUES (111, 121,'Jane');
INSERT INTO Scheduled VALUES (121, 111, 'Make');
					
--booking table is for connecting persons and journeys table
CREATE TABLE booking(
	booking_id INTEGER NOT NULL,
	person_role VARCHAR(30),
	pid INTEGER NOT NULL,
	PRIMARY KEY (booking_id,pid),

	FOREIGN KEY (booking_id) REFERENCES Journeys,
	FOREIGN KEY (pid) REFERENCES PERSON(pid) ON DELETE CASCADE,
	CHECK (person_role = 'officials' or person_role = 'athlete')
);
INSERT INTO booking VALUES (111, 'officials', 20240007);
INSERT INTO booking VALUES (121, 'athlete', 20240008);			

