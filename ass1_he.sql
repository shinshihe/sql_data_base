-- Assignment 1 Stage 2
-- Schema for the et.org events/ticketing site
--
-- Written by <<YOUR NAME GOES HERE>>
--
-- Conventions:
-- - all entity table names are plural
-- - most entities have an artifical primary key called "id"
-- - foreign keys are named after the relationship they represent

-- Generally useful domains

create domain URLValue as
	varchar(100) check (value like 'http://%');

create domain EmailValue as
	varchar(100) check (value like '%@%.%');

create domain GenderValue as
	char(1) check (value in ('m','f','n'));

create domain ColourValue as
	char(7) check (value ~ '#[0-9A-Fa-f]{6}');

create domain LocationValue as varchar(40)
	check (value ~ E'^-?\\d+\.\\d+,-?\\d+\.\\d+$');
	-- latitiude and longitude in format used by Google Maps
	-- e.g. '-33.916369,151.23024' (UNSW)

create domain NameValue as varchar(50);

create domain LongNameValue as varchar(100);


-- PLACES: addresses, geographic locations, etc.

create table Places (
	id_place          serial, -- integer default nextval('some_seq_or_other')

	biliaddress	 text NOT NULL,
	homeaddress	 text NOT NULL,
	primary key (id_place)
);


-- PAGEs: settings for pages in et.org

create table PageColours (
	pagecolor_id          serial,
	name NameValue,
	maintext text,
	heading text,
	headtext text,
	borders text,
	boxes text,
	links URLValue,
	background text,
	isTemplate text,

	primary key (pagecolor_id)
);


-- PEOPLE: information about various kinds of people
-- Users are People who can login to the system
-- Contacts are people about whom we have minimal info
-- Organisers are "entities" who organise Events

create table People (
	id          serial,
	email EmailValue,
	givenName NameValue,
	familyName NameValue,
	primary key (id)
);

create table Person (
	person_id 	serial,
	email EmailValue not Null,
	givenName NameValue,
	familyName NameValue,
	primary key (person_id)
);

create table Users (
	/*user_id int PRIMARY key REFERENCES People(id)*/
	user_id int PRIMARY key REFERENCES Person(person_id),
	gender GenderValue,
	birthday varchar(20),
	phone int,
	blog URLValue,
	website URLValue,
	password varchar(20),
	showName LongNameValue
);

create table Organisers (
	organiser_id serial,
	name NameValue,
	logo text,
	about text,
	foreign key (user)references users(user_id),
	foreign key (pagecolor) references (pagecolor_id)
);

create table ContactLists (
	contactlist_id serial,
	name NameValue,
	FOREIGN key (users) REFERENCES Users(user_id)
);

create table P_memberof_c(
	member_id int PRIMARY key REFERENCES contactlists(contactlist_id),
	nickName  NameValue,
	FOREIGN key(person) REFERENCES person(person_id)

);


create table Invited_to(
	person_id int primary key references Person(person_id),
	event_id int primary key references Event(event_id)
);


create table Attented(
	person_id int primary key references Person(person_id),
	event_id int primary key references Event(event_id)
);


-- EVENTS: things that happen and which people attend via tickets

create table EventInfo (
	id          serial,
	...
	primary key (id)
);

create table Events (
	id          serial,
	...
	primary key (id)
);

create domain EventRepetitionType as varchar(10)
	check (value in ('daily','weekly','monthly-by-day','monthly-by-date'));

create domain DayOfWeekType as char(3)
	check (value in ('mon','tue','wed','thu','fri','sat','sun'));

create table RepeatingEvents (
	id          serial,
	...
	primary key (id)
);


-- TICKETS: things that let you attend an event

create table TicketTypes (
	id          serial,
	...
	primary key (id)
);
