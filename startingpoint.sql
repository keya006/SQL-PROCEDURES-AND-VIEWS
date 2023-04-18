

/* This is a standard preamble for most of our scripts.  The intent is to establish
a consistent environment for the database behavior. */
set global transaction isolation level serializable;
set global SQL_MODE = 'ANSI,TRADITIONAL';
set names utf8mb4;
set SQL_SAFE_UPDATES = 0;
set @thisDatabase = 'flight_management';

-- Define the database structures

drop database if exists flight_management;
create database if not exists flight_management;
use flight_management;

create table airline (
	airlineID varchar(50),
    revenue integer default null,
    primary key (airlineID)
) engine = innodb;

insert into airline values
('Delta', 46),
('American', 45),
('United', 40),
('Lufthansa', 31),
('Air_France', 25),
('Southwest', 22),
('JetBlue', 8),
('Spirit', 4);

create table location (
	locationID varchar(50),
    primary key (locationID)
) engine = innodb;

insert into location values
('port_1'),
('port_2'),
('port_3'),
('port_4'),
('port_5'),
('port_9'),
('plane_1'),
('plane_2'),
('plane_4'),
('plane_7'),
('plane_8'),
('plane_9'),
('plane_11'),
('plane_15'),
('port_7'),
('port_10'),
('port_11'),
('port_13'),
('port_14'),
('port_15'),
('port_17'),
('port_18');

create table airplane (
	airlineID varchar(50),
    tail_num varchar(50),
    seat_capacity integer not null check (seat_capacity > 0),
    speed integer not null check (speed > 0),
    locationID varchar(50) default null,
    plane_type varchar(100) default null,
    skids boolean default null,
    propellers integer default null,
    jet_engines integer default null,
    primary key (airlineID, tail_num),
    constraint fk1 foreign key (airlineID) references airline (airlineID),
    constraint fk3 foreign key (locationID) references location (locationID)
) engine = innodb;

insert into airplane values
('Delta', 'n106js', 4, 200, 'plane_1', 'jet', null, null, 2),
('Delta', 'n110jn', 5, 600, 'plane_2', 'jet', null, null, 4),
('Delta', 'n127js', 4, 800, null, null, null, null, null),
('American', 'n330ss', 4, 200, 'plane_4', 'jet', null, null, 2),
('American', 'n380sd', 5, 400, null, 'jet', null, null, 2),
('United', 'n616lt', 7, 400, null, 'jet', null, null, 4),
('United', 'n517ly', 4, 400, 'plane_7', 'jet', null, null, 2),
('United', 'n620la', 4, 200, 'plane_8', 'prop', FALSE, 2, null),
('Southwest', 'n401fj', 4, 200, 'plane_9', 'jet', null, null, 2),
('Southwest', 'n653fk', 6, 400, null, 'jet', null, null, 2),
('Southwest', 'n118fm', 4, 100, 'plane_11', 'prop', TRUE, 1, null),
('Southwest', 'n815pw', 3, 200, null, 'prop', FALSE, 2, null),
('JetBlue', 'n161fk', 4, 200, null, 'jet', null, null, 2),
('JetBlue', 'n337as', 5, 400, null, 'jet', null, null, 2),
('Spirit', 'n256ap', 4, 400, 'plane_15', 'jet', null, null, 2),
('Delta', 'n156sq', 8, 100, null, null, null, null, null),
('United', 'n451fi', 5, 400, null, 'jet', null, null, 4);

create table airport (
	airportID char(3),
    airport_name varchar(200),
    city varchar(100) not null,
    state char(2) not null,
    locationID varchar(50) default null,
    primary key (airportID),
    constraint fk2 foreign key (locationID) references location (locationID)
) engine = innodb;

insert into airport values
('ATL', 'Hartsfield-Jackson Atlanta International Airport', 'Atlanta', 'GA', 'port_1'),
('DFW', 'Dallas-Fort Worth International Airport', 'Dallas', 'TX', 'port_2'),
('DEN', 'Denver International Airport', 'Denver', 'CO', 'port_3'),
('ORD', 'O_Hare International Airport', 'Chicago', 'IL', 'port_4'),
('LAX', 'Los Angeles International Airport', 'Los Angeles', 'CA', 'port_5'),
('LGA', 'LaGuardia Airport', 'New York', 'NY', null),
('JFK', 'John F_Kennedy International Airport', 'New York', 'NY', 'port_15'),
('MDW', 'Chicago Midway International Airport', 'Chicago', 'IL', null),
('DCA', 'Ronald Reagan Washington National Airport', 'Washington', 'DC', 'port_9'),
('IAD', 'Washington Dulles International Airport', 'Washington', 'DC', 'port_11'),
('DAL', 'Dallas Love Field', 'Dallas', 'TX', 'port_7'),
('IAH', 'George Bush Intercontinental Houston Airport', 'Houston', 'TX', 'port_13'),
('HOU', 'William P_Hobby Airport', 'Houston', 'TX', 'port_18'),
('BHM', 'Birmingham-Shuttlesworth International Airport', 'Birmingham', 'AL', null),
('MRI', 'Merrill Field', 'Anchorage', 'AK', null),
('ANC', 'Ted Stevens Anchorage International Airport', 'Anchorage', 'AK', null),
('PHX', 'Phoenix Sky Harbor International Airport', 'Phoenix', 'AZ', null),
('LIT', 'Bill and Hillary Clinton National Airport', 'Little Rock', 'AR', null),
('BDL', 'Bradley International Airport', 'Hartford', 'CT', null),
('ILG', 'Wilmington Airport', 'Wilmington', 'DE', null),
('MCO', 'Orlando International Airport', 'Orlando', 'FL', null),
('HNL', 'Daniel K. Inouye International Airport', 'Honolulu Oahu', 'HI', null),
('BOI', 'Boise Airport', 'Boise', 'ID', null),
('IND', 'Indianapolis International Airport', 'Indianapolis', 'IN', null),
('DSM', 'Des Moines International Airport', 'Des Moines', 'IA', null),
('ICT', 'Wichita Dwight D_Eisenhower National Airport', 'Wichita', 'KS', null),
('SDF', 'Louisville International Airport', 'Louisville', 'KY', null),
('MSY', 'Louis Armstrong New Orleans International Airport', 'New Orleans', 'LA', null),
('PWM', 'Portland International Jetport', 'Portland', 'ME', null),
('BWI', 'Baltimore_Washington International Airport', 'Baltimore', 'MD', null),
('BOS', 'General Edward Lawrence Logan International Airport', 'Boston', 'MA', null),
('DTW', 'Detroit Metro Wayne County Airport', 'Detroit', 'MI', null),
('MSP', 'Minneapolis_St_Paul International Wold_Chamberlain Airport', 'Minneapolis Saint Paul', 'MN', null),
('JAN', 'Jackson_Medgar Wiley Evers International Airport', 'Jackson', 'MS', null),
('STL', 'St_Louis Lambert International Airport', 'Saint Louis', 'MO', null),
('BZN', 'Bozeman Yellowstone International Airport', 'Bozeman', 'MT', null),
('OMA', 'Eppley Airfield', 'Omaha', 'NE', null),
('LAS', 'Harry Reid International Airport', 'Las Vegas', 'NV', null),
('MHT', 'Manchester_Boston Regional Airport', 'Manchester', 'NH', null),
('EWR', 'Newark Liberty International Airport', 'Newark', 'NJ', null),
('ABQ', 'Albuquerque International Sunport', 'Albuquerque', 'NM', null),
('ISP', 'Long Island MacArthur Airport', 'New York Islip', 'NY', 'port_14'),
('CLT', 'Charlotte Douglas International Airport', 'Charlotte', 'NC', null),
('FAR', 'Hector International Airport', 'Fargo', 'ND', null),
('CLE', 'Cleveland Hopkins International Airport', 'Cleveland', 'OH', null),
('OKC', 'Will Rogers World Airport', 'Oklahoma City', 'OK', null),
('PDX', 'Portland International Airport', 'Portland', 'OR', null),
('PHL', 'Philadelphia International Airport', 'Philadelphia', 'PA', null),
('PVD', 'Rhode Island T_F_Green International Airport', 'Providence', 'RI', null),
('CHS', 'Charleston International Airport', 'Charleston', 'SC', null),
('FSD', 'Joe Foss Field', 'Sioux Falls', 'SD', null),
('BNA', 'Nashville International Airport', 'Nashville', 'TN', null),
('SLC', 'Salt Lake City International Airport', 'Salt Lake City', 'UT', null),
('BTV', 'Burlington International Airport', 'Burlington', 'VT', null),
('SEA', 'Seattle-Tacoma International Airport', 'Seattle Tacoma', 'WA', 'port_17'),
('BFI', 'King County International Airport', 'Seattle', 'WA', 'port_10'),
('CRW', 'Yeager Airport', 'Charleston', 'WV', null),
('MKE', 'Milwaukee Mitchell International Airport', 'Milwaukee', 'WI', null),
('JAC', 'Jackson Hole Airport', 'Jackson', 'WY', null),
('GUM', 'Antonio B_Won Pat International Airport', 'Agana Tamuning', 'GU', null),
('GSN', 'Saipan International Airport', 'Obyan Saipan Island', 'MP', null),
('SJU', 'Luis Munoz Marin International Airport', 'San Juan Carolina', 'PR', null),
('STT', 'Cyril E_King Airport', 'Charlotte Amalie Saint Thomas', 'VI', null);

create table person (
	personID varchar(50),
    first_name varchar(100) not null,
    last_name varchar(100) default null,
    locationID varchar(50) not null,
    primary key (personID),
    constraint fk8 foreign key (locationID) references location (locationID)
) engine = innodb;

insert into person values
('p1', 'Jeanne', 'Nelson', 'plane_1'),
('p2', 'Roxanne', 'Byrd', 'plane_1'),
('p3', 'Tanya', 'Nguyen', 'plane_4'),
('p4', 'Kendra', 'Jacobs', 'plane_4'),
('p5', 'Jeff', 'Burton', 'plane_4'),
('p6', 'Randal', 'Parks', 'plane_7'),
('p7', 'Sonya', 'Owens', 'plane_7'),
('p8', 'Bennie', 'Palmer', 'plane_8'),
('p9', 'Marlene', 'Warner', 'plane_8'),
('p10', 'Lawrence', 'Morgan', 'plane_9'),
('p11', 'Sandra', 'Cruz', 'plane_9'),
('p12', 'Dan', 'Ball', 'plane_11'),
('p13', 'Bryant', 'Figueroa', 'plane_2'),
('p14', 'Dana', 'Perry', 'plane_2'),
('p15', 'Matt', 'Hunt', 'plane_2'),
('p16', 'Edna', 'Brown', 'plane_15'),
('p17', 'Ruby', 'Burgess', 'plane_15'),
('p18', 'Esther', 'Pittman', 'port_2'),
('p19', 'Doug', 'Fowler', 'port_4'),
('p20', 'Thomas', 'Olson', 'port_3'),
('p21', 'Mona', 'Harrison', 'port_4'),
('p22', 'Arlene', 'Massey', 'port_2'),
('p23', 'Judith', 'Patrick', 'port_3'),
('p24', 'Reginald', 'Rhodes', 'plane_1'),
('p25', 'Vincent', 'Garcia', 'plane_1'),
('p26', 'Cheryl', 'Moore', 'plane_4'),
('p27', 'Michael', 'Rivera', 'plane_7'),
('p28', 'Luther', 'Matthews', 'plane_8'),
('p29', 'Moses', 'Parks', 'plane_8'),
('p30', 'Ora', 'Steele', 'plane_9'),
('p31', 'Antonio', 'Flores', 'plane_9'),
('p32', 'Glenn', 'Ross', 'plane_11'),
('p33', 'Irma', 'Thomas', 'plane_11'),
('p34', 'Ann', 'Maldonado', 'plane_2'),
('p35', 'Jeffrey', 'Cruz', 'plane_2'),
('p36', 'Sonya', 'Price', 'plane_15'),
('p37', 'Tracy', 'Hale', 'plane_15'),
('p38', 'Albert', 'Simmons', 'port_1'),
('p39', 'Karen', 'Terry', 'port_9'),
('p40', 'Glen', 'Kelley', 'plane_4'),
('p41', 'Brooke', 'Little', 'port_4'),
('p42', 'Daryl', 'Nguyen', 'port_3'),
('p43', 'Judy', 'Willis', 'port_1'),
('p44', 'Marco', 'Klein', 'port_2'),
('p45', 'Angelica', 'Hampton', 'port_5');

create table pilot (
	personID varchar(50),
    taxID varchar(50) not null,
    experience integer default 0,
    flying_airline varchar(50) default null,
    flying_tail varchar(50) default null,
    primary key (personID),
    unique key (taxID),
    constraint fk4 foreign key (personID) references person (personID),
    constraint fk9 foreign key (flying_airline, flying_tail) references airplane (airlineID, tail_num)
) engine = innodb;

insert into pilot values
('p1', '330-12-6907', 31, 'Delta', 'n106js'),
('p2', '842-88-1257', 9, 'Delta', 'n106js'),
('p3', '750-24-7616', 11, 'American', 'n330ss'),
('p4', '776-21-8098', 24, 'American', 'n330ss'),
('p5', '933-93-2165', 27, 'American', 'n330ss'),
('p6', '707-84-4555', 38, 'United', 'n517ly'),
('p7', '450-25-5617', 13, 'United', 'n517ly'),
('p8', '701-38-2179', 12, 'United', 'n620la'),
('p9', '936-44-6941', 13, 'United', 'n620la'),
('p10', '769-60-1266', 15, 'Southwest', 'n401fj'),
('p11', '369-22-9505', 22, 'Southwest', 'n401fj'),
('p12', '680-92-5329', 24, 'Southwest', 'n118fm'),
('p13', '513-40-4168', 24, 'Delta', 'n110jn'),
('p14', '454-71-7847', 13, 'Delta', 'n110jn'),
('p15', '153-47-8101', 30, 'Delta', 'n110jn'),
('p16', '598-47-5172', 28, 'Spirit', 'n256ap'),
('p17', '865-71-6800', 36, 'Spirit', 'n256ap'),
('p18', '250-86-2784', 23, null, null),
('p19', '386-39-7881', 2, null, null),
('p20', '522-44-3098', 28, null, null),
('p21', '621-34-5755', 2, null, null),
('p22', '177-47-9877', 3, null, null),
('p23', '528-64-7912', 12, null, null),
('p24', '803-30-1789', 34, null, null),
('p25', '986-76-1587', 13, null, null),
('p26', '584-77-5105', 20, null, null);

create table pilot_licenses (
	personID varchar(50),
    license varchar(100),
    primary key (personID, license),
    constraint fk5 foreign key (personID) references pilot (personID)
) engine = innodb;

insert into pilot_licenses values
('p1', 'jet'),
('p2', 'jet'),
('p2', 'prop'),
('p3', 'jet'),
('p4', 'jet'),
('p4', 'prop'),
('p5', 'jet'),
('p6', 'jet'),
('p6', 'prop'),
('p7', 'jet'),
('p8', 'prop'),
('p9', 'prop'),
('p9', 'jet'),
('p9', 'testing'),
('p10', 'jet'),
('p11', 'jet'),
('p11', 'prop'),
('p12', 'prop'),
('p13', 'jet'),
('p14', 'jet'),
('p15', 'jet'),
('p15', 'prop'),
('p15', 'testing'),
('p16', 'jet'),
('p17', 'jet'),
('p17', 'prop'),
('p18', 'jet'),
('p19', 'jet'),
('p20', 'jet'),
('p21', 'jet'),
('p21', 'prop'),
('p22', 'jet'),
('p23', 'jet'),
('p24', 'jet'),
('p24', 'prop'),
('p24', 'testing'),
('p25', 'jet'),
('p26', 'jet');

create table passenger (
	personID varchar(50),
    miles integer default 0,
    primary key (personID),
    constraint fk6 foreign key (personID) references person (personID)
) engine = innodb;

insert into passenger values
('p21', 771),
('p22', 374),
('p23', 414),
('p24', 292),
('p25', 390),
('p26', 302),
('p27', 470),
('p28', 208),
('p29', 292),
('p30', 686),
('p31', 547),
('p32', 257),
('p33', 564),
('p34', 211),
('p35', 233),
('p36', 293),
('p37', 552),
('p38', 812),
('p39', 541),
('p40', 441),
('p41', 875),
('p42', 691),
('p43', 572),
('p44', 572),
('p45', 663);

create table leg (
	legID varchar(50),
    distance integer not null,
    departure char(3) not null,
    arrival char(3) not null,
    primary key (legID),
    constraint fk10 foreign key (departure) references airport (airportID),
    constraint fk11 foreign key (arrival) references airport (airportID)
) engine = innodb;

insert into leg values
('leg_1', 600, 'ATL', 'IAD'),
('leg_2', 600, 'ATL', 'IAH'),
('leg_3', 800, 'ATL', 'JFK'),
('leg_4', 600, 'ATL', 'ORD'),
('leg_5', 1000, 'BFI', 'LAX'),
('leg_6', 200, 'DAL', 'HOU'),
('leg_7', 600, 'DCA', 'ATL'),
('leg_8', 200, 'DCA', 'JFK'),
('leg_9', 800, 'DFW', 'ATL'),
('leg_10', 800, 'DFW', 'ORD'),
('leg_11', 600, 'IAD', 'ORD'),
('leg_12', 200, 'IAH', 'DAL'),
('leg_13', 1400, 'IAH', 'LAX'),
('leg_14', 2400, 'ISP', 'BFI'),
('leg_15', 800, 'JFK', 'ATL'),
('leg_16', 800, 'JFK', 'ORD'),
('leg_17', 2400, 'JFK', 'SEA'),
('leg_18', 1200, 'LAX', 'DFW'),
('leg_19', 1000, 'LAX', 'SEA'),
('leg_20', 600, 'ORD', 'DCA'),
('leg_21', 800, 'ORD', 'DFW'),
('leg_22', 800, 'ORD', 'LAX'),
('leg_23', 2400, 'SEA', 'JFK'),
('leg_24', 1800, 'SEA', 'ORD'),
('leg_25', 600, 'ORD', 'ATL'),
('leg_26', 800, 'LAX', 'ORD'),
('leg_27', 1600, 'ATL', 'LAX');

create table route (
	routeID varchar(50),
    primary key (routeID)
) engine = innodb;

insert into route values
('eastbound_north_milk_run'),
('westbound_north_milk_run'),
('eastbound_south_milk_run'),
('eastbound_north_nonstop'),
('westbound_north_nonstop'),
('northbound_west_coast'),
('northbound_east_coast'),
('southbound_midwest'),
('circle_west_coast'),
('circle_east_coast'),
('hub_xchg_southeast'),
('hub_xchg_southwest'),
('westbound_south_nonstop'),
('local_texas');

create table route_path (
	routeID varchar(50),
    legID varchar(50),
    sequence integer check (sequence > 0),
    primary key (routeID, legID, sequence),
    constraint fk12 foreign key (routeID) references route (routeID),
    constraint fk13 foreign key (legID) references leg (legID)
) engine = innodb;

insert into route_path values
('eastbound_north_milk_run', 'leg_24', 1),
('eastbound_north_milk_run', 'leg_20', 2),
('eastbound_north_milk_run', 'leg_8', 3),
('westbound_north_milk_run', 'leg_16', 1),
('westbound_north_milk_run', 'leg_22', 2),
('westbound_north_milk_run', 'leg_19', 3),
('eastbound_south_milk_run', 'leg_18', 1),
('eastbound_south_milk_run', 'leg_9', 2),
('eastbound_south_milk_run', 'leg_1', 3),
('eastbound_north_nonstop', 'leg_23', 1),
('westbound_north_nonstop', 'leg_17', 1),
('northbound_west_coast', 'leg_19', 1),
('northbound_east_coast', 'leg_3', 1),
('southbound_midwest', 'leg_21', 1),
('circle_west_coast', 'leg_18', 1),
('circle_west_coast', 'leg_10', 2),
('circle_west_coast', 'leg_22', 3),
('circle_east_coast', 'leg_4', 1),
('circle_east_coast', 'leg_20', 2),
('circle_east_coast', 'leg_7', 3),
('hub_xchg_southeast', 'leg_25', 1),
('hub_xchg_southeast', 'leg_4', 2),
('hub_xchg_southwest', 'leg_22', 1),
('hub_xchg_southwest', 'leg_26', 2),
('westbound_south_nonstop', 'leg_27', 1),
('local_texas', 'leg_12', 1),
('local_texas', 'leg_6', 2);

create table flight (
	flightID varchar(50),
    routeID varchar(50) not null,
    support_airline varchar(50) default null,
    support_tail varchar(50) default null,
    progress integer default null,
    airplane_status varchar(100) default null,
    next_time time default null,
	primary key (flightID),
    constraint fk14 foreign key (routeID) references route (routeID) on update cascade,
    constraint fk15 foreign key (support_airline, support_tail) references airplane (airlineID, tail_num)
		on update cascade on delete cascade
) engine = innodb;

insert into flight values
('DL_1174', 'northbound_east_coast', 'Delta', 'n106js', 0, 'on_ground', '08:00:00'),
('AM_1523', 'circle_west_coast', 'American', 'n330ss', 2, 'on_ground', '14:30:00'),
('UN_1899', 'eastbound_north_milk_run', 'United', 'n517ly', 0, 'on_ground', '09:30:00'),
('UN_523', 'hub_xchg_southeast', 'United', 'n620la', 1, 'in_flight', '11:00:00'),
('SW_1776', 'hub_xchg_southwest', 'Southwest', 'n401fj', 2, 'in_flight', '14:00:00'),
('SW_610', 'local_texas', 'Southwest', 'n118fm', 2, 'in_flight', '11:30:00'),
('DL_1243', 'westbound_north_nonstop', 'Delta', 'n110jn', 0, 'on_ground', '09:30:00'),
('SP_1880', 'circle_east_coast', 'Spirit', 'n256ap', 2, 'in_flight', '15:00:00'),
('DL_3410', 'circle_east_coast', null, null, null, null, null),
('UN_717', 'circle_west_coast', null, null, null, null, null);

create table ticket (
	ticketID varchar(50),
    cost integer default null,
    carrier varchar(50) not null,
    customer varchar(50) not null,
    deplane_at char(3) not null,
    primary key (ticketID),
    constraint fk16 foreign key (carrier) references flight (flightID)
		on update cascade on delete cascade,
    constraint fk17 foreign key (customer) references person (personID),
    constraint fk18 foreign key (deplane_at) references airport (airportID) on update cascade
) engine = innodb;

insert into ticket values
('tkt_dl_1', 450, 'DL_1174', 'p24', 'JFK'),
('tkt_dl_2', 225, 'DL_1174', 'p25', 'JFK'),
('tkt_am_3', 250, 'AM_1523', 'p26', 'LAX'),
('tkt_un_4', 175, 'UN_1899', 'p27', 'DCA'),
('tkt_un_5', 225, 'UN_523', 'p28', 'ATL'),
('tkt_un_6', 100, 'UN_523', 'p29', 'ORD'),
('tkt_sw_7', 400, 'SW_1776', 'p30', 'ORD'),
('tkt_sw_8', 175, 'SW_1776', 'p31', 'ORD'),
('tkt_sw_9', 125, 'SW_610', 'p32', 'HOU'),
('tkt_sw_10', 425, 'SW_610', 'p33', 'HOU'),
('tkt_dl_11', 500, 'DL_1243', 'p34', 'LAX'),
('tkt_dl_12', 250, 'DL_1243', 'p35', 'LAX'),
('tkt_sp_13', 225, 'SP_1880', 'p36', 'ATL'),
('tkt_sp_14', 150, 'SP_1880', 'p37', 'DCA'),
('tkt_un_15', 150, 'UN_523', 'p38', 'ORD'),
('tkt_sp_16', 475, 'SP_1880', 'p39', 'ATL'),
('tkt_am_17', 375, 'AM_1523', 'p40', 'ORD'),
('tkt_am_18', 275, 'AM_1523', 'p41', 'LAX');

create table ticket_seats (
	ticketID varchar(50),
    seat_number varchar(50),
    primary key (ticketID, seat_number),
    constraint fk7 foreign key (ticketID) references ticket (ticketID)
		on update cascade on delete cascade
) engine = innodb;

insert into ticket_seats values
('tkt_dl_1', '1C'),
('tkt_dl_1', '2F'),
('tkt_dl_2', '2D'),
('tkt_am_3', '3B'),
('tkt_un_4', '2B'),
('tkt_un_5', '1A'),
('tkt_un_6', '3B'),
('tkt_sw_7', '3C'),
('tkt_sw_8', '3E'),
('tkt_sw_9', '1C'),
('tkt_sw_10', '1D'),
('tkt_dl_11', '1E'),
('tkt_dl_11', '1B'),
('tkt_dl_11', '2F'),
('tkt_dl_12', '2A'),
('tkt_sp_13', '1A'),
('tkt_am_17', '2B'),
('tkt_am_18', '2A');
